import Source3.KeygenRngTrace128
import Source3.KeygenSamplerRefill121

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenRefillTrace128
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open ShakeProcessEvents128 (Proposal Result Event All)

def refill (ctx : ShakeExtractSource.Layout) (propose : Proposal) (fuel block : Nat) (before : State) : Option Result := do
  let value ← C99CompactScalar115.evaluate noCalls before.locals KeygenSamplerSource.refillCondition
  if value.integer=0 then pure (before,[]) else do
    let cell ← C99NameMap115.lookup before.locals "rb".toList
    let (drawn,word,events) ← KeygenRngTrace128.draw ctx propose fuel block before
    let after ← KeygenScalarCompute121.run 16 KeygenSamplerSource.assignBits
      (C99CompactState115.bindValue drawn "rb".toList cell.ty (.u64 word))
    pure (after,events)

theorem refill_sound (ctx : ShakeExtractSource.Layout) (propose : Proposal) (fuel block : Nat)
    (before after : State) (events : List Event)
    (computed : refill ctx propose fuel block before=some (after,events)) (checked : All ctx events) :
    KeygenSamplerSource.Refill ctx (reference before) (reference after) := by
  obtain ⟨value,evaluated,rest⟩ := Option.bind_eq_some_iff.mp computed
  have guard := C99CompactScalar115.evaluate_sound FprPrefixCalls.calls noCalls (C99CompactPointer115.noCalls_sound _)
    before.locals KeygenSamplerSource.refillCondition value evaluated
  split at rest
  next zero =>
    have same := (Prod.mk.inj (Option.some.inj rest)).1
    subst after
    exact .skip (reference before) (C99ValueBridge.value value) guard
      (by simpa only [C99ValueBridge.integer_matches] using zero)
  next nonzero =>
    obtain ⟨cell,declared,rest⟩ := Option.bind_eq_some_iff.mp rest
    obtain ⟨drawResult,draw,rest⟩ := Option.bind_eq_some_iff.mp rest
    rcases drawResult with ⟨drawn,word,innerEvents⟩
    dsimp only at rest
    obtain ⟨middle,bits,result⟩ := Option.bind_eq_some_iff.mp rest
    obtain ⟨sameState,sameEvents⟩ := Prod.mk.inj (Option.some.inj result)
    subst after
    subst events
    refine .fill (reference before) (reference drawn) (reference middle) (C99ValueBridge.value value) word
      (C99ValueBridge.type cell.ty) (cell.value.map C99ValueBridge.value) guard
      (by simpa only [C99ValueBridge.integer_matches] using nonzero) ?_
      (KeygenRngTrace128.draw_sound ctx propose fuel block before drawn word innerEvents draw checked) ?_
    · change (C99NameMap115.lookup before.locals "rb".toList).map C99CompactCells115.Cell.reference = _
      rw [declared]
      rfl
    · have source := KeygenScalarCompute121.run_sound 16 KeygenSamplerSource.assignBits
        (C99CompactState115.bindValue drawn "rb".toList cell.ty (.u64 word)) middle bits
      rw [C99CompactState115.reference_bindValue] at source
      exact source

end FT1536.Source3.KeygenRefillTrace128
