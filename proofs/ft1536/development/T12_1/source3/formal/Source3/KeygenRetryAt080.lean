import Source3.KeygenAttemptAt080
import Source3.KeygenAcceptedLoop079

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenRetryAt080
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenMakeCertRelocation (CallAt SpaceAt CertificateGateAt)
open KeygenPrecertificate080 (Entry)

theorem gate_call (ctx : Context) (before : State) (out : Result)
    (source : CertificateGateAt ctx.scratch.block ctx before out)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before) :
    ∃ v ret, CallAt ctx.scratch.block ctx before out.state v ret := by
  have profile := KeygenMakeCertCall.profile_of_dimensions before dimensions
  rcases KeygenMakeCertRelocation.gateAt_flow ctx.scratch.block ctx before out source with retry | accepted
  · obtain ⟨after,v,call,equal⟩ := KeygenMakeCertRelocation.retry_requires_callAt
      ctx.scratch.block ctx before out source profile retry
    subst out
    exact ⟨v,false,call⟩
  · obtain ⟨after,v,call,equal⟩ := KeygenMakeCertRelocation.accepted_break_requires_callAt
      ctx.scratch.block ctx before out source profile accepted
    subst out
    exact ⟨v,true,call⟩

theorem gate_entry (ctx : Context) (before : State) (out : Result)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (space : SpaceAt ctx.scratch.block before.heap)
    (gate : CertificateGateAt ctx.scratch.block ctx before out) :
    KeygenCallerEntry.Initial ctx out.state input h primes rev ∧
      KeygenMakeRetryTransport.EntryFrame ctx before.heap out.state.heap primes rev := by
  obtain ⟨v,ret,call⟩ := gate_call ctx before out gate dimensions
  have cells := KeygenMakeCertRelocation.callAt_cells ctx.scratch.block ctx before out.state v ret call
  have frame := KeygenCertificateAt080.entry_frame ctx before out.state v ret input h primes rev
    initial dimensions shape space call
  exact ⟨KeygenMakeRetryTransport.initial_of_frame ctx before out.state input h primes rev initial
    (congrFun cells.2.1 "fk".toList)
    (fun slot => congrFun cells.2.1 (KeygenResidueTrace.names slot).2.toList)
    (congrFun cells.2.1 "h".toList) cells.2.2 frame,frame⟩

theorem attempt_remaining (ctx : Context) (before : State) (out : Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (source : KeygenAttemptAt080.Exec ctx before out) :
    i<KeygenAttemptCap.limit ∧ KeygenMakeSearchPrefix.Remaining out.state (i+1) ∧
      (out.flow=.continueLoop ∨ out.flow=.breakLoop) := by
  cases source with
  | earlyRejected raw sample rejected =>
    have step := KeygenMakeSearchPrefix.sampled_remaining ctx before _ i remaining sample
    exact ⟨step.1,step.2.1,Or.inl rejected⟩
  | throughCertificate raw sample atCert out gate =>
    have step := KeygenMakeSearchPrefix.sampled_remaining ctx before raw i remaining sample
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
    (source : KeygenAttemptAt080.Exec ctx before out) :
    KeygenCallerEntry.Initial ctx out.state input h primes rev ∧
      KeygenMakeRetryTransport.EntryFrame ctx before.heap out.state.heap primes rev ∧
      out.state.tables=before.tables := by
  cases source with
  | earlyRejected raw sample rejected =>
    have step := KeygenMakeRetryTransport.sampled_entry ctx before _ i input h primes rev remaining initial sample
    exact ⟨step.1,step.2,KeygenAcceptedLoop079.sampled_tables ctx before _ i remaining sample⟩
  | throughCertificate raw sample atCert out gate =>
    obtain ⟨rawInitial,rawFrame⟩ := KeygenMakeRetryTransport.sampled_entry ctx before raw i
      input h primes rev remaining initial sample
    have dimensions := (KeygenMakeSearchPrefix.sampled_remaining ctx before raw i remaining sample).2.1.2.1
    have rawSpace := KeygenCertificateAt080.space_preserved ctx _ _ primes rev rawFrame space
    obtain ⟨outInitial,outFrame⟩ := gate_entry ctx raw.state out input h primes rev rawInitial
      dimensions shape rawSpace gate
    obtain ⟨v,ret,call⟩ := gate_call ctx raw.state out gate dimensions
    have cells := KeygenMakeCertRelocation.callAt_cells ctx.scratch.block ctx raw.state out.state v ret call
    exact ⟨outInitial,KeygenMakeRetryTransport.entry_frame_trans ctx _ _ _ primes rev rawFrame outFrame,
      cells.2.2.trans (KeygenAcceptedLoop079.sampled_tables ctx before raw i remaining sample)⟩

theorem facts_after (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (facts : Entry ctx before input h primes rev)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (space : SpaceAt ctx.scratch.block before.heap)
    (source : KeygenAttemptAt080.Exec ctx before out) :
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

end FT1536.Source3.KeygenRetryAt080
