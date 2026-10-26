//! WP-024 — testy pinów KAT wygenerowanych z rzeczywistego silnika
//! FT1536 (`impl/KAT/falcon_ternary_logn10_v1.txt`, profil ternary,
//! `logn = 10`, `q = 18433`).
//!
//! Wektory pochodzą z `impl/ci/kat/gen_falcon_kat.c` (publiczne API
//! silnika, deterministyczne syntetyczne seedy, zewnętrzny nonce); ich
//! bitowa odtwarzalność pilnuje `impl/ci/kat/run_falcon_kat.sh`. Ten test
//! sprawdza, co dziś liczy Rust:
//!
//! 1. integralność pliku KAT względem `MANIFEST.txt` (SHAKE256),
//! 2. punkt `c0` z transkryptu weryfikatora (nonce ‖ msg → `hash_to_point`)
//!    współczynnik po współczynniku,
//! 3. digesty i nagłówki pól (`pkey`, `sig`), długości i `engine_vrfy`.
//!
//! Piny `pkey`/`sig` są zakotwiczeniem dla WP-027 (wire/CBOR) i portu
//! sign/verify; sam test jeszcze nie dekoduje formatów silnika.

use ft_threshold_core::shake;

const KAT: &str = include_str!("../../../KAT/falcon_ternary_logn10_v1.txt");
const MANIFEST: &str = include_str!("../../../KAT/MANIFEST.txt");

/// Pierwszy bajt pk: ternary(0x80) | rezerwa 0 | logn 10.
const PKEY_HEADER: u8 = 0x80 | 10;
/// Pierwszy bajt podpisu: ternary | comp=static(1) | rezerwa 0 | logn 10.
const SIG_HEADER: u8 = 0x80 | (1 << 5) | 10;

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

fn unhex(s: &str) -> Vec<u8> {
    let b = s.as_bytes();
    assert!(b.len().is_multiple_of(2), "nieparzysta długość hex");
    (0..b.len() / 2)
        .map(|i| u8::from_str_radix(&s[2 * i..2 * i + 2], 16).expect("hex"))
        .collect()
}

fn shake256(data: &[u8]) -> [u8; 32] {
    let mut out = [0u8; 32];
    shake::shake256(data, &mut out);
    out
}

#[test]
fn kat_file_matches_manifest_digest() {
    let mf = fields(MANIFEST);
    assert_eq!(
        get(&mf, "file"),
        Some("falcon_ternary_logn10_v1.txt"),
        "manifest wskazuje inny plik"
    );
    let pin = get(&mf, "shake256").expect("shake256 w manifeście");
    let got = shake256(KAT.as_bytes());
    assert_eq!(hex(&got), pin, "plik KAT niezgodny z pinem manifestu");
}

#[test]
fn kat_c0_is_reproduced_by_hash_to_point() {
    let fs = fields(KAT);
    let nonce = unhex(get(&fs, "nonce").expect("nonce"));
    let msg = unhex(get(&fs, "msg").expect("msg"));
    let c0_bytes = unhex(get(&fs, "c0").expect("c0"));
    assert_eq!(c0_bytes.len(), 2 * 1536, "c0: 1536 × u16 LE");
    let p = shake::hash_to_point(&nonce, &msg).expect("hash_to_point");
    for (i, chunk) in c0_bytes.chunks_exact(2).enumerate() {
        let expected = u16::from_le_bytes([chunk[0], chunk[1]]);
        assert_eq!(p.coeff(i), Some(expected), "c0[{i}] rozjazd z silnikiem");
    }
}

#[test]
fn kat_field_digests_lengths_and_headers_match() {
    let fs = fields(KAT);

    let pkey = unhex(get(&fs, "pkey").expect("pkey"));
    assert_eq!(
        get(&fs, "pkey_len").and_then(|v| v.parse::<usize>().ok()),
        Some(pkey.len()),
        "pkey_len niezgodne z zawartością"
    );
    assert_eq!(pkey[0], PKEY_HEADER, "nagłówek pk (ternary, logn=10)");
    assert_eq!(
        hex(&shake256(&pkey)),
        get(&fs, "pkey_shake256").expect("pkey_shake256"),
    );

    let sig = unhex(get(&fs, "sig").expect("sig"));
    assert_eq!(
        get(&fs, "sig_len").and_then(|v| v.parse::<usize>().ok()),
        Some(sig.len()),
        "sig_len niezgodne z zawartością"
    );
    assert_eq!(sig[0], SIG_HEADER, "nagłówek podpisu (ternary, static)");
    assert_eq!(
        hex(&shake256(&sig)),
        get(&fs, "sig_shake256").expect("sig_shake256"),
    );

    // Klucz prywatny NIE jest zapisywany — tylko jego SHAKE256.
    let skey_digest = get(&fs, "skey_shake256").expect("skey_shake256");
    assert_eq!(skey_digest.len(), 64, "skey_shake256: 32 B jako hex");
    assert!(
        !KAT.contains("skey = "),
        "plik KAT nie może zawierać bajtów klucza prywatnego"
    );

    assert_eq!(get(&fs, "engine_vrfy"), Some("PASS"), "silnik zweryfikował");
    assert_eq!(unhex(skey_digest).len(), 32);
}

fn hex(bytes: &[u8]) -> String {
    bytes.iter().map(|b| format!("{b:02x}")).collect()
}
