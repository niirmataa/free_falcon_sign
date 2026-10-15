import Source3.KeygenWordEndpoints130
import Source3.KeygenWordDeterminism093

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenWordSegments130
open C99CompactState115 (State reference)
open KeygenWordExpr (Expr Eval)
open KeygenWordExec (Stmt Exec)

/-- Exactly count NORMAL loop iterations, retaining every actual guard.
    This is a proof cut; source completion still requires the continuation. -/
inductive Prefix (condition : Expr) (body increment : Stmt) : Nat → C99ArrayReference.State → C99ArrayReference.State → Prop where
  | done (state) : Prefix condition body increment 0 state state
  | next (count : Nat) (before middle updated after) (value : C99IntegerReference.Value)
      (guard : Eval before condition value) (nonzero : value.integer≠0)
      (iteration : Exec body before ⟨middle,.normal⟩)
      (update : Exec increment middle ⟨updated,.normal⟩)
      (rest : Prefix condition body increment count updated after) :
      Prefix condition body increment (count+1) before after

def run (fuel : Nat) (condition : Expr) (body increment : Stmt) : Nat → State → Option State
  | 0, before => some before
  | count+1, before => do
      let value ← KeygenWordCompute130.evaluate before condition
      if value.integer=0 then none else do
        let middle ← KeygenWordEndpoints130.normal fuel body before
        let updated ← KeygenWordEndpoints130.normal fuel increment middle
        run fuel condition body increment count updated

theorem run_source (fuel : Nat) (condition : Expr) (body increment : Stmt) (count : Nat)
    (before after : State) (computed : run fuel condition body increment count before=some after) :
    Prefix condition body increment count (reference before) (reference after) := by
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
          (C99ValueBridge.value value) (KeygenWordComputeSound130.sound before condition value evaluated)
          (by simpa only [C99ValueBridge.integer_matches] using nonzero)
          (KeygenWordEndpoints130.normal_sound fuel body before middle iteration)
          (KeygenWordEndpoints130.normal_sound fuel increment middle updated update) (ih updated following)

theorem finish (condition : Expr) (body increment : Stmt) (count : Nat)
    (before after : C99ArrayReference.State) (out : C99ProcedureReference.Result)
    (source : Prefix condition body increment count before after)
    (continuation : Exec (.loop condition body increment) after out) :
    Exec (.loop condition body increment) before out := by
  induction source with
  | done => exact continuation
  | next count before middle updated after value guard nonzero iteration update rest ih =>
      exact .loopNormal condition body increment before middle updated out value guard nonzero iteration update (ih continuation)

theorem append (condition : Expr) (body increment : Stmt) (n m : Nat)
    (before middle after : C99ArrayReference.State)
    (first : Prefix condition body increment n before middle)
    (second : Prefix condition body increment m middle after) :
    Prefix condition body increment (n+m) before after := by
  induction first with
  | done => simpa only [Nat.zero_add] using second
  | next count before first updated middle value guard nonzero iteration update rest ih =>
      rw [Nat.succ_add]
      exact .next (count+m) before first updated after value guard nonzero iteration update (ih second)

theorem metadata (condition : Expr) (body increment : Stmt) (count : Nat)
    (before after : C99ArrayReference.State) (source : Prefix condition body increment count before after) :
    C99Metadata091.Stable before after := by
  induction source with
  | done => exact ⟨rfl,rfl,rfl,rfl⟩
  | next count before middle updated after value guard nonzero iteration update rest ih =>
      exact C99Metadata091.trans before updated after
        (C99Metadata091.trans before middle updated (KeygenWordDeterminism093.metadata body before _ iteration)
          (KeygenWordDeterminism093.metadata increment middle _ update)) ih

end FT1536.Source3.KeygenWordSegments130
