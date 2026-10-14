import Source3.KeygenStore16Compute121

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSamplerTail121
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)

def flow (accepted : Bool) : C99ProcedureReference.Flow := if accepted then .breakLoop else .normal

def branch (before : State) : Option (State × Bool) := do
  let value ← C99CompactScalar115.evaluate noCalls before.locals KeygenTernaryStore.condition
  if value.integer=0 then pure (before,false) else do
    let after ← KeygenStore16Compute121.store before "v".toList (.var "u".toList) KeygenTernaryStore.coefficient
    pure (after,true)

theorem branch_sound (before after : State) (accepted : Bool) (computed : branch before=some (after,accepted)) :
    KeygenTernaryStore.Branch (reference before) ⟨reference after,flow accepted⟩ := by
  obtain ⟨value,evaluated,rest⟩ := Option.bind_eq_some_iff.mp computed
  have guard := C99CompactScalar115.evaluate_sound FprPrefixCalls.calls noCalls (C99CompactPointer115.noCalls_sound _)
    before.locals KeygenTernaryStore.condition value evaluated
  split at rest
  next zero =>
    obtain ⟨sameState,sameFlag⟩ := Prod.mk.inj (Option.some.inj rest)
    subst after
    subst accepted
    exact .rejected (C99ValueBridge.value value) guard (by simpa only [C99ValueBridge.integer_matches] using zero)
  next nonzero =>
    obtain ⟨middle,written,result⟩ := Option.bind_eq_some_iff.mp rest
    obtain ⟨sameState,sameFlag⟩ := Prod.mk.inj (Option.some.inj result)
    subst after
    subst accepted
    exact .accepted (reference middle) (C99ValueBridge.value value) guard
      (by simpa only [C99ValueBridge.integer_matches] using nonzero)
      (KeygenStore16Compute121.store_sound before middle "v".toList (.var "u".toList) KeygenTernaryStore.coefficient written)

def tail (before : State) : Option (State × Bool) := do
  branch (←KeygenScalarCompute121.run 16 KeygenTernaryStore.draw before)

theorem tail_sound (before after : State) (accepted : Bool) (computed : tail before=some (after,accepted)) :
    KeygenTernaryStore.Exec (reference before) ⟨reference after,flow accepted⟩ := by
  obtain ⟨middle,draw,rest⟩ := Option.bind_eq_some_iff.mp computed
  exact .tail (reference middle) ⟨reference after,flow accepted⟩
    (KeygenScalarCompute121.run_sound 16 KeygenTernaryStore.draw before middle draw)
    (branch_sound middle after accepted rest)

end FT1536.Source3.KeygenSamplerTail121
