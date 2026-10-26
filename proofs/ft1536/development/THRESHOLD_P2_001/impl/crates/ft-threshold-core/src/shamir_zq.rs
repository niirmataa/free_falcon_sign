//! Shamir w `Z_q` — Faza A setupu B′ (SPEC §6.0).
//!
//! `seed*` jest 32-bajtowym wektorem; każdy bajt jest osobną instancją
//! Shamira stopnia `k−1` nad `Z_q` (`q = 18433`, bajt `< q`). Ten moduł
//! obsługuje pojedynczą instancję: dzielenie, rekonstrukcję i sprawdzanie
//! spójności. Wspólny `sid` i 32 równoległe instancje należą do warstwy
//! protokołu.
//!
//! **Granica:** `reconstruct` odtwarza sekret z `k` udziałów — to jest
//! funkcja odbiorcy końcowego, nie ścieżka MPC. `verify_consistency`
//! **nie** liczy `f(0)`: sprawdza tylko, że kolejne udziały leżą na
//! wielomianie wyznaczonym przez pierwsze `k`.
//!
//! Losowanie współczynników należy do warstwy protokołu (CSPRNG); ten
//! moduł jest deterministyczny, jak [`crate::gf256`].

use std::collections::BTreeSet;

use zeroize::{Zeroize, ZeroizeOnDrop};

use crate::MAX_PARTIES_V1;
use crate::error::{CoreError, Result};
use crate::ring::{Q, add_mod, inv_mod, mul_mod, sub_mod};

/// Udział Shamir w `Z_q`; `y` jest czyszczone przy dropie.
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct Share {
    x: u16,
    y: u16,
}

impl std::fmt::Debug for Share {
    /// Debug **nie** pokazuje `y` (materiał poufny).
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Share")
            .field("x", &self.x)
            .finish_non_exhaustive()
    }
}

impl Share {
    /// Tworzy udział; `x = 0`, `x ≥ q` i `y ≥ q` są odrzucane.
    pub fn new(x: u16, y: u16) -> Result<Self> {
        if x == 0 {
            return Err(CoreError::XZero);
        }
        if x >= Q || y >= Q {
            return Err(CoreError::OutOfRange);
        }
        Ok(Self { x, y })
    }

    /// Punkt ewaluacji.
    pub fn x(&self) -> u16 {
        self.x
    }

    /// Wartość udziału.
    pub fn y(&self) -> u16 {
        self.y
    }
}

/// Dzieli sekret na udziały Shamira.
///
/// `coeffs` to współczynniki **niezerowego stopnia** (bez wyrazu wolnego):
/// `f(x) = secret + coeffs[0]·x + coeffs[1]·x² + ...`, więc próg
/// `k = coeffs.len() + 1`. Wymagane `2 ≤ k ≤ MAX_PARTIES_V1`, `xs`
/// niezerowe, różne i w liczbie co najmniej `k`.
pub fn split(secret: u16, xs: &[u16], coeffs: &[u16]) -> Result<Vec<Share>> {
    if secret >= Q {
        return Err(CoreError::OutOfRange);
    }
    if coeffs.iter().any(|&c| c >= Q) {
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

/// Odtwarza sekret z co najmniej `k` udziałów (Lagrange w punkcie 0).
///
/// Przy `shares.len() > k` najpierw sprawdzana jest spójność wszystkich
/// udziałów. To **nie** jest VSS: `k` fałszywych, wzajemnie spójnych
/// udziałów wskaże inny sekret — wiązanie zapewnia [`crate::vss`].
pub fn reconstruct(shares: &[Share], k: usize) -> Result<u16> {
    validate_shares(shares, k)?;
    if shares.len() > k {
        verify_consistency(shares, k)?;
    }

    let mut secret = 0u16;
    for i in 0..k {
        let mut num = 1u16;
        let mut den = 1u16;
        for j in 0..k {
            if i == j {
                continue;
            }
            // Lagrange w 0: licznik to Π(0 − x_j), nie Π x_j (znak ma znaczenie
            // w charakterystyce ≠ 2).
            num = mul_mod(num, sub_mod(0, shares[j].x));
            den = mul_mod(den, sub_mod(shares[i].x, shares[j].x));
        }
        let den_inv = inv_mod(den).ok_or(CoreError::DuplicateX)?;
        secret = add_mod(secret, mul_mod(shares[i].y, mul_mod(num, den_inv)));
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
        let expected = eval_lagrange(base, s.x)?;
        if expected != s.y {
            return Err(CoreError::InconsistentShare);
        }
    }
    Ok(())
}

fn validate_xs(xs: &[u16], k: usize) -> Result<()> {
    if !(2..=MAX_PARTIES_V1).contains(&k) {
        return Err(CoreError::ThresholdTooLow);
    }
    if xs.len() < k {
        return Err(CoreError::PartyCountMismatch);
    }
    let mut seen = BTreeSet::new();
    for &x in xs {
        if x == 0 {
            return Err(CoreError::XZero);
        }
        if x >= Q {
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
        if s.y >= Q {
            return Err(CoreError::OutOfRange);
        }
        if !seen.insert(s.x) {
            return Err(CoreError::DuplicateX);
        }
    }
    Ok(())
}

fn eval(poly: &[u16], x: u16) -> u16 {
    let mut acc = 0u16;
    for &c in poly.iter().rev() {
        acc = add_mod(mul_mod(acc, x), c);
    }
    acc
}

/// Wartość wielomianu z `points` w punkcie `x ≠ 0` (Lagrange).
fn eval_lagrange(points: &[Share], x: u16) -> Result<u16> {
    if points.is_empty() {
        return Err(CoreError::InsufficientShares);
    }
    if x == 0 {
        return Err(CoreError::XZero);
    }

    let mut y = 0u16;
    for (i, si) in points.iter().enumerate() {
        let mut num = 1u16;
        let mut den = 1u16;
        for (j, sj) in points.iter().enumerate() {
            if i == j {
                continue;
            }
            num = mul_mod(num, sub_mod(x, sj.x));
            den = mul_mod(den, sub_mod(si.x, sj.x));
        }
        let den_inv = inv_mod(den).ok_or(CoreError::DuplicateX)?;
        y = add_mod(y, mul_mod(si.y, mul_mod(num, den_inv)));
    }
    Ok(y)
}

#[cfg(test)]
mod tests {
    use super::{Share, reconstruct, split, verify_consistency};
    use crate::error::CoreError;
    use crate::ring::Q;
    use crate::vss;

    const SECRET: u16 = 0x42;
    const COEFFS: [u16; 3] = [7, 3, 12345];
    const XS: [u16; 5] = [1, 2, 3, 5, 7];

    fn split_sample() -> Vec<Share> {
        split(SECRET, &XS, &COEFFS).expect("split")
    }

    #[test]
    fn split_matches_independent_python_kat() {
        let shares = split_sample();
        let ys: Vec<u16> = shares.iter().map(Share::y).collect();
        assert_eq!(ys, vec![12421, 6687, 1635, 13362, 13440]);
        assert_eq!(fnv1a64_le(&ys), 0x0d63_41bb_5fe4_158e);
    }

    #[test]
    fn k_shares_reconstruct_secret() {
        let shares = split_sample();
        // Stopień 3: mniej niż 4 udziały dają inną wartość (to nie jest błąd).
        assert_eq!(reconstruct(&shares[..2], 2).expect("k2"), 18155);
        assert_eq!(reconstruct(&shares[..3], 3).expect("k3"), 404);
        assert_eq!(reconstruct(&shares[..4], 4).expect("k4"), SECRET);
        assert_eq!(reconstruct(&shares, 5).expect("k5"), SECRET);
    }

    #[test]
    fn consistency_accepts_valid_and_rejects_tampered() {
        let shares = split_sample();
        verify_consistency(&shares, 4).expect("valid");
        let mut bad = split_sample();
        bad[4] = Share::new(XS[4], bad[4].y() ^ 1).expect("share");
        assert_eq!(
            verify_consistency(&bad, 4).unwrap_err(),
            CoreError::InconsistentShare
        );
    }

    #[test]
    fn reconstruct_checks_consistency_beyond_k() {
        let mut bad = split_sample();
        bad[4] = Share::new(XS[4], 0).expect("share");
        assert_eq!(
            reconstruct(&bad, 4).unwrap_err(),
            CoreError::InconsistentShare
        );
    }

    #[test]
    fn zero_secret_and_high_x() {
        let shares = split(0, &[Q - 1, 2, 3], &[9, 9]).expect("split");
        assert_eq!(reconstruct(&shares, 3).expect("reconstruct"), 0);
    }

    #[test]
    fn bad_parameters_are_rejected() {
        assert_eq!(
            split(1, &[1], &[1]).unwrap_err(),
            CoreError::PartyCountMismatch
        );
        assert_eq!(split(1, &[1], &[]).unwrap_err(), CoreError::ThresholdTooLow);
        assert_eq!(
            split(1, &[1, 2], &[1, 2, 3]).unwrap_err(),
            CoreError::PartyCountMismatch
        );
        assert_eq!(split(1, &[0, 2], &[1]).unwrap_err(), CoreError::XZero);
        assert_eq!(split(1, &[2, 2], &[1]).unwrap_err(), CoreError::DuplicateX);
        assert_eq!(split(1, &[1, 2], &[Q]).unwrap_err(), CoreError::OutOfRange);
        assert_eq!(split(Q, &[1, 2], &[1]).unwrap_err(), CoreError::OutOfRange);
        let two = split(1, &[1, 2], &[1]).expect("split");
        assert_eq!(
            reconstruct(&two, 3).unwrap_err(),
            CoreError::InsufficientShares
        );
    }

    #[test]
    fn share_constructor_validates() {
        assert_eq!(Share::new(0, 1).unwrap_err(), CoreError::XZero);
        assert_eq!(Share::new(Q, 1).unwrap_err(), CoreError::OutOfRange);
        assert_eq!(Share::new(1, Q).unwrap_err(), CoreError::OutOfRange);
        assert_eq!(Share::new(1, 2).expect("ok").y(), 2);
    }

    #[test]
    fn vss_shares_reconstruct_same_secret() {
        let coeffs = [SECRET, 7, 3];
        let blinds = [[1u8; 32]; 3];
        let (_, shares) = vss::deal(&coeffs, &blinds, &XS[..3]).expect("deal");
        let zq: Vec<Share> = shares
            .iter()
            .map(|s| Share::new(s.x(), s.share_zq()).expect("share"))
            .collect();
        assert_eq!(reconstruct(&zq, 3).expect("reconstruct"), SECRET);
    }

    fn fnv1a64_le(values: &[u16]) -> u64 {
        let mut h = 0xcbf2_9ce4_8422_2325u64;
        for &v in values {
            for byte in [v as u8, (v >> 8) as u8] {
                h ^= byte as u64;
                h = h.wrapping_mul(0x0000_0100_0000_01b3);
            }
        }
        h
    }
}
