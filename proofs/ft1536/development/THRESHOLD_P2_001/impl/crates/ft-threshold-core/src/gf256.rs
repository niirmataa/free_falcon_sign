//! Arytmetyka GF(2^8) i dzielenie Shamira bajtów seeda.
//!
//! Pole: AES, wielomian `x^8 + x^4 + x^3 + x + 1` (`0x11b`, redukcja `0x1b`).
//! To jest warstwa **seed-share** (D-024): bajty seeda są dzielone progowo,
//! a nie współczynniki pierścienia `R_q` (te mają osobny moduł).
//!
//! Zasady:
//! - brak tabel zależnych od sekretu (mnożenie bitowe, stały przepływ),
//! - `x = 0` jest zarezerwowane dla sekretu i odrzucane,
//! - duplikaty punktów i za mało udziałów → jawny błąd,
//! - współczynniki wielomianu są zeroizowane po użyciu.
//!
//! **Granica:** to nie jest VSS. Kontrola spójności wykrywa fałszywy udział
//! tylko w modelu z nadmiarem `n > k` i nie chroni przed dealerem, który
//! zna wszystkie udziały. Produkcyjne VSS (Pedersen) jest osobnym modułem.

use zeroize::{Zeroize, ZeroizeOnDrop, Zeroizing};

use crate::error::{CoreError, Result};

/// Wielomian redukujący AES: `x^8 + x^4 + x^3 + x + 1` bez bitu wiodącego.
pub const FIELD_POLY: u8 = 0x1b;

/// Mnożenie w GF(2^8) (AES). Stały przepływ, bez tabel.
#[inline]
pub fn mul(mut a: u8, mut b: u8) -> u8 {
    let mut p = 0u8;
    for _ in 0..8 {
        let lsb = 0u8.wrapping_sub(b & 1);
        p ^= a & lsb;
        let hi = 0u8.wrapping_sub((a >> 7) & 1);
        a = (a << 1) ^ (FIELD_POLY & hi);
        b >>= 1;
    }
    p
}

/// Potęgowanie w GF(2^8); `pow(a, 0) = 1`.
pub fn pow(mut a: u8, mut e: u16) -> u8 {
    let mut r = 1u8;
    while e > 0 {
        if e & 1 == 1 {
            r = mul(r, a);
        }
        a = mul(a, a);
        e >>= 1;
    }
    r
}

/// Odwrotność multiplikatywna; `None` dla zera.
///
/// `a^254 = a^-1` z małego twierdzenia Fermata (`a^255 = 1`).
pub fn inv(a: u8) -> Option<u8> {
    if a == 0 { None } else { Some(pow(a, 254)) }
}

/// Udział bajtu sekretu w punkcie `x`.
///
/// Brak `Clone`/`Copy`/`Debug`: przypadkowe skopiowanie lub wypisanie
/// udziału jest błędem. Pola są prywatne; dostęp przez [`Share::x`] i
/// [`Share::y`]. Drop zeroizuje bajty.
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct Share {
    x: u8,
    y: u8,
}

impl Share {
    /// Tworzy udział; `x = 0` jest odrzucane.
    pub fn new(x: u8, y: u8) -> Result<Self> {
        if x == 0 {
            return Err(CoreError::XZero);
        }
        Ok(Self { x, y })
    }

    /// Punkt ewaluacji (niezerowy).
    pub fn x(&self) -> u8 {
        self.x
    }

    /// Wartość udziału w punkcie `x`.
    pub fn y(&self) -> u8 {
        self.y
    }
}

/// Wartość wielomianu w punkcie `x` (Horner w GF(2^8)).
fn eval(coeffs: &[u8], x: u8) -> u8 {
    let mut acc = 0u8;
    for &c in coeffs.iter().rev() {
        acc = mul(acc, x) ^ c;
    }
    acc
}

/// Sprawdza listę punktów ewaluacji dla progu `k`.
fn validate_xs(xs: &[u8], k: usize) -> Result<()> {
    if k < 2 {
        return Err(CoreError::ThresholdTooLow);
    }
    if xs.is_empty() {
        return Err(CoreError::EmptyXs);
    }
    if xs.len() < k {
        return Err(CoreError::NotEnoughPoints);
    }
    let mut seen = [false; 256];
    for &x in xs {
        if x == 0 {
            return Err(CoreError::XZero);
        }
        if seen[x as usize] {
            return Err(CoreError::DuplicateX);
        }
        seen[x as usize] = true;
    }
    Ok(())
}

/// Sprawdza udziały pod kątem progu `k` (nie sprawdza spójności).
fn validate_shares(shares: &[Share], k: usize) -> Result<()> {
    if k < 2 {
        return Err(CoreError::ThresholdTooLow);
    }
    if shares.len() < k {
        return Err(CoreError::InsufficientShares);
    }
    let mut seen = [false; 256];
    for s in shares {
        if s.x == 0 {
            return Err(CoreError::XZero);
        }
        if seen[s.x as usize] {
            return Err(CoreError::DuplicateX);
        }
        seen[s.x as usize] = true;
    }
    Ok(())
}

/// Dzieli bajt sekretu na udziały Shamira.
///
/// `coeffs` to współczynniki **niezerowego stopnia** (bez wyrazu wolnego):
/// wielomian ma postać `secret + coeffs[0]·x + coeffs[1]·x² + ...`, więc
/// próg `k = coeffs.len() + 1`. Współczynniki muszą pochodzić z
/// kryptograficznego RNG (losowanie należy do warstwy protokołu).
pub fn split(secret: u8, xs: &[u8], coeffs: &[u8]) -> Result<Vec<Share>> {
    let k = coeffs
        .len()
        .checked_add(1)
        .ok_or(CoreError::InvalidLength)?;
    validate_xs(xs, k)?;

    let mut poly = Zeroizing::new(Vec::with_capacity(k));
    poly.push(secret);
    poly.extend_from_slice(coeffs);

    let shares = xs
        .iter()
        .map(|&x| {
            // `x != 0` zostało sprawdzone; konstrukcja nie może zawieść.
            Ok(Share {
                x,
                y: eval(&poly, x),
            })
        })
        .collect::<Result<Vec<_>>>()?;
    Ok(shares)
}

/// Odtwarza sekret z co najmniej `k` udziałów (Lagrange w punkcie 0).
///
/// Przy `shares.len() > k` najpierw sprawdzana jest spójność wszystkich
/// udziałów, a rekonstrukcja używa pierwszych `k`. To nadal **nie** jest
/// VSS: dealer lub układ `k` fałszywych udziałów może wskazać inny sekret.
pub fn reconstruct(shares: &[Share], k: usize) -> Result<u8> {
    validate_shares(shares, k)?;
    if shares.len() > k {
        verify_consistency(shares, k)?;
    }

    let mut secret = 0u8;
    for (i, si) in shares[..k].iter().enumerate() {
        let mut num = 1u8;
        let mut den = 1u8;
        for (j, sj) in shares[..k].iter().enumerate() {
            if i == j {
                continue;
            }
            num = mul(num, sj.x);
            den = mul(den, si.x ^ sj.x);
        }
        let den_inv = inv(den).ok_or(CoreError::DuplicateX)?;
        secret ^= mul(si.y, mul(num, den_inv));
    }
    Ok(secret)
}

/// Sprawdza, czy wszystkie udziały leżą na jednym wielomianie stopnia `< k`.
///
/// Pierwsze `k` udziałów tworzy bazę interpolacji; każdy kolejny jest
/// porównywany z wartością policzoną **wyłącznie w swoim punkcie `x ≠ 0`**.
/// Ta ścieżka nigdy nie liczy `f(0)`, więc nie odtwarza sekretu.
///
/// Wymaga `n > k`, żeby wykryć pojedynczy fałszywy udział. Przy `n == k`
/// każde `k` punktów leży na pewnym wielomianie, więc wynik jest trywialny.
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

/// Wartość wielomianu z punktów `points` w punkcie `x` (Lagrange).
///
/// `x = 0` jest jawnie odrzucane — ta funkcja nie może odtworzyć sekretu.
fn eval_lagrange(points: &[Share], x: u8) -> Result<u8> {
    if points.is_empty() {
        return Err(CoreError::InsufficientShares);
    }
    if x == 0 {
        return Err(CoreError::XZero);
    }

    let mut y = 0u8;
    for (i, si) in points.iter().enumerate() {
        let mut num = 1u8;
        let mut den = 1u8;
        for (j, sj) in points.iter().enumerate() {
            if i == j {
                continue;
            }
            num = mul(num, x ^ sj.x);
            den = mul(den, si.x ^ sj.x);
        }
        let den_inv = inv(den).ok_or(CoreError::DuplicateX)?;
        y ^= mul(si.y, mul(num, den_inv));
    }
    Ok(y)
}

#[cfg(test)]
mod tests {
    use super::{Share, inv, mul, pow, reconstruct, split, verify_consistency};
    use crate::error::CoreError;

    #[test]
    fn mul_known_aes_vectors() {
        assert_eq!(mul(0x57, 0x83), 0xc1);
        assert_eq!(mul(0x53, 0xca), 0x01);
        assert_eq!(mul(0x00, 0xff), 0x00);
        assert_eq!(mul(0x01, 0xa5), 0xa5);
    }

    #[test]
    fn mul_is_commutative_and_distributive_on_sample() {
        // Miri jest zbyt wolny dla pełnego 256x256; pod nim próbkujemy.
        let step = if cfg!(miri) { 17 } else { 1 };
        for a in (0u16..=255).step_by(step) {
            let a = a as u8;
            for b in (0u16..=255).step_by(step) {
                let b = b as u8;
                assert_eq!(mul(a, b), mul(b, a));
                for c in [0u8, 1, 0x1b, 0x80, 0xff] {
                    assert_eq!(mul(a, b ^ c), mul(a, b) ^ mul(a, c));
                }
            }
        }
    }

    #[test]
    fn inv_is_exhaustive_left_inverse() {
        assert_eq!(inv(0), None);
        let step = if cfg!(miri) { 17 } else { 1 };
        for a in (1u16..=255).step_by(step) {
            let a = a as u8;
            assert_eq!(mul(a, inv(a).expect("nonzero")), 1, "a={a:#04x}");
        }
    }

    #[test]
    fn pow_small_exponents() {
        assert_eq!(pow(0, 0), 1);
        assert_eq!(pow(0, 5), 0);
        assert_eq!(pow(0x02, 8), 0x1b);
        assert_eq!(pow(0x03, 0), 1);
    }

    #[test]
    fn split_matches_independent_reference_kat() {
        // KAT z niezależnej implementacji Pythona (AES poly, Horner):
        // secret=0x42, coeffs=[0x11], xs=[1,2,3].
        let shares = split(0x42, &[1, 2, 3], &[0x11]).expect("split");
        let ys: Vec<u8> = shares.iter().map(Share::y).collect();
        assert_eq!(ys, vec![0x53, 0x60, 0x71]);
    }

    #[test]
    fn reconstruct_any_k_subset_of_five() {
        let xs = [1u8, 2, 3, 4, 5];
        let shares = split(0xa7, &xs, &[0x11, 0x22]).expect("split");
        for i in 0..xs.len() {
            for j in (i + 1)..xs.len() {
                for l in (j + 1)..xs.len() {
                    let subset = [&shares[i], &shares[j], &shares[l]];
                    let got = reconstruct_refs(&subset, 3);
                    assert_eq!(got, 0xa7, "subset {i},{j},{l}");
                }
            }
        }
    }

    fn reconstruct_refs(shares: &[&Share], k: usize) -> u8 {
        // Adapter testowy: `reconstruct` przyjmuje `&[Share]`, a subset
        // wybieramy przez referencje; tworzymy płytkie kopie wartości.
        let owned: Vec<Share> = shares
            .iter()
            .map(|s| Share::new(s.x(), s.y()).expect("nonzero x"))
            .collect();
        reconstruct(&owned, k).expect("reconstruct")
    }

    #[test]
    fn consistency_detects_tampered_share() {
        let shares = split(0x42, &[1, 2, 3], &[0x11]).expect("split");
        verify_consistency(&shares, 2).expect("consistent");

        let tampered = vec![
            Share::new(1, 0x53).expect("x"),
            Share::new(2, 0x61).expect("x"), // 0x60 ^ 1
            Share::new(3, 0x71).expect("x"),
        ];
        assert_eq!(
            verify_consistency(&tampered, 2).unwrap_err(),
            CoreError::InconsistentShare
        );
    }

    #[test]
    fn consistency_with_exact_k_is_trivial() {
        let shares = split(0x42, &[1, 2], &[0x11]).expect("split");
        verify_consistency(&shares, 2).expect("n == k");
    }

    #[test]
    fn split_rejects_invalid_points() {
        assert_eq!(split_err(1, &[], &[1]), CoreError::EmptyXs);
        assert_eq!(split_err(1, &[1], &[1]), CoreError::NotEnoughPoints);
        assert_eq!(split_err(1, &[0, 1], &[1]), CoreError::XZero);
        assert_eq!(split_err(1, &[1, 1], &[1]), CoreError::DuplicateX);
        assert_eq!(split_err(1, &[1, 2], &[]), CoreError::ThresholdTooLow);
    }

    /// `split` zwraca `Vec<Share>`, a `Share` celowo nie ma `Debug`;
    /// dlatego błąd wyciągamy bez `unwrap_err`.
    fn split_err(secret: u8, xs: &[u8], coeffs: &[u8]) -> CoreError {
        match split(secret, xs, coeffs) {
            Ok(_) => panic!("expected split error"),
            Err(e) => e,
        }
    }

    #[test]
    fn reconstruct_rejects_invalid_inputs() {
        let shares = split(0x42, &[1, 2, 3], &[0x11]).expect("split");
        assert_eq!(
            reconstruct(&shares[..1], 2).unwrap_err(),
            CoreError::InsufficientShares
        );
        let dup = vec![Share::new(1, 1).expect("x"), Share::new(1, 2).expect("x")];
        assert_eq!(reconstruct(&dup, 2).unwrap_err(), CoreError::DuplicateX);
    }

    #[test]
    fn reconstruct_checks_consistency_above_k() {
        let mut shares = split(0x42, &[1, 2, 3], &[0x11]).expect("split");
        shares[2] = Share::new(3, 0x70).expect("x");
        assert_eq!(
            reconstruct(&shares, 2).unwrap_err(),
            CoreError::InconsistentShare
        );
    }
}
