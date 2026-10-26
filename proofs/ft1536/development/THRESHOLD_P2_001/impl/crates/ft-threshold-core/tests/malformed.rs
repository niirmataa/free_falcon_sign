//! WP-019: 10^6 deterministycznych danych zniekształconych — brak paniki.
//!
//! To **nie** jest coverage-guided fuzzing. Test miesza losowe bufory
//! (długość 0..4096) z mutacjami poprawnych serializacji i sprawdza, że
//! parsery zwracają `Ok`/`Err` zamiast panikować. Ziarno jest stałe, więc
//! wynik jest odtwarzalny; log czasu i liczby iteracji jest w dowodzie WP-019.

use ft_threshold_core::error::CoreError;
use ft_threshold_core::prss::PairwiseKey;
use ft_threshold_core::ring::{N, Poly, Q};
use ft_threshold_core::vss::{self, ExpShare, VssCommitments};

fn next(state: &mut u64) -> u64 {
    let mut x = *state;
    x ^= x << 13;
    x ^= x >> 7;
    x ^= x << 17;
    *state = x;
    x
}

fn mutate(st: &mut u64, valid: &[u8]) -> Vec<u8> {
    let mut out = valid.to_vec();
    let flips = 1 + (next(st) % 4) as usize;
    for _ in 0..flips {
        let idx = (next(st) as usize) % out.len();
        let bit = 1u8 << (next(st) % 8);
        out[idx] ^= bit;
    }
    out
}

#[test]
#[cfg_attr(
    miri,
    ignore = "10^6 iteracji parserów jest zbyt wolne w Miri; logikę pokrywają testy jednostkowe"
)]
fn one_million_malformed_inputs_do_not_panic() {
    let (comms, shares) =
        vss::deal(&[1u16, 2, 3], &[[0u8; 32]; 3], &[1, 2, 3]).expect("deal");
    assert_eq!(shares.len(), 3);
    let comms_bytes = comms.to_bytes();
    let share_bytes = shares[0].to_bytes();
    let poly = Poly::from_coeffs(&vec![7u16; N]).expect("poly");
    let poly_bytes = poly.to_le_bytes();
    let key_bytes = [0x5au8; 32];

    let mut st = 0x9e37_79b9_7f4a_7c15u64;
    for i in 0..1_000_000u32 {
        let len = (next(&mut st) % 4097) as usize;
        let mut buf = vec![0u8; len];
        for b in &mut buf {
            *b = next(&mut st) as u8;
        }
        match i % 8 {
            0 => drop(ExpShare::try_from(buf.as_slice())),
            1 => drop(VssCommitments::from_bytes(&buf)),
            2 => drop(Poly::from_le_bytes(&buf)),
            3 => drop(PairwiseKey::try_from(buf.as_slice())),
            4 => drop(ExpShare::try_from(mutate(&mut st, &share_bytes).as_slice())),
            5 => drop(VssCommitments::from_bytes(&mutate(&mut st, &comms_bytes))),
            6 => drop(Poly::from_le_bytes(&mutate(&mut st, &poly_bytes))),
            _ => drop(PairwiseKey::try_from(mutate(&mut st, &key_bytes).as_slice())),
        }
    }
}

#[test]
fn parser_limits_are_fail_closed() {
    // ExpShare: dokładnie 66 B, x ∈ 1..q, kanoniczne Scalar.
    assert_eq!(
        ExpShare::try_from(&[0u8; 65][..]).unwrap_err(),
        CoreError::InvalidLength
    );
    let mut share = [0u8; 66];
    assert_eq!(
        ExpShare::try_from(&share[..]).unwrap_err(),
        CoreError::XZero
    );
    share[..2].copy_from_slice(&Q.to_be_bytes());
    assert_eq!(
        ExpShare::try_from(&share[..]).unwrap_err(),
        CoreError::OutOfRange
    );
    share[..2].copy_from_slice(&1u16.to_be_bytes());
    share[2..34].fill(0xff);
    assert_eq!(
        ExpShare::try_from(&share[..]).unwrap_err(),
        CoreError::OutOfRange
    );

    // VssCommitments: cap przed alokacją/parsowaniem, potem długość i punkty.
    assert_eq!(
        VssCommitments::from_bytes(&[]).unwrap_err(),
        CoreError::ThresholdTooLow
    );
    assert_eq!(
        VssCommitments::from_bytes(&[0u8; 31]).unwrap_err(),
        CoreError::InvalidLength
    );
    assert_eq!(
        VssCommitments::from_bytes(&[0u8; 17 * 32]).unwrap_err(),
        CoreError::PartyCountMismatch
    );
    assert_eq!(
        VssCommitments::from_bytes(&[0xffu8; 32]).unwrap_err(),
        CoreError::InvalidInput
    );

    // Poly: dokładnie 2·N B i współczynniki < q.
    assert!(matches!(
        Poly::from_le_bytes(&[0u8; 2 * N - 1]),
        Err(CoreError::InvalidLength)
    ));
    let mut poly = [0u8; 2 * N];
    poly[..2].copy_from_slice(&Q.to_le_bytes());
    assert!(matches!(
        Poly::from_le_bytes(&poly),
        Err(CoreError::OutOfRange)
    ));

    // Klucz pary: dokładnie 32 B.
    assert_eq!(
        PairwiseKey::try_from(&[0u8; 31][..]).unwrap_err(),
        CoreError::InvalidLength
    );
    assert!(PairwiseKey::try_from(&[0u8; 32][..]).is_ok());
}
