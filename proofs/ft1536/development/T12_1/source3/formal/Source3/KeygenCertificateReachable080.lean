import Source3.KeygenAcceptedLoop079
import Source3.KeygenCertificateReadonly080

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Reachable-state discharge of the certificate frame, including immutable
   table blocks, with no universal frame or static-separation premise. -/
namespace FT1536.Source3.KeygenCertificateReachable080
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

theorem call_frame (ctx : Context) (before after : State) (v : Value) (ret : Bool)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (space : C99Automatic32.Space before.heap)
    (call : KeygenMakeCertCall.Call ctx before after v ret) :
    KeygenMakeRetryTransport.CertEntryFrame ctx before.heap after.heap primes rev := by
  have zero := KeygenMakeStatementMachine.scratch_block_of_call ctx before after v ret call
  have writable : before.heap.writable 0=true := by
    rw [← zero]
    exact initial.scratch.2.2.2.2.2
  have objectZero : ctx.object.block≠0 := by
    rw [← zero]
    exact Ne.symm initial.contextScratch
  have primeZero : primes.block≠0 := by
    intro equal
    have readonly := initial.primeObject.2.2.2.1
    rw [equal,writable] at readonly
    cases readonly
  have revZero : rev.block≠0 := by
    intro equal
    have readonly := initial.revSource.1
    rw [equal,writable] at readonly
    cases readonly
  have workspace := KeygenMakeCertificatePremises.gate_workspace ctx before shape initial.scratch space
  exact ⟨(KeygenCertificateReadonly080.call_same_block ctx before after v ret call dimensions workspace
      ctx.object.block objectZero).2.2,
    (KeygenCertificateReadonly080.call_same_block ctx before after v ret call dimensions workspace
      primes.block primeZero).2.2,
    (KeygenCertificateReadonly080.call_same_block ctx before after v ret call dimensions workspace
      rev.block revZero).2.2⟩

theorem gate_entry (ctx : Context) (before : State) (out : Result)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (space : C99Automatic32.Space before.heap)
    (gate : KeygenMakeCertCall.CertificateGate ctx before out) :
    KeygenCallerEntry.Initial ctx out.state input h primes rev ∧
      KeygenMakeRetryTransport.EntryFrame ctx before.heap out.state.heap primes rev := by
  cases gate with
  | unprofiled noProfile => exact ⟨initial,KeygenMakeRetryTransport.entry_frame_rfl ctx _ primes rev⟩
  | rejected after v call | accepted after v call =>
    have cells := KeygenMakeCertCall.call_cells ctx before after v _ call
    have metadata := KeygenMakeRetryTransport.cert_shape ctx before after v _ call
    have residual := call_frame ctx before after v _ input h primes rev initial dimensions
      shape space call
    have frame : KeygenMakeRetryTransport.EntryFrame ctx before.heap after.heap primes rev :=
      ⟨metadata.1,metadata.2,fun offset _ => residual.1 offset,residual.2.1,residual.2.2⟩
    exact ⟨KeygenMakeRetryTransport.initial_of_frame ctx before after input h primes rev initial
      (congrFun cells.2.1 "fk".toList)
      (fun slot => congrFun cells.2.1 (KeygenResidueTrace.names slot).2.toList)
      (congrFun cells.2.1 "h".toList) cells.2.2 frame,frame⟩

theorem attempt_entry (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (space : C99Automatic32.Space before.heap)
    (source : KeygenMakeCertChronology.AttemptExec ctx before out) :
    KeygenCallerEntry.Initial ctx out.state input h primes rev ∧
      KeygenMakeRetryTransport.EntryFrame ctx before.heap out.state.heap primes rev := by
  cases source with
  | earlyRejected raw sample rejected =>
    exact KeygenMakeRetryTransport.sampled_entry ctx before _ i input h primes rev remaining initial sample
  | throughCertificate raw sample atCert out gate =>
    obtain ⟨rawInitial,rawFrame⟩ := KeygenMakeRetryTransport.sampled_entry ctx before raw i
      input h primes rev remaining initial sample
    have rawDimensions := (KeygenMakeSearchPrefix.sampled_remaining ctx before raw i remaining sample).2.1.2.1
    have rawSpace := KeygenMakeCertificatePremises.space_of_frame ctx _ _ primes rev rawFrame space
    obtain ⟨outInitial,outFrame⟩ := gate_entry ctx raw.state out input h primes rev rawInitial
      rawDimensions shape rawSpace gate
    exact ⟨outInitial,KeygenMakeRetryTransport.entry_frame_trans ctx _ _ _ primes rev rawFrame outFrame⟩

end FT1536.Source3.KeygenCertificateReachable080
