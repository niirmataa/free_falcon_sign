import Source3.KeygenPolyScaled101

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPolyNtt101
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenPolySubNtt

def checkedCode : Stmt → Bool
  | .base code => KeygenMakeFgDeterminism099.checkedCode code
  | .divide code => KeygenZintTop101.checkedCode code
  | .subtract _ => true
  | .seq a b | .branch _ a b | .loop _ a b => checkedCode a && checkedCode b
  | .scope _ _ body => checkedCode body

theorem execution (code : Stmt) (before : State) (a b : Result) (checked : checkedCode code = true)
    (first : Exec code before a) (second : Exec code before b) : a = b := by
  have make := KeygenMakeFgDeterminism099.execution (KeygenMakeFgArity099.body .step)
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedCode, Bool.and_eq_true] at *
  all_goals grind only [KeygenZintTop101.execution, KeygenZintScaled101.body_unique,
    C99ArrayDeterminism089.parameters, C99ScalarCallsDeterminism089.array_scalar]

theorem check0 : checkedCode (part 0) = true := by decide +kernel
theorem check1 : checkedCode (part 1) = true := by decide +kernel
theorem check2 : checkedCode (part 2) = true := by decide +kernel
theorem check3 : checkedCode (part 3) = true := by decide +kernel

theorem body_checked : checkedCode code = true := by
  change checkedCode (part 0) && (checkedCode (part 1) && (checkedCode (part 2) && (checkedCode (part 3) && true))) = true
  rw [check0, check1, check2, check3]; rfl

theorem parsed (i : Fin 4) : KeygenPolySubNtt.parsed i = some (part i) := by
  fin_cases i
  · exact parsed_part 0 audit0
  · exact parsed_part 1 audit1
  · exact parsed_part 2 audit2
  · exact parsed_part 3 audit3

theorem body_unique (before : State) (a b : Result)
    (first : Exec code before a) (second : Exec code before b) : a = b :=
  execution _ before a b body_checked first second

end FT1536.Source3.KeygenPolyNtt101
