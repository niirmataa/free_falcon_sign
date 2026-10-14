import Source3.ShakeExtractTraceCall128
import Source3.KeygenRngCompute121

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenRngTrace128
open C99CompactState115 (State reference)
open C99FiniteAllocation115 (allocate restore fresh fresh_iff)
open ShakeProcessEvents128 (Proposal Event All)

abbrev Result := State × BitVec 64 × List Event

def draw (ctx : ShakeExtractSource.Layout) (propose : Proposal) (fuel block : Nat) (before : State) : Option Result := do
  if fresh before.heap block then
    let entered : State := {before with heap := allocate before.heap block 8}
    let (after,events) ← ShakeExtractTraceCall128.invoke ctx propose fuel entered (KeygenRngSource.bytes block) (.u64 8)
    let word ← C99FiniteRead114.read64 after.heap (KeygenRngSource.object block)
    pure ({before with heap := restore before.heap after.heap block},word,events)
  else none

theorem draw_sound (ctx : ShakeExtractSource.Layout) (propose : Proposal) (fuel block : Nat)
    (before after : State) (word : BitVec 64) (events : List Event)
    (computed : draw ctx propose fuel block before=some (after,word,events)) (checked : All ctx events) :
    KeygenRngSource.Call ctx (reference before) (reference after) word := by
  unfold draw at computed
  split at computed
  next unused =>
    obtain ⟨middleResult,extracted,rest⟩ := Option.bind_eq_some_iff.mp computed
    rcases middleResult with ⟨middle,innerEvents⟩
    dsimp only at rest
    obtain ⟨value,read,result⟩ := Option.bind_eq_some_iff.mp rest
    obtain ⟨sameState,sameRest⟩ := Prod.mk.inj (Option.some.inj result)
    obtain ⟨sameWord,sameEvents⟩ := Prod.mk.inj sameRest
    subst after
    subst word
    subst events
    rw [C99CompactState115.reference_heap before (restore before.heap middle.heap block),
      C99FiniteAllocation115.restore_source]
    have source := ShakeExtractTraceCall128.invoke_sound ctx propose fuel {before with heap := allocate before.heap block 8}
      middle (KeygenRngSource.bytes block) (.u64 8) innerEvents extracted checked
    rw [C99CompactState115.reference_heap before (allocate before.heap block 8),KeygenRngCompute121.allocate_bound] at source
    exact .run block (reference middle) value ((fresh_iff before.heap block).mp unused) source
      (C99FiniteRead114.read64_sound middle.heap (KeygenRngSource.object block) value read)
  next occupied => cases computed

end FT1536.Source3.KeygenRngTrace128
