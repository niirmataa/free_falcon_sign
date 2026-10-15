import Source3.KeygenCallerPrefix
import Source3.KeygenCallerTransport
import Source3.KeygenAttemptMaterial134
import Source3.KeygenAttemptNorm133
import Source3.KeygenCallerTransport134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenCallerPrefix134
open C99ArrayReference (State Name)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenAttemptMaterial (Material PublicGate)
open KeygenRootCaller (Legal)
open KeygenCallerEntry (Initial)
open KeygenAttemptSlots (Slots)


open KeygenCallerPrefix
inductive Ternary (ctx : Context) (before : State) : Result → Prop where
  | resultantRejected (middle sampled : State) (out : Result)
      (first : KeygenSamplerContext.Call ctx before "f" middle) (second : KeygenSamplerContext.Call ctx middle "g" sampled)
      (gate : KeygenResultantGate.Exec sampled out) (rejected : out.flow=.continueLoop) : Ternary ctx before out
  | norm (middle sampled res : State) (out : Result)
      (first : KeygenSamplerContext.Call ctx before "f" middle) (second : KeygenSamplerContext.Call ctx middle "g" sampled)
      (resultants : KeygenResultantGate.Exec sampled ⟨res,.normal⟩)
      (norm : KeygenAttemptNorm133.Exec ctx res out) : Ternary ctx before out

theorem ternary_slots (ctx : Context) (before : State) (out : Result) (source : Ternary ctx before out) : Slots before out.state := by
  cases source with
  | resultantRejected middle sampled out first second gate rejected =>
    exact KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ first)
      (KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ second) (KeygenAttemptMaterial.resultants _ _ gate).1)
  | norm middle sampled res out first second resultants norm =>
    exact KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ first)
      (KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ second)
        (KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.resultants _ _ resultants).1 (KeygenAttemptNorm133.slots _ _ _ norm)))

theorem ternary_size (ctx : Context) (before : State) (out : Result) (f g : ArrayPointer)
    (entry : KeygenAttemptMaterial.Entry ctx before f g) (source : Ternary ctx before out) : out.state.heap.size=before.heap.size := by
  cases source with
  | resultantRejected middle sampled out first second gate rejected =>
    exact (KeygenAttemptMaterial.resultants _ _ gate).2.size.trans
      (KeygenAttemptMaterial.sampling_metadata ctx before middle sampled f g entry first second).1
  | norm middle sampled res out first second resultants norm =>
    exact (KeygenAttemptNorm133.stable _ _ _ norm).size.trans ((KeygenAttemptMaterial.resultants _ _ resultants).2.size.trans
      (KeygenAttemptMaterial.sampling_metadata ctx before middle sampled f g entry first second).1)

theorem ternary_material (ctx : Context) (before : State) (out : Result) (f g : ArrayPointer)
    (entry : KeygenAttemptMaterial.Entry ctx before f g) (source : Ternary ctx before out) : Material out.state.heap f g := by
  cases source with
  | resultantRejected middle sampled out first second gate rejected =>
    exact KeygenAttemptMaterial.through_resultants _ _ gate f g (KeygenAttemptMaterial.sampled_material ctx before middle sampled f g entry first second)
  | norm middle sampled res out first second resultants norm =>
    have slots := KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ first)
      (KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ second) (KeygenAttemptMaterial.resultants _ _ resultants).1)
    exact KeygenAttemptMaterial134.through_norm ctx res out norm f g
      (KeygenAttemptMaterial.protected_slots _ _ _ _ slots entry.fNorm) (KeygenAttemptMaterial.protected_slots _ _ _ _ slots entry.gNorm)
      (KeygenAttemptMaterial.through_resultants _ _ resultants f g (KeygenAttemptMaterial.sampled_material ctx before middle sampled f g entry first second))

theorem ternary_root (ctx : Context) (before : State) (out : Result) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (entry : KeygenAttemptMaterial.Entry ctx before (input 0) (input 1)) (legal : Legal ctx before input primes rev)
    (primesLive : 0<before.heap.size primes.block) (revLive : 0<before.heap.size rev.block)
    (separate : KeygenAttemptNorm.Protected ctx before ctx.object.block) (source : Ternary ctx before out) : Legal ctx out.state input primes rev := by
  cases source with
  | resultantRejected middle sampled out first second gate rejected =>
    exact KeygenCallerTransport.resultant_root ctx sampled out input primes rev
      (KeygenCallerTransport.sampling_root ctx before middle sampled input primes rev entry legal primesLive revLive first second) gate
  | norm middle sampled res out first second resultants norm =>
    have sampledLegal := KeygenCallerTransport.sampling_root ctx before middle sampled input primes rev entry legal primesLive revLive first second
    have resLegal := KeygenCallerTransport.resultant_root ctx sampled ⟨res,.normal⟩ input primes rev sampledLegal resultants
    have slots := KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ first)
      (KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ second) (KeygenAttemptMaterial.resultants _ _ resultants).1)
    exact KeygenCallerTransport134.norm_root ctx res out input primes rev resLegal
      (KeygenAttemptMaterial.protected_slots _ _ _ _ slots separate) norm

end FT1536.Source3.KeygenCallerPrefix134
