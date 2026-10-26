//! Pierścień `R_q = Z_q[X]/(X^N - X^{N/2} + 1)` dla FT1536.
//!
//! Parametry: `q = 18433`, `N = 1536`, `N/2 = 768` (profil `logn = 10`).
//! To jest pierścień współczynników `f, g, F, G, h, s1, s2` w podpisie
//! FT1536. Arytmetyka jest **szkolna** (poprawna, bez NTT); NTT i zgodność
//! reprezentacji z silnikiem wchodzą jako osobny krok WP-012.
//!
//! Redukcja: `X^N = X^{N/2} - 1`, czyli `X^{2m} = X^m - 1` dla `m = N/2`.
//! Dla `e >= N`: `X^e = X^{e-m} - X^{e-2m}`.
//!
//! **Granica:** wartości `Poly` mogą być sekretne (udziały). Typ nie ma
//! `Debug`/`Clone`; porównanie jawnych współczynników wymaga `ct_eq`
//! (stały przepływ). Zeroizacja przez `ZeroizeOnDrop`.

use zeroize::{Zeroize, ZeroizeOnDrop};

use crate::error::{CoreError, Result};

/// Modulus pierścienia FT1536.
pub const Q: u16 = 18433;

/// Stopień pierścienia (`logn = 10`).
pub const N: usize = 1536;

/// `N/2` — wykładnik członu redukcji.
pub const HALF_N: usize = N / 2;

/// Dodawanie modulo `Q` (argumenty dowolne, wynik w `0..Q`).
#[inline]
pub fn add_mod(a: u16, b: u16) -> u16 {
    ((a as u32 + b as u32) % Q as u32) as u16
}

/// Odejmowanie modulo `Q` (argumenty dowolne, wynik w `0..Q`).
#[inline]
pub fn sub_mod(a: u16, b: u16) -> u16 {
    ((a as u32 + Q as u32 - (b as u32 % Q as u32)) % Q as u32) as u16
}

/// Mnożenie modulo `Q`.
#[inline]
pub fn mul_mod(a: u16, b: u16) -> u16 {
    ((a as u32 * b as u32) % Q as u32) as u16
}

/// Odwrotność modulo `Q`; `None` dla zera (Fermat, `q` pierwsze).
pub fn inv_mod(a: u16) -> Option<u16> {
    let a = a % Q;
    if a == 0 {
        return None;
    }
    let mut r = 1u32;
    let mut b = a as u32;
    let mut e = Q as u32 - 2;
    while e > 0 {
        if e & 1 == 1 {
            r = (r * b) % Q as u32;
        }
        b = (b * b) % Q as u32;
        e >>= 1;
    }
    Some(r as u16)
}

/// Element pierścienia `R_q` (współczynniki w `0..Q`).
///
/// Brak `Clone`/`Copy`/`Debug`: przypadkowe kopiowanie sekretnego
/// wielomianu jest błędem. Konstrukcja przez [`Poly::from_coeffs`] lub
/// [`Poly::zero`].
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct Poly {
    coeffs: [u16; N],
}

impl Poly {
    /// Wielomian zerowy.
    pub fn zero() -> Self {
        Self { coeffs: [0u16; N] }
    }

    /// Buduje wielomian z dokładnie `N` współczynników w `0..Q`.
    pub fn from_coeffs(coeffs: &[u16]) -> Result<Self> {
        if coeffs.len() != N {
            return Err(CoreError::InvalidLength);
        }
        if coeffs.iter().any(|&c| c >= Q) {
            return Err(CoreError::OutOfRange);
        }
        let mut out = [0u16; N];
        out.copy_from_slice(coeffs);
        Ok(Self { coeffs: out })
    }

    /// Współczynnik przy `X^i` (dla `i < N`).
    pub fn coeff(&self, i: usize) -> Option<u16> {
        self.coeffs.get(i).copied()
    }

    /// Wszystkie współczynniki (kolejność od `X^0`).
    pub fn coeffs(&self) -> &[u16; N] {
        &self.coeffs
    }

    /// `self + rhs` w `R_q`.
    pub fn add(&self, rhs: &Self) -> Self {
        let mut out = [0u16; N];
        for ((o, &a), &b) in out
            .iter_mut()
            .zip(self.coeffs.iter())
            .zip(rhs.coeffs.iter())
        {
            *o = add_mod(a, b);
        }
        Self { coeffs: out }
    }

    /// `self - rhs` w `R_q`.
    pub fn sub(&self, rhs: &Self) -> Self {
        let mut out = [0u16; N];
        for ((o, &a), &b) in out
            .iter_mut()
            .zip(self.coeffs.iter())
            .zip(rhs.coeffs.iter())
        {
            *o = sub_mod(a, b);
        }
        Self { coeffs: out }
    }

    /// `-self` w `R_q`.
    pub fn neg(&self) -> Self {
        let mut out = [0u16; N];
        for (o, &c) in out.iter_mut().zip(self.coeffs.iter()) {
            *o = sub_mod(0, c);
        }
        Self { coeffs: out }
    }

    /// Mnożenie przez skalar z `Z_q`.
    pub fn scalar_mul(&self, k: u16) -> Self {
        let k = k % Q;
        let mut out = [0u16; N];
        for (o, &c) in out.iter_mut().zip(self.coeffs.iter()) {
            *o = mul_mod(c, k);
        }
        Self { coeffs: out }
    }

    /// Mnożenie w `R_q` (szkolne, z redukcją `X^N = X^{N/2} - 1`).
    ///
    /// Złożoność `O(N^2)`; wersja NTT przyjdzie w kolejnym kroku WP-012.
    pub fn mul(&self, rhs: &Self) -> Self {
        let mut acc = vec![0u64; 2 * N - 1];
        for i in 0..N {
            let ai = self.coeffs[i] as u64;
            if ai == 0 {
                continue;
            }
            for j in 0..N {
                acc[i + j] += ai * rhs.coeffs[j] as u64;
            }
        }

        let mut c = vec![0u16; 2 * N - 1];
        for (k, &v) in acc.iter().enumerate() {
            c[k] = (v % Q as u64) as u16;
        }

        // Malejąco: X^e = X^{e-m} - X^{e-2m}. Cel e-m może być >= N,
        // ale jest mniejszy od e, więc zostanie zredukowany później.
        for e in (N..2 * N - 1).rev() {
            let v = c[e];
            if v == 0 {
                continue;
            }
            c[e - HALF_N] = add_mod(c[e - HALF_N], v);
            c[e - N] = sub_mod(c[e - N], v);
            c[e] = 0;
        }

        let mut out = [0u16; N];
        out.copy_from_slice(&c[..N]);
        Self { coeffs: out }
    }

    /// Mnożenie przez `X` (przesunięcie + redukcja `X^N`).
    pub fn mul_by_x(&self) -> Self {
        let mut out = [0u16; N];
        out[1..].copy_from_slice(&self.coeffs[..N - 1]);
        let top = self.coeffs[N - 1];
        out[HALF_N] = add_mod(out[HALF_N], top);
        out[0] = sub_mod(out[0], top);
        Self { coeffs: out }
    }

    /// Czy wszystkie współczynniki są zerowe (stały przepływ).
    pub fn is_zero(&self) -> bool {
        let mut acc = 0u16;
        for &c in &self.coeffs {
            acc |= c;
        }
        acc == 0
    }

    /// Porównanie w stałym przepływie (bez wczesnego wyjścia).
    pub fn ct_eq(&self, rhs: &Self) -> bool {
        let mut diff = 0u16;
        for i in 0..N {
            diff |= self.coeffs[i] ^ rhs.coeffs[i];
        }
        diff == 0
    }
}

#[cfg(test)]
mod tests {
    use super::{HALF_N, N, Poly, Q, inv_mod, mul_mod};
    use crate::error::CoreError;

    fn poly_from_fn(f: impl Fn(usize) -> u16) -> Poly {
        let coeffs: Vec<u16> = (0..N).map(f).collect();
        Poly::from_coeffs(&coeffs).expect("valid coefficients")
    }

    fn monomial(degree: usize, value: u16) -> Poly {
        let mut c = vec![0u16; N];
        c[degree] = value;
        Poly::from_coeffs(&c).expect("valid monomial")
    }

    fn assert_coeffs(p: &Poly, expected: &[(usize, u16)]) {
        for i in 0..N {
            let want = expected
                .iter()
                .find_map(|&(j, v)| (i == j).then_some(v))
                .unwrap_or(0);
            assert_eq!(p.coeff(i), Some(want), "coefficient {i}");
        }
    }

    #[test]
    fn add_sub_neg_are_inverse() {
        let a = poly_from_fn(|i| ((7 * i + 3) % Q as usize) as u16);
        let b = poly_from_fn(|i| ((13 * i + 5) % Q as usize) as u16);
        let sum = a.add(&b);
        let back = sum.sub(&b);
        assert!(back.ct_eq(&a));
        let neg = a.neg();
        assert!((a.add(&neg)).is_zero());
    }

    #[test]
    #[cfg_attr(miri, ignore = "O(N^2) szkolne mnożenie jest zbyt wolne pod Miri")]
    fn mul_identity_and_zero() {
        let one = monomial(0, 1);
        let zero = Poly::zero();
        let a = poly_from_fn(|i| ((i * i + 11) % Q as usize) as u16);
        assert!(a.mul(&one).ct_eq(&a));
        assert!((a.mul(&zero)).is_zero());
        assert!((zero.mul(&a)).is_zero());
    }

    #[test]
    #[cfg_attr(miri, ignore = "O(N^2) szkolne mnożenie jest zbyt wolne pod Miri")]
    fn mul_by_x_matches_monomial_mul_on_sample() {
        let a = poly_from_fn(|i| ((5 * i + 9) % Q as usize) as u16);
        let x = monomial(1, 1);
        let via_mul = a.mul(&x);
        let via_shift = a.mul_by_x();
        assert!(via_mul.ct_eq(&via_shift));
    }

    #[test]
    #[cfg_attr(miri, ignore = "O(N^2) szkolne mnożenie jest zbyt wolne pod Miri")]
    fn ring_identity_xn() {
        // X^N = X^{N/2} - 1.
        let x = monomial(1, 1);
        let mut p = monomial(0, 1);
        for _ in 0..N {
            p = p.mul_by_x();
        }
        assert_coeffs(&p, &[(0, Q - 1), (HALF_N, 1)]);
        assert!(p.ct_eq(&x.mul(&monomial(N - 1, 1))));
    }

    #[test]
    #[cfg_attr(miri, ignore = "O(N^2) szkolne mnożenie jest zbyt wolne pod Miri")]
    fn ring_identity_x_has_order_6n_over_2() {
        // X^{6m} = 1 dla m = N/2, czyli X^{3N} = 1.
        let mut p = monomial(0, 1);
        for _ in 0..(3 * N) {
            p = p.mul_by_x();
        }
        assert_coeffs(&p, &[(0, 1)]);
    }

    #[test]
    #[cfg_attr(miri, ignore = "O(N^2) szkolne mnożenie jest zbyt wolne pod Miri")]
    fn mul_matches_independent_reference_kat() {
        // KAT z `ci/kat/ring_reference.py`: a_i=7i+3, b_i=13i+5 mod q.
        let a = poly_from_fn(|i| ((7 * i + 3) % Q as usize) as u16);
        let b = poly_from_fn(|i| ((13 * i + 5) % Q as usize) as u16);
        let c = a.mul(&b);
        let first8: Vec<u16> = (0..8).map(|i| c.coeff(i).expect("i<N")).collect();
        assert_eq!(
            first8,
            vec![9373, 8988, 8311, 7615, 7173, 7258, 8143, 10101]
        );

        let mut fnv = 0xcbf2_9ce4_8422_2325u64;
        for &v in c.coeffs() {
            for byte in [v as u8, (v >> 8) as u8] {
                fnv ^= byte as u64;
                fnv = fnv.wrapping_mul(0x0000_0100_0000_01b3);
            }
        }
        assert_eq!(fnv, 0x8151_1cf3_e5d1_b19d);
    }

    #[test]
    fn mod_helpers_are_consistent() {
        assert_eq!(mul_mod(18432, 18432), 1); // (-1)^2
        assert_eq!(inv_mod(0), None);
        for a in 1u16..=255 {
            let inv = inv_mod(a).expect("nonzero");
            assert_eq!(mul_mod(a, inv), 1, "a={a}");
        }
    }

    fn poly_err(coeffs: &[u16]) -> CoreError {
        match Poly::from_coeffs(coeffs) {
            Ok(_) => panic!("expected poly error"),
            Err(e) => e,
        }
    }

    #[test]
    fn from_coeffs_rejects_bad_input() {
        assert_eq!(poly_err(&[0u16; N - 1]), CoreError::InvalidLength);
        let mut c = vec![0u16; N];
        c[0] = Q;
        assert_eq!(poly_err(&c), CoreError::OutOfRange);
    }
}
