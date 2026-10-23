//! MPS4-H pin — zakres i16 f,g,F,G na realnych kluczach engine.
//! Dowód do `MPS_H_NOTES.md` H-1: max|F| ≪ q/2 ⇒ z z H3 ≡ z z F2.

use ft1536_sys::Ft1536KeyPair;
use ft1536_threshold_spike::mpc_sign::{uncompress_static_n, FT1536_N};

#[test]
fn measure_fg_i16_range() {
    for (label, seed_byte) in [("seed0x42", 0x42u8), ("seed0x77", 0x77u8)] {
        let seed = [seed_byte; 32];
        let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
        let sk = kp.secret_key();
        let mut pos = 1usize;
        for name in ["f", "g", "F", "G"] {
            let rest = &sk[pos..];
            let (p, used) = uncompress_static_n(rest, FT1536_N).expect("decode");
            pos += used;
            let max_abs = p.iter().map(|&c| c.unsigned_abs() as i32).max().unwrap();
            println!("MEASURE {label} {name}: max_abs={max_abs}");
            // f,g ternary; F,G i16 (duże) — ale na FT1536 ≪ q/2=9216
            if name == "f" || name == "g" {
                assert!(max_abs <= 1, "{name} musi być ternary");
            } else {
                assert!(
                    max_abs < (18433i32) / 2,
                    "{label} {name}: max_abs={max_abs} ≥ q/2 (z≡clear nie gwarantowane)"
                );
            }
        }
    }
}
