//! I1 — liczniki kosztu mnożeń (tylko testy; `#[cfg(test)]`).
//!
//! Zliczamy wywołania dwóch prymitywów mnożenia na udziałach:
//! - `mul_shamir_reshare` (re-deal Shamir, spike 013),
//! - Beaver `generate_triple_shares` (dealerskie trójki).
//!
//! Liczniki są **thread-local**: testy idą równolegle w wątkach, a klasyczny
//! `static AtomicU64` mieszałby zliczenia między testami. Każdy test mierzy
//! deltę na własnym wątku — bez mutexów i bez zmian API publicznego.

use std::cell::Cell;

thread_local! {
    static MUL_RESHARE: Cell<u64> = const { Cell::new(0) };
    static MUL_BEAVER_TRIPLE: Cell<u64> = const { Cell::new(0) };
}

/// +1 do licznika `mul_shamir_reshare` (wołane z `mul::mul_shamir_reshare`).
pub fn bump_reshare() {
    MUL_RESHARE.with(|c| c.set(c.get() + 1));
}

/// +1 do licznika Beaver `generate_triple_shares`.
pub fn bump_triple() {
    MUL_BEAVER_TRIPLE.with(|c| c.set(c.get() + 1));
}

/// Bieżące zliczenie `mul_shamir_reshare` na tym wątku.
pub fn reshare_count() -> u64 {
    MUL_RESHARE.with(|c| c.get())
}

/// Bieżące zliczenie Beaver `generate_triple_shares` na tym wątku.
pub fn triple_count() -> u64 {
    MUL_BEAVER_TRIPLE.with(|c| c.get())
}

/// Zeruje oba liczniki na tym wątku.
pub fn reset() {
    MUL_RESHARE.with(|c| c.set(0));
    MUL_BEAVER_TRIPLE.with(|c| c.set(0));
}

/// Delta liczników wokół `f`: (reshare, beaver_triple).
pub fn measure<F: FnOnce()>(f: F) -> (u64, u64) {
    let r0 = reshare_count();
    let b0 = triple_count();
    f();
    (reshare_count() - r0, triple_count() - b0)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::cmp::accept_bit_from_u_shares_probed;
    use crate::*;
    use rand::rngs::OsRng;

    const XS: [u8; 3] = [1, 2, 3];
    const K: u8 = 2;

    fn seed_shares_of(rng: &mut impl rand::RngCore, seed: &[u8; 32]) -> Vec<Vec<Share>> {
        split_seed(rng, seed, &XS, K).unwrap()
    }

    /// I1: H_fold (1 B) — 16 par seeda × 1 Beaver mul = 16 `generate_triple_shares`.
    /// Ścieżka `derive_key_byte_from_seed_shares` idzie przez `mul_shares_via_beaver`,
    /// więc **zero** `mul_shamir_reshare`.
    #[test]
    fn i1_hfold_cost_is_16_beaver_muls() {
        let mut rng = OsRng;
        let seed = [0x5Au8; 32];
        let sh = seed_shares_of(&mut rng, &seed);
        let (reshare, triples) = measure(|| {
            let k0 = derive_key_byte_from_seed_shares(&mut rng, &sh, &XS, K).unwrap();
            let _ = k0;
        });
        assert_eq!(triples, 16, "H_fold: 16 par × 1 Beaver mul");
        assert_eq!(reshare, 0, "H_fold nie używa mul_shamir_reshare");
    }

    /// I1: G_frag (64 B) — etap1: 32 muls, etap2: 32 muls = 64 `mul_shamir_reshare`.
    /// Zero Beaver (tor idzie przez re-deal, nie trójki).
    #[test]
    fn i1_g_frag_cost_is_64_reshare_muls() {
        let mut rng = OsRng;
        let seed = [0x3Cu8; 32];
        let sh = seed_shares_of(&mut rng, &seed);
        let (reshare, triples) = measure(|| {
            let out = derive_g_frag_shares(&mut rng, &sh, &XS, K).unwrap();
            assert_eq!(out.len(), 64);
        });
        assert_eq!(reshare, 64, "G_frag: 32+32 reshare muls");
        assert_eq!(triples, 0, "G_frag nie generuje trójek Beaver");
    }

    /// I1: derive_key_material_native (128 B) — G_frag (64) + łańcuch (64) = 128
    /// `mul_shamir_reshare`, zero Beaver.
    #[test]
    fn i1_key_material_native_cost_is_128_reshare_muls() {
        let mut rng = OsRng;
        let seed = [0x11u8; 32];
        let sh = seed_shares_of(&mut rng, &seed);
        let (reshare, triples) = measure(|| {
            let mat = derive_key_material_native(&mut rng, &sh, &XS, K).unwrap();
            assert_eq!(mat.len(), DERIVED_LEN);
        });
        assert_eq!(reshare, 128, "64 (G_frag) + 64 (chain) reshare muls");
        assert_eq!(triples, 0, "native chain nie generuje trójek Beaver");
    }

    /// I1: accept_bit (1 bit) — Horner P_w stopnia 255 = 255 kroków × 1 Beaver mul.
    /// `mul_vec` generuje trójkę na krok; zero `mul_shamir_reshare`.
    #[test]
    fn i1_accept_bit_cost_is_255_beaver_muls() {
        let mut rng = OsRng;
        let us = shamir_share(&mut rng, 19, &XS, K).unwrap();
        let u_at: Vec<u8> = us.iter().map(|s| s.share).collect();
        let (reshare, triples) = measure(|| {
            let a = accept_bit_from_u_shares_probed(&mut rng, &XS, K, &u_at, 20).unwrap();
            assert_eq!(a.len(), 3);
        });
        assert_eq!(triples, 255, "Horner: 255 muls (stopień P_w = 255)");
        assert_eq!(reshare, 0, "accept_bit nie używa mul_shamir_reshare");
    }

    /// I1: brzeg w=0 — P_0 ≡ 0, pusty Horner, **zero** mnożeń.
    #[test]
    fn i1_accept_bit_w0_is_zero_muls() {
        let mut rng = OsRng;
        let us = shamir_share(&mut rng, 7, &XS, K).unwrap();
        let u_at: Vec<u8> = us.iter().map(|s| s.share).collect();
        let (reshare, triples) = measure(|| {
            let a = accept_bit_from_u_shares_probed(&mut rng, &XS, K, &u_at, 0).unwrap();
            assert_eq!(a, vec![0u8; 3]);
        });
        assert_eq!(reshare, 0);
        assert_eq!(triples, 0, "w=0: żadnego mnożenia");
    }

    /// Mutation-check: licznik reaguje na realne wywołanie mul (nie jest ozdobą).
    #[test]
    fn i1_counter_sees_raw_mul_calls() {
        let mut rng = OsRng;
        let ash: Vec<u8> = shamir_share(&mut rng, 3, &XS, K)
            .unwrap()
            .into_iter()
            .map(|s| s.share)
            .collect();
        let bsh: Vec<u8> = shamir_share(&mut rng, 5, &XS, K)
            .unwrap()
            .into_iter()
            .map(|s| s.share)
            .collect();
        let (reshare, triples) = measure(|| {
            mul::mul_shamir_reshare(&mut rng, &XS, K, &ash, &bsh).unwrap();
        });
        assert_eq!(reshare, 1);
        assert_eq!(triples, 0);
        let (reshare, triples) = measure(|| {
            generate_triple_shares(&mut rng, &XS, K).unwrap();
        });
        assert_eq!(reshare, 0);
        assert_eq!(triples, 1);
    }
}

/// M4 — model kosztu butterfly (region 2): 1 butterfly ≈ 1 montymul na udziałach
/// (patrz `M4_REGION_MAP.md`, A1–A3). Tu licznik reshare-muls dla łańcucha.
#[cfg(test)]
mod tests_m4 {
    use super::*;
    use crate::mul::mul_shamir_reshare;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    /// M4: łańcuch N=768 „butterfly" = 768 reshare-muls (model A1: 1 mul/butterfly).
    #[test]
    fn m4_butterfly_chain_cost_matches_map() {
        let mut rng = StdRng::seed_from_u64(0x4B07);
        let xs = [1u8, 2, 3];
        let k = 2;
        let a = shares_of_byte(&mut rng, 7, &xs, k);
        let b = shares_of_byte(&mut rng, 9, &xs, k);
        let n = 768u64;
        let (reshare, triples) = measure(|| {
            let mut x = a.clone();
            let y = b.clone();
            for _ in 0..n {
                let z = mul_shamir_reshare(&mut rng, &xs, k, &x, &y).unwrap();
                x = z;
            }
        });
        assert_eq!(reshare, n, "1 reshare-mul per butterfly (model A1)");
        assert_eq!(triples, 0);
    }

    fn shares_of_byte(rng: &mut impl rand::RngCore, v: u8, xs: &[u8], k: u8) -> Vec<u8> {
        crate::shamir_share(rng, v, xs, k).unwrap().into_iter().map(|s| s.share).collect()
    }
}

#[cfg(test)]
mod tests_n3 {
    use super::*;
    use crate::mul::mul_shamir_reshare;
    use rand::rngs::StdRng;
    use rand::SeedableRng;

    /// N3 — model region-3: ~10³–10⁴ muls (M4 ESTIMATE). Tu łańcuch 1000
    /// reshare-muls (div/iNTT-like) z licznikiem kosztu.
    #[test]
    fn n3_region3_chain_cost() {
        let mut rng = StdRng::seed_from_u64(0x3B10);
        let xs = [1u8, 2, 3];
        let k = 2;
        let mut x: Vec<u8> = crate::shamir_share(&mut rng, 3, &xs, k)
            .unwrap()
            .into_iter()
            .map(|s| s.share)
            .collect();
        let y: Vec<u8> = crate::shamir_share(&mut rng, 5, &xs, k)
            .unwrap()
            .into_iter()
            .map(|s| s.share)
            .collect();
        let n = 1000u64;
        let (reshare, triples) = measure(|| {
            for _ in 0..n {
                x = mul_shamir_reshare(&mut rng, &xs, k, &x, &y).unwrap();
            }
        });
        assert_eq!(reshare, n);
        assert_eq!(triples, 0);
    }
}
