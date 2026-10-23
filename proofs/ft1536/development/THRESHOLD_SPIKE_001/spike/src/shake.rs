//! Y1 — prawdziwy SHAKE256 (FIPS 202) **na udziałach** Shamir GF(256).
//!
//! Zastępuje stand-in `xof_squeeze_blocks` tam, gdzie kontrakt wymaga
//! realnego XOF-a (`SECURITY_POSITION.md` wymóg 1).
//!
//! Model bitowy: każdy bit stanu Keccaka jest sekretem w {0,1} w GF(256),
//! podzielonym Shamirem. Wtedy:
//! - XOR bitów = dodawanie w GF(256) (liniowe, bez muls),
//! - AND bitów = `mul_shamir_reshare` (gf_mul na 0/1),
//! - NOT b = b ⊕ 1 (każda strona ⊕ 1 w swoim udziale).
//!
//! `chi`: `out = a ⊕ ((¬b) ∧ c) = a ⊕ c ⊕ (b ∧ c)` — 1 mul na bit.
//! Koszt: 1600 AND/rundę × 24 = **38 400** `mul_shamir_reshare` / Keccak-f
//! (zgodność rządu z `I3_SHAKE_MPC_COST.md`).
//!
//! Wierność: `shake256_shares` po rekonstrukcji == `shake256_clear`
//! (FIPS 202, bit-exact). Tor **nie otwiera** stanu pośredniego.

use crate::mul::mul_shamir_reshare;
use crate::xof::shake256_clear;
use crate::{validate_xs, Result, SpikeError};

// ─── Geometria Keccak-f[1600] ───────────────────────────────────────────

/// Bity stanu (25 × 64).
pub const KECCAK_BITS: usize = 1600;
/// Rundy Keccak-f[1600].
pub const KECCAK_ROUNDS: usize = 24;
/// SHAKE256 rate = 1088 b = 136 B (FIPS 202).
pub const SHAKE256_RATE: usize = 136;

/// Indeks bitu (x, y, z): lane (x + 5*y), bit z w lane (LE).
#[inline]
pub fn bit_index(x: usize, y: usize, z: usize) -> usize {
    z + 64 * (x + 5 * y)
}

/// Rotacje ρ per lane (x + 5*y) — tabela FIPS 202.
const RHO: [u32; 25] = [
    0, 1, 62, 28, 27, // y=0, x=0..4
    36, 44, 6, 55, 20, // y=1
    3, 10, 43, 25, 39, // y=2
    41, 45, 15, 21, 8, // y=3
    18, 2, 61, 56, 14, // y=4
];

/// Stałe rundowe RC[r] (64 bity, LE w lane A[0,0]) — FIPS 202.
const RC: [u64; KECCAK_ROUNDS] = [
    0x0000_0000_0000_0001,
    0x0000_0000_0000_8082,
    0x8000_0000_0000_808A,
    0x8000_0000_8000_8000,
    0x0000_0000_0000_808B,
    0x0000_0000_8000_0001,
    0x8000_0000_8000_8081,
    0x8000_0000_0000_8009,
    0x0000_0000_0000_008A,
    0x0000_0000_0000_0088,
    0x0000_0000_8000_8009,
    0x0000_0000_8000_000A,
    0x0000_0000_8000_808B,
    0x8000_0000_0000_008B,
    0x8000_0000_0000_8089,
    0x8000_0000_0000_8003,
    0x8000_0000_0000_8002,
    0x8000_0000_0000_0080,
    0x0000_0000_0000_800A,
    0x8000_0000_8000_000A,
    0x8000_0000_8000_8081,
    0x8000_0000_0000_8080,
    0x0000_0000_8000_0001,
    0x8000_0000_8000_8008,
];

// ─── Stan na udziałach ──────────────────────────────────────────────────

/// Stan Keccaka: 1600 bitów, każdy = wektor udziałów (1 na stronę).
/// Udział jest elementem GF(256); sekret bitu ∈ {0,1}.
pub type BitShares = Vec<u8>;

/// Pełny stan 1600 bitów w udziałach.
pub struct KeccakShares {
    bits: Vec<BitShares>,
}

impl KeccakShares {
    /// Stan zerowy: każdy bit = sekret 0 (udziały zera = same zera).
    pub fn zero(n: usize) -> Self {
        Self {
            bits: vec![vec![0u8; n]; KECCAK_BITS],
        }
    }

    pub fn n(&self) -> usize {
        self.bits.first().map(|b| b.len()).unwrap_or(0)
    }

    /// Udział bitu (x,y,z) — wiersz stron.
    pub fn bit(&self, x: usize, y: usize, z: usize) -> &BitShares {
        &self.bits[bit_index(x, y, z)]
    }

    /// Jawny bit publiczny w stan (liniowo: każda strona ⊕ pub).
    fn xor_public_bit(&mut self, idx: usize, pub_bit: u8) {
        if pub_bit == 0 {
            return;
        }
        for s in &mut self.bits[idx] {
            *s ^= 1;
        }
    }

    /// Rekonstrukcja bitów do jawnych 0/1 (oracle testowy / pin).
    /// `xs` = punkty, `k` = próg. **Moment** — nie w torze produkcyjnym.
    pub fn reconstruct_bits(&self, xs: &[u8], k: u8) -> Result<Vec<u8>> {
        let n = self.n();
        if n == 0 || xs.len() != n {
            return Err(SpikeError::PartyCountMismatch);
        }
        let mut out = Vec::with_capacity(KECCAK_BITS);
        for bit in &self.bits {
            out.push(reconstruct_bit(xs, bit, k)?);
        }
        Ok(out)
    }
}

/// Rekonstrukcja jednego bitu (sekret ∈ {0,1}) — Lagrange w 0 na **pierwszych
/// k** punktach (spójne λ). Nie mylić z `lagrange_at_zero(xs, i)` liczącym λ
/// po **wszystkich** xs (to inny zbiór punktów — retained RF).
fn reconstruct_bit(xs: &[u8], shares: &[u8], k: u8) -> Result<u8> {
    use crate::gf_mul;
    use crate::mul::lagrange_at_zero;
    let t = k as usize;
    if shares.len() != xs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    if t > shares.len() || t < 1 {
        return Err(SpikeError::NotEnoughPoints);
    }
    let xs_k = &xs[..t];
    let mut acc = 0u8;
    for i in 0..t {
        let lam = lagrange_at_zero(xs_k, i)?;
        acc ^= gf_mul(lam, shares[i]);
    }
    Ok(acc)
}

// ─── Pomocnicze na bitach (liniowe / mul) ───────────────────────────────

fn xor_into(dst: &mut BitShares, src: &BitShares) {
    for (d, s) in dst.iter_mut().zip(src.iter()) {
        *d ^= *s;
    }
}

/// AND bitów w udziałach: `mul_shamir_reshare` (gf_mul 0/1 = ∧).
fn and_bits(
    rng: &mut impl rand::RngCore,
    xs: &[u8],
    k: u8,
    a: &BitShares,
    b: &BitShares,
) -> Result<BitShares> {
    if a.len() != b.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    mul_shamir_reshare(rng, xs, k, a, b)
}

// ─── Keccak-f[1600] na udziałach ────────────────────────────────────────

/// Jedna permutacja Keccak-f[1600] na udziałach (24 rundy).
///
/// θ, ρ, π, ι — liniowe (XOR / permutacja bitów / stałe publiczne).
/// χ — 1600 `mul_shamir_reshare` na rundę (jedyne mnożenie).
///
/// Koszt: 24 × 1600 = **38 400** reshare-muls (I3).
pub fn keccak_f1600_shares(
    rng: &mut impl rand::RngCore,
    state: &mut KeccakShares,
    xs: &[u8],
    k: u8,
) -> Result<()> {
    validate_xs(xs, k)?;
    let n = xs.len();
    if state.n() != n {
        return Err(SpikeError::PartyCountMismatch);
    }

    for round in 0..KECCAK_ROUNDS {
        // θ: C[x][z] = ⊕_y A[x,y][z]; D[x][z] = C[x-1][z] ⊕ ROT(C[x+1],1)[z]
        let mut c_z: Vec<Vec<BitShares>> = vec![vec![vec![0u8; n]; 64]; 5];
        for x in 0..5 {
            for z in 0..64 {
                let mut acc = vec![0u8; n];
                for y in 0..5 {
                    xor_into(&mut acc, state.bit(x, y, z));
                }
                c_z[x][z] = acc;
            }
        }

        // D[x][z] = C[x-1][z] ⊕ C[x+1][z-1]
        let mut d_z: Vec<Vec<BitShares>> = vec![vec![vec![0u8; n]; 64]; 5];
        for x in 0..5 {
            let xl = (x + 4) % 5;
            let xr = (x + 1) % 5;
            for z in 0..64 {
                let mut acc = c_z[xl][z].clone();
                let zr = (z + 63) % 64; // ROT(...,1): bit z bierze z-1
                xor_into(&mut acc, &c_z[xr][zr]);
                d_z[x][z] = acc;
            }
        }

        for x in 0..5 {
            for y in 0..5 {
                for z in 0..64 {
                    let d = &d_z[x][z];
                    // A[x,y,z] ⊕= D[x][z]
                    let bit = &mut state.bits[bit_index(x, y, z)];
                    for (s, dd) in bit.iter_mut().zip(d.iter()) {
                        *s ^= *dd;
                    }
                }
            }
        }

        // ρ+π: B[y, 2x+3y] = ROT(A[x,y], r[x,y])
        let mut b: Vec<BitShares> = vec![vec![0u8; n]; KECCAK_BITS];
        for x in 0..5 {
            for y in 0..5 {
                let r = RHO[x + 5 * y] as usize;
                for z in 0..64 {
                    let src = state.bit(x, y, z).clone();
                    let z2 = (z + r) % 64;
                    let nx = y;
                    let ny = (2 * x + 3 * y) % 5;
                    b[bit_index(nx, ny, z2)] = src;
                }
            }
        }

        // χ: A[x,y,z] = B[x,y,z] ⊕ (B[x+1,y,z] ∧ B[x+2,y,z]) ⊕ B[x+2,y,z]
        //     (bo ¬b ∧ c = c ⊕ (b∧c); out = a ⊕ c ⊕ (b∧c))
        for x in 0..5 {
            for y in 0..5 {
                for z in 0..64 {
                    let a = b[bit_index(x, y, z)].clone();
                    let bb = b[bit_index((x + 1) % 5, y, z)].clone();
                    let cc = b[bit_index((x + 2) % 5, y, z)].clone();
                    let bc = and_bits(rng, xs, k, &bb, &cc)?;
                    let mut out = a;
                    xor_into(&mut out, &cc);
                    xor_into(&mut out, &bc);
                    state.bits[bit_index(x, y, z)] = out;
                }
            }
        }

        // ι: A[0,0] ⊕= RC[round]
        let rc = RC[round];
        for z in 0..64 {
            let bit = (rc >> z) & 1;
            state.xor_public_bit(bit_index(0, 0, z), bit as u8);
        }
    }
    Ok(())
}

// ─── SHAKE256 na udziałach ──────────────────────────────────────────────

/// Padding FIPS 202 dla SHAKE256 w **ostatnim** bloku rate.
/// `rem` = liczba bajtów wiadomości w tym bloku (0..RATE; 0 = blok samego padu).
/// **Single source of truth padu** (V-Y1-2): tor i testy wołają tę funkcję.
/// Domena `0x1F` w `rem`, `0x80` w ostatnim bajcie rate (`pad10*1`).
fn shake256_pad_block(rem: usize) -> Result<Vec<u8>> {
    if rem >= SHAKE256_RATE {
        return Err(SpikeError::MessageTooLong);
    }
    let mut block = vec![0u8; SHAKE256_RATE];
    block[rem] = 0x1F;
    block[SHAKE256_RATE - 1] |= 0x80;
    Ok(block)
}

/// Jawny pad z wiadomością (testy). Na `shake256_pad_block` — bez duplikacji.
#[cfg(test)]
fn shake256_pad(input: &[u8]) -> Result<Vec<u8>> {
    let mut block = shake256_pad_block(input.len())?;
    block[..input.len()].copy_from_slice(input);
    Ok(block)
}

/// Jawne bajty → bity LSb-first (oracle).
fn bytes_to_bits_clear(bytes: &[u8]) -> Vec<u8> {
    let mut bits = Vec::with_capacity(bytes.len() * 8);
    for &b in bytes {
        for i in 0..8 {
            bits.push((b >> i) & 1);
        }
    }
    bits
}

/// Jawny odczyt bajtów z bitów (oracle testowy).
#[cfg(test)]
fn bits_to_bytes_clear(bits: &[u8]) -> Vec<u8> {
    let nbytes = bits.len() / 8;
    let mut out = vec![0u8; nbytes];
    for (bi, &b) in bits.iter().enumerate().take(nbytes * 8) {
        out[bi / 8] |= b << (bi % 8);
    }
    out
}

/// Dealer (model testowy!): wiadomość jawna → **udziały bitów** (LSb-first).
/// Każdy bit jest osobnym sekretem {0,1} — **nie** dekomponujemy bitów
/// z udziałów bajtu (to nie działa w Shamirze).
pub fn split_msg_to_bit_shares(
    rng: &mut impl rand::RngCore,
    msg: &[u8],
    xs: &[u8],
    k: u8,
) -> Result<Vec<BitShares>> {
    let n = xs.len();
    validate_xs(xs, k)?;
    let clear_bits = bytes_to_bits_clear(msg);
    let mut out = Vec::with_capacity(clear_bits.len());
    for &bit in &clear_bits {
        let shares = crate::shamir_share(rng, bit, xs, k)?;
        let mut row = Vec::with_capacity(n);
        for s in shares {
            row.push(s.share);
        }
        out.push(row);
    }
    Ok(out)
}

/// Otwarcie bitów („moment" testowy) → jawne 0/1. Wymaga ≥k udziałów.
pub fn open_bit_shares(bits: &[BitShares], xs: &[u8], k: u8) -> Result<Vec<u8>> {
    let n = xs.len();
    let mut clear = Vec::with_capacity(bits.len());
    for row in bits {
        if row.len() != n {
            return Err(SpikeError::PartyCountMismatch);
        }
        clear.push(reconstruct_bit(xs, row, k)?);
    }
    Ok(clear)
}

/// SHAKE256 na udziałach: absorb `input_bits` (bity wiadomości w udziałach,
/// LSb-first per bajt), squeeze `out_len` bajtów jako **udziały bitów**
/// (`out_len * 8` wierszy).
///
/// **Multi-block (Y2):** wiadomość ≥ rate = kolejne bloki 136 B; pad FIPS
/// tylko w ostatnim (`shake256_pad_block(rem)`); `rem=0` = dodatkowy blok
/// samego padu. Tor **nie otwiera** wejścia ani stanu.
///
/// Fail-closed: `in_bits_len % 8 != 0`, zła liczba stron.
pub fn shake256_shares(
    rng: &mut impl rand::RngCore,
    input_bits: &[BitShares],
    out_len: usize,
    xs: &[u8],
    k: u8,
) -> Result<Vec<BitShares>> {
    validate_xs(xs, k)?;
    let n = xs.len();
    for row in input_bits {
        if row.len() != n {
            return Err(SpikeError::PartyCountMismatch);
        }
    }

    let in_bits_len = input_bits.len();
    if in_bits_len % 8 != 0 {
        return Err(SpikeError::PartyCountMismatch);
    }
    let in_len = in_bits_len / 8;
    let n_full = in_len / SHAKE256_RATE;
    let rem = in_len % SHAKE256_RATE;

    let mut state = KeccakShares::zero(n);

    // Pomoc: XOR bloku (rate*8 bitów) do stanu.
    let absorb_block = |state: &mut KeccakShares, block_bits: &[BitShares]| {
        for i in 0..SHAKE256_RATE * 8 {
            xor_into(&mut state.bits[i], &block_bits[i]);
        }
    };

    // Pełne bloki wiadomości (bez padu) — każdy: absorb + permutacja.
    for b in 0..n_full {
        let mut block_bits: Vec<BitShares> = vec![vec![0u8; n]; SHAKE256_RATE * 8];
        for i in 0..SHAKE256_RATE * 8 {
            block_bits[i] = input_bits[b * SHAKE256_RATE * 8 + i].clone();
        }
        absorb_block(&mut state, &block_bits);
        keccak_f1600_shares(rng, &mut state, xs, k)?;
    }

    // Ostatni blok: `rem` bajtów wiadomości + pad (rem=0 → sam pad).
    {
        let mut block_bits: Vec<BitShares> = vec![vec![0u8; n]; SHAKE256_RATE * 8];
        for i in 0..rem * 8 {
            block_bits[i] = input_bits[n_full * SHAKE256_RATE * 8 + i].clone();
        }
        let pad = shake256_pad_block(rem)?;
        for (bi, &pb) in pad.iter().enumerate() {
            if pb == 0 {
                continue;
            }
            for bit in 0..8 {
                if (pb >> bit) & 1 == 1 {
                    for s in &mut block_bits[bi * 8 + bit] {
                        *s ^= 1;
                    }
                }
            }
        }
        absorb_block(&mut state, &block_bits);
        keccak_f1600_shares(rng, &mut state, xs, k)?;
    }

    // Squeeze (stan już po permutacji ostatniego bloku).
    let out_bits_len = out_len * 8;
    let mut out_bits: Vec<BitShares> = Vec::with_capacity(out_bits_len);
    let mut produced = 0usize;
    let mut first = true;
    loop {
        if !first {
            keccak_f1600_shares(rng, &mut state, xs, k)?;
        }
        first = false;
        let take = core::cmp::min(SHAKE256_RATE * 8, out_bits_len - produced);
        for i in 0..take {
            out_bits.push(state.bits[i].clone());
        }
        produced += take;
        if produced >= out_bits_len {
            break;
        }
    }
    Ok(out_bits)
}

/// Oracle lokalny: jawny SHAKE256 po rekonstrukcji wejścia (testy/piny).
/// Nie jest to tor — „moment" jak `g_frag_local`.
pub fn shake256_shares_local_oracle(input: &[u8], out_len: usize) -> Vec<u8> {
    shake256_clear(input, out_len)
}

// ─── Y3 — wyprowadzanie klucza przez prawdziwy SHAKE256 ─────────────────

/// Domena wyprowadzenia materiału klucza (separacja kontekstu).
pub const KEY_DERIVE_DOMAIN: &[u8] = b"NEXUM-KEY-SHAKE-v1";

/// Dealer (model testowy!): 32-bajtowy seed → udziały **bitów** (LSb-first).
pub fn split_seed_to_bit_shares(
    rng: &mut impl rand::RngCore,
    seed: &[u8],
    xs: &[u8],
    k: u8,
) -> Result<Vec<BitShares>> {
    split_msg_to_bit_shares(rng, seed, xs, k)
}

/// Jawny bit publiczny jako Shamir (wielomian stały = udział b).
fn public_bit_shares(b: u8, n: usize) -> BitShares {
    vec![b; n]
}

/// Y3 — `derive_key_material` przez **prawdziwy SHAKE256** na udziałach.
///
/// `seed_bits` = 32 B seeda w bitach (256 wierszy; `split_seed_to_bit_shares`).
/// Tor: absorb `KEY_DERIVE_DOMAIN || seed`, squeeze [`crate::DERIVED_LEN`] B
/// jako bit-udziały. **Bez** stand-in `xof_squeeze_blocks` i bez otwarcia.
///
/// Oracle: [`derive_key_material_shake_local`] == `shake256_clear(domain||seed)`.
pub fn derive_key_material_shake(
    rng: &mut impl rand::RngCore,
    seed_bits: &[BitShares],
    out_len: usize,
    xs: &[u8],
    k: u8,
) -> Result<Vec<BitShares>> {
    validate_xs(xs, k)?;
    let n = xs.len();
    if seed_bits.len() != 32 * 8 {
        return Err(SpikeError::PartyCountMismatch);
    }
    for row in seed_bits {
        if row.len() != n {
            return Err(SpikeError::PartyCountMismatch);
        }
    }

    // Domena publiczna → stałe udziały; potem bity seeda.
    let mut input_bits: Vec<BitShares> = Vec::with_capacity(KEY_DERIVE_DOMAIN.len() * 8 + 256);
    for &byte in KEY_DERIVE_DOMAIN {
        for bit in 0..8 {
            input_bits.push(public_bit_shares((byte >> bit) & 1, n));
        }
    }
    input_bits.extend(seed_bits.iter().cloned());

    shake256_shares(rng, &input_bits, out_len, xs, k)
}

/// Oracle lokalny Y3 („moment"): `SHAKE256(domain || seed)` w czystości.
pub fn derive_key_material_shake_local(seed: &[u8], out_len: usize) -> Vec<u8> {
    let mut input = Vec::with_capacity(KEY_DERIVE_DOMAIN.len() + seed.len());
    input.extend_from_slice(KEY_DERIVE_DOMAIN);
    input.extend_from_slice(seed);
    shake256_clear(&input, out_len)
}

// ─── Testy ──────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests_y1_shake {
    use super::*;
    use crate::cost;
    use rand::SeedableRng;

    const XS: [u8; 3] = [1, 2, 3];
    const K: u8 = 2;

    /// Oracle: otwórz bity wyjścia i spakuj do bajtów.
    fn open_out_to_bytes(out_bits: &[BitShares]) -> Vec<u8> {
        let clear = open_bit_shares(out_bits, &XS, K).unwrap();
        bits_to_bytes_clear(&clear)
    }

    #[test]
    fn y1_keccak_pad_empty_is_fips() {
        let pad = shake256_pad(b"").unwrap();
        assert_eq!(pad.len(), 136);
        assert_eq!(pad[0], 0x1F);
        assert_eq!(pad[135], 0x80);
        assert!(pad[1..135].iter().all(|&b| b == 0));
    }

    #[test]
    fn y1_shake256_empty_matches_fips_clear() {
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x51_0001);
        let in_bits = split_msg_to_bit_shares(&mut rng, b"", &XS, K).unwrap();
        assert!(in_bits.is_empty());
        let out = shake256_shares(&mut rng, &in_bits, 32, &XS, K).unwrap();
        assert_eq!(out.len(), 32 * 8);
        let opened = open_out_to_bytes(&out);
        let expect = shake256_clear(b"", 32);
        assert_eq!(opened, expect, "SHAKE256('') bit-exact vs FIPS/clear");
    }

    #[test]
    fn y1_shake256_abc_matches_fips_clear() {
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x51_0002);
        let in_bits = split_msg_to_bit_shares(&mut rng, b"abc", &XS, K).unwrap();
        let out = shake256_shares(&mut rng, &in_bits, 32, &XS, K).unwrap();
        let opened = open_out_to_bytes(&out);
        let expect = shake256_clear(b"abc", 32);
        assert_eq!(opened, expect, "SHAKE256('abc') bit-exact");
    }

    #[test]
    fn y1_shake256_64bytes_out_matches() {
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x51_0003);
        let msg = b"nexum-threshold-y1-shake256-real-on-shares!!";
        let in_bits = split_msg_to_bit_shares(&mut rng, msg, &XS, K).unwrap();
        let out = shake256_shares(&mut rng, &in_bits, 64, &XS, K).unwrap();
        assert_eq!(out.len(), 64 * 8);
        let opened = open_out_to_bytes(&out);
        let expect = shake256_clear(msg, 64);
        assert_eq!(opened, expect);
    }

    #[test]
    fn y1_cost_is_38400_reshare_per_perm() {
        cost::reset();
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x51_0004);
        let in_bits = split_msg_to_bit_shares(&mut rng, b"x", &XS, K).unwrap();
        let _ = shake256_shares(&mut rng, &in_bits, 8, &XS, K).unwrap();
        let used = cost::reshare_count();
        // 1 permutacja (8 B ≤ rate): 24 × 1600 = 38400
        assert_eq!(used, 38_400, "Keccak-f chi = 38400 reshare-muls");
    }

    #[test]
    fn y1_fail_closed_bad_input() {
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x51_0005);
        let bad_n = vec![vec![0u8; 2]; 8];
        assert!(matches!(
            shake256_shares(&mut rng, &bad_n, 8, &XS, K),
            Err(SpikeError::PartyCountMismatch)
        ));
        // niepełny bajt wejścia
        let odd = vec![vec![0u8; 3]; 7];
        assert!(matches!(
            shake256_shares(&mut rng, &odd, 8, &XS, K),
            Err(SpikeError::PartyCountMismatch)
        ));
    }

    #[test]
    fn y1_stays_shared_one_party_cannot_open() {
        // Jeden udział ≠ sekret bitu: Lagrange z 1 punktu daje inną wartość
        // niż pełne k=2 dla co najmniej części bitów (tor nie otwiera).
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x51_0006);
        let in_bits = split_msg_to_bit_shares(&mut rng, b"secret-msg", &XS, K).unwrap();
        let out = shake256_shares(&mut rng, &in_bits, 16, &XS, K).unwrap();
        assert_eq!(out.len(), 16 * 8);
        let full = open_bit_shares(&out, &XS, K).unwrap();
        // „rekonstrukcja" z samego udziału 0 (błędna, ale bez błędu API)
        let mut one_only = Vec::new();
        for row in &out {
            let sh = crate::reconstruct(&[&crate::Share {
                x: XS[0],
                share: row[0],
            }])
            .unwrap();
            one_only.push(sh);
        }
        assert_ne!(
            one_only, full,
            "jeden udział nie może zdradzać bitów wyjścia"
        );
    }

    #[test]
    fn y1_bit_roundtrip_clear() {
        let b = bytes_to_bits_clear(&[0xA5, 0x00, 0xFF]);
        assert_eq!(bits_to_bytes_clear(&b), vec![0xA5, 0x00, 0xFF]);
    }

    // ─── Y12 mutacje: świadome zepsucie musi wypaść FIPS-match ─────────

    #[test]
    fn y12_mutated_domain_breaks_fips_match() {
        // Mutacja: inna domena derive ≠ SHAKE256(domain||seed) z oryginałem
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x5C_0001);
        let seed = [0x3Cu8; 32];
        let seed_bits = split_seed_to_bit_shares(&mut rng, &seed, &XS, K).unwrap();
        let out = derive_key_material_shake(&mut rng, &seed_bits, 32, &XS, K).unwrap();
        let opened = open_out_to_bytes(&out);
        // „zepsuta" domena w oracle (jakby pad/domain inne)
        let mut bad_input = Vec::new();
        bad_input.extend_from_slice(b"WRONG-DOMAIN-XXXX");
        bad_input.extend_from_slice(&seed);
        let bad = shake256_clear(&bad_input, 32);
        assert_ne!(opened, bad, "zepsuta domena musi dawać inny wynik");
    }

    #[test]
    fn y12_single_bit_flip_in_output_detected() {
        // Mutacja 1 bitu w otwartym wyjściu = niezgodność z FIPS
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x5C_0002);
        let in_bits = split_msg_to_bit_shares(&mut rng, b"abc", &XS, K).unwrap();
        let out = shake256_shares(&mut rng, &in_bits, 32, &XS, K).unwrap();
        let mut opened = open_out_to_bytes(&out);
        opened[0] ^= 1;
        assert_ne!(opened, shake256_clear(b"abc", 32), "flip bitu = FAIL");
    }

    // ─── Y2 multi-block absorb ─────────────────────────────────────────

    #[test]
    fn y2_msg_exactly_rate_matches_fips() {
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x52_0001);
        let msg = [0x5Au8; 136]; // == rate → blok wiadomości + blok padu
        let in_bits = split_msg_to_bit_shares(&mut rng, &msg, &XS, K).unwrap();
        let out = shake256_shares(&mut rng, &in_bits, 32, &XS, K).unwrap();
        let opened = open_out_to_bytes(&out);
        assert_eq!(opened, shake256_clear(&msg, 32), "136 B == rate");
    }

    #[test]
    fn y2_msg_two_rate_plus_rem_matches_fips() {
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x52_0002);
        let mut msg = vec![0u8; 2 * 136 + 50];
        for (i, b) in msg.iter_mut().enumerate() {
            *b = (i % 251) as u8;
        }
        let in_bits = split_msg_to_bit_shares(&mut rng, &msg, &XS, K).unwrap();
        let out = shake256_shares(&mut rng, &in_bits, 64, &XS, K).unwrap();
        let opened = open_out_to_bytes(&out);
        assert_eq!(opened, shake256_clear(&msg, 64), "2*rate+50 multi-block");
    }

    #[test]
    fn y2_msg_rate_plus_1_matches_fips() {
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x52_0003);
        let msg = [0xA5u8; 137];
        let in_bits = split_msg_to_bit_shares(&mut rng, &msg, &XS, K).unwrap();
        let out = shake256_shares(&mut rng, &in_bits, 32, &XS, K).unwrap();
        assert_eq!(open_out_to_bytes(&out), shake256_clear(&msg, 32));
    }

    #[test]
    fn y2_cost_perms_scale_with_blocks() {
        // 136 B = 2 permutacje (msg-block + pad-block) = 76800
        cost::reset();
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x52_0004);
        let msg = [1u8; 136];
        let in_bits = split_msg_to_bit_shares(&mut rng, &msg, &XS, K).unwrap();
        let _ = shake256_shares(&mut rng, &in_bits, 8, &XS, K).unwrap();
        assert_eq!(cost::reshare_count(), 2 * 38_400);
    }

    // ─── Y3 derive na prawdziwym SHAKE ─────────────────────────────────

    #[test]
    fn y3_derive_matches_shake_local_oracle() {
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x53_0001);
        let seed = [0x3Cu8; 32];
        let seed_bits = split_seed_to_bit_shares(&mut rng, &seed, &XS, K).unwrap();
        let out = derive_key_material_shake(&mut rng, &seed_bits, crate::DERIVED_LEN, &XS, K)
            .unwrap();
        assert_eq!(out.len(), crate::DERIVED_LEN * 8);
        let opened = open_out_to_bytes(&out);
        let expect = derive_key_material_shake_local(&seed, crate::DERIVED_LEN);
        assert_eq!(opened, expect, "Y3 derive == SHAKE256(domain||seed)");
    }

    #[test]
    fn y3_derive_not_equal_standin_g_frag() {
        // Realny SHAKE ≠ algebraiczny stand-in — jawna granica.
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x53_0002);
        let seed = [0x3Cu8; 32];
        let seed_bits = split_seed_to_bit_shares(&mut rng, &seed, &XS, K).unwrap();
        let out = derive_key_material_shake(&mut rng, &seed_bits, 64, &XS, K).unwrap();
        let shake_out = open_out_to_bytes(&out);
        let standin = crate::g_frag_local(&seed);
        assert_ne!(
            &shake_out[..64],
            &standin[..],
            "SHAKE derive ≠ G_frag stand-in"
        );
    }

    #[test]
    fn y3_fail_closed_seed_len() {
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x53_0003);
        let short = vec![vec![0u8; 3]; 255];
        assert!(matches!(
            derive_key_material_shake(&mut rng, &short, 8, &XS, K),
            Err(SpikeError::PartyCountMismatch)
        ));
    }

    #[test]
    fn y3_domain_separates_keys() {
        let seed = [7u8; 32];
        let a = derive_key_material_shake_local(&seed, 32);
        let b = shake256_clear(&seed, 32);
        assert_ne!(a, b, "domena KEY_DERIVE_DOMAIN zmienia wynik");
    }
}
