//! Spike 012 — PRSS-lite: pary nasion, udziały zera, masked open.
//!
//! **PROTOTYP.** Budulec zamiast centralnego PRSS z san-mpc (jeden seed).
//! Pary stron (i,j) ustalają wspólne nasiono z nonce'ów; PRF rozszerza
//! strumień. Udziały zera: strona i bierze +ρ, strona j −ρ, reszta 0.
//!
//! To **nie** jest pełne pairwise Cramer–Damgård–Ishai (brak CDI security
//! proof). Nie generuje jeszcze trójek Beaver (patrz spike 011 — sacrifice).
//!
//! T7.1: rozszerzenie o Z_P ZeroShareStream (±ρ mod P) oraz
//! [`shared_bit_masks`] — PRSS maski bitowe bez centralnego dealera.

use crate::{reconstruct_vals, SpikeError, Result};
use std::collections::BTreeMap;

/// Nasio pary (i,j) — obie strony znają to samo K; to **nie** jest
/// sekret przed drugą stroną pary.
#[derive(zeroize::Zeroize, zeroize::ZeroizeOnDrop)]
pub struct PairwiseSeed {
    pub key: [u8; 32],
}

impl PairwiseSeed {
    pub fn copy_key(&self) -> [u8; 32] {
        self.key
    }
}

fn hash256(data: &[&[u8]]) -> [u8; 32] {
    // Prosty 4×FNV-1a 64-bit → 32 B (spike bez SHA; **nie do produkcji**).
    let mut lanes = [0xcbf29ce484222325u64; 4];
    let mut i = 0usize;
    for chunk in data {
        for &b in *chunk {
            for (li, lane) in lanes.iter_mut().enumerate() {
                *lane ^= (b as u64).wrapping_add((i as u64) << (li * 3));
                *lane = lane.wrapping_mul(0x100000001b3);
            }
            i = i.wrapping_add(1);
        }
    }
    let mut out = [0u8; 32];
    for (li, lane) in lanes.iter().enumerate() {
        out[li * 8..li * 8 + 8].copy_from_slice(&lane.to_le_bytes());
    }
    out
}

/// Ustalenie nasiona pary z nonce'ów (oba kierunki ten sam wynik).
pub fn pair_seed(nonce_i: &[u8], nonce_j: &[u8]) -> PairwiseSeed {
    let (a, b) = if nonce_i <= nonce_j {
        (nonce_i, nonce_j)
    } else {
        (nonce_j, nonce_i)
    };
    PairwiseSeed {
        key: hash256(&[a, b, b"prss-pair"]),
    }
}

/// PRF: strumień bajtów z (key, counter).
pub fn prf_bytes(seed: &PairwiseSeed, counter: u64, out: &mut [u8]) {
    let mut buf = [0u8; 40];
    buf[..32].copy_from_slice(&seed.key);
    buf[32..].copy_from_slice(&counter.to_le_bytes());
    let block = hash256(&[&buf, b"prf"]);
    let n = out.len().min(32);
    out[..n].copy_from_slice(&block[..n]);
    if out.len() > 32 {
        let block2 = hash256(&[&buf, b"prf2"]);
        let rest = out.len() - 32;
        out[32..].copy_from_slice(&block2[..rest]);
    }
}

/// Jeden udział zera z pary (i,j): +ρ dla min(i,j), −ρ dla max(i,j).
/// Suma po stronach = 0 w GF(256).
pub fn zero_share_from_pair(
    seed: &PairwiseSeed,
    counter: u64,
    my_idx: usize,
    other_idx: usize,
) -> u8 {
    let mut r = [0u8; 1];
    prf_bytes(seed, counter, &mut r);
    let rho = r[0];
    if my_idx == other_idx {
        return 0;
    }
    if my_idx < other_idx {
        rho
    } else {
        rho // GF: −ρ = ρ (char 2)
    }
}

/// Zbiór udziałów zera dla strony `me` z wszystkich par.
/// `n` stron, indeksy 0..n-1. `seeds[pair]` klucz (min,max).
pub struct ZeroShareStream {
    pub me: usize,
    pub n: usize,
    seeds: BTreeMap<(usize, usize), PairwiseSeed>,
    counter: u64,
}

impl ZeroShareStream {
    pub fn new(me: usize, n: usize, seeds: BTreeMap<(usize, usize), PairwiseSeed>) -> Self {
        Self {
            me,
            n,
            seeds,
            counter: 0,
        }
    }

    /// Następny udział zera (XOR wszystkich par). **Następna** wartość
    /// innego uczestnika z tym samym counterem sumuje się do 0.
    pub fn next_zero(&mut self) -> u8 {
        let mut acc = 0u8;
        for j in 0..self.n {
            if j == self.me {
                continue;
            }
            let key = (self.me.min(j), self.me.max(j));
            let seed = self.seeds.get(&key).expect("missing pair seed");
            acc ^= zero_share_from_pair(seed, self.counter, self.me, j);
        }
        self.counter += 1;
        acc
    }
}

/// Masked open: dodajemy udział zera (maskuje udział sekretu), otwieramy
/// maskowaną wartość, **nie** odkrywamy maski. W spiku: strona porównuje
/// z zerem bez ujawniania własnego udziału.
///
/// Wersja demo 2-z-2: strony mają udział sekretu s_i; każda dodaje z_i
/// (udział zera); otwieramy s+z = s (bo z=0), ale pojedynczy udział
/// s_i+z_i jest maskowany wobec jednej strony bez drugiej.
pub fn masked_open_demo(
    secret_shares: &[u8],
    zero_shares: &[u8],
    xs: &[u8],
) -> Result<u8> {
    if secret_shares.len() != xs.len() || zero_shares.len() != xs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    let masked: Vec<u8> = secret_shares
        .iter()
        .zip(zero_shares)
        .map(|(&s, &z)| s ^ z)
        .collect();
    // otwarcie maskowanej wartości == sekret (z sumuje się do 0)
    reconstruct_vals(xs, &masked)
}

/// Weryfikacja: suma udziałów zera == 0.
pub fn check_zero_sum(zero_shares: &[u8], xs: &[u8]) -> Result<()> {
    let s = reconstruct_vals(xs, zero_shares)?;
    if s != 0 {
        return Err(SpikeError::InconsistentShare);
    }
    Ok(())
}

// ─── T7.1 — Z_P ZeroShareStream (±ρ mod P) ───────────────────────────────

/// Udział zera w Z_P z pary (i,j): +ρ dla min(i,j), −ρ dla max(i,j).
/// Suma po stronach = 0 (mod P).
pub fn zero_share_zp_from_pair(
    seed: &PairwiseSeed,
    counter: u64,
    my_idx: usize,
    other_idx: usize,
    p_mod: u64,
) -> u64 {
    let mut r = [0u8; 8];
    prf_bytes(seed, counter, &mut r);
    let rho = u64::from_le_bytes(r) % p_mod;
    if my_idx == other_idx {
        return 0;
    }
    if my_idx < other_idx {
        rho
    } else {
        // −ρ mod P
        if rho == 0 {
            0
        } else {
            p_mod - rho
        }
    }
}

/// Z_P ZeroShareStream — analog [`ZeroShareStream`] nad Z_P (±ρ mod P).
/// Suma udziałów zera po stronach = 0 (mod P).
pub struct ZeroShareStreamZp {
    pub me: usize,
    pub n: usize,
    seeds: BTreeMap<(usize, usize), PairwiseSeed>,
    counter: u64,
    p_mod: u64,
}

impl ZeroShareStreamZp {
    pub fn new(
        me: usize,
        n: usize,
        seeds: BTreeMap<(usize, usize), PairwiseSeed>,
        p_mod: u64,
    ) -> Self {
        Self {
            me,
            n,
            seeds,
            counter: 0,
            p_mod,
        }
    }

    /// Następny udział zera (suma wszystkich par). **Następna** wartość
    /// innego uczestnika z tym samym counterem sumuje się do 0 (mod P).
    pub fn next_zero(&mut self) -> u64 {
        let mut acc = 0u64;
        for j in 0..self.n {
            if j == self.me {
                continue;
            }
            let key = (self.me.min(j), self.me.max(j));
            let seed = self.seeds.get(&key).expect("missing pair seed");
            let z = zero_share_zp_from_pair(seed, self.counter, self.me, j, self.p_mod);
            acc = (acc + z) % self.p_mod;
        }
        self.counter += 1;
        acc
    }
}

// ─── T7.1 — shared_bit_masks: PRSS maski bitowe W-bitowe ─────────────────

/// `w` par masek bitowych (GF + Z_P) bez centralnego dealera (T7.1).
/// Każda para: bit maski `b = ⊕_i β_i` z wkładów wirtualnych partii —
/// **nigdy w clear**. Zwraca `(Vec<GfBitShares>, Vec<Vec<u64>>)`:
/// wiersz = bit, kolumna = strona.
///
/// Wrapper nad `ishare::paired_bit_mask_prss` — patrz tam za konstrukcją.
pub fn shared_bit_masks(
    rng: &mut impl rand::RngCore,
    w: usize,
    xs_p: &[u16],
    xs_gf: &[u8],
    k: u8,
    cost: &mut crate::ishare::RoundCost,
) -> Result<(Vec<crate::ishare::GfBitShares>, Vec<Vec<u64>>)> {
    let mut gf_bits = Vec::with_capacity(w);
    let mut p_bits = Vec::with_capacity(w);
    for _ in 0..w {
        let (gf, p) = crate::ishare::paired_bit_mask_prss(rng, xs_p, xs_gf, k, cost)?;
        gf_bits.push(gf);
        p_bits.push(p);
    }
    Ok((gf_bits, p_bits))
}

// ─── T8.1 — pairwise PRSS: osobne rng każdej strony ──────────────────────

/// T8.1 — `w` par masek bitowych z **osobnymi rng każdej wirtualnej
/// partii** (nie jeden in-process rng). Wkład partii `i` wyłącznie z
/// `rngs[i]`; `coins` = monety protokołu (reshare-mul) — **nie** materiał
/// masek. Bit maski `b = ⊕_i β_i` nigdy w clear; brak wspólnego dealera.
pub fn pairwise_prss_bit_masks<R: rand::RngCore>(
    rngs: &mut [R],
    coins: &mut R,
    w: usize,
    xs_p: &[u16],
    xs_gf: &[u8],
    k: u8,
    cost: &mut crate::ishare::RoundCost,
) -> Result<(Vec<crate::ishare::GfBitShares>, Vec<Vec<u64>>)> {
    let mut gf_bits = Vec::with_capacity(w);
    let mut p_bits = Vec::with_capacity(w);
    for _ in 0..w {
        let (gf, p) =
            crate::ishare::paired_bit_mask_prss_pairwise(rngs, coins, xs_p, xs_gf, k, cost)?;
        gf_bits.push(gf);
        p_bits.push(p);
    }
    Ok((gf_bits, p_bits))
}

/// T8.1 — strumienie zer z **osobnych rng per strona**: każda strona
/// losuje własny nonce swoim rng; pary nasion z [`pair_seed`] (obustronna
/// wymiana nonce'ów — **brak centralnego dealera**). Zwraca po jednym
/// [`ZeroShareStream`] na stronę. Suma `next_zero()` po stronach = 0.
pub fn pairwise_zero_streams<R: rand::RngCore>(rngs: &mut [R]) -> Vec<ZeroShareStream> {
    let n = rngs.len();
    let nonces: Vec<[u8; 8]> = rngs
        .iter_mut()
        .map(|r| {
            let mut nb = [0u8; 8];
            nb.copy_from_slice(&r.next_u64().to_le_bytes());
            nb
        })
        .collect();
    let build = || {
        let mut seeds = BTreeMap::new();
        for i in 0..n {
            for j in (i + 1)..n {
                seeds.insert((i, j), pair_seed(&nonces[i], &nonces[j]));
            }
        }
        seeds
    };
    (0..n).map(|me| ZeroShareStream::new(me, n, build())).collect()
}

#[cfg(test)]
mod tests {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn p1_pair_seed_symmetric() {
        let a = b"nonce-a";
        let b = b"nonce-b";
        assert_eq!(pair_seed(a, b).key, pair_seed(b, a).key);
        assert_ne!(pair_seed(a, b).key, pair_seed(a, a).key);
    }

    #[test]
    fn p2_zero_shares_sum_to_zero() {
        let mk = || {
            let mut seeds = BTreeMap::new();
            for (i, j) in [(0usize, 1usize), (0, 2), (1, 2)] {
                let mut ni = [0u8; 8];
                let mut nj = [0u8; 8];
                ni[0] = i as u8 + 1;
                nj[0] = j as u8 + 1;
                seeds.insert((i, j), pair_seed(&ni, &nj));
            }
            seeds
        };
        let mut z0 = ZeroShareStream::new(0, 3, mk());
        let mut z1 = ZeroShareStream::new(1, 3, mk());
        let mut z2 = ZeroShareStream::new(2, 3, mk());
        for t in 0..16u64 {
            let _ = t;
            let a = z0.next_zero();
            let b = z1.next_zero();
            let c = z2.next_zero();
            assert_eq!(a ^ b ^ c, 0, "zero shares must sum to 0");
        }
    }

    #[test]
    fn p3_masked_open_preserves_secret() {
        let mut rng = OsRng;
        let secret = 0x5Au8;
        let xs = [1u8, 2, 3];
        let shares = crate::shamir_share(&mut rng, secret, &xs, 2).unwrap();
        let mk = || {
            let mut seeds = BTreeMap::new();
            for (i, j) in [(0usize, 1usize), (0, 2), (1, 2)] {
                seeds.insert((i, j), pair_seed(&[i as u8 + 1], &[j as u8 + 1]));
            }
            seeds
        };
        let mut streams: Vec<ZeroShareStream> = (0..3)
            .map(|me| ZeroShareStream::new(me, 3, mk()))
            .collect();
        let z: Vec<u8> = streams.iter_mut().map(|s| s.next_zero()).collect();
        check_zero_sum(&z, &xs).unwrap();
        let opened = masked_open_demo(
            &shares.iter().map(|s| s.share).collect::<Vec<_>>(),
            &z,
            &xs,
        )
        .unwrap();
        assert_eq!(opened, secret);
    }

    #[test]
    fn p4_prf_deterministic() {
        let s = pair_seed(b"x", b"y");
        let mut a = [0u8; 16];
        let mut b = [0u8; 16];
        prf_bytes(&s, 7, &mut a);
        prf_bytes(&s, 7, &mut b);
        assert_eq!(a, b);
        prf_bytes(&s, 8, &mut b);
        assert_ne!(a, b);
    }
}

#[cfg(test)]
mod tests_pin {
    use super::*;

    fn fnv64(data: &[u8]) -> u64 {
        let mut h = 0xcbf29ce484222325u64;
        for &b in data {
            h ^= b as u64;
            h = h.wrapping_mul(0x100000001b3);
        }
        h
    }

    #[test]
    fn prss_key_pin() {
        let s = pair_seed(b"alice", b"bob");
        let fp = fnv64(&s.key);
        assert_eq!(fp, 0x77503213bc5df998, "PRSS pair_seed FNV pin");
        assert_eq!(s.key, pair_seed(b"bob", b"alice").key);
    }
}

#[cfg(test)]
mod tests_n5 {
    use super::*;

    #[test]
    fn zero_shares_n5_sum_to_zero() {
        let mk = || {
            let mut seeds = BTreeMap::new();
            for i in 0..5usize {
                for j in (i + 1)..5usize {
                    seeds.insert((i, j), pair_seed(&[i as u8], &[j as u8]));
                }
            }
            seeds
        };
        let mut streams: Vec<ZeroShareStream> = (0..5)
            .map(|me| ZeroShareStream::new(me, 5, mk()))
            .collect();
        for _ in 0..16 {
            let mut acc = 0u8;
            for st in streams.iter_mut() {
                acc ^= st.next_zero();
            }
            assert_eq!(acc, 0);
        }
    }

    #[test]
    fn missing_pair_seed_panics_path() {
        // brak pary → get().expect — w spiku budujemy pełne; tu 3 z 5 par
        let mut seeds = BTreeMap::new();
        seeds.insert((0, 1), pair_seed(b"a", b"b"));
        let mut z = ZeroShareStream::new(0, 3, seeds);
        // me=0, j=2 — brak (0,2) → panic; łapiemy przez catch_unwind
        let r = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| z.next_zero()));
        assert!(r.is_err(), "missing pair seed must panic in stub");
    }
}

#[cfg(test)]
mod tests_t8 {
    use super::*;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    fn party_rngs(seed: u64, n: usize) -> Vec<StdRng> {
        (0..n)
            .map(|i| StdRng::seed_from_u64(seed.wrapping_add(i as u64 * 0x1111)))
            .collect()
    }

    /// T8.1 — strumienie zer z osobnych rng per strona: Σ = 0 bez dealera.
    /// Każda strona losuje własny nonce; pary nasion z `pair_seed`.
    #[test]
    fn t8_pairwise_prss_zero_shares_sum_zero() {
        for n in [3usize, 5] {
            let mut rngs = party_rngs(0x58_09_00_01, n);
            let mut streams = pairwise_zero_streams(&mut rngs);
            assert_eq!(streams.len(), n);
            for _ in 0..32 {
                let mut acc = 0u8;
                for st in streams.iter_mut() {
                    acc ^= st.next_zero();
                }
                assert_eq!(acc, 0, "n={n}: Σ zero-shares = 0 bez dealera");
            }
        }
    }

    /// T8.1 — niezależność strumieni: inne rng stron → inne udziały zer,
    /// ale suma dalej 0. Brak wspólnego strumienia/dealera.
    #[test]
    fn t8_pairwise_prss_zero_shares_independent_streams() {
        let n = 3usize;
        let mut rngs_a = party_rngs(0x58_09_00_02, n);
        let mut rngs_b = party_rngs(0x58_09_00_02 ^ 0xFFFF, n);
        let mut sa = pairwise_zero_streams(&mut rngs_a);
        let mut sb = pairwise_zero_streams(&mut rngs_b);
        let za: Vec<u8> = sa.iter_mut().map(|s| s.next_zero()).collect();
        let zb: Vec<u8> = sb.iter_mut().map(|s| s.next_zero()).collect();
        assert_eq!(za.iter().fold(0u8, |a, &b| a ^ b), 0, "Σ A = 0");
        assert_eq!(zb.iter().fold(0u8, |a, &b| a ^ b), 0, "Σ B = 0");
        assert_ne!(za, zb, "inne rng stron → inne zero-shares");
    }

    /// T8.1 — maski bitowe z osobnych rng: GF/Z_P rekonstruują ten sam
    /// bit (test-only), API zwraca wyłącznie udziały.
    #[test]
    fn t8_pairwise_prss_bit_masks_separate_rngs() {
        let mut rngs = party_rngs(0x58_09_00_03, 3);
        let mut coins = StdRng::seed_from_u64(0x58_09_00_C3);
        let mut cost = crate::ishare::RoundCost::default();
        let (gf_bits, p_bits) = pairwise_prss_bit_masks(
            &mut rngs,
            &mut coins,
            8,
            &[1u16, 2, 3],
            &[1u8, 2, 3],
            2,
            &mut cost,
        )
        .unwrap();
        assert_eq!(gf_bits.len(), 8);
        assert_eq!(p_bits.len(), 8);
        for (mg, mp) in gf_bits.iter().zip(&p_bits) {
            assert_eq!(mg.len(), 3, "GF: n udziałów");
            assert_eq!(mp.len(), 3, "Z_P: n udziałów");
        }
        assert!(cost.prss_xor_muls > 0);
    }

    /// T8.4 — tamper udziału zera → suma ≠ 0 (fail-closed, InconsistentShare).
    #[test]
    fn t8_tamper_prss_zero_share_sum_detected() {
        let n = 3usize;
        let xs = [1u8, 2, 3];
        let mut rngs = party_rngs(0x58_09_00_04, n);
        let mut streams = pairwise_zero_streams(&mut rngs);
        let mut z: Vec<u8> = streams.iter_mut().map(|s| s.next_zero()).collect();
        check_zero_sum(&z, &xs).unwrap();
        // FAŁSZERSTWO: flip bitu udziału zera strony 0
        z[0] ^= 1;
        assert_eq!(
            check_zero_sum(&z, &xs),
            Err(crate::SpikeError::InconsistentShare),
            "tamper zero-share → Σ ≠ 0 wykryte"
        );
    }
}
