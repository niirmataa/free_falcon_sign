import Source3.C99StraightProcedure140
import Source3.C99ProcedureSegments136

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99CompiledSegments140
open C99CompactState115 (State reference)
open C99StraightProcedure140 (Certificate)

def run (calls : B20.C.Scalar.Calls) (body increment : Certificate) (condition : CLogic.Expr) :
    Nat → State → Option State
  | 0,before => some before
  | count+1,before => do
    let value ← C99ScalarCompute130.evaluate before.locals condition
    if value.integer=0 then none else do
      let middle ← body.run calls before
      let updated ← increment.run calls middle
      run calls body increment condition count updated

theorem source (program : C99ProcedureReference.Program) (calls : B20.C.Scalar.Calls)
    (valid : C99ExpressionSound.CallsSound FprPrefixCalls.calls calls)
    (body increment : Certificate) (condition : CLogic.Expr) (count : Nat)
    (before after : State) (computed : run calls body increment condition count before=some after) :
    C99ProcedureSegments136.Prefix program condition body.code increment.code count
      (reference before) (reference after) := by
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
        (body.source program calls valid before middle iteration)
        (increment.source program calls valid middle updated update) (ih updated following)

end FT1536.Source3.C99CompiledSegments140
