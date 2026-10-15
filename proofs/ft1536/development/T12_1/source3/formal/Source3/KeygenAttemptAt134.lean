import Source3.KeygenAttemptAt080
import Source3.KeygenPrecertificate080
import Source3.KeygenCertificateAt080
import Source3.KeygenMakeRetryTransport134
import Source3.KeygenMakeSearchPrefix134
import Source3.KeygenPrecertificate134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenAttemptAt134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenMakeCertRelocation (CallAt SpaceAt CertificateGateAt)
open KeygenPrecertificate080 (Entry)


open KeygenAttemptAt080
theorem sampled_material (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (facts : Entry ctx before input h primes rev)
    (source : KeygenMakeSearchPrefix134.Sampled ctx before out) (normal : out.flow=.normal) :
    KeygenMakeMaterialWitness.Witness out.state.heap input h := by
  cases source with
  | run entry raw cap gates =>
    cases gates with
    | ternaryRejected raw ternary rejected =>
      have bad : raw.flow=.normal := normal
      rw [rejected] at bad
      cases bad
    | publicRejected normed raw ternary publicGate rejected =>
      rw [rejected] at normal
      cases normal
    | solver normed publicState raw ternary publicGate rootGate =>
      obtain ⟨pv,publicCall,publicNonzero⟩ := KeygenMakeAttemptSpine.public_gate_call
        (KeygenCallerPrefix.close before normed) ⟨publicState,.normal⟩ publicGate rfl
      cases ternary with
      | resultantRejected middle sampled res first second resultants rejected => cases rejected
      | norm middle sampled res normOut first second resultants norms =>
        cases rootGate with
        | reject after v call zero => cases normal
        | accept after v call nonzero =>
          exact KeygenPrecertificate134.source_material ctx before entry middle sampled res normed
            publicState after pv v i input h primes rev remaining facts cap first second resultants
            norms publicCall publicNonzero call (KeygenCallerSuccess.nonzero_one ctx publicState after v call nonzero)

inductive Exec (ctx : Context) (before : State) : Result → Prop where
  | earlyRejected (raw : Result) (sample : KeygenMakeSearchPrefix134.Sampled ctx before raw)
      (rejected : raw.flow=.continueLoop) : Exec ctx before raw
  | throughCertificate (raw : Result) (sample : KeygenMakeSearchPrefix134.Sampled ctx before raw)
      (atCert : raw.flow=.normal) (out : Result)
      (gate : CertificateGateAt ctx.scratch.block ctx raw.state out) : Exec ctx before out

theorem accepted_material (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (facts : Entry ctx before input h primes rev)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (space : SpaceAt ctx.scratch.block before.heap)
    (source : Exec ctx before out) (accepted : out.flow=.breakLoop) :
    KeygenMakeMaterialWitness.Witness out.state.heap input h := by
  cases source with
  | earlyRejected raw sample rejected => rw [rejected] at accepted; cases accepted
  | throughCertificate raw sample atCert out gate =>
    have dimensions := (KeygenMakeSearchPrefix134.sampled_remaining ctx before raw i remaining sample).2.1.2.1
    have profile := KeygenMakeCertCall.profile_of_dimensions raw.state dimensions
    obtain ⟨after,v,call,outEq⟩ := KeygenMakeCertRelocation.accepted_break_requires_callAt
      ctx.scratch.block ctx raw.state out gate profile accepted
    subst out
    obtain ⟨rawInitial,frame⟩ := KeygenMakeRetryTransport134.sampled_entry ctx before raw i
      input h primes rev remaining facts.initial sample
    have rawSpace := KeygenCertificateAt080.space_preserved ctx before.heap raw.state.heap primes rev frame space
    have witness := sampled_material ctx before raw i input h primes rev remaining facts sample atCert
    exact KeygenMakeMaterialWitness.witness_represented raw.state.heap after.heap input h
      (fun slot => KeygenCertificateAt080.call_frame ctx raw.state after v true call dimensions shape
        rawInitial.scratch rawSpace (input slot).block (Ne.symm (rawInitial.scratchSeparate slot)))
      (KeygenCertificateAt080.call_frame ctx raw.state after v true call dimensions shape
        rawInitial.scratch rawSpace h.block (Ne.symm facts.hProtected.1)) witness

end FT1536.Source3.KeygenAttemptAt134
