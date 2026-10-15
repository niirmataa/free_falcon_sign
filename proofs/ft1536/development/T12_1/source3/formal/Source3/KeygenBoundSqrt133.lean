import Source3.KeygenAttemptNorm133

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenBoundSqrt133
open KeygenSearchExec (Expr Stmt)

def firstExpression : Stmt → Option Expr
  | .assign name expr => if name="bound".toList then some expr else none
  | .seq first _ => firstExpression first
  | .scope _ _ body => firstExpression body
  | _ => none

def denominator : Expr → Option Expr
  | .binary name _ right => if name="fpr_div".toList then some right else none
  | _ => none

theorem source_denominator : (firstExpression KeygenAttemptNorm.boundCode).bind denominator =
    some KeygenSearchEmbedding133.sqrtOfEight := by decide +kernel

theorem source_value (ctx : KeygenSearchContext.Context) (before : C99ArrayReference.State)
    (expr : Expr) (selected : (firstExpression KeygenAttemptNorm.boundCode).bind denominator=some expr) :
    KeygenSearchExtended133.Eval ctx before expr (.uint64 FprSqrtEight132.output) := by
  rw [source_denominator] at selected
  have same := Option.some.inj selected
  subst expr
  exact KeygenSearchEmbedding133.sqrt_of_eight ctx before

theorem source_unique (ctx : KeygenSearchContext.Context) (before : C99ArrayReference.State)
    (expr : Expr) (selected : (firstExpression KeygenAttemptNorm.boundCode).bind denominator=some expr)
    (out : C99IntegerReference.Value) (execution : KeygenSearchExtended133.Eval ctx before expr out) :
    out=.uint64 FprSqrtEight132.output :=
  KeygenSearchDeterminism133.expression ctx before expr out _ execution (source_value ctx before expr selected)

end FT1536.Source3.KeygenBoundSqrt133
