import Source3.KeygenCodecStaticCoefficientHistory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticStreamByte

/-- The drained byte depends only on the relevant low suffix, even for
    an accumulator containing arbitrarily many old emitted high bits. -/
theorem drain_low (word : BitVec 32) (p : Nat) :
    (KeygenCodecStaticByte.byte (word >>> p)).toNat=
      KeygenCodecStaticSuffix.low word (p+8)/2^p := by
  simp only [KeygenCodecStaticByte.byte,BitVec.toNat_ofNat,BitVec.toNat_ushiftRight,
    Nat.shiftRight_eq_div_pow,KeygenCodecStaticSuffix.low,Nat.pow_add]
  exact (Nat.mod_mul_right_div_self word.toNat (2^p) (2^8)).symm

end FT1536.Source3.KeygenCodecStaticStreamByte
