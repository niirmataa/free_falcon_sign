import Source3.KeygenPublicScalar095

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicWord095
open C99ArrayReference (State Name)
open C99IntegerReference (Value)
open C99MemoryReference
open KeygenPublicWord

theorem scalar (s : State) (e : CLogic.Expr) (a b : Value)
    (first : KeygenPublicWord.scalar s e a) (second : KeygenPublicWord.scalar s e b) : a = b :=
  C99ScalarDeterminism089.expression_unique KeygenPublicScalar.Call KeygenPublicScalar095.calls
    s.locals _ a b first second

theorem address (s : State) (name : Name) (index : CLogic.Expr) (a b : ArrayPointer)
    (first : Address s name index a) (second : Address s name index b) : a = b := by
  cases first
  cases second
  grind only [scalar, C99HeapDeterminism089.pointer_add]

theorem expression (signed : List Name) (s : State) (e : KeygenWordExpr.Expr) (a b : Value)
    (first : Eval signed s e a) (second : Eval signed s e b) : a = b := by
  have calls := KeygenPublicScalar095.calls
  unfold C99ScalarDeterminism089.Deterministic at calls
  induction first generalizing b <;> cases second
  all_goals grind only [scalar, address, C99NarrowReads.load16_deterministic,
    C99IntegerReference.neg_deterministic, C99ScalarDeterminism089.complement_unique,
    C99ScalarDeterminism089.compare_unique, KeygenWordDeterminism093.binary]

theorem parameters (before : State) (params : List C99ArrayReference.Param) (args : List C99ArrayReference.Arg)
    (a b : State) (first : Bind before params args a) (second : Bind before params args b) : a = b := by
  induction first generalizing b <;> cases second
  all_goals grind only [scalar, address]

theorem scalar_body (before : State) (code : CLogic.Stmt) (a b : C99ScalarReference.Env)
    (first : C99ScalarReference.Exec KeygenPublicScalar.Call before.locals (C99Frontend.scalar code) (.normal a))
    (second : C99ScalarReference.Exec KeygenPublicScalar.Call before.locals (C99Frontend.scalar code) (.normal b)) : a = b := by
  have same := C99ScalarDeterminism089.execution_unique KeygenPublicScalar.Call KeygenPublicScalar095.calls
    before.locals _ (.normal a) (.normal b) first second
  cases same
  rfl

end FT1536.Source3.KeygenPublicWord095
