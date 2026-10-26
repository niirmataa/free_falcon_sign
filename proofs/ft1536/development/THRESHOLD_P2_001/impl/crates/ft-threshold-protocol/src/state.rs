//! Typestate setupu: podpis tylko z walidowanego stanu (WP-014, audyt #3).
//!
//! Łańcuch stanów jest wymuszony typami, nie konwencją:
//!
//! ```text
//! PartyState<Unvalidated> --validate_dkg--> PartyState<DkgOk>
//!                          --validate_ntru--> PartyState<Ready>
//!                          --SignSession::begin--> SignSession
//! ```
//!
//! `PartyState<Ready>` nie ma publicznego konstruktora, a `SignSession::begin`
//! przyjmuje wyłącznie `PartyState<Ready>`; nie da się „przeskoczyć” DKG ani
//! NTRU, bo odpowiednie typy są tworzone tylko przez funkcje, które
//! **wykonują** sprawdzenie. Testy `compile_fail` w dokumentacji pilnują,
//! że te ścieżki nie znikną.
//!
//! **Co jest sprawdzane naprawdę:**
//! - DKG: każdy wkład dealera dla każdego z 32 bajtów seeda jest weryfikowany
//!   przez [`vss::verify_share`] względem jego zobowiązań; zobowiązania są
//!   agregowane w kanonicznej kolejności i wiązane z `sid`, `pk_hash` i `k`
//!   w `dkg_root`, który musi się zgadzać z korzeniem transkryptu.
//! - NTRU: relacja `f·h = g` w `R_q` jest liczona na jawnym kluczu.
//!
//! **Czego to nie zastępuje (jawne granice):**
//! - `NtruEvidence::verify_plaintext` to ścieżka `TEST-ORACLE` (G2): używa
//!   jawnego `f,g,h`. `PROD` wymaga sprawdzenia NTRU na udziałach bez
//!   rekonstrukcji (O-05); dlatego [`SignSession::begin`] odrzuca profil
//!   `Prod` z evidence źródła `PlaintextTestkit`.
//! - Wiązanie `pk` z bajtami silnika jest osobnym krokiem (O-05);
//!   `pk_hash` jest tu etykietą transkryptu, nie weryfikacją kodowania.
//! - To jest szkielet typestate, nie pełny protokół setupu (ruchy, complainty
//!   i transkrypt wchodzą w G2/WP-030).

use std::collections::{BTreeMap, BTreeSet};
use std::marker::PhantomData;

use ft_threshold_core::error::{CoreError, Result};
use ft_threshold_core::ring::Poly;
use ft_threshold_core::vss::{self, ExpShare, VssCommitments};
use ft_threshold_core::{MAX_PARTIES_V1, Profile};
use sha3::{Digest, Sha3_512};

/// Liczba instancji Shamira w Fazie A (jeden bajt `seed*` = jedna instancja).
pub const SEED_INSTANCES: usize = 32;

/// Domena korzenia DKG (część transkryptu, nie dowolny string).
pub const DKG_ROOT_DOMAIN: &[u8] = b"FT1536/threshold/v1/dkg-root";

/// Stan przed walidacją setupu.
pub struct Unvalidated;
/// Stan po zweryfikowanym DKG (Faza A).
pub struct DkgOk;
/// Stan po zweryfikowanym DKG **i** NTRU; jedyny, z którego wolno podpisywać.
pub struct Ready;

/// Stan strony w setupie; `S` jest etapem typestate.
///
/// Brak `Clone`: stan `Ready` jest przenoszony do [`SignSession::begin`],
/// więc nie da się z jednego stanu otworzyć dwóch sesji podpisu.
pub struct PartyState<S> {
    sid: [u8; 32],
    pk_hash: [u8; 32],
    parties: Vec<u16>,
    self_party: u16,
    k: usize,
    dkg: Option<DkgEvidence>,
    ntru: Option<NtruEvidence>,
    _stage: PhantomData<S>,
}

impl<S> std::fmt::Debug for PartyState<S> {
    /// Debug pokazuje tylko dane publiczne i etap typestate.
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("PartyState")
            .field("stage", &std::any::type_name::<S>())
            .field("sid", &hex32(&self.sid))
            .field("pk_hash", &hex32(&self.pk_hash))
            .field("parties", &self.parties)
            .field("self_party", &self.self_party)
            .field("k", &self.k)
            .finish()
    }
}

impl PartyState<Unvalidated> {
    /// Tworzy stan setupu. `parties` muszą być niezerowe, różne, `< q`,
    /// w liczbie `k..=MAX_PARTIES_V1`; `self_party` musi być w `parties`.
    pub fn new(
        sid: [u8; 32],
        pk_hash: [u8; 32],
        parties: Vec<u16>,
        self_party: u16,
        k: usize,
    ) -> Result<Self> {
        if !(2..=MAX_PARTIES_V1).contains(&k) {
            return Err(CoreError::ThresholdTooLow);
        }
        if parties.len() < k {
            return Err(CoreError::PartyCountMismatch);
        }
        if parties.len() > MAX_PARTIES_V1 {
            return Err(CoreError::PartyCountMismatch);
        }
        let mut seen = BTreeSet::new();
        for &p in &parties {
            if p == 0 {
                return Err(CoreError::XZero);
            }
            if p >= ft_threshold_core::ring::Q {
                return Err(CoreError::OutOfRange);
            }
            if !seen.insert(p) {
                return Err(CoreError::DuplicateX);
            }
        }
        if !seen.contains(&self_party) {
            return Err(CoreError::PartyCountMismatch);
        }
        Ok(Self {
            sid,
            pk_hash,
            parties,
            self_party,
            k,
            dkg: None,
            ntru: None,
            _stage: PhantomData,
        })
    }

    /// Weryfikuje wkłady VSS wszystkich dealerów dla 32 instancji seeda
    /// i wiąże je z korzeniem transkryptu.
    ///
    /// Wymagane: dokładnie `n·32` wkładów (każdy dealer × każda instancja),
    /// `share.x == self_party`, `commitments.len() == k`, każdy udział
    /// poprawny względem zobowiązań. `dkg_root` musi być równy
    /// `expected_root` (wartość z transkryptu).
    pub fn validate_dkg(
        self,
        contributions: &[DealerContribution],
        expected_root: &[u8; 32],
    ) -> Result<PartyState<DkgOk>> {
        let n = self.parties.len();
        if contributions.len() != n * SEED_INSTANCES {
            return Err(CoreError::PartyCountMismatch);
        }

        let mut by_instance: Vec<BTreeMap<u16, &DealerContribution>> =
            vec![BTreeMap::new(); SEED_INSTANCES];
        for c in contributions {
            if c.instance as usize >= SEED_INSTANCES {
                return Err(CoreError::OutOfRange);
            }
            if !self.parties.contains(&c.dealer) {
                return Err(CoreError::PartyCountMismatch);
            }
            if c.commitments.len() != self.k {
                return Err(CoreError::ThresholdTooLow);
            }
            if c.share.x() != self.self_party {
                return Err(CoreError::InconsistentShare);
            }
            if by_instance[c.instance as usize]
                .insert(c.dealer, c)
                .is_some()
            {
                return Err(CoreError::DuplicateX);
            }
        }
        for instance in &by_instance {
            if instance.len() != n {
                return Err(CoreError::PartyCountMismatch);
            }
        }

        for instance in &by_instance {
            for c in instance.values() {
                vss::verify_share(&c.share, &c.commitments)?;
            }
        }

        let root = dkg_root(
            &self.sid,
            &self.pk_hash,
            self.k,
            &self.parties,
            contributions,
        )?;
        if !ct_eq32(&root, expected_root) {
            return Err(CoreError::TranscriptMismatch);
        }

        let evidence = DkgEvidence {
            root,
            pk_hash: self.pk_hash,
        };
        Ok(PartyState {
            sid: self.sid,
            pk_hash: self.pk_hash,
            parties: self.parties,
            self_party: self.self_party,
            k: self.k,
            dkg: Some(evidence),
            ntru: None,
            _stage: PhantomData,
        })
    }
}

impl PartyState<DkgOk> {
    /// Evidence DKG (korzeń transkryptu i `pk_hash`).
    pub fn dkg(&self) -> &DkgEvidence {
        // Bezpieczne: `PartyState<DkgOk>` powstaje wyłącznie z `validate_dkg`.
        self.dkg.as_ref().expect("DkgOk implies evidence")
    }

    /// Weryfikuje relację NTRU `f·h = g` w `R_q` i przechodzi w stan gotowy.
    ///
    /// To jest ścieżka `TEST-ORACLE`: `f,g,h` są jawne. Dla `PROD` potrzebne
    /// jest sprawdzenie na udziałach (O-05); samo utworzenie stanu nie
    /// autoryzuje `PROD` — robi to dopiero [`SignSession::begin`].
    pub fn validate_ntru(self, f: &Poly, g: &Poly, h: &Poly) -> Result<PartyState<Ready>> {
        let ntru = NtruEvidence::verify_plaintext(f, g, h)?;
        Ok(PartyState {
            sid: self.sid,
            pk_hash: self.pk_hash,
            parties: self.parties,
            self_party: self.self_party,
            k: self.k,
            dkg: self.dkg,
            ntru: Some(ntru),
            _stage: PhantomData,
        })
    }
}

impl PartyState<Ready> {
    /// Evidence NTRU (źródło: jawne `f,g,h`).
    pub fn ntru(&self) -> &NtruEvidence {
        self.ntru.as_ref().expect("Ready implies evidence")
    }
}

/// Wkład jednego dealera dla jednej instancji seeda (dane publiczne +
/// poufny udział odbiorcy).
pub struct DealerContribution {
    dealer: u16,
    instance: u8,
    commitments: VssCommitments,
    share: ExpShare,
}

impl DealerContribution {
    /// Tworzy wkład; `instance` musi być `< 32`.
    pub fn new(
        dealer: u16,
        instance: u8,
        commitments: VssCommitments,
        share: ExpShare,
    ) -> Result<Self> {
        if instance as usize >= SEED_INSTANCES {
            return Err(CoreError::OutOfRange);
        }
        Ok(Self {
            dealer,
            instance,
            commitments,
            share,
        })
    }

    /// Identyfikator dealera.
    pub fn dealer(&self) -> u16 {
        self.dealer
    }

    /// Indeks bajtu seeda.
    pub fn instance(&self) -> u8 {
        self.instance
    }

    /// Zobowiązania VSS dealera.
    pub fn commitments(&self) -> &VssCommitments {
        &self.commitments
    }

    /// Udział odbiorcy.
    pub fn share(&self) -> &ExpShare {
        &self.share
    }
}

/// Evidence zweryfikowanego DKG (Faza A).
#[derive(Clone, Copy)]
pub struct DkgEvidence {
    root: [u8; 32],
    pk_hash: [u8; 32],
}

impl DkgEvidence {
    /// Korzeń transkryptu DKG.
    pub fn root(&self) -> [u8; 32] {
        self.root
    }

    /// `pk_hash` związany z transkryptem.
    pub fn pk_hash(&self) -> [u8; 32] {
        self.pk_hash
    }
}

impl std::fmt::Debug for DkgEvidence {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("DkgEvidence")
            .field("root", &hex32(&self.root))
            .field("pk_hash", &hex32(&self.pk_hash))
            .finish()
    }
}

/// Źródło evidence NTRU.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum EvidenceSource {
    /// Jawne `f,g,h` — wyłącznie `TEST-ORACLE` (G2).
    PlaintextTestkit,
    /// Sprawdzenie na udziałach bez rekonstrukcji (O-05, jeszcze niezaimplementowane).
    Mpc,
}

/// Evidence sprawdzonej relacji NTRU.
#[derive(Clone, Copy)]
pub struct NtruEvidence {
    source: EvidenceSource,
}

impl NtruEvidence {
    /// Weryfikuje `f·h = g` w `R_q` na jawnym kluczu (`TEST-ORACLE`).
    ///
    /// Odrzuca `f = 0` i `h = 0` (klucz zdegenerowany).
    pub fn verify_plaintext(f: &Poly, g: &Poly, h: &Poly) -> Result<Self> {
        if f.is_zero() || h.is_zero() {
            return Err(CoreError::InvalidInput);
        }
        if !f.mul(h).ct_eq(g) {
            return Err(CoreError::NtruMismatch);
        }
        Ok(Self {
            source: EvidenceSource::PlaintextTestkit,
        })
    }

    /// Źródło sprawdzenia.
    pub fn source(&self) -> EvidenceSource {
        self.source
    }
}

impl std::fmt::Debug for NtruEvidence {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("NtruEvidence")
            .field("source", &self.source)
            .finish()
    }
}

/// Sesja podpisu; powstaje wyłącznie ze stanu [`Ready`].
///
/// ```compile_fail
/// use ft_threshold_core::Profile;
/// use ft_threshold_protocol::state::{SignSession, Unvalidated, PartyState};
/// // Brak walidacji DKG/NTRU: nie ma metody begin na Unvalidated.
/// let st: PartyState<Unvalidated> = PartyState::new([0u8; 32], [0u8; 32], vec![1, 2, 3], 1, 2).unwrap();
/// let _ = SignSession::begin(st, Profile::TestOracle);
/// ```
///
/// ```compile_fail
/// use ft_threshold_protocol::state::PartyState;
/// // PartyState<Ready> nie ma publicznego konstruktora.
/// let _st = PartyState::<ft_threshold_protocol::state::Ready> {
///     sid: [0u8; 32], pk_hash: [0u8; 32], parties: vec![1, 2, 3],
///     self_party: 1, k: 2, dkg: None, ntru: None,
///     _stage: std::marker::PhantomData,
/// };
/// ```
pub struct SignSession {
    sid: [u8; 32],
    pk_hash: [u8; 32],
}

impl SignSession {
    /// Otwiera sesję podpisu ze stanu `Ready`.
    ///
    /// Profil `Prod` wymaga evidence NTRU ze źródła [`EvidenceSource::Mpc`];
    /// evidence z jawnych `f,g,h` dostaje [`CoreError::ProdEvidenceMissing`].
    pub fn begin(state: PartyState<Ready>, profile: Profile) -> Result<Self> {
        let ntru = state.ntru();
        if profile == Profile::Prod && ntru.source() != EvidenceSource::Mpc {
            return Err(CoreError::ProdEvidenceMissing);
        }
        Ok(Self {
            sid: state.sid,
            pk_hash: state.pk_hash,
        })
    }

    /// `sid` sesji.
    pub fn sid(&self) -> [u8; 32] {
        self.sid
    }

    /// `pk_hash` sesji.
    pub fn pk_hash(&self) -> [u8; 32] {
        self.pk_hash
    }
}

impl std::fmt::Debug for SignSession {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("SignSession")
            .field("sid", &hex32(&self.sid))
            .field("pk_hash", &hex32(&self.pk_hash))
            .finish()
    }
}

/// Kanoniczny korzeń transkryptu DKG: `SHA3-512(tag || sid || pk_hash ||
/// k || n || agregaty zobowiązań instancji 0..32)`.
///
/// Agregaty są liczone w rosnącej kolejności dealerów; każda instancja
/// wnosi `k·32 B` zobowiązań.
pub fn dkg_root(
    sid: &[u8; 32],
    pk_hash: &[u8; 32],
    k: usize,
    parties: &[u16],
    contributions: &[DealerContribution],
) -> Result<[u8; 32]> {
    if !(2..=MAX_PARTIES_V1).contains(&k) {
        return Err(CoreError::ThresholdTooLow);
    }
    if parties.len() < k || parties.is_empty() || parties.len() > MAX_PARTIES_V1 {
        return Err(CoreError::PartyCountMismatch);
    }
    if contributions.len() != parties.len() * SEED_INSTANCES {
        return Err(CoreError::PartyCountMismatch);
    }

    let mut by_instance: Vec<BTreeMap<u16, &DealerContribution>> =
        vec![BTreeMap::new(); SEED_INSTANCES];
    for c in contributions {
        if c.instance as usize >= SEED_INSTANCES || !parties.contains(&c.dealer) {
            return Err(CoreError::PartyCountMismatch);
        }
        if c.commitments.len() != k {
            return Err(CoreError::ThresholdTooLow);
        }
        if by_instance[c.instance as usize]
            .insert(c.dealer, c)
            .is_some()
        {
            return Err(CoreError::DuplicateX);
        }
    }

    let mut h = Sha3_512::new();
    h.update(DKG_ROOT_DOMAIN);
    h.update(sid);
    h.update(pk_hash);
    h.update([k as u8, parties.len() as u8]);
    for instance in &by_instance {
        if instance.len() != parties.len() {
            return Err(CoreError::PartyCountMismatch);
        }
        let mut agg: Option<VssCommitments> = None;
        for c in instance.values() {
            agg = Some(match agg {
                None => c.commitments.clone(),
                Some(a) => a.add(&c.commitments)?,
            });
        }
        let agg = agg.ok_or(CoreError::PartyCountMismatch)?;
        h.update(agg.to_bytes());
    }
    let digest = h.finalize();
    let mut root = [0u8; 32];
    root.copy_from_slice(&digest[..32]);
    Ok(root)
}

fn ct_eq32(a: &[u8; 32], b: &[u8; 32]) -> bool {
    let mut diff = 0u8;
    for (x, y) in a.iter().zip(b.iter()) {
        diff |= x ^ y;
    }
    diff == 0
}

fn hex32(bytes: &[u8; 32]) -> String {
    bytes.iter().map(|b| format!("{b:02x}")).collect()
}

#[cfg(test)]
mod tests {
    use super::{
        DealerContribution, EvidenceSource, PartyState, SEED_INSTANCES, SignSession, dkg_root,
    };
    use ft_threshold_core::Profile;
    use ft_threshold_core::error::CoreError;
    use ft_threshold_core::ring::Poly;
    use ft_threshold_core::vss;
    use sha3::{Digest, Sha3_512};

    const SID: [u8; 32] = [0x11; 32];
    const PK_HASH: [u8; 32] = [0x22; 32];
    const PARTIES: [u16; 3] = [1, 2, 3];
    const K: usize = 2;

    fn blind(dealer: u16, instance: u8) -> [u8; 32] {
        let mut h = Sha3_512::new();
        h.update(b"FT1536-P2/w014-blind");
        h.update(dealer.to_be_bytes());
        h.update([instance, 0]);
        let d = h.finalize();
        let mut out = [0u8; 32];
        out.copy_from_slice(&d[..32]);
        // < 2^251 < L (kanoniczny Scalar); bez arytmetyki modulo L.
        out[31] &= 0x07;
        out
    }

    fn dup_contrib(c: &DealerContribution) -> DealerContribution {
        DealerContribution::new(
            c.dealer(),
            c.instance(),
            c.commitments().clone(),
            vss::ExpShare::from_bytes(&c.share().to_bytes()).expect("share bytes"),
        )
        .expect("dup")
    }

    fn contributions() -> Vec<DealerContribution> {
        let mut out = Vec::with_capacity(PARTIES.len() * SEED_INSTANCES);
        for &dealer in &PARTIES {
            for instance in 0..SEED_INSTANCES as u8 {
                let secret = u16::from(instance) + dealer;
                let (comms, shares) = vss::deal(
                    &[secret, 7 + dealer + u16::from(instance)],
                    &[blind(dealer, instance), blind(dealer, instance)],
                    &PARTIES,
                )
                .expect("deal");
                let mine = shares
                    .into_iter()
                    .find(|s| s.x() == PARTIES[0])
                    .expect("my share");
                out.push(
                    DealerContribution::new(dealer, instance, comms, mine).expect("contribution"),
                );
            }
        }
        out
    }

    fn validated() -> PartyState<super::DkgOk> {
        let cs = contributions();
        let root = dkg_root(&SID, &PK_HASH, K, &PARTIES, &cs).expect("root");
        PartyState::new(SID, PK_HASH, PARTIES.to_vec(), PARTIES[0], K)
            .expect("state")
            .validate_dkg(&cs, &root)
            .expect("dkg")
    }

    fn toy_key() -> (Poly, Poly, Poly) {
        let mut f = vec![0u16; 1536];
        f[0] = 3;
        f[1] = 5;
        let mut h = vec![0u16; 1536];
        h[0] = 7;
        h[2] = 11;
        let f = Poly::from_coeffs(&f).expect("f");
        let h = Poly::from_coeffs(&h).expect("h");
        let g = f.mul(&h);
        (f, g, h)
    }

    #[test]
    #[cfg_attr(
        miri,
        ignore = "Ristretto/Poly O(N^2) w Miri są zbyt wolne; ścieżki crypto pokrywa core"
    )]
    fn full_chain_reaches_sign_session() {
        let (f, g, h) = toy_key();
        let ready = validated().validate_ntru(&f, &g, &h).expect("ntru");
        assert_eq!(ready.ntru().source(), EvidenceSource::PlaintextTestkit);
        let session = SignSession::begin(ready, Profile::TestOracle).expect("session");
        assert_eq!(session.sid(), SID);
        assert_eq!(session.pk_hash(), PK_HASH);
    }

    #[test]
    #[cfg_attr(
        miri,
        ignore = "Ristretto/Poly O(N^2) w Miri są zbyt wolne; ścieżki crypto pokrywa core"
    )]
    fn prod_rejects_plaintext_ntru_evidence() {
        let (f, g, h) = toy_key();
        let ready = validated().validate_ntru(&f, &g, &h).expect("ntru");
        assert_eq!(
            SignSession::begin(ready, Profile::Prod).unwrap_err(),
            CoreError::ProdEvidenceMissing
        );
    }

    #[test]
    #[cfg_attr(
        miri,
        ignore = "Ristretto/Poly O(N^2) w Miri są zbyt wolne; ścieżki crypto pokrywa core"
    )]
    fn dkg_root_mismatch_is_rejected() {
        let cs = contributions();
        let mut root = dkg_root(&SID, &PK_HASH, K, &PARTIES, &cs).expect("root");
        root[0] ^= 1;
        assert_eq!(
            PartyState::new(SID, PK_HASH, PARTIES.to_vec(), PARTIES[0], K)
                .expect("state")
                .validate_dkg(&cs, &root)
                .unwrap_err(),
            CoreError::TranscriptMismatch
        );
    }

    #[test]
    #[cfg_attr(
        miri,
        ignore = "Ristretto/Poly O(N^2) w Miri są zbyt wolne; ścieżki crypto pokrywa core"
    )]
    fn missing_or_duplicate_contribution_is_rejected() {
        let cs = contributions();
        let root = dkg_root(&SID, &PK_HASH, K, &PARTIES, &cs).expect("root");

        let short = &cs[..cs.len() - 1];
        assert_eq!(
            PartyState::new(SID, PK_HASH, PARTIES.to_vec(), PARTIES[0], K)
                .expect("state")
                .validate_dkg(short, &root)
                .unwrap_err(),
            CoreError::PartyCountMismatch
        );

        let mut dup = contributions();
        dup[1] = dup_contrib(&dup[0]);
        assert_eq!(
            PartyState::new(SID, PK_HASH, PARTIES.to_vec(), PARTIES[0], K)
                .expect("state")
                .validate_dkg(&dup, &root)
                .unwrap_err(),
            CoreError::DuplicateX
        );
    }

    #[test]
    #[cfg_attr(
        miri,
        ignore = "Ristretto/Poly O(N^2) w Miri są zbyt wolne; ścieżki crypto pokrywa core"
    )]
    fn tampered_share_or_commitment_is_rejected() {
        let cs = contributions();
        let root = dkg_root(&SID, &PK_HASH, K, &PARTIES, &cs).expect("root");

        let mut bytes = cs[5].share().to_bytes();
        bytes[2] ^= 0xFF;
        let forged = vss::ExpShare::from_bytes(&bytes).expect("parse");
        let bad = DealerContribution::new(
            cs[5].dealer(),
            cs[5].instance(),
            cs[5].commitments().clone(),
            forged,
        )
        .expect("bad");
        let mut with_bad = contributions();
        with_bad[5] = bad;
        assert_eq!(
            PartyState::new(SID, PK_HASH, PARTIES.to_vec(), PARTIES[0], K)
                .expect("state")
                .validate_dkg(&with_bad, &root)
                .unwrap_err(),
            CoreError::InconsistentShare
        );

        // Inny korzeń po podmianie zobowiązań: root z oryginału nie pasuje.
        let mut cs2 = contributions();
        let (comms, _) = vss::deal(&[1, 2], &[[1u8; 32]; 2], &PARTIES).expect("deal");
        let share = vss::ExpShare::from_bytes(&cs2[0].share().to_bytes()).expect("share");
        let swapped = DealerContribution::new(cs2[0].dealer(), cs2[0].instance(), comms, share)
            .expect("swapped");
        cs2[0] = swapped;
        assert_eq!(
            PartyState::new(SID, PK_HASH, PARTIES.to_vec(), PARTIES[0], K)
                .expect("state")
                .validate_dkg(&cs2, &root)
                .unwrap_err(),
            CoreError::InconsistentShare
        );
    }

    #[test]
    #[cfg_attr(
        miri,
        ignore = "Ristretto/Poly O(N^2) w Miri są zbyt wolne; ścieżki crypto pokrywa core"
    )]
    fn share_for_wrong_party_is_rejected() {
        let mut cs = contributions();
        let root = dkg_root(&SID, &PK_HASH, K, &PARTIES, &cs).expect("root");
        let (comms, shares) = vss::deal(&[9, 4], &[[2u8; 32]; 2], &PARTIES).expect("deal");
        let not_mine = shares
            .into_iter()
            .find(|s| s.x() == PARTIES[1])
            .expect("other");
        cs[0] = DealerContribution::new(cs[0].dealer(), cs[0].instance(), comms, not_mine)
            .expect("bad x");
        assert_eq!(
            PartyState::new(SID, PK_HASH, PARTIES.to_vec(), PARTIES[0], K)
                .expect("state")
                .validate_dkg(&cs, &root)
                .unwrap_err(),
            CoreError::InconsistentShare
        );
    }

    #[test]
    #[cfg_attr(
        miri,
        ignore = "Ristretto/Poly O(N^2) w Miri są zbyt wolne; ścieżki crypto pokrywa core"
    )]
    fn ntru_relation_is_checked() {
        let (f, g, h) = toy_key();
        let state = validated();
        let mut one = vec![0u16; 1536];
        one[0] = 1;
        let bad_g = g.add(&Poly::from_coeffs(&one).expect("one"));
        assert_eq!(
            state.validate_ntru(&f, &bad_g, &h).unwrap_err(),
            CoreError::NtruMismatch
        );
    }

    #[test]
    #[cfg_attr(
        miri,
        ignore = "Ristretto/Poly O(N^2) w Miri są zbyt wolne; ścieżki crypto pokrywa core"
    )]
    fn zero_key_is_rejected() {
        let (_, g, h) = toy_key();
        let zero = Poly::zero();
        let state = validated();
        assert_eq!(
            state.validate_ntru(&zero, &g, &h).unwrap_err(),
            CoreError::InvalidInput
        );
    }

    #[test]
    fn state_constructor_validates_parties() {
        assert_eq!(
            PartyState::new(SID, PK_HASH, vec![1], 1, 2).unwrap_err(),
            CoreError::PartyCountMismatch
        );
        assert_eq!(
            PartyState::new(SID, PK_HASH, vec![1, 2], 1, 1).unwrap_err(),
            CoreError::ThresholdTooLow
        );
        assert_eq!(
            PartyState::new(SID, PK_HASH, vec![0, 2], 0, 2).unwrap_err(),
            CoreError::XZero
        );
        assert_eq!(
            PartyState::new(SID, PK_HASH, vec![1, 1], 1, 2).unwrap_err(),
            CoreError::DuplicateX
        );
        assert_eq!(
            PartyState::new(SID, PK_HASH, vec![1, 2], 3, 2).unwrap_err(),
            CoreError::PartyCountMismatch
        );
    }

    #[test]
    #[cfg_attr(
        miri,
        ignore = "Ristretto/Poly O(N^2) w Miri są zbyt wolne; ścieżki crypto pokrywa core"
    )]
    fn dkg_root_is_deterministic_and_sensitive() {
        let cs = contributions();
        let a = dkg_root(&SID, &PK_HASH, K, &PARTIES, &cs).expect("a");
        let b = dkg_root(&SID, &PK_HASH, K, &PARTIES, &cs).expect("b");
        assert_eq!(a, b);
        let mut other_sid = SID;
        other_sid[0] ^= 1;
        assert_ne!(
            dkg_root(&other_sid, &PK_HASH, K, &PARTIES, &cs).expect("c"),
            a
        );
        let mut other_pk = PK_HASH;
        other_pk[0] ^= 1;
        assert_ne!(dkg_root(&SID, &other_pk, K, &PARTIES, &cs).expect("pk"), a);
    }
}
