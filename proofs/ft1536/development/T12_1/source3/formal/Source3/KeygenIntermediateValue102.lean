import Source3.KeygenIntermediatePointer102

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenIntermediateValue102
open C99ArrayReference (State)
open C99IntegerReference (Value)
open KeygenSearchContext (Context)
open KeygenIntermediateCalls

def checkedExpr : Expr → Bool
  | .word e => KeygenWordArity096.checkedExpr e
  | .land a b => checkedExpr a && checkedExpr b
  | .load64 _ _ | .rint _ _ | .logn | .ternary | .prime _ _ _ | .pointerLt _ _ => true

theorem rint (args : List Value) (a b : Value)
    (first : KeygenSearchLeaves.Rint args a) (second : KeygenSearchLeaves.Rint args b) : a = b :=
  C99ScalarDeterminism089.function_unique C99Frontend.headerCalls
    C99ScalarCallsDeterminism089.header_calls _ args a b first second

theorem expression (ctx : Context) (before : State) (e : Expr) (a b : Value) (checked : checkedExpr e = true)
    (first : Eval ctx before e a) (second : Eval ctx before e b) : a = b := by
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedExpr, Bool.and_eq_true] at *
  all_goals grind only [KeygenWordArity096.expression, C99ArrayDeterminism089.expression,
    rint, KeygenSearchPointer100.logn, KeygenSearchPointer100.ternary,
    KeygenLevelReads097.prime, KeygenIntermediatePointer102.pointer, KeygenIntermediatePointer102.compare]

def checkedArgs : List Arg → Bool
  | [] => true
  | .scalar e :: rest => checkedExpr e && checkedArgs rest
  | .pointer _ :: rest => checkedArgs rest

theorem binding (ctx : Context) (before : State) (ps : List C99ArrayReference.Param) (args : List Arg)
    (a b : State) (checked : checkedArgs args = true)
    (first : Bind ctx before ps args a) (second : Bind ctx before ps args b) : a = b := by
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedArgs, Bool.and_eq_true] at *
  all_goals grind only [expression, KeygenIntermediatePointer102.pointer]

end FT1536.Source3.KeygenIntermediateValue102
