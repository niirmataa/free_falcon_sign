import Source3.KeygenRootSearch103

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSmall103
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSmallSource

theorem store16 (before : Memory) (p : ArrayPointer) (word : BitVec 16) (a b : Memory)
    (first : KeygenSmallOutput.Store16 before p word a) (second : KeygenSmallOutput.Store16 before p word b) : a = b := by
  obtain ⟨_, _, _, sa, wa, ba, fa⟩ := first
  obtain ⟨_, _, _, sb, wb, bb, fb⟩ := second
  exact C99HeapDeterminism089.write_unique before p 2 (KeygenSmallOutput.byte16 word) a b
    ⟨sa, wa, ba, fa⟩ ⟨sb, wb, bb, fb⟩

def checkedCode : Stmt → Bool
  | .modular code => C99ModularArity096.checkedCode code
  | .plain _ _ _ | .store16 _ _ _ => true
  | .seq a b | .branch _ a b | .loop _ a b => checkedCode a && checkedCode b
  | .scope _ body => checkedCode body

theorem execution (code : Stmt) (before : State) (a b : Result) (checked : checkedCode code = true)
    (first : Exec code before a) (second : Exec code before b) : a = b := by
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedCode, Bool.and_eq_true] at *
  all_goals grind only [C99ModularArity096.execution_unique, KeygenSearchValue100.plain,
    C99ScalarCallsDeterminism089.array_pointer, C99ScalarCallsDeterminism089.array_scalar, store16]

theorem body_checked : checkedCode code = true := by decide +kernel

theorem body_unique (before : State) (a b : Result)
    (first : Exec code before a) (second : Exec code before b) : a = b :=
  execution _ before a b body_checked first second

end FT1536.Source3.KeygenSmall103
