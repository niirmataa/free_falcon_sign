import Source3.KeygenMakeMaterialWitness
import Source3.KeygenMakeCertChronology
import Source3.KeygenMakeSearchTrace

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- THE attempt-level spine: all six gates bound on ONE `AttemptExec`
    derivation of a single accepted attempt, with the entry facts derived
    from the allocation freshness. The gate order is the source order: the
    f/g sampler calls and the resultant gate (gate 1), the raw FPEMU norm
    and the orthogonal FPEMU norm (gates 2/3 inside one `KeygenAttemptNorm`
    body), the public computation (gate 4), the NTRU solver (gate 5) and the
    mandatory leaf certificate at the accepted break (gate 6). The spine
    composes the pinned witness exports (public material, solver-call h
    frame, ONE material with both equations, certificate frame) on the same
    physical f/g/F/G/h arrays of that single derivation and lands the
    witness at `EncodingInputs`, the input boundary of the encoding tail.
    The entry facts consumed here are the `Initial` allocation-derived facts
    plus the SAME class of explicit local inputs the witness module names
    (`LegalWorkspace` class): the h-side separations (legalH/hTables, solver
    hProtected), the material-legality cells and the material-block
    separation from the workspace/table blocks. Those are discharged from
    allocation freshness at the statement-machine step (35.1); they are not
    certificate outcomes, equations or codec facts. The retry frames on the
    rejected edges and the statement-machine extraction stay open. Not a
    review, not a codec or law claim. -/
namespace FT1536.Source3.KeygenMakeAttemptSpine
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)

/-! ## 1. State transports used by the spine (definitions first) -/

/-- The scope close restores only locals/arrays, so its heap is unchanged. -/
theorem close_heap (saved after : State) :
    (KeygenCallerPrefix.close saved after).heap=after.heap := rfl

/-- The scope close restores only locals/arrays, so its table map is
    unchanged. -/
theorem close_tables (saved after : State) :
    (KeygenCallerPrefix.close saved after).tables=after.tables := rfl

/-- The scope close keeps every local of the fixed caller frame. -/
theorem close_locals (saved after : State) (n : Name)
    (member : n∈KeygenMakeLocalFrame.fixed) :
    (KeygenCallerPrefix.close saved after).locals n=after.locals n :=
  KeygenMakeSearchPrefix.close_local saved ⟨after,.normal⟩ n member

/-- `Dimensions` is a statement about the fixed caller locals only. -/
theorem dimensions_locals (s t : State)
    (logn : s.locals "logn".toList=t.locals "logn".toList)
    (ter : s.locals "ter".toList=t.locals "ter".toList)
    (size : s.locals "n".toList=t.locals "n".toList)
    (dimensions : KeygenMakeSearchPrefix.Dimensions t) :
    KeygenMakeSearchPrefix.Dimensions s := by
  refine ⟨?_,?_,?_⟩
  · show C99CountedWords.Limit s
    show s.locals "n".toList=some (.uint64,some (.uint64 1536))
    rw [size]
    exact dimensions.1
  · rw [logn]
    exact dimensions.2.1
  · rw [ter]
    exact dimensions.2.2

/-- The material legality is a shape predicate of the block sizes, so it
    transports along heap-size equality. -/
theorem legal_same_size (a b : Memory) (p : ArrayPointer) (same : a.size=b.size)
    (legal : KeygenPublicInputMaterial.Legal a p) :
    KeygenPublicInputMaterial.Legal b p := by
  obtain ⟨width,elements⟩ := legal
  refine ⟨width,?_⟩
  intro i bound
  have allocated := elements i bound
  simpa only [C99MemoryReference.Allocated,same] using allocated

/-- The table liveness is a statement about the table map and block sizes. -/
theorem live_tables_same (a b : State) (tables : a.tables=b.tables)
    (size : a.heap.size=b.heap.size) (live : KeygenPublicInputLifetime.LiveTables a) :
    KeygenPublicInputLifetime.LiveTables b := by
  intro n p binding
  have old : a.tables n=some p := by rw [tables]; exact binding
  rw [← size]
  exact live n p old

/-- The protected-block separation reads only the scratch block and the
    table map. -/
theorem protected_same (ctx : Context) (a b : State) (block : Nat)
    (tables : a.tables=b.tables)
    (shield : KeygenRootSearch.Protected ctx a block) :
    KeygenRootSearch.Protected ctx b block := by
  refine ⟨shield.1,?_⟩
  intro n p binding
  have old : a.tables n=some p := by rw [tables]; exact binding
  exact shield.2 n p old

/-- The table-block separation reads only the table map. -/
theorem tables_same (a b : State) (block : Nat) (tables : a.tables=b.tables)
    (outside : KeygenPublicFrame.Tables a block) : KeygenPublicFrame.Tables b block := by
  intro n p binding
  have old : a.tables n=some p := by rw [tables]; exact binding
  exact outside n p old

/-- A public call keeps the caller locals, arrays and table map; only the
    heap is replaced by the callee result. -/
theorem public_slots_state (before after : State) (v : Value)
    (source : KeygenPublicSource.Call before after v) :
    after.locals=before.locals ∧ after.arrays=before.arrays ∧ after.tables=before.tables := by
  cases source
  exact ⟨rfl,rfl,rfl⟩

/-- A public gate stopped at a normal state is its accepting call. -/
theorem public_gate_call (P : State) (out : Result)
    (gate : KeygenAttemptMaterial.PublicGate P out) (normal : out.flow=.normal) :
    ∃ v : Value, KeygenPublicSource.Call P out.state v ∧ v.integer≠0 := by
  cases gate with
  | reject after v call zero =>
    cases normal
  | accept after v call nonzero =>
    exact ⟨v,call,nonzero⟩

theorem names_zero : (KeygenResidueTrace.names (0 : Fin 4)).2.toList="f".toList := by decide
theorem names_one : (KeygenResidueTrace.names (1 : Fin 4)).2.toList="g".toList := by decide

/-- The fixed-name array binding of the prepared gate state, from the
    allocation-derived `Initial` entry facts. -/
theorem prepared_array (ctx : Context) (s : State) (i : Nat) (n : Name)
    (outside : n∉KeygenCallerInit.rtNames) (p : ArrayPointer)
    (binding : s.arrays n=some p) :
    (KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced s i)).arrays n=some p :=
  (KeygenMakeSampling.prepared_slot ctx (KeygenCapWords.advanced s i) n outside).trans
    (by show (KeygenCapWords.advanced s i).arrays n=some p; exact binding)

/-! ## 2. Entry facts at the actual gate state -/

/-- The root-call legality at the prepared gate state, derived from the
    allocation-derived `Initial` entry facts (the fixed-name arrays survive
    the counter advance and the rt-scope preparation). -/
theorem root_legal_prepared (ctx : Context) (s : State) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx s input h primes rev) :
    KeygenRootCaller.Legal ctx (KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced s i))
      input primes rev := by
  refine ⟨?_,?_,initial.profile,initial.table,initial.primeObject,initial.revBinding,initial.revSource,
    initial.scratch,initial.width,?_,?_,?_,?_,?_⟩
  · exact prepared_array ctx s i "fk".toList (by decide) ctx.object initial.context
  · intro slot
    exact prepared_array ctx s i _ (KeygenCallerEntry.input_not_rt slot) (input slot)
      (initial.inputs slot)
  · intro slot; exact Or.inl (Ne.symm (initial.scratchSeparate slot))
  · intro a b different; exact Or.inl (initial.distinct a b different)
  · exact ⟨initial.contextScratch,initial.contextTables⟩
  · exact ⟨initial.scratchSeparate 0,initial.inputTables 0⟩
  · exact ⟨initial.scratchSeparate 1,initial.inputTables 1⟩

/-- The norm-frame protection of the context block at the prepared gate
    state, from the same allocation-derived entry facts. -/
theorem context_norm_prepared (ctx : Context) (s : State) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx s input h primes rev) :
    KeygenAttemptNorm.Protected ctx (KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced s i))
      ctx.object.block := by
  refine ⟨initial.contextScratch,?_,initial.contextTables⟩
  intro n member p binding
  rw [KeygenMakeSampling.prepared_rt ctx (KeygenCapWords.advanced s i) n member p binding]
  exact initial.contextScratch

/-- The h-side separation of the context block at the prepared gate state. -/
theorem context_public_prepared (ctx : Context) (s : State) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx s input h primes rev) :
    KeygenPublicFrame.Outside (KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced s i))
      ["h".toList] ctx.object.block := by
  intro n member p binding
  have equal := List.mem_singleton.mp member
  subst n
  have pointer := prepared_array ctx s i "h".toList (by decide) h initial.publicPointer
  have same := Option.some.inj (pointer.symm.trans binding)
  subst p
  exact initial.publicContext

/-! ## 3. The entry-facts class of the spine -/

/-- The entry facts of one attempt at its loop state. The `initial` field is
    DERIVED from the allocation freshness (the six automatic arrays of the
    `Declarations` allocation, through the prologue chain); the other fields
    are the named explicit local inputs of the witness module's class: the
    h-side separations and the material-legality cells, plus the material
    block separation from the workspace block0 and the static table blocks
    1/2. They are discharged from allocation freshness at the
    statement-machine step (35.1); none of them is a certificate outcome, an
    equation or a codec fact. -/
structure EntryFacts (ctx : Context) (s : State) (input : Fin 4 → ArrayPointer)
    (h primes rev : ArrayPointer) : Prop where
  initial : KeygenCallerEntry.Initial ctx s input h primes rev
  legalF : KeygenPublicInputMaterial.Legal s.heap (input 0)
  legalG : KeygenPublicInputMaterial.Legal s.heap (input 1)
  legalH : KeygenPublicInputMaterial.Legal s.heap h
  hTables : KeygenPublicFrame.Tables s h.block
  hProtected : KeygenRootSearch.Protected ctx s h.block
  blocks : ∀ slot : Fin 4, (input slot).block≠0 ∧ (input slot).block≠1 ∧ (input slot).block≠2
  pubBlocks : h.block≠0 ∧ h.block≠1 ∧ h.block≠2

/-! ## 4. The six-gate spine record -/

/-- THE six-gate spine of ONE attempt on ONE execution: the two sampler
    calls and the resultant gate (gate 1), the raw and orthogonal FPEMU norm
    bodies (gates 2/3), the public computation (gate 4), the NTRU solver
    (gate 5) and the mandatory leaf certificate call at the accepted break
    (gate 6), all extracted from a single `AttemptExec` derivation. -/
inductive Spine (ctx : Context) (before out : State) : Prop where
  | run (entry middle sampled res normed publicState rawState : State)
      (publicValue solverValue certValue : Value)
      (cap : KeygenMakeSampling.CappedSetup ctx before ⟨entry,.normal⟩)
      (sampleF : KeygenSamplerContext.Call ctx entry "f" middle)
      (sampleG : KeygenSamplerContext.Call ctx middle "g" sampled)
      (resultants : KeygenResultantGate.Exec sampled ⟨res,.normal⟩)
      (norms : KeygenAttemptNorm.Exec ctx res ⟨normed,.normal⟩)
      (publicCall : KeygenPublicSource.Call (KeygenCallerPrefix.close before normed)
        publicState publicValue)
      (publicNonzero : publicValue.integer≠0)
      (solverCall : KeygenRootSource.Call ctx publicState rawState solverValue)
      (solverReturned : solverValue=.int32 1)
      (certificate : KeygenMakeCertCall.Call ctx rawState out certValue true) :
      Spine ctx before out

/-- An accepted attempt (final break) on ONE `AttemptExec` derivation carries
    the whole six-gate spine; every other edge is impossible on the accepted
    break. -/
theorem accepted_spine (ctx : Context) (before : State) (out : Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (source : KeygenMakeCertChronology.AttemptExec ctx before out)
    (accepted : out.flow=.breakLoop) : Spine ctx before out.state := by
  cases source with
  | earlyRejected raw sample rejected =>
    rw [rejected] at accepted
    cases accepted
  | throughCertificate raw sample atCert out gate =>
    have dims : KeygenMakeSearchPrefix.Dimensions raw.state :=
      (KeygenMakeSearchPrefix.sampled_remaining ctx before raw i remaining sample).2.1.2.1
    have profile := KeygenMakeCertCall.profile_of_dimensions raw.state dims
    obtain ⟨after,cv,certCall,outEq⟩ := KeygenMakeCertCall.accepted_break_requires_call
      ctx raw.state out gate profile accepted
    subst out
    show Spine ctx before after
    cases sample with
    | run entry raw cap gates =>
      cases gates with
      | ternaryRejected raw' ternary rejected =>
        have bad : raw'.flow=.normal := atCert
        rw [rejected] at bad
        cases bad
      | publicRejected normed raw' ternary publicGate rejected =>
        rw [rejected] at atCert
        cases atCert
      | solver normed publicState raw' ternary publicGate rootGate =>
        obtain ⟨pv,publicCall,publicNonzero⟩ := public_gate_call
          (KeygenCallerPrefix.close before normed) ⟨publicState,.normal⟩ publicGate rfl
        cases ternary with
        | resultantRejected middle sampled res first second resultants rejected =>
          cases rejected
        | norm middle sampled res normOut first second resultants norms =>
          cases rootGate with
          | reject after v call zero =>
            cases atCert
          | accept after v call nonzero =>
            refine ⟨entry,middle,sampled,res,normed,publicState,after,pv,v,cv,
              cap,first,second,resultants,norms,publicCall,publicNonzero,call,?_,certCall⟩
            exact KeygenCallerSuccess.nonzero_one ctx publicState after v call nonzero

/-! ## 5. The spine composition on one derivation -/

/-- The spine of ONE accepted attempt lands the ONE material with both
    equations at the certificate-entry state and at `EncodingInputs`, the
    input boundary of the encoding tail. Gates 1-3 supply the sampled f/g
    material, gate 4 the public equations on the caller arrays, gate 5 the
    exact integer NTRU equation on the same physical arrays (through the
    solver-call h frame), gate 6 the certificate frame. The workspace
    legality and the h-side/material-block separations stay the explicit
    local inputs of the witness class. -/
theorem spine_witness (ctx : Context) (before entry middle sampled res normed publicState
    rawState out : State) (pv sv cv : Value) (i : Nat) (input : Fin 4 → ArrayPointer)
    (h primes rev : ArrayPointer) (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (facts : EntryFacts ctx before input h primes rev)
    (cap : KeygenMakeSampling.CappedSetup ctx before ⟨entry,.normal⟩)
    (sampleF : KeygenSamplerContext.Call ctx entry "f" middle)
    (sampleG : KeygenSamplerContext.Call ctx middle "g" sampled)
    (resultants : KeygenResultantGate.Exec sampled ⟨res,.normal⟩)
    (norms : KeygenAttemptNorm.Exec ctx res ⟨normed,.normal⟩)
    (publicCall : KeygenPublicSource.Call (KeygenCallerPrefix.close before normed) publicState pv)
    (publicNonzero : pv.integer≠0)
    (solverCall : KeygenRootSource.Call ctx publicState rawState sv)
    (solverReturned : sv=.int32 1)
    (certificate : KeygenMakeCertCall.Call ctx rawState out cv true)
    (workspace : KeygenMakeCertMaterial.LegalWorkspace rawState ctx) :
    KeygenMakeMaterialWitness.Witness rawState.heap input h ∧
    KeygenMakeMaterialWitness.EncodingInputs out.heap input h := by
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
    -- gate 6: the certificate frame on the same physical material
    have dimsR : KeygenMakeSearchPrefix.Dimensions rawState := by
      refine dimensions_locals rawState (KeygenCallerPrefix.close before normed) ?_ ?_ ?_ dimsP
      · exact (congrFun solverSlots.1 "logn".toList).trans
          (congrFun publicSlots.1 "logn".toList)
      · exact (congrFun solverSlots.1 "ter".toList).trans
          (congrFun publicSlots.1 "ter".toList)
      · exact (congrFun solverSlots.1 "n".toList).trans
          (congrFun publicSlots.1 "n".toList)
    have encoding : KeygenMakeMaterialWitness.EncodingInputs out.heap input h :=
      KeygenMakeMaterialWitness.attempt_witness ctx rawState out cv input h certificate dimsR
        workspace facts.blocks facts.pubBlocks witnessR
    exact ⟨witnessR,encoding⟩

/-- THE attempt-level spine on ONE `AttemptExec` derivation: an accepted
    attempt (final break) with allocation-derived entry facts carries all six
    gates and lands the ONE material with both equations at the encoding-tail
    input boundary. The workspace legality is the named residual of the
    witness class at the certificate-entry state; its uniform form is used
    here and is discharged from allocation freshness at the statement-machine
    step (35.1). -/
theorem attempt_spine (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (facts : EntryFacts ctx before input h primes rev)
    (source : KeygenMakeCertChronology.AttemptExec ctx before out)
    (accepted : out.flow=.breakLoop)
    (workspace : (rawState : State) → KeygenMakeCertMaterial.LegalWorkspace rawState ctx) :
    KeygenMakeMaterialWitness.EncodingInputs out.state.heap input h := by
  cases accepted_spine ctx before out i remaining source accepted with
  | run entry middle sampled res normed publicState rawState publicValue solverValue certValue
      cap sampleF sampleG resultants norms publicCall publicNonzero solverCall
      solverReturned certificate =>
    exact (spine_witness ctx before entry middle sampled res normed publicState rawState out.state
      publicValue solverValue certValue i input h primes rev remaining facts cap sampleF sampleG
      resultants norms publicCall publicNonzero solverCall solverReturned certificate
      (workspace rawState)).2

/-! ## 6. Entry facts derived from the allocation -/

/-- The entry facts of the FIRST attempt derived FROM THE ALLOCATION: the
    pinned already-ready prologue (which enters the six fresh automatic
    arrays of the `Declarations` allocation) yields the allocation-derived
    `Initial` facts and the loop-entry `Remaining 0` the spine consumes.
    The retry transport of these facts across rejected attempts belongs to
    the retry-frame item. -/
theorem entry_of_allocation (ctx : Context) (before after : State) (blocks : Fin 6 → Nat)
    (primes rev : ArrayPointer) (events : List KeygenEntropySource.Event)
    (original : KeygenMakeEntry.Original ctx before primes rev)
    (head : KeygenMakeReady.Prefix ctx before blocks events ⟨after,.normal⟩) :
    KeygenCallerEntry.Initial ctx after (KeygenMakeEntry.input blocks)
      (KeygenMakeEntry.publicPointer blocks) primes rev ∧
    KeygenMakeSearchPrefix.Remaining after 0 := by
  have facts := KeygenMakeReady.normal_prefix ctx before after blocks primes rev original events head
  have remaining := KeygenMakeSearchTrace.prefix_remaining ctx before after blocks primes rev
    original events head
  exact ⟨facts.2.1,remaining⟩

end FT1536.Source3.KeygenMakeAttemptSpine
