import Source3.KeygenRetryAt080
import Source3.KeygenAttemptAt080
import Source3.KeygenAcceptedLoop079
import Source3.KeygenAcceptedLoop134
import Source3.KeygenAttemptAt134
import Source3.KeygenMakeRetryTransport134
import Source3.KeygenMakeSearchPrefix134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenRetryAt134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenMakeCertRelocation (CallAt SpaceAt CertificateGateAt)
open KeygenPrecertificate080 (Entry)


open KeygenRetryAt080
theorem attempt_remaining (ctx : Context) (before : State) (out : Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (source : KeygenAttemptAt134.Exec ctx before out) :
    i<KeygenAttemptCap.limit ∧ KeygenMakeSearchPrefix.Remaining out.state (i+1) ∧
      (out.flow=.continueLoop ∨ out.flow=.breakLoop) := by
  cases source with
  | earlyRejected raw sample rejected =>
    have step := KeygenMakeSearchPrefix134.sampled_remaining ctx before _ i remaining sample
    exact ⟨step.1,step.2.1,Or.inl rejected⟩
  | throughCertificate raw sample atCert out gate =>
    have step := KeygenMakeSearchPrefix134.sampled_remaining ctx before raw i remaining sample
    obtain ⟨v,ret,call⟩ := gate_call ctx raw.state out gate step.2.1.2.1
    have cells := (KeygenMakeCertRelocation.callAt_cells ctx.scratch.block ctx raw.state out.state v ret call).1
    exact ⟨step.1,⟨KeygenMakeCertChronology.count_cells cells step.2.1.1,
      KeygenMakeCertChronology.dimensions_cells cells step.2.1.2.1,step.2.1.2.2⟩,
      KeygenMakeCertRelocation.gateAt_flow ctx.scratch.block ctx raw.state out gate⟩

theorem attempt_entry (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (space : SpaceAt ctx.scratch.block before.heap)
    (source : KeygenAttemptAt134.Exec ctx before out) :
    KeygenCallerEntry.Initial ctx out.state input h primes rev ∧
      KeygenMakeRetryTransport.EntryFrame ctx before.heap out.state.heap primes rev ∧
      out.state.tables=before.tables := by
  cases source with
  | earlyRejected raw sample rejected =>
    have step := KeygenMakeRetryTransport134.sampled_entry ctx before _ i input h primes rev remaining initial sample
    exact ⟨step.1,step.2,KeygenAcceptedLoop134.sampled_tables ctx before _ i remaining sample⟩
  | throughCertificate raw sample atCert out gate =>
    obtain ⟨rawInitial,rawFrame⟩ := KeygenMakeRetryTransport134.sampled_entry ctx before raw i
      input h primes rev remaining initial sample
    have dimensions := (KeygenMakeSearchPrefix134.sampled_remaining ctx before raw i remaining sample).2.1.2.1
    have rawSpace := KeygenCertificateAt080.space_preserved ctx _ _ primes rev rawFrame space
    obtain ⟨outInitial,outFrame⟩ := gate_entry ctx raw.state out input h primes rev rawInitial
      dimensions shape rawSpace gate
    obtain ⟨v,ret,call⟩ := gate_call ctx raw.state out gate dimensions
    have cells := KeygenMakeCertRelocation.callAt_cells ctx.scratch.block ctx raw.state out.state v ret call
    exact ⟨outInitial,KeygenMakeRetryTransport.entry_frame_trans ctx _ _ _ primes rev rawFrame outFrame,
      cells.2.2.trans (KeygenAcceptedLoop134.sampled_tables ctx before raw i remaining sample)⟩

theorem facts_after (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (facts : Entry ctx before input h primes rev)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (space : SpaceAt ctx.scratch.block before.heap)
    (source : KeygenAttemptAt134.Exec ctx before out) :
    Entry ctx out.state input h primes rev ∧
      KeygenMakeRetryTransport.EntryFrame ctx before.heap out.state.heap primes rev := by
  obtain ⟨initial,frame,tables⟩ := attempt_entry ctx before out i input h primes rev remaining
    facts.initial shape space source
  exact ⟨⟨initial,
    KeygenMakeAttemptSpine.legal_same_size _ _ _ frame.sizes.symm facts.legalF,
    KeygenMakeAttemptSpine.legal_same_size _ _ _ frame.sizes.symm facts.legalG,
    KeygenMakeAttemptSpine.legal_same_size _ _ _ frame.sizes.symm facts.legalH,
    KeygenMakeAttemptSpine.tables_same before out.state _ tables.symm facts.hTables,
    KeygenMakeAttemptSpine.protected_same ctx before out.state _ tables.symm facts.hProtected⟩,frame⟩

end FT1536.Source3.KeygenRetryAt134
