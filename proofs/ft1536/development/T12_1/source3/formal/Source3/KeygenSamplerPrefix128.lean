import Source3.KeygenOuterSegment128

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSamplerPrefix128
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open ShakeProcessEvents128 (Proposal Event All)
open KeygenOuterSegment128 (run declareX declaration_source)

/-- A finite source prefix, with the original guard, declaration, complete
    rejection loop, scope restoration and increment at every iteration. -/
inductive Prefix (ctx : ShakeExtractSource.Layout) : Nat → C99ArrayReference.State → C99ArrayReference.State → Prop where
  | done (state : C99ArrayReference.State) : Prefix ctx 0 state state
  | next (count : Nat) (before declared sampled updated after : C99ArrayReference.State) (value : C99IntegerReference.Value)
      (guard : C99ArrayReference.scalar before C99CountedWords.condition value) (nonzero : value.integer≠0)
      (declaration : C99ModularReference.Exec KeygenSamplerSource.declareX before ⟨declared,.normal⟩)
      (inner : KeygenSamplerSource.Inner ctx declared sampled)
      (increment : C99ModularReference.Exec KeygenSamplerSource.increment
        (C99ArrayReference.restoreScope before sampled ["x".toList] []) ⟨updated,.normal⟩)
      (rest : Prefix ctx count updated after) : Prefix ctx (count+1) before after

theorem finish (ctx : ShakeExtractSource.Layout) (count : Nat) (before after finalState : C99ArrayReference.State)
    (source : Prefix ctx count before after) (continuation : KeygenSamplerSource.Outer ctx after finalState) :
    KeygenSamplerSource.Outer ctx before finalState := by
  induction source with
  | done => exact continuation
  | next count before declared sampled updated after value guard nonzero declaration inner increment rest ih =>
      exact .next before declared sampled updated finalState value guard nonzero declaration inner increment (ih continuation)

theorem run_prefix (ctx : ShakeExtractSource.Layout) (propose : Proposal) (rngFuel block innerFuel count : Nat)
    (before after : State) (events : List Event)
    (computed : run ctx propose rngFuel block innerFuel count before=some (after,events)) (checked : All ctx events) :
    Prefix ctx count (reference before) (reference after) := by
  induction count generalizing before after events with
  | zero =>
      have same := (Prod.mk.inj (Option.some.inj computed)).1
      subst after
      exact .done _
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
        exact .next count (reference before) (reference (declareX before)) (reference sampled) (reference updated) (reference last)
          (C99ValueBridge.value value) guard (by simpa only [C99ValueBridge.integer_matches] using nonzero)
          (declaration_source before)
          (KeygenInnerTrace128.run_sound ctx propose rngFuel block innerFuel (declareX before) sampled headEvents inner
            (ShakeProcessEvents128.left ctx _ _ checked)) update
          (ih updated last tailEvents following (ShakeProcessEvents128.right ctx _ _ checked))


end FT1536.Source3.KeygenSamplerPrefix128
