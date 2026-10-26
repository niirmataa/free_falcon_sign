//! Fail-closed sampler odrzuceń (WP-021, audyt #16).
//!
//! Każdy sampler ma **twardy cap prób**. Po jego wyczerpaniu zwraca
//! [`CoreError::AttemptsExhausted`] — nie ma typu wyniku częściowego ani
//! „awaryjnego” `Ok` z odrzuconą próbką. To naprawia wzorzec fail-open
//! znany ze spike'a (`SampleOutcome` po capie).
//!
//! `uniform_below` używa klasycznego rejection sampling: odrzuca ogon
//! `[limit, 2^64)`, więc wynik jest **bez modulo bias** (w przeciwieństwie
//! do `u64 % bound`).
//!
//! **Granica:** to deterministyczny mechanizm liczenia prób i akceptacji.
//! Źródło losowości (OS CSPRNG, XOF, PRSS) dostarcza wołający; ten moduł
//! nie twierdzi nic o jakości entropii.

use crate::error::{CoreError, Result};

/// Domyślny cap prób samplerów v1 (2^20).
pub const DEFAULT_MAX_ATTEMPTS: u32 = 1 << 20;

/// Licznik prób z twardym capem; po capie **zawsze** `Err`.
#[derive(Debug)]
pub struct RejectionSampler {
    attempts: u32,
    max_attempts: u32,
}

impl RejectionSampler {
    /// Nowy sampler; `max_attempts = 0` jest błędem (nie „nieskończoność”).
    pub fn new(max_attempts: u32) -> Result<Self> {
        if max_attempts == 0 {
            return Err(CoreError::InvalidInput);
        }
        Ok(Self {
            attempts: 0,
            max_attempts,
        })
    }

    /// Liczba dotychczasowych prób.
    pub fn attempts(&self) -> u32 {
        self.attempts
    }

    /// Pozostały budżet prób.
    pub fn remaining(&self) -> u32 {
        self.max_attempts - self.attempts
    }

    /// Losuje i akceptuje, dopóki `accept` nie zwróci `true`.
    ///
    /// Po `max_attempts` odrzuceń → [`CoreError::AttemptsExhausted`].
    /// `next` jest wołane dokładnie raz na próbę.
    pub fn draw<T>(
        &mut self,
        mut next: impl FnMut() -> T,
        mut accept: impl FnMut(&T) -> bool,
    ) -> Result<T> {
        while self.attempts < self.max_attempts {
            self.attempts += 1;
            let value = next();
            if accept(&value) {
                return Ok(value);
            }
        }
        Err(CoreError::AttemptsExhausted)
    }

    /// Jednostajnie losuje w `0..bound` bez modulo bias.
    ///
    /// `bound = 0` → `InvalidInput`. Odrzucane są wartości z ogona
    /// `[u64::MAX − (u64::MAX mod bound), u64::MAX]`, więc każda reszta
    /// ma tę samą liczbę przeciwobrazów.
    pub fn uniform_below(&mut self, bound: u64, mut next: impl FnMut() -> u64) -> Result<u64> {
        if bound == 0 {
            return Err(CoreError::InvalidInput);
        }
        let tail = u64::MAX % bound;
        let limit = u64::MAX - tail;
        let v = self.draw(&mut next, |&v| v < limit)?;
        Ok(v % bound)
    }
}

#[cfg(test)]
mod tests {
    use super::{DEFAULT_MAX_ATTEMPTS, RejectionSampler};
    use crate::error::CoreError;

    #[test]
    fn cap_is_hard_and_fail_closed() {
        let mut s = RejectionSampler::new(3).expect("sampler");
        let mut calls = 0u32;
        let err = s
            .draw(
                || {
                    calls += 1;
                    1u32
                },
                |_| false,
            )
            .unwrap_err();
        assert_eq!(err, CoreError::AttemptsExhausted);
        assert_eq!(s.attempts(), 3);
        assert_eq!(s.remaining(), 0);
        assert_eq!(calls, 3);
        // Kolejne wołanie nadal Err, bez „cichego” resetu.
        assert_eq!(
            s.draw(|| 1u32, |_| true).unwrap_err(),
            CoreError::AttemptsExhausted
        );
    }

    #[test]
    fn accepts_after_rejections_and_counts_each_draw() {
        let mut s = RejectionSampler::new(10).expect("sampler");
        let mut n = 0u32;
        let v = s
            .draw(
                || {
                    n += 1;
                    n
                },
                |&v| v == 4,
            )
            .expect("accept 4");
        assert_eq!(v, 4);
        assert_eq!(s.attempts(), 4);
        assert_eq!(s.remaining(), 6);
        assert_eq!(DEFAULT_MAX_ATTEMPTS, 1 << 20);
    }

    #[test]
    fn zero_cap_and_zero_bound_are_rejected() {
        assert_eq!(
            RejectionSampler::new(0).unwrap_err(),
            CoreError::InvalidInput
        );
        let mut s = RejectionSampler::new(8).expect("sampler");
        assert_eq!(
            s.uniform_below(0, || 0).unwrap_err(),
            CoreError::InvalidInput
        );
    }

    #[test]
    fn uniform_below_rejects_tail_and_stays_in_range() {
        let bound = 7u64;
        let tail = u64::MAX % bound;
        let limit = u64::MAX - tail;
        let mut values = vec![u64::MAX, limit, limit - 1, 0, 13, 6];
        let mut s = RejectionSampler::new(16).expect("sampler");
        let v = s
            .uniform_below(bound, || values.remove(0))
            .expect("uniform");
        assert!(v < bound);
        assert_eq!(v, 6); // limit ≡ 0 (mod 7), więc limit − 1 ≡ 6
        assert_eq!(s.attempts(), 3);
        // Wyczerpanie, gdy wszystkie wartości są w ogonie.
        let mut s = RejectionSampler::new(2).expect("sampler");
        assert_eq!(
            s.uniform_below(bound, || u64::MAX).unwrap_err(),
            CoreError::AttemptsExhausted
        );
    }

    #[test]
    fn uniform_below_distribution_is_flat() {
        let bound = 7u64;
        let mut state = 0x243f_6a88_85a3_08d3u64;
        let mut buckets = [0u32; 7];
        let mut s = RejectionSampler::new(100_000).expect("sampler");
        for _ in 0..10_000 {
            let v = s
                .uniform_below(bound, || {
                    state ^= state << 13;
                    state ^= state >> 7;
                    state ^= state << 17;
                    state
                })
                .expect("uniform");
            buckets[v as usize] += 1;
        }
        let expected = 10_000.0 / 7.0;
        let chi: f64 = buckets
            .iter()
            .map(|&c| {
                let d = f64::from(c) - expected;
                d * d / expected
            })
            .sum();
        // df = 6; próg 25 jest bardzo luźny, próbka deterministyczna.
        assert!(chi < 25.0, "chi² = {chi}");
        assert_eq!(buckets.iter().sum::<u32>(), 10_000);
    }
}
