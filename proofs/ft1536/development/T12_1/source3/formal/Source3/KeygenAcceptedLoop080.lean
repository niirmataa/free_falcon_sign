import Source3.KeygenCertificateReachable080

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenAcceptedLoop080
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenMakeCertChronology

theorem facts_after (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (facts : KeygenMakeAttemptSpine.EntryFacts ctx before input h primes rev)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (space : C99Automatic32.Space before.heap)
    (source : AttemptExec ctx before out) :
    KeygenMakeAttemptSpine.EntryFacts ctx out.state input h primes rev ∧
      KeygenMakeRetryTransport.EntryFrame ctx before.heap out.state.heap primes rev := by
  obtain ⟨initial,frame⟩ := KeygenCertificateReachable080.attempt_entry ctx before out i
    input h primes rev remaining facts.initial shape space source
  have tables := KeygenAcceptedLoop079.attempt_tables ctx before out i remaining source
  exact ⟨⟨initial,
    KeygenMakeAttemptSpine.legal_same_size _ _ _ frame.sizes.symm facts.legalF,
    KeygenMakeAttemptSpine.legal_same_size _ _ _ frame.sizes.symm facts.legalG,
    KeygenMakeAttemptSpine.legal_same_size _ _ _ frame.sizes.symm facts.legalH,
    KeygenMakeAttemptSpine.tables_same before out.state _ tables.symm facts.hTables,
    KeygenMakeAttemptSpine.protected_same ctx before out.state _ tables.symm facts.hProtected,
    facts.blocks,facts.pubBlocks⟩,frame⟩

/-- Whole-loop material and entry frame, with both universal certificate
    frame and universal workspace premises removed. -/
theorem loop_material (ctx : Context) (before : State) (out : Result)
    (attempts : List (AttemptExecution ctx)) (source : LoopTrace ctx before out attempts)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx) :
    ∀ (i : Nat), KeygenMakeSearchPrefix.Remaining before i →
      KeygenMakeAttemptSpine.EntryFacts ctx before input h primes rev →
      C99Automatic32.Space before.heap → out.flow=.normal →
      KeygenMakeMaterialWitness.EncodingInputs out.state.heap input h ∧
      KeygenMakeRetryTransport.EntryFrame ctx before.heap out.state.heap primes rev := by
  induction source with
  | exhausted before out cap exit =>
    intro i remaining facts space normal
    exact (exit normal).elim
  | accepted a last =>
    intro i remaining facts space normal
    exact ⟨KeygenAcceptedMaterial079.attempt_material ctx a.before a.out i input h primes rev
      remaining facts shape space a.source last,
      (facts_after ctx a.before a.out i input h primes rev remaining facts shape space a.source).2⟩
  | retry a out rest rejected tail ih =>
    intro i remaining facts space normal
    obtain ⟨nextFacts,frame⟩ := facts_after ctx a.before a.out i input h primes rev remaining
      facts shape space a.source
    obtain ⟨witness,later⟩ := ih (i+1)
      (attempt_remaining ctx a.before a.out i remaining a.source).2.1 nextFacts
      (KeygenMakeCertificatePremises.space_of_frame ctx _ _ primes rev frame space) normal
    exact ⟨witness,KeygenMakeRetryTransport.entry_frame_trans ctx _ _ _ primes rev frame later⟩

end FT1536.Source3.KeygenAcceptedLoop080
