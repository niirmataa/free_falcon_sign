//! WP-031 e2e: pełny przepływ sign 2-z-3 na prawdziwym kluczu testowym
//! silnika FT1536 + weryfikacja **silnikiem C** (`falcon_vrfy`) przez
//! harness `impl/ci/sign/`.
//!
//! ```text
//! sign_e2e <testkey.bin> <engine-verify-bin> <out-dir>
//! ```
//!
//! `testkey.bin` (syntetyczny klucz z seeda `0x42`, generowany przez
//! `sign_e2e keygen`) zawiera bufor `sk` silnika, `pk` i `h`. Plik jest
//! roboczy, w `.build/` (ignorowany przez Git) — klucz jest syntetyczny,
//! ale higiena obowiązuje (patrz `ci/sign/run_sign_e2e.sh`).
//!
//! Scenariusz:
//! 1. **Pin F2** (`gold-ff`, nonce `[0;40]`): udziały → interpolacja →
//!    `norm²(s1)+norm²(s2) == 103747771` → sygnatura → silnik C: PASS.
//! 2. **Trzy pary** rosteru: pełen protokół `NONCE_COMMIT`/`NONCE_REVEAL`/
//!    `SIGN_OPEN` przez uwierzytelnione koperty; `finish` z weryfikatorem
//!    silnika (subprocess) — obie strony składają identyczny podpis.
//! 3. **Przypadek negatywny:** przekłamany udział `s2` → `finish`
//!    odmawia (`InconsistentShare`), podpis nie jest wydawany.
//!
//! Wyjście: raport na stdout; kod 0 = wszystkie asercje spełnione.

use std::path::{Path, PathBuf};
use std::process::Command;

use ft_threshold_core::Profile;
use ft_threshold_core::codec;
use ft_threshold_core::error::Result;
use ft_threshold_core::ring::{N, Poly, Q};
use ft_threshold_core::shake::{hash_to_point, shake256};
use ft_threshold_core::vss;
use ft_threshold_protocol::envelope::{EnvelopeKey, PartyId};
use ft_threshold_protocol::sign::{
    EngineVerifier, K_2OF3, MSG_SIGN_OPEN, ROUND_SIGN_OPEN, SignMachine, SignOpenPayload,
    SignRequest, lagrange_combine2,
};
use ft_threshold_protocol::state::{DealerContribution, PartyState, SEED_INSTANCES, dkg_root};
use ft_threshold_testkit::{TestKey, deal_test_key, oracle_sample_z};

const SID: [u8; 32] = [0x42; 32];
const PK_HASH: [u8; 32] = [0x99; 32];
const POLICY_HASH: [u8; 32] = [0x77; 32];
const EPOCH: u64 = 7;
const XS: [u16; 3] = [1, 2, 3];
const P1: PartyId = [0x01; 16];
const P2: PartyId = [0x02; 16];
const P3: PartyId = [0x03; 16];
const PARTIES: [PartyId; 3] = [P1, P2, P3];

/// Pin F2 ze spike'a (z ≡ clear, seed 0x42, msg `gold-ff`): norma L2²
/// złożonego $(s1, s2)$.
const F2_PIN_N: u64 = 103_747_771;

struct TestKeyFile {
    skey: Vec<u8>,
    pk: Vec<u8>,
    h: Poly,
}

fn read_test_key(path: &Path) -> std::io::Result<TestKeyFile> {
    let data = std::fs::read(path)?;
    let mut off = 0usize;
    let take = |data: &[u8], off: &mut usize, n: usize| -> Option<Vec<u8>> {
        if *off + n > data.len() {
            return None;
        }
        let v = data[*off..*off + n].to_vec();
        *off += n;
        Some(v)
    };
    let skey_len = u32::from_le_bytes(
        take(data.as_slice(), &mut off, 4)
            .ok_or_else(|| std::io::Error::other("skey_len"))?
            .try_into()
            .unwrap(),
    ) as usize;
    let skey = take(&data, &mut off, skey_len).ok_or_else(|| std::io::Error::other("skey"))?;
    let pk_len = u32::from_le_bytes(
        take(&data, &mut off, 4)
            .ok_or_else(|| std::io::Error::other("pk_len"))?
            .try_into()
            .unwrap(),
    ) as usize;
    let pk = take(&data, &mut off, pk_len).ok_or_else(|| std::io::Error::other("pk"))?;
    let h_bytes = take(&data, &mut off, 2 * N).ok_or_else(|| std::io::Error::other("h"))?;
    let h_coeffs: Vec<u16> = h_bytes
        .chunks_exact(2)
        .map(|b| u16::from_le_bytes([b[0], b[1]]))
        .collect();
    let h = Poly::from_coeffs(&h_coeffs).map_err(|_| std::io::Error::other("h coeffs"))?;
    Ok(TestKeyFile { skey, pk, h })
}

fn hex(bytes: &[u8]) -> String {
    bytes.iter().map(|b| format!("{b:02x}")).collect()
}

/// Weryfikator: podpis przechodzi **prawdziwy silnik C** w subprocessie
/// (`<bin> verify_one <case>`), synchronicznie — `Signature` nie powstaje
/// bez potwierdzenia silnika (I-10).
struct SubVerifier {
    bin: PathBuf,
    case: PathBuf,
    pk: Vec<u8>,
}

impl EngineVerifier for SubVerifier {
    fn verify(&self, _pk: &[u8], msg: &[u8], nonce: &[u8; 40], sig: &[u8]) -> bool {
        let text = format!(
            "pkey = {}\nmsg = {}\nnonce = {}\nsig = {}\n",
            hex(&self.pk),
            hex(msg),
            hex(nonce),
            hex(sig)
        );
        if std::fs::write(&self.case, text).is_err() {
            return false;
        }
        Command::new(&self.bin)
            .arg("verify_one")
            .arg(&self.case)
            .status()
            .map(|s| s.success())
            .unwrap_or(false)
    }
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

fn deterministic_blind(tag: u8, inst: u8) -> [u8; 32] {
    let mut input = Vec::new();
    input.extend_from_slice(b"FT1536/WP-031/e2e-blind");
    input.extend_from_slice(&[tag, inst, 0]);
    let mut h = [0u8; 32];
    shake256(&input, &mut h);
    h[31] &= 0b0000_0111;
    h
}

/// Fixture DKG (3 dealerów × 32 instancje VSS) — jak WP-030/state.rs;
/// harness potrzebuje zwalidowanego `PartyState<Ready>`.
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
            let mine = shares.into_iter().find(|s| s.x() == self_x).expect("share");
            out.push(DealerContribution::new(dealer, instance, comms, mine).expect("contribution"));
        }
    }
    out
}

fn session_for(self_x: u16, key: &TestKey) -> ft_threshold_protocol::state::SignSession {
    let cs = dkg_fixture(self_x);
    let root = dkg_root(&SID, &PK_HASH, K_2OF3, &XS, &cs).expect("root");
    ft_threshold_protocol::state::SignSession::begin(
        PartyState::new(SID, PK_HASH, XS.to_vec(), self_x, K_2OF3)
            .expect("state")
            .validate_dkg(&cs, &root)
            .expect("dkg")
            .validate_ntru(key.f(), key.g(), key.h())
            .expect("ntru"),
        Profile::TestOracle,
    )
    .expect("session")
}

fn pair_key(sender: PartyId, recipient: PartyId) -> EnvelopeKey {
    let mut psk = [0u8; 32];
    psk[..16].copy_from_slice(&sender);
    psk[16..].copy_from_slice(&recipient);
    EnvelopeKey::derive_psk(&psk, SID, EPOCH, sender, recipient).expect("pair key")
}

fn request(msg: &[u8], participants: [PartyId; 2]) -> SignRequest {
    SignRequest::new(
        SID,
        EPOCH,
        msg.to_vec(),
        POLICY_HASH,
        [0x55; 32],
        participants,
    )
    .expect("request")
}

fn poly_i64(v: &[i64]) -> Poly {
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
    Poly::from_coeffs(&coeffs).expect("poly")
}

/// Pin F2: udziały → interpolacja → norma → sygnatura → silnik C.
fn gold_ff_pin(
    key: &TestKey,
    shares: &[ft_threshold_protocol::sign::TrapdoorShare],
    v: &SubVerifier,
) -> bool {
    let msg = b"gold-ff";
    let nonce = [0u8; 40];
    let t = hash_to_point(&nonce, msg).expect("t");
    let (z0, z1) = oracle_sample_z(key, &t);
    let z0p = poly_i64(&z0);
    let z1p = poly_i64(&z1);

    // Udziały podpisu (jak SignMachine::compute_shares) dla pary x=1, x=2.
    let s1_1 = z0p.mul(shares[0].g()).add(&z1p.mul(shares[0].g_big()));
    let s2_1 = z0p.mul(shares[0].f()).add(&z1p.mul(shares[0].f_big()));
    let s1_2 = z0p.mul(shares[1].g()).add(&z1p.mul(shares[1].g_big()));
    let s2_2 = z0p.mul(shares[1].f()).add(&z1p.mul(shares[1].f_big()));
    let s1 = lagrange_combine2(1, &s1_1, 2, &s1_2).expect("s1").sub(&t);
    let s2 = lagrange_combine2(1, &s2_1, 2, &s2_2).expect("s2");

    let n = norm2_centered(&s1) + norm2_centered(&s2);
    println!("GOLD-FF pin n={n} (oczekiwane {F2_PIN_N})");
    if n != F2_PIN_N {
        println!("GOLD-FF pin FAILED");
        return false;
    }
    let sig = codec::encode_sig(&s2);
    if !v.verify(&v.pk, msg, &nonce, &sig) {
        println!("GOLD-FF engine-verify FAILED");
        return false;
    }
    println!("GOLD-FF engine-verify OK");
    true
}

fn run_pair(
    key: &TestKey,
    shares: &[ft_threshold_protocol::sign::TrapdoorShare],
    i: usize,
    j: usize,
    msg: &[u8],
    v: &dyn EngineVerifier,
) -> Result<Vec<u8>> {
    let (a_id, b_id) = (PARTIES[i], PARTIES[j]);
    let mut a = SignMachine::begin(
        session_for(XS[i], key),
        request(msg, [a_id, b_id]),
        a_id,
        PARTIES,
        trapdoor_copy(&shares[i]),
        Profile::TestOracle,
    )?;
    let mut b = SignMachine::begin(
        session_for(XS[j], key),
        request(msg, [a_id, b_id]),
        b_id,
        PARTIES,
        trapdoor_copy(&shares[j]),
        Profile::TestOracle,
    )?;
    let (k_ab, k_ba) = (pair_key(a_id, b_id), pair_key(b_id, a_id));

    // N1/N2: commit → reveal.
    let e1 = a.seal_nonce_commit(&k_ab, [0x11; 40], [0xA1; 32])?;
    let e2 = b.seal_nonce_commit(&k_ba, [0x22; 40], [0xB2; 32])?;
    a.receive_nonce_commit(&k_ba, e2)?;
    b.receive_nonce_commit(&k_ab, e1)?;
    let e3 = a.seal_nonce_reveal(&k_ab)?;
    let e4 = b.seal_nonce_reveal(&k_ba)?;
    a.receive_nonce_reveal(&k_ba, e4)?;
    b.receive_nonce_reveal(&k_ab, e3)?;

    // N3 + §7.3 + C1: wspólny nonce, t i oracle-$z$.
    assert_eq!(a.derive_nonce()?, b.derive_nonce()?, "nonce zgodne");
    a.compute_t()?;
    b.compute_t()?;
    let t = hash_to_point(&a.nonce().expect("nonce"), msg).expect("t");
    let (z0, z1) = oracle_sample_z(key, &t);
    a.compute_shares(&z0, &z1)?;
    b.compute_shares(&z0, &z1)?;

    // C2: otwarcie udziałów; C3: złożenie + weryfikator silnika.
    let e5 = a.seal_sign_open(&k_ab)?;
    let e6 = b.seal_sign_open(&k_ba)?;
    a.receive_sign_open(&k_ba, e6)?;
    b.receive_sign_open(&k_ab, e5)?;
    let sa = a.finish(key.h(), &[], v)?;
    let sb = b.finish(key.h(), &[], v)?;
    assert_eq!(
        sa.bytes(),
        sb.bytes(),
        "obie strony składają ten sam podpis"
    );
    Ok(sa.bytes().to_vec())
}

/// Kopiuje udział pułapki (Poly nie ma `Clone` — jawne kopiowanie przez bajty).
fn trapdoor_copy(
    s: &ft_threshold_protocol::sign::TrapdoorShare,
) -> ft_threshold_protocol::sign::TrapdoorShare {
    let cp = |p: &Poly| Poly::from_le_bytes(&p.to_le_bytes()).expect("copy");
    ft_threshold_protocol::sign::TrapdoorShare::new(
        s.x(),
        cp(s.f()),
        cp(s.g()),
        cp(s.f_big()),
        cp(s.g_big()),
    )
    .expect("trapdoor")
}

/// Przypadek negatywny: przekłamany udział `s2` → `finish` odmawia.
fn tamper_is_rejected(
    key: &TestKey,
    shares: &[ft_threshold_protocol::sign::TrapdoorShare],
    v: &dyn EngineVerifier,
) -> bool {
    use ft_threshold_protocol::envelope::{Body, Envelope};

    let msg = b"wp-031 tamper";
    let (a_id, b_id) = (PARTIES[0], PARTIES[1]);
    let mut a = SignMachine::begin(
        session_for(XS[0], key),
        request(msg, [a_id, b_id]),
        a_id,
        PARTIES,
        trapdoor_copy(&shares[0]),
        Profile::TestOracle,
    )
    .expect("A");
    let mut b = SignMachine::begin(
        session_for(XS[1], key),
        request(msg, [a_id, b_id]),
        b_id,
        PARTIES,
        trapdoor_copy(&shares[1]),
        Profile::TestOracle,
    )
    .expect("B");
    let (k_ab, k_ba) = (pair_key(a_id, b_id), pair_key(b_id, a_id));
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
    let t = hash_to_point(&a.nonce().expect("nonce"), msg).expect("t");
    let (z0, z1) = oracle_sample_z(key, &t);
    a.compute_shares(&z0, &z1).expect("shA");
    b.compute_shares(&z0, &z1).expect("shB");
    let _ = a.seal_sign_open(&k_ab).expect("o1");

    // B przekłamuje udział s2 (uczciwe SIGN_OPEN nie jest dostarczane).
    let honest = b.seal_sign_open(&k_ba).expect("o2");
    let payload = SignOpenPayload::from_cbor(honest.body_unverified().payload()).expect("p");
    let mut bump = vec![0u16; N];
    bump[0] = 1;
    let s2_bad = payload
        .s2_share()
        .expect("s2")
        .add(&Poly::from_coeffs(&bump).expect("bump"));
    let forged = SignOpenPayload::new(&payload.s1_share().expect("s1"), &s2_bad, payload.t_hash());
    let body = Body::new(
        SID,
        EPOCH,
        ROUND_SIGN_OPEN,
        3,
        MSG_SIGN_OPEN,
        b_id,
        forged.to_cbor(),
    )
    .expect("body");
    let forged_env = Envelope::seal(&k_ba, body).expect("seal");
    a.receive_sign_open(&k_ba, forged_env).expect("recv");

    let err = a
        .finish(key.h(), &[], v)
        .expect_err("przekłamany udział musi być odrzucony");
    println!("TAMPER rejected: {err}");
    a.is_aborted()
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() != 4 {
        eprintln!(
            "usage: {} <testkey.bin> <engine-verify-bin> <out-dir>",
            args[0]
        );
        std::process::exit(2);
    }
    let tk = read_test_key(Path::new(&args[1])).expect("testkey.bin");
    let verify_bin = PathBuf::from(&args[2]);
    let out_dir = PathBuf::from(&args[3]);
    std::fs::create_dir_all(&out_dir).expect("out dir");

    let key = TestKey::from_engine_sk(&tk.skey, tk.h.clone_poly()).expect("decode sk");
    let shares = deal_test_key(&key, &XS, 2, &[0x42u8; 32]).expect("deal");
    let v = SubVerifier {
        bin: verify_bin,
        case: out_dir.join("case.txt"),
        pk: tk.pk.clone(),
    };

    let mut ok = true;

    // 1. Pin F2 + engine verify na kluczu silnika (seed 0x42).
    ok &= gold_ff_pin(&key, &shares, &v);

    // 2. Trzy pary: pełny protokół + engine verify.
    for (i, j) in [(0usize, 1usize), (0, 2), (1, 2)] {
        match run_pair(&key, &shares, i, j, b"wp-031 e2e message", &v) {
            Ok(sig) => println!("PAIR {},{} OK sig={}", i + 1, j + 1, hex(&sig)),
            Err(e) => {
                println!("PAIR {},{} FAILED: {e}", i + 1, j + 1);
                ok = false;
            }
        }
    }

    // 3. Przypadek negatywny.
    ok &= tamper_is_rejected(&key, &shares, &v);

    println!("E2E {}", if ok { "PASS" } else { "FAIL" });
    std::process::exit(if ok { 0 } else { 1 });
}

/// Poly nie ma `Clone` — jawne kopiowanie przez bajty (harness).
trait ClonePoly {
    fn clone_poly(&self) -> Poly;
}
impl ClonePoly for Poly {
    fn clone_poly(&self) -> Poly {
        Poly::from_le_bytes(&self.to_le_bytes()).expect("copy")
    }
}
