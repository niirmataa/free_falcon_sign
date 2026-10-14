import Source3.KeygenSamplerTail121

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSamplerRefill121
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open ShakeExtractSource (Layout)

def refill (ctx : Layout) (rngFuel block : Nat) (before : State) : Option State := do
  let value ← C99CompactScalar115.evaluate noCalls before.locals KeygenSamplerSource.refillCondition
  if value.integer=0 then pure before else do
    let cell ← C99NameMap115.lookup before.locals "rb".toList
    let (drawn,word) ← KeygenRngCompute121.draw ctx rngFuel block before
    KeygenScalarCompute121.run 16 KeygenSamplerSource.assignBits
      (C99CompactState115.bindValue drawn "rb".toList cell.ty (.u64 word))

theorem refill_sound (ctx : Layout) (rngFuel block : Nat) (before after : State)
    (computed : refill ctx rngFuel block before=some after) :
    KeygenSamplerSource.Refill ctx (reference before) (reference after) := by
  obtain ⟨value,evaluated,rest⟩ := Option.bind_eq_some_iff.mp computed
  have guard := C99CompactScalar115.evaluate_sound FprPrefixCalls.calls noCalls (C99CompactPointer115.noCalls_sound _)
    before.locals KeygenSamplerSource.refillCondition value evaluated
  split at rest
  next zero =>
    have same := Option.some.inj rest
    subst after
    exact .skip (reference before) (C99ValueBridge.value value) guard
      (by simpa only [C99ValueBridge.integer_matches] using zero)
  next nonzero =>
    obtain ⟨cell,declared,rest⟩ := Option.bind_eq_some_iff.mp rest
    obtain ⟨⟨drawn,word⟩,draw,bits⟩ := Option.bind_eq_some_iff.mp rest
    refine .fill (reference before) (reference drawn) (reference after) (C99ValueBridge.value value) word
      (C99ValueBridge.type cell.ty) (cell.value.map C99ValueBridge.value) guard
      (by simpa only [C99ValueBridge.integer_matches] using nonzero) ?_
      (KeygenRngCompute121.draw_sound ctx rngFuel block before drawn word draw) ?_
    · change (C99NameMap115.lookup before.locals "rb".toList).map C99CompactCells115.Cell.reference = _
      rw [declared]
      rfl
    · have source := KeygenScalarCompute121.run_sound 16 KeygenSamplerSource.assignBits
        (C99CompactState115.bindValue drawn "rb".toList cell.ty (.u64 word)) after bits
      rw [C99CompactState115.reference_bindValue] at source
      exact source

end FT1536.Source3.KeygenSamplerRefill121
