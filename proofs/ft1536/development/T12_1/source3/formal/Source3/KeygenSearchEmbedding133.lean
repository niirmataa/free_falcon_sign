import Source3.KeygenSearchExtended133
import Source3.FprOfEight132

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSearchEmbedding133
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenSearchExec (Expr Stmt)
open KeygenSearchExtended133 (Eval Exec)

theorem expression (ctx : Context) (before : State) (expr : Expr) (out : Value)
    (source : KeygenSearchExec.Eval ctx before expr out) : Eval ctx before expr out := by
  induction source with
  | base expr out source => exact .base _ _ source
  | plain expr pointer out address source => exact .plain _ _ _ address source
  | unary name expr arg out evaluated call ih => exact .unary _ _ _ _ ih (FprScalarClosure132.previous _ _ _ call)
  | binary name first second x y out left right call ihLeft ihRight =>
      exact .binary _ _ _ _ _ _ ihLeft ihRight (FprScalarClosure132.previous _ _ _ call)
  | cast ty expr arg evaluated ih => exact .cast _ _ _ ih

theorem execution (ctx : Context) (code : Stmt) (before : State) (out : Result)
    (source : KeygenSearchExec.Exec ctx code before out) : Exec ctx code before out := by
  induction source with
  | procedure code before out source => exact .procedure _ _ _ source
  | logn dst before ty old word declared source => exact .logn _ _ _ _ _ declared source
  | pointer dst expr before pointer source => exact .pointer _ _ _ _ source
  | assign dst expr before ty old val declared source => exact .assign _ _ _ _ _ _ declared (expression _ _ _ _ source)
  | store32 dst index expr before after pointer val address source write =>
      exact .store32 _ _ _ _ _ _ _ address (expression _ _ _ _ source) write
  | store64 dst index expr before after pointer val address source write =>
      exact .store64 _ _ _ _ _ _ _ address (expression _ _ _ _ source) write
  | move dst src count before after p q word destination source length copy =>
      exact .move _ _ _ _ _ _ _ _ destination source length copy
  | small args before after source => exact .small _ _ _ source
  | seqNormal first second before middle out head tail ihFirst ihSecond =>
      exact .seqNormal _ _ _ _ _ ihFirst ihSecond
  | seqExit first second before out head exit ih => exact .seqExit _ _ _ _ ih exit
  | scope locals pointers body before out inner ih => exact .scope _ _ _ _ _ ih
  | branchTrue cond yes no before out val guard nonzero body ih => exact .branchTrue _ _ _ _ _ _ guard nonzero ih
  | branchFalse cond yes no before out val guard zero body ih => exact .branchFalse _ _ _ _ _ _ guard zero ih
  | loopFalse cond body increment before val guard zero => exact .loopFalse _ _ _ _ _ guard zero
  | loopNormal cond body increment before middle next out val guard nonzero iteration update rest ihBody ihUpdate ihRest =>
      exact .loopNormal _ _ _ _ _ _ _ _ guard nonzero ihBody ihUpdate ihRest
  | loopReturn cond body increment before after val ret guard nonzero iteration ih =>
      exact .loopReturn _ _ _ _ _ _ _ guard nonzero ih

def sqrtOfEight : Expr := .unary "fpr_sqrt".toList
  (.unary "fpr_of".toList (.base (.scalar (.literal .i32 8))))

theorem sqrt_of_eight (ctx : Context) (before : State) :
    Eval ctx before sqrtOfEight (.uint64 FprSqrtEight132.output) := by
  exact .unary _ _ (.uint64 FprSqrtEight132.input) _
    (.unary _ _ (.int32 8) _ (.base _ _ (.scalar _ _ (.literal .int32 8))) FprOfEight132.extended)
    FprScalarClosure132.sqrt_eight

theorem old_sqrt_of_eight_impossible (ctx : Context) (before : State) (out : Value) :
    ¬KeygenSearchExec.Eval ctx before sqrtOfEight out := by
  intro source
  cases source with
  | unary name arg value out source call => exact FprSqrtMissing131.no_call _ _ call

end FT1536.Source3.KeygenSearchEmbedding133
