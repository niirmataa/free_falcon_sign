//! Spike 008 — test izolacji procesów (F-13).
//! Wymaga zbudowanego bin `iso`; uruchamia `iso demo` w katalogu tymczasowym.
//!
//! Testy izolacji są serializowane (mutex): równoległe `iso` demo wywołują
//! flake na mailboxach (retained F-14).

use std::process::Command;

fn iso_tmp() -> std::path::PathBuf {
    // J1: workdiry pod W, nie systemowe /tmp (F-21 StorageFull)
    let mut d = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    d.push("iso-tmp");
    std::fs::create_dir_all(&d).ok();
    d
}
use std::sync::Mutex;

static ISO_LOCK: Mutex<()> = Mutex::new(());

fn iso_lock() -> std::sync::MutexGuard<'static, ()> {
    ISO_LOCK.lock().unwrap_or_else(|e| e.into_inner())
}

#[test]
fn s8_process_isolation_demo() {
    let _g = iso_lock();
    let outdir = iso_tmp().join(format!("iso-test-{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&outdir);

    // uruchom bin iso z target/debug lub przez cargo
    let status = Command::new(env!("CARGO_BIN_EXE_iso"))
        .args(["demo", outdir.to_str().unwrap()])
        .output()
        .expect("run iso demo");

    assert!(
        status.status.success(),
        "iso demo must succeed: {}",
        String::from_utf8_lossy(&status.stderr)
    );
    let stdout = String::from_utf8_lossy(&status.stdout);
    assert!(stdout.contains("ISO_DEMO_OK"));
    assert!(stdout.contains("DEALER_DONE"));
    assert!(stdout.contains("PARTY_READY x=1"));
    assert!(stdout.contains("PARTY_READY x=2"));
    assert!(stdout.contains("PARTY_READY x=3"));

    // seed nie jest zapisywany
    assert!(!outdir.join("seed.bin").exists());
    // kolumny osobne
    let c0 = std::fs::read(outdir.join("col0.bin")).unwrap();
    let c1 = std::fs::read(outdir.join("col1.bin")).unwrap();
    assert_ne!(c0, c1);

    let log1 = std::fs::read_to_string(outdir.join("party1.log")).unwrap();
    assert!(log1.starts_with("x=1"));
}

/// Spike 009 — pełne G_frag (64 muls) między procesami, mailbox plikowy.
#[test]
fn s9_g_frag_across_processes() {
    let _g = iso_lock();
    let outdir = iso_tmp().join(format!("iso-full-{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&outdir);

    let out = std::process::Command::new(env!("CARGO_BIN_EXE_iso"))
        .args(["full", outdir.to_str().unwrap()])
        .output()
        .expect("run iso full");

    assert!(
        out.status.success(),
        "iso full must succeed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    let stdout = String::from_utf8_lossy(&out.stdout);
    assert!(stdout.contains("FULL_OK"));
    assert!(stdout.contains("WORKER_DONE p=0"));
    assert!(stdout.contains("WORKER_DONE p=1"));
    assert!(stdout.contains("WORKER_DONE p=2"));

    // każda party zapisała 64 B udziałów G_frag; kolumny różne
    let out0 = std::fs::read(outdir.join("out0.bin")).unwrap();
    let out1 = std::fs::read(outdir.join("out1.bin")).unwrap();
    let out2 = std::fs::read(outdir.join("out2.bin")).unwrap();
    assert_eq!(out0.len(), 64);
    assert_ne!(out0, out1);
    assert_ne!(out1, out2);

    // mailbox: publiczne d,e na 64 rundy — bez kolumn
    let pub0 = std::fs::read(outdir.join("mailbox/r0_pub.bin")).unwrap();
    assert_eq!(pub0.len(), 2);

    // seed nie jest na dysku
    assert!(!outdir.join("seed.bin").exists());
}

/// Spike 010 — DKG seeda: żaden proces dealera nie zna sekretu.
#[test]
fn s10_dkg_seed_no_dealer_secret() {
    let _g = iso_lock();
    let outdir = iso_tmp().join(format!("iso-dkg-{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&outdir);

    let out = std::process::Command::new(env!("CARGO_BIN_EXE_iso"))
        .args(["dkg", outdir.to_str().unwrap()])
        .output()
        .expect("run iso dkg");

    assert!(
        out.status.success(),
        "iso dkg must succeed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    let stdout = String::from_utf8_lossy(&out.stdout);
    assert!(stdout.contains("DKG_OK"));
    assert!(stdout.contains("DKG_PARTY_DONE p=0"));

    // brak seed.bin — sekret nie był zapisywany jako całość
    assert!(!outdir.join("seed.bin").exists());
    // kolumny wynikowe różne
    let out0 = std::fs::read(outdir.join("out0.bin")).unwrap();
    let out1 = std::fs::read(outdir.join("out1.bin")).unwrap();
    assert_eq!(out0.len(), 64);
    assert_ne!(out0, out1);
}

/// Spike 011 — trójki: DKG a,b + sacrifice mul + check c=a*b.
#[test]
fn s11_triples_sacrifice() {
    let _g = iso_lock();
    let outdir = iso_tmp().join(format!("iso-triples-{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&outdir);

    let out = std::process::Command::new(env!("CARGO_BIN_EXE_iso"))
        .args(["triples", outdir.to_str().unwrap()])
        .output()
        .expect("run iso triples");
    assert!(
        out.status.success(),
        "iso triples must succeed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    let stdout = String::from_utf8_lossy(&out.stdout);
    assert!(stdout.contains("TRIPLES_OK"));
    assert!(stdout.contains("SACRIFICE_MUL_DONE"));
    assert!(!outdir.join("seed.bin").exists());
}

/// Spike 013 — pełne trójki bez sacrifice-mul (Lagrange re-deal).
#[test]
fn s13_full_triples_no_sacrifice() {
    let _g = iso_lock();
    let outdir = iso_tmp().join(format!("iso-ft-{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&outdir);
    let out = std::process::Command::new(env!("CARGO_BIN_EXE_iso"))
        .args(["full-triples", outdir.to_str().unwrap()])
        .output()
        .expect("run iso full-triples");
    assert!(
        out.status.success(),
        "{}",
        String::from_utf8_lossy(&out.stderr)
    );
    let stdout = String::from_utf8_lossy(&out.stdout);
    assert!(stdout.contains("FULL_TRIPLES_OK"));
    assert!(!outdir.join("seed.bin").exists());
}

/// TT-33 — fałszywa kolumna wykryta w torze wieloprocesowym.
#[test]
fn s33_forged_col_detected() {
    let _g = iso_lock();
    let outdir = iso_tmp().join(format!("iso-forge-{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&outdir);
    let out = std::process::Command::new(env!("CARGO_BIN_EXE_iso"))
        .args(["dkg", outdir.to_str().unwrap()])
        .output()
        .expect("dkg");
    assert!(out.status.success());
    // fałsz kolumny strony 2
    let mut c2 = std::fs::read(outdir.join("col2.bin")).unwrap();
    c2[5] ^= 0x5A;
    std::fs::write(outdir.join("col2.bin"), &c2).unwrap();
    let v = std::process::Command::new(env!("CARGO_BIN_EXE_iso"))
        .args(["verify-cols", outdir.to_str().unwrap()])
        .output()
        .expect("verify-cols");
    assert_eq!(v.status.code(), Some(3), "must detect inconsistency");
}

/// TT-31 — audyt: party1 nie czyta col0 ani deal0_*.
#[test]
fn s31_audit_no_foreign_reads() {
    let _g = iso_lock();
    let outdir = iso_tmp().join(format!("iso-audit-{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&outdir);
    let out = std::process::Command::new(env!("CARGO_BIN_EXE_iso"))
        .args(["dkg", outdir.to_str().unwrap()])
        .output()
        .expect("dkg");
    assert!(out.status.success());
    let a1 = std::fs::read_to_string(outdir.join("audit1.log")).unwrap_or_default();
    assert!(!a1.contains("col0.bin"), "party1 must not read col0: {a1}");
    // udziały dla strony 0 (x=1) — party1 nie ma ich czytać
    assert!(!a1.contains("deal0_1.bin"), "party1 must not read deal0_1: {a1}");
    assert!(!a1.contains("deal1_1.bin"), "party1 must not read deal1_1: {a1}");
    // własny adres: x=2 → deal*_2.bin
    assert!(a1.contains("deal0_2.bin"), "party1 should read deal0_2: {a1}");
}

/// TT-32 — 3-z-5 DKG + G_frag == oracle.
#[test]
fn s32_dkg5_3of5() {
    let _g = iso_lock();
    let outdir = iso_tmp().join(format!("iso-dkg5-{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&outdir);
    let out = std::process::Command::new(env!("CARGO_BIN_EXE_iso"))
        .args(["dkg5", outdir.to_str().unwrap()])
        .output()
        .expect("dkg5");
    assert!(out.status.success(), "{}", String::from_utf8_lossy(&out.stderr));
    assert!(String::from_utf8_lossy(&out.stdout).contains("DKG5_OK"));
    assert!(!outdir.join("seed.bin").exists());
}

/// Audyt dkg5: party1 nie czyta col0 / deal0_1.
#[test]
fn s31b_audit_dkg5() {
    let _g = iso_lock();
    let outdir = iso_tmp().join(format!("iso-a5-{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&outdir);
    let out = std::process::Command::new(env!("CARGO_BIN_EXE_iso"))
        .args(["dkg5", outdir.to_str().unwrap()])
        .output()
        .expect("dkg5");
    assert!(out.status.success());
    let a1 = std::fs::read_to_string(outdir.join("audit1.log")).unwrap_or_default();
    assert!(!a1.contains("col0.bin"));
    assert!(!a1.contains("deal0_1.bin"));
}

/// R2 — MAC open multi-process: honest open + forged exit 3.
#[test]
fn r2_mac_demo_iso() {
    let _g = iso_lock();
    let outdir = iso_tmp().join(format!("iso-mac-{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&outdir);
    let out = std::process::Command::new(env!("CARGO_BIN_EXE_iso"))
        .args(["mac-demo", outdir.to_str().unwrap()])
        .output()
        .expect("mac-demo");
    let stdout = String::from_utf8_lossy(&out.stdout);
    assert!(out.status.success(), "{}", stdout);
    assert!(stdout.contains("MAC_OK"));
    assert!(stdout.contains("MAC_FAIL"));
    assert!(stdout.contains("MAC_DEMO_OK"));
}

/// Y8 — SPDZ-MAC z ukrytym δ multi-process: honest + forged exit 3.
#[test]
fn y8_mac_demo_hid_iso() {
    let _g = iso_lock();
    let outdir = iso_tmp().join(format!("iso-mac-hid-{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&outdir);
    let out = std::process::Command::new(env!("CARGO_BIN_EXE_iso"))
        .args(["mac-demo-hid", outdir.to_str().unwrap()])
        .output()
        .expect("mac-demo-hid");
    let stdout = String::from_utf8_lossy(&out.stdout);
    assert!(out.status.success(), "{}", stdout);
    assert!(stdout.contains("MAC_HID_OK"));
    assert!(stdout.contains("MAC_HID_FAIL"));
    assert!(stdout.contains("MAC_DEMO_HID_OK"));
    assert!(
        !outdir.join("delta.txt").exists(),
        "pełny δ nie na dysku"
    );
}

/// H2 — Pedersen w osobnych procesach: verify OK, fałsz FAIL.
#[test]
fn h2_ped_demo_iso() {
    let _g = iso_lock();
    let outdir = iso_tmp().join(format!("iso-ped-{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&outdir);
    let out = std::process::Command::new(env!("CARGO_BIN_EXE_iso"))
        .args(["ped-demo", outdir.to_str().unwrap()])
        .output()
        .expect("ped-demo");
    let stdout = String::from_utf8_lossy(&out.stdout);
    assert!(out.status.success(), "{}", stdout);
    assert!(stdout.contains("PED_OK p=0"));
    assert!(stdout.contains("PED_FAIL"));
    assert!(stdout.contains("PED_DEMO_OK"));
    assert!(!outdir.join("poly.bin").exists());
    assert!(!outdir.join("secret.bin").exists());
}

/// O1 — pipeline: Pedersen verify → G_frag → MAC open (+ fałsz).
#[test]
fn o1_pipeline_iso() {
    let _g = iso_lock();
    let outdir = iso_tmp().join(format!("iso-plt-{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&outdir);
    let out = std::process::Command::new(env!("CARGO_BIN_EXE_iso"))
        .args(["pipeline", outdir.to_str().unwrap()])
        .output()
        .expect("pipeline");
    let stdout = String::from_utf8_lossy(&out.stdout);
    assert!(out.status.success(), "{}", stdout);
    assert!(stdout.contains("PIPE_PED_OK"));
    assert!(stdout.contains("PIPE_GFRAG_OK"));
    assert!(stdout.contains("PIPE_MAC_HID_OK"));
    assert!(stdout.contains("PIPELINE_OK"));
}

#[test]
fn w2_sign_demo_iso() {
    let _g = iso_lock();
    let outdir = iso_tmp().join(format!("iso-sign-{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&outdir);
    let out = std::process::Command::new(env!("CARGO_BIN_EXE_iso"))
        .args(["sign-demo", outdir.to_str().unwrap()])
        .output()
        .expect("sign-demo");
    let s = String::from_utf8_lossy(&out.stdout);
    assert!(out.status.success(), "{}", s);
    for tag in ["SIGN_PED_OK", "SIGN_DERIVE_OK", "SIGN_NONCE_OK", "SIGN_SAMPLE_OK", "SIGN_SYGNET_OK", "SIGN_DEMO_OK"] {
        assert!(s.contains(tag), "missing {tag}");
    }
}
