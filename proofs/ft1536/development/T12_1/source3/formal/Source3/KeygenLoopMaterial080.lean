import Source3.KeygenLoopAt080
import Source3.KeygenCertificateOccurrence080

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLoopMaterial080
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenMakeCertRelocation (CallAt SpaceAt)
open KeygenPrecertificate080 (Entry)
open KeygenLoopAt080

theorem material (ctx : Context) (before : State) (out : Result)
    (attempts : List (AttemptExecution ctx)) (source : LoopTrace ctx before out attempts)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx) :
    ∀ (i : Nat), KeygenMakeSearchPrefix.Remaining before i →
      Entry ctx before input h primes rev → SpaceAt ctx.scratch.block before.heap →
      out.flow=.normal → KeygenMakeMaterialWitness.Witness out.state.heap input h ∧
      KeygenMakeRetryTransport.EntryFrame ctx before.heap out.state.heap primes rev := by
  induction source with
  | exhausted before out cap exit =>
    intro i remaining facts space normal
    exact (exit normal).elim
  | accepted a last =>
    intro i remaining facts space normal
    exact ⟨KeygenAttemptAt080.accepted_material ctx a.before a.out i input h primes rev
      remaining facts shape space a.source last,
      (KeygenRetryAt080.facts_after ctx a.before a.out i input h primes rev remaining facts shape space a.source).2⟩
  | retry a out rest rejected tail ih =>
    intro i remaining facts space normal
    obtain ⟨nextFacts,frame⟩ := KeygenRetryAt080.facts_after ctx a.before a.out i input h primes rev
      remaining facts shape space a.source
    obtain ⟨witness,later⟩ := ih (i+1)
      (KeygenRetryAt080.attempt_remaining ctx a.before a.out i remaining a.source).2.1 nextFacts
      (KeygenCertificateAt080.space_preserved ctx _ _ primes rev frame space) normal
    exact ⟨witness,KeygenMakeRetryTransport.entry_frame_trans ctx _ _ _ primes rev frame later⟩

/-- The one-based call identifier is the executed attempt counter at the
    certificate gate. This is a conclusion about one actual attempt record. -/
def AttemptCertificate (ctx : Context) (id : Nat) (a : AttemptExecution ctx) : Prop :=
  ∃ (raw : State) (v : C99IntegerReference.Value),
    KeygenMakeSearchPrefix.Sampled ctx a.before ⟨raw,.normal⟩ ∧
    CallAt ctx.scratch.block ctx raw a.out.state v true ∧
    KeygenCertificateOccurrence080.Package ctx raw a.out.state ∧ KeygenCapWords.Count raw id

theorem attempt_certificate (ctx : Context) (a : AttemptExecution ctx) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining a.before i)
    (initial : KeygenCallerEntry.Initial ctx a.before input h primes rev)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (space : SpaceAt ctx.scratch.block a.before.heap)
    (accepted : AttemptAccepted a) : AttemptCertificate ctx (i+1) a := by
  rcases a with ⟨before,out,source⟩
  change out.flow=.breakLoop at accepted
  cases source with
  | earlyRejected raw sample rejected => rw [rejected] at accepted; cases accepted
  | throughCertificate raw sample atCert out gate =>
    have step := KeygenMakeSearchPrefix.sampled_remaining ctx before raw i remaining sample
    have profile := KeygenMakeCertCall.profile_of_dimensions raw.state step.2.1.2.1
    obtain ⟨after,v,call,equal⟩ := KeygenMakeCertRelocation.accepted_break_requires_callAt
      ctx.scratch.block ctx raw.state out gate profile accepted
    obtain ⟨rawInitial,frame⟩ := KeygenMakeRetryTransport.sampled_entry ctx before raw i
      input h primes rev remaining initial sample
    have rawSpace := KeygenCertificateAt080.space_preserved ctx _ _ primes rev frame space
    have package := KeygenCertificateOccurrence080.from_call ctx raw.state after v call step.2.1.2.1
      shape rawInitial.scratch rawSpace
    subst out
    refine ⟨raw.state,v,?_,call,package,step.2.1.1⟩
    cases raw with
    | mk state flow => cases atCert; exact sample

/-- The final certificate package is attached to the final element of the
    chronological source list and to the SAME serialization-entry state.
    Rejected prefixes advance the identifier by their actual length. -/
theorem final_certificate (ctx : Context) (before : State) (out : Result)
    (attempts : List (AttemptExecution ctx)) (source : LoopTrace ctx before out attempts)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx) :
    ∀ (i : Nat), KeygenMakeSearchPrefix.Remaining before i →
      KeygenCallerEntry.Initial ctx before input h primes rev →
      SpaceAt ctx.scratch.block before.heap → out.flow=.normal →
      ∃ rejected final, attempts=rejected++[final] ∧
        (∀ a∈rejected, AttemptRejected a) ∧ AttemptAccepted final ∧
        final.out.state=out.state ∧ AttemptCertificate ctx (i+attempts.length) final := by
  induction source with
  | exhausted before out cap exit =>
    intro i remaining initial space normal
    exact (exit normal).elim
  | accepted a last =>
    intro i remaining initial space normal
    exact ⟨[],a,rfl,by simp,last,rfl,
      by simpa using attempt_certificate ctx a i input h primes rev remaining initial shape space last⟩
  | retry a out rest rejected tail ih =>
    intro i remaining initial space normal
    obtain ⟨nextInitial,frame,_⟩ := KeygenRetryAt080.attempt_entry ctx a.before a.out i input h primes rev
      remaining initial shape space a.source
    obtain ⟨earlier,final,shapeList,rejects,last,same,package⟩ := ih (i+1)
      (KeygenRetryAt080.attempt_remaining ctx a.before a.out i remaining a.source).2.1 nextInitial
      (KeygenCertificateAt080.space_preserved ctx _ _ primes rev frame space) normal
    refine ⟨a::earlier,final,by simp only [shapeList,List.cons_append],?_,last,same,?_⟩
    · intro b member
      rcases List.mem_cons.mp member with equal | member
      · subst b; exact rejected
      · exact rejects b member
    · have length : i+(a::rest).length=(i+1)+rest.length := by simp only [List.length_cons]; omega
      rw [length]
      exact package

end FT1536.Source3.KeygenLoopMaterial080
