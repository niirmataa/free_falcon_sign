import Source3.KeygenAttemptNorm

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Coverage diagnosis of the FROZEN reference relation, not a C failure. -/
namespace FT1536.Source3.FprSqrtMissing131
open C99IntegerReference (Value)

theorem prefix_lookup : FprPrefixCalls.lookup "fpr_sqrt".toList=none := by decide +kernel
theorem primitive_lookup : C99Frontend.lookup "fpr_sqrt".toList=none := by decide +kernel

theorem no_call (args : List Value) (out : Value) :
    ¬KeygenSearchExec.ScalarCall "fpr_sqrt".toList args out := by
  intro source
  change FprPrefixCalls.calls "fpr_sqrt".toList args out at source
  unfold FprPrefixCalls.calls at source
  rw [prefix_lookup] at source
  change C99Frontend.primitiveCall "fpr_sqrt".toList args out at source
  obtain ⟨function,found,_⟩ := source
  rw [primitive_lookup] at found
  cases found

def missing : KeygenSearchExec.Expr → Bool
  | .base _ | .plain _ => false
  | .unary name arg => if name="fpr_sqrt".toList then true else missing arg
  | .binary name left right => if name="fpr_sqrt".toList then true else missing left || missing right
  | .cast _ arg => missing arg

theorem eval_excludes (ctx : KeygenSearchContext.Context) (state : C99ArrayReference.State)
    (expr : KeygenSearchExec.Expr) (out : Value) (source : KeygenSearchExec.Eval ctx state expr out) : missing expr=false := by
  induction source with
  | base | plain => rfl
  | unary name arg value out source call ih =>
      by_cases named : name="fpr_sqrt".toList
      · subst name
        exact (no_call _ _ call).elim
      · simp only [missing,ite_eq_right named,ih]
  | binary name left right x y out first second call ihLeft ihRight =>
      by_cases named : name="fpr_sqrt".toList
      · subst name
        exact (no_call _ _ call).elim
      · simp only [missing,ite_eq_right named,ihLeft,ihRight,Bool.or_false]
  | cast ty expr value source ih => exact ih

def blocked : KeygenSearchExec.Stmt → Bool
  | .assign _ expr => missing expr
  | .seq first _ => blocked first
  | .scope _ _ body => blocked body
  | _ => false

theorem exec_excludes (ctx : KeygenSearchContext.Context) (code : KeygenSearchExec.Stmt)
    (before : C99ArrayReference.State) (out : C99ProcedureReference.Result)
    (source : KeygenSearchExec.Exec ctx code before out) : blocked code=false := by
  induction source with
  | assign dst expr before ty old value declared evaluated => exact eval_excludes ctx before expr value evaluated
  | seqNormal first second before middle out head tail ihFirst ihSecond => exact ihFirst
  | seqExit first second before out head exit ih => exact ih
  | scope locals pointers body before out inner ih => exact ih
  | procedure | logn | pointer | store32 | store64 | move | small | branchTrue | branchFalse | loopFalse | loopNormal | loopReturn => rfl

theorem bound_blocked : blocked KeygenAttemptNorm.boundCode=true := by decide +kernel

theorem no_bound_execution (ctx : KeygenSearchContext.Context) (before : C99ArrayReference.State)
    (out : C99ProcedureReference.Result) : ¬KeygenSearchExec.Exec ctx KeygenAttemptNorm.boundCode before out := by
  intro source
  have impossible := exec_excludes ctx _ before out source
  rw [bound_blocked] at impossible
  cases impossible

theorem no_norm_execution (ctx : KeygenSearchContext.Context) (before : C99ArrayReference.State)
    (out : C99ProcedureReference.Result) : ¬KeygenAttemptNorm.Exec ctx before out := by
  intro source
  cases source with
  | rawRejected bounded out initial raw rejected => exact no_bound_execution ctx before _ initial
  | gs bounded raw out initial norm gs => exact no_bound_execution ctx before _ initial

end FT1536.Source3.FprSqrtMissing131
