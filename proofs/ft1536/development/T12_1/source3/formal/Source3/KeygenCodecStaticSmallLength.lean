import Source3.KeygenCodecStaticLength

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticSmallLength
open KeygenCodecStaticLength
open KeygenCodecStaticCoefficient (magnitude)

/-- The exact source quotient formula, written as an ordinary natural cost. -/
theorem cost_value (input : BitVec 16) :
    bitCost input=10+(magnitude input.toInt).toNat/256 := by
  have lower := BitVec.le_toInt input
  have upper : input.toInt<2^(16-1) := BitVec.toInt_lt
  have bounds := KeygenCodecStaticCoefficient.magnitude_bounds input.toInt lower (by omega)
  unfold bitCost unaryCount
  omega

def LowMagnitude (inputs : List (BitVec 16)) : Prop :=
  ∀ input, input∈inputs → magnitude input.toInt<256

theorem small_cost (input : BitVec 16) (small : magnitude input.toInt<256) : bitCost input=10 := by
  rw [cost_value]
  have lower := BitVec.le_toInt input
  have upper : input.toInt<2^(16-1) := BitVec.toInt_lt
  have bounds := KeygenCodecStaticCoefficient.magnitude_bounds input.toInt lower (by omega)
  omega

theorem small_total (inputs : List (BitVec 16)) (small : LowMagnitude inputs) :
    totalBits inputs=10*inputs.length := by
  induction inputs with
  | nil => rfl
  | cons input rest ih =>
    have first := small_cost input (small input (List.mem_cons_self))
    have tail := ih (fun value member => small value (List.mem_cons_of_mem input member))
    simp only [totalBits,List.length_cons,first,tail]
    omega

/-- The M0 low-magnitude carrier has1920 bytes for one1536-coefficient
    STATIC segment; mathematical-vector membership is not assumed here. -/
theorem small_profile (inputs : List (BitVec 16)) (length : inputs.length=1536)
    (small : LowMagnitude inputs) : byteLength inputs=1920 := by
  unfold byteLength
  rw [small_total inputs small,length]

end FT1536.Source3.KeygenCodecStaticSmallLength
