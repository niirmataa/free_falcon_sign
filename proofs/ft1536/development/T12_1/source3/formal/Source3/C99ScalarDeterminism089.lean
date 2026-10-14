import Source3.C99ScalarReference
import Mathlib.Tactic

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generic natural-semantics determinism. The explicit callee premise is
   a local metatheorem interface; concrete source callers must prove it for
   their fixed call table. It is not a premise of a claimed KeyGen law. -/
namespace FT1536.Source3.C99ScalarDeterminism089
open C99IntegerReference
open C99ScalarReference

def Deterministic (calls : CallRelation) : Prop :=
  ∀ name args a b, calls name args a → calls name args b → a = b

theorem compare_unique (op : Comparison) (x y a b : Value)
    (first : CompareExec op x y a) (second : CompareExec op x y b) : a = b := by
  cases first
  cases second
  simp_all

theorem complement_unique (x a b : Value)
    (first : ComplementExec x a) (second : ComplementExec x b) : a = b := by
  cases first
  cases second
  rfl

theorem expression_unique (calls : CallRelation) (deterministic : Deterministic calls)
    (env : Env) (e : Expr) (a b : Value)
    (first : Eval calls env e a) (second : Eval calls env e b) : a = b := by
  unfold Deterministic at deterministic
  induction first generalizing b <;> cases second
  all_goals grind only [arithmetic_deterministic, shift_deterministic,
    neg_deterministic, bitwise_deterministic, compare_unique, complement_unique]

theorem execution_unique (calls : CallRelation) (deterministic : Deterministic calls)
    (env : Env) (code : Stmt) (a b : Result)
    (first : Exec calls env code a) (second : Exec calls env code b) : a = b := by
  induction first generalizing b <;> cases second
  all_goals grind only [expression_unique]

theorem parameters_unique (params : List (Ty × Name)) (args : List Value) (a b : Env)
    (first : BindArgs params args a) (second : BindArgs params args b) : a = b := by
  induction first generalizing b with
  | nil => cases second; rfl
  | cons ty name ps v vs env bound ih =>
      cases second with
      | cons _ _ _ _ _ other bound' =>
          rw [ih other bound']

theorem function_unique (calls : CallRelation) (deterministic : Deterministic calls)
    (f : Function) (args : List Value) (a b : Value)
    (first : FunctionExec calls f args a) (second : FunctionExec calls f args b) : a = b := by
  cases first with
  | call locals result parameters body =>
      cases second with
      | call other result' parameters' body' =>
          have envEqual := parameters_unique f.params args locals other parameters parameters'
          subst other
          have values := execution_unique calls deterministic locals f.body _ _ body body'
          cases values
          rfl

end FT1536.Source3.C99ScalarDeterminism089
