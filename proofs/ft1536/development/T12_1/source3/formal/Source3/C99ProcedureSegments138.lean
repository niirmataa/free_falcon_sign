import Source3.C99ProcedureRun138
import Source3.C99ProcedureSegments136

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ProcedureSegments138
open C99CompactState115 (State reference)
open C99ProcedureReference (Stmt Exec Program)

open C99ProcedureSegments136 (Prefix)

def run (calls : B20.C.Scalar.Calls) (fuel : Nat) (condition : CLogic.Expr) (body increment : Stmt) :
    Nat → State → Option State
  | 0, before => some before
  | count+1, before => do
      let value ← C99ScalarCompute130.evaluate before.locals condition
      if value.integer=0 then none else do
        let middle ← C99ProcedureRun138.run calls fuel body before
        let updated ← C99ProcedureRun138.run calls fuel increment middle
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
          (C99ProcedureRun138.sound program calls callsSound fuel body before middle iteration)
          (C99ProcedureRun138.sound program calls callsSound fuel increment middle updated update) (ih updated following)

end FT1536.Source3.C99ProcedureSegments138
