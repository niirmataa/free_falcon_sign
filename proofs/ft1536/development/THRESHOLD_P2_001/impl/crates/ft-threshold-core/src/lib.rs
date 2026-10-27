//! Rdzeń progowego podpisu FT1536 (P2).
//!
//! Zaimplementowane (WP-012a/b/c/d, WP-018): GF(2^8) i Shamir seeda ([`gf256`]),
//! udziały bitów i strumień bitów SHAKE ([`bits`]), fail-closed sampler
//! odrzuceń ([`sampler`]),
//! pierścień `R_q` ([`ring`]), jawny SHAKE256 i `hash_to_point` ([`shake`])
//! oraz PRSS z parami kluczy i udziałami zera ([`prss`]).
//! NTT ternarna z silnika ([`ntt`]), Shamir w `Z_q` ([`shamir_zq`]) i Pedersen
//! VSS nad `Z_q` ([`vss`]), oraz domena `Z_P` ([`zp`]) z MAC ukrytego δ
//! ([`mac`]) i jednorazowymi maskami otwarć ([`mask`]) — D-025. Zasady: brak I/O,
//! brak `unsafe`, docelowo `no_std`-ready.

#![forbid(unsafe_code)]

pub mod bits;
pub mod codec;
pub mod error;
pub mod gf256;
pub mod mac;
pub mod mask;
pub mod ntt;
pub mod prss;
pub mod ring;
pub mod sampler;
pub mod shake;
pub mod shamir_zq;
pub mod vss;
pub mod zp;

pub use error::{CoreError, Result};

/// Profil zgodności (SPEC §14.1). Tag jest częścią transkryptu.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
#[repr(u8)]
pub enum Profile {
    /// Znany klucz testowy + deterministyczny sampler; **nie** `PROD`.
    TestOracle = 0x01,
    /// Realna krypto; wyłącznie po G3 i niezależnym odbiorze.
    Prod = 0x02,
}

/// Maksymalna liczba stron w v1 (SPEC §6.1).
pub const MAX_PARTIES_V1: usize = 16;

#[cfg(test)]
mod tests {
    use super::{MAX_PARTIES_V1, Profile};

    #[test]
    fn profile_tags_match_spec() {
        assert_eq!(Profile::TestOracle as u8, 0x01);
        assert_eq!(Profile::Prod as u8, 0x02);
        assert_eq!(MAX_PARTIES_V1, 16);
    }
}
