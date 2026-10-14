import Source3.KeygenLevelDeterminism097

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenBinaryDeterminism097
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenBinaryNtt

def checkedCode : Stmt → Bool
  | .base code => C99ModularArity096.checkedCode code
  | .seq a b | .branch _ a b | .loop _ a b => checkedCode a && checkedCode b
  | .scope _ _ body => checkedCode body

theorem execution (code : Stmt) (before : State) (a b : Result) (checked : checkedCode code = true)
    (first : Exec code before a) (second : Exec code before b) : a = b := by
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedCode, Bool.and_eq_true] at *
  all_goals grind only [C99ModularArity096.execution_unique, C99ScalarCallsDeterminism089.array_scalar]

theorem generate0 : checkedCode (part .generate 0) = true := by decide
theorem generate1 : checkedCode (part .generate 1) = true := by decide
theorem generate2 : checkedCode (part .generate 2) = true := by decide
theorem generate3 : checkedCode (part .generate 3) = true := by decide
theorem forward0 : checkedCode (part .forward 0) = true := by decide
theorem forward1 : checkedCode (part .forward 1) = true := by decide
theorem forward2 : checkedCode (part .forward 2) = true := by decide
theorem inverse0 : checkedCode (part .inverse 0) = true := by decide
theorem inverse1 : checkedCode (part .inverse 1) = true := by decide
theorem inverse2 : checkedCode (part .inverse 2) = true := by decide
theorem inverse3 : checkedCode (part .inverse 3) = true := by decide

theorem chain_checked (codes : List Stmt) (checked : ∀ code ∈ codes, checkedCode code = true) : checkedCode (chain codes) = true := by
  induction codes with
  | nil => rfl
  | cons code rest ih => exact Bool.and_eq_true_iff.mpr ⟨checked code (by simp), ih (fun c member => checked c (by simp [member]))⟩

theorem body_checked (kind : Kind) : checkedCode (code kind) = true := by
  cases kind
  case generate =>
    apply chain_checked
    intro code member
    simp only [List.mem_cons, List.not_mem_nil, or_false] at member
    rcases member with rfl | rfl | rfl | rfl
    · exact generate0
    · exact generate1
    · exact generate2
    · exact generate3
  case forward =>
    apply chain_checked
    intro code member
    simp only [List.mem_cons, List.not_mem_nil, or_false] at member
    rcases member with rfl | rfl | rfl
    · exact forward0
    · exact forward1
    · exact forward2
  case inverse =>
    apply chain_checked
    intro code member
    simp only [List.mem_cons, List.not_mem_nil, or_false] at member
    rcases member with rfl | rfl | rfl | rfl
    · exact inverse0
    · exact inverse1
    · exact inverse2
    · exact inverse3

theorem call_unique (kind : Kind) (before a b : State) (args : List KeygenLevelCalls.Arg)
    (checked : KeygenLevelReads097.checkedArgs args = true)
    (first : Call kind before args a) (second : Call kind before args b) : a = b := by
  cases first with
  | run entry1 out1 binding1 source1 returned1 =>
      cases second with
      | run entry2 out2 binding2 source2 returned2 =>
          have entries := KeygenLevelReads097.parameters before _ args entry1 entry2 checked binding1 binding2
          subst entry2
          have outcomes := execution _ entry1 out1 out2 (body_checked kind) source1 source2
          cases outcomes
          rfl

end FT1536.Source3.KeygenBinaryDeterminism097
