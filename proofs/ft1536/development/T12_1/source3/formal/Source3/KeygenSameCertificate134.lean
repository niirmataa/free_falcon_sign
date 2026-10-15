import Source3.KeygenSameCertificate080
import Source3.KeygenLoopMaterial080
import Source3.KeygenAttemptAt134
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
namespace FT1536.Source3.KeygenSameCertificate134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenPrecertificate080 (Entry)
open KeygenMakeCertRelocation (CallAt SpaceAt)
open KeygenLoopAt080 hiding AttemptAccepted AttemptExecution AttemptRejected BoundFacts LoopTrace Numbered loop_bounds source_bounds
open KeygenLoopAt134
open KeygenSameCertificate080
theorem attempt_joined (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (facts : Entry ctx before input h primes rev) (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (space : SpaceAt ctx.scratch.block before.heap)
    (source : KeygenAttemptAt134.Exec ctx before out) (accepted : out.flow=.breakLoop) :
    Joined ctx (i+1) input h out.state := by
  cases source with
  | earlyRejected raw sample rejected => rw [rejected] at accepted; cases accepted
  | throughCertificate raw sample atCert out gate =>
    have step := KeygenMakeSearchPrefix134.sampled_remaining ctx before raw i remaining sample
    have profile := KeygenMakeCertCall.profile_of_dimensions raw.state step.2.1.2.1
    obtain ⟨after,v,call,equal⟩ := KeygenMakeCertRelocation.accepted_break_requires_callAt
      ctx.scratch.block ctx raw.state out gate profile accepted
    obtain ⟨rawInitial,frame⟩ := KeygenMakeRetryTransport134.sampled_entry ctx before raw i
      input h primes rev remaining facts.initial sample
    have rawSpace := KeygenCertificateAt080.space_preserved ctx _ _ primes rev frame space
    have package := KeygenCertificateOccurrence080.from_call ctx raw.state after v call step.2.1.2.1
      shape rawInitial.scratch rawSpace
    have witness := KeygenAttemptAt134.sampled_material ctx before raw i input h primes rev remaining facts sample atCert
    subst out
    exact ⟨raw.state,v,call,package,step.2.1.1,rawInitial.inputs,rawInitial.publicPointer,witness,
      fun slot => KeygenCertificateAt080.call_frame ctx raw.state after v true call step.2.1.2.1 shape
        rawInitial.scratch rawSpace (input slot).block (Ne.symm (rawInitial.scratchSeparate slot)),
      KeygenCertificateAt080.call_frame ctx raw.state after v true call step.2.1.2.1 shape
        rawInitial.scratch rawSpace h.block (Ne.symm facts.hProtected.1)⟩

theorem loop_joined (ctx : Context) (before : State) (out : Result)
    (attempts : List (AttemptExecution ctx)) (source : LoopTrace ctx before out attempts)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx) :
    ∀ (i : Nat), KeygenMakeSearchPrefix.Remaining before i →
      Entry ctx before input h primes rev → SpaceAt ctx.scratch.block before.heap →
      out.flow=.normal → Joined ctx (i+attempts.length) input h out.state := by
  induction source with
  | exhausted before out cap exit =>
    intro i remaining facts space normal
    exact (exit normal).elim
  | accepted a last =>
    intro i remaining facts space normal
    simpa only [List.length_singleton] using
      attempt_joined ctx a.before a.out i input h primes rev remaining facts shape space a.source last
  | retry a out rest rejected tail ih =>
    intro i remaining facts space normal
    obtain ⟨nextFacts,frame⟩ := KeygenRetryAt134.facts_after ctx a.before a.out i input h primes rev
      remaining facts shape space a.source
    have joined := ih (i+1)
      (KeygenRetryAt134.attempt_remaining ctx a.before a.out i remaining a.source).2.1 nextFacts
      (KeygenCertificateAt080.space_preserved ctx _ _ primes rev frame space) normal
    have length : i+(a::rest).length=(i+1)+rest.length := by simp only [List.length_cons]; omega
    rw [length]
    exact joined

end FT1536.Source3.KeygenSameCertificate134
