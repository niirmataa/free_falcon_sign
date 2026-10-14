import Source3.ShakeSeedMemoryDeterminism089
import Source3.ShakeSeedReference

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeSeedDeterminism089
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open ShakeExtractSource (Layout)
open C99ScalarDeterminism089

theorem field_calls (ctx : Layout) (s : State) : Deterministic (ShakeSeedReference.ReadCall ctx s) := by
  intro name args a b first second
  cases first <;> cases second
  all_goals grind only [load64_deterministic]

theorem expression (ctx : Layout) (s : State) (e : CLogic.Expr) (a b : Value)
    (first : ShakeSeedReference.Eval ctx s e a) (second : ShakeSeedReference.Eval ctx s e b) : a = b :=
  expression_unique (ShakeSeedReference.ReadCall ctx s) (field_calls ctx s) s.locals
    (C99Frontend.expression e) a b first second

theorem scalar (ctx : Layout) (s : State) (code : CLogic.Stmt) (a b : C99ScalarReference.Env)
    (first : C99ScalarReference.Exec (ShakeSeedReference.ReadCall ctx s) s.locals (C99Frontend.scalar code) (.normal a))
    (second : C99ScalarReference.Exec (ShakeSeedReference.ReadCall ctx s) s.locals (C99Frontend.scalar code) (.normal b)) :
    a = b := by
  have same := execution_unique (ShakeSeedReference.ReadCall ctx s) (field_calls ctx s)
    s.locals (C99Frontend.scalar code) (.normal a) (.normal b) first second
  cases same
  rfl

/-- Actual init/inject/pad control and all its fixed source callees have
    unique completed states. Termination is a separate question. -/
theorem execution (ctx : Layout) (code : ShakeSeedProgram.Stmt) (before a b : State)
    (first : ShakeSeedReference.Exec ctx code before a)
    (second : ShakeSeedReference.Exec ctx code before b) : a = b := by
  induction first generalizing b <;> cases second
  all_goals grind only [scalar, expression, C99ScalarCallsDeterminism089.array_pointer,
    C99HeapDeterminism089.pointer_add, load64_deterministic,
    C99IntegerReference.arithmetic_deterministic, C99HeapDeterminism089.store64,
    C99HeapDeterminism089.store8, C99HeapDeterminism089.fill, memcpy_deterministic,
    ShakeSeedMemoryDeterminism089.xor_call, ShakeBlockDeterminism089.process]

theorem init (ctx : Layout) (before : State) (capacity : Value) (a b : State)
    (first : ShakeSeedReference.Init ctx before capacity a)
    (second : ShakeSeedReference.Init ctx before capacity b) : a = b := by
  cases first
  cases second
  grind only [execution]

theorem inject (ctx : Layout) (before : State) (data : ArrayPointer) (length : Value) (a b : State)
    (first : ShakeSeedReference.Inject ctx before data length a)
    (second : ShakeSeedReference.Inject ctx before data length b) : a = b := by
  cases first
  cases second
  grind only [execution]

theorem flip (ctx : Layout) (before a b : State)
    (first : ShakeSeedReference.Flip ctx before a) (second : ShakeSeedReference.Flip ctx before b) : a = b := by
  cases first
  cases second
  grind only [execution]

end FT1536.Source3.ShakeSeedDeterminism089
