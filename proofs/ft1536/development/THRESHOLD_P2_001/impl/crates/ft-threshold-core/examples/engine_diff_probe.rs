//! WP-023 — differential probe po stronie Rust (FT1536, ternary logn=10).
//!
//! Ten przykład NIE jest częścią API protokołu. Liczy te same przypadki co
//! `impl/ci/engine_diff/probe_engine.c` (silnik C) i zapisuje identyczny
//! format binarny; `run.py` porównuje oba pliki bajt po bajcie.
//!
//! Format: nagłówek 44 B (`FTDIF01\0`, wersja, n, q, cases, kinds, seed),
//! a po nim `kinds × cases` 32-bajtowych SHAKE256 z serializacji wyniku
//! (u16 little-endian). Kategorie: `hash_to_point`, NTT, iNTT oraz
//! mnożenie w `R_q` ścieżką NTT.
//!
//! ```text
//! cargo run -p ft-threshold-core --example engine_diff_probe --offline -- \
//!     --out .build/engine_diff/rust.bin --cases 2500
//! ```

use std::env;
use std::fs::File;
use std::io::{BufWriter, Write};
use std::process::ExitCode;

use ft_threshold_core::ntt;
use ft_threshold_core::ring::{N, Poly, Q};
use ft_threshold_core::shake;

const KINDS: u32 = 4;
const DEFAULT_CASES: u32 = 2500;
const SEED: u64 = 0x9e37_79b9_7f4a_7c15;
const KIND_SALT: u64 = 0xd1b5_4a32_d192_ed03;

struct Rng(u64);

impl Rng {
    fn new(kind: u32) -> Self {
        Self(SEED ^ KIND_SALT.wrapping_mul(u64::from(kind)))
    }

    fn next_u64(&mut self) -> u64 {
        let mut x = self.0;
        x ^= x << 13;
        x ^= x >> 7;
        x ^= x << 17;
        self.0 = x;
        x
    }

    fn coeff(&mut self) -> u16 {
        u16::try_from(self.next_u64() % u64::from(Q)).expect("coefficient < q")
    }

    fn fill(&mut self, out: &mut [u8]) {
        for chunk in out.chunks_mut(8) {
            let w = self.next_u64();
            for (j, b) in chunk.iter_mut().enumerate() {
                *b = u8::try_from((w >> (8 * j)) & 0xff).expect("byte");
            }
        }
    }
}

fn digest(p: &Poly) -> [u8; 32] {
    let bytes = p.to_le_bytes();
    let mut out = [0u8; 32];
    shake::shake256(&bytes, &mut out);
    out
}

fn poly_from(rng: &mut Rng) -> Poly {
    let mut coeffs = [0u16; N];
    for c in &mut coeffs {
        *c = rng.coeff();
    }
    Poly::from_coeffs(&coeffs).expect("coefficients < q")
}

fn main() -> ExitCode {
    let mut args = env::args().skip(1);
    let mut out_path: Option<String> = None;
    let mut cases = DEFAULT_CASES;
    while let Some(arg) = args.next() {
        match arg.as_str() {
            "--out" => match args.next() {
                Some(v) => out_path = Some(v),
                None => {
                    eprintln!("engine_diff_probe: --out requires a path");
                    return ExitCode::FAILURE;
                }
            },
            "--cases" => {
                let Some(v) = args.next() else {
                    eprintln!("engine_diff_probe: --cases requires a number");
                    return ExitCode::FAILURE;
                };
                match v.parse::<u32>() {
                    Ok(n) if (1..=100_000).contains(&n) => cases = n,
                    _ => {
                        eprintln!("engine_diff_probe: --cases out of range");
                        return ExitCode::FAILURE;
                    }
                }
            }
            other => {
                eprintln!("engine_diff_probe: unknown argument {other}");
                return ExitCode::FAILURE;
            }
        }
    }
    let Some(out_path) = out_path else {
        eprintln!("usage: engine_diff_probe --out OUT.bin [--cases N]");
        return ExitCode::FAILURE;
    };

    let file = match File::create(&out_path) {
        Ok(f) => f,
        Err(e) => {
            eprintln!("engine_diff_probe: cannot create {out_path}: {e}");
            return ExitCode::FAILURE;
        }
    };
    let mut out = BufWriter::new(file);

    let mut header = Vec::with_capacity(44);
    header.extend_from_slice(b"FTDIF01\0");
    header.extend_from_slice(&1u32.to_le_bytes());
    header.extend_from_slice(&u32::try_from(N).expect("N fits u32").to_le_bytes());
    header.extend_from_slice(&u32::from(Q).to_le_bytes());
    header.extend_from_slice(&cases.to_le_bytes());
    header.extend_from_slice(&KINDS.to_le_bytes());
    header.extend_from_slice(&SEED.to_le_bytes());
    if let Err(e) = out.write_all(&header) {
        eprintln!("engine_diff_probe: write header: {e}");
        return ExitCode::FAILURE;
    }

    for kind in 0..KINDS {
        let mut rng = Rng::new(kind);
        for _ in 0..cases {
            let d = match kind {
                0 => {
                    let mut nonce = [0u8; 16];
                    let mut msg = [0u8; 32];
                    rng.fill(&mut nonce);
                    rng.fill(&mut msg);
                    match shake::hash_to_point(&nonce, &msg) {
                        Ok(p) => digest(&p),
                        Err(e) => {
                            eprintln!("engine_diff_probe: hash_to_point: {e}");
                            return ExitCode::FAILURE;
                        }
                    }
                }
                1 => digest(&ntt::ntt(&poly_from(&mut rng))),
                2 => digest(&ntt::intt(&poly_from(&mut rng))),
                _ => {
                    let a = poly_from(&mut rng);
                    let b = poly_from(&mut rng);
                    digest(&ntt::mul(&a, &b))
                }
            };
            if let Err(e) = out.write_all(&d) {
                eprintln!("engine_diff_probe: write digest: {e}");
                return ExitCode::FAILURE;
            }
        }
    }

    if let Err(e) = out.flush() {
        eprintln!("engine_diff_probe: flush: {e}");
        return ExitCode::FAILURE;
    }
    ExitCode::SUCCESS
}
