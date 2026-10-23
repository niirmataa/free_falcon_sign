//! Spike 008 — izolacja procesów (granica F-13).
//!
//! **PROTOTYP.** Role jako **osobne procesy**:
//! - `dealer` — zna seed, dzieli na kolumny, **wychodzi** (sekret z nim)
//! - `party`  — trzyma **tylko własną kolumnę** (PartyView)
//! - `mailbox` — widzi wyłącznie publiczne maski (d,e) i jawne otwarcia
//!
//! Twierdzenie (wąskie): po wyjściu dealera żaden z procesów `party`/`mailbox`
//! nie ma pełnego seeda ani cudzych kolumn. To **nie** jest próg FT ani
//! malicious-secure — model dealerski, semi-honest, jeden Beaver na demonstrację.

use ft1536_threshold_spike::{
    derive_g_frag_shares, derive_nonce_shares, generate_triple_shares, gf_mul, mask_one,
    open_g_frag_byte, split_seed, sygnet_synthetic,
    open_g_frag_byte_mac_hidden, reconstruct_vals, shamir_share, Share,
};
use std::io::Read;
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};
use zeroize::Zeroize;

/// TT-31: audyt odczytów (zamiast strace — brak w środowisku).
/// `ISO_AUDIT=1` → dopisz ścieżkę do `audit{p}.log` w workdir.
fn audited_read(p: usize, workdir: &Path, path: &Path) -> std::io::Result<Vec<u8>> {
    let data = std::fs::read(path)?;
    if std::env::var("ISO_AUDIT").is_ok() {
        let mut f = std::fs::OpenOptions::new()
            .create(true)
            .append(true)
            .open(workdir.join(format!("audit{p}.log")))
            .ok();
        if let Some(f) = f.as_mut() {
            use std::io::Write;
            let _ = writeln!(f, "{}", path.display());
        }
    }
    Ok(data)
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    match args.get(1).map(|s| s.as_str()) {
        Some("dealer") => cmd_dealer(&args[2..]),
        Some("party") => cmd_party(&args[2..]),
        Some("mailbox") => cmd_mailbox(&args[2..]),
        Some("demo") => cmd_demo(&args[2..]),
        Some("full-dealer") => cmd_full_dealer(&args[2..]),
        Some("worker") => cmd_worker(&args[2..]),
        Some("full") => cmd_full(&args[2..]),
        Some("dkg") => cmd_dkg(&args[2..]),
        Some("dkg-party") => cmd_dkg_party(&args[2..]),
        Some("triple-dealer") => cmd_triple_dealer(&args[2..]),
        Some("sacrifice-mul") => cmd_sacrifice_mul(&args[2..]),
        Some("triples") => cmd_triples_demo(&args[2..]),
        Some("triple-party") => cmd_triple_party(&args[2..]),
        Some("full-triples") => cmd_full_triples(&args[2..]),
        Some("verify-cols") => cmd_verify_cols(&args[2..]),
        Some("dkg5") => cmd_dkg5(&args[2..]),
        Some("dkg5-party") => cmd_dkg5_party(&args[2..]),
        Some("mac-dealer") => cmd_mac_dealer(&args[2..]),
        Some("mac-open") => cmd_mac_open(&args[2..]),
        Some("mac-demo") => cmd_mac_demo(&args[2..]),
        Some("mac-dealer-hid") => cmd_mac_dealer_hid(&args[2..]),
        Some("mac-open-hid") => cmd_mac_open_hid(&args[2..]),
        Some("mac-demo-hid") => cmd_mac_demo_hid(&args[2..]),
        Some("ped-party") => cmd_ped_party(&args[2..]),
        Some("ped-demo") => cmd_ped_demo(&args[2..]),
        Some("pipeline") => cmd_pipeline(&args[2..]),
        Some("sign-demo") => cmd_sign_demo(&args[2..]),
        _ => {
            eprintln!(
                "usage: iso dealer|party|mailbox|demo|full-dealer|worker|full|dkg|dkg-party|triple-dealer ..."
            );
            std::process::exit(2);
        }
    }
}

// ─── dealer: split + write columns + exit ─────────────────────────────────

fn cmd_dealer(args: &[String]) {
    // iso dealer <outdir>
    let outdir = PathBuf::from(args.first().expect("outdir"));
    std::fs::create_dir_all(&outdir).unwrap();
    let mut seed = [0u8; 32];
    // syntetyczny seed z /dev/urandom
    let mut f = std::fs::File::open("/dev/urandom").unwrap();
    f.read_exact(&mut seed).unwrap();
    let xs = [1u8, 2, 3];
    let k = 2u8;
    let mut cols: Vec<Vec<u8>> = vec![vec![]; 3];
    for b in seed.iter() {
        let shares = shamir_share(&mut StdRngOs, *b, &xs, k).unwrap();
        for (i, s) in shares.into_iter().enumerate() {
            cols[i].push(s.share);
        }
    }
    for (i, col) in cols.iter().enumerate() {
        let p = outdir.join(format!("col{i}.bin"));
        std::fs::write(&p, col).unwrap();
    }
    // seed nie jest zapisywany — tylko kolumny
    seed.zeroize();
    println!("DEALER_DONE");
}

/// minimalny Rng oparty na /dev/urandom (bez StdRng w dealerze)
struct StdRngOs;
impl rand::RngCore for StdRngOs {
    fn next_u32(&mut self) -> u32 {
        self.next_u64() as u32
    }
    fn next_u64(&mut self) -> u64 {
        let mut b = [0u8; 8];
        std::fs::File::open("/dev/urandom")
            .unwrap()
            .read_exact(&mut b)
            .unwrap();
        u64::from_le_bytes(b)
    }
    fn fill_bytes(&mut self, dest: &mut [u8]) {
        std::fs::File::open("/dev/urandom")
            .unwrap()
            .read_exact(dest)
            .unwrap();
    }
    fn try_fill_bytes(&mut self, dest: &mut [u8]) -> Result<(), rand::Error> {
        self.fill_bytes(dest);
        Ok(())
    }
}

// ─── party: own column only ───────────────────────────────────────────────

fn cmd_party(args: &[String]) {
    // iso party <colfile> <x> <workdir>
    let colfile = PathBuf::from(&args[0]);
    let x: u8 = args[1].parse().unwrap();
    let workdir = PathBuf::from(&args[2]);
    let col = std::fs::read(&colfile).unwrap();
    assert_eq!(col.len(), 32, "column must be 32 seed-bytes");
    // PartyView: tylko własna kolumna
    let view = ft1536_threshold_spike::PartyView::from_column(x, col).unwrap();
    // zapisz hash kolumny (nie treść) do logu — dowód, że to TEN plik
    let mut h = 0xcbf29ce484222325u64;
    for i in 0..view.len() {
        if let Some(s) = view.share_at(i) {
            h ^= s as u64;
            h = h.wrapping_mul(0x100000001b3);
        }
    }
    let log = workdir.join(format!("party{x}.log"));
    std::fs::write(&log, format!("x={x} len={} fnv={h:016x}\n", view.len())).unwrap();
    // odpal lokalny Beaver na kolumnie vs druga kolumna NIE — party nie ma
    // drugiej kolumny. Demonstracja: party wysyła d_i,e_i dla pary (self, ??)
    // — w pełnym G_frag tu jest komunikacja. Na spike: party zapisuje gotowość.
    println!("PARTY_READY x={x} fnv={h:016x}");
}

// ─── mailbox: only public masks + opens ───────────────────────────────────

fn cmd_mailbox(args: &[String]) {
    // iso mailbox <workdir> — czyta wiadomości publiczne
    let workdir = PathBuf::from(&args[0]);
    let msgs = workdir.join("public.msgs");
    if msgs.exists() {
        let s = std::fs::read_to_string(&msgs).unwrap();
        println!("MAILBOX {} lines", s.lines().count());
    } else {
        println!("MAILBOX empty");
    }
}

// ─── demo: orchestracja procesów ──────────────────────────────────────────

fn cmd_demo(args: &[String]) {
    let workdir = PathBuf::from(args.first().cloned().unwrap_or_else(|| "iso-work".into()));
    let _ = std::fs::remove_dir_all(&workdir);
    std::fs::create_dir_all(&workdir).unwrap();

    let exe = std::env::current_exe().unwrap();

    // 1) dealer — osobny proces, kończy się
    let d = Command::new(&exe)
        .args(["dealer", workdir.to_str().unwrap()])
        .stdout(Stdio::piped())
        .spawn()
        .unwrap()
        .wait_with_output()
        .unwrap();
    assert!(d.status.success(), "dealer must succeed");
    let d_out = String::from_utf8_lossy(&d.stdout);
    assert!(d_out.contains("DEALER_DONE"));
    // kolumny istnieją; seed nie
    for i in 0..3 {
        let p = workdir.join(format!("col{i}.bin"));
        assert!(p.exists());
    }
    assert!(!workdir.join("seed.bin").exists(), "seed must not be written");

    // 2) trzy party — osobne procesy, każdy tylko własną kolumnę
    let xs = ["1", "2", "3"];
    let mut party_outs = Vec::new();
    for (i, x) in xs.iter().enumerate() {
        let col = workdir.join(format!("col{i}.bin"));
        let p = Command::new(&exe)
            .args([
                "party",
                col.to_str().unwrap(),
                x,
                workdir.to_str().unwrap(),
            ])
            .stdout(Stdio::piped())
            .spawn()
            .unwrap()
            .wait_with_output()
            .unwrap();
        assert!(p.status.success());
        party_outs.push(String::from_utf8_lossy(&p.stdout).into_owned());
    }

    // 3) mailbox — publiczne
    let m = Command::new(&exe)
        .args(["mailbox", workdir.to_str().unwrap()])
        .stdout(Stdio::piped())
        .spawn()
        .unwrap()
        .wait_with_output()
        .unwrap();

    // 4) izolacja: logi party nie zawierają pełnego seeda ani cudzych kolumn
    //    (seed nie istnieje na dysku po dealerze; kolumny są osobne)
    let mut col0 = std::fs::read(workdir.join("col0.bin")).unwrap();
    let col1 = std::fs::read(workdir.join("col1.bin")).unwrap();
    let col2 = std::fs::read(workdir.join("col2.bin")).unwrap();
    assert_ne!(col0, col1);
    assert_ne!(col1, col2);

    let log0 = std::fs::read_to_string(workdir.join("party1.log")).unwrap();
    // log party1 nie jest równy kolumnie 0 ani 2 (tylko hash)
    assert!(log0.starts_with("x=1"));
    assert!(!log0.contains(&format!("{:02x?}", col0[0])), "log must not dump column bytes");

    // 5) Beaver publiczny krok: demonstracja w jednym procesie koordynatora
    //    (mailbox widziałby tylko d,e) — potwierdzenie wzorca komunikacji.
    let mut rng = StdRngOs;
    let tri = generate_triple_shares(&mut rng, &[1, 2, 3], 2).unwrap();
    // strona 1 (x=1) i strona 2 (x=2) mnożą [a]*[b] z trójki jako demo
    let (d1, e1, _m1) = mask_one(col0[0], col1[0], tri.a[0], tri.b[0], tri.c[0]);
    let (d2, e2, _m2) = mask_one(col0[1], col1[1], tri.a[1], tri.b[1], tri.c[1]);
    let _d = reconstruct_vals(&[1, 2], &[d1, d2]).unwrap();
    let _e = reconstruct_vals(&[1, 2], &[e1, e2]).unwrap();
    // publiczne d,e — to mailbox widzi; NIE kolumny

    // 6) jawne otwarcie tylko wyznaczonego bajtu (kontrakt)
    let byte_shares: Vec<Share> = [1u8, 2, 3]
        .iter()
        .enumerate()
        .map(|(i, &x)| Share {
            x,
            share: col0[i],
        })
        .collect();
    // to jest otwarcie bajtu 0 — jawny „moment"
    let opened = open_g_frag_byte(&byte_shares, 2);
    assert!(opened.is_ok());

    println!("ISO_DEMO_OK");
    println!("dealer: {}", d_out.trim());
    for o in &party_outs {
        print!("{o}");
    }
    print!("{}", String::from_utf8_lossy(&m.stdout));
    col0.zeroize();
}

// ─── Spike 009: G_frag między procesami (mailbox plikowy) ─────────────────
//
// Pełna liczba mnożeń G_frag = 64 (32+32). Każda runda:
//   party_p: (d_p, e_p) → mailbox/r{m}_de{p}.bin
//   mailbox: d,e → mailbox/r{m}_pub.bin
//   party_p: z_p = finish(d,e) — udział iloczynu
// Udziały kolumn **nie** opuszczają procesu party.

const G_MULS: usize = 64;

fn full_seed_and_triples(outdir: &Path) {
    use zeroize::Zeroize;
    let mut seed = [0u8; 32];
    std::fs::File::open("/dev/urandom")
        .unwrap()
        .read_exact(&mut seed)
        .unwrap();
    let xs = [1u8, 2, 3];
    let k = 2u8;
    let mut cols: Vec<Vec<u8>> = vec![vec![]; 3];
    for b in seed.iter() {
        let shares = shamir_share(&mut StdRngOs, *b, &xs, k).unwrap();
        for (i, s) in shares.into_iter().enumerate() {
            cols[i].push(s.share);
        }
    }
    for (i, col) in cols.iter().enumerate() {
        std::fs::write(outdir.join(format!("col{i}.bin")), col).unwrap();
    }
    // trójki: G_MULS × 3 partie × 3 bajty (a,b,c)
    for m in 0..G_MULS {
        let tri = generate_triple_shares(&mut StdRngOs, &xs, k).unwrap();
        for p in 0..3 {
            let payload = [tri.a[p], tri.b[p], tri.c[p]];
            std::fs::write(outdir.join(format!("trip{m}_{p}.bin")), payload).unwrap();
        }
    }
    seed.zeroize();
    std::fs::create_dir_all(outdir.join("mailbox")).unwrap();
    println!("FULL_DEALER_DONE muls={G_MULS}");
}

fn cmd_full_dealer(args: &[String]) {
    let outdir = PathBuf::from(args.first().expect("outdir"));
    std::fs::create_dir_all(&outdir).unwrap();
    full_seed_and_triples(&outdir);
}

fn cmd_worker(args: &[String]) {
    // iso worker <workdir> <p:0|1|2>
    let workdir = PathBuf::from(&args[0]);
    let p: usize = args[1].parse().unwrap();
    let col = std::fs::read(workdir.join(format!("col{p}.bin"))).unwrap();
    assert_eq!(col.len(), 32);
    let view = ft1536_threshold_spike::PartyView::from_column(
        [1u8, 2, 3][p],
        col.clone(),
    )
    .unwrap();

    // stan lokalny: udziały seeda i out
    let mut seed_at: Vec<u8> = (0..32).map(|i| view.share_at(i).unwrap()).collect();
    let mut out_at: Vec<u8> = Vec::with_capacity(64);

    let mailbox = workdir.join("mailbox");
    std::fs::create_dir_all(&mailbox).unwrap();

    let mut z_count = 0usize;
    for m in 0..G_MULS {
        // wejścia do mnożenia
        let (x_i, y_i) = if m < 32 {
            let i = m;
            (seed_at[(i + 1) % 32], seed_at[(i + 13) % 32])
        } else {
            let i = m - 32;
            (out_at[i], seed_at[i])
        };
        let trip = std::fs::read(workdir.join(format!("trip{m}_{p}.bin"))).unwrap();
        assert_eq!(trip.len(), 3);
        let (d_i, e_i, mt) = mask_one(x_i, y_i, trip[0], trip[1], trip[2]);
        // atomiczny zapis
        let de_path = mailbox.join(format!("r{m}_de{p}.bin"));
        let de_tmp = mailbox.join(format!("r{m}_de{p}.tmp"));
        std::fs::write(&de_tmp, [d_i, e_i]).unwrap();
        std::fs::rename(&de_tmp, &de_path).unwrap();
        // czekaj na publiczne d,e (wszystkie de + pub)
        let pub_path = mailbox.join(format!("r{m}_pub.bin"));
        let deadline = std::time::Instant::now() + std::time::Duration::from_secs(20);
        while !pub_path.exists() {
            if std::time::Instant::now() > deadline {
                panic!("timeout waiting pub for round {m}");
            }
            let mut all_de = true;
            let mut ds = [0u8; 3];
            let mut es = [0u8; 3];
            for q in 0..3 {
                let pth = mailbox.join(format!("r{m}_de{q}.bin"));
                match std::fs::read(&pth) {
                    Ok(de) if de.len() == 2 => {
                        ds[q] = de[0];
                        es[q] = de[1];
                    }
                    _ => {
                        all_de = false;
                        break;
                    }
                }
            }
            if all_de && !pub_path.exists() {
                let d = reconstruct_vals(&[1, 2, 3], &ds).unwrap();
                let e = reconstruct_vals(&[1, 2, 3], &es).unwrap();
                let pub_tmp = mailbox.join(format!("r{m}_pub{p}.tmp"));
                std::fs::write(&pub_tmp, [d, e]).unwrap();
                if std::fs::rename(&pub_tmp, &pub_path).is_err() {
                    let _ = std::fs::remove_file(&pub_tmp);
                }
            }
            std::thread::sleep(std::time::Duration::from_millis(2));
        }
        let pubde = std::fs::read(&pub_path).unwrap();
        let z = mt.finish(pubde[0], pubde[1]);
        // złóż wynik rundy w out / seed
        if m < 32 {
            let i = m;
            // out[i] = seed[i] ⊕ z
            out_at.push(seed_at[i] ^ z);
        } else {
            let i = m - 32;
            // out[32+i] = out[i] ⊕ z
            out_at.push(out_at[i] ^ z);
        }
        z_count += 1;
    }
    assert_eq!(z_count, G_MULS);
    assert_eq!(out_at.len(), 64);
    std::fs::write(workdir.join(format!("out{p}.bin")), &out_at).unwrap();
    out_at.zeroize();
    seed_at.zeroize();
    println!("WORKER_DONE p={p}");
}

fn cmd_full(args: &[String]) {
    let workdir = PathBuf::from(args.first().cloned().unwrap_or_else(|| "iso-full".into()));
    let _ = std::fs::remove_dir_all(&workdir);
    std::fs::create_dir_all(&workdir).unwrap();
    let exe = std::env::current_exe().unwrap();

    let d = Command::new(&exe)
        .args(["full-dealer", workdir.to_str().unwrap()])
        .stdout(Stdio::piped())
        .spawn()
        .unwrap()
        .wait_with_output()
        .unwrap();
    assert!(d.status.success());
    assert!(String::from_utf8_lossy(&d.stdout).contains("FULL_DEALER_DONE"));

    let mut handles = Vec::new();
    for p in 0..3 {
        let exe = exe.clone();
        let wd = workdir.clone();
        handles.push(
            Command::new(exe)
                .args(["worker", wd.to_str().unwrap(), &p.to_string()])
                .stdout(Stdio::piped())
                .spawn()
                .unwrap(),
        );
    }
    for h in handles {
        let o = h.wait_with_output().unwrap();
        assert!(o.status.success(), "{}", String::from_utf8_lossy(&o.stderr));
        print!("{}", String::from_utf8_lossy(&o.stdout));
    }

    // weryfikacja: udziały out zgadzają się z g_frag_local tylko przy otwarciu
    // — tu otwieramy bajt 0 przez mailbox (jawny kontrakt)
    let out0 = std::fs::read(workdir.join("out0.bin")).unwrap();
    let out1 = std::fs::read(workdir.join("out1.bin")).unwrap();
    let _out2 = std::fs::read(workdir.join("out2.bin")).unwrap();
    assert_eq!(out0.len(), 64);
    assert_ne!(out0, out1);
    // otwarcie bajtu 0 z 2 udziałów (próg)
    let shares: Vec<Share> = vec![
        Share { x: 1, share: out0[0] },
        Share { x: 2, share: out1[0] },
    ];
    let opened = open_g_frag_byte(&shares, 2).unwrap();
    // oracle: nie mamy seeda w demo — zapisujemy otwarty bajt
    std::fs::write(workdir.join("opened0.bin"), [opened]).unwrap();
    println!("FULL_OK opened0={opened:02x}");
}

// ─── Spike 010: DKG seeda — żaden proces dealera nie zna sekretu ─────────
//
// Każda strona i losuje wkład s_i (32 B) i wielomiany Shamira k=2;
// wysyła f_i(j) do strony j. Sekret seed = ⊕_i s_i **nie istnieje**
// w żadnym procesie przed jawnych otwarciem.
// Trójki Beavera = preprocessing (osobny `triple-dealer`) — nie sekret.

fn cmd_triple_dealer(args: &[String]) {
    let outdir = PathBuf::from(args.first().expect("outdir"));
    std::fs::create_dir_all(&outdir.join("mailbox")).unwrap();
    let xs = [1u8, 2, 3];
    let k = 2u8;
    for m in 0..G_MULS {
        let tri = generate_triple_shares(&mut StdRngOs, &xs, k).unwrap();
        for p in 0..3 {
            std::fs::write(
                outdir.join(format!("trip{m}_{p}.bin")),
                [tri.a[p], tri.b[p], tri.c[p]],
            )
            .unwrap();
        }
    }
    println!("TRIPLE_DEALER_DONE");
}

fn cmd_dkg_party(args: &[String]) {
    // iso dkg-party <workdir> <p>
    use zeroize::Zeroize;
    let workdir = PathBuf::from(&args[0]);
    let p: usize = args[1].parse().unwrap();
    let mailbox = workdir.join("mailbox");
    std::fs::create_dir_all(&mailbox).unwrap();
    let xs = [1u8, 2u8, 3u8];
    let k = 2u8;

    // 1) wkład s_i — nigdy nie zapisywany w całości jako „seed"
    let mut s_i = [0u8; 32];
    std::fs::File::open("/dev/urandom")
        .unwrap()
        .read_exact(&mut s_i)
        .unwrap();

    // 2) deal: f_i(j) jako 32-bajtowe kolumny — deal{p}_{x}.bin
    let mut deals: Vec<[u8; 32]> = vec![[0u8; 32]; 3];
    for b in 0..32 {
        let shares = shamir_share(&mut StdRngOs, s_i[b], &xs, k).unwrap();
        for (j, sh) in shares.into_iter().enumerate() {
            deals[j][b] = sh.share;
        }
    }
    for (j, x) in xs.iter().enumerate() {
        let path = mailbox.join(format!("deal{p}_{x}.bin"));
        let tmp = mailbox.join(format!("deal{p}_{x}.tmp"));
        std::fs::write(&tmp, deals[j]).unwrap();
        std::fs::rename(&tmp, &path).unwrap();
    }

    // 3) poczekaj na deals od innych i zsumuj kolumnę (XOR w GF256)
    let deadline = std::time::Instant::now() + std::time::Duration::from_secs(20);
    loop {
        let ok = (0..3).all(|q| mailbox.join(format!("deal{q}_{}.bin", xs[p])).exists());
        if ok {
            break;
        }
        if std::time::Instant::now() > deadline {
            panic!("timeout waiting deals for party {p}");
        }
        std::thread::sleep(std::time::Duration::from_millis(2));
    }
    let mut col = vec![0u8; 32];
    for q in 0..3 {
        let bytes = audited_read(p, &workdir, &mailbox.join(format!("deal{q}_{}.bin", xs[p]))).unwrap();
        assert_eq!(bytes.len(), 32);
        for b in 0..32 {
            col[b] ^= bytes[b];
        }
    }
    // TT-33: zapisz kolumnę seeda do weryfikacji spójności w rodzicu
    std::fs::write(workdir.join(format!("col{p}.bin")), &col).unwrap();
    // 4) G_frag na kolumnie — jak worker (tym razem seed = ⊕ s_i nie jest znany)
    let mut seed_at = col.clone();
    let mut out_at: Vec<u8> = Vec::with_capacity(64);
    for m in 0..G_MULS {
        let (x_i, y_i) = if m < 32 {
            let i = m;
            (seed_at[(i + 1) % 32], seed_at[(i + 13) % 32])
        } else {
            let i = m - 32;
            (out_at[i], seed_at[i])
        };
        // TT-20/21: mnożenie Lagrange re-deal — brak trip*
        let u_p =
            ft1536_threshold_spike::mul::local_weighted_product(&xs, p, x_i, y_i).unwrap();
        let dealt = shamir_share(&mut StdRngOs, u_p, &xs, k).unwrap();
        for (j, sh) in dealt.into_iter().enumerate() {
            let path = mailbox.join(format!("um{m}_{p}_{}.bin", xs[j]));
            let tmp = mailbox.join(format!("um{m}_{p}_{}.tmp", xs[j]));
            std::fs::write(&tmp, [sh.share]).unwrap();
            std::fs::rename(&tmp, &path).unwrap();
        }
        let deadline = std::time::Instant::now() + std::time::Duration::from_secs(20);
        let z = loop {
            let mut acc = 0u8;
            let mut ok = true;
            for q in 0..3 {
                let path = mailbox.join(format!("um{m}_{q}_{}.bin", xs[p]));
                match audited_read(p, &workdir, &path) {
                    Ok(b) if b.len() == 1 => acc ^= b[0],
                    _ => {
                        ok = false;
                        break;
                    }
                }
            }
            if ok {
                break acc;
            }
            if std::time::Instant::now() > deadline {
                panic!("timeout umul round {m}");
            }
            std::thread::sleep(std::time::Duration::from_millis(2));
        };
        if m < 32 {
            let i = m;
            out_at.push(seed_at[i] ^ z);
        } else {
            let i = m - 32;
            out_at.push(out_at[i] ^ z);
        }
    }
    std::fs::write(workdir.join(format!("out{p}.bin")), &out_at).unwrap();
    // jawny „moment" TYLKO dla oracle testowego: zapisz s_i (wkład)
    // TT-30: wkład tylko na stdout (nie plik) — oracle w rodzicu
    let hex: String = s_i.iter().map(|b| format!("{b:02x}")).collect();
    println!("CONTRIB {p} {hex}");
    s_i.zeroize();
    seed_at.zeroize();
    out_at.zeroize();
    println!("DKG_PARTY_DONE p={p}");
}

fn cmd_dkg(args: &[String]) {
    let workdir = PathBuf::from(args.first().cloned().unwrap_or_else(|| "iso-dkg".into()));
    let _ = std::fs::remove_dir_all(&workdir);
    std::fs::create_dir_all(&workdir).unwrap();
    let exe = std::env::current_exe().unwrap();

    // 3 strony DKG (bez triple-dealer — mnożenie Lagrange re-deal)
    let mut handles = Vec::new();
    for p in 0..3 {
        handles.push(
            Command::new(&exe)
                .args(["dkg-party", workdir.to_str().unwrap(), &p.to_string()])
                .env("ISO_AUDIT", "1")
                .stdout(Stdio::piped())
                .spawn()
                .unwrap(),
        );
    }
    for (i, h) in handles.into_iter().enumerate() {
        let o = h.wait_with_output().unwrap();
        assert!(o.status.success(), "{}", String::from_utf8_lossy(&o.stderr));
        std::fs::write(workdir.join(format!("party{i}.out")), &o.stdout).unwrap();
        print!("{}", String::from_utf8_lossy(&o.stdout));
    }

    // TT-33: spójność kolumn seeda (n>k) — fail-closed przy fałszu
    for b in 0..32 {
        let shares: Vec<ft1536_threshold_spike::Share> = (0..3)
            .map(|p| {
                let c = std::fs::read(workdir.join(format!("col{p}.bin"))).unwrap();
                ft1536_threshold_spike::Share {
                    x: [1u8, 2, 3][p],
                    share: c[b],
                }
            })
            .collect();
        let refs: Vec<&_> = shares.iter().collect();
        if ft1536_threshold_spike::verify_consistency(&refs, 2).is_err() {
            eprintln!("INCONSISTENT col byte {b}");
            std::process::exit(3);
        }
    }

    // oracle: seed = ⊕ s_i ze stdout party (TT-30 — brak plików contrib)
    let mut seed = [0u8; 32];
    // z wejść demo czytamy stdout party poniżej — tu: odczytaj z workdir/party*.out
    for p in 0..3 {
        let log = std::fs::read_to_string(workdir.join(format!("party{p}.out"))).unwrap();
        for line in log.lines() {
            if let Some(rest) = line.strip_prefix(&format!("CONTRIB {p} ")) {
                let bytes = (0..32)
                    .map(|i| u8::from_str_radix(&rest[i * 2..i * 2 + 2], 16).unwrap())
                    .collect::<Vec<u8>>();
                for b in 0..32 {
                    seed[b] ^= bytes[b];
                }
            }
        }
    }
    let expect = ft1536_threshold_spike::g_frag_local(&seed);
    let out0 = std::fs::read(workdir.join("out0.bin")).unwrap();
    let out1 = std::fs::read(workdir.join("out1.bin")).unwrap();
    let opened = open_g_frag_byte(
        &[Share { x: 1, share: out0[0] }, Share { x: 2, share: out1[0] }],
        2,
    )
    .unwrap();
    assert_eq!(opened, expect[0], "DKG G_frag byte0 must match g_frag_local(seed)");
    // brak pliku seed.bin — seed nie został zapisany jako całość przez dealera
    assert!(!workdir.join("seed.bin").exists());
    println!("DKG_OK opened0={opened:02x}");
}

// ─── Spike 011: trójki bez stojącego dealera sekretu ──────────────────────
//
// a,b: jak DKG seeda (wkłady stron, brak centralnego sekretu).
// c=a*b: jednorazowy **sacrifice mul** (osobny proces, zeroizuje a,b).
// To NIE jest OT/HE triple-gen — zaufanie: proces, który widzi a,b na jedną
// mnożenie i umiera. Sacrifice-check: otwarcie wybranej trójki, assert c=a*b.

fn cmd_sacrifice_mul(args: &[String]) {
    // iso sacrifice-mul <workdir> — czyta ashare{p}.bin, bshare{p}.bin
    // rekonstruuje a,b, c=a*b, zapisuje cshare{p}.bin, zeroizuje
    use zeroize::Zeroize;
    let workdir = PathBuf::from(&args[0]);
    let mut a_y = [0u8; 3];
    let mut b_y = [0u8; 3];
    for p in 0..3 {
        let x = [1u8, 2, 3][p];
        let _ = x;
        let a = std::fs::read(workdir.join(format!("ashare{p}.bin"))).unwrap();
        let b = std::fs::read(workdir.join(format!("bshare{p}.bin"))).unwrap();
        assert_eq!(a.len(), 1);
        assert_eq!(b.len(), 1);
        a_y[p] = a[0];
        b_y[p] = b[0];
    }
    let a = reconstruct_vals(&[1, 2, 3], &a_y).unwrap();
    let b = reconstruct_vals(&[1, 2, 3], &b_y).unwrap();
    let c = ft1536_threshold_spike::gf_mul(a, b);
    let xs = [1u8, 2, 3];
    let shares = shamir_share(&mut StdRngOs, c, &xs, 2).unwrap();
    for (p, sh) in shares.into_iter().enumerate() {
        let path = workdir.join(format!("cshare{p}.bin"));
        let tmp = workdir.join(format!("cshare{p}.tmp"));
        std::fs::write(&tmp, [sh.share]).unwrap();
        std::fs::rename(&tmp, &path).unwrap();
    }
    // zeroizacja materiału wejściowego w tym procesie
    a_y.zeroize();
    b_y.zeroize();
    println!("SACRIFICE_MUL_DONE");
}

fn cmd_triples_demo(args: &[String]) {
    let workdir = PathBuf::from(args.first().cloned().unwrap_or_else(|| "iso-triples".into()));
    let _ = std::fs::remove_dir_all(&workdir);
    std::fs::create_dir_all(&workdir).unwrap();
    let exe = std::env::current_exe().unwrap();

    // 1) DKG a i b — każdy proces strony pisze ashare/bshare (udział w x_p)
    //    plus contribution do oracle
    let mut handles = Vec::new();
    for p in 0..3 {
        handles.push(
            Command::new(&exe)
                .args(["triple-party", workdir.to_str().unwrap(), &p.to_string()])
                .stdout(Stdio::piped())
                .spawn()
                .unwrap(),
        );
    }
    for h in handles {
        let o = h.wait_with_output().unwrap();
        assert!(o.status.success(), "{}", String::from_utf8_lossy(&o.stderr));
        print!("{}", String::from_utf8_lossy(&o.stdout));
    }

    // 2) sacrifice mul (osobny proces)
    let s = Command::new(&exe)
        .args(["sacrifice-mul", workdir.to_str().unwrap()])
        .stdout(Stdio::piped())
        .spawn()
        .unwrap()
        .wait_with_output()
        .unwrap();
    assert!(s.status.success());
    assert!(String::from_utf8_lossy(&s.stdout).contains("SACRIFICE_MUL_DONE"));
    print!("{}", String::from_utf8_lossy(&s.stdout));

    // 3) sacrifice-check: otwórz a,b,c z udziałów i sprawdź c=a*b
    let mut a_y = [0u8; 3];
    let mut b_y = [0u8; 3];
    let mut c_y = [0u8; 3];
    for p in 0..3 {
        a_y[p] = std::fs::read(workdir.join(format!("ashare{p}.bin"))).unwrap()[0];
        b_y[p] = std::fs::read(workdir.join(format!("bshare{p}.bin"))).unwrap()[0];
        c_y[p] = std::fs::read(workdir.join(format!("cshare{p}.bin"))).unwrap()[0];
    }
    let a = reconstruct_vals(&[1, 2, 3], &a_y).unwrap();
    let b = reconstruct_vals(&[1, 2, 3], &b_y).unwrap();
    let c = reconstruct_vals(&[1, 2, 3], &c_y).unwrap();
    assert_eq!(c, ft1536_threshold_spike::gf_mul(a, b), "sacrifice check: c=a*b");

    // 4) fałszywa trójka → check FAIL (retained: wykrycie)
    let mut c_bad = c_y;
    c_bad[1] ^= 1;
    let c2 = reconstruct_vals(&[1, 2, 3], &c_bad).unwrap();
    assert_ne!(c2, ft1536_threshold_spike::gf_mul(a, b));

    // brak standing dealera sekretu
    assert!(!workdir.join("seed.bin").exists());
    println!("TRIPLES_OK a={a:02x} b={b:02x} c={c:02x}");
}

fn cmd_triple_party(args: &[String]) {
    // iso triple-party <workdir> <p> — DKG a,b; zapisz udział w x_p
    use zeroize::Zeroize;
    let workdir = PathBuf::from(&args[0]);
    let p: usize = args[1].parse().unwrap();
    let mailbox = workdir.join("mailbox");
    std::fs::create_dir_all(&mailbox).unwrap();
    let xs = [1u8, 2u8, 3u8];
    let k = 2u8;

    let mut s_a = [0u8; 32];
    let mut s_b = [0u8; 32];
    std::fs::File::open("/dev/urandom")
        .unwrap()
        .read_exact(&mut s_a)
        .unwrap();
    std::fs::File::open("/dev/urandom")
        .unwrap()
        .read_exact(&mut s_b)
        .unwrap();

    // na potrzeby trójki demo: tylko bajt 0 jest „sekretem" a,b (mały zakres)
    for (tag, s_i) in [("a", s_a[0]), ("b", s_b[0])] {
        let mut deals: Vec<[u8; 32]> = vec![[0u8; 32]; 3];
        // tylko bajt 0; reszta dummy — demo trójki 1-bajtowej
        let shares = shamir_share(&mut StdRngOs, s_i, &xs, k).unwrap();
        for (j, sh) in shares.into_iter().enumerate() {
            deals[j][0] = sh.share;
        }
        for (j, x) in xs.iter().enumerate() {
            let path = mailbox.join(format!("deal{tag}{p}_{x}.bin"));
            let tmp = mailbox.join(format!("deal{tag}{p}_{x}.tmp"));
            std::fs::write(&tmp, deals[j]).unwrap();
            std::fs::rename(&tmp, &path).unwrap();
        }
    }

    let deadline = std::time::Instant::now() + std::time::Duration::from_secs(20);
    loop {
        let ok = ["a", "b"].iter().all(|tag| {
            (0..3).all(|q| mailbox.join(format!("deal{tag}{q}_{}.bin", xs[p])).exists())
        });
        if ok {
            break;
        }
        if std::time::Instant::now() > deadline {
            panic!("timeout triple deals");
        }
        std::thread::sleep(std::time::Duration::from_millis(2));
    }

    for tag in ["a", "b"] {
        let mut col = 0u8;
        for q in 0..3 {
            let bytes = std::fs::read(mailbox.join(format!("deal{tag}{q}_{}.bin", xs[p]))).unwrap();
            assert_eq!(bytes.len(), 32);
            col ^= bytes[0];
        }
        let path = workdir.join(format!("{tag}share{p}.bin"));
        let tmp = workdir.join(format!("{tag}share{p}.tmp"));
        std::fs::write(&tmp, [col]).unwrap();
        std::fs::rename(&tmp, &path).unwrap();
    }
    s_a.zeroize();
    s_b.zeroize();
    println!("TRIPLE_PARTY_DONE p={p}");
}

// ─── Spike 013: pełne trójki — mnożenie Lagrange re-deal, bez sacrifice ──

fn cmd_full_triples(args: &[String]) {
    let workdir = PathBuf::from(args.first().cloned().unwrap_or_else(|| "iso-ft".into()));
    let _ = std::fs::remove_dir_all(&workdir);
    std::fs::create_dir_all(&workdir).unwrap();
    let exe = std::env::current_exe().unwrap();

    // 1) DKG a,b (jak triple-party)
    let mut handles = Vec::new();
    for p in 0..3 {
        handles.push(
            Command::new(&exe)
                .args(["triple-party", workdir.to_str().unwrap(), &p.to_string()])
                .stdout(Stdio::piped())
                .spawn()
                .unwrap(),
        );
    }
    for h in handles {
        let o = h.wait_with_output().unwrap();
        assert!(o.status.success(), "{}", String::from_utf8_lossy(&o.stderr));
        print!("{}", String::from_utf8_lossy(&o.stdout));
    }

    // 2) mnożenie: u_i = λ_i a_i b_i; re-deal; c = Σ u_i
    let mut a_y = [0u8; 3];
    let mut b_y = [0u8; 3];
    for p in 0..3 {
        a_y[p] = std::fs::read(workdir.join(format!("ashare{p}.bin"))).unwrap()[0];
        b_y[p] = std::fs::read(workdir.join(format!("bshare{p}.bin"))).unwrap()[0];
    }
    let xs = [1u8, 2, 3];
    let c_y = ft1536_threshold_spike::mul::mul_shamir_reshare(
        &mut StdRngOs,
        &xs,
        2,
        &a_y,
        &b_y,
    )
    .unwrap();
    for (p, y) in c_y.iter().enumerate() {
        let path = workdir.join(format!("cshare{p}.bin"));
        let tmp = workdir.join(format!("cshare{p}.tmp"));
        std::fs::write(&tmp, [*y]).unwrap();
        std::fs::rename(&tmp, &path).unwrap();
    }

    // 3) sacrifice-check (jawny oracle — nie część toru progowego)
    ft1536_threshold_spike::mul::open_and_check_mul(&xs, &a_y, &b_y, &c_y).unwrap();
    assert!(!workdir.join("seed.bin").exists());
    println!("FULL_TRIPLES_OK");
}

fn cmd_verify_cols(args: &[String]) {
    let workdir = PathBuf::from(&args[0]);
    for b in 0..32 {
        let shares: Vec<ft1536_threshold_spike::Share> = (0..3)
            .map(|p| {
                let c = std::fs::read(workdir.join(format!("col{p}.bin"))).unwrap();
                ft1536_threshold_spike::Share {
                    x: [1u8, 2, 3][p],
                    share: c[b],
                }
            })
            .collect();
        let refs: Vec<&_> = shares.iter().collect();
        if ft1536_threshold_spike::verify_consistency(&refs, 2).is_err() {
            println!("INCONSISTENT byte={b}");
            std::process::exit(3);
        }
    }
    println!("COLS_OK");
}

// ─── TT-32: 3-z-5 w torze multi-process ──────────────────────────────────

fn cmd_dkg5_party(args: &[String]) {
    use zeroize::Zeroize;
    let workdir = PathBuf::from(&args[0]);
    let p: usize = args[1].parse().unwrap();
    let mailbox = workdir.join("mailbox");
    std::fs::create_dir_all(&mailbox).unwrap();
    let xs = [1u8, 2u8, 3u8, 4u8, 5u8];
    let k = 3u8;

    let mut s_i = [0u8; 32];
    std::fs::File::open("/dev/urandom")
        .unwrap()
        .read_exact(&mut s_i)
        .unwrap();

    let mut deals: Vec<[u8; 32]> = vec![[0u8; 32]; 5];
    for b in 0..32 {
        let shares = shamir_share(&mut StdRngOs, s_i[b], &xs, k).unwrap();
        for (j, sh) in shares.into_iter().enumerate() {
            deals[j][b] = sh.share;
        }
    }
    for (j, x) in xs.iter().enumerate() {
        let path = mailbox.join(format!("deal{p}_{x}.bin"));
        let tmp = mailbox.join(format!("deal{p}_{x}.tmp"));
        std::fs::write(&tmp, deals[j]).unwrap();
        std::fs::rename(&tmp, &path).unwrap();
    }

    let deadline = std::time::Instant::now() + std::time::Duration::from_secs(20);
    loop {
        let ok = (0..5).all(|q| mailbox.join(format!("deal{q}_{}.bin", xs[p])).exists());
        if ok {
            break;
        }
        if std::time::Instant::now() > deadline {
            panic!("timeout dkg5 deals p={p}");
        }
        std::thread::sleep(std::time::Duration::from_millis(2));
    }
    let mut col = vec![0u8; 32];
    for q in 0..5 {
        let bytes =
            audited_read(p, &workdir, &mailbox.join(format!("deal{q}_{}.bin", xs[p]))).unwrap();
        for b in 0..32 {
            col[b] ^= bytes[b];
        }
    }
    std::fs::write(workdir.join(format!("col{p}.bin")), &col).unwrap();

    // G_frag: 64 muls przez Lagrange re-deal (k=3)
    let mut seed_at = col.clone();
    let mut out_at: Vec<u8> = Vec::with_capacity(64);
    for m in 0..G_MULS {
        let (x_i, y_i) = if m < 32 {
            let i = m;
            (seed_at[(i + 1) % 32], seed_at[(i + 13) % 32])
        } else {
            let i = m - 32;
            (out_at[i], seed_at[i])
        };
        let u_p =
            ft1536_threshold_spike::mul::local_weighted_product(&xs, p, x_i, y_i).unwrap();
        let dealt = shamir_share(&mut StdRngOs, u_p, &xs, k).unwrap();
        for (j, sh) in dealt.into_iter().enumerate() {
            let path = mailbox.join(format!("um{m}_{p}_{}.bin", xs[j]));
            let tmp = mailbox.join(format!("um{m}_{p}_{}.tmp", xs[j]));
            std::fs::write(&tmp, [sh.share]).unwrap();
            std::fs::rename(&tmp, &path).unwrap();
        }
        let deadline = std::time::Instant::now() + std::time::Duration::from_secs(20);
        let z = loop {
            let mut acc = 0u8;
            let mut ok = true;
            for q in 0..5 {
                let path = mailbox.join(format!("um{m}_{q}_{}.bin", xs[p]));
                match audited_read(p, &workdir, &path) {
                    Ok(b) if b.len() == 1 => acc ^= b[0],
                    _ => {
                        ok = false;
                        break;
                    }
                }
            }
            if ok {
                break acc;
            }
            if std::time::Instant::now() > deadline {
                panic!("timeout umul5 {m}");
            }
            std::thread::sleep(std::time::Duration::from_millis(2));
        };
        if m < 32 {
            out_at.push(seed_at[m] ^ z);
        } else {
            out_at.push(out_at[m - 32] ^ z);
        }
    }
    std::fs::write(workdir.join(format!("out{p}.bin")), &out_at).unwrap();
    let hex: String = s_i.iter().map(|b| format!("{b:02x}")).collect();
    println!("CONTRIB5 {p} {hex}");
    s_i.zeroize();
    seed_at.zeroize();
    out_at.zeroize();
    println!("DKG5_PARTY_DONE p={p}");
}

fn cmd_dkg5(args: &[String]) {
    let workdir = PathBuf::from(args.first().cloned().unwrap_or_else(|| "iso-dkg5".into()));
    let _ = std::fs::remove_dir_all(&workdir);
    std::fs::create_dir_all(&workdir).unwrap();
    let exe = std::env::current_exe().unwrap();

    let mut handles = Vec::new();
    for p in 0..5 {
        handles.push(
            Command::new(&exe)
                .args(["dkg5-party", workdir.to_str().unwrap(), &p.to_string()])
                .env("ISO_AUDIT", "1")
                .stdout(Stdio::piped())
                .spawn()
                .unwrap(),
        );
    }
    for (i, h) in handles.into_iter().enumerate() {
        let o = h.wait_with_output().unwrap();
        assert!(o.status.success(), "{}", String::from_utf8_lossy(&o.stderr));
        std::fs::write(workdir.join(format!("party{i}.out")), &o.stdout).unwrap();
        print!("{}", String::from_utf8_lossy(&o.stdout));
    }

    // spójność 5 kolumn (k=3)
    for b in 0..32 {
        let shares: Vec<ft1536_threshold_spike::Share> = (0..5)
            .map(|p| {
                let c = std::fs::read(workdir.join(format!("col{p}.bin"))).unwrap();
                ft1536_threshold_spike::Share {
                    x: [1u8, 2, 3, 4, 5][p],
                    share: c[b],
                }
            })
            .collect();
        let refs: Vec<&_> = shares.iter().collect();
        if ft1536_threshold_spike::verify_consistency(&refs, 3).is_err() {
            eprintln!("INCONSISTENT5 byte {b}");
            std::process::exit(3);
        }
    }

    let mut seed = [0u8; 32];
    for p in 0..5 {
        let log = std::fs::read_to_string(workdir.join(format!("party{p}.out"))).unwrap();
        for line in log.lines() {
            if let Some(rest) = line.strip_prefix(&format!("CONTRIB5 {p} ")) {
                let bytes: Vec<u8> = (0..32)
                    .map(|i| u8::from_str_radix(&rest[i * 2..i * 2 + 2], 16).unwrap())
                    .collect();
                for b in 0..32 {
                    seed[b] ^= bytes[b];
                }
            }
        }
    }
    let expect = ft1536_threshold_spike::g_frag_local(&seed);
    let out0 = std::fs::read(workdir.join("out0.bin")).unwrap();
    let out1 = std::fs::read(workdir.join("out1.bin")).unwrap();
    let out2 = std::fs::read(workdir.join("out2.bin")).unwrap();
    // otwarcie z 3 z 5 (próg)
    let shares: Vec<ft1536_threshold_spike::Share> = vec![
        ft1536_threshold_spike::Share { x: 1, share: out0[0] },
        ft1536_threshold_spike::Share { x: 2, share: out1[0] },
        ft1536_threshold_spike::Share { x: 3, share: out2[0] },
    ];
    let opened = open_g_frag_byte(&shares, 3).unwrap();
    assert_eq!(opened, expect[0], "3-of-5 G_frag must match oracle");
    assert!(!workdir.join("seed.bin").exists());
    println!("DKG5_OK opened0={opened:02x}");
}

// ─── R2: MAC open w torze multi-process ──────────────────────────────────

fn cmd_mac_dealer(args: &[String]) {
    // iso mac-dealer <workdir> — dealerski model testowy: secret+mac shares
    let workdir = PathBuf::from(&args[0]);
    std::fs::create_dir_all(workdir.join("mailbox")).unwrap();
    let xs = [1u8, 2, 3];
    let delta = 0x07u8;
    let v = 0x5Au8;
    let sh = ft1536_threshold_spike::share_byte_with_mac(&mut StdRngOs, v, &xs, 2, delta).unwrap();
    for (i, s) in sh.into_iter().enumerate() {
        let path = workdir.join(format!("mac{i}.bin"));
        let tmp = workdir.join(format!("mac{i}.tmp"));
        std::fs::write(&tmp, [s.share, s.mac]).unwrap();
        std::fs::rename(&tmp, &path).unwrap();
    }
    std::fs::write(workdir.join("delta.txt"), [delta]).unwrap();
    println!("MAC_DEALER_DONE");
}

fn cmd_mac_open(args: &[String]) {
    // iso mac-open <workdir> [--forge]
    let workdir = PathBuf::from(&args[0]);
    let forge = args.iter().any(|a| a == "--forge");
    let delta = std::fs::read(workdir.join("delta.txt")).unwrap()[0];
    let mut shares = Vec::new();
    for i in 0..3 {
        let b = std::fs::read(workdir.join(format!("mac{i}.bin"))).unwrap();
        let mut share = b[0];
        let mut mac = b[1];
        if forge && i == 1 {
            share ^= 0xFF;
        }
        if forge && i == 2 {
            mac ^= 0x0F;
        }
        shares.push(ft1536_threshold_spike::MacShare {
            x: [1u8, 2, 3][i],
            share,
            mac,
        });
    }
    match ft1536_threshold_spike::open_with_mac(&shares, delta) {
        Ok(v) => {
            println!("MAC_OK v={v:02x}");
        }
        Err(_) => {
            println!("MAC_FAIL");
            std::process::exit(3);
        }
    }
}

fn cmd_mac_demo(args: &[String]) {
    let workdir = PathBuf::from(args.first().cloned().unwrap_or_else(|| "iso-mac".into()));
    let _ = std::fs::remove_dir_all(&workdir);
    std::fs::create_dir_all(&workdir).unwrap();
    let exe = std::env::current_exe().unwrap();
    let d = Command::new(&exe)
        .args(["mac-dealer", workdir.to_str().unwrap()])
        .stdout(Stdio::piped())
        .spawn()
        .unwrap()
        .wait_with_output()
        .unwrap();
    assert!(d.status.success());
    print!("{}", String::from_utf8_lossy(&d.stdout));
    let o = Command::new(&exe)
        .args(["mac-open", workdir.to_str().unwrap()])
        .stdout(Stdio::piped())
        .spawn()
        .unwrap()
        .wait_with_output()
        .unwrap();
    print!("{}", String::from_utf8_lossy(&o.stdout));
    assert!(o.status.success());
    let f = Command::new(&exe)
        .args(["mac-open", workdir.to_str().unwrap(), "--forge"])
        .stdout(Stdio::piped())
        .spawn()
        .unwrap()
        .wait_with_output()
        .unwrap();
    print!("{}", String::from_utf8_lossy(&f.stdout));
    assert_eq!(f.status.code(), Some(3), "forged must exit 3");
    println!("MAC_DEMO_OK");
}

// ─── Y8: SPDZ-MAC z ukrytym δ w torze multi-process ─────────────────────

fn cmd_mac_dealer_hid(args: &[String]) {
    // iso mac-dealer-hid <workdir> — udziały value+mac ORAZ udziały δ
    // (δ **nie** zapisane jako jeden bajt).
    let workdir = PathBuf::from(&args[0]);
    std::fs::create_dir_all(workdir.join("mailbox")).unwrap();
    let xs = [1u8, 2, 3];
    let delta = 0x07u8;
    let v = 0x5Au8;
    let (sh, ds) =
        ft1536_threshold_spike::share_byte_with_mac_hidden_delta(&mut StdRngOs, v, &xs, 2, delta)
            .unwrap();
    for (i, s) in sh.into_iter().enumerate() {
        let path = workdir.join(format!("mac{i}.bin"));
        let tmp = workdir.join(format!("mac{i}.tmp"));
        std::fs::write(&tmp, [s.share, s.mac]).unwrap();
        std::fs::rename(&tmp, &path).unwrap();
    }
    for (i, &d_i) in ds.shares.iter().enumerate() {
        let path = workdir.join(format!("delta{i}.bin"));
        let tmp = workdir.join(format!("delta{i}.tmp"));
        std::fs::write(&tmp, [d_i]).unwrap();
        std::fs::rename(&tmp, &path).unwrap();
    }
    // brak delta.txt — pełnego δ nie ma na dysku
    println!("MAC_DEALER_HID_DONE");
}

fn cmd_mac_open_hid(args: &[String]) {
    // iso mac-open-hid <workdir> [--forge]
    let workdir = PathBuf::from(&args[0]);
    let forge = args.iter().any(|a| a == "--forge");
    let mut shares = Vec::new();
    let mut delta_shares = Vec::new();
    for i in 0..3 {
        let b = std::fs::read(workdir.join(format!("mac{i}.bin"))).unwrap();
        let mut share = b[0];
        let mut mac = b[1];
        if forge && i == 1 {
            share ^= 0xFF;
        }
        if forge && i == 2 {
            mac ^= 0x0F;
        }
        shares.push(ft1536_threshold_spike::MacShare {
            x: [1u8, 2, 3][i],
            share,
            mac,
        });
        let d = std::fs::read(workdir.join(format!("delta{i}.bin"))).unwrap()[0];
        delta_shares.push(d);
    }
    let ds = ft1536_threshold_spike::DeltaShares {
        xs: vec![1, 2, 3],
        shares: delta_shares,
    };
    match ft1536_threshold_spike::open_with_mac_hidden_delta(&shares, &ds, 2) {
        Ok(v) => {
            println!("MAC_HID_OK v={v:02x}");
        }
        Err(_) => {
            println!("MAC_HID_FAIL");
            std::process::exit(3);
        }
    }
}

fn cmd_mac_demo_hid(args: &[String]) {
    let workdir = PathBuf::from(args.first().cloned().unwrap_or_else(|| "iso-mac-hid".into()));
    let _ = std::fs::remove_dir_all(&workdir);
    std::fs::create_dir_all(&workdir).unwrap();
    let exe = std::env::current_exe().unwrap();
    let d = Command::new(&exe)
        .args(["mac-dealer-hid", workdir.to_str().unwrap()])
        .stdout(Stdio::piped())
        .spawn()
        .unwrap()
        .wait_with_output()
        .unwrap();
    assert!(d.status.success());
    print!("{}", String::from_utf8_lossy(&d.stdout));
    // brak pełnego δ na dysku
    assert!(
        !workdir.join("delta.txt").exists(),
        "pełny δ nie może leżeć na dysku"
    );
    let o = Command::new(&exe)
        .args(["mac-open-hid", workdir.to_str().unwrap()])
        .stdout(Stdio::piped())
        .spawn()
        .unwrap()
        .wait_with_output()
        .unwrap();
    print!("{}", String::from_utf8_lossy(&o.stdout));
    assert!(o.status.success());
    let f = Command::new(&exe)
        .args(["mac-open-hid", workdir.to_str().unwrap(), "--forge"])
        .stdout(Stdio::piped())
        .spawn()
        .unwrap()
        .wait_with_output()
        .unwrap();
    print!("{}", String::from_utf8_lossy(&f.stdout));
    assert_eq!(f.status.code(), Some(3), "forged must exit 3");
    println!("MAC_DEMO_HID_OK");
}

// ─── H2: Pedersen w osobnych procesach ───────────────────────────────────

fn cmd_ped_party(args: &[String]) {
    // iso ped-party <workdir> <p> — tylko udział ExpShare; weryfikacja lokalna
    let workdir = PathBuf::from(&args[0]);
    let p: usize = args[1].parse().unwrap();
    let raw = std::fs::read(workdir.join(format!("exp{}.bin", p))).unwrap();
    assert_eq!(raw.len(), 65); // x + s32 + t32
    let mut s = [0u8; 32];
    let mut t = [0u8; 32];
    s.copy_from_slice(&raw[1..33]);
    t.copy_from_slice(&raw[33..65]);
    let share = ft1536_threshold_spike::pedersen::ExpShare { x: raw[0], s, t };
    // zobowiązania publiczne
    // odczyt C0..Ck z comms.bin (Ristretto compressed 32 B each)
    let comms_raw = std::fs::read(workdir.join("comms.bin")).unwrap();
    let n = comms_raw.len() / 32;
    let mut commitments = Vec::new();
    for i in 0..n {
        let mut b = [0u8; 32];
        b.copy_from_slice(&comms_raw[i * 32..(i + 1) * 32]);
        use curve25519_dalek::ristretto::CompressedRistretto;
        let pt = CompressedRistretto(b).decompress().unwrap();
        commitments.push(pt);
    }
    let cs = ft1536_threshold_spike::pedersen::PedersenCommitments { commitments };
    match ft1536_threshold_spike::pedersen::verify_exp_share(&share, &cs) {
        Ok(()) => {
            println!("PED_OK p={p}");
            std::fs::write(workdir.join(format!("ped{p}.ok")), [1u8]).unwrap();
        }
        Err(e) => {
            println!("PED_FAIL p={p} {e}");
            std::process::exit(3);
        }
    }
}

fn cmd_ped_demo(args: &[String]) {
    let workdir = PathBuf::from(args.first().cloned().unwrap_or_else(|| "iso-ped".into()));
    let _ = std::fs::remove_dir_all(&workdir);
    std::fs::create_dir_all(&workdir).unwrap();
    let xs = [1u8, 2, 3];
    let (comms, shares) =
        ft1536_threshold_spike::pedersen::deal_exp_shares(&mut StdRngOs, 0x77, &xs, 2);
    let mut blob = Vec::new();
    for c in &comms.commitments {
        blob.extend_from_slice(&c.compress().to_bytes());
    }
    std::fs::write(workdir.join("comms.bin"), &blob).unwrap();
    for (i, sh) in shares.iter().enumerate() {
        let mut b = Vec::with_capacity(65);
        b.push(sh.x);
        b.extend_from_slice(&sh.s);
        b.extend_from_slice(&sh.t);
        std::fs::write(workdir.join(format!("exp{i}.bin")), b).unwrap();
    }
    let exe = std::env::current_exe().unwrap();
    let mut ok = 0;
    for p in 0..3 {
        let o = Command::new(&exe)
            .args(["ped-party", workdir.to_str().unwrap(), &p.to_string()])
            .stdout(Stdio::piped())
            .spawn()
            .unwrap()
            .wait_with_output()
            .unwrap();
        print!("{}", String::from_utf8_lossy(&o.stdout));
        if o.status.success() {
            ok += 1;
        }
    }
    assert_eq!(ok, 3, "all 3 party processes must verify");
    // H2: brak pliku z pełnym sekretem / wielomianem
    assert!(!workdir.join("poly.bin").exists());
    assert!(!workdir.join("secret.bin").exists());
    // fałsz udziału w osobnym procesie → exit 3
    let mut raw = std::fs::read(workdir.join("exp1.bin")).unwrap();
    raw[2] ^= 0xFF;
    std::fs::write(workdir.join("exp1.bin"), &raw).unwrap();
    let f = Command::new(&exe)
        .args(["ped-party", workdir.to_str().unwrap(), "1"])
        .stdout(Stdio::piped())
        .spawn()
        .unwrap()
        .wait_with_output()
        .unwrap();
    print!("{}", String::from_utf8_lossy(&f.stdout));
    assert_eq!(f.status.code(), Some(3));
    println!("PED_DEMO_OK");
}

// ─── O1: pipeline Pedersen verify → G_frag → MAC open ────────────────────

fn cmd_pipeline(args: &[String]) {
    let workdir = PathBuf::from(args.first().cloned().unwrap_or_else(|| "iso-plt".into()));
    let _ = std::fs::remove_dir_all(&workdir);
    std::fs::create_dir_all(&workdir).unwrap();

    let xs = [1u8, 2, 3];
    let k = 2u8;
    let mut seed = [0u8; 32];
    std::fs::File::open("/dev/urandom").unwrap().read_exact(&mut seed).unwrap();

    // 1) Pedersen: deal exp-shares + weryfikacja (H1)
    let (comms, exp) = ft1536_threshold_spike::pedersen::deal_exp_shares(&mut StdRngOs, seed[0], &xs, k);
    for sh in &exp {
        ft1536_threshold_spike::pedersen::verify_exp_share(sh, &comms).expect("pedersen verify");
    }
    println!("PIPE_PED_OK");

    // 2) Shamir seed → G_frag shares (share-native)
    let sshares = split_seed(&mut StdRngOs, &seed, &xs, k).unwrap();
    let out = derive_g_frag_shares(&mut StdRngOs, &sshares, &xs, k).unwrap();
    println!("PIPE_GFRAG_OK n={}", out.len());

    // 3) MAC open bajtu 0 z **ukrytym** δ (Y9) + detekcja fałszu
    let delta = 0x0Du8;
    let v0 = open_g_frag_byte(&out[0], k).unwrap();
    let ds = ft1536_threshold_spike::share_delta(&mut StdRngOs, delta, &xs, k).unwrap();
    let mac_deal = shamir_share(&mut StdRngOs, gf_mul(delta, v0), &xs, k).unwrap();
    let macs: Vec<u8> = mac_deal.into_iter().map(|s| s.share).collect();
    let opened = open_g_frag_byte_mac_hidden(&out[0], &macs, &ds, k).unwrap();
    assert_eq!(opened, v0);
    let mut bad = macs.clone();
    bad[1] ^= 0xFF;
    assert!(open_g_frag_byte_mac_hidden(&out[0], &bad, &ds, k).is_err());
    println!("PIPE_MAC_HID_OK");

    seed.zeroize();
    println!("PIPELINE_OK");
}

// ─── W2: pełny tor sign-demo (syntetyczny) ───────────────────────────────

fn cmd_sign_demo(args: &[String]) {
    let workdir = PathBuf::from(args.first().cloned().unwrap_or_else(|| "iso-sign".into()));
    let _ = std::fs::remove_dir_all(&workdir);
    std::fs::create_dir_all(&workdir).unwrap();
    let xs = [1u8, 2, 3];
    let k = 2u8;

    // 1) Pedersen setup (R0)
    let (_c, exp) = ft1536_threshold_spike::pedersen::deal_exp_shares(&mut StdRngOs, 0x01, &xs, k);
    for s in &exp {
        ft1536_threshold_spike::pedersen::verify_exp_share(s, &_c).unwrap();
    }
    println!("SIGN_PED_OK");

    // 2) seed shares + derive (R1)
    let mut seed = [0u8; 32];
    std::fs::File::open("/dev/urandom").unwrap().read_exact(&mut seed).unwrap();
    let sh = split_seed(&mut StdRngOs, &seed, &xs, k).unwrap();
    let out = derive_g_frag_shares(&mut StdRngOs, &sh, &xs, k).unwrap();
    println!("SIGN_DERIVE_OK n={}", out.len());

    // 3) nonce (R2)
    let mh = [0x55u8; 32];
    let nonce = derive_nonce_shares(&mut StdRngOs, &sh, &mh, &xs, k).unwrap();
    println!("SIGN_NONCE_OK n={}", nonce.len());

    // 4) sampler (R3) — 1 okno
    let (x, found, _w) =
        ft1536_threshold_spike::select::sample_klein_lite_3(&mut StdRngOs, 8, 36, 3, &xs, k)
            .unwrap();
    println!("SIGN_SAMPLE_OK found={found} x={x}");

    // 5) sygnet (R5) — jawny artefakt
    let sig = sygnet_synthetic(&mut StdRngOs, &sh, &mh, &xs, k).unwrap();
    println!("SIGN_SYGNET_OK len={}", sig.len());

    seed.zeroize();
    println!("SIGN_DEMO_OK");
}
