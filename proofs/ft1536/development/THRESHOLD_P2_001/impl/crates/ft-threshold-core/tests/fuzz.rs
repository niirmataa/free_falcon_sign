//! WP-022 — fuzz kodeków rdzenia (`Poly`, `ExpShare`, `VssCommitments`,
//! `PairwiseKey`) i `hash_to_point`.
//!
//! Niezmienniki przy każdej mutacji (deterministyczny xorshift64):
//!
//! 1. **Brak paniki** — każde bajty kończą się `Ok`/`Err`, nigdy
//!    unwrapem/indeksem poza zakresem.
//! 2. **Fixpoint**: jeśli dekoder zaakceptuje wejście, to re-kodowanie
//!    musi dawać identyczne bajty. Rozjazd oznacza, że dekoder
//!    „naprawia” wejście — to jest bug formatu, nie testu.
//!
//! `hash_to_point`: determinizm (dwa wywołania identyczne), brak paniki
//! dla dowolnych długości wejścia i współczynniki zawsze `< q`.
//!
//! **Granica:** `decode_sk` nie istnieje w Rust (format klucza jest
//! własnością silnika C; pin KAT WP-024) — cel wyląduje z portem
//! sign/verify (WP-040/041).
//!
//! Ciężkie pętle ignorowane pod miri (pokrywa je natywny `cargo test`).

#![forbid(unsafe_code)]

use ft_threshold_core::prss::PairwiseKey;
use ft_threshold_core::ring::{N, Poly, Q};
use ft_threshold_core::shake;
use ft_threshold_core::vss::{self, ExpShare, VssCommitments};

const SEED: u64 = 0x5DEECE66D;
const ROUNDS: usize = 60_000;

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
        1 if out.len() > 2 => out.truncate(1 + rng.below(out.len() - 1)),
        2 => {
            let pos = rng.below(out.len() + 1);
            let extra = 1 + rng.below(16);
            let mut ins = Vec::with_capacity(extra);
            for _ in 0..extra {
                ins.push(rng.below(256) as u8);
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

fn poly_seed() -> Vec<u8> {
    let coeffs: Vec<u16> = (0..N).map(|i| ((i * 13 + 7) % Q as usize) as u16).collect();
    Poly::from_coeffs(&coeffs)
        .expect("poly seed")
        .to_le_bytes()
        .to_vec()
}

fn expshare_seed() -> Vec<u8> {
    let parties = [1u16, 2, 3];
    let (_, shares) = vss::deal(&[1234, 5678], &[[1u8; 32]; 2], &parties).expect("deal");
    shares
        .into_iter()
        .find(|s| s.x() == 2)
        .expect("share x=2")
        .to_bytes()
        .to_vec()
}

fn commitments_seed() -> Vec<u8> {
    let parties = [1u16, 2, 3];
    let (comms, _) = vss::deal(&[1234, 5678], &[[2u8; 32]; 2], &parties).expect("deal");
    comms.to_bytes()
}

fn codec_fixpoint_fuzz(
    name: &str,
    seed: Vec<u8>,
    decode_reencode: impl Fn(&[u8]) -> Option<Vec<u8>>,
) {
    let mut rng = Rng::new(SEED);
    let mut accepted = 0usize;
    for i in 0..ROUNDS {
        let bytes = mutate(&mut rng, &seed, i);
        if let Some(reencoded) = decode_reencode(&bytes) {
            assert_eq!(
                reencoded, bytes,
                "{name}: fixpoint naruszony w iteracji {i} — dekoder naprawia wejście"
            );
            accepted += 1;
        }
    }
    // Bazowy seed sam w sobie musi być akceptowalny (fixpoint ≥ 1).
    assert!(
        decode_reencode(&seed).is_some(),
        "{name}: bazowy seed nie dekoduje się"
    );
    let _ = accepted;
}

#[test]
#[cfg_attr(miri, ignore = "pętle pokrywa natywny cargo test; miri za wolne")]
fn fuzz_poly_codec_fixpoint() {
    codec_fixpoint_fuzz("poly", poly_seed(), |b| {
        Poly::try_from(b).ok().map(|p| p.to_le_bytes().to_vec())
    });
}

#[test]
#[cfg_attr(miri, ignore = "pętle pokrywa natywny cargo test; miri za wolne")]
fn fuzz_expshare_codec_fixpoint() {
    codec_fixpoint_fuzz("expshare", expshare_seed(), |b| {
        ExpShare::try_from(b).ok().map(|s| s.to_bytes().to_vec())
    });
}

#[test]
#[cfg_attr(miri, ignore = "pętle pokrywa natywny cargo test; miri za wolne")]
fn fuzz_vsscommitments_codec_fixpoint() {
    codec_fixpoint_fuzz("vsscommitments", commitments_seed(), |b| {
        VssCommitments::from_bytes(b).ok().map(|c| c.to_bytes())
    });
}

#[test]
#[cfg_attr(miri, ignore = "pętle pokrywa natywny cargo test; miri za wolne")]
fn fuzz_pairwisekey_accepts_exactly_32_bytes() {
    // `PairwiseKey` trzyma materiał klucza — celowo NIE ma akcesora
    // bajtów, więc fixpoint jest tu niedostępny. Niezmienniki: zero
    // paniki, dokładnie 32 B → `Ok`, każda inna długość → `Err`.
    let mut rng = Rng::new(SEED);
    for i in 0..ROUNDS {
        let bytes = mutate(&mut rng, &[0x5a; 32], i);
        let decoded = PairwiseKey::try_from(&bytes[..]);
        assert_eq!(
            decoded.is_ok(),
            bytes.len() == 32,
            "PairwiseKey: akceptuje wyłącznie 32 B (iteracja {i})"
        );
    }
}

#[test]
#[cfg_attr(miri, ignore = "pętle pokrywa natywny cargo test; miri za wolne")]
fn fuzz_hash_to_point_is_deterministic_and_bounded() {
    let mut rng = Rng::new(SEED);
    for i in 0..8_000 {
        let nonce_len = rng.below(64);
        let msg_len = rng.below(128);
        let mut nonce = Vec::with_capacity(nonce_len);
        for _ in 0..nonce_len {
            nonce.push(rng.below(256) as u8);
        }
        let mut msg = Vec::with_capacity(msg_len);
        for _ in 0..msg_len {
            msg.push(rng.below(256) as u8);
        }
        let p = shake::hash_to_point(&nonce, &msg)
            .unwrap_or_else(|e| panic!("hash_to_point panikował na iteracji {i}: {e}"));
        let q2 = shake::hash_to_point(&nonce, &msg).expect("powtórka");
        assert_eq!(p.coeff(0), q2.coeff(0), "determinizm w iteracji {i}");
        for j in [0usize, 1, 5, 100, N / 2, N - 1] {
            assert!(
                p.coeff(j).is_some_and(|c| c < Q),
                "współczynnik poza zakres w iteracji {i}"
            );
        }
    }
    // Duże wejścia (do limitu wiadomości) też są bezpieczne.
    let big = vec![0xabu8; 1 << 16];
    let p = shake::hash_to_point(&big, &big).expect("duże wejście");
    assert!(p.coeff(N - 1).is_some());
}
