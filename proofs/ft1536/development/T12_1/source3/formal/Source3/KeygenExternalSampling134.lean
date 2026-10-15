import Source3.KeygenExternalSampling082
import Source3.KeygenSecretComplete081
import Source3.KeygenAttemptNorm133
import Source3.KeygenCallerPrefix134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenExternalSampling134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open ShakeExtractFrame (SameBlock)




open KeygenExternalSampling082
theorem ternary (ctx : Context) (before : State) (out : Result) (input : Fin 4 → ArrayPointer)
    (h : ArrayPointer) (block : Nat) (outside : Outside ctx before input h block)
    (entry : KeygenAttemptMaterial.Entry ctx before (input 0) (input 1))
    (shield : KeygenAttemptNorm.Protected ctx before block)
    (source : KeygenCallerPrefix134.Ternary ctx before out) : SameBlock before.heap out.state.heap block := by
  cases source with
  | resultantRejected middle sampled result first second gate rejected =>
    exact KeygenPublicForeign081.same_trans _ _ _ block
      (two_samplers ctx before middle sampled input h block outside entry first second)
      (resultants sampled out gate block)
  | norm middle sampled res result first second gate norm =>
    have sampling := two_samplers ctx before middle sampled input h block outside entry first second
    have resultant := resultants sampled ⟨res,.normal⟩ gate block
    have slots := KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ first)
      (KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ second)
        (KeygenAttemptMaterial.resultants sampled ⟨res,.normal⟩ gate).1)
    have shieldRes := KeygenAttemptMaterial.protected_slots ctx before res block slots shield
    have stable := KeygenAttemptNorm133.stable ctx res out norm
    have normFrame : SameBlock res.heap out.state.heap block :=
      ⟨stable.size,stable.writable,KeygenAttemptNorm133.bytes ctx res out norm block shieldRes⟩
    exact KeygenPublicForeign081.same_trans _ _ _ block sampling
      (KeygenPublicForeign081.same_trans _ _ _ block resultant normFrame)

end FT1536.Source3.KeygenExternalSampling134
