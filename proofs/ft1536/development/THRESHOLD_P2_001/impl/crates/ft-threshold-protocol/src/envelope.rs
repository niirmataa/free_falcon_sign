//! Uwierzytelnione koperty, licznik rund i replay-window (WP-020, WP-027).
//!
//! **Zakres.** Kanoniczny CBOR (RFC 8949, deterministic encoding) dla
//! `body` i `envelope` (SPEC §9.2/§9.3), MAC per para, monotoniczny
//! `round` per nadawca powiązany z `seq` oraz okno `seq` z idempotentną
//! retransmisją identycznego `msg_id`. To warstwa aplikacyjna **nad**
//! TLS 1.3/mTLS (D-010): nie zastępuje transportu i nie jest AEAD.
//!
//! **Klucz.** W `TEST-ORACLE` `K_mac` może pochodzić z pre-shared key
//! ([`EnvelopeKey::derive_psk`]). W `PROD` klucz musi pochodzić z TLS
//! exporter + HKDF-SHA256 z tagiem, `sid`, `epoch`, `sender`, `recipient`
//! (SPEC §9.3); to zadanie WP-045/O-09 i **nie** jest tu udowodnione.
//!
//! **Format v1 (zamrożony WP-027).** `body` i `envelope` są mapami
//! CBOR o kluczach `1..=8` / `1..=3` (SPEC §9.3); `mac` jest liczony nad
//! `MAC_DOMAIN || canonical(envelope \ {3})`, a `msg_id` nad
//! `MSGID_DOMAIN || canonical(body)`. Dekoder jest ścisły: forma
//! nieskrócona, długości nieokreślone, tagi, klucze
//! nieposortowane/podwójne/nieznane i śmieci po elemencie → `Err`.
//! Zmiana formatu wymaga nowej wersji i nowych domen MAC.
//!
//! **Fail-closed.** Zły MAC, zły odbiorca, obca sesja/epoka, powtórzone
//! `seq` z innym `msg_id`, wiadomość poza oknem i naruszenie
//! współmonotoniczności `(seq, round)` → `Err`. Identyczna retransmisja
//! (`seq` + `msg_id`) wewnątrz okna jest zawsze idempotentna
//! ([`Delivery::Duplicate`]), nawet po przejściu nadawcy do wyższej rundy.

#![forbid(unsafe_code)]

use std::collections::BTreeMap;

use hmac::{Hmac, Mac};
use sha2::Sha256;
use zeroize::{Zeroize, ZeroizeOnDrop};

use ft_threshold_core::error::{CoreError, Result};
use ft_threshold_core::shake;

use crate::cbor::{CborReader, CborWriter};

type HmacSha256 = Hmac<Sha256>;

/// Domena wyprowadzania `K_mac` (PSK/TEST-ORACLE).
pub const KEY_DOMAIN: &[u8] = b"FT1536/threshold/v1/envelope-key";
/// Domena MAC koperty.
pub const MAC_DOMAIN: &[u8] = b"FT1536/threshold/v1/mac";
/// Domena `msg_id`.
pub const MSGID_DOMAIN: &[u8] = b"FT1536/threshold/v1/msgid";

/// Wersja formatu wire (v1; zamrożona WP-027).
pub const WIRE_VERSION: u8 = 1;
/// Maksymalny payload koperty (v0; SPEC §9.5 zaostrza do 1 MiB na wiadomość).
pub const MAX_PAYLOAD_BYTES: usize = 1 << 20;
/// Rozmiar okna replay (`seq` poza oknem = odrzucone).
pub const REPLAY_WINDOW: usize = 64;

/// Identyfikator strony (16 B).
pub type PartyId = [u8; 16];

/// Klucz MAC pary `(sender, recipient)` w sesji i epoce.
///
/// Brak `Clone`; drop zeroizuje materiał klucza. `Debug` nie pokazuje klucza.
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct EnvelopeKey {
    key: [u8; 32],
    sid: [u8; 32],
    epoch: u64,
    sender: PartyId,
    recipient: PartyId,
}

impl std::fmt::Debug for EnvelopeKey {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("EnvelopeKey")
            .field("sid", &self.sid)
            .field("epoch", &self.epoch)
            .field("sender", &self.sender)
            .field("recipient", &self.recipient)
            .finish_non_exhaustive()
    }
}

impl EnvelopeKey {
    /// `K_mac` z pre-shared key (TEST-ORACLE); w `PROD` użyć TLS exporter.
    pub fn derive_psk(
        psk: &[u8; 32],
        sid: [u8; 32],
        epoch: u64,
        sender: PartyId,
        recipient: PartyId,
    ) -> Result<Self> {
        if is_zero(&sid) || is_zero(&sender) || is_zero(&recipient) || sender == recipient {
            return Err(CoreError::InvalidInput);
        }
        let mut h =
            <HmacSha256 as Mac>::new_from_slice(psk).map_err(|_| CoreError::InvalidLength)?;
        h.update(KEY_DOMAIN);
        h.update(&sid);
        h.update(&epoch.to_be_bytes());
        h.update(&sender);
        h.update(&recipient);
        let out = h.finalize().into_bytes();
        let mut key = [0u8; 32];
        key.copy_from_slice(&out);
        Ok(Self {
            key,
            sid,
            epoch,
            sender,
            recipient,
        })
    }

    /// Nadawca, do którego przypisany jest klucz.
    pub fn sender(&self) -> &PartyId {
        &self.sender
    }

    /// Odbiorca, do którego przypisany jest klucz.
    pub fn recipient(&self) -> &PartyId {
        &self.recipient
    }

    fn mac(&self, auth_bytes: &[u8]) -> Result<[u8; 32]> {
        let mut h =
            <HmacSha256 as Mac>::new_from_slice(&self.key).map_err(|_| CoreError::InvalidLength)?;
        h.update(MAC_DOMAIN);
        h.update(auth_bytes);
        let out = h.finalize().into_bytes();
        let mut mac = [0u8; 32];
        mac.copy_from_slice(&out);
        Ok(mac)
    }
}

/// `body` wiadomości (SPEC §9.3); payload może być poufny.
pub struct Body {
    version: u8,
    sid: [u8; 32],
    epoch: u64,
    round: u64,
    seq: u64,
    msg_type: u16,
    sender: PartyId,
    payload: Vec<u8>,
}

impl std::fmt::Debug for Body {
    /// `Debug` nie wypisuje payloadu (może zawierać udziały).
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Body")
            .field("version", &self.version)
            .field("sid", &self.sid)
            .field("epoch", &self.epoch)
            .field("round", &self.round)
            .field("seq", &self.seq)
            .field("msg_type", &self.msg_type)
            .field("sender", &self.sender)
            .field("payload_len", &self.payload.len())
            .finish_non_exhaustive()
    }
}

impl Body {
    /// Buduje `body`; wersja musi być 1, `msg_type != 0`, ID niezerowe,
    /// payload ≤ [`MAX_PAYLOAD_BYTES`].
    #[allow(clippy::too_many_arguments)]
    pub fn new(
        sid: [u8; 32],
        epoch: u64,
        round: u64,
        seq: u64,
        msg_type: u16,
        sender: PartyId,
        payload: Vec<u8>,
    ) -> Result<Self> {
        if is_zero(&sid) || is_zero(&sender) {
            return Err(CoreError::InvalidInput);
        }
        if msg_type == 0 {
            return Err(CoreError::InvalidInput);
        }
        if payload.len() > MAX_PAYLOAD_BYTES {
            return Err(CoreError::InvalidLength);
        }
        Ok(Self {
            version: 1,
            sid,
            epoch,
            round,
            seq,
            msg_type,
            sender,
            payload,
        })
    }

    /// Wersja formatu (stała 1).
    pub fn version(&self) -> u8 {
        self.version
    }

    /// Identyfikator sesji.
    pub fn sid(&self) -> &[u8; 32] {
        &self.sid
    }

    /// Epoka klucza.
    pub fn epoch(&self) -> u64 {
        self.epoch
    }

    /// Runda protokołu.
    pub fn round(&self) -> u64 {
        self.round
    }

    /// Licznik per nadawca.
    pub fn seq(&self) -> u64 {
        self.seq
    }

    /// Typ komunikatu.
    pub fn msg_type(&self) -> u16 {
        self.msg_type
    }

    /// Nadawca.
    pub fn sender(&self) -> &PartyId {
        &self.sender
    }

    /// Payload (może być poufny; nie logować).
    pub fn payload(&self) -> &[u8] {
        &self.payload
    }

    /// `msg_id = SHAKE256(domain || canonical(body))[0..32]`, niezależny
    /// od odbiorcy.
    pub fn msg_id(&self) -> [u8; 32] {
        let encoded = self.to_cbor();
        let mut input = Vec::with_capacity(MSGID_DOMAIN.len() + encoded.len());
        input.extend_from_slice(MSGID_DOMAIN);
        input.extend_from_slice(&encoded);
        let mut out = [0u8; 32];
        shake::shake256(&input, &mut out);
        out
    }

    /// Kanoniczne bajty CBOR `body` (format v1, SPEC §9.3).
    pub fn to_cbor(&self) -> Vec<u8> {
        let mut w = CborWriter::new();
        w.put_map(8);
        w.put_uint(1);
        w.put_uint(u64::from(self.version));
        w.put_uint(2);
        w.put_bstr(&self.sid);
        w.put_uint(3);
        w.put_uint(self.epoch);
        w.put_uint(4);
        w.put_uint(self.round);
        w.put_uint(5);
        w.put_uint(self.seq);
        w.put_uint(6);
        w.put_uint(u64::from(self.msg_type));
        w.put_uint(7);
        w.put_bstr(&self.sender);
        w.put_uint(8);
        w.put_bstr(&self.payload);
        w.into_bytes()
    }

    /// Ścisłe dekodowanie kanonicznego CBOR `body` (format v1).
    ///
    /// Odrzuca wszystko, co nie jest bajt w bajt identyczne z kodowaniem
    /// [`Body::to_cbor`]: klucze inne niż `1..=8` w kolejności rosnącej,
    /// złe typy/rozmiary, `version != 1`, payload ponad limit oraz śmieci
    /// po mapie.
    fn decode(bytes: &[u8]) -> Result<Self> {
        let mut r = CborReader::new(bytes);
        let pairs = r.expect_map()?;
        if pairs != 8 {
            return Err(CoreError::NonCanonicalCbor);
        }
        let mut version = 0u64;
        let mut sid = [0u8; 32];
        let mut epoch = 0u64;
        let mut round = 0u64;
        let mut seq = 0u64;
        let mut msg_type = 0u64;
        let mut sender = [0u8; 16];
        let mut payload: Vec<u8> = Vec::new();

        for key in 1u64..=8 {
            if r.expect_uint()? != key {
                return Err(CoreError::NonCanonicalCbor);
            }
            match key {
                1 => version = r.expect_uint()?,
                2 => {
                    let b = r.expect_bstr(sid.len())?;
                    if b.len() != sid.len() {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    sid.copy_from_slice(b);
                }
                3 => epoch = r.expect_uint()?,
                4 => round = r.expect_uint()?,
                5 => seq = r.expect_uint()?,
                6 => msg_type = r.expect_uint()?,
                7 => {
                    let b = r.expect_bstr(sender.len())?;
                    if b.len() != sender.len() {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    sender.copy_from_slice(b);
                }
                _ => {
                    let b = r.expect_bstr(MAX_PAYLOAD_BYTES)?;
                    payload = b.to_vec();
                }
            }
        }
        r.expect_end()?;
        if version != u64::from(WIRE_VERSION) {
            return Err(CoreError::NonCanonicalCbor);
        }
        let msg_type = u16::try_from(msg_type).map_err(|_| CoreError::NonCanonicalCbor)?;
        Self::new(sid, epoch, round, seq, msg_type, sender, payload)
    }
}

impl TryFrom<&[u8]> for Body {
    type Error = CoreError;

    fn try_from(value: &[u8]) -> Result<Self> {
        Body::decode(value)
    }
}

/// Wejście MAC: `canonical(envelope \ {3})` — mapa `{1: body, 2: recipient}`
/// (SPEC §9.3); body jest osadzone jako pełny element CBOR.
fn envelope_auth_bytes(body_cbor: &[u8], recipient: &PartyId) -> Vec<u8> {
    let mut w = CborWriter::new();
    w.put_map(2);
    w.put_uint(1);
    w.put_raw(body_cbor);
    w.put_uint(2);
    w.put_bstr(recipient);
    w.into_bytes()
}

/// Uwierzytelniona koperta.
pub struct Envelope {
    body: Body,
    recipient: PartyId,
    mac: [u8; 32],
}

impl std::fmt::Debug for Envelope {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Envelope")
            .field("body", &self.body)
            .field("recipient", &self.recipient)
            .finish_non_exhaustive()
    }
}

impl Envelope {
    /// Opakowuje `body` kluczem pary; `body.sender` musi zgadzać się z kluczem.
    pub fn seal(key: &EnvelopeKey, body: Body) -> Result<Self> {
        if body.sender != key.sender || body.sid != key.sid || body.epoch != key.epoch {
            return Err(CoreError::AuthFail);
        }
        let auth = envelope_auth_bytes(&body.to_cbor(), &key.recipient);
        let mac = key.mac(&auth)?;
        Ok(Self {
            body,
            recipient: key.recipient,
            mac,
        })
    }

    /// Weryfikuje MAC i kontekst, zwraca `body` (konsumuje kopertę).
    pub fn open(self, key: &EnvelopeKey) -> Result<Body> {
        if self.body.sender != key.sender
            || self.recipient != key.recipient
            || self.body.sid != key.sid
            || self.body.epoch != key.epoch
        {
            return Err(CoreError::AuthFail);
        }
        let auth = envelope_auth_bytes(&self.body.to_cbor(), &self.recipient);
        let expected = key.mac(&auth)?;
        if !ct_eq32(&expected, &self.mac) {
            return Err(CoreError::AuthFail);
        }
        Ok(self.body)
    }

    /// `body` bez weryfikacji — wyłącznie do diagnostyki/testów; nie ufać.
    pub fn body_unverified(&self) -> &Body {
        &self.body
    }

    /// Kanoniczne bajty CBOR `envelope` (format v1, SPEC §9.3):
    /// `{1: body, 2: recipient, 3: mac}`.
    pub fn to_bytes(&self) -> Vec<u8> {
        let body_cbor = self.body.to_cbor();
        let mut w = CborWriter::new();
        w.put_map(3);
        w.put_uint(1);
        w.put_raw(&body_cbor);
        w.put_uint(2);
        w.put_bstr(&self.recipient);
        w.put_uint(3);
        w.put_bstr(&self.mac);
        w.into_bytes()
    }

    /// Ścisłe dekodowanie kanonicznego CBOR `envelope` (format v1).
    ///
    /// Odrzuca klucze inne niż `1,2,3` w kolejności rosnącej, złe typy,
    /// `recipient` ≠ 16 B, `mac` ≠ 32 B oraz śmieci po mapie. Sam `body`
    /// jest dekodowany tymi samymi regułami ([`Body::decode`]).
    fn decode(bytes: &[u8]) -> Result<Self> {
        let mut r = CborReader::new(bytes);
        let pairs = r.expect_map()?;
        if pairs != 3 {
            return Err(CoreError::NonCanonicalCbor);
        }
        let mut body_cbor: &[u8] = &[];
        let mut recipient = [0u8; 16];
        let mut mac = [0u8; 32];

        for key in 1u64..=3 {
            if r.expect_uint()? != key {
                return Err(CoreError::NonCanonicalCbor);
            }
            match key {
                1 => body_cbor = r.next_item_bytes(0)?,
                2 => {
                    let b = r.expect_bstr(recipient.len())?;
                    if b.len() != recipient.len() {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    recipient.copy_from_slice(b);
                }
                _ => {
                    let b = r.expect_bstr(mac.len())?;
                    if b.len() != mac.len() {
                        return Err(CoreError::NonCanonicalCbor);
                    }
                    mac.copy_from_slice(b);
                }
            }
        }
        r.expect_end()?;
        let body = Body::decode(body_cbor)?;
        Ok(Self {
            body,
            recipient,
            mac,
        })
    }
}

impl TryFrom<&[u8]> for Envelope {
    type Error = CoreError;

    fn try_from(value: &[u8]) -> Result<Self> {
        Envelope::decode(value)
    }
}

/// Wynik przyjęcia koperty.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum Delivery {
    /// Nowa wiadomość.
    New,
    /// Identyczna retransmisja (`seq` + `msg_id`); idempotentnie zignorowana.
    Duplicate,
}

/// Okno `seq` z idempotentną retransmisją identycznego `msg_id`.
pub struct ReplayWindow {
    highest: u64,
    slots: [Option<[u8; 32]>; REPLAY_WINDOW],
}

impl Default for ReplayWindow {
    fn default() -> Self {
        Self {
            highest: 0,
            slots: [None; REPLAY_WINDOW],
        }
    }
}

impl ReplayWindow {
    /// Przyjmuje `seq`/`msg_id`; stare lub sprzeczne → `Err`.
    pub fn accept(&mut self, seq: u64, msg_id: [u8; 32]) -> Result<Delivery> {
        if seq == 0 {
            return Err(CoreError::InvalidInput);
        }
        if self.highest == 0 {
            self.highest = seq;
            self.slots[idx(seq)] = Some(msg_id);
            return Ok(Delivery::New);
        }
        if seq > self.highest {
            let gap = seq - self.highest;
            if gap >= REPLAY_WINDOW as u64 {
                self.slots.fill(None);
            } else {
                for s in (self.highest + 1)..=seq {
                    self.slots[idx(s)] = None;
                }
            }
            self.highest = seq;
            self.slots[idx(seq)] = Some(msg_id);
            return Ok(Delivery::New);
        }
        if self.highest - seq >= REPLAY_WINDOW as u64 {
            return Err(CoreError::ReplayDetected);
        }
        match self.slots[idx(seq)] {
            Some(prev) if prev == msg_id => Ok(Delivery::Duplicate),
            Some(_) => Err(CoreError::ReplayDetected),
            None => {
                self.slots[idx(seq)] = Some(msg_id);
                Ok(Delivery::New)
            }
        }
    }
}

/// Stan odbiorcy sesji: `sid`, epoka, własne ID i okna nadawców.
pub struct SessionReceiver {
    sid: [u8; 32],
    epoch: u64,
    me: PartyId,
    peers: BTreeMap<PartyId, PeerState>,
}

struct PeerState {
    /// Runda odpowiadająca najwyższemu przyjętemu `seq` (`replay.highest`).
    round: u64,
    /// Najwyższa runda spośród wiadomości, które wypadły już poniżej okna.
    floor_round: u64,
    /// Rundy wiadomości aktualnie znajdujących się w 64-slotowym oknie.
    round_slots: [Option<u64>; REPLAY_WINDOW],
    replay: ReplayWindow,
}

impl Default for PeerState {
    fn default() -> Self {
        Self {
            round: 0,
            floor_round: 0,
            round_slots: [None; REPLAY_WINDOW],
            replay: ReplayWindow::default(),
        }
    }
}

impl PeerState {
    /// Weryfikuje okno `seq` oraz współmonotoniczność `(seq, round)`:
    /// `s1 < s2 => round(s1) <= round(s2)`.
    ///
    /// * Identyczna retransmisja (`seq` + `msg_id`) wewnątrz okna zwraca
    ///   [`Delivery::Duplicate`], nawet jeśli nadawca przeszedł już do
    ///   wyższej rundy.
    /// * Nowa wiadomość z `seq > highest` wymaga `round >= self.round` i
    ///   aktualizuje `self.round`.
    /// * Opóźniona nowa wiadomość z `seq < highest` wewnątrz okna musi
    ///   być spójna z sąsiadami (`min_round <= round <= max_round`) i
    ///   **nie** nadpisuje `self.round` (ochrona przed zatruciem rundy).
    fn accept(&mut self, seq: u64, round: u64, msg_id: [u8; 32]) -> Result<Delivery> {
        if seq == 0 {
            return Err(CoreError::InvalidInput);
        }
        if self.replay.highest == 0 {
            let delivery = self.replay.accept(seq, msg_id)?;
            self.round = round;
            self.round_slots[idx(seq)] = Some(round);
            return Ok(delivery);
        }

        if seq > self.replay.highest {
            if round < self.round {
                return Err(CoreError::RoundMismatch);
            }
            let gap = seq - self.replay.highest;
            if gap >= REPLAY_WINDOW as u64 {
                self.floor_round = self.round;
                self.round_slots.fill(None);
            } else {
                for s in (self.replay.highest + 1)..=seq {
                    if let Some(evicted_round) = self.round_slots[idx(s)].take() {
                        self.floor_round = self.floor_round.max(evicted_round);
                    }
                }
            }
            let delivery = self.replay.accept(seq, msg_id)?;
            self.round = round;
            self.round_slots[idx(seq)] = Some(round);
            return Ok(delivery);
        }

        // `seq <= self.replay.highest`: najpierw sprawdzamy zasięg okna i
        // ewentualny duplikat/konflikt w slocie `seq`.
        if self.replay.highest - seq >= REPLAY_WINDOW as u64 {
            return Err(CoreError::ReplayDetected);
        }
        if let Some(prev_id) = self.replay.slots[idx(seq)] {
            return if prev_id == msg_id {
                Ok(Delivery::Duplicate)
            } else {
                Err(CoreError::ReplayDetected)
            };
        }

        // Nowy, opóźniony pakiet (`seq < highest`, pusty slot w oknie):
        // wymuszamy `min_round <= round <= max_round` względem sąsiadów.
        let win_low = self
            .replay
            .highest
            .saturating_sub(REPLAY_WINDOW as u64 - 1)
            .max(1);
        let mut min_round = self.floor_round;
        for s in win_low..seq {
            if let Some(r) = self.round_slots[idx(s)] {
                min_round = min_round.max(r);
            }
        }
        let mut max_round = self.round;
        for s in (seq + 1)..=self.replay.highest {
            if let Some(r) = self.round_slots[idx(s)] {
                max_round = max_round.min(r);
            }
        }
        if round < min_round || round > max_round {
            return Err(CoreError::RoundMismatch);
        }

        let delivery = self.replay.accept(seq, msg_id)?;
        self.round_slots[idx(seq)] = Some(round);
        Ok(delivery)
    }
}

impl SessionReceiver {
    /// Nowy odbiorca; IDs i `sid` muszą być niezerowe.
    pub fn new(sid: [u8; 32], epoch: u64, me: PartyId) -> Result<Self> {
        if is_zero(&sid) || is_zero(&me) {
            return Err(CoreError::InvalidInput);
        }
        Ok(Self {
            sid,
            epoch,
            me,
            peers: BTreeMap::new(),
        })
    }

    /// Weryfikuje klucz/kopertę oraz sprzężoną monotoniczność `(seq, round)`
    /// w oknie anty-replay nadawcy.
    ///
    /// Kolejność: najpierw MAC (żeby nie ujawniać ani nie mutować stanu
    /// odbiorcy bez uwierzytelnienia), potem atomowa weryfikacja `(seq, round)`.
    pub fn accept(&mut self, key: &EnvelopeKey, env: Envelope) -> Result<(Body, Delivery)> {
        if key.sid != self.sid || key.epoch != self.epoch || key.recipient != self.me {
            return Err(CoreError::AuthFail);
        }
        let body = env.open(key)?;
        let msg_id = body.msg_id();
        let peer = self.peers.entry(body.sender).or_default();
        let delivery = peer.accept(body.seq, body.round, msg_id)?;
        Ok((body, delivery))
    }
}

fn idx(seq: u64) -> usize {
    ((seq - 1) as usize) % REPLAY_WINDOW
}

fn is_zero(bytes: &[u8]) -> bool {
    bytes.iter().all(|&b| b == 0)
}

fn ct_eq32(a: &[u8; 32], b: &[u8; 32]) -> bool {
    let mut diff = 0u8;
    for i in 0..32 {
        diff |= a[i] ^ b[i];
    }
    diff == 0
}

#[cfg(test)]
mod tests {
    use super::{
        Body, Delivery, Envelope, EnvelopeKey, MAX_PAYLOAD_BYTES, REPLAY_WINDOW, ReplayWindow,
        SessionReceiver,
    };
    use ft_threshold_core::error::CoreError;

    const SID: [u8; 32] = [0x11; 32];
    const A: [u8; 16] = [0xa1; 16];
    const B: [u8; 16] = [0xb2; 16];
    const C: [u8; 16] = [0xc3; 16];
    const EPOCH: u64 = 7;

    fn key(seed: u8, sender: [u8; 16], recipient: [u8; 16]) -> EnvelopeKey {
        EnvelopeKey::derive_psk(&[seed; 32], SID, EPOCH, sender, recipient).expect("key")
    }

    fn body(round: u64, seq: u64, msg_type: u16, payload: &[u8]) -> Body {
        Body::new(SID, EPOCH, round, seq, msg_type, A, payload.to_vec()).expect("body")
    }

    #[test]
    fn envelope_roundtrip_and_msg_id_is_recipient_independent() {
        let k1 = key(1, A, B);
        let k2 = key(1, A, C);
        let b1 = body(3, 1, 0x05, b"secret payload");
        let id1 = b1.msg_id();
        let b2 = body(3, 1, 0x05, b"secret payload");
        assert_eq!(id1, b2.msg_id());

        let e1 = Envelope::seal(&k1, b1).expect("seal 1");
        let e2 = Envelope::seal(&k2, b2).expect("seal 2");
        assert_eq!(e1.body_unverified().msg_id(), e2.body_unverified().msg_id());

        let opened1 = e1.open(&k1).expect("open 1");
        assert_eq!(opened1.payload(), b"secret payload");
        assert_eq!(opened1.round(), 3);
        assert_eq!(opened1.seq(), 1);
        assert_eq!(opened1.msg_type(), 0x05);

        let opened2 = e2.open(&k2).expect("open 2");
        assert_eq!(opened2.payload(), b"secret payload");
    }

    #[test]
    fn tampering_and_wrong_context_are_rejected() {
        // Mutacje pól po zapieczętowaniu (testy w module widzą prywatne pola).
        let k = key(2, A, B);
        let mut e = Envelope::seal(&k, body(1, 1, 1, b"x")).expect("seal");
        e.mac[0] ^= 1;
        assert_eq!(e.open(&k).unwrap_err(), CoreError::AuthFail);

        let mut e = Envelope::seal(&k, body(1, 1, 1, b"x")).expect("seal");
        e.body.round += 1;
        assert_eq!(e.open(&k).unwrap_err(), CoreError::AuthFail);

        let mut e = Envelope::seal(&k, body(1, 1, 1, b"x")).expect("seal");
        e.body.payload[0] ^= 1;
        assert_eq!(e.open(&k).unwrap_err(), CoreError::AuthFail);

        let mut e = Envelope::seal(&k, body(1, 1, 1, b"x")).expect("seal");
        e.recipient[0] ^= 1;
        assert_eq!(e.open(&k).unwrap_err(), CoreError::AuthFail);

        // Obcy klucz (inna para), inna epoka/sesja.
        let other = key(3, A, B);
        let e = Envelope::seal(&k, body(1, 1, 1, b"x")).expect("seal");
        assert_eq!(e.open(&other).unwrap_err(), CoreError::AuthFail);

        let wrong_epoch = EnvelopeKey::derive_psk(&[2; 32], SID, EPOCH + 1, A, B).expect("key");
        let e = Envelope::seal(&k, body(1, 1, 1, b"x")).expect("seal");
        assert_eq!(e.open(&wrong_epoch).unwrap_err(), CoreError::AuthFail);

        let wrong_sid = EnvelopeKey::derive_psk(&[2; 32], [0x22; 32], EPOCH, A, B).expect("key");
        let e = Envelope::seal(&k, body(1, 1, 1, b"x")).expect("seal");
        assert_eq!(e.open(&wrong_sid).unwrap_err(), CoreError::AuthFail);
    }

    #[test]
    fn replay_is_idempotent_only_for_identical_msg_id() {
        let k = key(4, A, B);
        let mut rx = SessionReceiver::new(SID, EPOCH, B).expect("receiver");

        let (_, d) = rx
            .accept(
                &k,
                Envelope::seal(&k, body(2, 10, 1, b"one")).expect("seal"),
            )
            .expect("accept");
        assert_eq!(d, Delivery::New);

        // Ta sama treść → ten sam msg_id → Duplicate (retransmisja).
        let (_, d) = rx
            .accept(
                &k,
                Envelope::seal(&k, body(2, 10, 1, b"one")).expect("seal"),
            )
            .expect("retransmit");
        assert_eq!(d, Delivery::Duplicate);

        // To samo seq, inna treść → ReplayDetected.
        let err = rx
            .accept(
                &k,
                Envelope::seal(&k, body(2, 10, 1, b"two")).expect("seal"),
            )
            .unwrap_err();
        assert_eq!(err, CoreError::ReplayDetected);
    }

    #[test]
    fn round_rollback_and_stale_window_are_rejected() {
        let k = key(5, A, B);
        let mut rx = SessionReceiver::new(SID, EPOCH, B).expect("receiver");

        rx.accept(&k, Envelope::seal(&k, body(5, 1, 1, b"a")).expect("seal"))
            .expect("round 5");
        let err = rx
            .accept(&k, Envelope::seal(&k, body(4, 2, 1, b"b")).expect("seal"))
            .unwrap_err();
        assert_eq!(err, CoreError::RoundMismatch);

        // Odrzucony pakiet z seq=2 nie mógł zająć slotu seq=2.
        let (_, d) = rx
            .accept(&k, Envelope::seal(&k, body(5, 2, 1, b"b")).expect("seal"))
            .expect("round 5 seq 2");
        assert_eq!(d, Delivery::New);

        // Skok poza okno, potem stara wiadomość.
        rx.accept(
            &k,
            Envelope::seal(&k, body(6, 1 + REPLAY_WINDOW as u64 + 100, 1, b"jump")).expect("seal"),
        )
        .expect("jump");
        let err = rx
            .accept(&k, Envelope::seal(&k, body(6, 2, 1, b"old")).expect("seal"))
            .unwrap_err();
        assert_eq!(err, CoreError::ReplayDetected);
    }

    #[test]
    fn delayed_retransmission_from_earlier_round_is_duplicate_not_round_mismatch() {
        let k = key(7, A, B);
        let mut rx = SessionReceiver::new(SID, EPOCH, B).expect("receiver");

        // Przyjmujemy wiadomość z rundy 1 (seq = 1), a następnie z rundy 2 (seq = 2).
        let (_, d1) = rx
            .accept(&k, Envelope::seal(&k, body(1, 1, 1, b"r1")).expect("seal"))
            .expect("accept r1");
        assert_eq!(d1, Delivery::New);

        let (_, d2) = rx
            .accept(&k, Envelope::seal(&k, body(2, 2, 1, b"r2")).expect("seal"))
            .expect("accept r2");
        assert_eq!(d2, Delivery::New);

        // Opóźniona retransmisja wiadomości (seq = 1, round = 1) wewnątrz okna
        // musi zwrócić Duplicate, a nie fałszywy RoundMismatch.
        let (_, d1_re) = rx
            .accept(&k, Envelope::seal(&k, body(1, 1, 1, b"r1")).expect("seal"))
            .expect("retransmit r1 after r2");
        assert_eq!(d1_re, Delivery::Duplicate);

        // Podmieniona treść na tym samym (seq = 1, round = 1) to nadal ReplayDetected.
        let err = rx
            .accept(
                &k,
                Envelope::seal(&k, body(1, 1, 1, b"r1-forged")).expect("seal"),
            )
            .unwrap_err();
        assert_eq!(err, CoreError::ReplayDetected);
    }

    #[test]
    fn out_of_order_inflated_round_cannot_deadlock_session() {
        let k = key(8, A, B);
        let mut rx = SessionReceiver::new(SID, EPOCH, B).expect("receiver");

        // Wiadomość (seq = 2, round = 1) dociera przed seq = 1.
        let (_, d) = rx
            .accept(
                &k,
                Envelope::seal(&k, body(1, 2, 1, b"seq2-r1")).expect("seal"),
            )
            .expect("accept seq 2");
        assert_eq!(d, Delivery::New);

        // Złośliwy pakiet out-of-order (seq = 1, round = 99) próbuje podbić
        // peer.round i zablokować rundę 1 — musi zostać odrzucony jako RoundMismatch.
        let err = rx
            .accept(
                &k,
                Envelope::seal(&k, body(99, 1, 1, b"poison")).expect("seal"),
            )
            .unwrap_err();
        assert_eq!(err, CoreError::RoundMismatch);

        // Uczciwy opóźniony pakiet (seq = 1, round = 1) nadal przechodzi jako New,
        // a kolejna wiadomość (seq = 3, round = 1) nie jest zablokowana.
        let (_, d_seq1) = rx
            .accept(
                &k,
                Envelope::seal(&k, body(1, 1, 1, b"seq1-r1")).expect("seal"),
            )
            .expect("accept honest seq 1");
        assert_eq!(d_seq1, Delivery::New);

        let (_, d_seq3) = rx
            .accept(
                &k,
                Envelope::seal(&k, body(1, 3, 1, b"seq3-r1")).expect("seal"),
            )
            .expect("accept honest seq 3");
        assert_eq!(d_seq3, Delivery::New);
    }

    #[test]
    fn out_of_order_middle_slot_respects_neighbor_rounds() {
        let k = key(9, A, B);
        let mut rx = SessionReceiver::new(SID, EPOCH, B).expect("receiver");

        // Przyjmujemy (seq = 1, round = 2) oraz (seq = 3, round = 4).
        rx.accept(&k, Envelope::seal(&k, body(2, 1, 1, b"s1")).expect("seal"))
            .expect("seq 1 round 2");
        rx.accept(&k, Envelope::seal(&k, body(4, 3, 1, b"s3")).expect("seal"))
            .expect("seq 3 round 4");

        // Dla seq = 2 dozwolony przedział rund to [2, 4]. Runda 1 i runda 5 są odrzucane.
        assert_eq!(
            rx.accept(
                &k,
                Envelope::seal(&k, body(1, 2, 1, b"bad-low")).expect("seal")
            )
            .unwrap_err(),
            CoreError::RoundMismatch
        );
        assert_eq!(
            rx.accept(
                &k,
                Envelope::seal(&k, body(5, 2, 1, b"bad-high")).expect("seal")
            )
            .unwrap_err(),
            CoreError::RoundMismatch
        );

        // Runda 3 dla seq = 2 spełnia 2 <= 3 <= 4 i zostaje przyjęta.
        let (_, d) = rx
            .accept(&k, Envelope::seal(&k, body(3, 2, 1, b"ok")).expect("seal"))
            .expect("seq 2 round 3");
        assert_eq!(d, Delivery::New);
    }

    #[test]
    fn out_of_order_within_window_is_new_then_duplicate() {
        let mut w = ReplayWindow::default();
        assert_eq!(w.accept(10, [1; 32]).expect("10"), Delivery::New);
        assert_eq!(w.accept(8, [2; 32]).expect("8"), Delivery::New);
        assert_eq!(w.accept(8, [2; 32]).expect("8 again"), Delivery::Duplicate);
        assert_eq!(w.accept(8, [3; 32]).unwrap_err(), CoreError::ReplayDetected);
        assert_eq!(w.accept(0, [4; 32]).unwrap_err(), CoreError::InvalidInput);
    }

    #[test]
    fn body_limits_and_ids_are_enforced() {
        assert_eq!(
            Body::new(SID, EPOCH, 1, 1, 1, [0u8; 16], vec![]).unwrap_err(),
            CoreError::InvalidInput
        );
        assert_eq!(
            Body::new([0u8; 32], EPOCH, 1, 1, 1, A, vec![]).unwrap_err(),
            CoreError::InvalidInput
        );
        assert_eq!(
            Body::new(SID, EPOCH, 1, 1, 0, A, vec![]).unwrap_err(),
            CoreError::InvalidInput
        );
        assert_eq!(
            Body::new(SID, EPOCH, 1, 1, 1, A, vec![0u8; MAX_PAYLOAD_BYTES + 1]).unwrap_err(),
            CoreError::InvalidLength
        );
        assert!(Body::new(SID, EPOCH, 1, 1, 1, A, vec![0u8; MAX_PAYLOAD_BYTES]).is_ok());

        assert!(EnvelopeKey::derive_psk(&[0u8; 32], SID, EPOCH, A, A).is_err());
        assert!(EnvelopeKey::derive_psk(&[0u8; 32], SID, EPOCH, [0u8; 16], B).is_err());
        assert!(SessionReceiver::new(SID, EPOCH, [0u8; 16]).is_err());
    }

    #[test]
    fn debug_does_not_reveal_key_or_payload() {
        let k = key(6, A, B);
        let text = format!("{k:?}");
        assert!(text.contains("EnvelopeKey"));
        assert!(!text.contains("key"));

        let b = body(1, 1, 1, b"top-secret-payload");
        let text = format!("{b:?}");
        assert!(text.contains("Body"));
        assert!(!text.contains("top-secret-payload"));
    }
}
