//! Rdzeń progowego podpisu FT1536 (P2).
//!
//! Zaimplementowane (WP-012a/b/c/d): GF(2^8) i Shamir seeda ([`gf256`]),
//! pierścień `R_q` ([`ring`]), jawny SHAKE256 i `hash_to_point` ([`shake`])
//! oraz PRSS z parami kluczy i udziałami zera ([`prss`]).
//! NTT ternarna z silnika ([`ntt`]), Shamir w `Z_q` ([`shamir_zq`]) i Pedersen
//! VSS nad `Z_q` ([`vss`]). Zasady: brak I/O,
//! brak `unsafe`, docelowo `no_std`-ready.

#![forbid(unsafe_code)]

pub mod error;
pub mod gf256;
pub mod ntt;
pub mod prss;
pub mod ring;
pub mod shake;
pub mod shamir_zq;
pub mod vss;

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
