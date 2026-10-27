//! WP-022 — fuzz dekodera wire v1 (BODY + ENVELOPE) z własnością fixpoint.
//!
//! Dwa poziomy:
//!
//! 1. **Korpus w repo** (`impl/fuzz/corpus/wire/`) wygenerowany przez
//!    niezależną referencję Python (`ci/fuzz/gen_corpus.py`):
//!    `ok_*` muszą się dekodować i re-kodować bajt w bajt,
//!    `bad_*` muszą być odrzucone, `mut_*` — cokolwiek poza paniką
//!    (a przy `Ok` fixpoint musi zachodzić).
//! 2. **Pętla mutacyjna** (deterministyczny xorshift64, brak fs):
//!    100 000 mutacji poprawnej koperty; niezmiennik kanoniczności:
//!    `TryFrom(bytes) == Ok` ⇒ `to_bytes() == bytes`. To jest realna
//!    własność zamrożonego formatu v1 — dekoder nie może „naprawiać”.
//!
//! Ciężkie pętle są ignorowane pod miri (izolacja miri nie ma fs, a
//! pętle pokrywa natywny `cargo test`; patrz `ci/check.sh`).
//!
//! **Granica:** `decode_sk` nie istnieje w Rust (format klucza jest
//! własnością silnika C, KAT WP-024) — ten cel wyląduje z portem
//! sign/verify (WP-040/041).

use ft_threshold_protocol::envelope::{Body, Envelope, EnvelopeKey, PartyId};

const CORPUS_DIR: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/../../fuzz/corpus/wire");
const CORPUS_FILES: usize = 44;
const MUTATION_ROUNDS: usize = 100_000;
const SEED: u64 = 0x5DEECE66D;

const SID: [u8; 32] = [0x31; 32];
const A: PartyId = [0xa1; 16];
const B: PartyId = [0xb2; 16];
const EPOCH: u64 = 3;

/// Ten sam schemat mutacji co `ci/fuzz/gen_corpus.py` (bit-flip, obcięcie,
/// wstawka, nadpisanie), niezależnie zaimplementowany w Rust.
struct Rng(u64);

impl Rng {
    fn new(seed: u64) -> Self {
        Self(seed | 1)
    }

    fn next(&mut self) -> u64 {
        let mut x = self.0;
        x ^= x << 13;
        x ^= x >> 7;
        x ^= x << 17;
        self.0 = x;
        x
    }

    fn below(&mut self, n: usize) -> usize {
        (self.next() % n as u64) as usize
    }
}

fn mutate(rng: &mut Rng, data: &[u8], idx: usize) -> Vec<u8> {
    let mut out = data.to_vec();
    match idx % 4 {
        0 if !out.is_empty() => {
            let pos = rng.below(out.len());
            out[pos] ^= 1 << (rng.below(8) as u8);
        }
        1 if out.len() > 2 => {
            let cut = 1 + rng.below(out.len() - 1);
            out.truncate(cut);
        }
        2 => {
            let pos = rng.below(out.len() + 1);
            let extra = 1 + rng.below(16);
            let mut ins = Vec::with_capacity(extra);
            for _ in 0..extra {
                ins.push((rng.below(256)) as u8);
            }
            let tail = out.split_off(pos);
            out.extend_from_slice(&ins);
            out.extend_from_slice(&tail);
        }
        _ => {
            if out.is_empty() {
                return out;
            }
            let pos = rng.below(out.len());
            let n = 1 + rng.below(16);
            for i in 0..n {
                if let Some(b) = out.get_mut(pos + i) {
                    *b = rng.below(256) as u8;
                }
            }
        }
    }
    out
}

fn valid_envelope_bytes() -> Vec<u8> {
    let key = EnvelopeKey::derive_psk(&[0x77; 32], SID, EPOCH, A, B).expect("key");
    let body = Body::new(SID, EPOCH, 2, 1, 0x05, A, b"fuzz-base-payload".to_vec()).expect("body");
    Envelope::seal(&key, body).expect("seal").to_bytes()
}

#[test]
#[cfg_attr(
    miri,
    ignore = "izolacja miri nie ma fs; korpus pokrywa natywny cargo test"
)]
fn corpus_files_behave_as_pinned() {
    let dir =
        std::fs::read_dir(CORPUS_DIR).unwrap_or_else(|e| panic!("brak korpusu {CORPUS_DIR}: {e}"));
    let mut entries: Vec<(String, Vec<u8>)> = dir
        .filter_map(|e| e.ok())
        .filter(|e| e.file_name().to_string_lossy().ends_with(".bin"))
        .map(|e| {
            let bytes = std::fs::read(e.path()).expect("read corpus");
            (e.file_name().to_string_lossy().into_owned(), bytes)
        })
        .collect();
    entries.sort_by(|a, b| a.0.cmp(&b.0));
    assert_eq!(
        entries.len(),
        CORPUS_FILES,
        "korpus ma nieoczekiwaną liczbę plików"
    );

    let (mut ok, mut bad, mut mutated) = (0, 0, 0);
    for (name, bytes) in &entries {
        if name.starts_with("ok_") {
            ok += 1;
            if name == "ok_envelope.bin" {
                let env = Envelope::try_from(&bytes[..]).expect("ok_envelope musi się dekodować");
                assert_eq!(env.to_bytes(), bytes[..], "fixpoint ok_envelope");
            } else {
                let body = Body::try_from(&bytes[..]).expect("ok_body musi się dekodować");
                assert_eq!(body.to_cbor(), bytes[..], "fixpoint ok_body");
            }
        } else if name.starts_with("bad_") {
            bad += 1;
            assert!(
                Envelope::try_from(&bytes[..]).is_err() && Body::try_from(&bytes[..]).is_err(),
                "{name}: bad_* muszą być odrzucone przez oba dekodery"
            );
        } else if name.starts_with("mut_") {
            mutated += 1;
            // Cokolwiek poza paniką; przy Ok — fixpoint.
            if let Ok(env) = Envelope::try_from(&bytes[..]) {
                assert_eq!(env.to_bytes(), bytes[..], "fixpoint mut_{}", name);
            }
        } else {
            panic!("nieznana klasa pliku korpusu: {name}");
        }
    }
    assert_eq!((ok, bad, mutated), (2, 10, 32), "skład korpusu");
}

#[test]
#[cfg_attr(miri, ignore = "pętle pokrywa natywny cargo test; miri za wolne")]
fn mutation_loop_never_panics_and_accepts_only_canonical() {
    let base = valid_envelope_bytes();
    // Bazowa koperta jest poprawna — to punkt startowy fixpointu.
    let base_env = Envelope::try_from(&base[..]).expect("bazowa koperta");
    assert_eq!(base_env.to_bytes(), base[..]);

    let mut rng = Rng::new(SEED);
    let mut accepted_envelope = 0usize;
    for i in 0..MUTATION_ROUNDS {
        let bytes = mutate(&mut rng, &base, i);
        if let Ok(env) = Envelope::try_from(&bytes[..]) {
            assert_eq!(env.to_bytes(), bytes[..], "fixpoint koperty w iteracji {i}");
            accepted_envelope += 1;
        }
        // Body: niezmiennik braku paniki (fixpoint body sprawdza
        // corpus ok_body.bin; z mutacji koperty ciało nie powstaje).
        let _ = Body::try_from(&bytes[..]);
    }
    // Sanity pętli: obie ścieżki muszą się zdarzyć (akceptacja fixpointu
    // i odrzucenie). Dekoder koperty słusznie akceptuje mutacje MAC/payload
    // (MAC weryfikuje dopiero `open`), więc tu nie ma górnego progu.
    assert!(
        accepted_envelope > 0,
        "żadna mutacja nie została zaakceptowana — pętla niczego nie testuje"
    );
    assert!(
        accepted_envelope < MUTATION_ROUNDS,
        "dekoder niczego nie odrzuca?"
    );
}

#[test]
#[cfg_attr(miri, ignore = "pętle pokrywa natywny cargo test; miri za wolne")]
fn decoder_rejects_known_structural_abuses() {
    // Zagnieżdżenie ponad MAX_DEPTH: body z kluczem 1 jako mapa w mapie…
    // (budujemy ręcznie: map(1){1: map(1){1: …}} — cbor reader ma limit 8).
    let mut deep = Vec::new();
    for depth in (0..12).rev() {
        let mut w = ft_threshold_protocol::cbor::CborWriter::new();
        w.put_map(1);
        w.put_uint(1);
        deep = if depth == 11 {
            w.put_bstr(&[0xaa; 8]);
            w.into_bytes()
        } else {
            w.put_raw(&deep);
            w.into_bytes()
        };
    }
    assert!(
        Body::try_from(&deep[..]).is_err(),
        "zbyt głębokie zagnieżdżenie"
    );
    assert!(
        Envelope::try_from(&deep[..]).is_err(),
        "zbyt głębokie zagnieżdżenie w kopercie"
    );

    // Pusta mapa jako body (klucze wymagane: 1..=8).
    let mut w = ft_threshold_protocol::cbor::CborWriter::new();
    w.put_map(0);
    assert!(Body::try_from(&w.into_bytes()[..]).is_err());

    // Mapa z 8 parami, ale klucze 2..=9 (start od 2, koniec 9).
    let mut w = ft_threshold_protocol::cbor::CborWriter::new();
    w.put_map(8);
    for k in 2u64..=9 {
        w.put_uint(k);
        w.put_uint(0);
    }
    assert!(Body::try_from(&w.into_bytes()[..]).is_err());
}
