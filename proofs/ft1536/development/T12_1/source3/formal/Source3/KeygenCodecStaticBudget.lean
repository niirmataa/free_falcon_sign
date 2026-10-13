import Source3.KeygenCodecStaticJoint

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- A conservative bound from the int16 input domain, independent of the
   requested output length, capacity, flow and old accumulator high bits. -/
namespace FT1536.Source3.KeygenCodecStaticBudget

theorem unary_size (n p : Nat) (word : BitVec 32) :
    (KeygenCodecStaticUnaryHistory.bytes n p word).length≤n := by
  induction n generalizing p word with
  | zero => exact Nat.le_refl 0
  | succ n ih =>
    simp only [KeygenCodecStaticUnaryHistory.bytes,List.length_append]
    have tail := ih ((p+1)%8) ((word <<< 1)+(if n=0 then 1 else 0))
    split <;> simp only [List.length_cons,List.length_nil] <;> omega

theorem coefficient_size (p : Nat) (word : BitVec 32) (input : BitVec 16) (small : p<8) :
    (KeygenCodecStaticCoefficientHistory.bytes p word input).length≤131 := by
  have lower := BitVec.le_toInt input
  have upper : input.toInt < 2^(16-1) := BitVec.toInt_lt
  have magnitude := KeygenCodecStaticCoefficient.magnitude_bounds input.toInt lower (by omega)
  have count : (KeygenCodecStaticCoefficient.magnitude input.toInt/256+1).toNat≤129 := by omega
  have unary := unary_size (KeygenCodecStaticCoefficient.magnitude input.toInt/256+1).toNat
    ((p+9)%8) (KeygenCodecStaticPrefix.packedWord word input)
  unfold KeygenCodecStaticCoefficientHistory.bytes KeygenCodecStaticCoefficientHistory.firstBytes
    KeygenCodecStaticCoefficientHistory.lastBytes
  rw [List.length_append,KeygenCodecStaticCoefficientHistory.drain_size]
  omega

end FT1536.Source3.KeygenCodecStaticBudget
