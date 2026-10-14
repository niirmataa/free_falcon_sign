import Source3.KeygenInnerTrace128

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenOuterSegment128
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open ShakeProcessEvents128 (Proposal Result Event All)

def declareX (before : State) : State :=
  {before with locals := C99CompactScalar115.declareMany before.locals .u32 ["x".toList]}

theorem declaration_source (before : State) :
    C99ModularReference.Exec KeygenSamplerSource.declareX (reference before) ⟨reference (declareX before),.normal⟩ :=
  KeygenScalarCompute121.run_sound 16 KeygenSamplerSource.declareX before (declareX before) rfl

/-- A proof cut after exactly count successful coefficient iterations.
    The actual source n and every guard remain unchanged. This is not an
    early return of the sampler; source completion needs its continuation. -/
def run (ctx : ShakeExtractSource.Layout) (propose : Proposal) (rngFuel block innerFuel : Nat) : Nat → State → Option Result
  | 0, before => some (before,[])
  | count+1, before => do
      let guard ← C99CompactScalar115.evaluate noCalls before.locals C99CountedWords.condition
      if guard.integer=0 then none else do
        let (sampled,headEvents) ← KeygenInnerTrace128.run ctx propose rngFuel block innerFuel (declareX before)
        let restored := C99CompactState115.restoreScope before sampled ["x".toList] []
        let updated ← KeygenScalarCompute121.run 16 KeygenSamplerSource.increment restored
        let (after,tailEvents) ← run ctx propose rngFuel block innerFuel count updated
        pure (after,headEvents++tailEvents)

theorem run_sound (ctx : ShakeExtractSource.Layout) (propose : Proposal) (rngFuel block innerFuel count : Nat)
    (before after : State) (events : List Event) (finalState : C99ArrayReference.State)
    (computed : run ctx propose rngFuel block innerFuel count before=some (after,events)) (checked : All ctx events)
    (continuation : KeygenSamplerSource.Outer ctx (reference after) finalState) :
    KeygenSamplerSource.Outer ctx (reference before) finalState := by
  induction count generalizing before after events with
  | zero =>
      have same := (Prod.mk.inj (Option.some.inj computed)).1
      subst after
      exact continuation
  | succ count ih =>
      obtain ⟨value,evaluated,rest⟩ := Option.bind_eq_some_iff.mp computed
      have guard := C99CompactScalar115.evaluate_sound FprPrefixCalls.calls noCalls (C99CompactPointer115.noCalls_sound _)
        before.locals C99CountedWords.condition value evaluated
      split at rest
      next zero => cases rest
      next nonzero =>
        obtain ⟨head,inner,rest⟩ := Option.bind_eq_some_iff.mp rest
        rcases head with ⟨sampled,headEvents⟩
        dsimp only at rest
        obtain ⟨updated,increment,rest⟩ := Option.bind_eq_some_iff.mp rest
        obtain ⟨tail,following,result⟩ := Option.bind_eq_some_iff.mp rest
        rcases tail with ⟨last,tailEvents⟩
        obtain ⟨sameState,sameEvents⟩ := Prod.mk.inj (Option.some.inj result)
        subst after
        subst events
        have update := KeygenScalarCompute121.run_sound 16 KeygenSamplerSource.increment
          (C99CompactState115.restoreScope before sampled ["x".toList] []) updated increment
        rw [C99CompactState115.reference_restoreScope] at update
        exact .next (reference before) (reference (declareX before)) (reference sampled) (reference updated) finalState
          (C99ValueBridge.value value) guard (by simpa only [C99ValueBridge.integer_matches] using nonzero)
          (declaration_source before)
          (KeygenInnerTrace128.run_sound ctx propose rngFuel block innerFuel (declareX before) sampled headEvents inner
            (ShakeProcessEvents128.left ctx _ _ checked)) update
          (ih updated last tailEvents following (ShakeProcessEvents128.right ctx _ _ checked) continuation)

end FT1536.Source3.KeygenOuterSegment128
