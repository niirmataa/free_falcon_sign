import Source3.C99ProcedureRun136

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ProcedureSegments136
open C99CompactState115 (State reference)
open C99ProcedureReference (Stmt Exec Program)

/- A cut after count normal iterations, with actual source guards retained. -/
inductive Prefix (program : Program) (condition : CLogic.Expr) (body increment : Stmt) :
    Nat → C99ArrayReference.State → C99ArrayReference.State → Prop where
  | done (state) : Prefix program condition body increment 0 state state
  | next (count : Nat) (before middle updated after) (value : C99IntegerReference.Value)
      (guard : C99ArrayReference.scalar before condition value) (nonzero : value.integer≠0)
      (iteration : Exec program body before ⟨middle,.normal⟩)
      (update : Exec program increment middle ⟨updated,.normal⟩)
      (rest : Prefix program condition body increment count updated after) :
      Prefix program condition body increment (count+1) before after

def run (calls : B20.C.Scalar.Calls) (fuel : Nat) (condition : CLogic.Expr) (body increment : Stmt) :
    Nat → State → Option State
  | 0, before => some before
  | count+1, before => do
      let value ← C99ScalarCompute130.evaluate before.locals condition
      if value.integer=0 then none else do
        let middle ← C99ProcedureRun136.run calls fuel body before
        let updated ← C99ProcedureRun136.run calls fuel increment middle
        run calls fuel condition body increment count updated

theorem run_source (program : Program) (calls : B20.C.Scalar.Calls)
    (callsSound : C99ExpressionSound.CallsSound FprPrefixCalls.calls calls)
    (fuel : Nat) (condition : CLogic.Expr) (body increment : Stmt) (count : Nat)
    (before after : State) (computed : run calls fuel condition body increment count before=some after) :
    Prefix program condition body increment count (reference before) (reference after) := by
  induction count generalizing before with
  | zero =>
      have same := Option.some.inj computed
      subst after
      exact .done _
  | succ count ih =>
      obtain ⟨value,evaluated,rest⟩ := Option.bind_eq_some_iff.mp computed
      split at rest
      next zero => cases rest
      next nonzero =>
        obtain ⟨middle,iteration,rest⟩ := Option.bind_eq_some_iff.mp rest
        obtain ⟨updated,update,following⟩ := Option.bind_eq_some_iff.mp rest
        exact .next count (reference before) (reference middle) (reference updated) (reference after)
          (C99ValueBridge.value value)
          (C99ScalarCompute130.evaluate_sound FprPrefixCalls.calls before.locals condition value evaluated)
          (by simpa only [C99ValueBridge.integer_matches] using nonzero)
          (C99ProcedureRun136.sound program calls callsSound fuel body before middle iteration)
          (C99ProcedureRun136.sound program calls callsSound fuel increment middle updated update) (ih updated following)

theorem finish (program : Program) (condition : CLogic.Expr) (body increment : Stmt) (count : Nat)
    (before after : C99ArrayReference.State) (out : C99ProcedureReference.Result)
    (source : Prefix program condition body increment count before after)
    (continuation : Exec program (.loop condition body increment) after out) :
    Exec program (.loop condition body increment) before out := by
  induction source with
  | done => exact continuation
  | next count before middle updated after value guard nonzero iteration update rest ih =>
      exact .loopNormal condition body increment before middle updated out value guard nonzero iteration update (ih continuation)

theorem append (program : Program) (condition : CLogic.Expr) (body increment : Stmt) (n m : Nat)
    (before middle after : C99ArrayReference.State)
    (first : Prefix program condition body increment n before middle)
    (second : Prefix program condition body increment m middle after) :
    Prefix program condition body increment (n+m) before after := by
  induction first with
  | done => simpa only [Nat.zero_add] using second
  | next count before first updated middle value guard nonzero iteration update rest ih =>
      rw [Nat.succ_add]
      exact .next (count+m) before first updated after value guard nonzero iteration update (ih second)

end FT1536.Source3.C99ProcedureSegments136
