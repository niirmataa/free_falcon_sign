import Source3.KeygenResultantRun130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenResultantRunSound130
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open KeygenResultantRun130 (run)

theorem sound (fuel block : Nat) (before after : State) (args : List C99ArrayReference.Arg)
    (outValue : B20.C.Val) (computed : run fuel block before args=some (after,outValue)) :
    KeygenResultantSource.Call (reference before) args (reference after) (C99ValueBridge.value outValue) := by
  obtain ⟨bound,binding,rest⟩ := Option.bind_eq_some_iff.mp computed
  split at rest
  next fresh =>
    obtain ⟨ready,setup,rest⟩ := Option.bind_eq_some_iff.mp rest
    split at rest
    next zeroGuard =>
      obtain ⟨packed,packing,rest⟩ := Option.bind_eq_some_iff.mp rest
      obtain ⟨word,profile,rest⟩ := Option.bind_eq_some_iff.mp rest
      obtain ⟨reduced,fallthrough,rest⟩ := Option.bind_eq_some_iff.mp rest
      obtain ⟨tail,ending,result⟩ := Option.bind_eq_some_iff.mp rest
      rcases tail with ⟨last,returned⟩
      dsimp only at result
      obtain ⟨sameState,sameValue⟩ := Prod.mk.inj (Option.some.inj result)
      subst after outValue
      rw [C99CompactState115.reference_heap before (C99FiniteAllocation115.restore before.heap last.heap block),
        C99FiniteAllocation115.restore_source]
      refine KeygenResultantSource.Call.run (reference bound) (reference ready) (reference packed) (reference reduced)
        ⟨reference last,.returned (some (C99ValueBridge.value returned))⟩ block word
        (C99ValueBridge.value (B20.C.cast .u32 returned))
        (C99CompactBinding115.bind_sound noCalls (C99CompactPointer115.noCalls_sound _) before bound _ _ binding)
        ((C99FiniteAllocation115.fresh_iff bound.heap block).mp fresh) ?_
        (KeygenResultantInit130.zero_legal ready block zeroGuard) ?_
        (KeygenResultantRun130.profile_sound packed word profile)
        (KeygenWordEndpoints130.normal_sound fuel _ packed reduced fallthrough)
        (KeygenWordEndpoints130.returned_sound fuel _ reduced last returned ending) ?_
      · have source := KeygenScalarCompute121.run_sound 16 KeygenResultantSource.setup
          (KeygenResultantInit130.entry bound block) ready setup
        rw [KeygenResultantInit130.entry_source] at source
        exact source
      · have source := KeygenWordEndpoints130.normal_sound fuel KeygenResultantSource.packing
          (KeygenResultantInit130.zeroed ready block) packed packing
        rw [KeygenResultantInit130.zero_source ready block zeroGuard] at source
        exact source
      · simpa only [C99ValueBridge.cast_matches,C99ValueBridge.type] using
          (C99ProcedureReference.ReturnValue.value .uint32 (C99ValueBridge.value returned))
    next rejected => cases rest
  next occupied => cases rest

end FT1536.Source3.KeygenResultantRunSound130
