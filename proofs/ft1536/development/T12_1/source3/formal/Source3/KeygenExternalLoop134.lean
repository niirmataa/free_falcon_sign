import Source3.KeygenExternalLoop082
import Source3.KeygenExternalGates082
import Source3.KeygenAttemptAt134
import Source3.KeygenExternalGates134
import Source3.KeygenLoopAt134
import Source3.KeygenMakeRetryTransport134
import Source3.KeygenMakeSearchPrefix134
import Source3.KeygenRetryAt134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenExternalLoop134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenExternalSampling082 (Outside)
open KeygenMakeCertRelocation (SpaceAt)
open ShakeExtractFrame (SameBlock)


open KeygenExternalLoop082
theorem attempt (ctx : Context) (before : State) (out : Result) (i : Nat) (input : Fin 4 → ArrayPointer)
    (h primes rev : ArrayPointer) (block : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (outside : Outside ctx before input h block)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx) (space : SpaceAt ctx.scratch.block before.heap)
    (source : KeygenAttemptAt134.Exec ctx before out) : SameBlock before.heap out.state.heap block := by
  cases source with
  | earlyRejected raw sample rejected =>
    exact KeygenExternalGates134.sampled ctx before out i input h primes rev block remaining initial outside sample
  | throughCertificate raw sample atCert result gate =>
    have first := KeygenExternalGates134.sampled ctx before raw i input h primes rev block remaining initial outside sample
    obtain ⟨rawInitial,entryFrame⟩ := KeygenMakeRetryTransport134.sampled_entry ctx before raw i input h primes rev remaining initial sample
    have dims := (KeygenMakeSearchPrefix134.sampled_remaining ctx before raw i remaining sample).2.1.2.1
    have rawSpace := KeygenCertificateAt080.space_preserved ctx _ _ primes rev entryFrame space
    obtain ⟨v,ret,call⟩ := KeygenRetryAt080.gate_call ctx raw.state out gate dims
    have last := KeygenCertificateAt080.call_frame ctx raw.state out.state v ret call dims shape rawInitial.scratch
      rawSpace block (Ne.symm outside.scratch)
    exact KeygenPublicForeign081.same_trans _ _ _ block first last

theorem loop (ctx : Context) (before : State) (out : Result)
    (attempts : List (KeygenLoopAt134.AttemptExecution ctx))
    (source : KeygenLoopAt134.LoopTrace ctx before out attempts)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer) (block : Nat)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx) :
    ∀ i, KeygenMakeSearchPrefix.Remaining before i →
      KeygenCallerEntry.Initial ctx before input h primes rev → Outside ctx before input h block →
      SpaceAt ctx.scratch.block before.heap → out.flow=.normal → SameBlock before.heap out.state.heap block := by
  induction source with
  | exhausted before out cap exit =>
    intro i remaining initial outside space normal
    exact (exit normal).elim
  | accepted a accepted =>
    intro i remaining initial outside space normal
    exact attempt ctx a.before a.out i input h primes rev block remaining initial outside shape space a.source
  | retry a out rest rejected tail ih =>
    intro i remaining initial outside space normal
    have first := attempt ctx a.before a.out i input h primes rev block remaining initial outside shape space a.source
    have facts := KeygenRetryAt134.attempt_entry ctx a.before a.out i input h primes rev remaining initial shape space a.source
    have nextOutside := KeygenExternalSampling082.moved ctx a.before a.out.state input h block outside facts.2.2 first.1
    have last := ih (i+1) (KeygenRetryAt134.attempt_remaining ctx a.before a.out i remaining a.source).2.1
      facts.1 nextOutside (KeygenCertificateAt080.space_preserved ctx _ _ primes rev facts.2.1 space) normal
    exact KeygenPublicForeign081.same_trans _ _ _ block first last

end FT1536.Source3.KeygenExternalLoop134
