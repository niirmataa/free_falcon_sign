import Source3.KeygenZintPoly101

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPolyScaled101
open C99ArrayReference (State)
open KeygenPolySubScaled

def checkedCode : Stmt → Bool
  | .assign _ e => KeygenWordArity096.checkedExpr e
  | .seq a b => checkedCode a && checkedCode b
  | .scope _ _ body => checkedCode body
  | .branch e a b | .loop e a b => KeygenWordArity096.checkedExpr e && checkedCode a && checkedCode b
  | .skip | .declare _ _ | .declarePtr _ | .pointer _ _ _ | .divide31 _ _ _ | .addScaled _ => true

theorem execution (code : Stmt) (before a b : State) (checked : checkedCode code = true)
    (first : Exec code before a) (second : Exec code before b) : a = b := by
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedCode, Bool.and_eq_true] at *
  all_goals grind only [KeygenWordArity096.expression, C99ScalarCallsDeterminism089.array_pointer,
    KeygenZintScaled101.call_unique]

theorem check0 : checkedCode (part 0) = true := by decide +kernel
theorem check1 : checkedCode (part 1) = true := by decide +kernel
theorem check2 : checkedCode (part 2) = true := by decide +kernel

theorem body_checked : checkedCode code = true := by
  change checkedCode (part 0) && (checkedCode (part 1) && (checkedCode (part 2) && true)) = true
  rw [check0, check1, check2]; rfl

theorem parsed (i : Fin 3) : KeygenPolySubScaled.parsed i = some (part i) := by
  fin_cases i
  · exact parsed_part 0 audit0
  · exact parsed_part 1 audit1
  · exact parsed_part 2 audit2

theorem body_unique (before a b : State) (first : Exec code before a) (second : Exec code before b) : a = b :=
  execution _ before a b body_checked first second

theorem call_unique (before a b : State) (args : List C99ArrayReference.Arg)
    (first : Call before args a) (second : Call before args b) : a = b := by
  obtain ⟨entry1, out1, binding1, source1, state1⟩ := first
  obtain ⟨entry2, out2, binding2, source2, state2⟩ := second
  have entries := C99ArrayDeterminism089.parameters before _ args entry1 entry2 binding1 binding2
  subst entry2
  have outcomes := body_unique entry1 out1 out2 source1 source2
  subst out2
  exact state1.trans state2.symm

end FT1536.Source3.KeygenPolyScaled101
