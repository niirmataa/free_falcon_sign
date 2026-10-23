//! Testy integracyjne spike 002 — 2-z-3 + kontrola spójności.

use ft1536_threshold_spike::*;
use rand::rngs::OsRng;
use rand::RngCore;

const XS3: [u8; 3] = [1, 2, 3];
const K: u8 = 2;

fn synth_seed(rng: &mut impl rand::RngCore) -> [u8; 32] {
    let mut seed = [0u8; 32];
    for b in seed.iter_mut() {
        *b = (rng.next_u32() & 0xFF) as u8;
    }
    seed
}

/// t1 — happy path, wszystkie pary
#[test]
fn spike02_t1_happy_all_pairs() {
    let mut rng = OsRng;
    let seed = synth_seed(&mut rng);
    let expected = h_fold_local(&seed);
    let shares = split_seed(&mut rng, &seed, &XS3, K).unwrap();
    for pair in [[0usize, 1], [0, 2], [1, 2]] {
        let k0 = derive_key_byte_checked(&mut rng, &shares, &XS3, K, &pair).unwrap();
        assert_eq!(k0, expected);
    }
}

/// t2 — wzorzec lokalny
#[test]
fn spike02_t2_local_oracle() {
    let mut rng = OsRng;
    for _ in 0..16 {
        let seed = synth_seed(&mut rng);
        assert_eq!(
            derive_key_byte_2of3(&mut rng, &seed, &XS3, K).unwrap(),
            h_fold_local(&seed)
        );
    }
}

/// t3 — padnięcie jednej strony
#[test]
fn spike02_t3_drop_one_party() {
    let mut rng = OsRng;
    let seed = synth_seed(&mut rng);
    let expected = h_fold_local(&seed);
    let shares = split_seed(&mut rng, &seed, &XS3, K).unwrap();
    for pair in [[0usize, 1], [0, 2], [1, 2]] {
        assert_eq!(
            derive_key_byte_checked(&mut rng, &shares, &XS3, K, &pair).unwrap(),
            expected
        );
    }
}

/// t4 — 1-z-3 nie wystarczy
#[test]
fn spike02_t4_single_share_insufficient() {
    let mut rng = OsRng;
    let mut mismatch = false;
    for _ in 0..64 {
        let s = (rng.next_u32() & 0xFF) as u8;
        let sh = shamir_share(&mut rng, s, &XS3, K).unwrap();
        if reconstruct_one_byte(&[&sh[0]]).unwrap() != s {
            mismatch = true;
            break;
        }
    }
    assert!(mismatch);
}

/// t5 — fałszerstwo WYKRYTE
#[test]
fn spike02_t5_forged_detected() {
    let mut rng = OsRng;
    let mut shares = shamir_share(&mut rng, 0x42, &XS3, K).unwrap();
    shares[1].share ^= 0x5A;
    let refs: Vec<&Share> = shares.iter().collect();
    assert_eq!(verify_consistency(&refs, K), Err(SpikeError::InconsistentShare));
}

/// t6 — derive blokowany (fail-closed, nie cichy zły)
#[test]
fn spike02_t6_forged_blocks_derive() {
    let mut rng = OsRng;
    let seed = synth_seed(&mut rng);
    let mut shares = split_seed(&mut rng, &seed, &XS3, K).unwrap();
    shares[0][1].share ^= 0xFF;
    assert_eq!(
        derive_key_byte_checked(&mut rng, &shares, &XS3, K, &[0, 1, 2]),
        Err(SpikeError::InconsistentShare)
    );
}

/// t7 — guardy H-28
#[test]
fn spike02_t7_h28_guards() {
    let mut rng = OsRng;
    assert_eq!(
        shamir_share(&mut rng, 1, &[], K).map(|_| ()).unwrap_err(),
        SpikeError::EmptyXs
    );
    assert_eq!(
        shamir_share(&mut rng, 1, &[1, 2], 0).map(|_| ()).unwrap_err(),
        SpikeError::ThresholdTooLow
    );
    assert_eq!(
        shamir_share(&mut rng, 1, &[1, 2], 1).map(|_| ()).unwrap_err(),
        SpikeError::ThresholdTooLow
    );
    assert_eq!(
        shamir_share(&mut rng, 1, &[0, 1, 2], K).map(|_| ()).unwrap_err(),
        SpikeError::XZero
    );
    assert_eq!(
        shamir_share(&mut rng, 1, &[1, 1, 2], K).map(|_| ()).unwrap_err(),
        SpikeError::DuplicateX
    );
    assert_eq!(reconstruct(&[]).map(|_| ()).unwrap_err(), SpikeError::EmptyShares);
}

// ── Spike 003: G_frag ──────────────────────────────────────────────────────

/// s1 — 64 B materiału == oracle
#[test]
fn spike03_s1_g_frag_oracle() {
    let mut rng = OsRng;
    let seed = synth_seed(&mut rng);
    let expected = g_frag_local(&seed);
    let material = derive_g_frag_2of3_shares(&mut rng, &seed, &XS3, K).unwrap();
    assert_eq!(material.len(), G_FRAG_LEN);
    for i in 0..G_FRAG_LEN {
        assert_eq!(open_g_frag_byte(&material[i], K).unwrap(), expected[i]);
    }
}

/// s2 — 1 udział nie otwiera; udziały ≠ pełny materiał
#[test]
fn spike03_s2_stays_shared() {
    let mut rng = OsRng;
    let seed = synth_seed(&mut rng);
    let material = derive_g_frag_2of3_shares(&mut rng, &seed, &XS3, K).unwrap();
    assert_eq!(
        open_g_frag_byte(&material[0][..1], K),
        Err(SpikeError::InsufficientShares)
    );
}

/// s3 — fałszywy udział seeda wykryty przed wyprowadzaniem
#[test]
fn spike03_s3_forged_detected() {
    let mut rng = OsRng;
    let seed = synth_seed(&mut rng);
    let mut seed_shares = split_seed(&mut rng, &seed, &XS3, K).unwrap();
    seed_shares[5][2].share ^= 0xA5;
    let refs: Vec<&Share> = seed_shares[5].iter().collect();
    assert_eq!(verify_consistency(&refs, K), Err(SpikeError::InconsistentShare));
}
