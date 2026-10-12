import Source3.KeygenCodecNoneDispatch

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- uint32 suffix algebra for the actual STATIC accumulator operations.
   Old emitted bits remain in the word; only the pending low suffix is
   interpreted. These lemmas alone are not the complete body invariant. -/
namespace FT1536.Source3.KeygenCodecStaticSuffix
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference

def low (acc : BitVec 32) (count : Nat) : Nat := acc.toNat % 2^count

theorem low_bound (acc : BitVec 32) (count : Nat) : low acc count<2^count :=
  Nat.mod_lt _ (Nat.two_pow_pos _)

theorem low_shl (acc : BitVec 32) (count shift : Nat) (width : count+shift≤32) :
    low (acc <<< shift) (count+shift)=low acc count*2^shift := by
  unfold low
  rw [BitVec.toNat_shiftLeft,Nat.mod_mod_of_dvd _ (Nat.pow_dvd_pow 2 width)]
  rw [Nat.shiftLeft_eq,Nat.pow_add,Nat.mul_mod_mul_right]

theorem low_append (acc bits : BitVec 32) (count shift : Nat)
    (width : count+shift≤32) (newBits : bits.toNat<2^shift) :
    low ((acc <<< shift) ||| bits) (count+shift)=low acc count*2^shift+bits.toNat := by
  have order : 2^shift≤(2 : Nat)^(count+shift) :=
    Nat.le_of_dvd (Nat.two_pow_pos _) (Nat.pow_dvd_pow 2 (by omega))
  have bitsMod : bits.toNat%2^(count+shift)=bits.toNat := Nat.mod_eq_of_lt (Nat.lt_of_lt_of_le newBits order)
  change (((acc <<< shift).toNat ||| bits.toNat)%2^(count+shift))=_
  rw [Nat.or_mod_two_pow,bitsMod]
  change low (acc <<< shift) (count+shift) ||| bits.toNat=_
  rw [low_shl acc count shift width,←Nat.shiftLeft_eq,←Nat.shiftLeft_add_eq_or_of_lt newBits]

/-- Removing a whole emitted byte changes the interpretation length, not
    the stored word. The remaining low suffix is exactly the same residue. -/
theorem low_remove (acc : BitVec 32) (pending : Nat) :
    low acc pending=low (BitVec.ofNat 32 (low acc (pending+8))) pending := by
  unfold low
  rw [BitVec.toNat_ofNat]
  by_cases fits : pending≤32
  · rw [Nat.mod_mod_of_dvd _ (Nat.pow_dvd_pow 2 fits)]
    rw [Nat.mod_mod_of_dvd _ (Nat.pow_dvd_pow 2 (by omega : pending≤pending+8))]
  · have a : acc.toNat<2^pending := Nat.lt_of_lt_of_le acc.isLt
      (Nat.le_of_dvd (Nat.two_pow_pos _) (Nat.pow_dvd_pow 2 (by omega : 32≤pending)))
    have b : acc.toNat<2^(pending+8) := Nat.lt_of_lt_of_le a
      (Nat.le_of_dvd (Nat.two_pow_pos _) (Nat.pow_dvd_pow 2 (by omega : pending≤pending+8)))
    simp only [Nat.mod_eq_of_lt a,Nat.mod_eq_of_lt b,Nat.mod_eq_of_lt acc.isLt]

/-- The previously retained zero-input counterexample is kernel checked
    as a counterexample to the whole-word bound, not as a codec failure. -/
theorem whole_word_bound_false : ¬(1025 : Nat)<2^4 := by decide +kernel

theorem first_part_source : KeygenCodecStaticBinding.node040=
    .write (.variable "acc".toList) .set
      (.binary .bor (.binary .shl (.variable "acc".toList)
        (.binary .add (.variable "j".toList) (.number .i32 1))) (.variable "lo".toList)) := rfl

theorem unary_shift_source : KeygenCodecStaticBinding.node061=
    .write (.variable "acc".toList) .shl (.number .i32 1) := rfl

theorem unary_bit_source : KeygenCodecStaticBinding.node062=
    .write (.variable "acc".toList) .add
      (.binary .band (.binary .shr (.cast .u32 (.variable "ne".toList)) (.number .i32 15)) (.number .i32 1)) := rfl

end FT1536.Source3.KeygenCodecStaticSuffix
