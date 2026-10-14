import Source3.KeygenZintCoreArity098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenZintExtractArity098
open KeygenZintCall
open KeygenZintDeterminism098 (checkedCode)

theorem chain_checked (codes : List Stmt) (checked : ∀ code ∈ codes, checkedCode code = true) : checkedCode (chain codes) = true := by
  induction codes with
  | nil => rfl
  | cons code rest ih => exact Bool.and_eq_true_iff.mpr ⟨checked code (by simp), ih (fun c member => checked c (by simp [member]))⟩

theorem bitlength0 : checkedCode (extractPart .bitlength 0) = true := by decide +kernel
theorem bitlength1 : checkedCode (extractPart .bitlength 1) = true := by decide +kernel
theorem bitlength2 : checkedCode (extractPart .bitlength 2) = true := by decide +kernel
theorem signed0 : checkedCode (extractPart .signedBitLength 0) = true := by decide +kernel
theorem signed1 : checkedCode (extractPart .signedBitLength 1) = true := by decide +kernel
theorem signed2 : checkedCode (extractPart .signedBitLength 2) = true := by decide +kernel
theorem signed3 : checkedCode (extractPart .signedBitLength 3) = true := by decide +kernel
theorem signed4 : checkedCode (extractPart .signedBitLength 4) = true := by decide +kernel

theorem bitlength : checkedCode (calleeBody .bitlength) = true := by
  apply chain_checked
  intro code member
  simp only [List.mem_cons, List.not_mem_nil, or_false] at member
  rcases member with rfl | rfl | rfl
  · exact bitlength0
  · exact bitlength1
  · exact bitlength2

theorem signedBitLength : checkedCode (calleeBody .signedBitLength) = true := by
  apply chain_checked
  intro code member
  simp only [List.mem_cons, List.not_mem_nil, or_false] at member
  rcases member with rfl | rfl | rfl | rfl | rfl
  · exact signed0
  · exact signed1
  · exact signed2
  · exact signed3
  · exact signed4

end FT1536.Source3.KeygenZintExtractArity098
