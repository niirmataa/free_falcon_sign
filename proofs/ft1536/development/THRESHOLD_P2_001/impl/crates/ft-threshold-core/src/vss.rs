//! Pedersen VSS nad `Z_q` — Faza A setupu B′ (SPEC §6.0, §6.2).
//!
//! Każda strona dzieli **swój własny wkład** (nie ma zaufanego dealera:
//! D-008 wyklucza dealera z `PROD`). Schemat dla jednego wielomianu:
//!
//! - współczynniki `a_j ∈ Z_q` (u16, `< q`) i blindy `r_j ∈ Z_L` (Scalar),
//! - zobowiązania `C_j = a_j·G + r_j·H`,
//! - udział dla `x`: `s = Σ a_j·x^j` liczony w `Z_L`, `t = Σ r_j·x^j`,
//! - weryfikacja: `s·G + t·H == Σ C_j·x^j` (bez interpolacji).
//!
//! **Dlaczego `s` w `Z_L`, a nie od razu w `Z_q`:** równanie wykładnicze
//! wymaga wspólnego pierścienia wykładników. Dla `k ≤ 16` i `x < q`
//! zachodzi `Σ a_j·x^j < (q−1)^k < 2^240 < L`, więc Scalar `s` jest
//! **dokładną** wartością całkowitą, a [`ExpShare::share_zq`] redukuje ją
//! do udziału Shamir w `Z_q`. Agregacja ≤ 16 dealerów daje `< 2^244 < L`.
//! To jest jawny warunek poprawności, nie „prawdopodobnie wystarczy”.
//!
//! **H** to generator nothing-up-my-sleeve: `SHA3-512(".../pedersen-h")`
//! → `RistrettoPoint::from_uniform_bytes`. Stały pin jest w teście.
//!
//! **Granica:** to komponent VSS, nie cały DKG (adjudykacja, transkrypt,
//! NTRU i `pk` są w SPEC §6.2/§6.3 i pozostają otwarte). Zeroizacja:
//! `ExpShare` czyści `s` i `t` przy dropie.

use std::collections::BTreeSet;
use std::sync::OnceLock;

use curve25519_dalek::constants::RISTRETTO_BASEPOINT_POINT as G;
use curve25519_dalek::ristretto::RistrettoPoint;
use curve25519_dalek::scalar::Scalar;
use curve25519_dalek::traits::Identity;
use sha3::{Digest, Sha3_512};
use zeroize::{Zeroize, ZeroizeOnDrop};

use crate::MAX_PARTIES_V1;
use crate::error::{CoreError, Result};
use crate::ring::Q;

/// Domena generatora `H` (część specyfikacji, nie dowolny string).
pub const H_DOMAIN: &[u8] = b"FT1536/threshold/v1/pedersen-h";

/// Bajty na zaszyfrowany punkt Ristretto.
pub const POINT_BYTES: usize = 32;

/// Bajty na udział wykładnikowy: `x(2) || s(32) || t(32)`.
pub const EXP_SHARE_BYTES: usize = 2 + 32 + 32;

/// Generator `H` (cache: hash-to-point liczony raz na proces).
pub fn pedersen_h() -> RistrettoPoint {
    static H: OnceLock<RistrettoPoint> = OnceLock::new();
    *H.get_or_init(|| {
        let digest = Sha3_512::digest(H_DOMAIN);
        let mut wide = [0u8; 64];
        wide.copy_from_slice(&digest);
        RistrettoPoint::from_uniform_bytes(&wide)
    })
}

/// Zobowiązania Pedersena do wszystkich współczynników (jawne).
#[derive(Clone, Debug)]
pub struct VssCommitments {
    points: Vec<RistrettoPoint>,
}

impl VssCommitments {
    /// Tworzy zestaw zobowiązań; długość musi być w `2..=MAX_PARTIES_V1`.
    pub fn new(points: Vec<RistrettoPoint>) -> Result<Self> {
        if points.len() < 2 {
            return Err(CoreError::ThresholdTooLow);
        }
        if points.len() > MAX_PARTIES_V1 {
            return Err(CoreError::PartyCountMismatch);
        }
        Ok(Self { points })
    }

    /// Liczba zobowiązań (= stopień wielomianu + 1).
    pub fn len(&self) -> usize {
        self.points.len()
    }

    /// Czy zbiór jest pusty (konstruktor tego nie dopuszcza).
    pub fn is_empty(&self) -> bool {
        self.points.is_empty()
    }

    /// Zobowiązanie współczynnika `j`.
    pub fn point(&self, j: usize) -> Option<&RistrettoPoint> {
        self.points.get(j)
    }

    /// Suma zobowiązań (homomorfizm addytywny; agregacja S5).
    pub fn add(&self, other: &Self) -> Result<Self> {
        if self.points.len() != other.points.len() {
            return Err(CoreError::InvalidLength);
        }
        let points = self
            .points
            .iter()
            .zip(other.points.iter())
            .map(|(a, b)| a + b)
            .collect();
        Self::new(points)
    }

    /// Kanoniczna serializacja: `32 B` na punkt.
    pub fn to_bytes(&self) -> Vec<u8> {
        let mut out = Vec::with_capacity(self.points.len() * POINT_BYTES);
        for p in &self.points {
            out.extend_from_slice(&p.compress().to_bytes());
        }
        out
    }

    /// Parsuje kanoniczne punkty; zły punkt to `InvalidInput` (fail-closed).
    ///
    /// Limit wejścia: `≤ MAX_PARTIES_V1` punktów (WP-019) — większy bufor
    /// jest odrzucany **przed** alokacją, bez próby parsowania.
    pub fn from_bytes(bytes: &[u8]) -> Result<Self> {
        if bytes.len() > MAX_PARTIES_V1 * POINT_BYTES {
            return Err(CoreError::PartyCountMismatch);
        }
        if !bytes.len().is_multiple_of(POINT_BYTES) {
            return Err(CoreError::InvalidLength);
        }
        let mut points = Vec::with_capacity(bytes.len() / POINT_BYTES);
        for chunk in bytes.chunks_exact(POINT_BYTES) {
            let mut buf = [0u8; POINT_BYTES];
            buf.copy_from_slice(chunk);
            let point = curve25519_dalek::ristretto::CompressedRistretto::from_slice(&buf)
                .map_err(|_| CoreError::InvalidLength)?
                .decompress()
                .ok_or(CoreError::InvalidInput)?;
            points.push(point);
        }
        Self::new(points)
    }

    /// Porównanie (dane publiczne; punkty porównują się w stałym czasie).
    pub fn ct_eq(&self, other: &Self) -> bool {
        self.points == other.points
    }
}

/// Udział w przestrzeni wykładników: `(x, s, t)`.
///
/// `s` jest dokładną ewaluacją całkowitą dla udziałów z [`deal`]
/// (patrz warunek `2^240 < L` w opisie modułu); `share_zq` redukuje
/// ją do `Z_q`.
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct ExpShare {
    x: u16,
    s: Scalar,
    t: Scalar,
}

impl std::fmt::Debug for ExpShare {
    /// Debug **nie** pokazuje `s` ani `t` (materiał poufny).
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("ExpShare")
            .field("x", &self.x)
            .finish_non_exhaustive()
    }
}

impl ExpShare {
    /// Buduje udział z kanonicznych bajtów `s`/`t`; `x = 0` i `x ≥ q` są błędem.
    pub fn new(x: u16, s: [u8; 32], t: [u8; 32]) -> Result<Self> {
        if x == 0 {
            return Err(CoreError::XZero);
        }
        if x >= Q {
            return Err(CoreError::OutOfRange);
        }
        let s = scalar_from_canonical(&s)?;
        let t = scalar_from_canonical(&t)?;
        Ok(Self { x, s, t })
    }

    /// Punkt ewaluacji `x`.
    pub fn x(&self) -> u16 {
        self.x
    }

    /// Udział Shamir w `Z_q` (dokładny dla udziałów z [`deal`]).
    pub fn share_zq(&self) -> u16 {
        scalar_mod_q(&self.s)
    }

    /// Kanoniczne bajty `s` (do wysyłki/complaintu).
    pub fn s_bytes(&self) -> [u8; 32] {
        self.s.to_bytes()
    }

    /// Kanoniczne bajty `t` (blind; do wysyłki/complaintu).
    pub fn t_bytes(&self) -> [u8; 32] {
        self.t.to_bytes()
    }

    /// Serializacja: `x(2 BE) || s(32) || t(32)`.
    pub fn to_bytes(&self) -> [u8; EXP_SHARE_BYTES] {
        let mut out = [0u8; EXP_SHARE_BYTES];
        out[..2].copy_from_slice(&self.x.to_be_bytes());
        out[2..34].copy_from_slice(&self.s.to_bytes());
        out[34..].copy_from_slice(&self.t.to_bytes());
        out
    }

    /// Parsuje serializację [`Self::to_bytes`].
    pub fn from_bytes(bytes: &[u8; EXP_SHARE_BYTES]) -> Result<Self> {
        let x = u16::from_be_bytes([bytes[0], bytes[1]]);
        let mut s = [0u8; 32];
        let mut t = [0u8; 32];
        s.copy_from_slice(&bytes[2..34]);
        t.copy_from_slice(&bytes[34..]);
        Self::new(x, s, t)
    }

    /// Suma udziałów od różnych dealerów dla tego samego `x` (S5).
    ///
    /// Poprawna dla ≤ 16 udziałów z [`deal`] (`< 2^244 < L`).
    pub fn add(&self, other: &Self) -> Result<Self> {
        if self.x != other.x {
            return Err(CoreError::InconsistentShare);
        }
        Ok(Self {
            x: self.x,
            s: self.s + other.s,
            t: self.t + other.t,
        })
    }
}

impl TryFrom<&[u8]> for ExpShare {
    type Error = CoreError;

    fn try_from(bytes: &[u8]) -> Result<Self> {
        let fixed: &[u8; EXP_SHARE_BYTES] =
            bytes.try_into().map_err(|_| CoreError::InvalidLength)?;
        Self::from_bytes(fixed)
    }
}

/// Składa udziały od wielu dealerów dla **tego samego** `x` (S5, krok 1).
///
/// Bound: `≤ MAX_PARTIES_V1 = 16` dealerów daje `< 2^244 < L`, więc suma
/// Scalarów jest **dokładna** (bez zawijania modulo `L`). Pusty zbiór,
/// różne `x` i więcej niż 16 dealerów są błędem.
pub fn fold_shares<'a>(shares: impl IntoIterator<Item = &'a ExpShare>) -> Result<ExpShare> {
    let mut iter = shares.into_iter();
    let first = iter.next().ok_or(CoreError::EmptyXs)?;
    let mut acc = ExpShare::from_bytes(&first.to_bytes())?;
    let mut count = 1usize;
    for s in iter {
        count += 1;
        if count > MAX_PARTIES_V1 {
            return Err(CoreError::PartyCountMismatch);
        }
        acc = acc.add(s)?;
    }
    Ok(acc)
}

/// Składa zobowiązania dealerów (S5, krok 2): suma po współczynnikach.
///
/// Wszystkie zestawy muszą mieć tę samą długość; pusty zbiór jest błędem.
pub fn fold_commitments<'a>(
    comms: impl IntoIterator<Item = &'a VssCommitments>,
) -> Result<VssCommitments> {
    let mut iter = comms.into_iter();
    let first = iter.next().ok_or(CoreError::EmptyXs)?;
    let mut acc = first.clone();
    let mut count = 1usize;
    for c in iter {
        count += 1;
        if count > MAX_PARTIES_V1 {
            return Err(CoreError::PartyCountMismatch);
        }
        acc = acc.add(c)?;
    }
    Ok(acc)
}

/// Dzieli wkład strony: zobowiązania + udziały dla `xs`.
///
/// `secret_coeffs[j]` to współczynnik `a_j ∈ Z_q`, `blinds[j]` kanoniczny
/// Scalar blindingu. `xs` muszą być niezerowe, różne, `< q`, a ich liczba
/// musi wynosić co najmniej `k` (inaczej sekretu nie da się odtworzyć).
pub fn deal(
    secret_coeffs: &[u16],
    blinds: &[[u8; 32]],
    xs: &[u16],
) -> Result<(VssCommitments, Vec<ExpShare>)> {
    let k = secret_coeffs.len();
    if k < 2 {
        return Err(CoreError::ThresholdTooLow);
    }
    if k > MAX_PARTIES_V1 {
        return Err(CoreError::PartyCountMismatch);
    }
    if blinds.len() != k {
        return Err(CoreError::InvalidLength);
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

    let mut blind_scalars = Vec::with_capacity(k);
    for b in blinds {
        blind_scalars.push(scalar_from_canonical(b)?);
    }

    let h = pedersen_h();
    let mut points = Vec::with_capacity(k);
    for (&a, &r) in secret_coeffs.iter().zip(blind_scalars.iter()) {
        if a >= Q {
            return Err(CoreError::OutOfRange);
        }
        points.push(G * Scalar::from(u64::from(a)) + h * r);
    }
    let comms = VssCommitments::new(points)?;

    let shares = xs
        .iter()
        .map(|&x| {
            let sx = Scalar::from(u64::from(x));
            ExpShare {
                x,
                s: eval_zq(secret_coeffs, sx),
                t: eval_scalar(&blind_scalars, sx),
            }
        })
        .collect();

    Ok((comms, shares))
}

/// Weryfikuje udział: `s·G + t·H == Σ C_j·x^j`.
pub fn verify_share(share: &ExpShare, comms: &VssCommitments) -> Result<()> {
    if share.x == 0 {
        return Err(CoreError::XZero);
    }
    let x = Scalar::from(u64::from(share.x));
    let lhs = G * share.s + pedersen_h() * share.t;

    let mut xp = Scalar::ONE;
    let mut rhs = RistrettoPoint::identity();
    for p in &comms.points {
        rhs += p * xp;
        xp *= x;
    }

    if lhs == rhs {
        Ok(())
    } else {
        Err(CoreError::InconsistentShare)
    }
}

fn scalar_from_canonical(bytes: &[u8; 32]) -> Result<Scalar> {
    let s = Scalar::from_canonical_bytes(*bytes);
    Option::<Scalar>::from(s).ok_or(CoreError::OutOfRange)
}

/// Horner w `Z_L` dla współczynników `Z_q`; wynik = dokładna ewaluacja
/// całkowita, bo dla `k ≤ 16`, `x < q` zachodzi `< 2^240 < L`.
fn eval_zq(coeffs: &[u16], x: Scalar) -> Scalar {
    let mut acc = Scalar::ZERO;
    for &c in coeffs.iter().rev() {
        acc = acc * x + Scalar::from(u64::from(c));
    }
    acc
}

fn eval_scalar(coeffs: &[Scalar], x: Scalar) -> Scalar {
    let mut acc = Scalar::ZERO;
    for &c in coeffs.iter().rev() {
        acc = acc * x + c;
    }
    acc
}

/// Redukuje kanoniczny Scalar (integer `0..L`) modulo `q`.
fn scalar_mod_q(s: &Scalar) -> u16 {
    let bytes = s.to_bytes();
    let mut acc = 0u32;
    for &b in bytes.iter().rev() {
        acc = (acc * 256 + u32::from(b)) % u32::from(Q);
    }
    acc as u16
}

#[cfg(test)]
mod tests {
    use super::{
        EXP_SHARE_BYTES, ExpShare, H_DOMAIN, VssCommitments, deal, fold_commitments, fold_shares,
        pedersen_h, scalar_mod_q, verify_share,
    };
    use crate::MAX_PARTIES_V1;
    use crate::error::CoreError;
    use crate::ring::{Q, inv_mod};
    use curve25519_dalek::scalar::Scalar;
    use sha3::{Digest, Sha3_512};

    fn blind(seed: u8, i: u8) -> [u8; 32] {
        let mut h = Sha3_512::new();
        h.update([seed, i]);
        h.update(b"FT1536-P2/vss-test-blind");
        let digest = h.finalize();
        let mut wide = [0u8; 64];
        wide.copy_from_slice(&digest);
        Scalar::from_bytes_mod_order_wide(&wide).to_bytes()
    }

    fn blinds(seed: u8, k: usize) -> Vec<[u8; 32]> {
        (0..k as u8).map(|i| blind(seed, i)).collect()
    }

    #[test]
    fn h_generator_matches_pin() {
        assert_eq!(H_DOMAIN, b"FT1536/threshold/v1/pedersen-h");
        let bytes = pedersen_h().compress().to_bytes();
        assert_eq!(
            hex(&bytes),
            "5af2b2eee4636fccd6c4190d844d9ef6ceeca320e645cc3b0ec7e11e64a9ba1f"
        );
    }

    #[test]
    fn deal_and_verify() {
        let coeffs = [0x42u16, 7, 3];
        let (comms, shares) = deal(&coeffs, &blinds(1, 3), &[1, 2, 3]).expect("deal");
        assert_eq!(comms.len(), 3);
        assert_eq!(shares.len(), 3);
        for sh in &shares {
            verify_share(sh, &comms).expect("verify");
        }
    }

    #[test]
    fn share_zq_is_integer_shamir_eval() {
        let coeffs = [0x42u16, 7, 3];
        let (_, shares) = deal(&coeffs, &blinds(2, 3), &[1, 2, 5]).expect("deal");
        for sh in &shares {
            let x = u128::from(sh.x());
            let expected = (0x42 + 7 * x + 3 * x * x) % u128::from(Q);
            assert_eq!(u128::from(sh.share_zq()), expected, "x={x}");
        }
    }

    #[test]
    fn share_zq_handles_large_x() {
        let coeffs = [66u16, 7, 3];
        let x = u128::from(Q - 1);
        let (_, shares) = deal(&coeffs, &blinds(3, 3), &[Q - 1, 2, 3]).expect("deal");
        let expected = (66 + 7 * x + 3 * x * x) % u128::from(Q);
        assert_eq!(u128::from(shares[0].share_zq()), expected);
    }

    #[test]
    fn k_shares_reconstruct_secret_mod_q() {
        let coeffs = [0x42u16, 7, 3];
        let xs = [1u16, 2, 3];
        let (_, shares) = deal(&coeffs, &blinds(4, 3), &xs).expect("deal");
        let ys: Vec<u16> = shares.iter().map(ExpShare::share_zq).collect();
        assert_eq!(lagrange_at_zero(&xs, &ys), 0x42);
    }

    #[test]
    fn forged_share_is_rejected() {
        let (comms, shares) = deal(&[0x11u16, 9], &blinds(5, 2), &[1, 2, 3]).expect("deal");
        let mut bytes = shares[1].to_bytes();
        bytes[2] ^= 0xFF;
        let forged = ExpShare::from_bytes(&bytes).expect("parse");
        assert_eq!(
            verify_share(&forged, &comms).unwrap_err(),
            CoreError::InconsistentShare
        );
    }

    #[test]
    fn forged_blind_is_rejected() {
        let (comms, shares) = deal(&[0x11u16, 9], &blinds(6, 2), &[1, 2, 3]).expect("deal");
        let mut bytes = shares[0].to_bytes();
        bytes[34] ^= 0x01;
        let forged = ExpShare::from_bytes(&bytes).expect("parse");
        assert_eq!(
            verify_share(&forged, &comms).unwrap_err(),
            CoreError::InconsistentShare
        );
    }

    #[test]
    fn wrong_x_is_rejected() {
        let (comms, shares) = deal(&[0x11u16, 9], &blinds(7, 2), &[1, 2, 3]).expect("deal");
        let mut bytes = shares[2].to_bytes();
        bytes[0] = 0;
        bytes[1] = 4; // x = 4 zamiast 3
        let moved = ExpShare::from_bytes(&bytes).expect("parse");
        assert_eq!(
            verify_share(&moved, &comms).unwrap_err(),
            CoreError::InconsistentShare
        );
    }

    #[test]
    fn x_zero_and_out_of_range_are_rejected() {
        let (_, shares) = deal(&[1u16, 2], &blinds(8, 2), &[1, 2]).expect("deal");
        let mut bytes = shares[0].to_bytes();
        bytes[0] = 0;
        bytes[1] = 0;
        assert_eq!(ExpShare::from_bytes(&bytes).unwrap_err(), CoreError::XZero);
        bytes[0] = 0x48;
        bytes[1] = 0x01; // 18433 = q
        assert_eq!(
            ExpShare::from_bytes(&bytes).unwrap_err(),
            CoreError::OutOfRange
        );
    }

    #[test]
    fn duplicate_and_zero_x_in_deal_are_rejected() {
        let b = blinds(9, 2);
        assert_eq!(
            deal(&[1u16, 2], &b, &[1, 1]).unwrap_err(),
            CoreError::DuplicateX
        );
        assert_eq!(deal(&[1u16, 2], &b, &[0, 2]).unwrap_err(), CoreError::XZero);
    }

    #[test]
    fn deal_rejects_bad_parameters() {
        let b = blinds(10, 2);
        assert_eq!(
            deal(&[1u16], &b[..1], &[1, 2]).unwrap_err(),
            CoreError::ThresholdTooLow
        );
        assert_eq!(
            deal(&[1u16, 2], &b[..1], &[1, 2]).unwrap_err(),
            CoreError::InvalidLength
        );
        assert_eq!(
            deal(&[1u16, 2], &b, &[1]).unwrap_err(),
            CoreError::PartyCountMismatch
        );
        assert_eq!(
            deal(&[Q, 2], &b, &[1, 2]).unwrap_err(),
            CoreError::OutOfRange
        );
    }

    #[test]
    fn commitments_encoding_roundtrip_and_rejects_garbage() {
        let (comms, _) = deal(&[5u16, 8], &blinds(11, 2), &[1, 2, 3]).expect("deal");
        let bytes = comms.to_bytes();
        assert_eq!(bytes.len(), 2 * super::POINT_BYTES);
        let back = VssCommitments::from_bytes(&bytes).expect("parse");
        assert!(back.ct_eq(&comms));

        assert_eq!(
            VssCommitments::from_bytes(&bytes[..bytes.len() - 1]).unwrap_err(),
            CoreError::InvalidLength
        );
        assert_eq!(
            VssCommitments::from_bytes(&[0xFFu8; 32]).unwrap_err(),
            CoreError::InvalidInput
        );
    }

    #[test]
    fn share_encoding_roundtrip() {
        let (_, shares) = deal(&[5u16, 8], &blinds(12, 2), &[1, 2, 3]).expect("deal");
        let bytes = shares[0].to_bytes();
        assert_eq!(bytes.len(), EXP_SHARE_BYTES);
        let back = ExpShare::from_bytes(&bytes).expect("parse");
        assert_eq!(back.x(), shares[0].x());
        assert_eq!(back.share_zq(), shares[0].share_zq());
        assert_eq!(back.s_bytes(), shares[0].s_bytes());
        assert_eq!(back.t_bytes(), shares[0].t_bytes());
    }

    #[test]
    fn aggregation_is_homomorphic() {
        let xs = [1u16, 2, 3];
        let (c1, s1) = deal(&[0x21u16, 4], &blinds(13, 2), &xs).expect("deal1");
        let (c2, s2) = deal(&[7u16, 0x33], &blinds(14, 2), &xs).expect("deal2");
        let c_sum = c1.add(&c2).expect("add comms");
        for (a, b) in s1.iter().zip(s2.iter()) {
            let sh = a.add(b).expect("add shares");
            verify_share(&sh, &c_sum).expect("verify aggregate");
            assert_eq!(
                u32::from(sh.share_zq()),
                (u32::from(a.share_zq()) + u32::from(b.share_zq())) % u32::from(Q)
            );
        }
        assert_eq!(c1.add(&c2).expect("again").to_bytes(), c_sum.to_bytes());
    }

    #[test]
    fn aggregating_different_x_is_rejected() {
        let (_, s1) = deal(&[1u16, 2], &blinds(15, 2), &[1, 2]).expect("deal1");
        let (_, s2) = deal(&[1u16, 2], &blinds(16, 2), &[2, 3]).expect("deal2");
        assert_eq!(s1[0].add(&s2[0]).unwrap_err(), CoreError::InconsistentShare);
    }

    #[test]
    fn scalar_reduction_matches_independent_horner() {
        for v in [0u64, 1, 12345, u64::MAX] {
            let s = Scalar::from(v);
            assert_eq!(u64::from(scalar_mod_q(&s)), v % u64::from(Q));
        }
    }

    #[test]
    fn full_coefficient_verification_rejects_high_index_tamper() {
        // Audyt #7: próbka 8 współczynników przepuściłaby fałszerstwo
        // w wysokim współczynniku. Pełna weryfikacja musi je złapać.
        let k = MAX_PARTIES_V1;
        let xs: Vec<u16> = (1..=k as u16).collect();
        let coeffs: Vec<u16> = (0..k).map(|i| (i as u16) * 7 + 1).collect();
        let blinds: Vec<[u8; 32]> = (0..k as u8).map(|i| blind(20, i)).collect();
        let (comms, mut shares) = deal(&coeffs, &blinds, &xs).expect("deal");

        // Δ·x^(k−1) w przestrzeni wykładników: tylko współczynnik 15.
        let x = Scalar::from(u64::from(xs[0]));
        let mut pow = Scalar::ONE;
        for _ in 0..k - 1 {
            pow *= x;
        }
        let delta = pow * Scalar::from(5u64);
        let mut s = shares[0].s_bytes();
        let cur = Scalar::from_canonical_bytes(s);
        let cur = Option::<Scalar>::from(cur).expect("canonical");
        s = (cur + delta).to_bytes();
        let t = shares[0].t_bytes();
        shares[0] = ExpShare::new(shares[0].x(), s, t).expect("forged");
        assert_eq!(
            verify_share(&shares[0], &comms).unwrap_err(),
            CoreError::InconsistentShare
        );
    }

    #[test]
    fn fold_shares_and_commitments_are_homomorphic() {
        let xs = [1u16, 2, 3];
        let (c1, s1) = deal(&[10u16, 4], &blinds(21, 2), &xs).expect("d1");
        let (c2, s2) = deal(&[20u16, 9], &blinds(22, 2), &xs).expect("d2");
        let (c3, s3) = deal(&[30u16, 1], &blinds(23, 2), &xs).expect("d3");
        let comms = fold_commitments([&c1, &c2, &c3]).expect("comms");
        // Składamy po tym samym x (nie mieszamy stron).
        let folded: Vec<ExpShare> = (0..xs.len())
            .map(|i| fold_shares([&s1[i], &s2[i], &s3[i]]).expect("fold"))
            .collect();
        for f in &folded {
            verify_share(f, &comms).expect("aggregate verifies");
        }
        // Suma sekretów 10+20+30 = 60; 3 zagregowane udziały odtwarzają 60.
        let ys: Vec<u16> = folded.iter().map(ExpShare::share_zq).collect();
        assert_eq!(lagrange_at_zero(&xs, &ys), 60 % Q);
    }

    #[test]
    fn fold_rejects_empty_and_mixed_x() {
        let (_, s1) = deal(&[1u16, 2], &blinds(24, 2), &[1, 2]).expect("d1");
        let (_, s2) = deal(&[1u16, 2], &blinds(25, 2), &[2, 3]).expect("d2");
        assert_eq!(
            fold_shares(std::iter::empty()).unwrap_err(),
            CoreError::EmptyXs
        );
        assert_eq!(
            fold_shares([&s1[0], &s2[0]]).unwrap_err(),
            CoreError::InconsistentShare
        );
        assert_eq!(
            fold_commitments(std::iter::empty::<&VssCommitments>()).unwrap_err(),
            CoreError::EmptyXs
        );
        // >16 dealerów: ten sam cap co dla udziałów (publiczny odpowiednik).
        let sets: Vec<(VssCommitments, Vec<ExpShare>)> = (0..=MAX_PARTIES_V1 as u8)
            .map(|d| deal(&[1u16, 2], &blinds(30 + d, 2), &[1, 2]).expect("deal"))
            .collect();
        let comms: Vec<&VssCommitments> = sets.iter().map(|(c, _)| c).collect();
        assert_eq!(
            fold_commitments(comms).unwrap_err(),
            CoreError::PartyCountMismatch
        );
        let shares: Vec<&ExpShare> = sets.iter().map(|(_, s)| &s[0]).collect();
        assert_eq!(
            fold_shares(shares).unwrap_err(),
            CoreError::PartyCountMismatch
        );
    }

    #[test]
    fn fold_bound_is_below_scalar_order() {
        // Ewaluacja u dealera: (q−1)^k < 2^(15·16) = 2^240 dla k ≤ 16.
        // 16 dealerów: < 2^244. Rząd L grupy Ristretto255 jest > 2^252,
        // więc suma Scalarów nie zawija modulo L. Wartości liczymy z
        // bieżących stałych, żeby test nie był tautologią.
        let q_bits = 64 - (Q as u64 - 1).leading_zeros();
        assert_eq!(q_bits, 15);
        let parties = u32::try_from(MAX_PARTIES_V1).expect("MAX_PARTIES_V1 fits u32");
        let per_dealer_bits = parties * q_bits;
        let all_dealers_bits = per_dealer_bits + 4;
        assert_eq!(per_dealer_bits, 240);
        assert_eq!(all_dealers_bits, 244);
        assert!(all_dealers_bits < 252);
        // Sam próg 2^252 < L sprawdza test `scalar_order_exceeds_2_252`.
        assert_eq!(Scalar::ONE.to_bytes().len(), 32);
    }

    #[test]
    fn scalar_order_exceeds_2_252() {
        // 2^252 jako 32 bajty LE jest < L (L = 2^252 + δ, δ > 0).
        let mut two_252 = [0u8; 32];
        two_252[31] = 0x10;
        let sc = Option::<Scalar>::from(Scalar::from_canonical_bytes(two_252)).expect("2^252 < L");
        assert_eq!(sc.to_bytes(), two_252);
        // 2^252 + 1 też jest < L (δ ≈ 2^124).
        let mut plus_one = two_252;
        plus_one[0] = 1;
        assert!(Option::<Scalar>::from(Scalar::from_canonical_bytes(plus_one)).is_some());
    }

    #[test]
    fn integer_eval_bound_fits_below_scalar_order() {
        // (q-1) < 2^15, k ≤ 16 → ewaluacja < 2^240 < L ≈ 2^252.
        // Agregacja ≤ 16 dealerów → < 2^244 < L.
        const { assert!(Q as u64 - 1 < (1 << 15)) };
        const { assert!(15 * MAX_PARTIES_V1 + 4 < 252) };
    }

    fn lagrange_at_zero(xs: &[u16], ys: &[u16]) -> u16 {
        let q = u32::from(Q);
        let mut acc = 0u32;
        for i in 0..xs.len() {
            let mut num = 1u32;
            let mut den = 1u32;
            for (j, &xj) in xs.iter().enumerate() {
                if i == j {
                    continue;
                }
                num = num * (q - u32::from(xj)) % q;
                den = den * ((u32::from(xs[i]) + q - u32::from(xj)) % q) % q;
            }
            let inv = u32::from(inv_mod(den as u16).expect("invertible"));
            acc = (acc + u32::from(ys[i]) * num % q * inv) % q;
        }
        acc as u16
    }

    fn hex(bytes: &[u8]) -> String {
        bytes.iter().map(|b| format!("{b:02x}")).collect()
    }
}
