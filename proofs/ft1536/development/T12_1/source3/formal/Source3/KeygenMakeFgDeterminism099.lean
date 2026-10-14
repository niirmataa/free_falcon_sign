import Source3.KeygenMakeFgTop099

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenMakeFgDeterminism099
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeFgSource

def checkedCode : Stmt → Bool
  | .level code => KeygenLevelDeterminism097.checkedCode code
  | .zint code => KeygenZintDeterminism098.checkedCode code
  | .word code => KeygenWordArity096.checkedCode code
  | .binary _ args => KeygenLevelReads097.checkedArgs args
  | .top _ | .step _ => true
  | .seq a b | .branch _ a b | .loop _ a b => checkedCode a && checkedCode b
  | .scope _ _ body => checkedCode body

theorem execution (stepClosed : checkedCode (code .step) = true)
    (body : Stmt) (before : State) (a b : Result) (checked : checkedCode body = true)
    (first : Exec body before a) (second : Exec body before b) : a = b := by
  have zintUnique := KeygenZintDeterminism098.execution KeygenZintCall098.closed
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedCode, Bool.and_eq_true] at *
  all_goals grind only [KeygenLevelDeterminism097.execution, KeygenWordArity096.execution,
    KeygenBinaryDeterminism097.call_unique, KeygenMakeFgTop099.call_unique,
    C99ArrayDeterminism089.parameters, C99ScalarCallsDeterminism089.array_scalar]

end FT1536.Source3.KeygenMakeFgDeterminism099
