import Source3.KeygenMakeAttemptSpine

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source material before the certificate, independent of block numbering.
   Extracted from the pinned spine argument; certificate framing is separate. -/
namespace FT1536.Source3.KeygenPrecertificate080
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenMakeAttemptSpine

structure Entry (ctx : Context) (s : State) (input : Fin 4 → ArrayPointer)
    (h primes rev : ArrayPointer) : Prop where
  initial : KeygenCallerEntry.Initial ctx s input h primes rev
  legalF : KeygenPublicInputMaterial.Legal s.heap (input 0)
  legalG : KeygenPublicInputMaterial.Legal s.heap (input 1)
  legalH : KeygenPublicInputMaterial.Legal s.heap h
  hTables : KeygenPublicFrame.Tables s h.block
  hProtected : KeygenRootSearch.Protected ctx s h.block

theorem source_material (ctx : Context) (before entry middle sampled res normed publicState
    rawState : State) (pv sv : Value) (i : Nat) (input : Fin 4 → ArrayPointer)
    (h primes rev : ArrayPointer) (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (facts : Entry ctx before input h primes rev)
    (cap : KeygenMakeSampling.CappedSetup ctx before ⟨entry,.normal⟩)
    (sampleF : KeygenSamplerContext.Call ctx entry "f" middle)
    (sampleG : KeygenSamplerContext.Call ctx middle "g" sampled)
    (resultants : KeygenResultantGate.Exec sampled ⟨res,.normal⟩)
    (norms : KeygenAttemptNorm.Exec ctx res ⟨normed,.normal⟩)
    (publicCall : KeygenPublicSource.Call (KeygenCallerPrefix.close before normed) publicState pv)
    (publicNonzero : pv.integer≠0)
    (solverCall : KeygenRootSource.Call ctx publicState rawState sv)
    (solverReturned : sv=.int32 1)
    : KeygenMakeMaterialWitness.Witness rawState.heap input h := by
  -- the gate state is the prepared state of this counter value
  rcases KeygenMakeSampling.cap_before_setup ctx before i ⟨entry,.normal⟩
    remaining.2.2 remaining.1 remaining.2.1.1 cap with aborted | running
  · have impossible := congrArg Result.flow aborted.2
    cases impossible
  · have entryEq : entry=KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced before i) :=
      congrArg Result.state running.2.1
    subst entry
    -- entry facts derived from the allocation-derived Initial
    have entryF : KeygenAttemptMaterial.Entry ctx (KeygenMakeSampling.prepared ctx
        (KeygenCapWords.advanced before i)) (input 0) (input 1) :=
      KeygenMakeSampling.entry_from_prepared ctx before i input h primes rev facts.initial remaining.2.1.1
    have legalE : KeygenRootCaller.Legal ctx (KeygenMakeSampling.prepared ctx
        (KeygenCapWords.advanced before i)) input primes rev :=
      root_legal_prepared ctx before i input h primes rev facts.initial
    have ctxNormE : KeygenAttemptNorm.Protected ctx (KeygenMakeSampling.prepared ctx
        (KeygenCapWords.advanced before i)) ctx.object.block :=
      context_norm_prepared ctx before i input h primes rev facts.initial
    have dimsE : KeygenMakeSearchPrefix.Dimensions
        (KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced before i)) :=
      KeygenMakeSearchPrefix.dimensions_advanced ctx before i remaining.2.1
    have entryTables : (KeygenMakeSampling.prepared ctx
        (KeygenCapWords.advanced before i)).tables=before.tables := rfl
    have entrySize : (KeygenMakeSampling.prepared ctx
        (KeygenCapWords.advanced before i)).heap.size=before.heap.size := rfl
    have primesLive : 0<(KeygenMakeSampling.prepared ctx
        (KeygenCapWords.advanced before i)).heap.size primes.block := by
      rw [entrySize]
      exact facts.initial.staticLive _ _ facts.initial.table
    have revLive : 0<(KeygenMakeSampling.prepared ctx
        (KeygenCapWords.advanced before i)).heap.size rev.block := by
      rw [entrySize]
      exact facts.initial.staticLive _ _ facts.initial.revBinding
    -- gates 1-3: one ternary body on the same sampled material
    have ternary : KeygenCallerPrefix.Ternary ctx
        (KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced before i)) ⟨normed,.normal⟩ :=
      .norm middle sampled res ⟨normed,.normal⟩ sampleF sampleG resultants norms
    have materialN : KeygenAttemptMaterial.Material normed.heap (input 0) (input 1) :=
      KeygenCallerPrefix.ternary_material ctx (KeygenMakeSampling.prepared ctx
        (KeygenCapWords.advanced before i)) ⟨normed,.normal⟩ (input 0) (input 1) entryF ternary
    have slotsN : KeygenAttemptSlots.Slots
        (KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced before i)) normed :=
      KeygenCallerPrefix.ternary_slots ctx (KeygenMakeSampling.prepared ctx
        (KeygenCapWords.advanced before i)) ⟨normed,.normal⟩ ternary
    have sizeN : normed.heap.size=(KeygenMakeSampling.prepared ctx
        (KeygenCapWords.advanced before i)).heap.size :=
      KeygenCallerPrefix.ternary_size ctx (KeygenMakeSampling.prepared ctx
        (KeygenCapWords.advanced before i)) ⟨normed,.normal⟩ (input 0) (input 1) entryF ternary
    have localsN : ∀ n∈KeygenMakeLocalFrame.fixed,
        normed.locals n=(KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced before i)).locals n :=
      KeygenMakeLocalFrame.ternary ctx (KeygenMakeSampling.prepared ctx
        (KeygenCapWords.advanced before i)) ⟨normed,.normal⟩ ternary
    have legalN : KeygenRootCaller.Legal ctx normed input primes rev :=
      KeygenCallerPrefix.ternary_root ctx (KeygenMakeSampling.prepared ctx
        (KeygenCapWords.advanced before i)) ⟨normed,.normal⟩ input primes rev entryF legalE
        primesLive revLive ctxNormE ternary
    -- the closed ternary scope of gate 4
    have legalP : KeygenRootCaller.Legal ctx
        (KeygenCallerPrefix.close before normed) input primes rev :=
      KeygenCallerPrefix.close_root ctx before normed input primes rev legalN
    have materialP : KeygenAttemptMaterial.Material
        (KeygenCallerPrefix.close before normed).heap (input 0) (input 1) := materialN
    have dimsP : KeygenMakeSearchPrefix.Dimensions (KeygenCallerPrefix.close before normed) := by
      refine dimensions_locals (KeygenCallerPrefix.close before normed)
        (KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced before i)) ?_ ?_ ?_ dimsE
      · exact (close_locals before normed "logn".toList (by decide)).trans
          (localsN "logn".toList (by decide))
      · exact (close_locals before normed "ter".toList (by decide)).trans
          (localsN "ter".toList (by decide))
      · exact (close_locals before normed "n".toList (by decide)).trans
          (localsN "n".toList (by decide))
    have fEntry : (KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced before i)).arrays
        "f".toList=some (input 0) :=
      prepared_array ctx before i "f".toList (by decide) (input 0)
        (by show before.arrays "f".toList=some (input 0)
            rw [← names_zero]
            exact facts.initial.inputs 0)
    have gEntry : (KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced before i)).arrays
        "g".toList=some (input 1) :=
      prepared_array ctx before i "g".toList (by decide) (input 1)
        (by show before.arrays "g".toList=some (input 1)
            rw [← names_one]
            exact facts.initial.inputs 1)
    have hEntry : (KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced before i)).arrays
        "h".toList=some h :=
      prepared_array ctx before i "h".toList (by decide) h facts.initial.publicPointer
    have arraysP : (KeygenCallerPrefix.close before normed).arrays "f".toList=some (input 0) ∧
        (KeygenCallerPrefix.close before normed).arrays "g".toList=some (input 1) ∧
        (KeygenCallerPrefix.close before normed).arrays "h".toList=some h := by
      refine ⟨?_,?_,?_⟩
      · exact (KeygenCallerPrefix.close_array before normed "f".toList (by decide)).trans
          ((congrFun slotsN.1 "f".toList).trans fEntry)
      · exact (KeygenCallerPrefix.close_array before normed "g".toList (by decide)).trans
          ((congrFun slotsN.1 "g".toList).trans gEntry)
      · exact (KeygenCallerPrefix.close_array before normed "h".toList (by decide)).trans
          ((congrFun slotsN.1 "h".toList).trans hEntry)
    have tablesP : (KeygenCallerPrefix.close before normed).tables=before.tables :=
      (close_tables before normed).trans (slotsN.2.trans entryTables)
    have sizeP : (KeygenCallerPrefix.close before normed).heap.size=before.heap.size :=
      (congrArg Memory.size (close_heap before normed)).trans (sizeN.trans entrySize)
    have separateP : h.block≠(input 0).block ∧ h.block≠(input 1).block :=
      ⟨facts.initial.publicSeparate 0,facts.initial.publicSeparate 1⟩
    have liveP : KeygenPublicInputLifetime.LiveTables (KeygenCallerPrefix.close before normed) :=
      live_tables_same before (KeygenCallerPrefix.close before normed) tablesP.symm sizeP.symm
        facts.initial.staticLive
    have hTablesP : KeygenPublicFrame.Tables (KeygenCallerPrefix.close before normed) h.block :=
      tables_same before (KeygenCallerPrefix.close before normed) h.block tablesP.symm facts.hTables
    have legalFP : KeygenPublicInputMaterial.Legal
        (KeygenCallerPrefix.close before normed).heap (input 0) :=
      legal_same_size before.heap (KeygenCallerPrefix.close before normed).heap (input 0)
        sizeP.symm facts.legalF
    have legalGP : KeygenPublicInputMaterial.Legal
        (KeygenCallerPrefix.close before normed).heap (input 1) :=
      legal_same_size before.heap (KeygenCallerPrefix.close before normed).heap (input 1)
        sizeP.symm facts.legalG
    have legalHP : KeygenPublicInputMaterial.Legal
        (KeygenCallerPrefix.close before normed).heap h :=
      legal_same_size before.heap (KeygenCallerPrefix.close before normed).heap h
        sizeP.symm facts.legalH
    -- gate 4: the public equations on the actual caller arrays
    obtain ⟨fv,gv,fvBound,gvBound,materialQ⟩ := KeygenMakeMaterialWitness.public_material_equations
      (KeygenCallerPrefix.close before normed) publicState pv input h dimsP arraysP materialP
      legalFP legalGP legalHP separateP liveP hTablesP publicCall publicNonzero
    -- gate 5: the solver call on the same arrays, with the h frame
    have objectOutsideP : KeygenPublicFrame.Outside
        (KeygenCallerPrefix.close before normed) ["h".toList] ctx.object.block := by
      intro n member p binding
      have equal := List.mem_singleton.mp member
      subst n
      have pointer := Option.some.inj (arraysP.2.2.symm.trans binding)
      subst p
      exact facts.initial.publicContext
    have legalQ : KeygenRootCaller.Legal ctx publicState input primes rev :=
      KeygenCallerTransport.public_root ctx (KeygenCallerPrefix.close before normed) publicState
        pv input primes rev legalP objectOutsideP publicCall
    have publicSlots := public_slots_state (KeygenCallerPrefix.close before normed) publicState pv
      publicCall
    have solverSlots := KeygenRootSource.slots ctx publicState rawState sv solverCall
    have hTablesQ : KeygenPublicFrame.Tables publicState h.block :=
      tables_same before publicState h.block (publicSlots.2.2.trans tablesP).symm facts.hTables
    have hProtectedQ : KeygenRootSearch.Protected ctx publicState h.block :=
      protected_same ctx before publicState h.block (publicSlots.2.2.trans tablesP).symm facts.hProtected
    have witnessR : KeygenMakeMaterialWitness.Witness rawState.heap input h :=
      KeygenMakeMaterialWitness.witness_at_solver ctx publicState rawState sv input h primes rev
        legalQ solverCall solverReturned hProtectedQ (facts.initial.publicSeparate 2)
        (facts.initial.publicSeparate 3) fv gv fvBound gvBound materialQ
    exact witnessR

end FT1536.Source3.KeygenPrecertificate080
