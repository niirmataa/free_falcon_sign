//! SPDZ-style MAC z **ukrytym** δ nad `Z_P` (WP-013, D-025).
//!
//! Audyt #9 (G-2) wykazał, że ścieżka z jawnym `delta_known` jest
//! obejściem: kto zna δ, ten może podmienić udział `x → x+Δ` i MAC
//! `m → m+δ·Δ`, a kontrola przejdzie. W v1 δ **nie występuje** w API:
//! jest tylko w udziałach [`DeltaShares`] i nigdy nie jest rekonstruowane
//! w ścieżce podpisu.
//!
//! **Dlaczego to działa (i czego nie twierdzi):** strona zna tylko swój
//! udział `δ_i`, nie globalne δ. Przesunięcie własnego udziału o `Δ`
//! wymaga dla spójności `Δ·δ` w MAC, a nie `Δ·δ_i`; przy `k` udziałach
//! rekonstrukcja wartości zmienia się o `λ_i·Δ`, więc kompensacja musi
//! użyć globalnego δ. Bez δ podstawienie jest wykrywane jako `MacFail`.
//! To **nie** jest malicious-secure/UC: nie wykrywa błędów, które nie
//! naruszają relacji `mac = δ·share` (np. błędy w samym obwodzie przed
//! współdzieleniem) — te należą do kontroli na wynikach obliczeń
//! (auth triples, WP-016).
//!
//! Protokół otwarcia (`open_checked`):
//!
//! 1. rekonstrukcja wartości `v` z `k` udziałów Shamir w `Z_P`,
//! 2. `z_i = mac_i − v·δ_i (mod P)` — udziały zera, gdy MAC poprawny,
//! 3. rekonstrukcja `z`; `z ≠ 0` → [`CoreError::MacFail`].
//!
//! **Granica:** to komponent MAC, nie protokół. Tworzenie udziałów MAC
//! dla iloczynów (auth triples) i DKG wartości należy do WP-016; ten
//! moduł nie ma konstruktora z „zaufanym dealerem” w API produkcyjnym
//! (`share_with_mac_testkit` istnieje wyłącznie w testach).
//!
//! **Model:** półuczciwe obliczenia + detekcja na otwarciach. To **nie**
//! jest malicious-secure/UC i nie zastępuje O-02/O-16.

use zeroize::{Zeroize, ZeroizeOnDrop};

use crate::MAX_PARTIES_V1;
use crate::error::{CoreError, Result};
use crate::zp::{self, P};

/// Udział wartości z MAC: `(x, share, mac)`, gdzie `mac = δ·share` w `Z_P`
/// w sensie współdzielenia (nie lokalnej równości — δ też jest podzielone).
#[derive(Clone, Zeroize, ZeroizeOnDrop)]
pub struct MacShare {
    x: u16,
    share: u64,
    mac: u64,
}

impl std::fmt::Debug for MacShare {
    /// Debug **nie** pokazuje `share` ani `mac` (materiał poufny).
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("MacShare")
            .field("x", &self.x)
            .finish_non_exhaustive()
    }
}

impl MacShare {
    /// Tworzy udział; `x` musi być poprawnym punktem, wartości `< P`.
    pub fn new(x: u16, share: u64, mac: u64) -> Result<Self> {
        if x == 0 {
            return Err(CoreError::XZero);
        }
        if x >= crate::ring::Q {
            return Err(CoreError::OutOfRange);
        }
        if share >= P || mac >= P {
            return Err(CoreError::OutOfRange);
        }
        Ok(Self { x, share, mac })
    }

    /// Punkt ewaluacji.
    pub fn x(&self) -> u16 {
        self.x
    }

    /// Udział wartości (jawny w tej warstwie; pole jest czyszczone przy dropie).
    pub fn share(&self) -> u64 {
        self.share
    }

    /// Udział MAC.
    pub fn mac(&self) -> u64 {
        self.mac
    }

    /// Suma udziałów o tym samym `x` (MAC jest liniowy po δ).
    pub fn add(&self, other: &Self) -> Result<Self> {
        if self.x != other.x {
            return Err(CoreError::PartyCountMismatch);
        }
        Self::new(
            self.x,
            zp::add(self.share, other.share),
            zp::add(self.mac, other.mac),
        )
    }

    /// Różnica udziałów o tym samym `x`.
    pub fn sub(&self, other: &Self) -> Result<Self> {
        if self.x != other.x {
            return Err(CoreError::PartyCountMismatch);
        }
        Self::new(
            self.x,
            zp::sub(self.share, other.share),
            zp::sub(self.mac, other.mac),
        )
    }
}

/// Udziały klucza MAC δ (Shamir w `Z_P`). **Nie rekonstruować w torze.**
///
/// Powstają z wkładów stron: każda strona losuje `r_i`, dzieli je Shamirem
/// i rozsyła udziały; δ = Σ r_i nigdy nie istnieje w jednym miejscu.
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct DeltaShares {
    xs: Vec<u16>,
    shares: Vec<u64>,
}

impl std::fmt::Debug for DeltaShares {
    /// Debug pokazuje tylko liczbę stron (wartości są poufne).
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("DeltaShares")
            .field("len", &self.shares.len())
            .finish_non_exhaustive()
    }
}

impl DeltaShares {
    /// Składa δ z udziałów wkładów: `share_j = Σ_i share_{i,j} (mod P)`.
    ///
    /// Każdy wiersz to udziały jednego wkładu `r_i` (z [`crate::zp::split`]),
    /// w tej samej kolejności `xs`. Pusty zbiór wkładów jest błędem.
    pub fn from_contribution_shares(xs: &[u16], contribs: &[Vec<u64>]) -> Result<Self> {
        if xs.is_empty() {
            return Err(CoreError::EmptyXs);
        }
        if xs.len() > MAX_PARTIES_V1 {
            return Err(CoreError::PartyCountMismatch);
        }
        if contribs.is_empty() {
            return Err(CoreError::InvalidInput);
        }
        let mut acc = vec![0u64; xs.len()];
        for row in contribs {
            if row.len() != xs.len() {
                return Err(CoreError::PartyCountMismatch);
            }
            for (a, &v) in acc.iter_mut().zip(row.iter()) {
                if v >= P {
                    return Err(CoreError::OutOfRange);
                }
                *a = zp::add(*a, v);
            }
        }
        Ok(Self {
            xs: xs.to_vec(),
            shares: acc,
        })
    }

    /// Liczba udziałów.
    pub fn len(&self) -> usize {
        self.shares.len()
    }

    /// Czy zbiór jest pusty (konstruktory tego nie dopuszczają).
    pub fn is_empty(&self) -> bool {
        self.shares.is_empty()
    }

    /// Punkty ewaluacji w kolejności udziałów.
    pub fn xs(&self) -> &[u16] {
        &self.xs
    }

    /// Podzbiór udziałów w kolejności `xs` (np. dokładnie `k` stron
    /// uczestniczących w otwarciu). Brak punktu → `PartyCountMismatch`.
    pub fn subset(&self, xs: &[u16]) -> Result<Self> {
        if xs.is_empty() {
            return Err(CoreError::EmptyXs);
        }
        let mut shares = Vec::with_capacity(xs.len());
        for &x in xs {
            let idx = self
                .xs
                .iter()
                .position(|&c| c == x)
                .ok_or(CoreError::PartyCountMismatch)?;
            shares.push(self.shares[idx]);
        }
        Ok(Self {
            xs: xs.to_vec(),
            shares,
        })
    }
}

/// Otwiera wartość i sprawdza MAC przy ukrytym δ.
///
/// `shares` muszą mieć dokładnie `k` elementów (jawny podzbiór uczestników
/// otwarcia), a `delta` — te same `x` w tej samej kolejności. δ nie jest
/// rekonstruowane. Niezgodność MAC → [`CoreError::MacFail`].
pub fn open_checked(shares: &[MacShare], delta: &DeltaShares, k: usize) -> Result<u64> {
    if !(2..=MAX_PARTIES_V1).contains(&k) {
        return Err(CoreError::ThresholdTooLow);
    }
    if shares.len() != k || delta.len() != k {
        return Err(CoreError::PartyCountMismatch);
    }
    for (s, &dx) in shares.iter().zip(delta.xs.iter()) {
        if s.x != dx {
            return Err(CoreError::PartyCountMismatch);
        }
    }

    let val_shares: Vec<zp::Share> = shares
        .iter()
        .map(|s| zp::Share::new(s.x, s.share))
        .collect::<Result<_>>()?;
    let value = zp::reconstruct(&val_shares, k)?;

    let zero_shares: Vec<zp::Share> = shares
        .iter()
        .zip(delta.shares.iter())
        .map(|(s, &d)| {
            // z_i = mac_i − v·δ_i
            zp::Share::new(s.x, zp::sub(s.mac, zp::mul(value, d)))
        })
        .collect::<Result<_>>()?;
    let z = zp::reconstruct(&zero_shares, k)?;

    if z == 0 {
        Ok(value)
    } else {
        Err(CoreError::MacFail)
    }
}

#[cfg(test)]
mod tests {
    use super::{DeltaShares, MacShare, open_checked};
    use crate::error::CoreError;
    use crate::zp::{self, P};

    // Piny z `ci/kat/zp_reference.py`.
    const XS: [u16; 2] = [1, 2];
    const DELTA: u64 = 0x0f1e_2d3c_4b5a_6978 % P;
    const DELTA_COEFFS: [u64; 1] = [0x7e57_c0de_1234_5678 % P];
    const VALUE: u64 = 0x0123_4567_89ab_cdef % P;
    const VALUE_COEFFS: [u64; 1] = [0x0f1e_2d3c_4b5a_6978 % P];
    const MAC_COEFFS: [u64; 1] = [0x00c0_ffee_1234_5678 % P];

    /// Testkitowy dealer MAC (**tylko testy**; API produkcyjne go nie ma).
    fn mac_shares_testkit(xs: &[u16], delta: u64, value: u64) -> (Vec<MacShare>, DeltaShares) {
        let delta_shares = zp::split(delta, xs, &DELTA_COEFFS).expect("split delta");
        let value_shares = zp::split(value, xs, &VALUE_COEFFS).expect("split value");
        let mac_shares = zp::split(zp::mul(delta, value), xs, &MAC_COEFFS).expect("split mac");
        let shares = value_shares
            .iter()
            .zip(mac_shares.iter())
            .map(|(v, m)| MacShare::new(v.x(), v.y(), m.y()).expect("mac share"))
            .collect();
        let delta = DeltaShares::from_contribution_shares(
            xs,
            &[delta_shares.iter().map(zp::Share::y).collect()],
        )
        .expect("delta");
        (shares, delta)
    }

    #[test]
    fn open_matches_python_kat_and_returns_value() {
        let delta_shares = zp::split(DELTA, &XS, &DELTA_COEFFS).expect("delta");
        let value_shares = zp::split(VALUE, &XS, &VALUE_COEFFS).expect("value");
        let mac_shares = zp::split(zp::mul(DELTA, VALUE), &XS, &MAC_COEFFS).expect("mac");
        assert_eq!(
            delta_shares.iter().map(zp::Share::y).collect::<Vec<_>>(),
            vec![0x0d75_ee1a_5d8e_bff4, 0x0bcd_aef8_6fc3_1670]
        );
        assert_eq!(
            value_shares.iter().map(zp::Share::y).collect::<Vec<_>>(),
            vec![0x1041_72a3_d506_3767, 0x1f5f_9fe0_2060_a0df]
        );
        assert_eq!(
            mac_shares.iter().map(zp::Share::y).collect::<Vec<_>>(),
            vec![0x177f_9de2_d53d_1c72, 0x1840_9dd0_e771_72ea]
        );

        let shares: Vec<MacShare> = value_shares
            .iter()
            .zip(mac_shares.iter())
            .map(|(v, m)| MacShare::new(v.x(), v.y(), m.y()).expect("share"))
            .collect();
        let delta = DeltaShares::from_contribution_shares(
            &XS,
            &[delta_shares.iter().map(zp::Share::y).collect()],
        )
        .expect("delta");
        assert_eq!(open_checked(&shares, &delta, 2).expect("open"), VALUE);
    }

    #[test]
    fn tampered_value_share_fails() {
        let (shares, delta) = mac_shares_testkit(&XS, DELTA, VALUE);
        let bad = MacShare::new(
            shares[0].x(),
            zp::add(shares[0].share(), 1),
            shares[0].mac(),
        )
        .expect("bad");
        let set = [bad, shares[1].clone()];
        assert_eq!(
            open_checked(&set, &delta, 2).unwrap_err(),
            CoreError::MacFail
        );
    }

    #[test]
    fn tampered_mac_fails() {
        let (shares, delta) = mac_shares_testkit(&XS, DELTA, VALUE);
        let bad = MacShare::new(
            shares[1].x(),
            shares[1].share(),
            zp::add(shares[1].mac(), 7),
        )
        .expect("bad");
        let set = [shares[0].clone(), bad];
        assert_eq!(
            open_checked(&set, &delta, 2).unwrap_err(),
            CoreError::MacFail
        );
    }

    #[test]
    fn arbitrary_mac_tamper_fails() {
        // Podmiana MAC bez zgodnego δ_i jest wykrywana.
        let (shares, delta) = mac_shares_testkit(&XS, DELTA, VALUE);
        for mac_guess in [1u64, 2, 0xdead_beef] {
            let bad = MacShare::new(
                shares[0].x(),
                zp::add(shares[0].share(), 3),
                zp::add(shares[0].mac(), mac_guess),
            )
            .expect("bad");
            let set = [bad, shares[1].clone()];
            assert_eq!(
                open_checked(&set, &delta, 2).unwrap_err(),
                CoreError::MacFail,
                "guess={mac_guess}"
            );
        }
    }

    #[test]
    fn local_shift_with_own_delta_share_is_detected() {
        // Strona zna δ_i, ale nie globalne δ. Przesunięcie udziału o Δ
        // i MAC o Δ·δ_i NIE jest spójne (potrzeba Δ·δ), więc MacFail.
        let (shares, delta) = mac_shares_testkit(&XS, DELTA, VALUE);
        let shift = 3u64;
        let shifted = MacShare::new(
            shares[0].x(),
            zp::add(shares[0].share(), shift),
            zp::add(shares[0].mac(), zp::mul(shift, delta.shares[0])),
        )
        .expect("shifted");
        let set = [shifted, shares[1].clone()];
        assert_eq!(
            open_checked(&set, &delta, 2).unwrap_err(),
            CoreError::MacFail
        );
    }

    #[test]
    fn wrong_delta_subset_fails() {
        let xs3 = [1u16, 2, 3];
        let (shares, delta) = mac_shares_testkit(&xs3, DELTA, VALUE);
        assert_eq!(
            open_checked(&shares[..2], &delta, 2).unwrap_err(),
            CoreError::PartyCountMismatch
        );
        let subset = delta.subset(&[2, 3]).expect("subset");
        assert_eq!(open_checked(&shares[1..], &subset, 2).expect("open"), VALUE);
        let wrong_order = delta.subset(&[2, 1]).expect("subset");
        assert_eq!(
            open_checked(&shares[..2], &wrong_order, 2).unwrap_err(),
            CoreError::PartyCountMismatch
        );
        assert_eq!(
            delta.subset(&[9]).unwrap_err(),
            CoreError::PartyCountMismatch
        );
    }

    #[test]
    fn open_validates_k() {
        let (shares, delta) = mac_shares_testkit(&XS, DELTA, VALUE);
        assert_eq!(
            open_checked(&shares, &delta, 1).unwrap_err(),
            CoreError::ThresholdTooLow
        );
        assert_eq!(
            open_checked(&shares, &delta, 3).unwrap_err(),
            CoreError::PartyCountMismatch
        );
    }

    #[test]
    fn delta_sums_contributions() {
        let xs = [1u16, 2, 3];
        let r1 = zp::split(11, &xs, &[5, 7]).expect("r1");
        let r2 = zp::split(22, &xs, &[9, 13]).expect("r2");
        let delta = DeltaShares::from_contribution_shares(
            &xs,
            &[
                r1.iter().map(zp::Share::y).collect(),
                r2.iter().map(zp::Share::y).collect(),
            ],
        )
        .expect("delta");
        // δ = 33: odtworzenie z udziałów musi dać 33 (kontrola KAT).
        let shares: Vec<zp::Share> = delta
            .xs()
            .iter()
            .zip(delta.shares.iter())
            .map(|(&x, &y)| zp::Share::new(x, y).expect("share"))
            .collect();
        assert_eq!(zp::reconstruct(&shares, 3).expect("reconstruct"), 33);
    }

    #[test]
    fn delta_aggregation_matches_mac_opening() {
        let xs = [1u16, 2, 3];
        let (s1, _) = mac_shares_testkit(&xs, DELTA, VALUE);
        let d1 = DeltaShares::from_contribution_shares(
            &xs,
            &[zp::split(DELTA, &xs, &DELTA_COEFFS)
                .expect("d1")
                .iter()
                .map(zp::Share::y)
                .collect()],
        )
        .expect("delta1");
        let d2 = DeltaShares::from_contribution_shares(
            &xs,
            &[zp::split(0, &xs, &DELTA_COEFFS)
                .expect("d2")
                .iter()
                .map(zp::Share::y)
                .collect()],
        )
        .expect("delta2");
        // δ = DELTA + 0; suma udziałów z dwóch wkładów musi otwierać to samo.
        let dsum =
            DeltaShares::from_contribution_shares(&xs, &[d1.shares.clone(), d2.shares.clone()])
                .expect("dsum");
        assert_eq!(open_checked(&s1, &dsum, 3).expect("open"), VALUE);
    }

    #[test]
    fn delta_rejects_bad_shapes() {
        assert_eq!(
            DeltaShares::from_contribution_shares(&[], &[vec![1]]).unwrap_err(),
            CoreError::EmptyXs
        );
        assert_eq!(
            DeltaShares::from_contribution_shares(&[1, 2], &[]).unwrap_err(),
            CoreError::InvalidInput
        );
        assert_eq!(
            DeltaShares::from_contribution_shares(&[1, 2], &[vec![1]]).unwrap_err(),
            CoreError::PartyCountMismatch
        );
        assert_eq!(
            DeltaShares::from_contribution_shares(&[1, 2], &[vec![1, P]]).unwrap_err(),
            CoreError::OutOfRange
        );
        let xs: Vec<u16> = (1..=17).collect();
        assert_eq!(
            DeltaShares::from_contribution_shares(&xs, &[vec![0; 17]]).unwrap_err(),
            CoreError::PartyCountMismatch
        );
    }

    #[test]
    fn mac_share_linearity_and_constructors() {
        let (a, _) = mac_shares_testkit(&[1, 2], DELTA, VALUE);
        let (b, _) = mac_shares_testkit(&[1, 2], DELTA, 5);
        let sum = a[0].add(&b[0]).expect("add");
        assert_eq!(sum.share(), zp::add(a[0].share(), b[0].share()));
        assert_eq!(sum.mac(), zp::add(a[0].mac(), b[0].mac()));
        let diff = a[0].sub(&b[0]).expect("sub");
        assert_eq!(diff.share(), zp::sub(a[0].share(), b[0].share()));

        assert_eq!(
            a[0].add(&MacShare::new(3, 0, 0).expect("m")).unwrap_err(),
            CoreError::PartyCountMismatch
        );
        assert_eq!(MacShare::new(0, 1, 1).unwrap_err(), CoreError::XZero);
        assert_eq!(
            MacShare::new(crate::ring::Q, 1, 1).unwrap_err(),
            CoreError::OutOfRange
        );
        assert_eq!(MacShare::new(1, P, 1).unwrap_err(), CoreError::OutOfRange);
        assert_eq!(MacShare::new(1, 1, P).unwrap_err(), CoreError::OutOfRange);
    }

    #[test]
    fn debug_redacts_secrets() {
        let (shares, delta) = mac_shares_testkit(&XS, DELTA, VALUE);
        let text = format!("{:?} {:?}", shares[0], delta);
        assert!(text.contains("MacShare"));
        assert!(text.contains("DeltaShares"));
        assert!(!text.contains(&format!("{}", shares[0].share())));
        assert!(!text.contains(&format!("{}", shares[0].mac())));
    }
}
