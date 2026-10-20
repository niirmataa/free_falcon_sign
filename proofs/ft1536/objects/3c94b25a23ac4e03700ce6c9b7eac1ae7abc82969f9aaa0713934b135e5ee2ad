import Source3.KeygenMakeReady
import Source3.KeygenMakeSampling

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Remove047's already-ready subset at the SAME first-sampling boundary.
   The first cap domain follows from the source counter0, not an extra
   reachable-count premise. Global attempt chronology remains a later step. -/
namespace FT1536.Source3.KeygenMakeReadySampling
open C99ArrayReference (State)
open C99MemoryReference
open KeygenSearchContext (Context)
open KeygenMakeSampling

inductive FirstSamples (ctx : Context) (before : State) (blocks : Fin 6 → Nat) : List KeygenEntropySource.Event → State → Prop where
  | run (events : List KeygenEntropySource.Event) (loopEntry samplerEntry middle after : State)
      (head : KeygenMakeReady.Prefix ctx before blocks events ⟨loopEntry,.normal⟩)
      (cap : CappedSetup ctx loopEntry ⟨samplerEntry,.normal⟩)
      (first : KeygenSamplerContext.Call ctx samplerEntry "f" middle)
      (second : KeygenSamplerContext.Call ctx middle "g" after) : FirstSamples ctx before blocks events after
theorem source_same_material (ctx : Context) (before after : State) (blocks : Fin 6 → Nat) (primes rev : ArrayPointer)
    (original : KeygenMakeEntry.Original ctx before primes rev) (events : List KeygenEntropySource.Event)
    (source : FirstSamples ctx before blocks events after) :
    KeygenCapWords.Count after 1 ∧ KeygenAttemptMaterial.Material after.heap
      (KeygenMakeEntry.input blocks 0) (KeygenMakeEntry.input blocks 1) := by
  cases source with
  | run loopEntry samplerEntry middle after head cap first second =>
    have facts := KeygenMakeReady.normal_prefix ctx before loopEntry blocks primes rev original events head
    have locals := KeygenMakeReady.normal_prefix_locals ctx before loopEntry blocks primes rev original events head
    have size : C99CountedWords.Limit loopEntry := by
      change loopEntry.locals "n".toList=some (.uint64,some (.uint64 1536))
      rw [locals]
      rfl
    rcases cap_before_setup ctx loopEntry 0 ⟨samplerEntry,.normal⟩ (by decide) facts.1 size cap with aborted | running
    · have bad := aborted.1; dsimp [KeygenAttemptCap.limit] at bad; omega
    · have equal : samplerEntry=prepared ctx (KeygenCapWords.advanced loopEntry 0) := congrArg C99ProcedureReference.Result.state running.2.1
      subst samplerEntry
      have entry := entry_from_prepared ctx loopEntry 0 _ _ primes rev facts.2.1 size
      refine ⟨?_,KeygenAttemptMaterial.sampled_material ctx _ middle after _ _ entry first second⟩
      change after.locals "local_attempts".toList=some (.uint64,some (.uint64 1))
      rw [sampler_locals ctx middle after "g" second,sampler_locals ctx _ middle "f" first]
      exact running.2.2

end FT1536.Source3.KeygenMakeReadySampling
