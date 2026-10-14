import Source3.KeygenTernaryFunction094

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ModularDeterminism095
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open C99ModularReference
open C99ScalarDeterminism089 (Deterministic)

theorem expression (calls : CallRelation) (deterministic : Deterministic calls)
    (s : State) (e : Expr) (a b : Value) (first : GenEval calls s e a) (second : GenEval calls s e b) : a = b := by
  unfold Deterministic at deterministic
  induction first generalizing b <;> cases second
  all_goals grind only [C99ScalarCallsDeterminism089.array_scalar, C99ScalarCallsDeterminism089.array_pointer,
    Gate00Memory.load32_deterministic, C99NarrowReads.load16_deterministic]

theorem execution (calls : CallRelation) (deterministic : Deterministic calls)
    (code : Stmt) (before : State) (a b : Result)
    (first : GenExec calls code before a) (second : GenExec calls code before b) : a = b := by
  induction first generalizing b <;> cases second
  all_goals grind only [expression, C99ArrayDeterminism089.execution,
    C99ScalarCallsDeterminism089.array_scalar, C99ScalarCallsDeterminism089.array_pointer,
    C99NarrowReads.load16_deterministic, C99HeapDeterminism089.store32]

end FT1536.Source3.C99ModularDeterminism095
