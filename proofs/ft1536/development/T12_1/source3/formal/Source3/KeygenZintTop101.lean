import Source3.KeygenDepthZero100

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenZintTop101
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenZintTop

def checkedCode : Stmt → Bool
  | .core code => KeygenZintDeterminism098.checkedCode code
  | .divide31 _ _ _ | .retBitcast _ _ => true
  | .seq a b => checkedCode a && checkedCode b

theorem execution (code : Stmt) (before : State) (a b : Result) (checked : checkedCode code = true)
    (first : Exec code before a) (second : Exec code before b) : a = b := by
  have core := KeygenZintDeterminism098.execution KeygenZintCall098.closed
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedCode, Bool.and_eq_true] at *
  all_goals grind

theorem check0 : checkedCode (part 0) = true := by decide +kernel
theorem check1 : checkedCode (part 1) = true := by decide +kernel
theorem check2 : checkedCode (part 2) = true := by decide +kernel
theorem check3 : checkedCode (part 3) = true := by decide +kernel

theorem body_checked : checkedCode code = true := by
  change checkedCode (part 0) && (checkedCode (part 1) && (checkedCode (part 2) && (checkedCode (part 3) && true))) = true
  rw [check0, check1, check2, check3]
  rfl

theorem parsed (i : Fin 4) : KeygenZintTop.parsed i = some (part i) := by
  fin_cases i
  · exact parsed_part 0 audit0
  · exact parsed_part 1 audit1
  · exact parsed_part 2 audit2
  · exact parsed_part 3 audit3

theorem body_unique (before : State) (a b : Result)
    (first : Exec code before a) (second : Exec code before b) : a = b :=
  execution code before a b body_checked first second

theorem call_unique (before a b : State) (args : List C99ArrayReference.Arg) (x y : Value)
    (first : Call before args a x) (second : Call before args b y) : a = b ∧ x = y := by
  obtain ⟨entry1, out1, binding1, source1, returned1, state1⟩ := first
  obtain ⟨entry2, out2, binding2, source2, returned2, state2⟩ := second
  have entries := C99ArrayDeterminism089.parameters before _ args entry1 entry2 binding1 binding2
  subst entry2
  have outcomes := body_unique entry1 out1 out2 source1 source2
  subst out2
  exact ⟨state1.trans state2.symm, Option.some.inj (C99ProcedureDeterminism094.returned _ _ _ _ returned1 returned2)⟩

end FT1536.Source3.KeygenZintTop101
