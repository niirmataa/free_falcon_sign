import Source3.KeygenMakeFgDeterminism099

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenMakeFgArity099
open KeygenMakeFgSource
open KeygenMakeFgDeterminism099 (checkedCode)

theorem step0 : checkedCode (part .step 0) = true := by decide +kernel
theorem step1 : checkedCode (part .step 1) = true := by decide +kernel
theorem step2 : checkedCode (part .step 2) = true := by decide +kernel
theorem step3 : checkedCode (part .step 3) = true := by decide +kernel
theorem step4 : checkedCode (part .step 4) = true := by decide +kernel
theorem make0 : checkedCode (part .make 0) = true := by decide +kernel
theorem make1 : checkedCode (part .make 1) = true := by decide +kernel
theorem make2 : checkedCode (part .make 2) = true := by decide +kernel
theorem make3 : checkedCode (part .make 3) = true := by decide +kernel

theorem chain_checked (codes : List Stmt) (checked : ∀ code ∈ codes, checkedCode code = true) : checkedCode (chain codes) = true := by
  induction codes with
  | nil => rfl
  | cons code rest ih => exact Bool.and_eq_true_iff.mpr ⟨checked code (by simp), ih (fun c member => checked c (by simp [member]))⟩

theorem body (kind : Kind) : checkedCode (code kind) = true := by
  cases kind
  case step =>
    apply chain_checked
    intro code member
    simp only [List.mem_cons, List.not_mem_nil, or_false] at member
    rcases member with rfl | rfl | rfl | rfl | rfl
    · exact step0
    · exact step1
    · exact step2
    · exact step3
    · exact step4
  case make =>
    apply chain_checked
    intro code member
    simp only [List.mem_cons, List.not_mem_nil, or_false] at member
    rcases member with rfl | rfl | rfl | rfl
    · exact make0
    · exact make1
    · exact make2
    · exact make3

theorem step_parsed (i : Fin 5) : parsed .step i.val = some (part .step i.val) := by
  fin_cases i
  · exact parsed_part .step 0 step_audit0
  · exact parsed_part .step 1 step_audit1
  · exact parsed_part .step 2 step_audit2
  · exact parsed_part .step 3 step_audit3
  · exact parsed_part .step 4 step_audit4

theorem make_parsed (i : Fin 4) : parsed .make i.val = some (part .make i.val) := by
  fin_cases i
  · exact parsed_part .make 0 make_audit0
  · exact parsed_part .make 1 make_audit1
  · exact parsed_part .make 2 make_audit2
  · exact parsed_part .make 3 make_audit3

end FT1536.Source3.KeygenMakeFgArity099
