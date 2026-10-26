//! WP-027 — testy wektorów wire v1 (kanoniczny CBOR, SPEC §9.2/§9.3).
//!
//! Wektor pochodzi z **niezależnej referencji Python**
//! (`impl/ci/wire/cbor_reference.py`), która implementuje kanoniczny
//! CBOR od zera; bitowa odtwarzalność pilnuje
//! `impl/ci/wire/run_wire_vectors.sh`. Ten test sprawdza, że Rust
//! koduje/dekoduje **identycznie** i że warianty non-canonical są
//! odrzucane, nie „naprawiane”.

use ft_threshold_protocol::envelope::{Body, Envelope, EnvelopeKey, MAX_PAYLOAD_BYTES, PartyId};

const VEC: &str = include_str!("../../../wire/vectors/envelope_v1.txt");

fn fields(text: &str) -> Vec<(String, String)> {
    text.lines()
        .filter(|l| !l.starts_with('#'))
        .filter_map(|l| l.split_once(" = "))
        .map(|(k, v)| (k.trim().to_string(), v.trim().to_string()))
        .collect()
}

fn get<'a>(fs: &'a [(String, String)], key: &str) -> Option<&'a str> {
    fs.iter().find(|(k, _)| k == key).map(|(_, v)| v.as_str())
}

fn hex32(s: &str, want: usize) -> [u8; 32] {
    let b = unhex(s);
    assert_eq!(b.len(), want, "nieoczekiwana długość pola");
    let mut out = [0u8; 32];
    out.copy_from_slice(&b);
    out
}

fn id16(s: &str) -> PartyId {
    let b = unhex(s);
    assert_eq!(b.len(), 16, "nieoczekiwana długość pola");
    let mut out = [0u8; 16];
    out.copy_from_slice(&b);
    out
}

fn unhex(s: &str) -> Vec<u8> {
    assert!(s.len().is_multiple_of(2), "nieparzysta długość hex");
    (0..s.len() / 2)
        .map(|i| u8::from_str_radix(&s[2 * i..2 * i + 2], 16).expect("hex"))
        .collect()
}

fn vector_body(fs: &[(String, String)]) -> Body {
    let sid = hex32(get(fs, "sid").expect("sid"), 32);
    let epoch: u64 = get(fs, "epoch").expect("epoch").parse().expect("epoch");
    let round: u64 = get(fs, "round").expect("round").parse().expect("round");
    let seq: u64 = get(fs, "seq").expect("seq").parse().expect("seq");
    let msg_type: u16 = get(fs, "msg_type")
        .expect("msg_type")
        .parse()
        .expect("msg_type");
    let sender = id16(get(fs, "sender").expect("sender"));
    let payload = unhex(get(fs, "payload").expect("payload"));
    Body::new(sid, epoch, round, seq, msg_type, sender, payload).expect("body")
}

fn vector_key(fs: &[(String, String)]) -> EnvelopeKey {
    let psk = hex32(get(fs, "psk").expect("psk"), 32);
    let sid = hex32(get(fs, "sid").expect("sid"), 32);
    let epoch: u64 = get(fs, "epoch").expect("epoch").parse().expect("epoch");
    let sender = id16(get(fs, "sender").expect("sender"));
    let recipient = id16(get(fs, "recipient").expect("recipient"));
    EnvelopeKey::derive_psk(&psk, sid, epoch, sender, recipient).expect("key")
}

#[test]
fn body_encoding_matches_independent_reference() {
    let fs = fields(VEC);
    let body_cbor = unhex(get(&fs, "body_cbor").expect("body_cbor"));

    // Kodowanie Rust == referencja Python, bajt w bajt.
    let body = vector_body(&fs);
    assert_eq!(body.to_cbor(), body_cbor, "kodowanie ≠ referencja");

    // Dekoder przyjmuje dokładnie te bajty i odtwarza pola.
    let decoded = Body::try_from(&body_cbor[..]).expect("decode");
    assert_eq!(decoded.sid(), body.sid());
    assert_eq!(decoded.epoch(), body.epoch());
    assert_eq!(decoded.round(), body.round());
    assert_eq!(decoded.seq(), body.seq());
    assert_eq!(decoded.msg_type(), body.msg_type());
    assert_eq!(decoded.sender(), body.sender());
    assert_eq!(decoded.payload(), body.payload());

    // Punkt stały: dekodowanie → kodowanie daje te same bajty.
    assert_eq!(decoded.to_cbor(), body_cbor);

    // msg_id wg niezależnej referencji.
    let msg_id = hex32(get(&fs, "msg_id").expect("msg_id"), 32);
    assert_eq!(decoded.msg_id(), msg_id, "msg_id ≠ referencja");
}

#[test]
fn envelope_seal_matches_independent_reference() {
    let fs = fields(VEC);
    let envelope_cbor = unhex(get(&fs, "envelope_cbor").expect("envelope_cbor"));
    let body = vector_body(&fs);
    let key = vector_key(&fs);

    let msg_id_expected = body.msg_id();
    let payload_expected = body.payload().to_vec();
    let env = Envelope::seal(&key, body).expect("seal");
    assert_eq!(
        env.to_bytes(),
        envelope_cbor,
        "seal ≠ referencja (mac albo kształt mapy)"
    );

    // Dekodowanie ścisłe + otwarcie zwraca oryginalne body.
    let parsed = Envelope::try_from(&envelope_cbor[..]).expect("envelope decode");
    let opened = parsed.open(&key).expect("open");
    assert_eq!(opened.msg_id(), msg_id_expected);
    assert_eq!(opened.payload(), &payload_expected);
}

#[test]
fn non_canonical_variants_from_reference_are_rejected() {
    let fs = fields(VEC);
    let bads = [
        "bad_version_nonshort",
        "bad_epoch_nonshort",
        "bad_indefinite_map",
        "bad_keys_unsorted",
        "bad_dup_key5",
        "bad_extra_key9",
        "bad_trailing_byte",
        "bad_tag_on_sid",
        "bad_text_sender",
        "bad_missing_key8",
    ];
    assert_eq!(bads.len(), 10, "pełny zestaw wariantów non-canonical");
    for name in bads {
        let bytes = unhex(get(&fs, name).unwrap_or_else(|| panic!("brak {name} w wektorze")));
        let err = Body::try_from(&bytes[..])
            .err()
            .unwrap_or_else(|| panic!("{name}: dekoder przyjął non-canonical"));
        assert_eq!(
            err,
            ft_threshold_core::error::CoreError::NonCanonicalCbor,
            "{name}: zły kod błędu"
        );
    }
}

#[test]
fn envelope_decode_rejects_structural_garbage() {
    let fs = fields(VEC);
    let envelope_cbor = unhex(get(&fs, "envelope_cbor").expect("envelope_cbor"));

    // Obcięte bajty.
    assert!(Envelope::try_from(&envelope_cbor[..envelope_cbor.len() - 1]).is_err());
    // Śmieci po mapie.
    let mut trailing = envelope_cbor.clone();
    trailing.push(0x00);
    assert!(Envelope::try_from(&trailing[..]).is_err());
    // Puste wejście.
    assert!(Envelope::try_from(&[][..]).is_err());
    // Zły MAC (32→31 B niemożliwe bez przebudowy; wystarczy flipp):
    let mut tampered = envelope_cbor.clone();
    let last = tampered.len() - 1;
    tampered[last] ^= 0xFF;
    let key = vector_key(&fs);
    if let Ok(env) = Envelope::try_from(&tampered[..]) {
        assert_eq!(
            env.open(&key).err(),
            Some(ft_threshold_core::error::CoreError::AuthFail)
        );
    }
    // Limit payloadu: payload 1 MiB + 1 B → odrzucone przy budowie.
    let over = vec![0u8; MAX_PAYLOAD_BYTES + 1];
    let sid = hex32(get(&fs, "sid").expect("sid"), 32);
    let sender = id16(get(&fs, "sender").expect("sender"));
    assert!(Body::new(sid, 1, 1, 1, 1, sender, over).is_err());
}
