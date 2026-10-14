import Source3.KeygenZintTop101

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenZintScaled101
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenZintScaled
open KeygenZintDeterminism098 (checkedCode)

theorem add0 : checkedCode (part .add 0) = true := by decide +kernel
theorem add1 : checkedCode (part .add 1) = true := by decide +kernel
theorem add2 : checkedCode (part .add 2) = true := by decide +kernel
theorem sub0 : checkedCode (part .sub 0) = true := by decide +kernel
theorem sub1 : checkedCode (part .sub 1) = true := by decide +kernel
theorem sub2 : checkedCode (part .sub 2) = true := by decide +kernel

theorem body_checked (kind : Kind) : checkedCode (code kind) = true := by
  apply KeygenZintExtractArity098.chain_checked
  intro c member
  simp only [List.mem_cons, List.not_mem_nil, or_false] at member
  cases kind <;> rcases member with rfl | rfl | rfl
  · exact add0
  · exact add1
  · exact add2
  · exact sub0
  · exact sub1
  · exact sub2

theorem parsed (kind : Kind) (i : Fin 3) : KeygenZintScaled.parsed kind i = some (part kind i) := by
  cases kind <;> fin_cases i
  · exact parsed_part .add 0 add_audit0
  · exact parsed_part .add 1 add_audit1
  · exact parsed_part .add 2 add_audit2
  · exact parsed_part .sub 0 sub_audit0
  · exact parsed_part .sub 1 sub_audit1
  · exact parsed_part .sub 2 sub_audit2

theorem binding (before : State) (ps : List C99ArrayReference.Param) (args : List Arg) (a b : State)
    (first : Bind before ps args a) (second : Bind before ps args b) : a = b := by
  induction first generalizing b <;> cases second
  all_goals grind only [C99ScalarCallsDeterminism089.array_scalar, C99ScalarCallsDeterminism089.array_pointer]

theorem body_unique (kind : Kind) (before : State) (a b : Result)
    (first : KeygenZintCall.Exec (code kind) before a) (second : KeygenZintCall.Exec (code kind) before b) : a = b :=
  KeygenZintDeterminism098.execution KeygenZintCall098.closed _ before a b (body_checked kind) first second

theorem call_unique (kind : Kind) (before a b : State) (args : List Arg)
    (first : Call kind before args a) (second : Call kind before args b) : a = b := by
  obtain ⟨entry1, out1, binding1, source1, returned1, state1⟩ := first
  obtain ⟨entry2, out2, binding2, source2, returned2, state2⟩ := second
  have entries := binding before _ args entry1 entry2 binding1 binding2
  subst entry2
  have outcomes := body_unique kind entry1 out1 out2 source1 source2
  subst out2
  exact state1.trans state2.symm

end FT1536.Source3.KeygenZintScaled101
