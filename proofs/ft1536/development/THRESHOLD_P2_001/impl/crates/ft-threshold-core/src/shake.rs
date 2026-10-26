//! SHAKE256 i `hash_to_point` dla FT1536 (warstwa jawna).
//!
//! To jest **czysty** XOF: dane wejściowe są jawne albo należą do jednej
//! strony. SHAKE na udziałach (MPC, Y1) to osobny, większy krok G3/O-16;
//! ten moduł go nie zastępuje i nie deklaruje bezpieczeństwa MPC.
//!
//! Zgodność z silnikiem: `hash_to_point(nonce, msg)` absorbuje
//! `nonce || msg` (bez długości), czyta strumień 16-bitowych słów
//! big-endian i odrzuca `w >= 65536 - (65536 mod q)`, tak jak
//! `falcon_hash_to_point` w `falcon-sign.c`/`falcon-vrfy.c`.

use sha3::Shake256;
use sha3::digest::{ExtendableOutput, Update, XofReader};

use crate::error::{CoreError, Result};
use crate::ring::{N, Poly, Q};
use crate::sampler::RejectionSampler;

/// Maksymalny strumień XOF zużyty przez `hash_to_point` (fail-closed).
///
/// Oczekiwane zużycie to ok. 3,7 kB; limit 1 MiB jest bezpiecznikiem
/// na błąd implementacji, nie parametrem kryptograficznym.
pub const MAX_HASH_TO_POINT_STREAM: usize = 1 << 20;

/// Próg odrzucania w rejection samplingu: `65536 - (65536 mod q)`.
pub const HASH_TO_POINT_LIM: u32 = 65536 - (65536 % Q as u32);

/// SHAKE256: pochłania `input`, zapisuje `out.len()` bajtów.
pub fn shake256(input: &[u8], out: &mut [u8]) {
    let mut h = Shake256::default();
    h.update(input);
    let mut reader = h.finalize_xof();
    reader.read(out);
}

/// `t = hash_to_point(nonce || msg)` w `R_q`.
///
/// Zwraca `N` współczynników w `0..q`. Błąd `InvalidLength` oznacza
/// przekroczenie [`MAX_HASH_TO_POINT_STREAM`] (nie powinno wystąpić dla
/// poprawnego XOF; jest to fail-closed zamiast cichego zera).
pub fn hash_to_point(nonce: &[u8], msg: &[u8]) -> Result<Poly> {
    let mut h = Shake256::default();
    h.update(nonce);
    h.update(msg);
    let mut reader = h.finalize_xof();

    // Cap liczony w 16-bitowych słowach: dokładnie 2 B strumienia na próbę.
    // Po capie `AttemptsExhausted` (fail-closed, WP-021), nie ciche zero.
    let max_words =
        u32::try_from(MAX_HASH_TO_POINT_STREAM / 2).map_err(|_| CoreError::InvalidLength)?;
    let mut sampler = RejectionSampler::new(max_words)?;
    let mut coeffs = Vec::with_capacity(N);

    while coeffs.len() < N {
        let w = sampler.draw(
            || {
                let mut word = [0u8; 2];
                reader.read(&mut word);
                u32::from(u16::from_be_bytes(word))
            },
            |&w| w < HASH_TO_POINT_LIM,
        )?;
        coeffs.push((w % Q as u32) as u16);
    }

    Poly::from_coeffs(&coeffs)
}

#[cfg(test)]
mod tests {
    use super::{HASH_TO_POINT_LIM, hash_to_point, shake256};
    use crate::ring::{N, Poly, Q};

    #[test]
    fn shake256_known_nist_vectors() {
        let mut out = [0u8; 32];
        shake256(b"", &mut out);
        assert_eq!(
            hex(&out),
            "46b9dd2b0ba88d13233b3feb743eeb243fcd52ea62b81b82b50c27646ed5762f"
        );
        shake256(b"abc", &mut out);
        assert_eq!(
            hex(&out),
            "483366601360a8771c6863080cc4114d8db44530f8f1e1ee4f94ea37e78b5739"
        );
    }

    #[test]
    fn shake256_is_prefix_consistent() {
        let mut long = [0u8; 200];
        shake256(b"prefix", &mut long);
        let mut short = [0u8; 64];
        shake256(b"prefix", &mut short);
        assert_eq!(&long[..64], &short[..]);
    }

    #[test]
    fn rejection_limit_matches_engine() {
        assert_eq!(Q, 18433);
        assert_eq!(HASH_TO_POINT_LIM, 55299);
    }

    #[test]
    #[cfg_attr(miri, ignore = "O(N) próbek XOF; pod Miri zbędne")]
    fn hash_to_point_matches_independent_python_kat() {
        let nonce = [0x11u8; 40];
        let msg = b"FT1536 P2 KAT";
        let t = hash_to_point(&nonce, msg).expect("hash_to_point");
        assert_eq!(t.coeffs().len(), N);
        assert!(t.coeffs().iter().all(|&c| c < Q));

        let first8: Vec<u16> = (0..8).map(|i| t.coeff(i).expect("i<N")).collect();
        assert_eq!(
            first8,
            vec![7860, 3625, 13024, 994, 6512, 8133, 10335, 14238]
        );

        let mut fnv = 0xcbf2_9ce4_8422_2325u64;
        for &v in t.coeffs() {
            for byte in [v as u8, (v >> 8) as u8] {
                fnv ^= byte as u64;
                fnv = fnv.wrapping_mul(0x0000_0100_0000_01b3);
            }
        }
        assert_eq!(fnv, 0x4e82_5d9b_aa76_a9a3);
    }

    #[test]
    #[cfg_attr(miri, ignore = "O(N) próbek XOF; pod Miri zbędne")]
    fn hash_to_point_is_deterministic_and_domain_separated() {
        let a = hash_to_point(b"nonce-a", b"msg").expect("a");
        let b = hash_to_point(b"nonce-a", b"msg").expect("b");
        let c = hash_to_point(b"nonce-b", b"msg").expect("c");
        assert!(a.ct_eq(&b));
        assert!(!a.ct_eq(&c));
    }

    #[test]
    fn poly_from_coeffs_accepts_full_output() {
        // Sanity: wynik hash_to_point zawsze mieści się w R_q.
        let coeffs = vec![12345u16; N];
        assert!(Poly::from_coeffs(&coeffs).is_ok());
    }

    fn hex(bytes: &[u8]) -> String {
        bytes.iter().map(|b| format!("{b:02x}")).collect()
    }
}
