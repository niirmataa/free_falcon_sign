//! Testkit P2 (WP-031): dealer klucza testowego, oracle-sampler `$z$`,
//! dekoder `sk` silnika i weryfikator-oracle.
//!
//! **Test-only** (D-009): dealer, stand-in `$z$` i jawny klucz testowy nie
//! mogą istnieć w buildzie `PROD`. Ten crate nie jest linkowany przez
//! `ft-threshold-node` ani `ft-threshold-coordinator` (egzekwuje to
//! `ci/check_prod_symbols.sh`). SPEC §5.1: „testkit MAY użyć znanego `f,F`
//! do wygenerowania `z$, ale `protocol`/`core` **MUST NOT** mieć API
//! reconstruct" — stąd cały oracle żyje tutaj.
//!
//! **Granica twierdzeń:** [`OracleVerifier`] to kontrola plumbingowa na
//! znanym kluczu — **nie** jest silnikiem C. Twierdzenia „engine verify"
//! daje wyłącznie harness `impl/ci/sign/` (prawdziwy `falcon_vrfy`).

#![forbid(unsafe_code)]

use ft_threshold_core::codec;
use ft_threshold_core::error::{CoreError, Result};
use ft_threshold_core::ring::{HALF_N, N, Poly, Q};
use ft_threshold_core::shake::{hash_to_point, shake256};
use ft_threshold_core::shamir_zq;
use ft_threshold_protocol::sign::{EngineVerifier, NONCE_BYTES, TrapdoorShare};

/// Tag domenowy wyprowadzania współczynników dealera testkit.
const TAG_DEAL: &[u8] = b"FT1536/threshold/v1/testkit/deal";

/// Jawny klucz testowy (TEST-ORACLE, §5.1) — **tylko testkit** widzi pełny
/// klucz. Ścieżka sign dostaje wyłącznie udziały ([`TrapdoorShare`]).
pub struct TestKey {
    f: Poly,
    g: Poly,
    big_f: Poly,
    big_g: Poly,
    h: Poly,
}

impl std::fmt::Debug for TestKey {
    /// `Debug` nie pokazuje współczynników klucza.
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("TestKey").finish_non_exhaustive()
    }
}

impl TestKey {
    /// Buduje klucz testowy i sprawdza relacje `f·h = g`, `F·h = G` w `R_q`.
    pub fn new(f: Poly, g: Poly, big_f: Poly, big_g: Poly, h: Poly) -> Result<Self> {
        if f.is_zero() || h.is_zero() {
            return Err(CoreError::InvalidInput);
        }
        if !f.mul(&h).ct_eq(&g) || !big_f.mul(&h).ct_eq(&big_g) {
            return Err(CoreError::NtruMismatch);
        }
        Ok(Self {
            f,
            g,
            big_f,
            big_g,
            h,
        })
    }

    /// Odtwarza $(f, g, F, G)$ z bufora `sk` silnika FT1536:
    /// `0xAA || f || g || F || G`, każdy wektor `compress_static`, `N = 1536`
    /// (format potwierdzony na prawdziwych kluczach silnika).
    ///
    /// `h$ pochodzi z klucza publicznego (`falcon_decode_18433` w harnessie).
    pub fn from_engine_sk(skey: &[u8], h: Poly) -> Result<Self> {
        let (&header, mut rest) = skey.split_first().ok_or(CoreError::InvalidLength)?;
        // ternary | comp = STATIC | rezerwa 0 | logn = 10 | has_G = 1.
        if header != 0xAA {
            return Err(CoreError::InvalidInput);
        }
        let mut polys = Vec::with_capacity(4);
        for _ in 0..4 {
            let (signed, used) = codec::uncompress_static(rest, N)?;
            rest = &rest[used..];
            let q = i32::from(Q);
            let coeffs: Vec<u16> = signed
                .iter()
                .map(|&v| {
                    let mut v = i32::from(v) % q;
                    if v < 0 {
                        v += q;
                    }
                    v as u16
                })
                .collect();
            polys.push(Poly::from_coeffs(&coeffs)?);
        }
        if !rest.is_empty() {
            return Err(CoreError::InvalidLength);
        }
        let big_g = polys.pop().ok_or(CoreError::InvalidLength)?;
        let big_f = polys.pop().ok_or(CoreError::InvalidLength)?;
        let g = polys.pop().ok_or(CoreError::InvalidLength)?;
        let f = polys.pop().ok_or(CoreError::InvalidLength)?;
        Self::new(f, g, big_f, big_g, h)
    }

    /// `f`.
    pub fn f(&self) -> &Poly {
        &self.f
    }

    /// `g`.
    pub fn g(&self) -> &Poly {
        &self.g
    }

    /// `F`.
    pub fn f_big(&self) -> &Poly {
        &self.big_f
    }

    /// `G`.
    pub fn g_big(&self) -> &Poly {
        &self.big_g
    }

    /// `h` (klucz publiczny wielomianowy).
    pub fn h(&self) -> &Poly {
        &self.h
    }
}

fn poly_tag_index(seed: &[u8; 32], tag: u8, index: usize) -> u16 {
    let mut input = Vec::new();
    input.extend_from_slice(TAG_DEAL);
    input.extend_from_slice(seed);
    input.push(tag);
    input.extend_from_slice(&(index as u32).to_be_bytes());
    let mut out = [0u8; 2];
    shake256(&input, &mut out);
    u16::from_be_bytes(out) % Q
}

/// Dealer testkit: dzieli klucz testowy na udziały Shamira (`k`-z-`n`,
/// per współczynnik każdego z 4 wielomianów) w punktach `xs`.
///
/// Współczynniki wielomianów Shamira są wyprowadzane deterministycznie
/// z `seed` (SHAKE256) — test-only powtarzalność; w `PROD` wkłady pochodzą
/// z MPC `G(seed*)` (WP-037), nie z dealera.
pub fn deal_test_key(
    key: &TestKey,
    xs: &[u16],
    k: usize,
    seed: &[u8; 32],
) -> Result<Vec<TrapdoorShare>> {
    if !(2..=ft_threshold_core::MAX_PARTIES_V1).contains(&k) || xs.len() < k {
        return Err(CoreError::ThresholdTooLow);
    }
    let mut per_x: Vec<[Vec<u16>; 4]> = (0..xs.len())
        .map(|_| [Vec::new(), Vec::new(), Vec::new(), Vec::new()])
        .collect();
    let polys = [key.f(), key.g(), key.f_big(), key.g_big()];
    for (tag, poly) in polys.iter().enumerate() {
        for (i, &c) in poly.coeffs().iter().enumerate() {
            let mut coeffs = Vec::with_capacity(k - 1);
            for j in 0..(k - 1) {
                coeffs.push(poly_tag_index(seed, tag as u8, i * (k - 1) + j));
            }
            let shares = shamir_zq::split(c, xs, &coeffs)?;
            for (slot, s) in per_x.iter_mut().zip(shares.iter()) {
                slot[tag].push(s.y());
            }
        }
    }
    let mut out = Vec::with_capacity(xs.len());
    for (idx, slot) in per_x.into_iter().enumerate() {
        out.push(TrapdoorShare::new(
            xs[idx],
            Poly::from_coeffs(&slot[0])?,
            Poly::from_coeffs(&slot[1])?,
            Poly::from_coeffs(&slot[2])?,
            Poly::from_coeffs(&slot[3])?,
        )?);
    }
    Ok(out)
}

fn centered_i64(p: &Poly) -> Vec<i64> {
    let q = i64::from(Q);
    p.coeffs()
        .iter()
        .map(|&c| {
            let v = i64::from(c);
            if v > q / 2 { v - q } else { v }
        })
        .collect()
}

/// Iloczyn w pierścieniu `Z[X]/(X^N − X^{N/2} + 1)` na `i64` (bez mod q),
/// z redukcją identyczną z `ring::mul`.
fn mul_ring_i64(a: &[i64], b: &[i64]) -> Vec<i64> {
    let mut acc = vec![0i64; 2 * N - 1];
    for i in 0..N {
        if a[i] == 0 {
            continue;
        }
        for j in 0..N {
            if b[j] == 0 {
                continue;
            }
            acc[i + j] += a[i] * b[j];
        }
    }
    for e in (N..2 * N - 1).rev() {
        let v = acc[e];
        if v == 0 {
            continue;
        }
        acc[e - HALF_N] += v;
        acc[e - N] -= v;
        acc[e] = 0;
    }
    acc.truncate(N);
    acc
}

fn round_div_q(v: i64) -> i64 {
    let q = f64::from(Q);
    (v as f64 / q).round() as i64
}

/// Oracle-sampler `$z$` (SPEC §7.4, **TEST-ORACLE**):
/// `z1 = round(t·f/q)`, `z0 = round(−t·F/q)` w `Z[X]/(φ)` —
/// deterministyczne zaokrąglenie Babai, jawnie oznaczone jako stand-in.
///
/// To jest dokładnie ścieżka odrzucona dla `PROD` (`ff_lite`/Babai,
/// retained F2-1); wynik **nie** może wejść do KAT `PROD` jako
/// „poprawny kryptograficznie" (§5.1, §7.4). Wymaga jawnego `f, F`
/// (klucz testowy) — dlatego mieszka w testkicie, nie w `protocol`/`core`.
pub fn oracle_sample_z(key: &TestKey, t: &Poly) -> (Vec<i64>, Vec<i64>) {
    let t64 = centered_i64(t);
    let f64c = centered_i64(key.f());
    let big_f64 = centered_i64(key.f_big());
    let tf = mul_ring_i64(&t64, &f64c);
    let t_big_f = mul_ring_i64(&t64, &big_f64);
    let z1: Vec<i64> = tf.iter().map(|&c| round_div_q(c)).collect();
    let z0: Vec<i64> = t_big_f.iter().map(|&c| -round_div_q(c)).collect();
    (z0, z1)
}

fn poly_from_i64(v: &[i64]) -> Poly {
    let q = i64::from(Q);
    let coeffs: Vec<u16> = v
        .iter()
        .map(|&c| {
            let mut c = c % q;
            if c < 0 {
                c += q;
            }
            c as u16
        })
        .collect();
    Poly::from_coeffs(&coeffs).expect("N współczynników")
}

/// Weryfikator-oracle (TEST-ORACLE): zna klucz testowy, przelicza
/// oczekiwane `$s2 = z0·f + z1·F$` z oracle-samplera i porównuje
/// z dekodowanym podpisem.
///
/// **To nie jest silnik C** (brak formy kwadratowej normy i pełnej ścieżki
/// weryfikatora) — potwierdzenie „engine verify" daje wyłącznie harness
/// `impl/ci/sign/`. Check normy jest po stronie `SignMachine::finish`
/// (`B_NORM_BOUND2`) i silnika.
pub struct OracleVerifier<'a> {
    key: &'a TestKey,
}

impl<'a> OracleVerifier<'a> {
    /// Weryfikator dla znanego klucza testowego.
    pub fn new(key: &'a TestKey) -> Self {
        Self { key }
    }
}

impl EngineVerifier for OracleVerifier<'_> {
    fn verify(&self, _pk: &[u8], msg: &[u8], nonce: &[u8; NONCE_BYTES], sig: &[u8]) -> bool {
        let Ok(t) = hash_to_point(nonce, msg) else {
            return false;
        };
        let (z0, z1) = oracle_sample_z(self.key, &t);
        let expected_s2 = poly_from_i64(&z0)
            .mul(self.key.f())
            .add(&poly_from_i64(&z1).mul(self.key.f_big()));
        let Ok(decoded) = codec::decode_sig(sig) else {
            return false;
        };
        decoded.ct_eq(&expected_s2)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use ft_threshold_protocol::sign::lagrange_combine2;

    fn toy_key() -> TestKey {
        let mut f_c = vec![0u16; N];
        f_c[0] = 3;
        f_c[1] = 5;
        let mut h_c = vec![0u16; N];
        h_c[0] = 7;
        h_c[2] = 11;
        let mut big_f_c = vec![0u16; N];
        big_f_c[0] = 2;
        big_f_c[3] = 13;
        let f = Poly::from_coeffs(&f_c).expect("f");
        let h = Poly::from_coeffs(&h_c).expect("h");
        let big_f = Poly::from_coeffs(&big_f_c).expect("F");
        let g = f.mul(&h);
        let big_g = big_f.mul(&h);
        TestKey::new(f, g, big_f, big_g, h).expect("key")
    }

    fn t_sample() -> Poly {
        hash_to_point(&[0x42u8; 40], b"testkit sample").expect("t")
    }

    #[test]
    fn key_relations_are_enforced() {
        let k = toy_key();
        assert!(!k.f().is_zero());
        // Zepsuta relacja f·h = g.
        let mut g_bad = vec![0u16; N];
        g_bad[0] = 1;
        let err = TestKey::new(
            Poly::from_le_bytes(&k.f().to_le_bytes()).expect("f"),
            Poly::from_coeffs(&g_bad).expect("g"),
            Poly::from_le_bytes(&k.f_big().to_le_bytes()).expect("F"),
            Poly::from_le_bytes(&k.g_big().to_le_bytes()).expect("G"),
            Poly::from_le_bytes(&k.h().to_le_bytes()).expect("h"),
        )
        .unwrap_err();
        assert_eq!(err, CoreError::NtruMismatch);
    }

    #[test]
    #[cfg_attr(
        miri,
        ignore = "mnożenia O(N^2) w Miri są zbyt wolne; pokrywa cargo test"
    )]
    fn dealer_shares_interpolate_back_to_key() {
        let key = toy_key();
        let xs = [1u16, 2, 3];
        let shares = deal_test_key(&key, &xs, 2, &[7u8; 32]).expect("deal");
        assert_eq!(shares.len(), 3);
        // Dowolna para odtwarza wielomiany klucza (Lagrange w 0).
        for (a, b) in [(0usize, 1usize), (0, 2), (1, 2)] {
            let f = lagrange_combine2(xs[a], shares[a].f(), xs[b], shares[b].f()).expect("f");
            assert!(f.ct_eq(key.f()), "para {a},{b}: f");
        }
    }

    #[test]
    #[cfg_attr(
        miri,
        ignore = "mnożenia O(N^2) w Miri są zbyt wolne; pokrywa cargo test"
    )]
    fn oracle_z_is_deterministic_and_finite() {
        let key = toy_key();
        let t = t_sample();
        let (z0a, z1a) = oracle_sample_z(&key, &t);
        let (z0b, z1b) = oracle_sample_z(&key, &t);
        assert_eq!(z0a, z0b);
        assert_eq!(z1a, z1b);
        assert_eq!(z0a.len(), N);
        for v in z0a.iter().chain(z1a.iter()) {
            assert!(v.abs() < 1 << 40, "z nie może uciekać poza i64-robocze");
        }
    }

    #[test]
    #[cfg_attr(
        miri,
        ignore = "mnożenia O(N^2) w Miri są zbyt wolne; pokrywa cargo test"
    )]
    fn oracle_verifier_accepts_golden_and_rejects_mismatch() {
        let key = toy_key();
        let t = t_sample();
        let (z0, z1) = oracle_sample_z(&key, &t);
        let s2 = poly_from_i64(&z0)
            .mul(key.f())
            .add(&poly_from_i64(&z1).mul(key.f_big()));
        let sig = codec::encode_sig(&s2);
        let nonce = [0x42u8; 40];
        let v = OracleVerifier::new(&key);
        assert!(
            v.verify(&[], b"testkit sample", &nonce, &sig),
            "złoty podpis musi przejść"
        );
        assert!(
            !v.verify(&[], b"other message", &nonce, &sig),
            "inny komunikat = inne oczekiwane s2 = odrzucenie"
        );
        let mut bad = sig.clone();
        bad[10] ^= 0x01;
        assert!(
            !v.verify(&[], b"testkit sample", &nonce, &bad),
            "uszkodzony sig"
        );
    }

    #[test]
    fn engine_sk_roundtrip_decodes_and_validates() {
        let key = toy_key();
        // Syntetyczny bufor sk w formacie silnika: 0xAA || f || g || F || G.
        let mut skey = vec![0xAAu8];
        for p in [key.f(), key.g(), key.f_big(), key.g_big()] {
            let signed: Vec<i16> = p
                .coeffs()
                .iter()
                .map(|&c| {
                    let q = i32::from(Q);
                    let v = i32::from(c);
                    if v > q / 2 { (v - q) as i16 } else { v as i16 }
                })
                .collect();
            skey.extend(codec::compress_static(&signed));
        }
        let h = Poly::from_le_bytes(&key.h().to_le_bytes()).expect("h");
        let decoded = TestKey::from_engine_sk(&skey, h).expect("decode sk");
        assert!(decoded.f().ct_eq(key.f()));
        assert!(decoded.g_big().ct_eq(key.g_big()));

        // Zły nagłówek i nadmiarowe bajty są odrzucane.
        let mut bad = skey.clone();
        bad[0] = 0x9A;
        assert!(TestKey::from_engine_sk(&bad, Poly::zero()).is_err());
        let mut extra = skey;
        extra.push(0);
        assert!(TestKey::from_engine_sk(&extra, Poly::zero()).is_err());
    }
}
