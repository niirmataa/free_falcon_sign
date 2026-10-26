//! Jednorazowe maski otwarć w `Z_P` (WP-015, D-025).
//!
//! **Problem (audyt #4).** Otwarcie wartości przez sumę z maską jest
//! bezpieczne tylko wtedy, gdy maska jest świeża i ma **niezależną
//! szerokość** od otwieranej wartości. Maski w `Z_q` (`q ≈ 2^14`) są zbyt
//! wąskie — ujawniają górne bity. Dlatego maski żyją wyłącznie w `Z_P`
//! (`P = 2^61−1`) i każda wartość ma własną, świeżą maskę.
//!
//! **Model liniowy.** [`Mask`] nie jest `Clone`/`Copy`, a [`Mask::apply`]
//! konsumuje maskę. Dwa otwarcia tego samego sekretu wymagają dwóch
//! niezależnych masek — nie da się „przypadkiem” użyć tej samej.
//!
//! **Szerokości.** [`Mask::from_entropy_bits`] daje dokładnie jednostajną
//! maskę w `[0, 2^bits)` dla `bits ≤ 60` (128-bitowe wejście dzieli się
//! przez `2^bits` bez reszty). Pełne pole (`bits = 61`) używa redukcji
//! `128-bit % P`; obciążenie jest ograniczone przez `2^128 / P ≥ 2^67`,
//! czyli względnie `< 2^-67` — pomijalne statystycznie, jawnie opisane
//! w teście `full_width_mask_bias_bound` i w dowodzie WP-015.
//!
//! **Granica:** to prymityw maskowania, nie protokół. Kto i kiedy otwiera
//! maskę, w jakiej rundzie i z jakim MAC, należy do warstwy protokołu
//! (WP-030+). Ten moduł nie twierdzi, że zastępuje auth-triples.
//!
//! Maska nie jest `Clone`:
//! ```compile_fail
//! use ft_threshold_core::mask::Mask;
//! let m = Mask::from_entropy(&[7u8; 16]);
//! let _copy = m.clone();
//! ```

use zeroize::{Zeroize, ZeroizeOnDrop};

use crate::error::{CoreError, Result};
use crate::zp::{self, P};

/// Maksymalna szerokość maski: pełne `Z_P` (`P < 2^61`).
pub const MASK_BITS_MAX: u8 = 61;

/// Jednorazowa maska w `Z_P`; wartość jest czyszczona przy dropie.
///
/// Brak `Clone`/`Copy` jest celowy (audyt #11): kopia maski to ponowne
/// użycie jednorazowego padu.
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct Mask {
    value: u64,
    bits: u8,
}

impl std::fmt::Debug for Mask {
    /// `Debug` **nie** pokazuje wartości maski — dopóki nie zostanie
    /// świadomie otwarta, jest materiałem poufnym.
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Mask")
            .field("bits", &self.bits)
            .finish_non_exhaustive()
    }
}

impl Mask {
    /// Pełnowymiarowa maska `Z_P` z 128 bitów entropii.
    ///
    /// Redukcja `% P` ma obciążenie względne `< 2^-67` (patrz dokumentacja
    /// modułu). Do maskowania wartości w całym `Z_P`.
    pub fn from_entropy(bytes: &[u8; 16]) -> Self {
        let wide = u128::from_le_bytes(*bytes) % u128::from(P);
        // `wide < P < 2^61`, więc konwersja jest dokładna.
        Self {
            value: u64::try_from(wide).expect("wide < P < 2^61"),
            bits: MASK_BITS_MAX,
        }
    }

    /// Maska o wybranej szerokości `bits` (`1..=60`) z 128 bitów entropii.
    ///
    /// Dla `bits ≤ 60` rozkład jest **dokładnie** jednostajny na
    /// `[0, 2^bits)`: `2^128` jest podzielne przez `2^bits`.
    /// `bits = 61` deleguje do [`Mask::from_entropy`] (pełne `Z_P`).
    pub fn from_entropy_bits(bytes: &[u8; 16], bits: u8) -> Result<Self> {
        if !(1..=MASK_BITS_MAX).contains(&bits) {
            return Err(CoreError::OutOfRange);
        }
        if bits == MASK_BITS_MAX {
            return Ok(Self::from_entropy(bytes));
        }
        let modulus = 1u128 << bits;
        let wide = u128::from_le_bytes(*bytes) % modulus;
        Ok(Self {
            value: u64::try_from(wide).expect("wide < 2^60"),
            bits,
        })
    }

    /// Maska z wartości kanonicznej — **tylko** KAT/testy; nie jest źródłem
    /// losowości i nie może być używana w protokole.
    pub fn from_canonical(value: u64, bits: u8) -> Result<Self> {
        if !(1..=MASK_BITS_MAX).contains(&bits) {
            return Err(CoreError::OutOfRange);
        }
        if bits == MASK_BITS_MAX {
            if value >= P {
                return Err(CoreError::OutOfRange);
            }
        } else if value >= (1u64 << bits) {
            return Err(CoreError::OutOfRange);
        }
        Ok(Self { value, bits })
    }

    /// Szerokość maski w bitach (`1..=61`).
    pub fn bits(&self) -> u8 {
        self.bits
    }

    /// Wartość maski. Jawienie się maski jest częścią otwarcia; nie logować
    /// przed decyzją protokołu.
    pub fn value(&self) -> u64 {
        self.value
    }

    /// `secret + mask` w `Z_P` (maska jest konsumowana).
    ///
    /// Dla `bits < 61` wymagamy `secret < 2^bits`: węższa maska nie ukrywa
    /// górnych bitów szerszej wartości, więc takie użycie jest błędem, nie
    /// „prawie poprawnym” wynikiem.
    pub fn apply(self, secret: u64) -> Result<u64> {
        let bound = if self.bits == MASK_BITS_MAX {
            P
        } else {
            1u64 << self.bits
        };
        if secret >= bound {
            return Err(CoreError::OutOfRange);
        }
        if self.bits == MASK_BITS_MAX {
            Ok(zp::add(secret, self.value))
        } else {
            // `secret + value < 2·2^60 ≤ P − 1` dla bits ≤ 60.
            Ok(secret + self.value)
        }
    }

    /// `masked − mask` w `Z_P`; odwrotność [`Mask::apply`].
    pub fn remove(self, masked: u64) -> Result<u64> {
        if masked >= P {
            return Err(CoreError::OutOfRange);
        }
        let bound = if self.bits == MASK_BITS_MAX {
            P
        } else {
            1u64 << self.bits
        };
        let plain = zp::sub(masked, self.value);
        if plain >= bound {
            return Err(CoreError::OutOfRange);
        }
        Ok(plain)
    }
}

#[cfg(test)]
mod tests {
    use super::{MASK_BITS_MAX, Mask};
    use crate::error::CoreError;
    use crate::zp::{self, P};
    use sha3::{Digest, Sha3_256};

    /// Deterministyczna entropia do testów statystycznych (nie produkcja).
    fn entropy(seed: u8, i: u32) -> [u8; 16] {
        let mut h = Sha3_256::new();
        h.update([seed]);
        h.update(i.to_le_bytes());
        let digest = h.finalize();
        let mut out = [0u8; 16];
        out.copy_from_slice(&digest[..16]);
        out
    }

    fn chi_square_buckets(values: &[u64], buckets: usize, domain: u128) -> f64 {
        let mut counts = vec![0u64; buckets];
        for &v in values {
            let idx = usize::try_from(u128::from(v) * buckets as u128 / domain)
                .expect("bucket fits usize");
            counts[idx] += 1;
        }
        let expected = values.len() as f64 / buckets as f64;
        counts
            .iter()
            .map(|&c| {
                let d = c as f64 - expected;
                d * d / expected
            })
            .sum()
    }

    fn pearson(xs: &[u64], ys: &[u64]) -> f64 {
        let n = xs.len() as f64;
        let mx = xs.iter().map(|&x| x as f64).sum::<f64>() / n;
        let my = ys.iter().map(|&y| y as f64).sum::<f64>() / n;
        let mut sxy = 0.0;
        let mut sxx = 0.0;
        let mut syy = 0.0;
        for (&x, &y) in xs.iter().zip(ys) {
            let dx = x as f64 - mx;
            let dy = y as f64 - my;
            sxy += dx * dy;
            sxx += dx * dx;
            syy += dy * dy;
        }
        sxy / (sxx * syy).sqrt()
    }

    #[test]
    fn full_width_mask_bias_bound() {
        // 2^128 = k·P + r; każda reszta ma k albo k+1 przeciwobrazów,
        // więc względne obciążenie ≤ 1/k. k = floor(2^128 / P) ≥ 2^67.
        let k = u128::MAX / u128::from(P);
        assert!(k >= (1u128 << 67), "k = {k}");
    }

    #[test]
    #[cfg_attr(
        miri,
        ignore = "statystyka 4096 masek + SHA3 jest zbyt wolna w Miri; logikę maskowania pokrywają testy natywne"
    )]
    fn full_width_masks_are_unique_and_span_the_field() {
        let n = 4096u32;
        let mut values = Vec::with_capacity(n as usize);
        for i in 0..n {
            let m = Mask::from_entropy(&entropy(1, i));
            assert_eq!(m.bits(), MASK_BITS_MAX);
            assert!(m.value() < P);
            values.push(m.value());
        }
        let mut sorted = values.clone();
        sorted.sort_unstable();
        sorted.dedup();
        assert_eq!(sorted.len(), values.len(), "maska powtórzona");

        let min = *values.iter().min().expect("non-empty");
        let max = *values.iter().max().expect("non-empty");
        // Pełna szerokość 61 bitów: próbka musi sięgać obu połówek ciała.
        assert!(min < P / 2);
        assert!(max > P / 2);
        // 16 kubełków, df = 15; próg 45 jest bardzo luźny (p ≪ 0.001),
        // ale deterministyczna próbka i tak daje stabilny wynik.
        let chi = chi_square_buckets(&values, 16, u128::from(P));
        assert!(chi < 45.0, "chi² = {chi}");
    }

    #[test]
    #[cfg_attr(
        miri,
        ignore = "statystyka 10 tys. masek + SHA3 jest zbyt wolna w Miri; logikę maskowania pokrywają testy natywne"
    )]
    fn narrow_masks_are_uniform_and_widths_are_independent() {
        for bits in [1u8, 2, 14, 30, 60] {
            let domain = 1u128 << bits;
            let n = 2048u32;
            let mut values = Vec::with_capacity(n as usize);
            for i in 0..n {
                let m = Mask::from_entropy_bits(&entropy(2 + bits, i), bits).expect("mask");
                assert_eq!(m.bits(), bits);
                assert!(u128::from(m.value()) < domain);
                values.push(m.value());
            }
            let buckets = 16.min(1usize << bits);
            let chi = chi_square_buckets(&values, buckets, domain);
            assert!(chi < 45.0, "bits={bits}, chi² = {chi}");
        }
        assert_eq!(
            Mask::from_entropy_bits(&[0u8; 16], 0).unwrap_err(),
            CoreError::OutOfRange
        );
        assert_eq!(
            Mask::from_entropy_bits(&[0u8; 16], 62).unwrap_err(),
            CoreError::OutOfRange
        );
    }

    #[test]
    #[cfg_attr(
        miri,
        ignore = "statystyka 2048 otwarć + SHA3 jest zbyt wolna w Miri; logikę maskowania pokrywają testy natywne"
    )]
    fn two_openings_of_the_same_secret_do_not_correlate() {
        // Otwarcie 1: pełnowymiarowa maska. Otwarcie 2: inna, świeża maska
        // o innej szerokości. Ten sam sekret (14 bitów) w obu.
        let secret = 12_345u64;
        let n = 2048u32;
        let mut a = Vec::with_capacity(n as usize);
        let mut b = Vec::with_capacity(n as usize);
        for i in 0..n {
            let m1 = Mask::from_entropy(&entropy(10, i));
            let m2 = Mask::from_entropy_bits(&entropy(11, i), 30).expect("mask");
            let a_i = m1.apply(secret).expect("open 1");
            let b_i = m2.apply(secret).expect("open 2");
            assert!(a_i < P);
            assert!(b_i < (1u64 << 30));
            a.push(a_i);
            b.push(b_i);
        }
        let mut sorted = a.clone();
        sorted.sort_unstable();
        sorted.dedup();
        assert_eq!(sorted.len(), a.len(), "powtórzone otwarcie 1");
        // Różne dziedziny: porównujemy unormowane wartości (a/P, b/2^30).
        // Brak korelacji liniowej między dwoma otwarciami tego samego sekretu.
        let corr = pearson(&a, &b);
        assert!(corr.abs() < 0.05, "corr = {corr}");
        // Otwarcia nie są stałym przesunięciem: różnica (mod P) też jest
        // szeroko rozłożona, a nie skupiona w jednym punkcie.
        let diffs: Vec<u64> = a.iter().zip(&b).map(|(&x, &y)| zp::sub(x, y)).collect();
        let mut ds = diffs.clone();
        ds.sort_unstable();
        ds.dedup();
        assert!(ds.len() > n as usize / 2, "różnice zbyt skoncentrowane");
        let chi = chi_square_buckets(&diffs, 16, u128::from(P));
        assert!(chi < 45.0, "chi² różnic = {chi}");
    }

    #[test]
    fn apply_remove_roundtrip_and_domain_checks() {
        let m = Mask::from_entropy(&entropy(20, 0));
        let mask = m.value();
        let masked = m.apply(1_234).expect("apply");
        assert_eq!(zp::sub(masked, mask), 1_234);
        // `remove` konsumuje inną maskę o tej samej wartości.
        let m2 = Mask::from_canonical(mask, MASK_BITS_MAX).expect("canonical");
        assert_eq!(m2.remove(masked).expect("remove"), 1_234);

        let narrow = Mask::from_entropy_bits(&entropy(21, 0), 14).expect("mask");
        assert_eq!(narrow.apply(1u64 << 14).unwrap_err(), CoreError::OutOfRange);

        let narrow = Mask::from_entropy_bits(&entropy(22, 0), 14).expect("mask");
        let narrow_value = narrow.value();
        let out = narrow.apply(16_383).expect("apply 14-bit");
        assert!(out < (1u64 << 15));
        let reopen = Mask::from_canonical(narrow_value, 14).expect("canonical");
        assert_eq!(reopen.remove(out).expect("remove"), 16_383);

        let full = Mask::from_entropy(&entropy(23, 0));
        assert_eq!(full.apply(P).unwrap_err(), CoreError::OutOfRange);
        let full = Mask::from_entropy(&entropy(24, 0));
        assert_eq!(full.remove(P).unwrap_err(), CoreError::OutOfRange);
    }

    #[test]
    fn debug_does_not_reveal_mask() {
        let value = 0x1234_5678_9abcu64;
        let m = Mask::from_canonical(value, MASK_BITS_MAX).expect("canonical");
        let text = format!("{m:?}");
        assert!(text.contains("Mask"));
        assert!(!text.contains("value"));
        assert!(!text.contains(&value.to_string()));
    }

    #[test]
    fn canonical_constructor_rejects_out_of_range() {
        assert_eq!(
            Mask::from_canonical(P, MASK_BITS_MAX).unwrap_err(),
            CoreError::OutOfRange
        );
        assert_eq!(
            Mask::from_canonical(1 << 14, 14).unwrap_err(),
            CoreError::OutOfRange
        );
        assert_eq!(
            Mask::from_canonical(0, 0).unwrap_err(),
            CoreError::OutOfRange
        );
    }
}
