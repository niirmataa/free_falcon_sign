//! WP-031 (Bramka G2) — protokół podpisu 2-z-3 na profilu `TEST-ORACLE`
//! (tylko plumbing): `NONCE_COMMIT` (`0x12`) → `NONCE_REVEAL` (`0x13`) →
//! udziały podpisu w pierścieniu $R_q$ → złożenie podpisu → weryfikacja
//! weryfikatorem (silnik C) **bez rekonstrukcji klucza prywatnego**.
//!
//! Ścieżka zgodna z SPEC §7 (N1–N3, C1–C3) i §12.2. Strony $P_a, P_b$
//! (kworum `k = 2` z rosteru 3 stron) wymieniają uwierzytelnione koperty
//! [`Envelope`], liczą lokalnie udziały $s1_i = z0·g_i + z1·G_i$,
//! $s2_i = z0·f_i + z1·F_i$ (liniowość Shamira w $R_q$ — jawne $z$),
//! otwierają je w `SIGN_OPEN` (`0x15`) i składają interpolacją
//! Lagrange'a w punkcie 0. Klucz prywatny $(f, g, F, G)$ **nie istnieje**
//! w tej ścieżce: maszyna przyjmuje wyłącznie udział pułapki
//! ([`TrapdoorShare`]) i jawne $h$ (klucz publiczny).
//!
//! # Decyzje plumbingowe WP-031 (jawne, do przeglądu w WP-033/WP-041)
//!
//! 1. **Udział $s1$ w `SIGN_OPEN`.** SPEC §7.5 C2 mówi „otwarcie tylko
//!    `s2`", ale check #3 tej samej sekcji dopuszcza weryfikację
//!    $s1 = s2·h − t$ **„na udziałach"**. Tu otwierane są udziały obu
//!    $s1_i, s2_i$ (nie wartości złożone), żeby check „na udziałach"
//!    (`s2·h == Σ λ_i s1_i`) był realnym, fail-closed wykrywaniem
//!    przekłamanych udziałów przed wydaniem podpisu. Udział $s1_i$ nie
//!    ujawnia pułapki mocniej niż $s2_i$ (oba są jawnymi kombinacjami
//!    liniowymi udziału przy publicznym $z$; ochrona przed wzajemnym
//!    łączeniem sesji to WP-042). Format `SIGN_OPEN` jest i tak DRAFT
//!    do WP-041 — tam decyzja wraca do przeglądu.
//! 2. **Dokładnie `k` uczestników.** Wzór N3 (§7.2) wiąże `n_1 ‖ … ‖ n_k`;
//!    w WP-031 sesja ma dokładnie `k = 2` uczestników (każda para rosteru).
//!    Udział `> k` stron = WP-034.
//! 3. **Layouty bajtowe hashów** (epoch jako `u64` BE itd.) są tu
//!    deterministyczne, ale freeze wiążący idzie w WP-033 (transkrypt).
//! 4. **Brak MAC ukrytego δ na otwarciach** (WP-013/WP-041). Wykrywanie
//!    przekłamanych udziałów opiera się na checku „na udziałach", bramce
//!    normy i bramce weryfikatora (I-10). To NIE jest równoważne
//!    zabezpieczeniu MPC z §7.5 #1.
//! 5. **Norma: $L2^2$ zamiast formy kwadratowej silnika** (O-06/WP-041).
//!    Check wewnętrzny jest bezpiecznie-stronniczy (akceptuje podzbiór
//!    sygnatur silnika); bramka ostateczna = weryfikator silnika.
//! 6. **`TH_final`, `SignReceipt`, replay, epoki, idempotencja
//!    `request_id`** = WP-033. Tu `Signature` ma `nonce`, `bytes`,
//!    `pk_hash` (§7.8 bez transkryptu).
//! 7. **Sampler $z$ przychodzi z zewnątrz.** Oracle-sampler
//!    (`z1 = round(t·f/q)`, `z0 = round(−t·F/q)`) żyje w `ft-threshold-testkit`
//!    i MAY widzieć jawny klucz testowy (§5.1); `protocol`/`core`
//!    **nie mają** API reconstruct (WP-025/WP-035).
//!
//! **To nie jest `PROD`.** Twierdzenia wyłącznie: „plumbing przepływu
//! działa na wektorach testowych" (§5.1). `SignMachine::begin` odrzuca
//! profil `Prod` (WP-041 wnosi realny sampler).

#![forbid(unsafe_code)]

use ft_threshold_core::Profile;
use ft_threshold_core::codec;
use ft_threshold_core::error::{CoreError, Result};
use ft_threshold_core::ring::{N, Poly, Q, inv_mod, mul_mod, sub_mod};
use ft_threshold_core::shake;
use zeroize::{Zeroize, ZeroizeOnDrop, Zeroizing};

use crate::cbor::{CborReader, CborWriter};
use crate::envelope::{Body, Delivery, Envelope, EnvelopeKey, PartyId, SessionReceiver};
use crate::state::SignSession;

/// Próg `k = 2` dla konfiguracji 2-z-3 (D-003).
pub const K_2OF3: usize = 2;
/// Liczba stron `n = 3` dla konfiguracji 2-z-3 (D-003).
pub const PARTIES_2OF3: usize = 3;

/// Typ komunikatu `NONCE_COMMIT` (runda N1, `payloads_v0.cddl`).
pub const MSG_NONCE_COMMIT: u16 = 0x12;
/// Typ komunikatu `NONCE_REVEAL` (runda N2, `payloads_v0.cddl`).
pub const MSG_NONCE_REVEAL: u16 = 0x13;
/// Typ komunikatu `SIGN_OPEN` (runda C2, `payloads_v0.cddl` — DRAFT).
pub const MSG_SIGN_OPEN: u16 = 0x15;

/// Długość udziału nonce (`n_i`, §7.2).
pub const NONCE_BYTES: usize = 40;
/// Długości soli zobowiązania (`salt_i`, §7.2).
pub const SALT_BYTES: usize = 32;
/// Maksymalny rozmiar `msg` (§7.1: ≤ 1 MiB).
pub const MAX_MSG_BYTES: usize = 1 << 20;

/// `FALCON_FT1536_NORM_BOUND2` — granica normy formy silnika (§2).
/// Użyta tu jako check $L2^2 < B$ (decyzja plumbingowa #5).
pub const B_NORM_BOUND2: u64 = 2_093_922_385;

/// Runda koperty `NONCE_COMMIT` w maszynie (§12.2 → N1).
pub const ROUND_NONCE_COMMIT: u64 = 1;
/// Runda koperty `NONCE_REVEAL` (N2).
pub const ROUND_NONCE_REVEAL: u64 = 2;
/// Runda koperty `SIGN_OPEN` (C2).
pub const ROUND_SIGN_OPEN: u64 = 3;

/// Tag domenowy zobowiązania nonce (§10.3).
const TAG_NONCE_COMMIT: &[u8] = b"FT1536/threshold/v1/nonce-commit";
/// Tag domenowy agregacji nonce (§10.3).
const TAG_NONCE: &[u8] = b"FT1536/threshold/v1/nonce";
/// Tag domenowy punktu `t` (§10.3).
const TAG_T: &[u8] = b"FT1536/threshold/v1/t";

fn shake32(parts: &[&[u8]]) -> [u8; 32] {
    let mut joined = Vec::new();
    for p in parts {
        joined.extend_from_slice(p);
    }
    let mut out = [0u8; 32];
    shake::shake256(&joined, &mut out);
    out
}

fn shake40(parts: &[&[u8]]) -> [u8; 40] {
    let mut joined = Vec::new();
    for p in parts {
        joined.extend_from_slice(p);
    }
    let mut out = [0u8; 40];
    shake::shake256(&joined, &mut out);
    out
}

fn is_zero(bytes: &[u8]) -> bool {
    bytes.iter().all(|&b| b == 0)
}

fn ct_eq32(a: &[u8; 32], b: &[u8; 32]) -> bool {
    let mut diff = 0u8;
    for (x, y) in a.iter().zip(b.iter()) {
        diff |= x ^ y;
    }
    diff == 0
}

/// Payload `0x12 NONCE_COMMIT` (runda N1, publiczny, §9.4).
///
/// Kanoniczna mapa CBOR o kluczu `1`: `{1: commitment (32 B)}`.
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct NonceCommitPayload {
    commitment: [u8; 32],
}

impl NonceCommitPayload {
    /// Tworzy payload zobowiązania `c_i` (32 B, niezerowe).
    pub fn new(commitment: [u8; 32]) -> Result<Self> {
        if is_zero(&commitment) {
            return Err(CoreError::InvalidInput);
        }
        Ok(Self { commitment })
    }

    /// Zobowiązanie `c_i`.
    pub fn commitment(&self) -> &[u8; 32] {
        &self.commitment
    }

    /// Koduje payload do kanonicznego CBOR.
    pub fn to_cbor(&self) -> Vec<u8> {
        let mut w = CborWriter::new();
        w.put_map(1);
        w.put_uint(1);
        w.put_bstr(&self.commitment);
        w.into_bytes()
    }

    /// Dekoduje payload z kanonicznego CBOR.
    pub fn from_cbor(bytes: &[u8]) -> Result<Self> {
        let mut r = CborReader::new(bytes);
        if r.expect_map()? != 1 {
            return Err(CoreError::NonCanonicalCbor);
        }
        if r.expect_uint()? != 1 {
            return Err(CoreError::NonCanonicalCbor);
        }
        let b = r.expect_bstr(32)?;
        if b.len() != 32 {
            return Err(CoreError::NonCanonicalCbor);
        }
        r.expect_end()?;
        let mut commitment = [0u8; 32];
        commitment.copy_from_slice(b);
        Self::new(commitment).map_err(|_| CoreError::NonCanonicalCbor)
    }
}

impl TryFrom<&[u8]> for NonceCommitPayload {
    type Error = CoreError;

    fn try_from(value: &[u8]) -> Result<Self> {
        Self::from_cbor(value)
    }
}

/// Payload `0x13 NONCE_REVEAL` (runda N2, publiczny, §9.4).
///
/// Kanoniczna mapa CBOR o kluczach `1..=2`:
/// `{1: nonce_share (40 B), 2: salt (32 B)}`.
#[derive(Clone, Eq, PartialEq)]
pub struct NonceRevealPayload {
    nonce_share: [u8; NONCE_BYTES],
    salt: [u8; SALT_BYTES],
}

impl std::fmt::Debug for NonceRevealPayload {
    /// `Debug` nie pokazuje `nonce_share` (sekret do chwili ujawnienia).
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("NonceRevealPayload")
            .field("salt", &self.salt)
            .finish_non_exhaustive()
    }
}

impl NonceRevealPayload {
    /// Tworzy payload otwarcia; `nonce_share` i `salt` muszą być niezerowe.
    pub fn new(nonce_share: [u8; NONCE_BYTES], salt: [u8; SALT_BYTES]) -> Result<Self> {
        if is_zero(&nonce_share) || is_zero(&salt) {
            return Err(CoreError::InvalidInput);
        }
        Ok(Self { nonce_share, salt })
    }

    /// Udział nonce `n_i` (40 B).
    pub fn nonce_share(&self) -> &[u8; NONCE_BYTES] {
        &self.nonce_share
    }

    /// Sól zobowiązania `salt_i` (32 B).
    pub fn salt(&self) -> &[u8; SALT_BYTES] {
        &self.salt
    }

    /// Koduje payload do kanonicznego CBOR.
    pub fn to_cbor(&self) -> Vec<u8> {
        let mut w = CborWriter::new();
        w.put_map(2);
        w.put_uint(1);
        w.put_bstr(&self.nonce_share);
        w.put_uint(2);
        w.put_bstr(&self.salt);
        w.into_bytes()
    }

    /// Dekoduje payload z kanonicznego CBOR.
    pub fn from_cbor(bytes: &[u8]) -> Result<Self> {
        let mut r = CborReader::new(bytes);
        if r.expect_map()? != 2 {
            return Err(CoreError::NonCanonicalCbor);
        }
        if r.expect_uint()? != 1 {
            return Err(CoreError::NonCanonicalCbor);
        }
        let nb = r.expect_bstr(NONCE_BYTES)?;
        if nb.len() != NONCE_BYTES {
            return Err(CoreError::NonCanonicalCbor);
        }
        if r.expect_uint()? != 2 {
            return Err(CoreError::NonCanonicalCbor);
        }
        let sb = r.expect_bstr(SALT_BYTES)?;
        if sb.len() != SALT_BYTES {
            return Err(CoreError::NonCanonicalCbor);
        }
        r.expect_end()?;
        let mut nonce_share = [0u8; NONCE_BYTES];
        nonce_share.copy_from_slice(nb);
        let mut salt = [0u8; SALT_BYTES];
        salt.copy_from_slice(sb);
        Self::new(nonce_share, salt).map_err(|_| CoreError::NonCanonicalCbor)
    }
}

impl TryFrom<&[u8]> for NonceRevealPayload {
    type Error = CoreError;

    fn try_from(value: &[u8]) -> Result<Self> {
        Self::from_cbor(value)
    }
}

/// Payload `0x15 SIGN_OPEN` (runda C2; `SIGN_OPEN` jest DRAFT do WP-041).
///
/// Kanoniczna mapa CBOR o kluczach `1..=3`:
/// `{1: s1_share (2N B), 2: s2_share (2N B), 3: t_hash (32 B)}`.
///
/// `s1_share` jest udziałem (nie wartością złożoną) — patrz decyzja
/// plumbingowa #1 w module; `t_hash` realizuje check `HTP_MISMATCH` (§7.3).
pub struct SignOpenPayload {
    s1_bytes: Vec<u8>,
    s2_bytes: Vec<u8>,
    t_hash: [u8; 32],
}

impl std::fmt::Debug for SignOpenPayload {
    /// `Debug` nie pokazuje udziałów `s1`/`s2`.
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("SignOpenPayload")
            .field("t_hash", &self.t_hash)
            .finish_non_exhaustive()
    }
}

impl SignOpenPayload {
    /// Tworzy payload otwarcia udziałów `(s1_i, s2_i)` i `t_hash`.
    pub fn new(s1_share: &Poly, s2_share: &Poly, t_hash: &[u8; 32]) -> Self {
        Self {
            s1_bytes: s1_share.to_le_bytes().to_vec(),
            s2_bytes: s2_share.to_le_bytes().to_vec(),
            t_hash: *t_hash,
        }
    }

    /// Udział `s1_i` (deserializowany, `2N` B little-endian).
    pub fn s1_share(&self) -> Result<Poly> {
        Poly::from_le_bytes(&self.s1_bytes)
    }

    /// Udział `s2_i` (deserializowany).
    pub fn s2_share(&self) -> Result<Poly> {
        Poly::from_le_bytes(&self.s2_bytes)
    }

    /// `t_hash` nadawcy (§7.3).
    pub fn t_hash(&self) -> &[u8; 32] {
        &self.t_hash
    }

    /// Koduje payload do kanonicznego CBOR.
    pub fn to_cbor(&self) -> Vec<u8> {
        let mut w = CborWriter::new();
        w.put_map(3);
        w.put_uint(1);
        w.put_bstr(&self.s1_bytes);
        w.put_uint(2);
        w.put_bstr(&self.s2_bytes);
        w.put_uint(3);
        w.put_bstr(&self.t_hash);
        w.into_bytes()
    }

    /// Dekoduje payload z kanonicznego CBOR.
    pub fn from_cbor(bytes: &[u8]) -> Result<Self> {
        let mut r = CborReader::new(bytes);
        if r.expect_map()? != 3 {
            return Err(CoreError::NonCanonicalCbor);
        }
        if r.expect_uint()? != 1 {
            return Err(CoreError::NonCanonicalCbor);
        }
        let s1_bytes = r.expect_bstr(2 * N)?.to_vec();
        if s1_bytes.len() != 2 * N {
            return Err(CoreError::NonCanonicalCbor);
        }
        if r.expect_uint()? != 2 {
            return Err(CoreError::NonCanonicalCbor);
        }
        let s2_bytes = r.expect_bstr(2 * N)?.to_vec();
        if s2_bytes.len() != 2 * N {
            return Err(CoreError::NonCanonicalCbor);
        }
        if r.expect_uint()? != 3 {
            return Err(CoreError::NonCanonicalCbor);
        }
        let tb = r.expect_bstr(32)?;
        if tb.len() != 32 {
            return Err(CoreError::NonCanonicalCbor);
        }
        r.expect_end()?;
        let mut t_hash = [0u8; 32];
        t_hash.copy_from_slice(tb);
        let payload = Self {
            s1_bytes,
            s2_bytes,
            t_hash,
        };
        // Udziały muszą się deserializować (walidacja kształtu).
        payload
            .s1_share()
            .map_err(|_| CoreError::NonCanonicalCbor)?;
        payload
            .s2_share()
            .map_err(|_| CoreError::NonCanonicalCbor)?;
        Ok(payload)
    }
}

impl TryFrom<&[u8]> for SignOpenPayload {
    type Error = CoreError;

    fn try_from(value: &[u8]) -> Result<Self> {
        Self::from_cbor(value)
    }
}

/// Wejście sesji podpisu (§7.1; `nonce_mode` i polityka szczegółowa — WP-033).
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct SignRequest {
    sid: [u8; 32],
    epoch: u64,
    msg: Vec<u8>,
    policy_hash: [u8; 32],
    request_id: [u8; 32],
    participants: [PartyId; K_2OF3],
}

impl SignRequest {
    /// Tworzy i waliduje żądanie podpisu.
    ///
    /// Wymagania (§7.1, podzbiór WP-031):
    /// - `msg` ≤ [`MAX_MSG_BYTES`], `sid`/`policy_hash`/`request_id` niezerowe,
    /// - `participants` niezerowe, różne i **ściśle posortowane rosnąco**
    ///   (kanoniczny porządek agregacji nonce, §7.2 N3).
    pub fn new(
        sid: [u8; 32],
        epoch: u64,
        msg: Vec<u8>,
        policy_hash: [u8; 32],
        request_id: [u8; 32],
        participants: [PartyId; K_2OF3],
    ) -> Result<Self> {
        if is_zero(&sid) || is_zero(&policy_hash) || is_zero(&request_id) {
            return Err(CoreError::InvalidInput);
        }
        if msg.len() > MAX_MSG_BYTES {
            return Err(CoreError::InvalidLength);
        }
        for i in 0..K_2OF3 {
            if is_zero(&participants[i]) {
                return Err(CoreError::InvalidInput);
            }
            if i > 0 && participants[i - 1] >= participants[i] {
                return Err(CoreError::DuplicateX);
            }
        }
        Ok(Self {
            sid,
            epoch,
            msg,
            policy_hash,
            request_id,
            participants,
        })
    }

    /// Identyfikator sesji `sid`.
    pub fn sid(&self) -> &[u8; 32] {
        &self.sid
    }

    /// Epoka klucza.
    pub fn epoch(&self) -> u64 {
        self.epoch
    }

    /// Komunikat do podpisania.
    pub fn msg(&self) -> &[u8] {
        &self.msg
    }

    /// Skrót polityki.
    pub fn policy_hash(&self) -> &[u8; 32] {
        &self.policy_hash
    }

    /// Identyfikator żądania (idempotencja retry — WP-033).
    pub fn request_id(&self) -> &[u8; 32] {
        &self.request_id
    }

    /// Uczestnicy kworum (`k = 2`), ściśle rosnąco.
    pub fn participants(&self) -> &[PartyId; K_2OF3] {
        &self.participants
    }
}

/// Udział pułapki NTRU strony: $(f_i, g_i, F_i, G_i)$ w $R_q$ (sekret).
///
/// Powstaje z dealera testkit (TEST-ORACLE, §5.1) albo docelowo z MPC
/// `G(seed*)` (WP-037). Ścieżka podpisu **nie widzi** pełnego klucza —
/// brak API reconstruct (WP-025/WP-035). Wartości są czyszczone przy dropie.
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct TrapdoorShare {
    x: u16,
    f: Poly,
    g: Poly,
    big_f: Poly,
    big_g: Poly,
}

impl std::fmt::Debug for TrapdoorShare {
    /// `Debug` pokazuje wyłącznie punkt ewaluacji `x`.
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("TrapdoorShare")
            .field("x", &self.x)
            .finish_non_exhaustive()
    }
}

impl TrapdoorShare {
    /// Tworzy udział pułapki w punkcie `x` (niezerowym, `< q`).
    pub fn new(x: u16, f: Poly, g: Poly, big_f: Poly, big_g: Poly) -> Result<Self> {
        if x == 0 {
            return Err(CoreError::XZero);
        }
        if x >= Q {
            return Err(CoreError::OutOfRange);
        }
        Ok(Self {
            x,
            f,
            g,
            big_f,
            big_g,
        })
    }

    /// Punkt ewaluacji Shamira `x`.
    pub fn x(&self) -> u16 {
        self.x
    }

    /// Udział $f_i$ (referencja; sekret — nie logować).
    pub fn f(&self) -> &Poly {
        &self.f
    }

    /// Udział $g_i$ (jw.).
    pub fn g(&self) -> &Poly {
        &self.g
    }

    /// Udział $F_i$ (jw.).
    pub fn f_big(&self) -> &Poly {
        &self.big_f
    }

    /// Udział $G_i$ (jw.).
    pub fn g_big(&self) -> &Poly {
        &self.big_g
    }
}

/// Wynik sesji podpisu (§7.8; `TH_final`/`SignReceipt` — WP-033).
#[derive(Debug)]
pub struct Signature {
    nonce: [u8; NONCE_BYTES],
    bytes: Vec<u8>,
    pk_hash: [u8; 32],
}

impl Signature {
    /// Nonce podpisu (40 B, publiczne — §7.2).
    pub fn nonce(&self) -> &[u8; NONCE_BYTES] {
        &self.nonce
    }

    /// Bajty podpisu: `0xAA || compress_static(s2)` (§2, I-05).
    pub fn bytes(&self) -> &[u8] {
        &self.bytes
    }

    /// `pk_hash` wiążący klucz (§7.8).
    pub fn pk_hash(&self) -> &[u8; 32] {
        &self.pk_hash
    }
}

/// Weryfikator wyniku (I-10, §7.5): [`Signature`] powstaje **dopiero** po
/// `verify(...) == true`; inaczej `Err(VerifyFail)` i brak podpisu.
///
/// W docelowym obiegu to `ft-threshold-verify` (wrapper `ft1536-sys`,
/// WP-048); w WP-031 wywołania e2e podpinają silnik C przez harness
/// `impl/ci/sign/`. Interfejs celowo nie ma żadnego slotu na klucz
/// prywatny (audyt WP-035).
pub trait EngineVerifier {
    /// Czy `sig` jest ważnym podpisem `msg` pod `pk` z `nonce`.
    fn verify(&self, pk: &[u8], msg: &[u8], nonce: &[u8; NONCE_BYTES], sig: &[u8]) -> bool;
}

/// Etapy maszyny stanów sesji sign (SPEC §12.2).
///
/// `INIT → ACCEPTED` zamyka [`SignMachine::begin`]; `VERIFIED → RELEASED`
/// to jedna atomowa tranzycja w [`SignMachine::finish`] (brak częściowego
/// podpisu, I-02).
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum SignStage {
    /// INIT → ACCEPTED: stan walidowany, oczekuje N1.
    Accepted,
    /// NONCE_COMMITTED: własne zobowiązanie wysłane.
    NonceCommitted,
    /// NONCE_REVEALED: własne otwarcie wysłane.
    NonceRevealed,
    /// SAMPLING: `nonce` i `t` policzone (oracle `$z$` z zewnątrz).
    Sampling,
    /// COMPUTING: udziały `(s1_i, s2_i)` policzone.
    Computing,
    /// OPENING: `SIGN_OPEN` wysłany, oczekuje na udział strony przeciwnej.
    Opening,
    /// RELEASED: podpis złożony i potwierdzony przez weryfikator.
    Released,
    /// ABORTED: sesja zatrzymana fail-closed (błąd = brak podpisu).
    Aborted,
}

/// Maszyna stanów sesji podpisu 2-z-3 (TEST-ORACLE).
///
/// Powstaje wyłącznie ze zwalidowanego [`SignSession`] (typestate
/// `PartyState<Ready>` — WP-014). Jeden aktywny sign na instancję
/// (konkurencja/replay = WP-033).
pub struct SignMachine {
    sid: [u8; 32],
    pk_hash: [u8; 32],
    epoch: u64,
    msg: Vec<u8>,
    me: PartyId,
    me_x: u16,
    peer: PartyId,
    peer_x: u16,
    trapdoor: TrapdoorShare,
    receiver: SessionReceiver,
    next_seq: u64,
    my_nonce: Option<Zeroizing<[u8; NONCE_BYTES]>>,
    my_salt: Option<Zeroizing<[u8; SALT_BYTES]>>,
    my_commitment: Option<[u8; 32]>,
    peer_commitment: Option<[u8; 32]>,
    peer_reveal: Option<Zeroizing<([u8; NONCE_BYTES], [u8; SALT_BYTES])>>,
    nonce: Option<[u8; NONCE_BYTES]>,
    t: Option<Poly>,
    t_hash: [u8; 32],
    my_s1: Option<Poly>,
    my_s2: Option<Poly>,
    peer_s1: Option<Poly>,
    peer_s2: Option<Poly>,
    stage: SignStage,
    aborted: bool,
}

impl std::fmt::Debug for SignMachine {
    /// `Debug` pokazuje wyłącznie dane publiczne i etap.
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("SignMachine")
            .field("stage", &self.stage)
            .field("me", &self.me)
            .field("peer", &self.peer)
            .field("aborted", &self.aborted)
            .finish_non_exhaustive()
    }
}

impl SignMachine {
    /// Otwiera sesję podpisu ze zwalidowanego stanu [`SignSession`].
    ///
    /// `party_ids` to roster 3 stron (ściśle rosnąco) w parze pozycyjnej
    /// z punktami Shamira ze stanu; `me` musi należeć do `participants`
    /// żądania, a `trapdoor.x` musi być własnym punktem ewaluacji.
    ///
    /// Profil `Prod` jest odrzucany: WP-031 realizuje wyłącznie
    /// plumbing `TEST-ORACLE`; realny sampler i profil `PROD` to WP-041.
    pub fn begin(
        session: SignSession,
        request: SignRequest,
        me: PartyId,
        party_ids: [PartyId; PARTIES_2OF3],
        trapdoor: TrapdoorShare,
        profile: Profile,
    ) -> Result<Self> {
        if profile != Profile::TestOracle {
            return Err(CoreError::ProdEvidenceMissing);
        }
        if *request.sid() != session.sid() {
            return Err(CoreError::InvalidInput);
        }
        for i in 0..PARTIES_2OF3 {
            if is_zero(&party_ids[i]) {
                return Err(CoreError::InvalidInput);
            }
            if i > 0 && party_ids[i - 1] >= party_ids[i] {
                return Err(CoreError::DuplicateX);
            }
        }
        if session.parties().len() != PARTIES_2OF3 || session.k() != K_2OF3 {
            return Err(CoreError::PartyCountMismatch);
        }

        // Pozycje `me` i `peer` w rosterze; punkty Shamira idą pozycyjnie.
        let mut me_idx = None;
        let mut peer_idx = None;
        for (i, p) in party_ids.iter().enumerate() {
            if *p == me {
                me_idx = Some(i);
            }
            if request.participants().contains(p) && *p != me {
                peer_idx = Some(i);
            }
        }
        let me_idx = me_idx.ok_or(CoreError::PartyCountMismatch)?;
        let peer_idx = peer_idx.ok_or(CoreError::PartyCountMismatch)?;
        if !request.participants().contains(&me) {
            return Err(CoreError::PartyCountMismatch);
        }
        for p in request.participants() {
            if !party_ids.contains(p) {
                return Err(CoreError::PartyCountMismatch);
            }
        }

        let me_x = session.parties()[me_idx];
        let peer_x = session.parties()[peer_idx];
        if me_x != session.self_party() || trapdoor.x() != session.self_party() {
            return Err(CoreError::InconsistentShare);
        }

        let receiver = SessionReceiver::new(*request.sid(), request.epoch(), me)?;
        Ok(Self {
            sid: *request.sid(),
            pk_hash: session.pk_hash(),
            epoch: request.epoch(),
            msg: request.msg().to_vec(),
            me,
            me_x,
            peer: party_ids[peer_idx],
            peer_x,
            trapdoor,
            receiver,
            next_seq: 0,
            my_nonce: None,
            my_salt: None,
            my_commitment: None,
            peer_commitment: None,
            peer_reveal: None,
            nonce: None,
            t: None,
            t_hash: [0u8; 32],
            my_s1: None,
            my_s2: None,
            peer_s1: None,
            peer_s2: None,
            stage: SignStage::Accepted,
            aborted: false,
        })
    }

    /// Etap maszyny.
    pub fn stage(&self) -> SignStage {
        self.stage
    }

    /// Czy sesja została zatrzymana fail-closed.
    pub fn is_aborted(&self) -> bool {
        self.aborted
    }

    /// Uzgodniony `nonce` (po [`SignMachine::derive_nonce`]).
    pub fn nonce(&self) -> Option<[u8; NONCE_BYTES]> {
        self.nonce
    }

    fn ensure_open(&self) -> Result<()> {
        if self.aborted {
            return Err(CoreError::InconsistentShare);
        }
        Ok(())
    }

    fn abort(&mut self) {
        self.aborted = true;
        self.stage = SignStage::Aborted;
    }

    fn check_send_key(&self, key: &EnvelopeKey) -> Result<()> {
        if key.sender() != &self.me || key.recipient() != &self.peer {
            return Err(CoreError::AuthFail);
        }
        Ok(())
    }

    fn check_recv_key(&self, key: &EnvelopeKey) -> Result<()> {
        if key.sender() != &self.peer || key.recipient() != &self.me {
            return Err(CoreError::AuthFail);
        }
        Ok(())
    }

    fn seal(
        &mut self,
        key: &EnvelopeKey,
        round: u64,
        msg_type: u16,
        payload: Vec<u8>,
    ) -> Result<Envelope> {
        self.check_send_key(key)?;
        self.next_seq += 1;
        let body = Body::new(
            self.sid,
            self.epoch,
            round,
            self.next_seq,
            msg_type,
            self.me,
            payload,
        )?;
        Envelope::seal(key, body)
    }

    fn accept(
        &mut self,
        key: &EnvelopeKey,
        env: Envelope,
        round: u64,
        msg_type: u16,
    ) -> Result<(Body, Delivery)> {
        self.check_recv_key(key)?;
        let (body, delivery) = self.receiver.accept(key, env)?;
        if delivery == Delivery::Duplicate {
            return Ok((body, delivery));
        }
        if body.round() != round
            || body.msg_type() != msg_type
            || body.sender() != &self.peer
            || body.sid() != &self.sid
            || body.epoch() != self.epoch
        {
            return Err(CoreError::InvalidInput);
        }
        Ok((body, delivery))
    }

    /// **Runda N1:** losuje udział `n_i` (40 B) i sól `salt_i` (32 B),
    /// liczy zobowiązanie `c_i` (§7.2) i pieczętuje `NONCE_COMMIT`.
    ///
    /// `nonce_share` **MUSI** pochodzić z OS CSPRNG węzła (ten moduł nie
    /// ma I/O ani RNG); sól wiąże zobowiązanie z otwarciem.
    pub fn seal_nonce_commit(
        &mut self,
        key: &EnvelopeKey,
        nonce_share: [u8; NONCE_BYTES],
        salt: [u8; SALT_BYTES],
    ) -> Result<Envelope> {
        self.ensure_open()?;
        if self.stage != SignStage::Accepted {
            return Err(CoreError::RoundMismatch);
        }
        if is_zero(&nonce_share) || is_zero(&salt) {
            return Err(CoreError::InvalidInput);
        }
        let commitment = shake32(&[
            TAG_NONCE_COMMIT,
            &self.sid,
            &self.epoch.to_be_bytes(),
            &self.me,
            &nonce_share,
            &salt,
        ]);
        let payload = NonceCommitPayload::new(commitment)?.to_cbor();
        let env = self.seal(key, ROUND_NONCE_COMMIT, MSG_NONCE_COMMIT, payload)?;
        self.my_nonce = Some(Zeroizing::new(nonce_share));
        self.my_salt = Some(Zeroizing::new(salt));
        self.my_commitment = Some(commitment);
        self.stage = SignStage::NonceCommitted;
        Ok(env)
    }

    /// Odbiera `NONCE_COMMIT` od strony przeciwnej (runda N1).
    pub fn receive_nonce_commit(&mut self, key: &EnvelopeKey, env: Envelope) -> Result<Delivery> {
        self.ensure_open()?;
        if self.stage != SignStage::NonceCommitted {
            return Err(CoreError::RoundMismatch);
        }
        let (body, delivery) = self.accept(key, env, ROUND_NONCE_COMMIT, MSG_NONCE_COMMIT)?;
        if delivery == Delivery::Duplicate {
            return Ok(delivery);
        }
        let payload = NonceCommitPayload::from_cbor(body.payload())?;
        if self.peer_commitment.is_some() {
            // Drugie, różne zobowiązanie tej samej strony = equivocation.
            self.abort();
            return Err(CoreError::ReplayDetected);
        }
        self.peer_commitment = Some(*payload.commitment());
        Ok(delivery)
    }

    /// **Runda N2:** pieczętuje `NONCE_REVEAL` z własnym `n_i` i `salt_i`.
    ///
    /// Wymaga kompletu zobowiązań z N1 (wszystkie commity przed revealami).
    pub fn seal_nonce_reveal(&mut self, key: &EnvelopeKey) -> Result<Envelope> {
        self.ensure_open()?;
        if self.stage != SignStage::NonceCommitted || self.peer_commitment.is_none() {
            return Err(CoreError::RoundMismatch);
        }
        let nonce_share = **self.my_nonce.as_ref().ok_or(CoreError::RoundMismatch)?;
        let salt = **self.my_salt.as_ref().ok_or(CoreError::RoundMismatch)?;
        let payload = NonceRevealPayload::new(nonce_share, salt)?.to_cbor();
        let env = self.seal(key, ROUND_NONCE_REVEAL, MSG_NONCE_REVEAL, payload)?;
        self.stage = SignStage::NonceRevealed;
        Ok(env)
    }

    /// Odbiera `NONCE_REVEAL` i sprawdza zgodność z zobowiązaniem (N2).
    ///
    /// Niezgodność = [`CoreError::CommitmentMismatch`] i abort (fail-closed).
    pub fn receive_nonce_reveal(&mut self, key: &EnvelopeKey, env: Envelope) -> Result<Delivery> {
        self.ensure_open()?;
        if self.stage != SignStage::NonceRevealed {
            return Err(CoreError::RoundMismatch);
        }
        let (body, delivery) = self.accept(key, env, ROUND_NONCE_REVEAL, MSG_NONCE_REVEAL)?;
        if delivery == Delivery::Duplicate {
            return Ok(delivery);
        }
        let payload = NonceRevealPayload::from_cbor(body.payload())?;
        let expected = shake32(&[
            TAG_NONCE_COMMIT,
            &self.sid,
            &self.epoch.to_be_bytes(),
            &self.peer,
            payload.nonce_share(),
            payload.salt(),
        ]);
        let commitment = self.peer_commitment.ok_or(CoreError::RoundMismatch)?;
        if !ct_eq32(&expected, &commitment) {
            self.abort();
            return Err(CoreError::CommitmentMismatch);
        }
        self.peer_reveal = Some(Zeroizing::new((*payload.nonce_share(), *payload.salt())));
        Ok(delivery)
    }

    /// **Runda N3 (lokalna, §7.2):** agreguje odsłonięte udziały w
    /// kanonicznej kolejności (uczestnicy rosnąco):
    /// `nonce = SHAKE256(TAG ‖ sid ‖ epoch ‖ msg ‖ n_lo ‖ n_hi)[0..40]`.
    pub fn derive_nonce(&mut self) -> Result<[u8; NONCE_BYTES]> {
        self.ensure_open()?;
        if self.stage != SignStage::NonceRevealed {
            return Err(CoreError::RoundMismatch);
        }
        let my = **self
            .my_nonce
            .as_ref()
            .ok_or(CoreError::InsufficientShares)?;
        let peer_reveal = self
            .peer_reveal
            .as_ref()
            .ok_or(CoreError::InsufficientShares)?;
        let (peer_n, _peer_salt) = &**peer_reveal;
        // Uczestnicy są sortowani rosnąco; kolejność `n_lo ‖ n_hi` idzie
        // za kolejnością `PartyId`, nie za kolejnością odbioru.
        let (n_lo, n_hi) = if self.me < self.peer {
            (my, *peer_n)
        } else {
            (*peer_n, my)
        };
        let nonce = shake40(&[
            TAG_NONCE,
            &self.sid,
            &self.epoch.to_be_bytes(),
            &self.msg,
            &n_lo,
            &n_hi,
        ]);
        self.nonce = Some(nonce);
        self.stage = SignStage::Sampling;
        Ok(nonce)
    }

    /// **§7.3:** liczy `t = hash_to_point(nonce, msg)` i `t_hash`
    /// (porównywany z `SIGN_OPEN`; rozjazd = `HtpMismatch`/`BAD_HTP`).
    pub fn compute_t(&mut self) -> Result<()> {
        self.ensure_open()?;
        if self.stage != SignStage::Sampling {
            return Err(CoreError::RoundMismatch);
        }
        let nonce = self.nonce.ok_or(CoreError::RoundMismatch)?;
        let t = shake::hash_to_point(&nonce, &self.msg)?;
        self.t_hash = shake32(&[TAG_T, &t.to_le_bytes()]);
        self.t = Some(t);
        Ok(())
    }

    /// **Faza C1 (lokalna):** liczy udziały podpisu w $R_q$ z jawnych
    /// $z = (z0, z1)$ (oracle-sampler z testkitu, §7.4):
    /// $s1_i = z0·g_i + z1·G_i$, $s2_i = z0·f_i + z1·F_i$ (liniowość
    /// Shamira — jawne $z$ skaluje udziały bez reshare).
    ///
    /// `$z$` jest przekazywane z zewnątrz: `protocol`/`core` nie mają
    /// API reconstruct i nie widzą pełnego klucza.
    pub fn compute_shares(&mut self, z0: &[i64], z1: &[i64]) -> Result<()> {
        self.ensure_open()?;
        if self.stage != SignStage::Sampling || self.t.is_none() {
            return Err(CoreError::RoundMismatch);
        }
        if z0.len() != N || z1.len() != N {
            return Err(CoreError::InvalidLength);
        }
        let z0p = poly_from_i64(z0);
        let z1p = poly_from_i64(z1);
        let s1 = z0p
            .mul(&self.trapdoor.g)
            .add(&z1p.mul(&self.trapdoor.big_g));
        let s2 = z0p
            .mul(&self.trapdoor.f)
            .add(&z1p.mul(&self.trapdoor.big_f));
        self.my_s1 = Some(s1);
        self.my_s2 = Some(s2);
        self.stage = SignStage::Computing;
        Ok(())
    }

    /// **Runda C2:** pieczętuje `SIGN_OPEN` z udziałami `(s1_i, s2_i)`
    /// i `t_hash` (decyzja plumbingowa #1 — udział `s1_i` realizuje
    /// check §7.5 #3 „na udziałach").
    pub fn seal_sign_open(&mut self, key: &EnvelopeKey) -> Result<Envelope> {
        self.ensure_open()?;
        if self.stage != SignStage::Computing {
            return Err(CoreError::RoundMismatch);
        }
        let s1 = self.my_s1.as_ref().ok_or(CoreError::RoundMismatch)?;
        let s2 = self.my_s2.as_ref().ok_or(CoreError::RoundMismatch)?;
        let payload = SignOpenPayload::new(s1, s2, &self.t_hash).to_cbor();
        let env = self.seal(key, ROUND_SIGN_OPEN, MSG_SIGN_OPEN, payload)?;
        self.stage = SignStage::Opening;
        Ok(env)
    }

    /// Odbiera `SIGN_OPEN` strony przeciwnej; `t_hash` musi być zgodny
    /// (§7.3, rozjazd = [`CoreError::HtpMismatch`] i abort).
    pub fn receive_sign_open(&mut self, key: &EnvelopeKey, env: Envelope) -> Result<Delivery> {
        self.ensure_open()?;
        if self.stage != SignStage::Opening {
            return Err(CoreError::RoundMismatch);
        }
        let (body, delivery) = self.accept(key, env, ROUND_SIGN_OPEN, MSG_SIGN_OPEN)?;
        if delivery == Delivery::Duplicate {
            return Ok(delivery);
        }
        let payload = SignOpenPayload::from_cbor(body.payload())?;
        if !ct_eq32(payload.t_hash(), &self.t_hash) {
            self.abort();
            return Err(CoreError::HtpMismatch);
        }
        if self.peer_s2.is_some() {
            self.abort();
            return Err(CoreError::ReplayDetected);
        }
        self.peer_s1 = Some(payload.s1_share()?);
        self.peer_s2 = Some(payload.s2_share()?);
        Ok(delivery)
    }

    /// **Faza C2/C3 — złożenie i wydanie:** interpoluje udziały
    /// Lagrange'em w 0, sprawdza relację **na udziałach**
    /// ($s2·h = Σ λ_i s1_i$; §7.5 #3), wyznacza $s1 = Σ λ_i s1_i − t$,
    /// bramkuje normę $L2^2 < B_{norm}$ (decyzja #5), koduje
    /// `sig = 0xAA ‖ compress_static(s2)` i **dopiero** po
    /// `verifier.verify(...) == true` wydaje [`Signature`] (I-02, I-10).
    ///
    /// Każdy błąd = `Err` + abort; podpis nie jest wydawany.
    pub fn finish(
        &mut self,
        h: &Poly,
        pk: &[u8],
        verifier: &dyn EngineVerifier,
    ) -> Result<Signature> {
        self.ensure_open()?;
        if self.stage != SignStage::Opening {
            return Err(CoreError::RoundMismatch);
        }
        let my_s1 = self.my_s1.as_ref().ok_or(CoreError::InsufficientShares)?;
        let my_s2 = self.my_s2.as_ref().ok_or(CoreError::InsufficientShares)?;
        let peer_s1 = self.peer_s1.as_ref().ok_or(CoreError::InsufficientShares)?;
        let peer_s2 = self.peer_s2.as_ref().ok_or(CoreError::InsufficientShares)?;
        let t = self.t.as_ref().ok_or(CoreError::RoundMismatch)?;

        let s1 = lagrange_combine2(self.me_x, my_s1, self.peer_x, peer_s1)?;
        let s2 = lagrange_combine2(self.me_x, my_s2, self.peer_x, peer_s2)?;

        // Check „na udziałach": s2·h == s1 (bez −t), fail-closed.
        if !s2.mul(h).ct_eq(&s1) {
            self.abort();
            return Err(CoreError::InconsistentShare);
        }

        let s1_sig = s1.sub(t);
        if norm2_centered(&s1_sig) + norm2_centered(&s2) >= B_NORM_BOUND2 {
            self.abort();
            return Err(CoreError::NormFail);
        }

        let bytes = codec::encode_sig(&s2);
        let nonce = self.nonce.ok_or(CoreError::RoundMismatch)?;
        if !verifier.verify(pk, &self.msg, &nonce, &bytes) {
            self.abort();
            return Err(CoreError::VerifyFail);
        }

        self.stage = SignStage::Released;
        Ok(Signature {
            nonce,
            bytes,
            pk_hash: self.pk_hash,
        })
    }
}

fn poly_from_i64(v: &[i64]) -> Poly {
    let q = i64::from(Q);
    let coeffs: Vec<u16> = v
        .iter()
        .map(|&c| {
            let mut c = c % q;
            if c < 0 {
                c += q;
            }
            c as u16
        })
        .collect();
    Poly::from_coeffs(&coeffs).expect("N współczynników")
}

/// Składa dwa udziały Shamira w punkcie 0 (lagrange dla `k = 2`).
///
/// To jest **składanie podpisu**, nie rekonstrukcja klucza: wejściem są
/// udziały jawnych wartości wynikowych $(s1_i, s2_i)$ (§7.5 C2/C3).
pub fn lagrange_combine2(x_a: u16, a: &Poly, x_b: u16, b: &Poly) -> Result<Poly> {
    if x_a == 0 || x_b == 0 {
        return Err(CoreError::XZero);
    }
    if x_a == x_b {
        return Err(CoreError::DuplicateX);
    }
    let lam_a = mul_mod(
        sub_mod(0, x_b),
        inv_mod(sub_mod(x_a, x_b)).ok_or(CoreError::OutOfRange)?,
    );
    let lam_b = mul_mod(
        sub_mod(0, x_a),
        inv_mod(sub_mod(x_b, x_a)).ok_or(CoreError::OutOfRange)?,
    );
    Ok(a.scalar_mul(lam_a).add(&b.scalar_mul(lam_b)))
}

fn norm2_centered(p: &Poly) -> u64 {
    let q = i32::from(Q);
    let mut acc = 0u64;
    for &c in p.coeffs() {
        let mut v = i32::from(c);
        if v > q / 2 {
            v -= q;
        }
        acc = acc.saturating_add((i64::from(v) * i64::from(v)) as u64);
    }
    acc
}

#[cfg(test)]
mod tests {
    use super::*;

    #[cfg(feature = "test-oracle")]
    use crate::state::{DealerContribution, PartyState, SEED_INSTANCES, dkg_root};
    #[cfg(feature = "test-oracle")]
    use ft_threshold_core::vss;
    #[cfg(feature = "test-oracle")]
    use sha3::{Digest, Sha3_512};

    const SID: [u8; 32] = [0x42; 32];
    const POLICY_HASH: [u8; 32] = [0x77; 32];
    const REQUEST_ID: [u8; 32] = [0x55; 32];
    const EPOCH: u64 = 7;

    const P1: PartyId = [0x01; 16];
    const P2: PartyId = [0x02; 16];

    #[cfg(feature = "test-oracle")]
    const PK_HASH: [u8; 32] = [0x99; 32];
    #[cfg(feature = "test-oracle")]
    const P3: PartyId = [0x03; 16];
    #[cfg(feature = "test-oracle")]
    const PARTIES: [PartyId; PARTIES_2OF3] = [P1, P2, P3];
    #[cfg(feature = "test-oracle")]
    const XS: [u16; PARTIES_2OF3] = [1, 2, 3];

    #[cfg(feature = "test-oracle")]
    fn pair_key(sender: PartyId, recipient: PartyId) -> EnvelopeKey {
        let mut psk = [0u8; 32];
        psk[..16].copy_from_slice(&sender);
        psk[16..].copy_from_slice(&recipient);
        EnvelopeKey::derive_psk(&psk, SID, EPOCH, sender, recipient).expect("pair key")
    }

    #[cfg(feature = "test-oracle")]
    fn deterministic_blind(tag: u8, inst: u8) -> [u8; 32] {
        let mut h = Sha3_512::new();
        h.update(b"FT1536/WP-031/test-blind");
        h.update([tag, inst, 0]);
        let d = h.finalize();
        let mut out = [0u8; 32];
        out.copy_from_slice(&d[..32]);
        out[31] &= 0b0000_0111;
        out
    }

    /// Fixture DKG (jak testy `state.rs`): 3 dealerów × 32 instancje VSS,
    /// udziały dla punktu `self_x`.
    #[cfg(feature = "test-oracle")]
    fn dkg_fixture(self_x: u16) -> Vec<DealerContribution> {
        let mut out = Vec::with_capacity(XS.len() * SEED_INSTANCES);
        for &dealer in &XS {
            for instance in 0..SEED_INSTANCES as u8 {
                let secret = u16::from(instance) + dealer;
                let (comms, shares) = vss::deal(
                    &[secret, 7 + dealer + u16::from(instance)],
                    &[
                        deterministic_blind(dealer as u8, instance),
                        deterministic_blind(dealer as u8, instance),
                    ],
                    &XS,
                )
                .expect("deal");
                let mine = shares
                    .into_iter()
                    .find(|s| s.x() == self_x)
                    .expect("my share");
                out.push(
                    DealerContribution::new(dealer, instance, comms, mine).expect("contribution"),
                );
            }
        }
        out
    }

    /// `t` przepływu testowego (stałe `n_i`, `msg`, `SID`, `EPOCH`).
    ///
    /// Klucz zabawkowy jest „rigged" wokół tego `t`, żeby wynikowe
    /// $(s1, s2)$ były krótkie i przeszły bramkę normy. Krótkość
    /// kryptograficzna pochodzi z oracle-samplera i prawdziwego klucza
    /// (e2e `impl/ci/sign/`); te testy pokrywają **plumbing**, nie
    /// geometrię kraty.
    #[cfg(feature = "test-oracle")]
    fn test_t() -> Poly {
        let nonce = shake40(&[
            TAG_NONCE,
            &SID,
            &EPOCH.to_be_bytes(),
            b"wp-031 message",
            &[0x11u8; 40],
            &[0x22u8; 40],
        ]);
        shake::hash_to_point(&nonce, b"wp-031 message").expect("t")
    }

    /// Klucz zabawkowy z relacjami $f·h = g$, $F·h = G$:
    /// $f = F = 1$, $h = G = t$, $g = t$. Przy $z = (0, 1)$ daje
    /// $s2 = 1$, $s1 = 0$ — krótko i z poprawnym równaniem weryfikacji.
    #[cfg(feature = "test-oracle")]
    fn toy_key() -> (Poly, Poly, Poly, Poly, Poly) {
        let t = test_t();
        let one_c = {
            let mut c = vec![0u16; N];
            c[0] = 1;
            c
        };
        let f = Poly::from_coeffs(&one_c).expect("f");
        let big_f = Poly::from_coeffs(&one_c).expect("F");
        let h = Poly::from_le_bytes(&t.to_le_bytes()).expect("h");
        let g = f.mul(&h);
        let big_g = big_f.mul(&h);
        (f, g, big_f, big_g, h)
    }

    /// Lokalny dealer testkit: Shamir per współczynnik, udział w `XS[x_idx]`.
    #[cfg(feature = "test-oracle")]
    fn deal_local_share(poly: &Poly, tag: u8, x_idx: usize) -> Poly {
        use ft_threshold_core::shamir_zq;
        let mut coeffs = Vec::with_capacity(N);
        for (i, &c) in poly.coeffs().iter().enumerate() {
            let coeff1 = (u16::from(tag) * 31 + i as u16 * 7 + 3) % Q;
            let ys = shamir_zq::split(c, &XS, &[coeff1])
                .expect("split")
                .iter()
                .map(|s| s.y())
                .collect::<Vec<u16>>();
            coeffs.push(ys[x_idx]);
        }
        Poly::from_coeffs(&coeffs).expect("share poly")
    }

    #[cfg(feature = "test-oracle")]
    fn trapdoor_for(x_idx: usize, tag: u8) -> TrapdoorShare {
        let (f, g, big_f, big_g, _) = toy_key();
        TrapdoorShare::new(
            XS[x_idx],
            deal_local_share(&f, tag, x_idx),
            deal_local_share(&g, tag + 1, x_idx),
            deal_local_share(&big_f, tag + 2, x_idx),
            deal_local_share(&big_g, tag + 3, x_idx),
        )
        .expect("trapdoor")
    }

    #[cfg(feature = "test-oracle")]
    fn fresh_session(self_x: u16) -> SignSession {
        let cs = dkg_fixture(self_x);
        let root = dkg_root(&SID, &PK_HASH, K_2OF3, &XS, &cs).expect("root");
        let (f, g, _big_f, _big_g, h) = toy_key();
        SignSession::begin(
            PartyState::new(SID, PK_HASH, XS.to_vec(), self_x, K_2OF3)
                .expect("state")
                .validate_dkg(&cs, &root)
                .expect("dkg")
                .validate_ntru(&f, &g, &h)
                .expect("ntru"),
            Profile::TestOracle,
        )
        .expect("session")
    }

    #[cfg(feature = "test-oracle")]
    fn request(participants: [PartyId; K_2OF3]) -> SignRequest {
        SignRequest::new(
            SID,
            EPOCH,
            b"wp-031 message".to_vec(),
            POLICY_HASH,
            REQUEST_ID,
            participants,
        )
        .expect("request")
    }

    #[cfg(feature = "test-oracle")]
    struct AcceptVerifier;
    #[cfg(feature = "test-oracle")]
    impl EngineVerifier for AcceptVerifier {
        fn verify(&self, _pk: &[u8], _msg: &[u8], _nonce: &[u8; NONCE_BYTES], _sig: &[u8]) -> bool {
            true
        }
    }

    #[cfg(feature = "test-oracle")]
    struct RejectVerifier;
    #[cfg(feature = "test-oracle")]
    impl EngineVerifier for RejectVerifier {
        fn verify(&self, _pk: &[u8], _msg: &[u8], _nonce: &[u8; NONCE_BYTES], _sig: &[u8]) -> bool {
            false
        }
    }

    /// Stałe, jawne `$z = (0, 1)$` do testów plumbingu (krótkość wynika
    /// z rigowanego klucza — patrz `toy_key`).
    #[cfg(feature = "test-oracle")]
    fn test_z() -> (Vec<i64>, Vec<i64>) {
        let z0 = vec![0i64; N];
        let mut z1 = vec![0i64; N];
        z1[0] = 1;
        (z0, z1)
    }

    /// Pełny przepływ pary w kolejności rund; zwraca sygnatury obu stron.
    #[cfg(feature = "test-oracle")]
    fn run_pair(
        a: &mut SignMachine,
        b: &mut SignMachine,
        k_ab: &EnvelopeKey,
        k_ba: &EnvelopeKey,
        verifier: &dyn EngineVerifier,
    ) -> Result<(Signature, Signature)> {
        let h = toy_key().4;
        // N1
        let e1 = a.seal_nonce_commit(k_ab, [0x11; 40], [0xA1; 32])?;
        let e2 = b.seal_nonce_commit(k_ba, [0x22; 40], [0xB2; 32])?;
        assert_eq!(a.receive_nonce_commit(k_ba, e2)?, Delivery::New);
        assert_eq!(b.receive_nonce_commit(k_ab, e1)?, Delivery::New);
        // N2
        let e3 = a.seal_nonce_reveal(k_ab)?;
        let e4 = b.seal_nonce_reveal(k_ba)?;
        assert_eq!(a.receive_nonce_reveal(k_ba, e4)?, Delivery::New);
        assert_eq!(b.receive_nonce_reveal(k_ab, e3)?, Delivery::New);
        // N3 + §7.3
        assert_eq!(a.derive_nonce()?, b.derive_nonce()?);
        a.compute_t()?;
        b.compute_t()?;
        // C1/C2
        let (z0, z1) = test_z();
        a.compute_shares(&z0, &z1)?;
        b.compute_shares(&z0, &z1)?;
        let e5 = a.seal_sign_open(k_ab)?;
        let e6 = b.seal_sign_open(k_ba)?;
        assert_eq!(a.receive_sign_open(k_ba, e6)?, Delivery::New);
        assert_eq!(b.receive_sign_open(k_ab, e5)?, Delivery::New);
        // C3
        let sa = a.finish(&h, b"pk-bytes", verifier)?;
        let sb = b.finish(&h, b"pk-bytes", verifier)?;
        Ok((sa, sb))
    }

    #[test]
    fn payload_codecs_satisfy_canonical_fixpoint() {
        let commit = NonceCommitPayload::new([0x33; 32]).expect("commit");
        let bytes = commit.to_cbor();
        assert_eq!(NonceCommitPayload::from_cbor(&bytes).expect("dec"), commit);
        assert_eq!(commit.to_cbor(), bytes);
        assert!(NonceCommitPayload::new([0u8; 32]).is_err());

        let reveal = NonceRevealPayload::new([0x44; 40], [0x55; 32]).expect("reveal");
        let bytes = reveal.to_cbor();
        assert_eq!(NonceRevealPayload::from_cbor(&bytes).expect("dec"), reveal);
        assert_eq!(reveal.to_cbor(), bytes);
        assert!(NonceRevealPayload::new([0u8; 40], [0x55; 32]).is_err());

        let s1_c = {
            let mut c = vec![0u16; N];
            c[..3].copy_from_slice(&[1u16, 2, 3]);
            c
        };
        let s2_c = {
            let mut c = vec![0u16; N];
            c[..3].copy_from_slice(&[4u16, 5, 6]);
            c
        };
        let s1 = Poly::from_coeffs(&s1_c).expect("s1");
        let s2 = Poly::from_coeffs(&s2_c).expect("s2");
        let open = SignOpenPayload::new(&s1, &s2, &[0x66; 32]);
        let bytes = open.to_cbor();
        let dec = SignOpenPayload::from_cbor(&bytes).expect("dec");
        assert_eq!(dec.t_hash(), open.t_hash());
        assert_eq!(dec.to_cbor(), bytes);
        assert!(dec.s1_share().expect("s1").ct_eq(&s1));
        assert!(dec.s2_share().expect("s2").ct_eq(&s2));

        // Nadmiarowe śmieci po elemencie = niekanoniczne.
        let mut padded = bytes.clone();
        padded.push(0);
        assert!(SignOpenPayload::from_cbor(&padded).is_err());
    }

    #[test]
    fn request_validates_participants_and_limits() {
        // Nieposortowani uczestnicy.
        assert!(SignRequest::new(SID, EPOCH, vec![], POLICY_HASH, REQUEST_ID, [P2, P1]).is_err());
        // Zerowy sid / request_id / powtórzeni uczestnicy.
        assert!(
            SignRequest::new([0u8; 32], EPOCH, vec![], POLICY_HASH, REQUEST_ID, [P1, P2]).is_err()
        );
        assert!(SignRequest::new(SID, EPOCH, vec![], POLICY_HASH, [0u8; 32], [P1, P2]).is_err());
        assert!(SignRequest::new(SID, EPOCH, vec![], POLICY_HASH, REQUEST_ID, [P1, P1]).is_err());
        // msg > 1 MiB.
        assert!(
            SignRequest::new(
                SID,
                EPOCH,
                vec![0u8; MAX_MSG_BYTES + 1],
                POLICY_HASH,
                REQUEST_ID,
                [P1, P2],
            )
            .is_err()
        );
    }

    #[test]
    fn lagrange_combine2_interpolates_at_zero() {
        // Sekret `s` i współczynnik `c` to wielomiany; udziały liniowe
        // a = s + c·1 (x=1), b = s + c·2 (x=2) muszą złożyć się w `s`.
        let mut s_c = vec![0u16; N];
        s_c[0] = 5;
        s_c[1] = 9;
        let mut c_c = vec![0u16; N];
        c_c[0] = 7;
        c_c[2] = 13;
        let s = Poly::from_coeffs(&s_c).expect("s");
        let c = Poly::from_coeffs(&c_c).expect("c");
        let a = s.add(&c.scalar_mul(1));
        let b = s.add(&c.scalar_mul(2));
        let out = lagrange_combine2(1, &a, 2, &b).expect("combine");
        assert!(out.ct_eq(&s), "interpolacja w 0 musi odtworzyć sekret");
    }

    #[cfg(feature = "test-oracle")]
    fn honest_pair_flow_impl() {
        let mut a = SignMachine::begin(
            fresh_session(XS[0]),
            request([P1, P2]),
            P1,
            PARTIES,
            trapdoor_for(0, 1),
            Profile::TestOracle,
        )
        .expect("machine A");
        let mut b = SignMachine::begin(
            fresh_session(XS[1]),
            request([P1, P2]),
            P2,
            PARTIES,
            trapdoor_for(1, 1),
            Profile::TestOracle,
        )
        .expect("machine B");
        let (k_ab, k_ba) = (pair_key(P1, P2), pair_key(P2, P1));
        let (sa, sb) = run_pair(&mut a, &mut b, &k_ab, &k_ba, &AcceptVerifier).expect("pair");
        assert_eq!(a.stage(), SignStage::Released);
        assert_eq!(b.stage(), SignStage::Released);
        assert_eq!(
            sa.bytes(),
            sb.bytes(),
            "obie strony składają ten sam podpis"
        );

        // Mutation-check: złożone `s2` == jawne `z0·f + z1·F`.
        let (f, g, big_f, big_g, h) = toy_key();
        let (z0, z1) = test_z();
        let z0p = poly_from_i64(&z0);
        let z1p = poly_from_i64(&z1);
        let expected_s2 = z0p.mul(&f).add(&z1p.mul(&big_f));
        let decoded = codec::decode_sig(sa.bytes()).expect("decode sig");
        assert!(
            decoded.ct_eq(&expected_s2),
            "s2 musi być zgodne z jawnym rachunkiem"
        );
        // Równanie weryfikacji: `s1 = s2·h − t` == `z0·g + z1·G − t`.
        let t = shake::hash_to_point(sa.nonce(), b"wp-031 message").expect("t");
        let s1_from_eq = decoded.mul(&h).sub(&t);
        let expected_s1 = z0p.mul(&g).add(&z1p.mul(&big_g)).sub(&t);
        assert!(
            s1_from_eq.ct_eq(&expected_s1),
            "równanie s2·h − s1 = t musi trzymać"
        );
    }

    #[test]
    #[cfg(feature = "test-oracle")]
    #[cfg_attr(
        miri,
        ignore = "fixture VSS Ristretto + mnożenia O(N^2) w Miri są zbyt wolne; pokrywa cargo test"
    )]
    fn honest_pair_flow_releases_equal_signature() {
        honest_pair_flow_impl();
    }

    #[test]
    #[cfg(feature = "test-oracle")]
    #[cfg_attr(
        miri,
        ignore = "fixture VSS Ristretto + mnożenia O(N^2) w Miri są zbyt wolne; pokrywa cargo test"
    )]
    fn all_three_pairs_sign() {
        for (i, j) in [(0usize, 1usize), (0, 2), (1, 2)] {
            let mut a = SignMachine::begin(
                fresh_session(XS[i]),
                request([PARTIES[i], PARTIES[j]]),
                PARTIES[i],
                PARTIES,
                trapdoor_for(i, 1),
                Profile::TestOracle,
            )
            .expect("machine A");
            let mut b = SignMachine::begin(
                fresh_session(XS[j]),
                request([PARTIES[i], PARTIES[j]]),
                PARTIES[j],
                PARTIES,
                trapdoor_for(j, 1),
                Profile::TestOracle,
            )
            .expect("machine B");
            let k_ab = pair_key(PARTIES[i], PARTIES[j]);
            let k_ba = pair_key(PARTIES[j], PARTIES[i]);
            let (sa, sb) = run_pair(&mut a, &mut b, &k_ab, &k_ba, &AcceptVerifier)
                .unwrap_or_else(|e| panic!("para {i},{j}: {e}"));
            assert_eq!(sa.bytes(), sb.bytes(), "para {i},{j}");
        }
    }

    #[test]
    #[cfg(feature = "test-oracle")]
    #[cfg_attr(
        miri,
        ignore = "fixture VSS Ristretto w Miri jest zbyt wolna; pokrywa cargo test"
    )]
    fn commitment_mismatch_aborts_session() {
        let mut a = SignMachine::begin(
            fresh_session(XS[0]),
            request([P1, P2]),
            P1,
            PARTIES,
            trapdoor_for(0, 1),
            Profile::TestOracle,
        )
        .expect("A");
        let mut b = SignMachine::begin(
            fresh_session(XS[1]),
            request([P1, P2]),
            P2,
            PARTIES,
            trapdoor_for(1, 1),
            Profile::TestOracle,
        )
        .expect("B");
        let (k_ab, k_ba) = (pair_key(P1, P2), pair_key(P2, P1));
        let e1 = a
            .seal_nonce_commit(&k_ab, [0x11; 40], [0xA1; 32])
            .expect("c1");
        let e2 = b
            .seal_nonce_commit(&k_ba, [0x22; 40], [0xB2; 32])
            .expect("c2");
        a.receive_nonce_commit(&k_ba, e2).expect("r2");
        b.receive_nonce_commit(&k_ab, e1).expect("r1");
        let e3 = a.seal_nonce_reveal(&k_ab).expect("n1");
        let _ = b.seal_nonce_reveal(&k_ba).expect("n2");

        // B fałszuje otwarcie: inne `n_i` niż zaciągnięte w zobowiązaniu
        // (uczciwe N2 B nie jest dostarczane; fałszywe zajmuje jego seq).
        let forged = NonceRevealPayload::new([0x99; 40], [0xB2; 32]).expect("forged");
        let body = Body::new(
            SID,
            EPOCH,
            ROUND_NONCE_REVEAL,
            2,
            MSG_NONCE_REVEAL,
            P2,
            forged.to_cbor(),
        )
        .expect("body");
        let forged_env = Envelope::seal(&k_ba, body).expect("seal");

        assert_eq!(
            a.receive_nonce_reveal(&k_ba, forged_env).unwrap_err(),
            CoreError::CommitmentMismatch
        );
        assert!(a.is_aborted(), "fałszywe otwarcie = fail-closed abort");
        assert_eq!(a.stage(), SignStage::Aborted);
        // Dalsze kroki są niemożliwe.
        assert!(a.seal_nonce_reveal(&k_ab).is_err());
        let _ = e3;
    }

    #[test]
    #[cfg(feature = "test-oracle")]
    #[cfg_attr(
        miri,
        ignore = "fixture VSS Ristretto w Miri jest zbyt wolna; pokrywa cargo test"
    )]
    fn wrong_stage_operations_are_rejected() {
        let mut a = SignMachine::begin(
            fresh_session(XS[0]),
            request([P1, P2]),
            P1,
            PARTIES,
            trapdoor_for(0, 1),
            Profile::TestOracle,
        )
        .expect("A");
        let k_ab = pair_key(P1, P2);
        // Reveal przed commit, derive przed revealami, compute_t przed nonce.
        assert_eq!(
            a.seal_nonce_reveal(&k_ab).unwrap_err(),
            CoreError::RoundMismatch
        );
        assert_eq!(a.derive_nonce().unwrap_err(), CoreError::RoundMismatch);
        assert_eq!(a.compute_t().unwrap_err(), CoreError::RoundMismatch);
        assert_eq!(
            a.compute_shares(&[0i64; N], &[0i64; N]).unwrap_err(),
            CoreError::RoundMismatch
        );
        // Commit bez poprawnego klucza pary.
        let bad_key = pair_key(P1, P3);
        assert_eq!(
            a.seal_nonce_commit(&bad_key, [0x11; 40], [0xA1; 32])
                .unwrap_err(),
            CoreError::AuthFail
        );
    }

    #[test]
    #[cfg(feature = "test-oracle")]
    #[cfg_attr(
        miri,
        ignore = "fixture VSS Ristretto w Miri jest zbyt wolna; pokrywa cargo test"
    )]
    fn second_commit_is_equivocation() {
        let mut a = SignMachine::begin(
            fresh_session(XS[0]),
            request([P1, P2]),
            P1,
            PARTIES,
            trapdoor_for(0, 1),
            Profile::TestOracle,
        )
        .expect("A");
        let mut b = SignMachine::begin(
            fresh_session(XS[1]),
            request([P1, P2]),
            P2,
            PARTIES,
            trapdoor_for(1, 1),
            Profile::TestOracle,
        )
        .expect("B");
        let (k_ab, k_ba) = (pair_key(P1, P2), pair_key(P2, P1));
        let e1 = a
            .seal_nonce_commit(&k_ab, [0x11; 40], [0xA1; 32])
            .expect("c1");
        let e2 = b
            .seal_nonce_commit(&k_ba, [0x22; 40], [0xB2; 32])
            .expect("c2");
        a.receive_nonce_commit(&k_ba, e2).expect("r2");
        b.receive_nonce_commit(&k_ab, e1).expect("r1");

        // Drugie, inne zobowiązanie B (seq=2, ta sama runda) to equivocation.
        let second = NonceCommitPayload::new([0xAB; 32]).expect("second");
        let body = Body::new(
            SID,
            EPOCH,
            ROUND_NONCE_COMMIT,
            2,
            MSG_NONCE_COMMIT,
            P2,
            second.to_cbor(),
        )
        .expect("body");
        let second_env = Envelope::seal(&k_ba, body).expect("seal");
        assert_eq!(
            a.receive_nonce_commit(&k_ba, second_env).unwrap_err(),
            CoreError::ReplayDetected
        );
        assert!(a.is_aborted(), "equivocation = fail-closed abort");
    }

    #[test]
    #[cfg(feature = "test-oracle")]
    #[cfg_attr(
        miri,
        ignore = "fixture VSS Ristretto + mnożenia O(N^2) w Miri są zbyt wolne; pokrywa cargo test"
    )]
    fn tampered_s2_share_fails_share_check() {
        let mut a = SignMachine::begin(
            fresh_session(XS[0]),
            request([P1, P2]),
            P1,
            PARTIES,
            trapdoor_for(0, 1),
            Profile::TestOracle,
        )
        .expect("A");
        let mut b = SignMachine::begin(
            fresh_session(XS[1]),
            request([P1, P2]),
            P2,
            PARTIES,
            trapdoor_for(1, 1),
            Profile::TestOracle,
        )
        .expect("B");
        let (k_ab, k_ba) = (pair_key(P1, P2), pair_key(P2, P1));
        let e1 = a
            .seal_nonce_commit(&k_ab, [0x11; 40], [0xA1; 32])
            .expect("c1");
        let e2 = b
            .seal_nonce_commit(&k_ba, [0x22; 40], [0xB2; 32])
            .expect("c2");
        a.receive_nonce_commit(&k_ba, e2).expect("r2");
        b.receive_nonce_commit(&k_ab, e1).expect("r1");
        let e3 = a.seal_nonce_reveal(&k_ab).expect("n1");
        let e4 = b.seal_nonce_reveal(&k_ba).expect("n2");
        a.receive_nonce_reveal(&k_ba, e4).expect("rr2");
        b.receive_nonce_reveal(&k_ab, e3).expect("rr1");
        a.derive_nonce().expect("nonce");
        b.derive_nonce().expect("nonce");
        a.compute_t().expect("t");
        b.compute_t().expect("t");
        let (z0, z1) = test_z();
        a.compute_shares(&z0, &z1).expect("shares A");
        b.compute_shares(&z0, &z1).expect("shares B");
        let e5 = a.seal_sign_open(&k_ab).expect("o1");

        // B przekłamuje udział `s2` (`s1` zostaje — relacja na udziałach pęknie).
        let honest_env = b.seal_sign_open(&k_ba).expect("o2");
        let honest = SignOpenPayload::from_cbor(honest_env.body_unverified().payload()).expect("p");
        let mut bump = vec![0u16; N];
        bump[0] = 1;
        let s2_bad = honest
            .s2_share()
            .expect("s2")
            .add(&Poly::from_coeffs(&bump).expect("bump"));
        let forged =
            SignOpenPayload::new(&honest.s1_share().expect("s1"), &s2_bad, honest.t_hash());
        let body = Body::new(
            SID,
            EPOCH,
            ROUND_SIGN_OPEN,
            3,
            MSG_SIGN_OPEN,
            P2,
            forged.to_cbor(),
        )
        .expect("body");
        let forged_env = Envelope::seal(&k_ba, body).expect("seal");

        a.receive_sign_open(&k_ba, forged_env)
            .expect("receive forged");
        let h = toy_key().4;
        assert_eq!(
            a.finish(&h, b"pk-bytes", &AcceptVerifier).unwrap_err(),
            CoreError::InconsistentShare
        );
        assert!(a.is_aborted());
        assert_eq!(a.stage(), SignStage::Aborted);
        let _ = e5;
    }

    #[test]
    #[cfg(feature = "test-oracle")]
    #[cfg_attr(
        miri,
        ignore = "fixture VSS Ristretto + mnożenia O(N^2) w Miri są zbyt wolne; pokrywa cargo test"
    )]
    fn tampered_t_hash_is_rejected() {
        let mut a = SignMachine::begin(
            fresh_session(XS[0]),
            request([P1, P2]),
            P1,
            PARTIES,
            trapdoor_for(0, 1),
            Profile::TestOracle,
        )
        .expect("A");
        let mut b = SignMachine::begin(
            fresh_session(XS[1]),
            request([P1, P2]),
            P2,
            PARTIES,
            trapdoor_for(1, 1),
            Profile::TestOracle,
        )
        .expect("B");
        let (k_ab, k_ba) = (pair_key(P1, P2), pair_key(P2, P1));
        let e1 = a
            .seal_nonce_commit(&k_ab, [0x11; 40], [0xA1; 32])
            .expect("c1");
        let e2 = b
            .seal_nonce_commit(&k_ba, [0x22; 40], [0xB2; 32])
            .expect("c2");
        a.receive_nonce_commit(&k_ba, e2).expect("r2");
        b.receive_nonce_commit(&k_ab, e1).expect("r1");
        let e3 = a.seal_nonce_reveal(&k_ab).expect("n1");
        let e4 = b.seal_nonce_reveal(&k_ba).expect("n2");
        a.receive_nonce_reveal(&k_ba, e4).expect("rr2");
        b.receive_nonce_reveal(&k_ab, e3).expect("rr1");
        a.derive_nonce().expect("nonce");
        b.derive_nonce().expect("nonce");
        a.compute_t().expect("t");
        b.compute_t().expect("t");
        let (z0, z1) = test_z();
        a.compute_shares(&z0, &z1).expect("shares A");
        b.compute_shares(&z0, &z1).expect("shares B");
        let _ = a.seal_sign_open(&k_ab).expect("o1");

        // B wysyła udziały z podmienionym `t_hash`.
        let honest_env = b.seal_sign_open(&k_ba).expect("o2");
        let honest = SignOpenPayload::from_cbor(honest_env.body_unverified().payload()).expect("p");
        let mut bad_t = [0u8; 32];
        bad_t.copy_from_slice(honest.t_hash());
        bad_t[0] ^= 0xFF;
        let forged = SignOpenPayload::new(
            &honest.s1_share().expect("s1"),
            &honest.s2_share().expect("s2"),
            &bad_t,
        );
        let body = Body::new(
            SID,
            EPOCH,
            ROUND_SIGN_OPEN,
            3,
            MSG_SIGN_OPEN,
            P2,
            forged.to_cbor(),
        )
        .expect("body");
        let forged_env = Envelope::seal(&k_ba, body).expect("seal");

        assert_eq!(
            a.receive_sign_open(&k_ba, forged_env).unwrap_err(),
            CoreError::HtpMismatch
        );
        assert!(a.is_aborted());
    }

    #[test]
    #[cfg(feature = "test-oracle")]
    #[cfg_attr(
        miri,
        ignore = "fixture VSS Ristretto + mnożenia O(N^2) w Miri są zbyt wolne; pokrywa cargo test"
    )]
    fn rejecting_verifier_blocks_release() {
        let mut a = SignMachine::begin(
            fresh_session(XS[0]),
            request([P1, P2]),
            P1,
            PARTIES,
            trapdoor_for(0, 1),
            Profile::TestOracle,
        )
        .expect("A");
        let mut b = SignMachine::begin(
            fresh_session(XS[1]),
            request([P1, P2]),
            P2,
            PARTIES,
            trapdoor_for(1, 1),
            Profile::TestOracle,
        )
        .expect("B");
        let (k_ab, k_ba) = (pair_key(P1, P2), pair_key(P2, P1));
        let e1 = a
            .seal_nonce_commit(&k_ab, [0x11; 40], [0xA1; 32])
            .expect("c1");
        let e2 = b
            .seal_nonce_commit(&k_ba, [0x22; 40], [0xB2; 32])
            .expect("c2");
        a.receive_nonce_commit(&k_ba, e2).expect("r2");
        b.receive_nonce_commit(&k_ab, e1).expect("r1");
        let e3 = a.seal_nonce_reveal(&k_ab).expect("n1");
        let e4 = b.seal_nonce_reveal(&k_ba).expect("n2");
        a.receive_nonce_reveal(&k_ba, e4).expect("rr2");
        b.receive_nonce_reveal(&k_ab, e3).expect("rr1");
        a.derive_nonce().expect("nonce");
        b.derive_nonce().expect("nonce");
        a.compute_t().expect("t");
        b.compute_t().expect("t");
        let (z0, z1) = test_z();
        a.compute_shares(&z0, &z1).expect("shares A");
        b.compute_shares(&z0, &z1).expect("shares B");
        let e5 = a.seal_sign_open(&k_ab).expect("o1");
        let e6 = b.seal_sign_open(&k_ba).expect("o2");
        a.receive_sign_open(&k_ba, e6).expect("recv");

        let h = toy_key().4;
        assert_eq!(
            a.finish(&h, b"pk-bytes", &RejectVerifier).unwrap_err(),
            CoreError::VerifyFail
        );
        assert!(a.is_aborted(), "VERIFY_FAIL = brak wydania, fail-closed");
        assert_eq!(a.stage(), SignStage::Aborted);
        let _ = e5;
    }

    #[test]
    #[cfg(feature = "test-oracle")]
    fn begin_rejects_wrong_profile_and_mismatched_roster() {
        // Profil Prod.
        let err = SignMachine::begin(
            fresh_session(XS[0]),
            request([P1, P2]),
            P1,
            PARTIES,
            trapdoor_for(0, 1),
            Profile::Prod,
        )
        .unwrap_err();
        assert_eq!(err, CoreError::ProdEvidenceMissing);
        // `me` spoza uczestników.
        let err = SignMachine::begin(
            fresh_session(XS[2]),
            request([P1, P2]),
            P3,
            PARTIES,
            trapdoor_for(2, 1),
            Profile::TestOracle,
        )
        .unwrap_err();
        assert_eq!(err, CoreError::PartyCountMismatch);
        // Udział w złym punkcie x.
        let err = SignMachine::begin(
            fresh_session(XS[0]),
            request([P1, P2]),
            P1,
            PARTIES,
            trapdoor_for(1, 1),
            Profile::TestOracle,
        )
        .unwrap_err();
        assert_eq!(err, CoreError::InconsistentShare);
    }
}
