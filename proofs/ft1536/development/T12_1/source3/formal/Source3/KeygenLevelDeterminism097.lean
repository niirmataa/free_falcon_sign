import Source3.KeygenLevelArity097

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLevelDeterminism097
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenLevelExec

def checkedCode : Stmt → Bool
  | .modular code => C99ModularArity096.checkedCode code
  | .prime _ _ _ _ | .move _ _ _ _ _ => true
  | .call _ args => KeygenLevelReads097.checkedArgs args
  | .seq a b | .branch _ a b | .loop _ a b => checkedCode a && checkedCode b
  | .scope _ _ body => checkedCode body

theorem execution (code : Stmt) (before : State) (a b : Result) (checked : checkedCode code = true)
    (first : Exec code before a) (second : Exec code before b) : a = b := by
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedCode, Bool.and_eq_true] at *
  all_goals grind only [C99ModularArity096.execution_unique, KeygenLevelReads097.prime,
    KeygenLevelArity097.call_unique, KeygenLevelReads097.memmove,
    C99ScalarCallsDeterminism089.array_scalar, C99ScalarCallsDeterminism089.array_pointer]

end FT1536.Source3.KeygenLevelDeterminism097
