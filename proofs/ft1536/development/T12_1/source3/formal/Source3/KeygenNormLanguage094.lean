import Source3.C99ProcedureDeterminism094

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenNormLanguage094
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenSearchExec

theorem scalar_calls : C99ScalarDeterminism089.Deterministic ScalarCall := by
  intro name args a b first second
  by_cases rint : name = "fpr_rint".toList
  · simp only [ScalarCall, rint, ite_true] at first second
    exact C99ScalarDeterminism089.function_unique C99Frontend.headerCalls
      C99ScalarCallsDeterminism089.header_calls _ args a b first second
  · simp only [ScalarCall, rint, ite_false] at first second
    exact C99ScalarCallsDeterminism089.prefix_calls name args a b first second

theorem small_call (before a b : State) (args : List C99ArrayReference.Arg)
    (first : KeygenSearchLeaves.SmallCall before args a) (second : KeygenSearchLeaves.SmallCall before args b) : a = b := by
  cases first
  cases second
  grind only [C99ArrayDeterminism089.parameters, C99ProcedureDeterminism094.execution]

def checkedExpr : Expr → Bool
  | .base _ => true
  | .plain _ => false
  | .unary _ e | .cast _ e => checkedExpr e
  | .binary _ a b => checkedExpr a && checkedExpr b

def checkedCode : Stmt → Bool
  | .procedure _ | .small _ => true
  | .assign _ e | .store _ _ _ e => checkedExpr e
  | .seq a b | .branch _ a b | .loop _ a b => checkedCode a && checkedCode b
  | .scope _ _ body => checkedCode body
  | .logn _ | .pointer _ _ | .move _ _ _ => false

theorem expression (ctx : Context) (before : State) (e : Expr) (a b : Value)
    (checked : checkedExpr e = true) (first : Eval ctx before e a) (second : Eval ctx before e b) : a = b := by
  have calls := scalar_calls
  unfold C99ScalarDeterminism089.Deterministic at calls
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedExpr, Bool.and_eq_true, Bool.false_eq_true] at *
  all_goals grind only [C99ArrayDeterminism089.expression]

theorem execution (ctx : Context) (code : Stmt) (before : State) (a b : Result)
    (checked : checkedCode code = true) (first : Exec ctx code before a) (second : Exec ctx code before b) : a = b := by
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedCode, Bool.and_eq_true, Bool.false_eq_true] at *
  all_goals grind only [expression, small_call, C99ProcedureDeterminism094.execution,
    C99ScalarCallsDeterminism089.array_scalar, C99ScalarCallsDeterminism089.array_pointer,
    C99HeapDeterminism089.store32, C99HeapDeterminism089.store64]

end FT1536.Source3.KeygenNormLanguage094
