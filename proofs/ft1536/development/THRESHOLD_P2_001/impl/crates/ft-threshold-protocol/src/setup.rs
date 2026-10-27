//! WP-030 (Bramka G2) — Przepływ komunikatów setupu 2-z-3 (DKG + VSS +
//! Complaints + Blame) na profilu `TEST-ORACLE` (`0x01`).
//!
//! **Zakres (Faza A wariantu B′, D-024):**
//! 1. **Runda 1 (`MSG_VSS_SHARE = 0x05`):** każda ze stron $P_1, P_2, P_3$
//!    dzieli swój lokalny wkład dla 32 instancji seeda (`SEED_INSTANCES = 32`)
//!    za pomocą [`vss::deal`] nad $\mathbb{Z}_q$ ($q = 18433$) ze zobowiązaniami
//!    Pedersena i rozsyła uwierzytelnione koperty ([`Envelope`]) do pozostałych
//!    węzłów.
//! 2. **Runda 2 (Weryfikacja VSS + Complaints `MSG_COMPLAINT = 0x06`):** każdy
//!    węzeł otwiera kopertę przez [`SessionReceiver::accept`] i sprawdza wszystkie
//!    32 udziały przez [`vss::verify_share`]. W razie niezgodności natychmiast
//!    generuje [`ComplaintPayload`] wskazujący nieuczciwego dealera, wpisuje go
//!    na listę `disqualified`, przechodzi w stan `aborted` (fail-closed) i
//!    zwraca `Err(CoreError::InconsistentShare)`.
//! 3. **Runda 3 (`MSG_SETUP_FINAL = 0x08`):** jeśli wszystkie wkłady przeszły
//!    weryfikację bez skarg, węzeł składa udziały ([`vss::fold_shares`]) i
//!    zobowiązania ([`vss::fold_commitments`]), wylicza deterministyczny
//!    `dkg_root` i przechodzi do [`PartyState<DkgOk>`].

#![forbid(unsafe_code)]

use std::collections::{BTreeMap, BTreeSet};

use ft_threshold_core::Profile;
use ft_threshold_core::error::{CoreError, Result};
use ft_threshold_core::ring::Q;
use ft_threshold_core::vss::{self, EXP_SHARE_BYTES, ExpShare, POINT_BYTES, VssCommitments};

use crate::cbor::{CborReader, CborWriter};
use crate::envelope::{Body, Delivery, Envelope, EnvelopeKey, PartyId, SessionReceiver};
use crate::state::{DealerContribution, DkgOk, PartyState, SEED_INSTANCES, dkg_root};

/// Próg `k = 2` dla konfiguracji 2-z-3 (D-003).
pub const K_2OF3: usize = 2;
/// Liczba stron `n = 3` dla konfiguracji 2-z-3 (D-003).
pub const PARTIES_2OF3: usize = 3;
/// Rozmiar pojedynczego zestawu zobowiązań VSS dla `k = 2` (`2 * 32 B = 64 B`).
pub const COMMITMENTS_2OF3_BYTES: usize = K_2OF3 * POINT_BYTES;
/// Maksymalny rozmiar `setup_nonce` w `SETUP_INIT`.
pub const MAX_SETUP_NONCE_BYTES: usize = 64;

/// Typ komunikatu `SETUP_INIT` (`payloads_v0.cddl`).
pub const MSG_SETUP_INIT: u16 = 0x01;
/// Typ komunikatu `VSS_SHARE` (`payloads_v0.cddl`).
pub const MSG_VSS_SHARE: u16 = 0x05;
/// Typ komunikatu `COMPLAINT` (`payloads_v0.cddl`).
pub const MSG_COMPLAINT: u16 = 0x06;
/// Typ komunikatu `SETUP_FINAL` (`payloads_v0.cddl`).
pub const MSG_SETUP_FINAL: u16 = 0x08;

/// Payload `0x01 SETUP_INIT` (runda inicjalizacji, publiczny).
///
/// Kanoniczna mapa CBOR o kluczach `1..=9`:
/// `{1: sid, 2: epoch, 3: k, 4: n, 5: parties, 6: xs, 7: policy_hash, 8: mode, 9: setup_nonce}`.
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct SetupInit {
    sid: [u8; 32],
    epoch: u64,
    k: u8,
    n: u8,
    parties: [PartyId; PARTIES_2OF3],
    xs: [u16; PARTIES_2OF3],
    policy_hash: [u8; 32],
    mode: u8,
    setup_nonce: Vec<u8>,
}

impl SetupInit {
    /// Tworzy i waliduje `SetupInit` dla konfiguracji 2-z-3 na profilu `TEST-ORACLE`.
    ///
    /// Wymagania:
    /// - `sid` i każdy `PartyId` niezerowe,
    /// - `parties` ściśle posortowane rosnąco (kanoniczny porządek leksykograficzny),
    /// - `xs` ściśle rosnące, w zakresie `1..q`,
    /// - `mode == Profile::TestOracle as u8` (`0x01` w Bramce G2),
    /// - `setup_nonce` o długości `1..=MAX_SETUP_NONCE_BYTES`.
    pub fn new(
        sid: [u8; 32],
        epoch: u64,
        parties: [PartyId; PARTIES_2OF3],
        xs: [u16; PARTIES_2OF3],
        policy_hash: [u8; 32],
        mode: u8,
        setup_nonce: Vec<u8>,
    ) -> Result<Self> {
        if is_zero(&sid) {
            return Err(CoreError::InvalidInput);
        }
        if mode != Profile::TestOracle as u8 {
            return Err(CoreError::ProdEvidenceMissing);
        }
        if setup_nonce.is_empty() || setup_nonce.len() > MAX_SETUP_NONCE_BYTES {
            return Err(CoreError::InvalidLength);
        }
        validate_sorted_parties(&parties)?;
        validate_sorted_xs(&xs)?;

        Ok(Self {
            sid,
            epoch,
            k: K_2OF3 as u8,
            n: PARTIES_2OF3 as u8,
            parties,
            xs,
            policy_hash,
            mode,
            setup_nonce,
        })
    }

    /// Identyfikator sesji (`sid`).
    pub fn sid(&self) -> &[u8; 32] {
        &self.sid
    }

    /// Epoka klucza (`epoch`).
    pub fn epoch(&self) -> u64 {
        self.epoch
    }

    /// Próg `k` (stałe `2`).
    pub fn k(&self) -> u8 {
        self.k
    }

    /// Liczba stron `n` (stałe `3`).
    pub fn n(&self) -> u8 {
        self.n
    }

    /// Uporządkowana lista 3 stron (`PartyId`).
    pub fn parties(&self) -> &[PartyId; PARTIES_2OF3] {
        &self.parties
    }

    /// Punkty ewaluacji Shamira przypisane kolejnym stronom z `parties`.
    pub fn xs(&self) -> &[u16; PARTIES_2OF3] {
        &self.xs
    }

    /// Skrót polityki (`policy_hash`).
    pub fn policy_hash(&self) -> &[u8; 32] {
        &self.policy_hash
    }

    /// Tryb profilu (`0x01 = TestOracle`).
    pub fn mode(&self) -> u8 {
        self.mode
    }

    /// Nonce inicjalizacji setupu.
    pub fn setup_nonce(&self) -> &[u8] {
        &self.setup_nonce
    }

    /// Koduje `SetupInit` do kanonicznego CBOR (RFC 8949 §4.2).
    pub fn to_cbor(&self) -> Vec<u8> {
        let mut w = CborWriter::new();
        w.put_map(9);
        w.put_uint(1);
        w.put_bstr(&self.sid);
        w.put_uint(2);
        w.put_uint(self.epoch);
        w.put_uint(3);
        w.put_uint(u64::from(self.k));
        w.put_uint(4);
        w.put_uint(u64::from(self.n));
        w.put_uint(5);
        w.put_array(PARTIES_2OF3);
        for p in &self.parties {
            w.put_bstr(p);
        }
        w.put_uint(6);
        w.put_array(PARTIES_2OF3);
        for &x in &self.xs {
            w.put_uint(u64::from(x));
        }
        w.put_uint(7);
        w.put_bstr(&self.policy_hash);
        w.put_uint(8);
        w.put_uint(u64::from(self.mode));
        w.put_uint(9);
        w.put_bstr(&self.setup_nonce);
        w.into_bytes()
    }

    /// Dekoduje `SetupInit` ze ścisłego kanonicznego CBOR.
    pub fn from_cbor(bytes: &[u8]) -> Result<Self> {
        let mut r = CborReader::new(bytes);
        if r.expect_map()? != 9 {
            return Err(CoreError::NonCanonicalCbor);
        }
        let mut sid = [0u8; 32];
        let mut epoch = 0u64;
        let mut k = 0u64;
        let mut n = 0u64;
        let mut parties = [[0u8; 16]; PARTIES_2OF3];
        let mut xs = [0u16; PARTIES_2OF3];
        let mut policy_hash = [0u8; 32];
        let mut mode = 0u64;
        let mut setup_nonce = Vec::new();

        for key in 1u64..=9 {
            if r.expect_uint()? != key {
                return Err(CoreError::NonCanonicalCbor);
            }
            match key {
                1 => {
                    let b = r.expect_bstr(32)?;
                    if b.len() != 32 {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    sid.copy_from_slice(b);
                }
                2 => epoch = r.expect_uint()?,
                3 => k = r.expect_uint()?,
                4 => n = r.expect_uint()?,
                5 => {
                    if r.expect_array(PARTIES_2OF3)? != PARTIES_2OF3 {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    for slot in &mut parties {
                        let b = r.expect_bstr(16)?;
                        if b.len() != 16 {
                            return Err(CoreError::NonCanonicalCbor);
                        }
                        slot.copy_from_slice(b);
                    }
                }
                6 => {
                    if r.expect_array(PARTIES_2OF3)? != PARTIES_2OF3 {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    for slot in &mut xs {
                        let v = r.expect_uint()?;
                        *slot = u16::try_from(v).map_err(|_| CoreError::NonCanonicalCbor)?;
                    }
                }
                7 => {
                    let b = r.expect_bstr(32)?;
                    if b.len() != 32 {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    policy_hash.copy_from_slice(b);
                }
                8 => mode = r.expect_uint()?,
                _ => {
                    let b = r.expect_bstr(MAX_SETUP_NONCE_BYTES)?;
                    if b.is_empty() {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    setup_nonce = b.to_vec();
                }
            }
        }
        r.expect_end()?;

        if k != K_2OF3 as u64 || n != PARTIES_2OF3 as u64 {
            return Err(CoreError::NonCanonicalCbor);
        }
        let mode_u8 = u8::try_from(mode).map_err(|_| CoreError::NonCanonicalCbor)?;
        Self::new(sid, epoch, parties, xs, policy_hash, mode_u8, setup_nonce)
    }
}

impl TryFrom<&[u8]> for SetupInit {
    type Error = CoreError;

    fn try_from(value: &[u8]) -> Result<Self> {
        Self::from_cbor(value)
    }
}

/// Payload `0x05 VSS_SHARE` (prywatny pakiet udziałów i zobowiązań od dealera
/// dla konkretnego odbiorcy, obejmujący wszystkie `SEED_INSTANCES = 32` instancje).
///
/// Kanoniczna mapa CBOR o kluczach `1..=4`:
/// `{1: dealer (16 B), 2: dealer_x (uint), 3: shares ([*bstr .size 66]), 4: commitments ([*bstr .size 64])}`.
pub struct VssSharePayload {
    dealer: PartyId,
    dealer_x: u16,
    shares: Vec<ExpShare>,
    commitments: Vec<VssCommitments>,
}

impl std::fmt::Debug for VssSharePayload {
    /// `Debug` nie ujawnia wartości udziałów `shares`.
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("VssSharePayload")
            .field("dealer", &self.dealer)
            .field("dealer_x", &self.dealer_x)
            .field("instances", &self.shares.len())
            .finish_non_exhaustive()
    }
}

impl VssSharePayload {
    /// Buduje pakiet `VssSharePayload` dla 32 instancji seeda.
    pub fn new(
        dealer: PartyId,
        dealer_x: u16,
        shares: Vec<ExpShare>,
        commitments: Vec<VssCommitments>,
    ) -> Result<Self> {
        if is_zero(&dealer) {
            return Err(CoreError::InvalidInput);
        }
        if dealer_x == 0 {
            return Err(CoreError::XZero);
        }
        if dealer_x >= Q {
            return Err(CoreError::OutOfRange);
        }
        if shares.len() != SEED_INSTANCES || commitments.len() != SEED_INSTANCES {
            return Err(CoreError::InvalidLength);
        }
        let recipient_x = shares[0].x();
        for (s, c) in shares.iter().zip(commitments.iter()) {
            if s.x() != recipient_x {
                return Err(CoreError::InconsistentShare);
            }
            if c.len() != K_2OF3 {
                return Err(CoreError::ThresholdTooLow);
            }
        }
        Ok(Self {
            dealer,
            dealer_x,
            shares,
            commitments,
        })
    }

    /// Identyfikator dealera (`PartyId`).
    pub fn dealer(&self) -> &PartyId {
        &self.dealer
    }

    /// Punkt ewaluacji dealera (`1..q`).
    pub fn dealer_x(&self) -> u16 {
        self.dealer_x
    }

    /// Udziały wykładnikowe (`32` instancje) przeznaczone dla odbiorcy.
    pub fn shares(&self) -> &[ExpShare] {
        &self.shares
    }

    /// Zobowiązania Pedersena (`32` instancje) dealera.
    pub fn commitments(&self) -> &[VssCommitments] {
        &self.commitments
    }

    /// Koduje `VssSharePayload` do kanonicznego CBOR.
    pub fn to_cbor(&self) -> Vec<u8> {
        let mut w = CborWriter::new();
        w.put_map(4);
        w.put_uint(1);
        w.put_bstr(&self.dealer);
        w.put_uint(2);
        w.put_uint(u64::from(self.dealer_x));
        w.put_uint(3);
        w.put_array(SEED_INSTANCES);
        for s in &self.shares {
            w.put_bstr(&s.to_bytes());
        }
        w.put_uint(4);
        w.put_array(SEED_INSTANCES);
        for c in &self.commitments {
            w.put_bstr(&c.to_bytes());
        }
        w.into_bytes()
    }

    /// Dekoduje `VssSharePayload` z kanonicznego CBOR.
    pub fn from_cbor(bytes: &[u8]) -> Result<Self> {
        let mut r = CborReader::new(bytes);
        if r.expect_map()? != 4 {
            return Err(CoreError::NonCanonicalCbor);
        }
        let mut dealer = [0u8; 16];
        let mut dealer_x = 0u16;
        let mut shares = Vec::with_capacity(SEED_INSTANCES);
        let mut commitments = Vec::with_capacity(SEED_INSTANCES);

        for key in 1u64..=4 {
            if r.expect_uint()? != key {
                return Err(CoreError::NonCanonicalCbor);
            }
            match key {
                1 => {
                    let b = r.expect_bstr(16)?;
                    if b.len() != 16 {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    dealer.copy_from_slice(b);
                }
                2 => {
                    let v = r.expect_uint()?;
                    dealer_x = u16::try_from(v).map_err(|_| CoreError::NonCanonicalCbor)?;
                }
                3 => {
                    if r.expect_array(SEED_INSTANCES)? != SEED_INSTANCES {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    for _ in 0..SEED_INSTANCES {
                        let b = r.expect_bstr(EXP_SHARE_BYTES)?;
                        if b.len() != EXP_SHARE_BYTES {
                            return Err(CoreError::NonCanonicalCbor);
                        }
                        let share =
                            ExpShare::try_from(b).map_err(|_| CoreError::NonCanonicalCbor)?;
                        shares.push(share);
                    }
                }
                _ => {
                    if r.expect_array(SEED_INSTANCES)? != SEED_INSTANCES {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    for _ in 0..SEED_INSTANCES {
                        let b = r.expect_bstr(COMMITMENTS_2OF3_BYTES)?;
                        if b.len() != COMMITMENTS_2OF3_BYTES {
                            return Err(CoreError::NonCanonicalCbor);
                        }
                        let comm =
                            VssCommitments::from_bytes(b).map_err(|_| CoreError::NonCanonicalCbor)?;
                        commitments.push(comm);
                    }
                }
            }
        }
        r.expect_end()?;
        Self::new(dealer, dealer_x, shares, commitments)
    }
}

impl TryFrom<&[u8]> for VssSharePayload {
    type Error = CoreError;

    fn try_from(value: &[u8]) -> Result<Self> {
        Self::from_cbor(value)
    }
}

/// Payload `0x06 COMPLAINT` (publiczna skarga z dowodem niezgodnego udziału,
/// zgodna z `complaint_payload` w `payloads_v0.cddl`).
///
/// Kanoniczna mapa CBOR o kluczach `1..=5`:
/// `{1: accused (16 B), 2: dealer/complainant (16 B), 3: share (66 B), 4: blind (32 B), 5: index (uint)}`.
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct ComplaintPayload {
    accused: PartyId,
    complainant: PartyId,
    share_bytes: [u8; EXP_SHARE_BYTES],
    blind: [u8; 32],
    index: u8,
}

impl ComplaintPayload {
    /// Tworzy skargę przeciwko `accused` dla instancji `index < 32`.
    pub fn new(
        accused: PartyId,
        complainant: PartyId,
        share: &ExpShare,
        index: u8,
    ) -> Result<Self> {
        if is_zero(&accused) || is_zero(&complainant) || accused == complainant {
            return Err(CoreError::InvalidInput);
        }
        if index as usize >= SEED_INSTANCES {
            return Err(CoreError::OutOfRange);
        }
        Ok(Self {
            accused,
            complainant,
            share_bytes: share.to_bytes(),
            blind: share.t_bytes(),
            index,
        })
    }

    /// Oskarżony dealer (`PartyId`), który przysłał niespójny udział.
    pub fn accused(&self) -> &PartyId {
        &self.accused
    }

    /// Strona zgłaszająca skargę (`PartyId`).
    pub fn complainant(&self) -> &PartyId {
        &self.complainant
    }

    /// Zserializowany wadliwy udział (`x || s || t`, 66 B).
    pub fn share_bytes(&self) -> &[u8; EXP_SHARE_BYTES] {
        &self.share_bytes
    }

    /// Odtworzony obiekt [`ExpShare`] ze skargi.
    pub fn share(&self) -> Result<ExpShare> {
        ExpShare::from_bytes(&self.share_bytes)
    }

    /// Kanoniczne bajty blindu `t` (32 B).
    pub fn blind(&self) -> &[u8; 32] {
        &self.blind
    }

    /// Indeks instancji seeda (`0..31`), w której wykryto fałszerstwo.
    pub fn index(&self) -> u8 {
        self.index
    }

    /// Koduje `ComplaintPayload` do kanonicznego CBOR.
    pub fn to_cbor(&self) -> Vec<u8> {
        let mut w = CborWriter::new();
        w.put_map(5);
        w.put_uint(1);
        w.put_bstr(&self.accused);
        w.put_uint(2);
        w.put_bstr(&self.complainant);
        w.put_uint(3);
        w.put_bstr(&self.share_bytes);
        w.put_uint(4);
        w.put_bstr(&self.blind);
        w.put_uint(5);
        w.put_uint(u64::from(self.index));
        w.into_bytes()
    }

    /// Dekoduje `ComplaintPayload` z kanonicznego CBOR.
    pub fn from_cbor(bytes: &[u8]) -> Result<Self> {
        let mut r = CborReader::new(bytes);
        if r.expect_map()? != 5 {
            return Err(CoreError::NonCanonicalCbor);
        }
        let mut accused = [0u8; 16];
        let mut complainant = [0u8; 16];
        let mut share_bytes = [0u8; EXP_SHARE_BYTES];
        let mut blind = [0u8; 32];
        let mut index = 0u8;

        for key in 1u64..=5 {
            if r.expect_uint()? != key {
                return Err(CoreError::NonCanonicalCbor);
            }
            match key {
                1 => {
                    let b = r.expect_bstr(16)?;
                    if b.len() != 16 {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    accused.copy_from_slice(b);
                }
                2 => {
                    let b = r.expect_bstr(16)?;
                    if b.len() != 16 {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    complainant.copy_from_slice(b);
                }
                3 => {
                    let b = r.expect_bstr(EXP_SHARE_BYTES)?;
                    if b.len() != EXP_SHARE_BYTES {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    share_bytes.copy_from_slice(b);
                }
                4 => {
                    let b = r.expect_bstr(32)?;
                    if b.len() != 32 {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    blind.copy_from_slice(b);
                }
                _ => {
                    let v = r.expect_uint()?;
                    index = u8::try_from(v).map_err(|_| CoreError::NonCanonicalCbor)?;
                }
            }
        }
        r.expect_end()?;

        let share = ExpShare::from_bytes(&share_bytes).map_err(|_| CoreError::NonCanonicalCbor)?;
        if share.t_bytes() != blind {
            return Err(CoreError::NonCanonicalCbor);
        }
        Self::new(accused, complainant, &share, index).map_err(|_| CoreError::NonCanonicalCbor)
    }
}

impl TryFrom<&[u8]> for ComplaintPayload {
    type Error = CoreError;

    fn try_from(value: &[u8]) -> Result<Self> {
        Self::from_cbor(value)
    }
}

/// Payload `0x08 SETUP_FINAL` (podsumowanie setupu: `pk_hash`, `dkg_root`,
/// listy `accepted` i `disqualified`).
///
/// Kanoniczna mapa CBOR o kluczach `1..=4`:
/// `{1: pk_hash (32 B), 2: dkg_root (32 B), 3: accepted ([*bstr .size 16]), 4: disqualified ([*bstr .size 16])}`.
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct SetupFinal {
    pk_hash: [u8; 32],
    dkg_root: [u8; 32],
    accepted: Vec<PartyId>,
    disqualified: Vec<PartyId>,
}

impl SetupFinal {
    /// Tworzy i waliduje `SetupFinal`. Listy `accepted` i `disqualified`
    /// muszą być ściśle posortowane rosnąco i rozłączne.
    pub fn new(
        pk_hash: [u8; 32],
        dkg_root: [u8; 32],
        accepted: Vec<PartyId>,
        disqualified: Vec<PartyId>,
    ) -> Result<Self> {
        if is_zero(&pk_hash) || is_zero(&dkg_root) {
            return Err(CoreError::InvalidInput);
        }
        if accepted.len() + disqualified.len() > PARTIES_2OF3 {
            return Err(CoreError::PartyCountMismatch);
        }
        validate_sorted_party_slice(&accepted)?;
        validate_sorted_party_slice(&disqualified)?;
        for a in &accepted {
            if disqualified.contains(a) {
                return Err(CoreError::DuplicateX);
            }
        }
        Ok(Self {
            pk_hash,
            dkg_root,
            accepted,
            disqualified,
        })
    }

    /// Skrót klucza publicznego (`pk_hash`).
    pub fn pk_hash(&self) -> &[u8; 32] {
        &self.pk_hash
    }

    /// Korzeń transkryptu DKG (`dkg_root`).
    pub fn dkg_root(&self) -> &[u8; 32] {
        &self.dkg_root
    }

    /// Zaakceptowane strony (ściśle rosnąco).
    pub fn accepted(&self) -> &[PartyId] {
        &self.accepted
    }

    /// Zdyskwalifikowane strony (ściśle rosnąco).
    pub fn disqualified(&self) -> &[PartyId] {
        &self.disqualified
    }

    /// Koduje `SetupFinal` do kanonicznego CBOR.
    pub fn to_cbor(&self) -> Vec<u8> {
        let mut w = CborWriter::new();
        w.put_map(4);
        w.put_uint(1);
        w.put_bstr(&self.pk_hash);
        w.put_uint(2);
        w.put_bstr(&self.dkg_root);
        w.put_uint(3);
        w.put_array(self.accepted.len());
        for p in &self.accepted {
            w.put_bstr(p);
        }
        w.put_uint(4);
        w.put_array(self.disqualified.len());
        for p in &self.disqualified {
            w.put_bstr(p);
        }
        w.into_bytes()
    }

    /// Dekoduje `SetupFinal` z kanonicznego CBOR.
    pub fn from_cbor(bytes: &[u8]) -> Result<Self> {
        let mut r = CborReader::new(bytes);
        if r.expect_map()? != 4 {
            return Err(CoreError::NonCanonicalCbor);
        }
        let mut pk_hash = [0u8; 32];
        let mut dkg_root = [0u8; 32];
        let mut accepted = Vec::new();
        let mut disqualified = Vec::new();

        for key in 1u64..=4 {
            if r.expect_uint()? != key {
                return Err(CoreError::NonCanonicalCbor);
            }
            match key {
                1 => {
                    let b = r.expect_bstr(32)?;
                    if b.len() != 32 {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    pk_hash.copy_from_slice(b);
                }
                2 => {
                    let b = r.expect_bstr(32)?;
                    if b.len() != 32 {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    dkg_root.copy_from_slice(b);
                }
                3 => {
                    let len = r.expect_array(PARTIES_2OF3)?;
                    accepted = Vec::with_capacity(len);
                    for _ in 0..len {
                        let b = r.expect_bstr(16)?;
                        if b.len() != 16 {
                            return Err(CoreError::NonCanonicalCbor);
                        }
                        let mut id = [0u8; 16];
                        id.copy_from_slice(b);
                        accepted.push(id);
                    }
                }
                _ => {
                    let len = r.expect_array(PARTIES_2OF3)?;
                    disqualified = Vec::with_capacity(len);
                    for _ in 0..len {
                        let b = r.expect_bstr(16)?;
                        if b.len() != 16 {
                            return Err(CoreError::NonCanonicalCbor);
                        }
                        let mut id = [0u8; 16];
                        id.copy_from_slice(b);
                        disqualified.push(id);
                    }
                }
            }
        }
        r.expect_end()?;
        Self::new(pk_hash, dkg_root, accepted, disqualified)
            .map_err(|_| CoreError::NonCanonicalCbor)
    }
}

impl TryFrom<&[u8]> for SetupFinal {
    type Error = CoreError;

    fn try_from(value: &[u8]) -> Result<Self> {
        Self::from_cbor(value)
    }
}

/// Wkład własny węzła na wejściu do Rundy 1: współczynniki wielomianów
/// stopnia `k-1 = 1` w $\mathbb{Z}_q$ oraz 32-bajtowe blindy skalarne dla
/// wszystkich 32 instancji seeda.
pub struct LocalDealInput {
    coeffs: [[u16; K_2OF3]; SEED_INSTANCES],
    blinds: [[[u8; 32]; K_2OF3]; SEED_INSTANCES],
}

impl LocalDealInput {
    /// Tworzy zestaw danych wejściowych dla `vss::deal` w 32 instancjach.
    pub fn new(
        coeffs: [[u16; K_2OF3]; SEED_INSTANCES],
        blinds: [[[u8; 32]; K_2OF3]; SEED_INSTANCES],
    ) -> Result<Self> {
        for inst in &coeffs {
            for &c in inst {
                if c >= Q {
                    return Err(CoreError::OutOfRange);
                }
            }
        }
        Ok(Self { coeffs, blinds })
    }
}

/// Maszyna stanów sesji Setupu 2-z-3 (`P_1, P_2, P_3`) na profilu `TEST-ORACLE`.
pub struct SetupSession {
    init: SetupInit,
    pk_hash: [u8; 32],
    me_id: PartyId,
    me_x: u16,
    receiver: SessionReceiver,
    next_seq: BTreeMap<PartyId, u64>,
    contributions: BTreeMap<(u16, u8), DealerContribution>,
    dealer_commitments: BTreeMap<PartyId, Vec<VssCommitments>>,
    complaints: Vec<ComplaintPayload>,
    disqualified: BTreeSet<PartyId>,
    aborted: bool,
}

impl SetupSession {
    /// Otwiera nową sesję setupu dla węzła `me_id` na podstawie `SetupInit`.
    pub fn new(init: SetupInit, pk_hash: [u8; 32], me_id: PartyId) -> Result<Self> {
        if is_zero(&pk_hash) {
            return Err(CoreError::InvalidInput);
        }
        let mut me_x = None;
        for (p, &x) in init.parties.iter().zip(init.xs.iter()) {
            if *p == me_id {
                me_x = Some(x);
                break;
            }
        }
        let me_x = me_x.ok_or(CoreError::PartyCountMismatch)?;
        let receiver = SessionReceiver::new(init.sid, init.epoch, me_id)?;

        Ok(Self {
            init,
            pk_hash,
            me_id,
            me_x,
            receiver,
            next_seq: BTreeMap::new(),
            contributions: BTreeMap::new(),
            dealer_commitments: BTreeMap::new(),
            complaints: Vec::new(),
            disqualified: BTreeSet::new(),
            aborted: false,
        })
    }

    /// Identyfikator własnego węzła (`PartyId`).
    pub fn me_id(&self) -> &PartyId {
        &self.me_id
    }

    /// Punkt ewaluacji własnego węzła (`1..q`).
    pub fn me_x(&self) -> u16 {
        self.me_x
    }

    /// Czy sesja została przerwana wskutek wykrycia oszustwa (fail-closed).
    pub fn is_aborted(&self) -> bool {
        self.aborted
    }

    /// Wygenerowane skargi ([`ComplaintPayload`]).
    pub fn complaints(&self) -> &[ComplaintPayload] {
        &self.complaints
    }

    /// Zbiór zdyskwalifikowanych stron (`PartyId`).
    pub fn disqualified(&self) -> &BTreeSet<PartyId> {
        &self.disqualified
    }

    /// Mapuje `PartyId` na punkt ewaluacji `x` w bieżącej sesji.
    pub fn party_x(&self, party: &PartyId) -> Result<u16> {
        for (p, &x) in self.init.parties.iter().zip(self.init.xs.iter()) {
            if p == party {
                return Ok(x);
            }
        }
        Err(CoreError::PartyCountMismatch)
    }

    /// **Runda 1:** Generuje wkład VSS dla 32 instancji seeda, rejestruje
    /// własne udziały i buduje uwierzytelnione koperty [`Envelope`] dla
    /// pozostałych dwóch stron.
    pub fn deal_round1(
        &mut self,
        input: &LocalDealInput,
        peer_keys: &[(&PartyId, &EnvelopeKey); 2],
    ) -> Result<[Envelope; 2]> {
        if self.aborted {
            return Err(CoreError::InconsistentShare);
        }
        // Sprawdzamy, że klucze odpowiadają dokładnie dwóm pozostałym stronom.
        for &(peer_id, key) in peer_keys {
            if *peer_id == self.me_id {
                return Err(CoreError::InvalidInput);
            }
            let _ = self.party_x(peer_id)?;
            if key.sender() != &self.me_id || key.recipient() != peer_id {
                return Err(CoreError::AuthFail);
            }
        }
        if peer_keys[0].0 == peer_keys[1].0 {
            return Err(CoreError::DuplicateX);
        }

        let mut all_comms = Vec::with_capacity(SEED_INSTANCES);
        let mut peer0_shares = Vec::with_capacity(SEED_INSTANCES);
        let mut peer1_shares = Vec::with_capacity(SEED_INSTANCES);

        let peer0_x = self.party_x(peer_keys[0].0)?;
        let peer1_x = self.party_x(peer_keys[1].0)?;

        for inst in 0..SEED_INSTANCES {
            let (comms, shares) =
                vss::deal(&input.coeffs[inst], &input.blinds[inst], &self.init.xs)?;
            let mut my_share = None;
            let mut p0_share = None;
            let mut p1_share = None;

            for s in shares {
                if s.x() == self.me_x {
                    my_share = Some(s);
                } else if s.x() == peer0_x {
                    p0_share = Some(s);
                } else if s.x() == peer1_x {
                    p1_share = Some(s);
                }
            }

            let my_share = my_share.ok_or(CoreError::PartyCountMismatch)?;
            let p0_share = p0_share.ok_or(CoreError::PartyCountMismatch)?;
            let p1_share = p1_share.ok_or(CoreError::PartyCountMismatch)?;

            let contrib =
                DealerContribution::new(self.me_x, inst as u8, comms.clone(), my_share)?;
            self.contributions.insert((self.me_x, inst as u8), contrib);

            all_comms.push(comms);
            peer0_shares.push(p0_share);
            peer1_shares.push(p1_share);
        }

        self.dealer_commitments
            .insert(self.me_id, all_comms.clone());

        let payload0 = VssSharePayload::new(self.me_id, self.me_x, peer0_shares, all_comms.clone())?;
        let payload1 = VssSharePayload::new(self.me_id, self.me_x, peer1_shares, all_comms)?;

        let env0 = self.seal_message(peer_keys[0].1, 1, MSG_VSS_SHARE, payload0.to_cbor())?;
        let env1 = self.seal_message(peer_keys[1].1, 1, MSG_VSS_SHARE, payload1.to_cbor())?;

        Ok([env0, env1])
    }

    /// **Runda 2:** Odbiera kopertę `MSG_VSS_SHARE` od innego węzła przez
    /// [`SessionReceiver::accept`] i weryfikuje wszystkie 32 udziały względem
    /// zobowiązań dealera za pomocą [`vss::verify_share`].
    ///
    /// Jeśli którykolwiek udział jest sfałszowany:
    /// - generuje i zapisuje [`ComplaintPayload`] wskazujący nieuczciwego dealera,
    /// - oznacza dealera jako zdyskwalifikowanego w `self.disqualified`,
    /// - przechodzi w stan `aborted = true` (fail-closed) i zwraca
    ///   `Err(CoreError::InconsistentShare)`.
    pub fn receive_vss_envelope(&mut self, key: &EnvelopeKey, env: Envelope) -> Result<Delivery> {
        if self.aborted {
            return Err(CoreError::InconsistentShare);
        }
        let (body, delivery) = self.receiver.accept(key, env)?;
        if delivery == Delivery::Duplicate {
            return Ok(Delivery::Duplicate);
        }
        if body.round() != 1 || body.msg_type() != MSG_VSS_SHARE {
            return Err(CoreError::InvalidInput);
        }

        let payload = VssSharePayload::from_cbor(body.payload())?;
        if &payload.dealer != body.sender() || payload.dealer == self.me_id {
            return Err(CoreError::InvalidInput);
        }
        let expected_dealer_x = self.party_x(&payload.dealer)?;
        if payload.dealer_x != expected_dealer_x {
            return Err(CoreError::InvalidInput);
        }

        self.dealer_commitments
            .insert(payload.dealer, payload.commitments.clone());

        for (inst, (share, comms)) in payload
            .shares
            .iter()
            .zip(payload.commitments.iter())
            .enumerate()
        {
            if share.x() != self.me_x || vss::verify_share(share, comms).is_err() {
                let complaint =
                    ComplaintPayload::new(payload.dealer, self.me_id, share, inst as u8)?;
                self.complaints.push(complaint);
                self.disqualified.insert(payload.dealer);
                self.aborted = true;
                return Err(CoreError::InconsistentShare);
            }
        }

        for (inst, (share, comms)) in payload
            .shares
            .into_iter()
            .zip(payload.commitments.into_iter())
            .enumerate()
        {
            let contrib = DealerContribution::new(expected_dealer_x, inst as u8, comms, share)?;
            self.contributions
                .insert((expected_dealer_x, inst as u8), contrib);
        }

        Ok(Delivery::New)
    }

    /// Opakowuje wygenerowaną skargę [`ComplaintPayload`] w uwierzytelnioną
    /// kopertę `MSG_COMPLAINT` (Runda 2) do wysłania pozostałym stronom.
    pub fn seal_complaint(
        &mut self,
        key: &EnvelopeKey,
        complaint: &ComplaintPayload,
    ) -> Result<Envelope> {
        if complaint.complainant != self.me_id {
            return Err(CoreError::InvalidInput);
        }
        self.seal_message(key, 2, MSG_COMPLAINT, complaint.to_cbor())
    }

    /// Odbiera i weryfikuje skargę `MSG_COMPLAINT` od innego węzła.
    ///
    /// * Jeśli udział w skardze faktycznie nie przechodzi [`vss::verify_share`]
    ///   względem zarejestrowanych zobowiązań `accused`, węzeł dyskwalifikuje
    ///   `accused`, oznacza sesję jako `aborted` i zwraca `Err(CoreError::InconsistentShare)`.
    /// * Jeśli udział w skardze jest poprawny względem zobowiązań `accused`,
    ///   oznacza to fałszywe oskarżenie — dyskwalifikowany jest `complainant`.
    pub fn receive_complaint_envelope(
        &mut self,
        key: &EnvelopeKey,
        env: Envelope,
    ) -> Result<PartyId> {
        let (body, _delivery) = self.receiver.accept(key, env)?;
        if body.round() != 2 || body.msg_type() != MSG_COMPLAINT {
            return Err(CoreError::InvalidInput);
        }
        let complaint = ComplaintPayload::from_cbor(body.payload())?;
        if &complaint.complainant != body.sender() {
            return Err(CoreError::InvalidInput);
        }
        let _ = self.party_x(&complaint.accused)?;
        let complainant_x = self.party_x(&complaint.complainant)?;
        let share = complaint.share()?;

        let blamed = if share.x() != complainant_x {
            complaint.complainant
        } else if let Some(comms_vec) = self.dealer_commitments.get(&complaint.accused) {
            let comms = comms_vec
                .get(complaint.index as usize)
                .ok_or(CoreError::OutOfRange)?;
            if vss::verify_share(&share, comms).is_err() {
                complaint.accused
            } else {
                complaint.complainant
            }
        } else {
            complaint.accused
        };

        self.complaints.push(complaint);
        self.disqualified.insert(blamed);
        self.aborted = true;
        Err(CoreError::InconsistentShare)
    }

    /// **Runda 3 (Finalizacja):** Jeśli wszystkie 3 strony dostarczyły poprawne
    /// wkłady i nie ma żadnych skarg ani dyskwalifikacji:
    /// - agreguje udziały i zobowiązania wszystkich 32 instancji,
    /// - wylicza kanoniczny `dkg_root` ([`dkg_root`]),
    /// - przeprowadza walidację typestate do [`PartyState<DkgOk>`] oraz
    ///   zwraca strukturę [`SetupFinal`].
    pub fn finalize(self) -> Result<(PartyState<DkgOk>, SetupFinal)> {
        if self.aborted || !self.disqualified.is_empty() || !self.complaints.is_empty() {
            return Err(CoreError::InconsistentShare);
        }
        if self.contributions.len() != PARTIES_2OF3 * SEED_INSTANCES {
            return Err(CoreError::PartyCountMismatch);
        }

        let ordered: Vec<DealerContribution> = self.contributions.into_values().collect();
        let root = dkg_root(
            &self.init.sid,
            &self.pk_hash,
            K_2OF3,
            &self.init.xs,
            &ordered,
        )?;

        let unvalidated = PartyState::new(
            self.init.sid,
            self.pk_hash,
            self.init.xs.to_vec(),
            self.me_x,
            K_2OF3,
        )?;
        let dkg_ok = unvalidated.validate_dkg(&ordered, &root)?;
        let final_msg = SetupFinal::new(
            self.pk_hash,
            root,
            self.init.parties.to_vec(),
            Vec::new(),
        )?;

        Ok((dkg_ok, final_msg))
    }

    fn seal_message(
        &mut self,
        key: &EnvelopeKey,
        round: u64,
        msg_type: u16,
        payload: Vec<u8>,
    ) -> Result<Envelope> {
        let seq_entry = self.next_seq.entry(*key.recipient()).or_insert(0);
        *seq_entry += 1;
        let seq = *seq_entry;
        let body = Body::new(
            self.init.sid,
            self.init.epoch,
            round,
            seq,
            msg_type,
            self.me_id,
            payload,
        )?;
        Envelope::seal(key, body)
    }
}

fn is_zero(bytes: &[u8]) -> bool {
    bytes.iter().all(|&b| b == 0)
}

fn validate_sorted_parties(parties: &[PartyId; PARTIES_2OF3]) -> Result<()> {
    for i in 0..PARTIES_2OF3 {
        if is_zero(&parties[i]) {
            return Err(CoreError::InvalidInput);
        }
        if i > 0 && parties[i - 1] >= parties[i] {
            return Err(CoreError::DuplicateX);
        }
    }
    Ok(())
}

fn validate_sorted_party_slice(parties: &[PartyId]) -> Result<()> {
    for i in 0..parties.len() {
        if is_zero(&parties[i]) {
            return Err(CoreError::InvalidInput);
        }
        if i > 0 && parties[i - 1] >= parties[i] {
            return Err(CoreError::DuplicateX);
        }
    }
    Ok(())
}

fn validate_sorted_xs(xs: &[u16; PARTIES_2OF3]) -> Result<()> {
    for i in 0..PARTIES_2OF3 {
        if xs[i] == 0 {
            return Err(CoreError::XZero);
        }
        if xs[i] >= Q {
            return Err(CoreError::OutOfRange);
        }
        if i > 0 && xs[i - 1] >= xs[i] {
            return Err(CoreError::DuplicateX);
        }
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::{
        ComplaintPayload, K_2OF3, LocalDealInput, MSG_VSS_SHARE, PARTIES_2OF3, SetupFinal,
        SetupInit, SetupSession, VssSharePayload,
    };
    use crate::envelope::{Body, Delivery, Envelope, EnvelopeKey, PartyId};
    use crate::state::SEED_INSTANCES;
    use ft_threshold_core::Profile;
    use ft_threshold_core::error::CoreError;
    use ft_threshold_core::ring::Q;
    use ft_threshold_core::vss::{self, ExpShare};
    use sha3::{Digest, Sha3_512};

    const SID: [u8; 32] = [0x42; 32];
    const PK_HASH: [u8; 32] = [0x99; 32];
    const POLICY_HASH: [u8; 32] = [0x77; 32];
    const EPOCH: u64 = 1;

    const P1: PartyId = [0x01; 16];
    const P2: PartyId = [0x02; 16];
    const P3: PartyId = [0x03; 16];
    const PARTIES: [PartyId; PARTIES_2OF3] = [P1, P2, P3];
    const XS: [u16; PARTIES_2OF3] = [1, 2, 3];

    fn pair_key(sender: PartyId, recipient: PartyId) -> EnvelopeKey {
        let mut psk = [0u8; 32];
        psk[..16].copy_from_slice(&sender);
        psk[16..].copy_from_slice(&recipient);
        EnvelopeKey::derive_psk(&psk, SID, EPOCH, sender, recipient).expect("pair key")
    }

    fn deterministic_blind(party_tag: u8, inst: u8, coeff_idx: u8) -> [u8; 32] {
        let mut h = Sha3_512::new();
        h.update(b"FT1536/WP-030/test-blind");
        h.update([party_tag, inst, coeff_idx]);
        let digest = h.finalize();
        let mut out = [0u8; 32];
        out.copy_from_slice(&digest[..32]);
        // < 2^251 < L (kanoniczny Scalar w Ristretto255/Curve25519)
        out[31] &= 0b0000_0111;
        out
    }

    fn make_deal_input(party_tag: u8) -> LocalDealInput {
        let mut coeffs = [[0u16; K_2OF3]; SEED_INSTANCES];
        let mut blinds = [[[0u8; 32]; K_2OF3]; SEED_INSTANCES];
        for inst in 0..SEED_INSTANCES {
            coeffs[inst][0] = (u16::from(party_tag) * 100 + inst as u16 + 1) % Q;
            coeffs[inst][1] = (u16::from(party_tag) * 37 + inst as u16 * 3 + 5) % Q;
            blinds[inst][0] = deterministic_blind(party_tag, inst as u8, 0);
            blinds[inst][1] = deterministic_blind(party_tag, inst as u8, 1);
        }
        LocalDealInput::new(coeffs, blinds).expect("valid local deal input")
    }

    fn sample_setup_init() -> SetupInit {
        SetupInit::new(
            SID,
            EPOCH,
            PARTIES,
            XS,
            POLICY_HASH,
            Profile::TestOracle as u8,
            b"wp030-setup-nonce".to_vec(),
        )
        .expect("setup init")
    }

    #[test]
    fn setup_payload_codecs_satisfy_canonical_fixpoint() {
        // 1. SetupInit roundtrip + fixpoint
        let init = sample_setup_init();
        let init_bytes = init.to_cbor();
        let init_dec = SetupInit::from_cbor(&init_bytes).expect("decode SetupInit");
        assert_eq!(init_dec, init);
        assert_eq!(init_dec.to_cbor(), init_bytes);

        // Nieposortowane strony w SetupInit są odrzucane.
        assert!(
            SetupInit::new(
                SID,
                EPOCH,
                [P2, P1, P3],
                XS,
                POLICY_HASH,
                Profile::TestOracle as u8,
                b"nonce".to_vec(),
            )
            .is_err()
        );

        // 2. ComplaintPayload roundtrip + fixpoint
        let share = ExpShare::new(1, [0x01; 32], [0x02; 32]).expect("exp share");
        let complaint = ComplaintPayload::new(P2, P1, &share, 7).expect("complaint");
        let comp_bytes = complaint.to_cbor();
        let comp_dec = ComplaintPayload::from_cbor(&comp_bytes).expect("decode ComplaintPayload");
        assert_eq!(comp_dec, complaint);
        assert_eq!(comp_dec.to_cbor(), comp_bytes);

        // 3. SetupFinal roundtrip + fixpoint
        let final_msg =
            SetupFinal::new(PK_HASH, [0xab; 32], vec![P1, P3], vec![P2]).expect("setup final");
        let final_bytes = final_msg.to_cbor();
        let final_dec = SetupFinal::from_cbor(&final_bytes).expect("decode SetupFinal");
        assert_eq!(final_dec, final_msg);
        assert_eq!(final_dec.to_cbor(), final_bytes);
    }

    /// **Test 1 (Uczciwy):** Trzy węzły ($P_1, P_2, P_3$) wykonują pełny
    /// protokół setupu 2-z-3, wymieniając uwierzytelnione koperty. Wszystkie
    /// 3 kończą sukcesem, uzyskując identyczny `dkg_root` oraz spójne
    /// udziały sekretu w `PartyState<DkgOk>`.
    #[test]
    #[cfg_attr(
        miri,
        ignore = "Ristretto 3x32 instancje VSS w Miri są zbyt wolne; pokrywane przez natywny cargo test"
    )]
    fn honest_three_party_setup_reaches_identical_dkg_root_and_dkg_ok() {
        let init = sample_setup_init();

        let mut s1 = SetupSession::new(init.clone(), PK_HASH, P1).expect("s1");
        let mut s2 = SetupSession::new(init.clone(), PK_HASH, P2).expect("s2");
        let mut s3 = SetupSession::new(init, PK_HASH, P3).expect("s3");

        let k12 = pair_key(P1, P2);
        let k13 = pair_key(P1, P3);
        let k21 = pair_key(P2, P1);
        let k23 = pair_key(P2, P3);
        let k31 = pair_key(P3, P1);
        let k32 = pair_key(P3, P2);

        // Runda 1: każda strona generuje swój wkład i koperty dla pozostałych dwóch.
        let [env_1_to_2, env_1_to_3] = s1
            .deal_round1(&make_deal_input(1), &[(&P2, &k12), (&P3, &k13)])
            .expect("P1 deal");
        let [env_2_to_1, env_2_to_3] = s2
            .deal_round1(&make_deal_input(2), &[(&P1, &k21), (&P3, &k23)])
            .expect("P2 deal");
        let [env_3_to_1, env_3_to_2] = s3
            .deal_round1(&make_deal_input(3), &[(&P1, &k31), (&P2, &k32)])
            .expect("P3 deal");

        // Runda 2: wymiana i weryfikacja VSS wszystkich kopert.
        assert_eq!(
            s1.receive_vss_envelope(&k21, env_2_to_1).expect("P1 <- P2"),
            Delivery::New
        );
        assert_eq!(
            s1.receive_vss_envelope(&k31, env_3_to_1).expect("P1 <- P3"),
            Delivery::New
        );

        assert_eq!(
            s2.receive_vss_envelope(&k12, env_1_to_2).expect("P2 <- P1"),
            Delivery::New
        );
        assert_eq!(
            s2.receive_vss_envelope(&k32, env_3_to_2).expect("P2 <- P3"),
            Delivery::New
        );

        assert_eq!(
            s3.receive_vss_envelope(&k13, env_1_to_3).expect("P3 <- P1"),
            Delivery::New
        );
        assert_eq!(
            s3.receive_vss_envelope(&k23, env_2_to_3).expect("P3 <- P2"),
            Delivery::New
        );

        assert!(s1.complaints().is_empty() && s1.disqualified().is_empty());
        assert!(s2.complaints().is_empty() && s2.disqualified().is_empty());
        assert!(s3.complaints().is_empty() && s3.disqualified().is_empty());

        // Runda 3: finalizacja i przejście do PartyState<DkgOk>.
        let (state1, final1) = s1.finalize().expect("P1 finalize");
        let (state2, final2) = s2.finalize().expect("P2 finalize");
        let (state3, final3) = s3.finalize().expect("P3 finalize");

        assert_eq!(state1.dkg().root(), state2.dkg().root());
        assert_eq!(state2.dkg().root(), state3.dkg().root());
        assert_eq!(final1, final2);
        assert_eq!(final2, final3);
        assert_eq!(final1.accepted(), &PARTIES[..]);
        assert!(final1.disqualified().is_empty());

        // Sprawdzenie fixpointu CBOR wiadomości finalnej.
        let final_cbor = final1.to_cbor();
        assert_eq!(
            SetupFinal::from_cbor(&final_cbor).expect("decode final"),
            final1
        );

        // Wartość zagregowanego wielomianu w x = 1, 2, 3 odpowiada sumie sekretów dealerów.
        for inst in 0..SEED_INSTANCES {
            let expected_s0: u32 = [1u16, 2, 3]
                .iter()
                .map(|&tag| u32::from((tag * 100 + inst as u16 + 1) % Q))
                .sum::<u32>()
                % u32::from(Q);
            // Interpolacja Lagrange'a z udziałów P1 (x=1) i P2 (x=2) w Z_q:
            // f(0) = 2*f(1) - f(2) (mod q).
            let y1 = u32::from(state1.seed_share()[inst]);
            let y2 = u32::from(state2.seed_share()[inst]);
            let reconstructed = (2 * y1 + u32::from(Q) - y2) % u32::from(Q);
            assert_eq!(reconstructed, expected_s0, "inst={inst}");
        }
    }

    /// **Test 2 (Złośliwy przeciwnik):** Węzeł $P_2$ w Rundzie 1 celowo
    /// przekłamuje bajty swojego udziału wysyłanego do $P_1$. Węzeł $P_1$
    /// weryfikuje udział względem zobowiązań $P_2$, natychmiast wykrywa
    /// oszustwo, generuje `ComplaintPayload` obwiniający $P_2$, wpisuje $P_2$
    /// na listę `disqualified`, a sesja kończy się bezpiecznym odrzuceniem
    /// (fail-closed) i propagacją skargi do $P_3$.
    #[test]
    #[cfg_attr(
        miri,
        ignore = "Ristretto 3x32 instancje VSS w Miri są zbyt wolne; pokrywane przez natywny cargo test"
    )]
    fn malicious_dealer_corrupted_share_triggers_complaint_blame_and_abort() {
        let init = sample_setup_init();

        let mut s1 = SetupSession::new(init.clone(), PK_HASH, P1).expect("s1");
        let mut s2 = SetupSession::new(init.clone(), PK_HASH, P2).expect("s2");
        let mut s3 = SetupSession::new(init, PK_HASH, P3).expect("s3");

        let k12 = pair_key(P1, P2);
        let k13 = pair_key(P1, P3);
        let k21 = pair_key(P2, P1);
        let k23 = pair_key(P2, P3);
        let k31 = pair_key(P3, P1);

        let [_env_1_to_2, env_1_to_3] = s1
            .deal_round1(&make_deal_input(1), &[(&P2, &k12), (&P3, &k13)])
            .expect("P1 deal");
        let [env_2_to_1, env_2_to_3] = s2
            .deal_round1(&make_deal_input(2), &[(&P1, &k21), (&P3, &k23)])
            .expect("P2 deal");

        // Złośliwy P2 otwiera własny pakiet dla P1, przekłamuje wartość udziału
        // w instancji 5 i ponownie pieczętuje kopertę swoim kluczem MAC (k21).
        let honest_payload =
            VssSharePayload::from_cbor(env_2_to_1.body_unverified().payload()).expect("decode P2");
        let mut forged_shares: Vec<ExpShare> = honest_payload
            .shares()
            .iter()
            .map(|s| ExpShare::from_bytes(&s.to_bytes()).expect("clone share"))
            .collect();
        let mut tampered_bytes = forged_shares[5].to_bytes();
        tampered_bytes[2] ^= 0x01; // Modyfikacja najniższego bajtu skalaru `s` w instancji 5
        forged_shares[5] = ExpShare::from_bytes(&tampered_bytes).expect("valid scalar");

        let forged_payload = VssSharePayload::new(
            P2,
            2,
            forged_shares,
            honest_payload.commitments().to_vec(),
        )
        .expect("forged payload");
        let forged_body =
            Body::new(SID, EPOCH, 1, 1, MSG_VSS_SHARE, P2, forged_payload.to_cbor()).expect("body");
        let forged_env_2_to_1 = Envelope::seal(&k21, forged_body).expect("seal forged");

        // P1 odbiera sfałszowany wkład od P2 -> natychmiastowy błąd InconsistentShare!
        let err = s1
            .receive_vss_envelope(&k21, forged_env_2_to_1)
            .unwrap_err();
        assert_eq!(err, CoreError::InconsistentShare);
        assert!(s1.is_aborted());
        assert!(s1.disqualified().contains(&P2));
        assert_eq!(s1.complaints().len(), 1);

        let complaint = s1.complaints()[0].clone();
        assert_eq!(complaint.accused(), &P2);
        assert_eq!(complaint.complainant(), &P1);
        assert_eq!(complaint.index(), 5);

        // P1 rozsyła podpisaną kopertę skargi do P3; P3 po otrzymaniu zobowiązań P2
        // niezależnie weryfikuje dowód winy i również dyskwalifikuje P2.
        s3.receive_vss_envelope(&k13, env_1_to_3).expect("P3 <- P1");
        s3.receive_vss_envelope(&k23, env_2_to_3).expect("P3 <- P2");

        let complaint_env_1_to_3 = s1
            .seal_complaint(&k13, &complaint)
            .expect("seal complaint");
        let p3_err = s3
            .receive_complaint_envelope(&k13, complaint_env_1_to_3)
            .unwrap_err();
        assert_eq!(p3_err, CoreError::InconsistentShare);
        assert!(s3.is_aborted());
        assert!(s3.disqualified().contains(&P2));

        // Próba doliczenia dalszych wiadomości lub finalizacji na uszkodzonej sesji
        // kończy się natychmiastowym odrzuceniem (fail-closed).
        let _ = k31;
        assert_eq!(s1.finalize().unwrap_err(), CoreError::InconsistentShare);
        assert_eq!(s3.finalize().unwrap_err(), CoreError::InconsistentShare);
    }

    #[test]
    fn vss_share_payload_cbor_roundtrip_single_check() {
        let mut coeffs = [[0u16; K_2OF3]; SEED_INSTANCES];
        let mut blinds = [[[0u8; 32]; K_2OF3]; SEED_INSTANCES];
        for i in 0..SEED_INSTANCES {
            coeffs[i] = [10 + i as u16, 20 + i as u16];
            blinds[i] = [[1u8; 32], [2u8; 32]];
        }
        let mut shares = Vec::with_capacity(SEED_INSTANCES);
        let mut comms = Vec::with_capacity(SEED_INSTANCES);
        for i in 0..SEED_INSTANCES {
            let (c, mut sh) = vss::deal(&coeffs[i], &blinds[i], &XS).expect("deal");
            shares.push(sh.remove(0));
            comms.push(c);
        }
        let payload = VssSharePayload::new(P1, 1, shares, comms).expect("payload");
        let bytes = payload.to_cbor();
        let decoded = VssSharePayload::from_cbor(&bytes).expect("decode");
        assert_eq!(decoded.to_cbor(), bytes);
    }
}
