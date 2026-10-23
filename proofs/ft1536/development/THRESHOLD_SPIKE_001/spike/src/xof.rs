//! X2 — XOF multi-block **squeeze stand-in** on shares.
//!
//! **NIE jest to SHAKE/Keccak.** To algebraiczny łańcuch GF(256) w stylu
//! `G_frag` (mul_shamir_reshare + lokalne ⊕) stojący w miejscu XOF-a.
//! Realny SHAKE w MPC: patrz `I3_SHAKE_MPC_COST.md` (~10³ × G_frag / perm).
//!
//! Kontrakt API (`seed_shares` → bloki wyjściowe w udziałach):
//! - blok = 32 B (`XOF_BLOCK_LEN`), domyślnie 4 bloki w testach,
//! - koszt: `n_blocks × XOF_MULS_PER_BLOCK` reshare-muls (licznik `cost`),
//! - tor **nie otwiera** seeda ani bloków; otwarcie tylko przez jawny kontrakt.
//!
//! Wzorzec (oracle `xof_squeeze_local`, NIE SHAKE):
//! ```text
//! state := seed
//! for b in 0..n_blocks:
//!   block[i] = state[i] ⊕ (state[(i+1)%32] ⊗ state[(i+7+b)%32])   // 32 muls
//!   state[i] ⊕= block[(i+3)%32] ⊕ block[(i+11)%32]                 // liniowo
//! ```

use crate::mul::mul_shamir_reshare;
use crate::{gf_mul, validate_xs, Result, Share, SpikeError};

/// Długość bloku XOF-slice (B).
pub const XOF_BLOCK_LEN: usize = 32;

/// Reshare-muls na blok (32 muls squeeze; absorb liniowy = 0).
pub const XOF_MULS_PER_BLOCK: usize = 32;

/// Jawny wzorzec squeeze (oracle testowy / lokalny). **NIE SHAKE.**
/// Zwraca `n_blocks` bloków po `XOF_BLOCK_LEN` bajtów.
pub fn xof_squeeze_local(seed: &[u8; 32], n_blocks: usize) -> Vec<[u8; XOF_BLOCK_LEN]> {
    let mut state = *seed;
    let mut blocks = Vec::with_capacity(n_blocks);
    for b in 0..n_blocks {
        let mut block = [0u8; XOF_BLOCK_LEN];
        for i in 0..XOF_BLOCK_LEN {
            let prod = gf_mul(state[(i + 1) % 32], state[(i + 7 + b) % 32]);
            block[i] = state[i] ^ prod;
        }
        for i in 0..XOF_BLOCK_LEN {
            state[i] ^= block[(i + 3) % 32] ^ block[(i + 11) % 32];
        }
        blocks.push(block);
    }
    blocks
}

/// XOF multi-block squeeze na udziałach (stand-in, **bez otwierania**).
///
/// `seed_shares`: 32 B seeda w udziałach (`[bajt][strona]` — jak `split_seed`).
/// Zwraca `n_blocks × XOF_BLOCK_LEN` wierszy udziałów (układ jak `G_frag`:
/// wiersz = bajt wyjściowy, `Share` per strona). Blok `b` zajmuje
/// bajty `[b*32..(b+1)*32)`.
///
/// Koszt: `n_blocks × 32` `mul_shamir_reshare` (zlicza `cost::bump_reshare`).
/// Fail-closed: zły rozmiar seeda / stron → `Err`.
pub fn xof_squeeze_blocks(
    rng: &mut impl rand::RngCore,
    seed_shares: &[Vec<Share>],
    n_blocks: usize,
    xs: &[u8],
    k: u8,
) -> Result<Vec<Vec<Share>>> {
    validate_xs(xs, k)?;
    if seed_shares.len() != 32 {
        return Err(SpikeError::PartyCountMismatch);
    }
    let n = xs.len();
    for b in seed_shares {
        if b.len() != n {
            return Err(SpikeError::PartyCountMismatch);
        }
    }

    // stan: [32][n] wartości udziałów (per strona)
    let mut state_at: Vec<Vec<u8>> = (0..32)
        .map(|i| seed_shares[i].iter().map(|s| s.share).collect())
        .collect();

    let mut out: Vec<Vec<Share>> = Vec::with_capacity(n_blocks.saturating_mul(XOF_BLOCK_LEN));

    for b in 0..n_blocks {
        // squeeze: 32 reshare-muls
        let mut block_at: Vec<Vec<u8>> = Vec::with_capacity(XOF_BLOCK_LEN);
        for i in 0..XOF_BLOCK_LEN {
            let x_at = state_at[(i + 1) % 32].clone();
            let y_at = state_at[(i + 7 + b) % 32].clone();
            let prod = mul_shamir_reshare(rng, xs, k, &x_at, &y_at)?;
            let s = &state_at[i];
            block_at.push(s.iter().zip(prod.iter()).map(|(&a, &c)| a ^ c).collect());
        }
        // absorb liniowy: 0 muls
        for i in 0..XOF_BLOCK_LEN {
            for p in 0..n {
                state_at[i][p] ^= block_at[(i + 3) % 32][p] ^ block_at[(i + 11) % 32][p];
            }
        }
        // pakuj blok w wiersze Share (jak G_frag)
        for ys in block_at {
            out.push(
                xs.iter()
                    .zip(ys)
                    .map(|(&x, share)| Share { x, share })
                    .collect(),
            );
        }
    }
    Ok(out)
}

/// Otwarcie bajtu bloku (jawny kontrakt testowy) — jak `open_g_frag_byte`.
pub fn open_xof_byte(byte_shares: &[Share], k: u8) -> Result<u8> {
    if (byte_shares.len() as u8) < k {
        return Err(SpikeError::InsufficientShares);
    }
    let refs: Vec<&Share> = byte_shares.iter().collect();
    crate::reconstruct(&refs)
}

#[cfg(test)]
mod tests_x2 {
    use super::*;
    use crate::cost;
    use crate::split_seed;
    use rand::rngs::OsRng;

    const XS: [u8; 3] = [1, 2, 3];
    const K: u8 = 2;

    fn seed_pat(pat: u8) -> [u8; 32] {
        let mut seed = [0u8; 32];
        for (i, b) in seed.iter_mut().enumerate() {
            *b = (i as u8).wrapping_mul(13) ^ pat;
        }
        seed
    }

    fn fnv64(data: &[u8]) -> u64 {
        let mut h = 0xcbf29ce484222325u64;
        for &b in data {
            h ^= b as u64;
            h = h.wrapping_mul(0x100000001b3);
        }
        h
    }

    /// X2: oracle per block — udziały otwierają się do `xof_squeeze_local`.
    #[test]
    fn x2_oracle_per_block() {
        let mut rng = OsRng;
        let seed = seed_pat(0xA5);
        let expect = xof_squeeze_local(&seed, 4);
        let sh = split_seed(&mut rng, &seed, &XS, K).unwrap();
        let out = xof_squeeze_blocks(&mut rng, &sh, 4, &XS, K).unwrap();
        assert_eq!(out.len(), 4 * XOF_BLOCK_LEN);
        for b in 0..4 {
            for i in 0..XOF_BLOCK_LEN {
                let opened = open_xof_byte(&out[b * XOF_BLOCK_LEN + i], K).unwrap();
                assert_eq!(opened, expect[b][i], "block {b} byte {i}");
            }
        }
    }

    /// X2: 1 udział nie otwiera bajtu (k=2).
    #[test]
    fn x2_one_share_insufficient() {
        let mut rng = OsRng;
        let seed = seed_pat(0x11);
        let sh = split_seed(&mut rng, &seed, &XS, K).unwrap();
        let out = xof_squeeze_blocks(&mut rng, &sh, 4, &XS, K).unwrap();
        for row in &out {
            assert_eq!(
                open_xof_byte(&row[..1], K).map(|_| ()).unwrap_err(),
                SpikeError::InsufficientShares
            );
        }
    }

    /// X2: cost counter = blocks × muls (32 reshare-muls/blok, 0 Beaver).
    #[test]
    fn x2_cost_is_blocks_times_muls() {
        let mut rng = OsRng;
        let seed = seed_pat(0x3C);
        let sh = split_seed(&mut rng, &seed, &XS, K).unwrap();
        for n_blocks in [1usize, 4, 7] {
            let (reshare, triples) = cost::measure(|| {
                let out = xof_squeeze_blocks(&mut rng, &sh, n_blocks, &XS, K).unwrap();
                assert_eq!(out.len(), n_blocks * XOF_BLOCK_LEN);
            });
            assert_eq!(
                reshare,
                (n_blocks * XOF_MULS_PER_BLOCK) as u64,
                "cost = blocks × muls"
            );
            assert_eq!(triples, 0, "squeeze stand-in: zero Beaver");
        }
    }

    /// X2: deterministyczny wzorzec oracle — pin FNV (NIE SHAKE).
    #[test]
    fn x2_local_pattern_pin() {
        let seed = seed_pat(0xA5);
        let blocks = xof_squeeze_local(&seed, 4);
        let mut flat = Vec::with_capacity(4 * XOF_BLOCK_LEN);
        for blk in &blocks {
            flat.extend_from_slice(blk);
        }
        let fp = fnv64(&flat);
        // determinizm
        let again = xof_squeeze_local(&seed, 4);
        assert_eq!(blocks, again);
        // inny pat → inny tor
        let mut seed2 = seed;
        seed2[0] ^= 1;
        assert_ne!(xof_squeeze_local(&seed2, 4), blocks);
        // twardy pin FNV (ustalony przy przyjęciu modelu X2)
        assert_eq!(
            fp, 0x03446e0f55c52dd4,
            "X2 xof_squeeze_local FNV pin (4 blocks, pat=0xA5)"
        );
    }

    /// X2: share-level determinizm przy ziarnie StdRng (jak mul pin).
    #[test]
    fn x2_share_level_stable_pin() {
        use rand::rngs::StdRng;
        use rand::SeedableRng;

        let seed = seed_pat(0x5A);
        let mut r1 = StdRng::seed_from_u64(0xC0FFEE);
        let sh1 = split_seed(&mut r1, &seed, &XS, K).unwrap();
        let out1 = xof_squeeze_blocks(&mut r1, &sh1, 2, &XS, K).unwrap();

        let mut r2 = StdRng::seed_from_u64(0xC0FFEE);
        let sh2 = split_seed(&mut r2, &seed, &XS, K).unwrap();
        let out2 = xof_squeeze_blocks(&mut r2, &sh2, 2, &XS, K).unwrap();

        assert_eq!(out1.len(), out2.len());
        let mut bytes1 = Vec::new();
        let mut bytes2 = Vec::new();
        for (a, b) in out1.iter().zip(out2.iter()) {
            assert_eq!(a.len(), b.len());
            for (sa, sb) in a.iter().zip(b.iter()) {
                bytes1.push(sa.share);
                bytes2.push(sb.share);
            }
        }
        assert_eq!(bytes1, bytes2, "StdRng determinism");
        let fp = fnv64(&bytes1);
        // twardy pin share-level
        assert_eq!(fp, 0xf330a4077be3921f, "X2 share-level FNV pin (2 blocks, pat=0x5A, StdRng 0xC0FFEE)");
    }

    /// X2: guardy fail-closed (zła długość seeda / zły rozmiar strony).
    #[test]
    fn x2_guards_fail_closed() {
        let mut rng = OsRng;
        let seed = seed_pat(1);
        let sh = split_seed(&mut rng, &seed, &XS, K).unwrap();

        // zła długość seeda (31 zamiast 32)
        let mut bad_len: Vec<Vec<Share>> = Vec::with_capacity(31);
        for row in &sh[..31] {
            let mut copy = Vec::with_capacity(row.len());
            for s in row {
                copy.push(Share { x: s.x, share: s.share });
            }
            bad_len.push(copy);
        }
        assert_eq!(
            xof_squeeze_blocks(&mut rng, &bad_len, 4, &XS, K)
                .map(|_| ())
                .unwrap_err(),
            SpikeError::PartyCountMismatch
        );

        // zły rozmiar strony w pierwszym bajcie (2 zamiast 3)
        let mut bad_side: Vec<Vec<Share>> = Vec::with_capacity(32);
        for (i, row) in sh.iter().enumerate() {
            if i == 0 {
                let mut copy = Vec::with_capacity(2);
                for s in &row[..2] {
                    copy.push(Share { x: s.x, share: s.share });
                }
                bad_side.push(copy);
            } else {
                let mut copy = Vec::with_capacity(row.len());
                for s in row {
                    copy.push(Share { x: s.x, share: s.share });
                }
                bad_side.push(copy);
            }
        }
        assert_eq!(
            xof_squeeze_blocks(&mut rng, &bad_side, 4, &XS, K)
                .map(|_| ())
                .unwrap_err(),
            SpikeError::PartyCountMismatch
        );
    }
}

// ─── Real SHAKE256 (FIPS 202) — oracle w czystości, NIE na udziałach ─────

/// Prawdziwy SHAKE256 (via `sha3`) — wzorzec dla paperu / pinów.
/// **Nie jest to tor MPC.** Koszt MPC patrz `I3_SHAKE_MPC_COST.md`.
pub fn shake256_clear(input: &[u8], out_len: usize) -> Vec<u8> {
    use sha3::digest::{ExtendableOutput, Update, XofReader};
    use sha3::Shake256;
    let mut h = Shake256::default();
    h.update(input);
    let mut reader = h.finalize_xof();
    let mut out = vec![0u8; out_len];
    reader.read(&mut out);
    out
}

/// Model kosztu MPC SHAKE256: AND-gates permutacji (I3 ballpark).
pub fn shake256_mpc_and_gates(perms: u64) -> u64 {
    // chi: 1600 AND/round × 24 rounds ≈ 38_400; full boolean ~10^5 — bierzemy 38_400
    const AND_PERM: u64 = 38_400;
    AND_PERM.saturating_mul(perms)
}

#[cfg(test)]
mod tests_real_shake {
    use super::*;

    #[test]
    fn x4_shake256_matches_rfc_vector() {
        // FIPS 202 Example (empty): SHAKE256("") first 32 bytes
        let out = shake256_clear(b"", 32);
        let expect = [
            0x46, 0xb9, 0xdd, 0x2b, 0x0b, 0xa8, 0x8d, 0x13, 0x23, 0x3b, 0x3f, 0xeb, 0x74,
            0x3e, 0xeb, 0x24, 0x3f, 0xcd, 0x52, 0xea, 0x62, 0xb8, 0x1b, 0x82, 0xb5, 0x0c,
            0x27, 0x64, 0x6e, 0xd5, 0x76, 0x2f,
        ];
        assert_eq!(out.as_slice(), &expect[..], "FIPS 202 SHAKE256 empty vector");
    }

    #[test]
    fn x4_shake256_gate_model() {
        assert_eq!(shake256_mpc_and_gates(1), 38_400);
        assert_eq!(shake256_mpc_and_gates(100), 3_840_000);
    }
}
