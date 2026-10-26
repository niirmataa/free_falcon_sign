//! Bity, ich udziały i strumień bitów z SHAKE256 (WP-018, audyt #13).
//!
//! W MPC bit-dekompozycji ten sam bit musi istnieć w **dwóch domenach**:
//! jako udział GF(2^8) (liniowy XOR) i jako udział `Z_q`/`Z_P` (liniowe
//! składanie). Udział, który nie jest bitem, albo którego reprezentacje
//! się różnią, jest fałszerstwem — musi być odrzucony, zanim wejdzie do
//! obwodu. Ten moduł pilnuje **bitności i spójności każdego udziału**;
//! nie implementuje obwodu bitowego ani weryfikacji `a(a+1)=0`
//! (to należy do protokołu, WP-030+).
//!
//! Strumień bitów pochodzi z SHAKE256 (LSB-first w bajtach), więc jest
//! deterministyczny i niezależny od kolejności partycji strumienia.
//!
//! Udział bitu nie jest `Clone`:
//! ```compile_fail
//! use ft_threshold_core::bits::BitShare;
//! let b = BitShare::new(1, 1, 1).expect("bit");
//! let _copy = b.clone();
//! ```

use sha3::Shake256;
use sha3::digest::{ExtendableOutput, Update, XofReader};
use zeroize::{Zeroize, ZeroizeOnDrop};

use crate::error::{CoreError, Result};
use crate::ring::Q;

/// Wypełnia `out` bitami 0/1 z SHAKE256(input), LSB-first w każdym bajcie.
///
/// Domenę wiąże wołający (np. `nonce || msg || label`), tak jak w
/// [`crate::shake::shake256`]. Każdy bajt wyniku jest wyłącznie `0` albo `1`.
pub fn shake_bits(input: &[u8], out: &mut [u8]) {
    let mut h = Shake256::default();
    h.update(input);
    let mut reader = h.finalize_xof();
    let mut byte = [0u8; 1];
    for (i, slot) in out.iter_mut().enumerate() {
        if i % 8 == 0 {
            reader.read(&mut byte);
        }
        *slot = (byte[0] >> (i % 8)) & 1;
    }
}

/// Udział bitu spójny w GF(2^8) i `Z_q`/`Z_P`.
///
/// Konstruktor odrzuca wartości spoza `{0,1}` ([`CoreError::NonBitShare`])
/// oraz różne bity w obu reprezentacjach ([`CoreError::InconsistentShare`]).
/// Brak `Clone` (audyt #11): udział to materiał poufny.
#[derive(Zeroize, ZeroizeOnDrop)]
pub struct BitShare {
    x: u16,
    gf: u8,
    zp: u64,
}

impl std::fmt::Debug for BitShare {
    /// Debug pokazuje wyłącznie punkt ewaluacji; bity udziału są poufne.
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("BitShare")
            .field("x", &self.x)
            .finish_non_exhaustive()
    }
}

impl BitShare {
    /// Tworzy udział bitu; `gf` i `zp` muszą być w `{0,1}` i równe.
    pub fn new(x: u16, gf: u8, zp: u64) -> Result<Self> {
        if x == 0 {
            return Err(CoreError::XZero);
        }
        if x >= Q {
            return Err(CoreError::OutOfRange);
        }
        if gf > 1 || zp > 1 {
            return Err(CoreError::NonBitShare);
        }
        if u64::from(gf) != zp {
            return Err(CoreError::InconsistentShare);
        }
        Ok(Self { x, gf, zp })
    }

    /// Udział z lokalnego bitu (`true` = 1) w obu domenach.
    pub fn from_local(x: u16, bit: bool) -> Result<Self> {
        let v = u8::from(bit);
        Self::new(x, v, u64::from(v))
    }

    /// Punkt ewaluacji.
    pub fn x(&self) -> u16 {
        self.x
    }

    /// Wartość w GF(2^8) (`0`/`1`).
    pub fn gf(&self) -> u8 {
        self.gf
    }

    /// Wartość w `Z_q`/`Z_P` (`0`/`1`).
    pub fn zp(&self) -> u64 {
        self.zp
    }

    /// Bit udziału; spójność gwarantuje konstruktor.
    pub fn bit(&self) -> bool {
        self.gf == 1
    }
}

#[cfg(test)]
mod tests {
    use super::{BitShare, shake_bits};
    use crate::error::CoreError;
    use crate::ring::Q;

    #[test]
    fn shake_bits_matches_known_first_byte_and_stays_binary() {
        let mut bits = [9u8; 16];
        shake_bits(b"", &mut bits);
        // SHAKE256("") zaczyna się od 0x46 = 0100_0110, LSB-first.
        assert_eq!(bits, [0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1]);
        assert!(bits.iter().all(|&b| b <= 1));
    }

    #[test]
    fn shake_bits_is_deterministic_and_domain_separated() {
        let mut a = [0u8; 64];
        let mut b = [0u8; 64];
        let mut c = [0u8; 64];
        shake_bits(b"ctx-a", &mut a);
        shake_bits(b"ctx-a", &mut b);
        shake_bits(b"ctx-b", &mut c);
        assert_eq!(a, b);
        assert_ne!(a, c);
        assert!(a.iter().all(|&v| v <= 1));
    }

    #[test]
    fn bit_share_accepts_only_consistent_bits() {
        for x in 1..=4u16 {
            for bit in [0u8, 1] {
                let s = BitShare::new(x, bit, u64::from(bit)).expect("valid bit");
                assert_eq!(s.x(), x);
                assert_eq!(s.gf(), bit);
                assert_eq!(s.zp(), u64::from(bit));
                assert_eq!(s.bit(), bit == 1);
                assert_eq!(BitShare::from_local(x, bit == 1).expect("local").gf(), bit);
            }
        }
        // Fałszywy bit w którejkolwiek domenie → NonBitShare.
        for forged in 2..=255u8 {
            assert_eq!(
                BitShare::new(1, forged, 0).unwrap_err(),
                CoreError::NonBitShare
            );
            assert_eq!(
                BitShare::new(1, 0, u64::from(forged)).unwrap_err(),
                CoreError::NonBitShare
            );
        }
        // Spójność: ten sam udział musi mieć ten sam bit w obu domenach.
        assert_eq!(
            BitShare::new(1, 0, 1).unwrap_err(),
            CoreError::InconsistentShare
        );
        assert_eq!(
            BitShare::new(1, 1, 0).unwrap_err(),
            CoreError::InconsistentShare
        );
        // Zakres punktu ewaluacji.
        assert_eq!(BitShare::new(0, 0, 0).unwrap_err(), CoreError::XZero);
        assert_eq!(BitShare::new(Q, 0, 0).unwrap_err(), CoreError::OutOfRange);
    }

    #[test]
    fn debug_does_not_reveal_share_bit() {
        let s = BitShare::new(3, 1, 1).expect("bit");
        let text = format!("{s:?}");
        assert!(text.contains("BitShare"));
        assert!(!text.contains("gf"));
        assert!(!text.contains("zp"));
    }
}
