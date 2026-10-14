import Source3.KeygenResultantFunction093

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ProcedureDeterminism094
open C99ArrayReference (State)
open C99ProcedureReference

theorem receive (dst : Destination) (before a b : State) (v : Option Value)
    (first : Receive dst before v a) (second : Receive dst before v b) : a = b := by
  cases first <;> cases second
  all_goals grind only [KeygenWordDeterminism093.binary]

theorem returned (ty : Option Ty) (flow : Flow) (a b : Option Value)
    (first : ReturnValue ty flow a) (second : ReturnValue ty flow b) : a = b := by
  cases first <;> cases second <;> rfl

/-- Every callee is followed recursively in the SAME program table.
    No abstract callee-result premise enters this theorem. -/
theorem execution (program : Program) (code : Stmt) (before : State) (a b : Result)
    (first : Exec program code before a) (second : Exec program code before b) : a = b := by
  induction first generalizing b <;> cases second
  all_goals grind only [C99ArrayDeterminism089.execution, C99ArrayDeterminism089.expression,
    C99ArrayDeterminism089.parameters, C99ScalarCallsDeterminism089.array_scalar, receive, returned]

end FT1536.Source3.C99ProcedureDeterminism094
