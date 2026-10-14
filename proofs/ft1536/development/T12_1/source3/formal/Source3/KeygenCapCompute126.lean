import Source3.SelectedPrefixFacts125

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCapCompute126
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)

def increment (before : State) : Option State :=
  (C99CompactScalar115.step noCalls before.locals
    (.update "local_attempts".toList .add (.literal .i32 1))).map (fun locals => {before with locals := locals})

theorem increment_sound (program : C99ProcedureReference.Program) (before after : State) (computed : increment before=some after) :
    C99ProcedureReference.Exec program KeygenAttemptCap.increment (reference before) ⟨reference after,.normal⟩ := by
  obtain ⟨locals,step,result⟩ := Option.map_eq_some_iff.mp computed
  subst after
  rw [C99CompactState115.reference_locals]
  exact .base _ _ _ (.scalar (reference before) (C99CompactCells115.environment locals)
    (.update "local_attempts".toList .add (.literal .i32 1))
    (C99CompactScalar115.step_sound FprPrefixCalls.calls noCalls (C99CompactPointer115.noCalls_sound _)
      before.locals locals _ step))

/-- Certify a normal cap step only. Rejection here is absence of this
    certificate, not an invented whole-call failure observation. -/
def run (before : State) : Option State := do
  let after ← increment before
  let value ← KeygenRngOps124.evaluate after KeygenAttemptCap.condition
  if value.integer=0 then pure after else none

theorem run_sound (program : C99ProcedureReference.Program) (before after : State) (computed : run before=some after) :
    C99ProcedureReference.Exec program KeygenAttemptCap.code (reference before) ⟨reference after,.normal⟩ := by
  obtain ⟨middle,step,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨value,evaluated,rest⟩ := Option.bind_eq_some_iff.mp rest
  split at rest
  next zero =>
    have same := Option.some.inj rest
    subst after
    refine .seqNormal _ _ (reference before) (reference middle) ⟨reference middle,.normal⟩
      (increment_sound program before middle step) ?_
    exact .branchFalse _ _ _ (reference middle) ⟨reference middle,.normal⟩ (C99ValueBridge.value value)
      (KeygenRngOps124.evaluate_sound middle KeygenAttemptCap.condition value evaluated)
      (by simpa only [C99ValueBridge.integer_matches] using zero) (.base _ _ _ (.skip _))
  next exceeded => cases rest

end FT1536.Source3.KeygenCapCompute126
