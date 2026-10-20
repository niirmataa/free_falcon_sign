import Source3.KeygenMakeRetryFrames
import Source3.KeygenMakeCertMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- THE per-retry entry transport of the B1.07 retry item: the `Initial`/
    legal/static entry facts of `entry_of_allocation` survive EVERY attempt
    instance on EVERY return edge (general typed execution of the capped
    attempt — early rejections, the certificate rejection retry and the
    accepted break), and the gate-time `ReadTmp` tie of the executed `fk->tmp`
    binding is transported through the same attempt frames. The transport is
    stated at the gate level (one whole attempt at a time); the loop-trace
    chronology composition stays at that level. The certificate-call leg
    consumes one named residual, the `CertEntryFrame` byte frame of the entry
    blocks; discharging it needs the open M0 table-block inversion of the
    pinned FFT table environment (blocks 1/2), the `call_same_block` item. No
    certificate outcome, equation, codec fact or scratch-block0 fact is a
    premise. Not a review and not a law claim. -/
namespace FT1536.Source3.KeygenMakeRetryTransport
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)
open ShakeExtractFrame (SameBlock)

/-! ## 1. The entry frame consumed by the entry facts and the member read -/

/-- The heap frame the entry facts and the gate-time member read consume: the
    allocation metadata, the fk-object bytes outside the sampler RNG
    subobject (profile fields and the `tmp` member) and the two static
    source-table blocks. -/
structure EntryFrame (ctx : Context) (before after : Memory) (primes rev : ArrayPointer) : Prop where
  sizes : after.size=before.size
  writable : after.writable=before.writable
  object : ∀ offset, KeygenSamplerContext.OutsideRng ctx offset →
    after.bytes ctx.object.block offset=before.bytes ctx.object.block offset
  prime : ∀ offset, after.bytes primes.block offset=before.bytes primes.block offset
  rev : ∀ offset, after.bytes rev.block offset=before.bytes rev.block offset

theorem entry_frame_trans (ctx : Context) (a b c : Memory) (primes rev : ArrayPointer)
    (first : EntryFrame ctx a b primes rev) (second : EntryFrame ctx b c primes rev) :
    EntryFrame ctx a c primes rev :=
  ⟨second.sizes.trans first.sizes,second.writable.trans first.writable,
    fun offset outside => (second.object offset outside).trans (first.object offset outside),
    fun offset => (second.prime offset).trans (first.prime offset),
    fun offset => (second.rev offset).trans (first.rev offset)⟩

theorem entry_frame_rfl (ctx : Context) (a : Memory) (primes rev : ArrayPointer) :
    EntryFrame ctx a a primes rev :=
  ⟨rfl,rfl,fun _ _ => rfl,fun _ => rfl,fun _ => rfl⟩

/-- The profile fields are the first eight bytes of the fk object, outside the
    sampler RNG subobject. -/
theorem profile_of_frame (ctx : Context) (before after : Memory) (primes rev : ArrayPointer)
    (profile : KeygenSearchContext.M0 before ctx) (frame : EntryFrame ctx before after primes rev) :
    KeygenSearchContext.M0 after ctx := by
  refine ⟨Gate00Memory.load32_transport before after (KeygenSearchContext.field ctx 0 4) 10 profile.1
      frame.sizes ?_,Gate00Memory.load32_transport before after (KeygenSearchContext.field ctx 4 4) 1
      profile.2 frame.sizes ?_⟩
  · intro i
    exact frame.object _ (Or.inl (by
      have := i.isLt
      dsimp [KeygenSearchContext.field,ArrayPointer.offset]
      omega))
  · intro i
    exact frame.object _ (Or.inl (by
      have := i.isLt
      dsimp [KeygenSearchContext.field,ArrayPointer.offset]
      omega))

/-- A 64-bit member read transports along the allocation metadata and its
    byte cells. -/
theorem load64_frame (before after : Memory) (p : ArrayPointer) (w : BitVec 64)
    (read : Load64 before p w) (sizes : after.size=before.size)
    (bytes : ∀ i : Fin 8, after.bytes p.block (p.offset+i.val)=before.bytes p.block (p.offset+i.val)) :
    Load64 after p w := by
  cases read with
  | load data allocated width initialized =>
    apply Load64.load after p data
    · simpa only [Allocated,sizes] using allocated
    · exact width
    · intro i
      exact (bytes i).trans (initialized i)

/-- The object legality is a shape predicate of the block size. -/
theorem object_legal_frame (ctx : Context) (before after : Memory) (primes rev : ArrayPointer)
    (legal : KeygenSearchContext.ObjectLegal before ctx) (frame : EntryFrame ctx before after primes rev) :
    KeygenSearchContext.ObjectLegal after ctx :=
  by simpa only [KeygenSearchContext.ObjectLegal,frame.sizes] using legal

/-- The `tmp` member bytes of an entry frame: outside the RNG subobject, so a
    binding readback survives every frame of this class. -/
theorem tmp_cells (ctx : Context) (before after : Memory) (primes rev : ArrayPointer)
    (frame : EntryFrame ctx before after primes rev) :
    ∀ i : Fin 8,
      after.bytes (KeygenSearchContext.field ctx 432 8).block
          ((KeygenSearchContext.field ctx 432 8).offset+i.val)=
        before.bytes (KeygenSearchContext.field ctx 432 8).block
          ((KeygenSearchContext.field ctx 432 8).offset+i.val) := by
  intro i
  exact frame.object _ (Or.inr (by
    have := i.isLt
    dsimp [KeygenSearchContext.field,ArrayPointer.offset]
    omega))

/-- The gate-time member read transports through an entry frame: the `tmp`
    member bytes live past the RNG subobject, so a binding readback survives
    every frame of this class. -/
theorem readTmp_frame (ctx : Context) (before after : State) (primes rev : ArrayPointer)
    (read : KeygenSearchContext.ReadTmp ctx before ctx.scratch)
    (fk : after.arrays "fk".toList=before.arrays "fk".toList)
    (legal : KeygenSearchContext.ObjectLegal after.heap ctx)
    (frame : EntryFrame ctx before.heap after.heap primes rev) :
    KeygenSearchContext.ReadTmp ctx after ctx.scratch := by
  cases read with
  | read bound oldLegal pointer bytes =>
    exact KeygenSearchContext.ReadTmp.read
      (show after.arrays "fk".toList=some ctx.object by rw [fk]; exact bound) legal pointer
      (load64_frame before.heap after.heap (KeygenSearchContext.field ctx 432 8)
        (KeygenSearchContext.pointerWord ctx) bytes frame.sizes (tmp_cells ctx before.heap after.heap
          primes rev frame))

/-- THE gate-time `ReadTmp` tie from the executed `fk->tmp` binding through an
    entry frame: `readTmp_of_binding` at the binding output, transported to the
    gate state by the frame and the caller cells. -/
theorem readTmp_of_binding_frame (ctx : Context) (entered : State) (middle : Memory)
    (gate : State) (primes rev : ArrayPointer)
    (source : KeygenMakeWorkspaceAllocation.Binding ctx entered.heap middle)
    (frame : EntryFrame ctx middle gate.heap primes rev)
    (bound : KeygenSearchContext.Bound gate ctx)
    (legal : KeygenSearchContext.ObjectLegal gate.heap ctx)
    (pointer : KeygenSearchContext.PointerLegal ctx) :
    KeygenSearchContext.ReadTmp ctx gate ctx.scratch :=
  KeygenSearchContext.ReadTmp.read bound legal pointer
    (load64_frame middle gate.heap (KeygenSearchContext.field ctx 432 8)
      (KeygenSearchContext.pointerWord ctx) (KeygenMakeWorkspaceAllocation.binding_tmp_load source)
      frame.sizes (tmp_cells ctx middle gate.heap primes rev frame))

/-! ## 2. The entry-facts transport along an entry frame -/

/-- THE `Initial`/legal/static entry transport along an entry frame: the
    array/table cell groups and the entry blocks retained. -/
theorem initial_of_frame (ctx : Context) (before after : State) (input : Fin 4 → ArrayPointer)
    (h primes rev : ArrayPointer) (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (fk : after.arrays "fk".toList=before.arrays "fk".toList)
    (inputs : ∀ slot : Fin 4,
      after.arrays (KeygenResidueTrace.names slot).2.toList=before.arrays (KeygenResidueTrace.names slot).2.toList)
    (publicCells : after.arrays "h".toList=before.arrays "h".toList)
    (tables : after.tables=before.tables)
    (frame : EntryFrame ctx before.heap after.heap primes rev) :
    KeygenCallerEntry.Initial ctx after input h primes rev := by
  refine ⟨?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · exact fk.trans initial.context
  · intro slot
    exact (inputs slot).trans (initial.inputs slot)
  · exact publicCells.trans initial.publicPointer
  · exact profile_of_frame ctx before.heap after.heap primes rev initial.profile frame
  · rw [tables]
    exact initial.table
  · exact KeygenCallerTransport.prime_same before.heap after.heap primes initial.primeObject
      ⟨frame.sizes,frame.writable,frame.prime⟩
  · rw [tables]
    exact initial.revBinding
  · exact KeygenCallerTransport.rev_same before.heap after.heap rev initial.revSource
      ⟨frame.sizes,frame.writable,frame.rev⟩
  · simpa only [KeygenMkgm3Layout.Legal,frame.sizes,frame.writable] using initial.scratch
  · intro slot
    simpa only [Allocated,frame.sizes] using initial.allocated slot
  · exact initial.width
  · exact initial.scratchSeparate
  · exact initial.distinct
  · exact initial.contextSeparate
  · exact initial.contextScratch
  · intro name p binding
    exact initial.contextTables name p (by rw [← tables]; exact binding)
  · intro slot name p binding
    exact initial.inputTables slot name p (by rw [← tables]; exact binding)
  · exact initial.publicSeparate
  · exact initial.publicContext
  · intro name p binding
    have live := initial.staticLive name p (by rw [← tables]; exact binding)
    rw [frame.sizes]
    exact live

/-! ## 3. Gates 1-3: the ternary body -/

/-- The two sampler calls keep the entry frame: the fk-object bytes outside
    the RNG subobject (through the executed SHAKE stores), the static table
    blocks (separated from the rng and both destination arrays) and the
    allocation metadata. -/
theorem frame_of_sampling (ctx : Context) (before middle after : State) (input : Fin 4 → ArrayPointer)
    (h primes rev : ArrayPointer) (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (entry : KeygenAttemptMaterial.Entry ctx before (input 0) (input 1))
    (first : KeygenSamplerContext.Call ctx before "f" middle)
    (second : KeygenSamplerContext.Call ctx middle "g" after) :
    EntryFrame ctx before.heap after.heap primes rev := by
  have legal := KeygenMakeSearchMaterial.root_initial ctx before input h primes rev initial
  have metadata := KeygenAttemptMaterial.sampling_metadata ctx before middle after (input 0) (input 1)
    entry first second
  have primesSame : SameBlock before.heap after.heap primes.block :=
    KeygenCallerTransport.sampling_table ctx before middle after input primes rev primes "PRIMES3".toList
      initial.table (initial.staticLive _ _ initial.table) entry legal first second
  have revSame : SameBlock before.heap after.heap rev.block :=
    KeygenCallerTransport.sampling_table ctx before middle after input primes rev rev "REV10".toList
      initial.revBinding (initial.staticLive _ _ initial.revBinding) entry legal first second
  refine ⟨metadata.1,metadata.2,?_,primesSame.2.2,revSame.2.2⟩
  intro offset outside
  have one := KeygenSamplerContext.context ctx before middle "f" (input 0) first
    (Ne.symm (initial.contextSeparate 0)) entry.size entry.fPointer offset outside
  have middleSize : C99CountedWords.Limit middle :=
    (congrFun (KeygenCallerTransport.sampler_locals _ _ _ _ first) _).trans entry.size
  have middlePointer : middle.arrays "g".toList=some (input 1) :=
    (congrFun (KeygenAttemptMaterial.sampler_slots _ _ _ _ first).1 _).trans entry.gPointer
  have two := KeygenSamplerContext.context ctx middle after "g" (input 1) second
    (Ne.symm (initial.contextSeparate 1)) middleSize middlePointer offset outside
  exact (ShakePointFrame.trans before.heap middle.heap after.heap ctx.object.block offset one two).2.2

/-- The gates 1-3 entry frame: both sampler calls, the resultant gate and the
    norm bodies keep the entry blocks on every return edge. -/
theorem frame_of_ternary (ctx : Context) (entry : State) (out : Result)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx entry input h primes rev)
    (material : KeygenAttemptMaterial.Entry ctx entry (input 0) (input 1))
    (normProtected : KeygenAttemptNorm.Protected ctx entry ctx.object.block)
    (source : KeygenCallerPrefix.Ternary ctx entry out) :
    EntryFrame ctx entry.heap out.state.heap primes rev := by
  cases source with
  | resultantRejected middle sampled out first second gate rejected =>
    have sampling := frame_of_sampling ctx entry middle sampled input h primes rev initial material
      first second
    have stable := (KeygenAttemptMaterial.resultants sampled out gate).2
    have bytes := KeygenResultantGate.bytes sampled out gate
    exact entry_frame_trans _ _ _ _ _ _ sampling
      ⟨stable.size,stable.writable,
        fun offset _ => congrFun (congrFun bytes ctx.object.block) offset,
        fun offset => congrFun (congrFun bytes primes.block) offset,
        fun offset => congrFun (congrFun bytes rev.block) offset⟩
  | norm middle sampled res out first second resultants norm =>
    have sampling := frame_of_sampling ctx entry middle sampled input h primes rev initial material
      first second
    have resStable := (KeygenAttemptMaterial.resultants sampled ⟨res,.normal⟩ resultants).2
    have resBytes := KeygenResultantGate.bytes sampled ⟨res,.normal⟩ resultants
    have resFrame : EntryFrame ctx sampled.heap res.heap primes rev :=
      ⟨resStable.size,resStable.writable,
        fun offset _ => congrFun (congrFun resBytes ctx.object.block) offset,
        fun offset => congrFun (congrFun resBytes primes.block) offset,
        fun offset => congrFun (congrFun resBytes rev.block) offset⟩
    have normStable := KeygenAttemptNorm.stable ctx res out norm
    obtain ⟨_,_,_,primeReadonly,_,_,_⟩ := initial.primeObject
    obtain ⟨revReadonly,_,_,_⟩ := initial.revSource
    have resReadonly : res.heap.writable primes.block=false := by
      rw [resStable.writable,sampling.writable]
      exact primeReadonly
    have resRevReadonly : res.heap.writable rev.block=false := by
      rw [resStable.writable,sampling.writable]
      exact revReadonly
    have resSlots := KeygenAttemptSlots.trans _ _ _
      (KeygenAttemptMaterial.sampler_slots _ _ _ _ first)
      (KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ second)
        (KeygenAttemptMaterial.resultants _ _ resultants).1)
    have resProtected : KeygenAttemptNorm.Protected ctx res ctx.object.block :=
      KeygenAttemptMaterial.protected_slots _ _ _ ctx.object.block resSlots normProtected
    have normFrame : EntryFrame ctx res.heap out.state.heap primes rev :=
      ⟨normStable.size,normStable.writable,
        fun offset _ => KeygenAttemptNorm.bytes ctx res out norm ctx.object.block resProtected offset,
        fun offset => normStable.readonly primes.block offset resReadonly,
        fun offset => normStable.readonly rev.block offset resRevReadonly⟩
    exact entry_frame_trans _ _ _ _ _ _ sampling (entry_frame_trans _ _ _ _ _ _ resFrame normFrame)

/-- The gates 1-3 entry transport: both sampler calls, the resultant gate and
    the norm bodies keep the `Initial`/legal/static facts on every return
    edge. -/
theorem initial_of_ternary (ctx : Context) (entry : State) (out : Result)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx entry input h primes rev)
    (material : KeygenAttemptMaterial.Entry ctx entry (input 0) (input 1))
    (normProtected : KeygenAttemptNorm.Protected ctx entry ctx.object.block)
    (source : KeygenCallerPrefix.Ternary ctx entry out) :
    KeygenCallerEntry.Initial ctx out.state input h primes rev :=
  initial_of_frame ctx entry out.state input h primes rev initial
    (congrFun (KeygenCallerPrefix.ternary_slots ctx entry out source).1 "fk".toList)
    (fun slot => congrFun (KeygenCallerPrefix.ternary_slots ctx entry out source).1
      (KeygenResidueTrace.names slot).2.toList)
    (congrFun (KeygenCallerPrefix.ternary_slots ctx entry out source).1 "h".toList)
    (KeygenCallerPrefix.ternary_slots ctx entry out source).2
    (frame_of_ternary ctx entry out input h primes rev initial material normProtected source)

/-- The ternary scope close keeps the entry facts: the close restores only the
    rt names and the two locals; the heap and the table map are untouched. -/
theorem initial_of_close (ctx : Context) (saved after : State) (input : Fin 4 → ArrayPointer)
    (h primes rev : ArrayPointer) (initial : KeygenCallerEntry.Initial ctx after input h primes rev) :
    KeygenCallerEntry.Initial ctx (KeygenCallerPrefix.close saved after) input h primes rev :=
  initial_of_frame ctx after (KeygenCallerPrefix.close saved after) input h primes rev initial
    (KeygenCallerPrefix.close_array saved after "fk".toList (by decide))
    (fun slot => KeygenCallerPrefix.close_array saved after
      (KeygenResidueTrace.names slot).2.toList (KeygenCallerEntry.input_not_rt slot))
    (KeygenCallerPrefix.close_array saved after "h".toList (by decide))
    (KeygenMakeAttemptSpine.close_tables saved after)
    (entry_frame_rfl ctx after.heap primes rev)

/-! ## 4. Gate 4 (public) and gate 5 (solver) transports -/

/-- The public computation keeps the entry frame on both gate edges: the call
    writes only the public h block, so the fk object and the static tables
    retain their bytes and the metadata is stable. -/
theorem frame_of_public (ctx : Context) (before after : State) (v : Value)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (source : KeygenPublicSource.Call before after v) :
    EntryFrame ctx before.heap after.heap primes rev := by
  obtain ⟨_,_,_,primeReadonly,_,_,_⟩ := initial.primeObject
  obtain ⟨revReadonly,_,_,_⟩ := initial.revSource
  have stable := KeygenPublicStability.call before after v source
  have objectSame : SameBlock before.heap after.heap ctx.object.block :=
    KeygenPublicSource.frame before after v source ctx.object.block
      (KeygenMakeSearchMaterial.context_public ctx before input h primes rev initial)
      initial.contextTables
      (KeygenCallerTransport.context_live ctx before.heap initial.profile)
  exact ⟨objectSame.1,objectSame.2.1,fun offset _ => objectSame.2.2 offset,
    fun offset => stable.readonly primes.block offset primeReadonly,
    fun offset => stable.readonly rev.block offset revReadonly⟩

/-- The public computation (gate 4) keeps the `Initial`/legal/static facts on
    both gate edges. -/
theorem initial_of_public (ctx : Context) (before after : State) (v : Value)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (source : KeygenPublicSource.Call before after v) :
    KeygenCallerEntry.Initial ctx after input h primes rev := by
  have slots := KeygenMakeAttemptSpine.public_slots_state before after v source
  exact initial_of_frame ctx before after input h primes rev initial
    (congrFun slots.2.1 "fk".toList)
    (fun slot => congrFun slots.2.1 (KeygenResidueTrace.names slot).2.toList)
    (congrFun slots.2.1 "h".toList) slots.2.2
    (frame_of_public ctx before after v input h primes rev initial source)

/-- The transform sequence keeps the allocation metadata of its calls. -/
theorem solver_ntt_stable (statement : C99ProcedureReference.Stmt) (before after : State)
    (source : KeygenSolverNttCalls.Exec statement before after) :
    KeygenMemoryStability.Stable before.heap after.heap := by
  induction source with
  | skip s => exact KeygenMemoryStability.refl _
  | seq first second before middle after head tail ih1 ih2 =>
    exact KeygenMemoryStability.trans _ _ _ ih1 ih2
  | call args before entry out parameters body returned =>
    have result := KeygenMemoryStability.modular KeygenNttForwardPrograms.forwardBody entry out body
    rw [C99ArrayReference.bind_heap before KeygenSolverNttCalls.params
      (KeygenSolverNttCalls.expandArgs args) entry parameters] at result
    show KeygenMemoryStability.Stable before.heap out.state.heap
    exact result

/-- The validation suffix keeps the allocation metadata of its whole body. -/
theorem validation_stable (ctx : Context) (before : State) (out : Result)
    (source : KeygenRootValidationSource.Exec ctx before out) :
    KeygenMemoryStability.Stable before.heap out.state.heap := by
  cases source with
  | run prepared entry generated converted transformed out genTernary nttTernary preparation genMember genNonzero binding generation genReturn conversion convNormal nttMember nttNonzero transforms validation =>
    have prep : KeygenMemoryStability.Stable before.heap prepared.heap := by
      cases preparation with
      | run root primes aliased ternary p p0i tmp layout normal member nonzero table primeRead inverse =>
        have result := KeygenMemoryStability.modular KeygenMkgm3Layout.aliasCode
          (C99ArrayReference.bindPointer before "ft".toList root) aliased layout
        show KeygenMemoryStability.Stable before.heap aliased.state.heap
        simpa only [C99ArrayReference.bindPointer] using result
    have gen : KeygenMemoryStability.Stable prepared.heap generated.state.heap := by
      have result := KeygenMemoryStability.modular KeygenMkgm3Program.code entry generated generation
      rw [KeygenLevelCalls.bind_heap prepared entry (KeygenLevelCalls.params .generate)
        KeygenRootValidationSource.genArgs binding] at result
      exact result
    have conv : KeygenMemoryStability.Stable generated.state.heap converted.state.heap := by
      have result := KeygenMemoryStability.modular KeygenResidueProgram.code
        (KeygenRootValidationSource.returned prepared generated) converted conversion
      simpa only [KeygenRootValidationSource.returned] using result
    have ntt : KeygenMemoryStability.Stable converted.state.heap transformed.heap :=
      solver_ntt_stable KeygenSolverNttCalls.code converted.state transformed transforms
    have final : KeygenMemoryStability.Stable transformed.heap out.state.heap :=
      KeygenMemoryStability.modular KeygenSolverTarget.code transformed out validation
    exact KeygenMemoryStability.trans _ _ _ prep
      (KeygenMemoryStability.trans _ _ _ gen
        (KeygenMemoryStability.trans _ _ _ conv (KeygenMemoryStability.trans _ _ _ ntt final)))

/-- The solver body keeps the allocation metadata of the whole call. -/
theorem solver_stable (ctx : Context) (before after : State) (v : Value)
    (source : KeygenRootSource.Call ctx before after v) :
    KeygenMemoryStability.Stable before.heap after.heap := by
  cases source with
  | run entry out v binding body returned =>
    have result : KeygenMemoryStability.Stable entry.heap out.state.heap := by
      cases body with
      | searchRejected raw search rejected =>
        exact KeygenSearchStability.root ctx entry _ search
      | outputRejected searched raw search gate rejected =>
        obtain ⟨ternary,tmp,_,_,exec⟩ := gate
        exact KeygenMemoryStability.trans _ _ _
          (KeygenSearchStability.root ctx entry ⟨searched,.normal⟩ search)
          (KeygenRootObjects.gate ⟨ternary,tmp⟩ searched _ exec)
      | validated searched passed raw search gate validation =>
        obtain ⟨ternary,tmp,_,_,exec⟩ := gate
        exact KeygenMemoryStability.trans _ _ _
          (KeygenMemoryStability.trans _ _ _
            (KeygenSearchStability.root ctx entry ⟨searched,.normal⟩ search)
            (KeygenRootObjects.gate ⟨ternary,tmp⟩ searched ⟨passed,.normal⟩ exec))
          (validation_stable ctx passed _ validation)
    rw [C99ArrayReference.bind_heap before KeygenRootSource.params KeygenRootSource.arguments entry
      binding] at result
    show KeygenMemoryStability.Stable before.heap out.state.heap
    exact result

/-- The solver call keeps the entry frame on both gate edges: the solver-call
    frame holds at the fk object and the static tables are read-only blocks. -/
theorem frame_of_solver (ctx : Context) (before after : State) (v : Value)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (source : KeygenRootSource.Call ctx before after v) :
    EntryFrame ctx before.heap after.heap primes rev := by
  obtain ⟨_,_,_,primeReadonly,_,_,_⟩ := initial.primeObject
  obtain ⟨revReadonly,_,_,_⟩ := initial.revSource
  have stable := solver_stable ctx before after v source
  have objectSame : SameBlock before.heap after.heap ctx.object.block :=
    KeygenMakeRetryFrames.solver_frame ctx before after v input h primes rev
      (KeygenMakeSearchMaterial.root_initial ctx before input h primes rev initial) source ctx.object.block
      ⟨initial.contextScratch,initial.contextTables⟩ (initial.contextSeparate 2) (initial.contextSeparate 3)
  exact ⟨objectSame.1,objectSame.2.1,fun offset _ => objectSame.2.2 offset,
    fun offset => stable.readonly primes.block offset primeReadonly,
    fun offset => stable.readonly rev.block offset revReadonly⟩

/-- The solver call (gate 5) keeps the `Initial`/legal/static facts on both
    gate edges. -/
theorem initial_of_solver (ctx : Context) (before after : State) (v : Value)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (source : KeygenRootSource.Call ctx before after v) :
    KeygenCallerEntry.Initial ctx after input h primes rev := by
  have slots := KeygenRootSource.slots ctx before after v source
  exact initial_of_frame ctx before after input h primes rev initial
    (congrFun slots.2.1 "fk".toList)
    (fun slot => congrFun slots.2.1 (KeygenResidueTrace.names slot).2.toList)
    (congrFun slots.2.1 "h".toList) slots.2.2
    (frame_of_solver ctx before after v input h primes rev initial source)

/-! ## 5. The certificate gate and the whole attempt on every edge -/

/-- The certificate-call entry frame: the certificate body keeps the bytes of
    the fk object and the two static source tables. Its derivation from
    `CertificateFunctionFrame.source_frame` (valid on BOTH return values)
    needs the M0 table-block inversion of the pinned FFT table environment
    (blocks 1/2), the open `call_same_block` item; here it is an explicit,
    named residual of the same class as the spine's `LegalWorkspace` input. -/
def CertEntryFrame (ctx : Context) (before after : Memory) (primes rev : ArrayPointer) : Prop :=
  (∀ offset, after.bytes ctx.object.block offset=before.bytes ctx.object.block offset) ∧
  (∀ offset, after.bytes primes.block offset=before.bytes primes.block offset) ∧
  (∀ offset, after.bytes rev.block offset=before.bytes rev.block offset)

/-- The certificate call keeps the allocation metadata: its automatic frame is
    entered and left around the body, and the body writes no new block. -/
theorem cert_shape (ctx : Context) (before after : State) (v : Value) (ret : Bool)
    (source : KeygenMakeCertCall.Call ctx before after v ret) :
    after.heap.size=before.heap.size ∧ after.heap.writable=before.heap.writable := by
  cases source with
  | run args bind afterMem gateTrace events ret body v bit =>
    exact KeygenMakeCertMaterial.leave_shape args FftGlobalMemory.environment before.heap afterMem
      gateTrace events ret body.2

/-- The sixth gate keeps the `Initial`/legal/static facts AND the entry frame
    on every edge: the unprofiled skip is the identity, both call edges keep
    the cells and (through the named residual) the entry blocks. -/
theorem cert_gate_entry (ctx : Context) (before : State) (out : Result)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (gate : KeygenMakeCertCall.CertificateGate ctx before out)
    (certFrame : ∀ (s t : State) (w : Value) (ret : Bool),
      KeygenMakeCertCall.Call ctx s t w ret → CertEntryFrame ctx s.heap t.heap primes rev) :
    KeygenCallerEntry.Initial ctx out.state input h primes rev ∧
      EntryFrame ctx before.heap out.state.heap primes rev := by
  cases gate with
  | rejected after v call =>
    have cells := KeygenMakeCertCall.call_cells ctx before after v false call
    have shape := cert_shape ctx before after v false call
    have residual := certFrame before after v false call
    have frame : EntryFrame ctx before.heap after.heap primes rev :=
      ⟨shape.1,shape.2,fun offset _ => residual.1 offset,residual.2.1,residual.2.2⟩
    exact ⟨initial_of_frame ctx before after input h primes rev initial
        (congrFun cells.2.1 "fk".toList)
        (fun slot => congrFun cells.2.1 (KeygenResidueTrace.names slot).2.toList)
        (congrFun cells.2.1 "h".toList) cells.2.2 frame,frame⟩
  | accepted after v call =>
    have cells := KeygenMakeCertCall.call_cells ctx before after v true call
    have shape := cert_shape ctx before after v true call
    have residual := certFrame before after v true call
    have frame : EntryFrame ctx before.heap after.heap primes rev :=
      ⟨shape.1,shape.2,fun offset _ => residual.1 offset,residual.2.1,residual.2.2⟩
    exact ⟨initial_of_frame ctx before after input h primes rev initial
        (congrFun cells.2.1 "fk".toList)
        (fun slot => congrFun cells.2.1 (KeygenResidueTrace.names slot).2.toList)
        (congrFun cells.2.1 "h".toList) cells.2.2 frame,frame⟩
  | unprofiled noProfile =>
    exact ⟨initial,entry_frame_rfl ctx before.heap primes rev⟩

/-- The public gate hands its caller state to the underlying public call on
    every edge. -/
theorem public_gate_any (before : State) (out : Result)
    (gate : KeygenAttemptMaterial.PublicGate before out) :
    ∃ v : Value, KeygenPublicSource.Call before out.state v := by
  cases gate with
  | reject after v call zero => exact ⟨v,call⟩
  | accept after v call nonzero => exact ⟨v,call⟩

/-- The solver gate hands its caller state to the underlying solver call on
    every edge. -/
theorem root_gate_any (ctx : Context) (before : State) (out : Result)
    (gate : KeygenCallerSuccess.RootGate ctx before out) :
    ∃ v : Value, KeygenRootSource.Call ctx before out.state v := by
  cases gate with
  | reject after v call zero => exact ⟨v,call⟩
  | accept after v call nonzero => exact ⟨v,call⟩

/-- The five-gate prefix keeps the `Initial`/legal/static facts AND the entry
    frame on every edge of `Gates`. -/
theorem gate_entry (ctx : Context) (saved entry : State) (out : Result)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (entryInitial : KeygenCallerEntry.Initial ctx entry input h primes rev)
    (material : KeygenAttemptMaterial.Entry ctx entry (input 0) (input 1))
    (normProtected : KeygenAttemptNorm.Protected ctx entry ctx.object.block)
    (source : KeygenMakeSearchPrefix.Gates ctx saved entry out) :
    KeygenCallerEntry.Initial ctx out.state input h primes rev ∧
      EntryFrame ctx entry.heap out.state.heap primes rev := by
  cases source with
  | ternaryRejected raw source rejected =>
    exact ⟨initial_of_close ctx saved raw.state input h primes rev
        (initial_of_ternary ctx entry raw input h primes rev entryInitial material normProtected source),
      frame_of_ternary ctx entry raw input h primes rev entryInitial material normProtected source⟩
  | publicRejected normed raw source gate rejected =>
    obtain ⟨pv,publicCall⟩ := public_gate_any _ _ gate
    have ternaryFrame : EntryFrame ctx entry.heap normed.heap primes rev :=
      frame_of_ternary ctx entry ⟨normed,.normal⟩ input h primes rev entryInitial material normProtected source
    have closed : KeygenCallerEntry.Initial ctx (KeygenCallerPrefix.close saved normed) input h primes rev :=
      initial_of_close ctx saved normed input h primes rev
        (initial_of_ternary ctx entry ⟨normed,.normal⟩ input h primes rev entryInitial material
          normProtected source)
    exact ⟨initial_of_public ctx (KeygenCallerPrefix.close saved normed) _ pv input h primes rev
        closed publicCall,
      entry_frame_trans _ _ _ _ _ _ ternaryFrame
        (frame_of_public ctx (KeygenCallerPrefix.close saved normed) _ pv input h primes rev closed
          publicCall)⟩
  | solver normed publicState raw source publicGate gate =>
    obtain ⟨pv,publicCall⟩ := public_gate_any _ _ publicGate
    obtain ⟨sv,solverCall⟩ := root_gate_any ctx _ _ gate
    have ternaryFrame : EntryFrame ctx entry.heap normed.heap primes rev :=
      frame_of_ternary ctx entry ⟨normed,.normal⟩ input h primes rev entryInitial material normProtected source
    have closed : KeygenCallerEntry.Initial ctx (KeygenCallerPrefix.close saved normed) input h primes rev :=
      initial_of_close ctx saved normed input h primes rev
        (initial_of_ternary ctx entry ⟨normed,.normal⟩ input h primes rev entryInitial material
          normProtected source)
    have openState : KeygenCallerEntry.Initial ctx _ input h primes rev :=
      initial_of_public ctx (KeygenCallerPrefix.close saved normed) _ pv input h primes rev closed publicCall
    have closeFrame : EntryFrame ctx normed.heap (KeygenCallerPrefix.close saved normed).heap primes rev :=
      entry_frame_rfl ctx normed.heap primes rev
    exact ⟨initial_of_solver ctx _ _ sv input h primes rev openState solverCall,
      entry_frame_trans _ _ _ _ _ _ ternaryFrame
        (entry_frame_trans _ _ _ _ _ _ closeFrame
          (entry_frame_trans _ _ _ _ _ _
            (frame_of_public ctx (KeygenCallerPrefix.close saved normed) _ pv input h primes rev closed
              publicCall)
            (frame_of_solver ctx _ _ sv input h primes rev openState solverCall)))⟩

/-- THE per-retry entry transport at the gate level: one whole `Sampled`
    attempt keeps the `Initial`/legal/static facts and the entry frame on
    every return edge. -/
theorem sampled_entry (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (source : KeygenMakeSearchPrefix.Sampled ctx before out) :
    KeygenCallerEntry.Initial ctx out.state input h primes rev ∧
      EntryFrame ctx before.heap out.state.heap primes rev := by
  cases source with
  | run entry out cap gates =>
    rcases KeygenMakeSampling.cap_before_setup ctx before i ⟨entry,.normal⟩
      remaining.2.2 remaining.1 remaining.2.1.1 cap with aborted | running
    · have impossible := congrArg Result.flow aborted.2
      cases impossible
    · have entryEq : entry=KeygenMakeSearchPrefix.updated ctx before i := congrArg Result.state running.2.1
      subst entry
      have entryInitial := KeygenMakeSampling.prepared_initial ctx before i input h primes rev initial
      have material := KeygenMakeSampling.entry_from_prepared ctx before i input h primes rev initial
        remaining.2.1.1
      have normProtected := KeygenMakeSearchMaterial.context_norm ctx before i input h primes rev initial
      exact gate_entry ctx before (KeygenMakeSearchPrefix.updated ctx before i) out input h primes rev
        entryInitial material normProtected gates

/-- THE whole-attempt entry transport on EVERY return edge (general typed
    execution of the capped attempt): early rejections, the certificate
    rejection retry and the accepted break all carry the `Initial`/legal/static
    facts and the entry frame to their return state. The certificate leg
    consumes the named `CertEntryFrame` residual at its call edges. -/
theorem attempt_entry (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (source : KeygenMakeCertChronology.AttemptExec ctx before out)
    (certFrame : ∀ (s t : State) (w : Value) (ret : Bool),
      KeygenMakeCertCall.Call ctx s t w ret → CertEntryFrame ctx s.heap t.heap primes rev) :
    KeygenCallerEntry.Initial ctx out.state input h primes rev ∧
      EntryFrame ctx before.heap out.state.heap primes rev := by
  cases source with
  | earlyRejected raw sample rejected =>
    exact sampled_entry ctx before _ i input h primes rev remaining initial sample
  | throughCertificate raw sample atCert out gate =>
    obtain ⟨rawInitial,rawFrame⟩ := sampled_entry ctx before _ i input h primes rev remaining initial sample
    obtain ⟨outInitial,outFrame⟩ := cert_gate_entry ctx _ _ input h primes rev rawInitial gate certFrame
    exact ⟨outInitial,entry_frame_trans _ _ _ _ _ _ rawFrame outFrame⟩

/-- THE `Initial`/legal/static entry transport of one whole attempt on every
    return edge. -/
theorem initial_of_attempt (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (source : KeygenMakeCertChronology.AttemptExec ctx before out)
    (certFrame : ∀ (s t : State) (w : Value) (ret : Bool),
      KeygenMakeCertCall.Call ctx s t w ret → CertEntryFrame ctx s.heap t.heap primes rev) :
    KeygenCallerEntry.Initial ctx out.state input h primes rev :=
  (attempt_entry ctx before out i input h primes rev remaining initial source certFrame).1

/-- The entry frame of one whole attempt on every return edge. -/
theorem frame_of_attempt (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (source : KeygenMakeCertChronology.AttemptExec ctx before out)
    (certFrame : ∀ (s t : State) (w : Value) (ret : Bool),
      KeygenMakeCertCall.Call ctx s t w ret → CertEntryFrame ctx s.heap t.heap primes rev) :
    EntryFrame ctx before.heap out.state.heap primes rev :=
  (attempt_entry ctx before out i input h primes rev remaining initial source certFrame).2

/-! ## 6. The per-retry step of `entry_of_allocation` -/

/-- THE per-retry transport of `entry_of_allocation` across the whole attempt:
    a rejected attempt hands its `Initial`/legal/static facts and the advanced
    loop counter to the next retry instance. The transport holds on every
    return edge, so no flow premise is needed; the loop-trace chronology
    composition stays at this gate level. -/
theorem retry_entry (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (source : KeygenMakeCertChronology.AttemptExec ctx before out)
    (certFrame : ∀ (s t : State) (w : Value) (ret : Bool),
      KeygenMakeCertCall.Call ctx s t w ret → CertEntryFrame ctx s.heap t.heap primes rev) :
    KeygenCallerEntry.Initial ctx out.state input h primes rev ∧
      KeygenMakeSearchPrefix.Remaining out.state (i+1) :=
  ⟨initial_of_attempt ctx before out i input h primes rev remaining initial source certFrame,
    (KeygenMakeCertChronology.attempt_remaining ctx before out i remaining source).2.1⟩

/-- The allocation-derived entry facts reach the FIRST retry instance: the
    pinned already-ready prologue facts of `entry_of_allocation` transported
    across the first attempt's rejection. -/
theorem entry_of_allocation_retry (ctx : Context) (before after : State) (blocks : Fin 6 → Nat)
    (primes rev : ArrayPointer) (events : List KeygenEntropySource.Event)
    (original : KeygenMakeEntry.Original ctx before primes rev)
    (head : KeygenMakeReady.Prefix ctx before blocks events ⟨after,.normal⟩)
    (out : Result) (source : KeygenMakeCertChronology.AttemptExec ctx after out)
    (certFrame : ∀ (s t : State) (w : Value) (ret : Bool),
      KeygenMakeCertCall.Call ctx s t w ret → CertEntryFrame ctx s.heap t.heap primes rev) :
    KeygenCallerEntry.Initial ctx out.state (KeygenMakeEntry.input blocks)
      (KeygenMakeEntry.publicPointer blocks) primes rev ∧
      KeygenMakeSearchPrefix.Remaining out.state 1 := by
  have facts := KeygenMakeAttemptSpine.entry_of_allocation ctx before after blocks primes rev events
    original head
  exact retry_entry ctx after out 0 (KeygenMakeEntry.input blocks)
    (KeygenMakeEntry.publicPointer blocks) primes rev facts.2 facts.1 source certFrame

/-! ## 7. The gate-time `ReadTmp` tie through the attempt frames -/

/-- THE gate-time `ReadTmp` tie through the attempt frames: the member read of
    the bound scratch pointer survives a whole attempt on every return edge,
    from the entry facts and the entry read at the attempt input. -/
theorem readTmp_of_attempt (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (read : KeygenSearchContext.ReadTmp ctx before ctx.scratch)
    (source : KeygenMakeCertChronology.AttemptExec ctx before out)
    (certFrame : ∀ (s t : State) (w : Value) (ret : Bool),
      KeygenMakeCertCall.Call ctx s t w ret → CertEntryFrame ctx s.heap t.heap primes rev) :
    KeygenSearchContext.ReadTmp ctx out.state ctx.scratch := by
  cases read with
  | read bound legal pointer bytes =>
    have frame := frame_of_attempt ctx before out i input h primes rev remaining initial source certFrame
    exact KeygenSearchContext.ReadTmp.read
      (initial_of_attempt ctx before out i input h primes rev remaining initial source certFrame).context
      (object_legal_frame ctx before.heap out.state.heap primes rev legal frame) pointer
      (load64_frame before.heap out.state.heap (KeygenSearchContext.field ctx 432 8)
        (KeygenSearchContext.pointerWord ctx) bytes frame.sizes
        (tmp_cells ctx before.heap out.state.heap primes rev frame))

/-- THE gate-time `ReadTmp` tie from the executed `fk->tmp` binding through
    the attempt frames: `readTmp_of_binding` at the loop entry transported to
    every later return of the attempt. -/
theorem readTmp_of_binding_attempt (ctx : Context) (entered before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (binding : KeygenMakeWorkspaceAllocation.Binding ctx entered.heap before.heap)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (legal : KeygenSearchContext.ObjectLegal before.heap ctx)
    (pointer : KeygenSearchContext.PointerLegal ctx)
    (source : KeygenMakeCertChronology.AttemptExec ctx before out)
    (certFrame : ∀ (s t : State) (w : Value) (ret : Bool),
      KeygenMakeCertCall.Call ctx s t w ret → CertEntryFrame ctx s.heap t.heap primes rev) :
    KeygenSearchContext.ReadTmp ctx out.state ctx.scratch :=
  readTmp_of_attempt ctx before out i input h primes rev remaining initial
    (KeygenMakeWorkspaceAllocation.readTmp_of_binding ctx entered before binding initial.context legal
      pointer) source certFrame

end FT1536.Source3.KeygenMakeRetryTransport
