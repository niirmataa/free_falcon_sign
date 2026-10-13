import Source3.KeygenCodecStaticComplete

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact bit and byte accounting for the stream derived from the complete
   pinned STATIC body. Old accumulator high bits do not affect its length. -/
namespace FT1536.Source3.KeygenCodecStaticLength
open KeygenCodecStaticOuterHistory KeygenCodecStaticOuterState
open KeygenCodecStaticIteration KeygenCodecStaticCoefficientHistory

/-- The source unary loop executes quotient+1 bit steps, including its stop bit. -/
def unaryCount (input : BitVec 16) : Nat :=
  (KeygenCodecStaticCoefficient.magnitude input.toInt/256+1).toNat

def bitCost (input : BitVec 16) : Nat := 9+unaryCount input

def totalBits : List (BitVec 16) → Nat
  | [] => 0
  | input::rest => bitCost input+totalBits rest

def byteLength (inputs : List (BitVec 16)) : Nat := (totalBits inputs+7)/8

theorem unary_length (n p : Nat) (word : BitVec 32) (small : p<8) :
    (KeygenCodecStaticUnaryHistory.bytes n p word).length=(p+n)/8 := by
  induction n generalizing p word with
  | zero => simp only [KeygenCodecStaticUnaryHistory.bytes,List.length_nil,Nat.add_zero,Nat.div_eq_of_lt small]
  | succ n ih =>
    simp only [KeygenCodecStaticUnaryHistory.bytes,List.length_append]
    rw [ih _ _ (Nat.mod_lt _ (by decide +kernel))]
    split <;> simp only [List.length_cons,List.length_nil]
    all_goals omega

theorem coefficient_length (p : Nat) (word : BitVec 32) (input : BitVec 16) :
    (KeygenCodecStaticCoefficientHistory.bytes p word input).length=(p+bitCost input)/8 := by
  unfold KeygenCodecStaticCoefficientHistory.bytes firstBytes lastBytes
  rw [List.length_append,drain_size,unary_length _ _ _ (Nat.mod_lt _ (by decide +kernel))]
  unfold bitCost unaryCount
  omega

theorem coefficient_pending (p : Nat) (input : BitVec 16) :
    nextPending p input.toInt=(p+bitCost input)%8 := by
  unfold nextPending bitCost unaryCount
  omega

/-- Conservation of all processed bits, for any original word and pending count. -/
theorem stream_conservation (inputs : List (BitVec 16)) (p : Nat) (word : BitVec 32)
    (small : p<8) :
    8*(KeygenCodecStaticOuterHistory.bytes inputs p word).length+(fold inputs p word).1=
      p+totalBits inputs := by
  induction inputs generalizing p word with
  | nil => simp only [KeygenCodecStaticOuterHistory.bytes,List.length_nil,fold,totalBits,Nat.mul_zero,Nat.zero_add,Nat.add_zero]
  | cons input rest ih =>
    have tail := ih (nextPending p input.toInt) (nextWord p word input.toInt)
      (by unfold nextPending; exact Nat.mod_lt _ (by decide +kernel))
    simp only [KeygenCodecStaticOuterHistory.bytes,List.length_append,fold,totalBits]
    rw [coefficient_length]
    rw [coefficient_pending] at tail ⊢
    omega

theorem stream_length (inputs : List (BitVec 16)) (p : Nat) (word : BitVec 32)
    (small : p<8) :
    (KeygenCodecStaticOuterHistory.bytes inputs p word).length=(p+totalBits inputs)/8 ∧
      (fold inputs p word).1=(p+totalBits inputs)%8 := by
  have conserved := stream_conservation inputs p word small
  have pending := fold_pending inputs p word small
  omega

/-- Include the actual independent final padding of this one segment. -/
theorem encoded_length (inputs : List (BitVec 16)) :
    (KeygenCodecStaticComplete.encoded inputs).length=byteLength inputs := by
  have stream := stream_length inputs 0 0 (by decide +kernel)
  unfold KeygenCodecStaticComplete.encoded byteLength
  rw [List.length_append,KeygenCodecStaticReturnHistory.padding_size,stream.1,stream.2]
  simp only [Nat.zero_add]
  split <;> omega

theorem cost_bounds (input : BitVec 16) : 10≤bitCost input ∧ bitCost input≤138 := by
  have lower := BitVec.le_toInt input
  have upper : input.toInt<2^(16-1) := BitVec.toInt_lt
  have magnitude := KeygenCodecStaticCoefficient.magnitude_bounds input.toInt lower (by omega)
  unfold bitCost unaryCount
  omega

theorem total_bounds (inputs : List (BitVec 16)) :
    10*inputs.length≤totalBits inputs ∧ totalBits inputs≤138*inputs.length := by
  induction inputs with
  | nil => simp only [List.length_nil,totalBits,Nat.mul_zero,Nat.le_refl,and_self]
  | cons input rest ih =>
    have cost := cost_bounds input
    simp only [List.length_cons,totalBits]
    omega

theorem profile_bounds (inputs : List (BitVec 16)) (length : inputs.length=1536) :
    1920≤byteLength inputs ∧ byteLength inputs≤26496 := by
  have bounds := total_bounds inputs
  rw [length] at bounds
  unfold byteLength
  omega

end FT1536.Source3.KeygenCodecStaticLength
