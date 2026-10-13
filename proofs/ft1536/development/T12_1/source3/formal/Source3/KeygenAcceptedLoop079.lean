import Source3.KeygenAcceptedMaterial079

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Fold the material witness through actual rejected attempts. The named
   certificate entry frame is still a residual of this intermediate export. -/
namespace FT1536.Source3.KeygenAcceptedLoop079
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenMakeCertChronology

theorem sampled_tables (ctx : Context) (before : State) (out : Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (source : KeygenMakeSearchPrefix.Sampled ctx before out) :
    out.state.tables=before.tables := by
  cases source with
  | run entry out cap gates =>
    rcases KeygenMakeSampling.cap_before_setup ctx before i ⟨entry,.normal⟩
      remaining.2.2 remaining.1 remaining.2.1.1 cap with aborted | running
    · have impossible := congrArg Result.flow aborted.2
      cases impossible
    · have entryEq : entry=KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced before i) :=
        congrArg Result.state running.2.1
      have entryTables : entry.tables=before.tables := by rw [entryEq]; rfl
      cases gates with
      | ternaryRejected raw source rejected =>
        exact (KeygenCallerPrefix.ternary_slots ctx entry raw source).2.trans
          entryTables
      | publicRejected normed raw source gate rejected =>
        cases gate with
        | reject after v call zero | accept after v call nonzero =>
          exact (KeygenMakeAttemptSpine.public_slots_state _ _ _ call).2.2.trans
            ((KeygenCallerPrefix.ternary_slots ctx entry _ source).2.trans
              entryTables)
      | solver normed publicState raw source publicGate gate =>
        have publicTables : publicState.tables=entry.tables := by
          cases publicGate with
          | accept after v call nonzero =>
            exact (KeygenMakeAttemptSpine.public_slots_state _ _ _ call).2.2.trans
              (KeygenCallerPrefix.ternary_slots ctx entry _ source).2
        cases gate with
        | reject after v call zero | accept after v call nonzero =>
          exact (KeygenRootSource.slots _ _ _ _ call).2.2.trans
            (publicTables.trans entryTables)

theorem attempt_tables (ctx : Context) (before : State) (out : Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (source : AttemptExec ctx before out) : out.state.tables=before.tables := by
  cases source with
  | earlyRejected raw sample rejected => exact sampled_tables ctx before _ i remaining sample
  | throughCertificate raw sample atCert out gate =>
    exact (KeygenMakeCertCall.gate_cells ctx raw.state out gate).2.2.trans
      (sampled_tables ctx before raw i remaining sample)

theorem facts_after (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (facts : KeygenMakeAttemptSpine.EntryFacts ctx before input h primes rev)
    (source : AttemptExec ctx before out)
    (certFrame : ∀ (s t : State) (w : Value) (ret : Bool),
      KeygenMakeCertCall.Call ctx s t w ret →
        KeygenMakeRetryTransport.CertEntryFrame ctx s.heap t.heap primes rev) :
    KeygenMakeAttemptSpine.EntryFacts ctx out.state input h primes rev := by
  obtain ⟨initial,frame⟩ := KeygenMakeRetryTransport.attempt_entry ctx before out i
    input h primes rev remaining facts.initial source certFrame
  have tables := attempt_tables ctx before out i remaining source
  exact ⟨initial,
    KeygenMakeAttemptSpine.legal_same_size _ _ _ frame.sizes.symm facts.legalF,
    KeygenMakeAttemptSpine.legal_same_size _ _ _ frame.sizes.symm facts.legalG,
    KeygenMakeAttemptSpine.legal_same_size _ _ _ frame.sizes.symm facts.legalH,
    KeygenMakeAttemptSpine.tables_same before out.state _ tables.symm facts.hTables,
    KeygenMakeAttemptSpine.protected_same ctx before out.state _ tables.symm facts.hProtected,
    facts.blocks,facts.pubBlocks⟩

theorem loop_material (ctx : Context) (before : State) (out : Result)
    (attempts : List (AttemptExecution ctx)) (source : LoopTrace ctx before out attempts)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (certFrame : ∀ (s t : State) (w : Value) (ret : Bool),
      KeygenMakeCertCall.Call ctx s t w ret →
        KeygenMakeRetryTransport.CertEntryFrame ctx s.heap t.heap primes rev) :
    ∀ (i : Nat), KeygenMakeSearchPrefix.Remaining before i →
      KeygenMakeAttemptSpine.EntryFacts ctx before input h primes rev →
      C99Automatic32.Space before.heap → out.flow=.normal →
      KeygenMakeMaterialWitness.EncodingInputs out.state.heap input h := by
  induction source with
  | exhausted before out cap exit =>
    intro i remaining facts space normal
    exact (exit normal).elim
  | accepted a last =>
    intro i remaining facts space normal
    exact KeygenAcceptedMaterial079.attempt_material ctx a.before a.out i input h primes rev
      remaining facts shape space a.source last
  | retry a out rest rejected tail ih =>
    intro i remaining facts space normal
    have frame := KeygenMakeRetryTransport.frame_of_attempt ctx a.before a.out i input h
      primes rev remaining facts.initial a.source certFrame
    exact ih (i+1) (attempt_remaining ctx a.before a.out i remaining a.source).2.1
      (facts_after ctx a.before a.out i input h primes rev remaining facts a.source certFrame)
      (KeygenMakeCertificatePremises.space_of_frame ctx _ _ primes rev frame space) normal

/-- The final accepted attempt's actual output state is the serialization
    entry state. Equal abstract material names are insufficient for this fact. -/
theorem final_state (ctx : Context) (before : State) (out : Result)
    (attempts : List (AttemptExecution ctx)) (source : LoopTrace ctx before out attempts)
    (normal : out.flow=.normal) :
    ∃ rejected final, attempts=rejected++[final] ∧
      (∀ a∈rejected, AttemptRejected a) ∧ AttemptAccepted final ∧ final.out.state=out.state := by
  induction source with
  | exhausted before out cap exit => exact (exit normal).elim
  | accepted a last => exact ⟨[],a,rfl,by simp,last,rfl⟩
  | retry a out rest rejected tail ih =>
    obtain ⟨earlier,final,shape,rejects,last,same⟩ := ih normal
    refine ⟨a::earlier,final,by simp only [shape,List.cons_append],?_,last,same⟩
    intro b member
    rcases List.mem_cons.mp member with equal | member
    · subst b; exact rejected
    · exact rejects b member

end FT1536.Source3.KeygenAcceptedLoop079
