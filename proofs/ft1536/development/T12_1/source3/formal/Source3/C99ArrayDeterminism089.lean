import Source3.C99ScalarCallsDeterminism089
import Source3.C99HeapDeterminism089

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ArrayDeterminism089
open C99ArrayReference
open C99IntegerReference (Value)
open C99MemoryReference

theorem expression (s : State) (e : Expr) (a b : Value)
    (first : Eval s e a) (second : Eval s e b) : a = b := by
  have calleeUnique := C99ScalarCallsDeterminism089.prefix_calls
  unfold C99ScalarDeterminism089.Deterministic at calleeUnique
  induction first generalizing b <;> cases second
  all_goals grind only [C99ScalarCallsDeterminism089.array_scalar,
    C99ScalarCallsDeterminism089.array_pointer, load64_deterministic,
    C99NarrowReads.load16_deterministic]

theorem parameters (caller : State) (params : List Param) (args : List Arg) (a b : State)
    (first : Bind caller params args a) (second : Bind caller params args b) : a = b := by
  induction first generalizing b <;> cases second
  all_goals grind only [C99ScalarCallsDeterminism089.array_scalar,
    C99ScalarCallsDeterminism089.array_pointer]

theorem scalar (before : State) (code : CLogic.Stmt) (a b : C99ScalarReference.Env)
    (first : C99ScalarReference.Exec FprPrefixCalls.calls before.locals (C99Frontend.scalar code) (.normal a))
    (second : C99ScalarReference.Exec FprPrefixCalls.calls before.locals (C99Frontend.scalar code) (.normal b)) : a = b := by
  have same := C99ScalarDeterminism089.execution_unique FprPrefixCalls.calls
    C99ScalarCallsDeterminism089.prefix_calls before.locals (C99Frontend.scalar code)
    (.normal a) (.normal b) first second
  cases same
  rfl

/-- The fixed function table is followed recursively in both derivations.
    There is no assumed source completeness or abstract callee result. -/
theorem execution (program : Program) (code : Stmt) (before a b : State)
    (first : Exec program code before a) (second : Exec program code before b) : a = b := by
  induction first generalizing b <;> cases second
  all_goals grind only [expression, scalar, parameters,
    C99ScalarCallsDeterminism089.array_scalar, C99ScalarCallsDeterminism089.array_pointer,
    C99HeapDeterminism089.store64, C99HeapDeterminism089.store32, memcpy_deterministic]

end FT1536.Source3.C99ArrayDeterminism089
