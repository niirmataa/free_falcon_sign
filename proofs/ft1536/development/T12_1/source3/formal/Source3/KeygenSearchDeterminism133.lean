import Source3.KeygenSearchExtended133
import Source3.KeygenSearchValue100

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSearchDeterminism133
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenSearchExec (Expr Stmt)
open KeygenSearchExtended133 (Eval Exec)

theorem expression (ctx : Context) (before : State) (expr : Expr) (a b : Value)
    (first : Eval ctx before expr a) (second : Eval ctx before expr b) : a=b := by
  have calls := FprScalarClosure132.deterministic
  unfold C99ScalarDeterminism089.Deterministic at calls
  induction first generalizing b <;> cases second
  all_goals grind only [C99ArrayDeterminism089.expression, KeygenSearchPointer100.pointer, KeygenSearchValue100.plain]

theorem execution (ctx : Context) (code : Stmt) (before : State) (a b : Result)
    (first : Exec ctx code before a) (second : Exec ctx code before b) : a=b := by
  induction first generalizing b <;> cases second
  all_goals grind only [C99ProcedureDeterminism094.execution, KeygenSearchPointer100.logn,
    KeygenSearchPointer100.pointer, expression, KeygenNormLanguage094.small_call,
    KeygenLevelReads097.memmove, C99HeapDeterminism089.store32, C99HeapDeterminism089.store64,
    C99ScalarCallsDeterminism089.array_scalar, C99ScalarCallsDeterminism089.array_pointer]

end FT1536.Source3.KeygenSearchDeterminism133
