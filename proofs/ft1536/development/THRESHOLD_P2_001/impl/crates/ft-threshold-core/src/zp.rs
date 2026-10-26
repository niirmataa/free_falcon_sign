//! Arytmetyka i Shamir w `Z_P`, `P = 2^61−1` (D-025, WP-013).
//!
//! Domeny v1: udziały pułapki żyją w `Z_q` ([`crate::shamir_zq`],
//! [`crate::vss`]), a arytmetyka MPC i maskowanie w `Z_P` (SPEC §7.0).
//! Ten moduł jest **tylko** domeną `Z_P`: brak `q`, brak `R_q`, brak I/O.
//!
//! `P` jest liczbą pierwszą Mersenne'a, więc `Z_P` jest ciałem; odwrotność
//! liczymy z małego twierdzenia Fermata (`a^(P−2)`). Wszystkie wartości są
//! kanoniczne w `0..P`. Iloczyn dwóch elementów `< P` mieści się w `u128`
//! (`< 2^122`), więc redukcja jest dokładna.
//!
//! **Granica:** to arytmetyka i dzielenie sekretu. Protokół (kto, kiedy,
//! jakie przejście domen) należy do warstwy wyżej; ten moduł jest
//! deterministyczny — losowanie współczynników dostarcza wołający.

use std::collections::BTreeSet;

use zeroize::{Zeroize, ZeroizeOnDrop};

use crate::MAX_PARTIES_V1;
use crate::error::{CoreError, Result};

/// Moduł ciała: `2^61 − 1` (liczba pierwsza Mersenne'a).
pub const P: u64 = (1u64 << 61) - 1;

/// Dodawanie w `Z_P`; argumenty muszą być kanoniczne (`< P`).
pub fn add(a: u64, b: u64) -> u64 {
    debug_assert!(a < P && b < P);
    let s = a + b;
    if s >= P { s - P } else { s }
}

/// Odejmowanie w `Z_P`.
pub fn sub(a: u64, b: u64) -> u64 {
    debug_assert!(a < P && b < P);
    if a >= b { a - b } else { a + P - b }
}

/// Negacja w `Z_P`.
pub fn neg(a: u64) -> u64 {
    debug_assert!(a < P);
    if a == 0 { 0 } else { P - a }
}

/// Mnożenie w `Z_P` (dokładne: iloczyn `< 2^122` mieści się w `u128`).
pub fn mul(a: u64, b: u64) -> u64 {
    debug_assert!(a < P && b < P);
    ((u128::from(a) * u128::from(b)) % u128::from(P)) as u64
}

/// Potęgowanie w `Z_P` (square-and-multiply).
pub fn pow(a: u64, e: u64) -> u64 {
    let mut base = a % P;
    let mut exp = e;
    let mut acc = 1u64;
    while exp > 0 {
        if exp & 1 == 1 {
            acc = mul(acc, base);
        }
        base = mul(base, base);
        exp >>= 1;
    }
    acc
}

/// Odwrotność multyplikatywna w `Z_P`; `0` nie jest odwracalne.
pub fn inv(a: u64) -> Option<u64> {
    if a == 0 || a >= P {
        return None;
    }
    Some(pow(a, P - 2))
}

/// Udział Shamir w `Z_P`; `y` jest czyszczone przy dropie.
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct Share {
    x: u16,
    y: u64,
}

impl std::fmt::Debug for Share {
    /// Debug **nie** pokazuje `y` (materiał poufny).
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("zp::Share")
            .field("x", &self.x)
            .finish_non_exhaustive()
    }
}

impl Share {
    /// Tworzy udział; `x = 0`, `x ≥ q` i `y ≥ P` są odrzucane.
    ///
    /// Górna granica `x` jest dziedziczona z domeny współdzielonej
    /// (`q = 18433`), żeby te same identyfikatory stron działały w obu
    /// domenach (D-025).
    pub fn new(x: u16, y: u64) -> Result<Self> {
        if x == 0 {
            return Err(CoreError::XZero);
        }
        if x >= crate::ring::Q {
            return Err(CoreError::OutOfRange);
        }
        if y >= P {
            return Err(CoreError::OutOfRange);
        }
        Ok(Self { x, y })
    }

    /// Punkt ewaluacji.
    pub fn x(&self) -> u16 {
        self.x
    }

    /// Wartość udziału.
    pub fn y(&self) -> u64 {
        self.y
    }
}

/// Dzieli sekret w `Z_P`.
///
/// `coeffs` to współczynniki **niezerowego stopnia** (bez wyrazu wolnego):
/// `f(x) = secret + coeffs[0]·x + coeffs[1]·x² + ...`, więc próg
/// `k = coeffs.len() + 1`. Wymagane `2 ≤ k ≤ MAX_PARTIES_V1`, `xs`
/// niezerowe, różne i w liczbie co najmniej `k`. Współczynniki muszą
/// pochodzić z CSPRNG (losowanie należy do warstwy protokołu).
pub fn split(secret: u64, xs: &[u16], coeffs: &[u64]) -> Result<Vec<Share>> {
    if secret >= P {
        return Err(CoreError::OutOfRange);
    }
    if coeffs.iter().any(|&c| c >= P) {
        return Err(CoreError::OutOfRange);
    }
    let k = coeffs
        .len()
        .checked_add(1)
        .ok_or(CoreError::InvalidLength)?;
    validate_xs(xs, k)?;

    let mut poly = Vec::with_capacity(k);
    poly.push(secret);
    poly.extend_from_slice(coeffs);

    xs.iter().map(|&x| Share::new(x, eval(&poly, x))).collect()
}

/// Odtwarza sekret w `Z_P` z co najmniej `k` udziałów (Lagrange w punkcie 0).
///
/// Przy `shares.len() > k` najpierw sprawdzana jest spójność wszystkich
/// udziałów. To **nie** jest VSS: `k` fałszywych, wzajemnie spójnych
/// udziałów wskaże inny sekret — wiązanie zapewnia [`crate::vss`].
pub fn reconstruct(shares: &[Share], k: usize) -> Result<u64> {
    validate_shares(shares, k)?;
    if shares.len() > k {
        verify_consistency(shares, k)?;
    }

    let mut secret = 0u64;
    for i in 0..k {
        let mut num = 1u64;
        let mut den = 1u64;
        for j in 0..k {
            if i == j {
                continue;
            }
            // Lagrange w 0: licznik to Π(0 − x_j).
            num = mul(num, neg(u64::from(shares[j].x)));
            den = mul(den, sub(u64::from(shares[i].x), u64::from(shares[j].x)));
        }
        let den_inv = inv(den).ok_or(CoreError::DuplicateX)?;
        secret = add(secret, mul(shares[i].y, mul(num, den_inv)));
    }
    Ok(secret)
}

/// Sprawdza, czy wszystkie udziały leżą na jednym wielomianie stopnia `< k`.
///
/// Pierwsze `k` udziałów tworzy bazę interpolacji; każdy kolejny jest
/// porównywany w swoim punkcie `x ≠ 0`. Ta ścieżka nie liczy `f(0)`.
pub fn verify_consistency(shares: &[Share], k: usize) -> Result<()> {
    validate_shares(shares, k)?;
    if shares.len() == k {
        return Ok(());
    }

    let base = &shares[..k];
    for s in &shares[k..] {
        if eval_lagrange(base, s.x)? != s.y {
            return Err(CoreError::InconsistentShare);
        }
    }
    Ok(())
}

/// Współczynniki Lagrange'a w punkcie 0 dla `xs` (λ_i).
///
/// Używane przez ścieżki, które łączą udziały liniowo bez rekonstrukcji
/// (np. suma udziałów δ w [`crate::mac`]). `xs` muszą być niezerowe, różne
/// i w liczbie `2..=MAX_PARTIES_V1`.
pub fn lagrange_at_zero(xs: &[u16]) -> Result<Vec<u64>> {
    validate_xs(xs, 2)?;
    let mut lambdas = Vec::with_capacity(xs.len());
    for (i, &xi) in xs.iter().enumerate() {
        let mut num = 1u64;
        let mut den = 1u64;
        for (j, &xj) in xs.iter().enumerate() {
            if i == j {
                continue;
            }
            num = mul(num, neg(u64::from(xj)));
            den = mul(den, sub(u64::from(xi), u64::from(xj)));
        }
        let den_inv = inv(den).ok_or(CoreError::DuplicateX)?;
        lambdas.push(mul(num, den_inv));
    }
    Ok(lambdas)
}

fn validate_xs(xs: &[u16], k: usize) -> Result<()> {
    if !(2..=MAX_PARTIES_V1).contains(&k) {
        return Err(CoreError::ThresholdTooLow);
    }
    if xs.len() < k {
        return Err(CoreError::NotEnoughPoints);
    }
    let mut seen = BTreeSet::new();
    for &x in xs {
        if x == 0 {
            return Err(CoreError::XZero);
        }
        if x >= crate::ring::Q {
            return Err(CoreError::OutOfRange);
        }
        if !seen.insert(x) {
            return Err(CoreError::DuplicateX);
        }
    }
    Ok(())
}

fn validate_shares(shares: &[Share], k: usize) -> Result<()> {
    if !(2..=MAX_PARTIES_V1).contains(&k) {
        return Err(CoreError::ThresholdTooLow);
    }
    if shares.len() < k {
        return Err(CoreError::InsufficientShares);
    }
    let mut seen = BTreeSet::new();
    for s in shares {
        if s.y >= P {
            return Err(CoreError::OutOfRange);
        }
        if !seen.insert(s.x) {
            return Err(CoreError::DuplicateX);
        }
    }
    Ok(())
}

fn eval(poly: &[u64], x: u16) -> u64 {
    let x = u64::from(x);
    let mut acc = 0u64;
    for &c in poly.iter().rev() {
        acc = add(mul(acc, x), c);
    }
    acc
}

/// Wartość wielomianu z `points` w punkcie `x ≠ 0` (Lagrange).
fn eval_lagrange(points: &[Share], x: u16) -> Result<u64> {
    if points.is_empty() {
        return Err(CoreError::InsufficientShares);
    }
    if x == 0 {
        return Err(CoreError::XZero);
    }

    let x = u64::from(x);
    let mut y = 0u64;
    for (i, si) in points.iter().enumerate() {
        let mut num = 1u64;
        let mut den = 1u64;
        for (j, sj) in points.iter().enumerate() {
            if i == j {
                continue;
            }
            num = mul(num, sub(x, u64::from(sj.x)));
            den = mul(den, sub(u64::from(si.x), u64::from(sj.x)));
        }
        let den_inv = inv(den).ok_or(CoreError::DuplicateX)?;
        y = add(y, mul(si.y, mul(num, den_inv)));
    }
    Ok(y)
}

#[cfg(test)]
mod tests {
    use super::{P, Share, add, inv, lagrange_at_zero, mul, neg, pow, reconstruct, split, sub};
    use crate::error::CoreError;
    use crate::ring::Q;

    // KAT z `ci/kat/zp_reference.py` (niezależny Python).
    const SECRET: u64 = 0x0123_4567_89ab_cdef % P;
    const COEFFS: [u64; 2] = [0x0f1e_2d3c_4b5a_6978 % P, 0x1111_2222_3333_4444 % P];
    const XS: [u16; 4] = [1, 2, 3, 5];

    fn split_sample() -> Vec<Share> {
        split(SECRET, &XS, &COEFFS).expect("split")
    }

    #[test]
    fn split_matches_independent_python_kat() {
        let ys: Vec<u64> = split_sample().iter().map(Share::y).collect();
        assert_eq!(
            ys,
            vec![
                0x0152_94c6_0839_7bac,
                0x03a4_2868_ed2d_b1f2,
                0x0818_0050_3888_70c1,
                0x1766_7cec_0271_87fa,
            ]
        );
        assert_eq!(fnv1a64_le(&ys), 0xebc9_12f3_f65f_3a6a);
    }

    #[test]
    fn k_shares_reconstruct_secret() {
        let shares = split_sample();
        assert_eq!(reconstruct(&shares[..3], 3).expect("k3"), SECRET);
        assert_eq!(reconstruct(&shares, 4).expect("k4"), SECRET);
    }

    #[test]
    fn consistency_accepts_valid_and_rejects_tampered() {
        let shares = split_sample();
        super::verify_consistency(&shares, 3).expect("valid");
        let mut bad = split_sample();
        bad[3] = Share::new(XS[3], add(bad[3].y(), 1)).expect("share");
        assert_eq!(
            super::verify_consistency(&bad, 3).unwrap_err(),
            CoreError::InconsistentShare
        );
        assert_eq!(
            reconstruct(&bad, 3).unwrap_err(),
            CoreError::InconsistentShare
        );
    }

    #[test]
    fn field_axioms_and_edges() {
        assert_eq!(add(P - 1, 1), 0);
        assert_eq!(sub(0, 1), P - 1);
        assert_eq!(neg(0), 0);
        assert_eq!(neg(P - 1), 1);
        assert_eq!(mul(P - 1, P - 1), 1);
        assert_eq!(pow(2, 61), 1); // 2^61 ≡ 1 (mod 2^61−1)
        for a in [1u64, 2, 3, 12345, P - 1, P - 2] {
            let i = inv(a).expect("invertible");
            assert_eq!(mul(a, i), 1, "a={a}");
        }
        assert_eq!(inv(0), None);
        assert_eq!(inv(P), None);
    }

    #[test]
    fn lagrange_sums_to_one_and_interpolates() {
        let lambdas = lagrange_at_zero(&XS).expect("lambdas");
        let mut acc = 0u64;
        for l in lambdas {
            acc = add(acc, l);
        }
        assert_eq!(acc, 1);

        // Liniowa kombinacja udziałów liniowego wielomianu daje f(0).
        let shares = split(SECRET, &XS, &[0x1234]).expect("split");
        let lambdas = lagrange_at_zero(&XS).expect("lambdas");
        let mut acc = 0u64;
        for (s, l) in shares.iter().zip(lambdas) {
            acc = add(acc, mul(s.y(), l));
        }
        assert_eq!(acc, SECRET);
    }

    #[test]
    fn zero_and_high_values() {
        let shares = split(0, &[Q - 1, 2, 3], &[9, 9]).expect("split");
        assert_eq!(reconstruct(&shares, 3).expect("reconstruct"), 0);
        let shares = split(P - 1, &[1, 2, 3], &[P - 2, P - 3]).expect("split");
        assert_eq!(reconstruct(&shares, 3).expect("reconstruct"), P - 1);
    }

    #[test]
    fn bad_parameters_are_rejected() {
        assert_eq!(
            split(1, &[1], &[1]).unwrap_err(),
            CoreError::NotEnoughPoints
        );
        assert_eq!(split(1, &[1], &[]).unwrap_err(), CoreError::ThresholdTooLow);
        assert_eq!(
            split(1, &[1, 2], &[1, 2, 3]).unwrap_err(),
            CoreError::NotEnoughPoints
        );
        assert_eq!(split(1, &[0, 2], &[1]).unwrap_err(), CoreError::XZero);
        assert_eq!(split(1, &[2, 2], &[1]).unwrap_err(), CoreError::DuplicateX);
        assert_eq!(split(1, &[1, 2], &[P]).unwrap_err(), CoreError::OutOfRange);
        assert_eq!(split(P, &[1, 2], &[1]).unwrap_err(), CoreError::OutOfRange);
        let two = split(1, &[1, 2], &[1]).expect("split");
        assert_eq!(
            reconstruct(&two, 3).unwrap_err(),
            CoreError::InsufficientShares
        );
        assert_eq!(
            lagrange_at_zero(&[1]).unwrap_err(),
            CoreError::NotEnoughPoints
        );
        assert_eq!(lagrange_at_zero(&[0, 1]).unwrap_err(), CoreError::XZero);
        assert_eq!(
            lagrange_at_zero(&[1, 1]).unwrap_err(),
            CoreError::DuplicateX
        );
    }

    #[test]
    fn share_constructor_validates() {
        assert_eq!(Share::new(0, 1).unwrap_err(), CoreError::XZero);
        assert_eq!(Share::new(Q, 1).unwrap_err(), CoreError::OutOfRange);
        assert_eq!(Share::new(1, P).unwrap_err(), CoreError::OutOfRange);
        assert_eq!(Share::new(1, 2).expect("ok").y(), 2);
    }

    #[test]
    fn max_threshold_sixteen_works() {
        let xs: Vec<u16> = (1..=u16::from(MAX_PARTIES_U16)).collect();
        let coeffs: Vec<u64> = (0u64..15).map(|i| i * 7 + 1).collect();
        let shares = split(SECRET, &xs, &coeffs).expect("split");
        assert_eq!(reconstruct(&shares, 16).expect("k16"), SECRET);
    }

    const MAX_PARTIES_U16: u8 = 16;

    fn fnv1a64_le(values: &[u64]) -> u64 {
        let mut h = 0xcbf2_9ce4_8422_2325u64;
        for &v in values {
            for byte in v.to_le_bytes() {
                h ^= u64::from(byte);
                h = h.wrapping_mul(0x0000_0100_0000_01b3);
            }
        }
        h
    }
}
