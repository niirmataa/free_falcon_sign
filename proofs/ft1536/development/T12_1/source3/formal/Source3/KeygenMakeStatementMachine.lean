import Source3.KeygenMakeAttemptSpine
import Source3.KeygenMakeRetryTransport
import Source3.KeygenMakeWorkspaceAllocation
import Source3.KeygenMakeCertRelocation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- THE statement-machine extraction of the B1.07 call/allocation binding:
   the C call site `(fpr *)fk->tmp` ties to the relativized `ExecAt` at the
   actual scratch block, through the `temp_size` reservation body (the pinned
   candidate mirror storing exactly the certificate workspace extent) and the
   `falcon_keygen_new` prologue stores (the `fk->tmp_len`/`malloc`/`fk->tmp`
   binding). The b-not-1/2 side condition of the pinned transport is
   DISCHARGED from allocation freshness (a fresh malloc block is separated
   from every live block; the pinned FFT table environment keeps blocks 1/2
   live). This step also discharges the residual inputs of the spine/witness
   classes from allocation freshness: the h-side/material-block/workspace
   `EntryFacts` residuals and the `CertEntryFrame` byte frame of the entry
   blocks. The `call_same_block` item is closed here: a general call frame on
   a foreign block, consuming the M0 table-block inversion of the pinned
   table environment (blocks 1/2) inside the step. The certificate
   instantiation carries its concrete pinned globals
   (`FftGlobalScalars.environment` through `FftGlobalMemory.environment`), the
   common call material (gate trace/event stream of the same call), the
   source snapshots and the bad-flag lifetime. No certificate outcome, no
   equation, no codec fact and no scratch-block0 fact is a premise; the
   canonical block0 numbering enters only through the call's own bridge field
   (`workspace_scratch_block`), never as an assumption. Not a review, not a
   law claim; the loop-trace chronology and the encoding-tail codec bodies
   stay outside. -/
namespace FT1536.Source3.KeygenMakeStatementMachine
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open ShakeExtractFrame (SameBlock)
open CertificateFunctionReference (Arguments)

/-! ## 1. The pinned table-block liveness (blocks 1/2) -/

/-- A 64-bit load leaves its pointer allocated; stated with a variable word
    index (a DEFINED index breaks `Load64` elimination — the documented
    determined-index trap). -/
theorem allocated_of_load64 (before : Memory) (p : ArrayPointer) (w : BitVec 64)
    (load : Load64 before p w) : Allocated before p := by
  cases load with
  | load _ allocated _ _ => exact allocated

/-- The pinned FFT table environment loads its source words at blocks 1 and
    2, so both static table blocks are live in any pinned caller memory. The
    inversion is over the pinned `FftGlobalMemory.tables` dispatch only. -/
theorem pinned_block_live (before : Memory) (table : FftTableParser.Table)
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment before) :
    0<before.size (FftGlobalMemory.block table) := by
  have bound : 0<(FftTableSources.words table).length := by
    cases table <;> simpa only [FftTableSources.words_length] using (by decide)
  have load := (pinned.2 table 0 bound).1
  have allocated := allocated_of_load64 before {FftGlobalMemory.pointer table with index := 0}
    ((FftTableSources.words table)[0]) load
  have positive : 0<8*(2*FftTableParser.rowCount table) := by
    cases table <;> decide
  have extent := allocated.2.2.2.1
  dsimp [FftGlobalMemory.pointer,ArrayPointer.offset] at extent
  cases table <;> simp [FftGlobalMemory.block] at extent ⊢ <;> omega

theorem pinned_one_live (before : Memory)
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment before) :
    0<before.size 1 :=
  by simpa [FftGlobalMemory.block] using pinned_block_live before .square pinned

theorem pinned_two_live (before : Memory)
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment before) :
    0<before.size 2 :=
  by simpa [FftGlobalMemory.block] using pinned_block_live before .cubic pinned

/-! ## 2. The b-not-1/2 side condition from allocation freshness -/

/-- The scratch block of the executed `fk->tmp` allocation binding is
    DISTINCT from the two static table blocks: the binding allocates a FRESH
    block (zero size before the `malloc`), while the pinned environment keeps
    blocks 1/2 live. This is the b-not-1/2 side condition of the pinned
    transport (`KeygenMakeCertRelocation.pinned_swap` and the transported
    call frames), discharged from allocation freshness — never assumed. -/
theorem binding_scratch_free (ctx : Context) (before after : Memory)
    (source : KeygenMakeWorkspaceAllocation.Binding ctx before after)
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment before) :
    ctx.scratch.block≠1 ∧ ctx.scratch.block≠2 := by
  cases source with
  | run block middle stored scratch tmpLen fresh allocated tmp =>
    have sizes : middle.size=before.size := tmpLen.2.2.2.1
    have free : middle.size block=0 := fresh.1
    have one : 0<before.size 1 := pinned_one_live before pinned
    have two : 0<before.size 2 := pinned_two_live before pinned
    rw [scratch]
    show (KeygenMakeWorkspaceAllocation.scratchOf block).block≠1 ∧
      (KeygenMakeWorkspaceAllocation.scratchOf block).block≠2
    constructor
    · intro equal
      have eq : block=1 := by
        simpa [KeygenMakeWorkspaceAllocation.scratchOf] using equal
      subst eq
      rw [sizes] at free
      omega
    · intro equal
      have eq : block=2 := by
        simpa [KeygenMakeWorkspaceAllocation.scratchOf] using equal
      subst eq
      rw [sizes] at free
      omega

/-- The six automatic arrays of the make declarations are DISTINCT from the
    two static table blocks: freshness is checked at every declaration
    allocation and the pinned environment keeps blocks 1/2 live. -/
theorem objects_table_free (before after : State) (blocks : Fin 6 → Nat)
    (source : KeygenMakeObjects.Exec 0 before blocks after)
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment before.heap) :
    ∀ slot : Fin 6, (KeygenMakeObjects.pointer blocks slot).block≠1 ∧
      (KeygenMakeObjects.pointer blocks slot).block≠2 := by
  intro slot
  have one : 0<before.heap.size 1 := pinned_one_live before.heap pinned
  have two : 0<before.heap.size 2 := pinned_two_live before.heap pinned
  have first := KeygenMakeObjects.fresh_separate 0 before after blocks source slot (by omega) 1 one
  have second := KeygenMakeObjects.fresh_separate 0 before after blocks source slot (by omega) 2 two
  exact ⟨Ne.symm first,Ne.symm second⟩

/-- The allocation shape predicates transport along the block-size equality. -/
theorem allocated_same (a b : Memory) (p : ArrayPointer)
    (same : a.size p.block=b.size p.block)
    (source : Allocated a p) : Allocated b p := by
  obtain ⟨width,aligned,inside,extent,bounded⟩ := source
  refine ⟨width,aligned,inside,?_,?_⟩
  · rw [← same]
    exact extent
  · rw [← same]
    exact bounded

/-! ## 3. The call-site tie: temp_size body and the fpr cast -/

/-- The executed `temp_size` reservation spans EXACTLY the certificate
    workspace: the stored `fk->tmp_len` value of the binding is the fold
    maximum of the pinned candidate mirror
    (`KeygenMakeWorkspaceExtent.reservation_matches_workspace`), so the
    extent of the reserved buffer equals the workspace extent. -/
theorem scratch_extent_exact (block : Nat) :
    KeygenMakeWorkspaceRelocation.extent (KeygenMakeWorkspaceAllocation.scratchOf block)=286720 :=
  (KeygenMakeWorkspaceAllocation.scratch_extent block).trans
    KeygenMakeWorkspaceAllocation.tempSize_exact

theorem scratch_extent_workspace (block : Nat) :
    KeygenMakeWorkspaceRelocation.extent (KeygenMakeWorkspaceAllocation.scratchOf block)=
      CertificateWorkspace.bytes :=
  (KeygenMakeWorkspaceAllocation.scratch_extent block).trans
    KeygenMakeWorkspaceAllocation.tempSize_workspace

/-- The fpr view of the reserved buffer spans the remaining buffer bytes. -/
theorem fprCast_scratch_span (block : Nat) :
    (KeygenMakeCertCall.fprCast (KeygenMakeWorkspaceAllocation.scratchOf block)).count=
      KeygenMakeWorkspaceRelocation.extent (KeygenMakeWorkspaceAllocation.scratchOf block)/8 :=
  rfl

/-- THE call-site bridge: the `(fpr *)fk->tmp` cast of the bound scratch IS
    the certificate workspace view of the machine at the scratch block — the
    `temp_size` body value and the `falcon_keygen_new` prologue stores tie
    the C call-site argument to the workspace of the relativized `ExecAt`. -/
theorem call_site_bridge (block : Nat) :
    CertificateAfterConversion.workspacePointer
        (ArrayPointer.offset (KeygenMakeWorkspaceAllocation.scratchOf block)) 0=
      KeygenMakeCertCall.fprCast
        (KeygenMakeWorkspaceRelocation.swapPtr block
          (KeygenMakeWorkspaceAllocation.scratchOf block)) :=
  KeygenMakeWorkspaceRelocation.bridge_of_extent
    (KeygenMakeWorkspaceAllocation.scratchOf block) (scratch_extent_exact block)

/-! ## 4. The extraction: the call site binds to `ExecAt` at the scratch block -/

/-- The caller cells plus the executed allocation binding give the
    actual-world binding at the scratch block: the C call site
    `(fpr *)fk->tmp` reads the bound scratch descriptor (the gate-time
    `ReadTmp` tie of `readTmp_of_binding`), and the workspace bridge is the
    same equality read in the relocated world. -/
theorem certBindAt_of_allocation (s entered : State) (ctx : Context) (args : Arguments)
    (cells : KeygenMakeWorkspaceBridge.Cells s ctx args)
    (binding : KeygenMakeWorkspaceAllocation.Binding ctx entered.heap s.heap)
    (base : args.base=ArrayPointer.offset ctx.scratch) :
    KeygenMakeCertRelocation.CertBindAt ctx.scratch.block s ctx args :=
  (KeygenMakeCertRelocation.certBindAt_iff ctx.scratch.block s ctx args).mpr
    (KeygenMakeWorkspaceAllocation.cert_bind_relocated_of_allocation s entered ctx args cells
      binding base)

/-- THE statement-machine tie of the gate call: the executed allocation
    binding and the caller cells bind the certificate body to the relativized
    `ExecAt` at the ACTUAL scratch block (the `falcon_keygen_new` prologue
    stores the `fk->tmp_len`/`malloc`/`fk->tmp` binding, the call site reads
    it back through the `ReadTmp` tie). -/
theorem callAt_of_allocation (s entered : State) (ctx : Context) (args : Arguments)
    (afterMem : Memory) (gateTrace : List (BitVec 64))
    (events : List CertificateEffects.Event) (ret : Bool)
    (cells : KeygenMakeWorkspaceBridge.Cells s ctx args)
    (binding : KeygenMakeWorkspaceAllocation.Binding ctx entered.heap s.heap)
    (base : args.base=ArrayPointer.offset ctx.scratch)
    (body : KeygenMakeCertRelocation.ExecAt ctx.scratch.block args s.heap afterMem
      gateTrace events ret) (v : Value) (bit : (ret=true ↔ v.integer≠0)) :
    KeygenMakeCertRelocation.CallAt ctx.scratch.block ctx s {s with heap := afterMem} v ret :=
  KeygenMakeCertRelocation.callAt_run ctx.scratch.block ctx s args
    (certBindAt_of_allocation s entered ctx args cells binding base)
    afterMem gateTrace events ret body v bit

/-! ## 5. The call frame on foreign blocks: `call_same_block` -/

/-- THE general call frame on a foreign block: the certificate body keeps
    every byte of any block outside the model workspace (block0) and the two
    static table blocks (1/2), on BOTH return values. This closes the open
    `call_same_block` item: it consumes the M0 table-block inversion of the
    pinned table environment (`KeygenMakeWorkspaceTables.
    tablesOutside_nonTable`, blocks 1/2) inside this step. The block0 leg of
    `CertificateRegionFrame.Outside` is read off the hypothesis, never off an
    assumed scratch-block0 fact. -/
theorem call_same_block (ctx : Context) (before after : State) (v : Value) (ret : Bool)
    (call : KeygenMakeCertCall.Call ctx before after v ret)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (workspace : KeygenMakeCertMaterial.LegalWorkspace before ctx)
    (block : Nat) (not0 : block≠0) (not1 : block≠1) (not2 : block≠2) :
    SameBlock before.heap after.heap block := by
  cases call with
  | run args bind afterMem gateTrace events ret body v bit =>
    have profile := KeygenMakeCertCall.bind_callee_profile before ctx args bind dimensions
    have legal := workspace args bind
    have shape := KeygenMakeCertMaterial.leave_shape args FftGlobalMemory.environment
      before.heap afterMem gateTrace events ret body.2
    refine ⟨shape.1,shape.2,fun offset => ?_⟩
    by_cases live : offset<before.heap.size block
    · exact CertificateFunctionFrame.source_frame args FftGlobalMemory.environment
        before.heap afterMem gateTrace events ret profile legal body.2 block offset live
        (Or.inl not0)
        (KeygenMakeWorkspaceTables.tablesOutside_nonTable args before.heap block offset not1 not2)
    · exact KeygenMakeCertMaterial.leave_bytes args FftGlobalMemory.environment
        before.heap afterMem gateTrace events ret body.2 block offset live

/-- THE `CertEntryFrame` residual discharge: the certificate call keeps the
    bytes of the fk object and the two static source tables on BOTH return
    values — the entry frame consumed by the retry transport is now DERIVED
    from the call frame at the three entry blocks. The three-block
    separations come from the allocation freshness legs below. -/
theorem cert_entry_frame (ctx : Context) (before after : State) (v : Value) (ret : Bool)
    (primes rev : ArrayPointer)
    (call : KeygenMakeCertCall.Call ctx before after v ret)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (workspace : KeygenMakeCertMaterial.LegalWorkspace before ctx)
    (objectBlocks : ctx.object.block≠0 ∧ ctx.object.block≠1 ∧ ctx.object.block≠2)
    (primeBlocks : primes.block≠0 ∧ primes.block≠1 ∧ primes.block≠2)
    (revBlocks : rev.block≠0 ∧ rev.block≠1 ∧ rev.block≠2) :
    KeygenMakeRetryTransport.CertEntryFrame ctx before.heap after.heap primes rev := by
  refine ⟨?_,?_,?_⟩
  · exact (call_same_block ctx before after v ret call dimensions workspace ctx.object.block
      objectBlocks.1 objectBlocks.2.1 objectBlocks.2.2).2.2
  · exact (call_same_block ctx before after v ret call dimensions workspace primes.block
      primeBlocks.1 primeBlocks.2.1 primeBlocks.2.2).2.2
  · exact (call_same_block ctx before after v ret call dimensions workspace rev.block
      revBlocks.1 revBlocks.2.1 revBlocks.2.2).2.2

/-- The block0 separations read off the call's own bridge field: the
    canonical model numbering of the entry-facts class is FORCED by the
    executed `CertBind` workspace equality (`workspace_scratch_block`), so
    the material/entry blocks are never the workspace block. -/
theorem scratch_block_of_call (ctx : Context) (before after : State) (v : Value) (ret : Bool)
    (call : KeygenMakeCertCall.Call ctx before after v ret) : ctx.scratch.block=0 := by
  cases call with
  | run args bind afterMem gateTrace events ret body v bit =>
    exact KeygenMakeCertMaterial.workspace_scratch_block before ctx args bind

/-! ## 6. The `EntryFacts` residuals from allocation freshness -/

theorem legal_of_pointer (heap : Memory) (blocks : Fin 6 → Nat) (slot : Fin 6)
    (small : slot.val<5)
    (allocated : Allocated heap (KeygenMakeObjects.pointer blocks slot)) :
    KeygenPublicInputMaterial.Legal heap (KeygenMakeObjects.pointer blocks slot) := by
  have different : slot.val≠5 := by omega
  have width : (KeygenMakeObjects.pointer blocks slot).elementBytes=2 := by
    show KeygenMakeObjects.width slot=2
    simp [KeygenMakeObjects.width,different]
  have count : (KeygenMakeObjects.pointer blocks slot).count=3072 := by
    show KeygenMakeObjects.count slot=3072
    simp [KeygenMakeObjects.count,different]
  refine ⟨width,fun i bound => ?_⟩
  obtain ⟨positive,aligned,inside,extent,bounded⟩ := allocated
  refine ⟨positive,aligned,?_,?_,bounded⟩
  · show (KeygenMakeObjects.pointer blocks slot).index+i<
      (KeygenMakeObjects.pointer blocks slot).count
    have zero : (KeygenMakeObjects.pointer blocks slot).index=0 := rfl
    rw [zero,count]
    omega
  · exact extent

theorem input_of_pointer (blocks : Fin 6 → Nat) (slot : Fin 4) :
    KeygenMakeEntry.input blocks slot=
      KeygenMakeObjects.pointer blocks ⟨slot.val,by have := slot.isLt; omega⟩ := rfl

/-- THE allocation-freshness discharge of the spine's `EntryFacts` class: the
    `Initial`/`Remaining` entry facts of `entry_of_allocation` plus EVERY
    residual input of the witness class — the material-legality cells
    (legalF/legalG/legalH), the h-side separations (hTables/hProtected) and
    the material-block separations from the workspace block0 and the static
    table blocks 1/2 — are derived from the six-array `Declarations`
    allocation freshness, the pinned table-block liveness and the executed
    scratch binding. The block0 leg of the material separations is read
    through the executed binding (`block0` is the canonical shape forced by
    the call's bridge field, see `scratch_block_of_call`); the block 1/2 legs
    are pure freshness. No certificate outcome, equation or codec fact
    appears. -/
theorem entry_facts_of_allocation (ctx : Context) (before after : State) (blocks : Fin 6 → Nat)
    (primes rev : ArrayPointer) (events : List KeygenEntropySource.Event)
    (original : KeygenMakeEntry.Original ctx before primes rev)
    (head : KeygenMakeReady.Prefix ctx before blocks events ⟨after,.normal⟩)
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment before.heap)
    (block0 : ctx.scratch.block=0) :
    KeygenMakeAttemptSpine.EntryFacts ctx after (KeygenMakeEntry.input blocks)
      (KeygenMakeEntry.publicPointer blocks) primes rev := by
  have facts := KeygenMakeAttemptSpine.entry_of_allocation ctx before after blocks primes rev
    events original head
  cases head with
  | run objects initialized dimensioned events out declarations counter dimensions gate =>
    have objectsEq : objects=KeygenMakePrologue.declared before blocks := by
      cases declarations
      rfl
    subst objects
    have entry := KeygenMakePrologue.initial ctx before (KeygenMakePrologue.declared before blocks)
      primes rev original blocks declarations
    have initializedEq : initialized=
        KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks) :=
      congrArg Result.state
        (KeygenMakePrologue.count_result before blocks ⟨initialized,.normal⟩ counter)
    subst initialized
    have profile : KeygenSearchContext.M0
        (KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks)).heap ctx :=
      entry.profile
    have dimensionsEq := KeygenMakePrologue.dimensions_result ctx
      (KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks))
      dimensioned profile dimensions
    subst dimensioned
    have exec : KeygenMakeObjects.Exec 0 (KeygenMakePrologue.projectionStart before)
        blocks (KeygenMakePrologue.declared before blocks) :=
      KeygenMakePrologue.allocation_projection before
        (KeygenMakePrologue.declared before blocks) blocks declarations
    have originalP := KeygenMakePrologue.projection_original ctx before primes rev original
    have call := KeygenMakeReady.gate_normal ctx _ after events gate
    have slots := KeygenRngReference.call_slots ctx _ after events (.int32 1) call
    have objectLive : 0<(KeygenMakePrologue.projectionStart before).heap.size ctx.object.block :=
      KeygenMakeEntry.object_live ctx (KeygenMakePrologue.projectionStart before) primes rev originalP
    have scratchLive : 0<(KeygenMakePrologue.projectionStart before).heap.size ctx.scratch.block :=
      KeygenMakeEntry.scratch_live ctx (KeygenMakePrologue.projectionStart before) primes rev originalP
    have tableLive : ∀ name p, before.tables name=some p →
        0<(KeygenMakePrologue.projectionStart before).heap.size p.block := by
      intro name p binding
      exact originalP.staticLive name p binding
    have arrayFree : ∀ slot : Fin 6, (KeygenMakeObjects.pointer blocks slot).block≠
        ctx.object.block ∧ (KeygenMakeObjects.pointer blocks slot).block≠ctx.scratch.block := by
      intro slot
      refine ⟨Ne.symm (KeygenMakeObjects.fresh_separate 0
          (KeygenMakePrologue.projectionStart before) (KeygenMakePrologue.declared before blocks)
          blocks exec slot (by omega) ctx.object.block objectLive),
        Ne.symm (KeygenMakeObjects.fresh_separate 0
          (KeygenMakePrologue.projectionStart before) (KeygenMakePrologue.declared before blocks)
          blocks exec slot (by omega) ctx.scratch.block scratchLive)⟩
    have arrayShape : ∀ slot : Fin 6,
        after.heap.size (blocks slot)=KeygenMakeObjects.extent slot ∧
        after.heap.writable (blocks slot)=true ∧
        Allocated after.heap (KeygenMakeObjects.pointer blocks slot) := by
      intro slot
      have shape := KeygenMakeObjects.object 0 (KeygenMakePrologue.projectionStart before)
        (KeygenMakePrologue.declared before blocks) blocks exec slot (by omega)
      have allocated := KeygenMakeObjects.allocated_object
        (KeygenMakePrologue.projectionStart before)
        (KeygenMakePrologue.declared before blocks) blocks exec slot
      have frame := KeygenMakeReady.block_frame ctx _ after events (.int32 1) call
        (blocks slot) (arrayFree slot).1
      refine ⟨?_,?_,?_⟩
      · rw [frame.1]
        exact shape.2.1
      · rw [frame.2.1]
        exact shape.2.2.1
      · exact allocated_same (KeygenMakePrologue.declared before blocks).heap after.heap
          (KeygenMakeObjects.pointer blocks slot) frame.1.symm allocated
    have tablesAfter : after.tables=before.tables := slots.2.2.2
    have tablesH : KeygenPublicFrame.Tables after
        (KeygenMakeEntry.publicPointer blocks).block := by
      intro name p binding
      have live := tableLive name p (by simpa [tablesAfter] using binding)
      have fresh := KeygenMakeObjects.fresh_separate 0
        (KeygenMakePrologue.projectionStart before)
        (KeygenMakePrologue.declared before blocks) blocks exec (4 : Fin 6) (by omega) p.block live
      have same : (KeygenMakeEntry.publicPointer blocks).block=blocks 4 := rfl
      rw [same]
      exact fresh
    have scratchH : ctx.scratch.block≠(KeygenMakeEntry.publicPointer blocks).block := by
      have fresh := KeygenMakeObjects.fresh_separate 0
        (KeygenMakePrologue.projectionStart before)
        (KeygenMakePrologue.declared before blocks) blocks exec (4 : Fin 6) (by omega)
        ctx.scratch.block scratchLive
      have same : (KeygenMakeEntry.publicPointer blocks).block=blocks 4 := rfl
      rw [same]
      exact fresh
    have materialBlocks : ∀ slot : Fin 4,
        (KeygenMakeEntry.input blocks slot).block≠0 ∧
        (KeygenMakeEntry.input blocks slot).block≠1 ∧
        (KeygenMakeEntry.input blocks slot).block≠2 := by
      intro slot
      have zeroLive : 0<(KeygenMakePrologue.projectionStart before).heap.size 0 := by
        have moved := scratchLive
        rw [block0] at moved
        exact moved
      have oneLive : 0<(KeygenMakePrologue.projectionStart before).heap.size 1 :=
        pinned_one_live _ pinned
      have twoLive : 0<(KeygenMakePrologue.projectionStart before).heap.size 2 :=
        pinned_two_live _ pinned
      have base : (KeygenMakeEntry.input blocks slot).block=
          blocks ⟨slot.val,by have := slot.isLt; omega⟩ := rfl
      rw [base]
      refine ⟨?_,?_,?_⟩
      · exact Ne.symm (KeygenMakeObjects.fresh_separate 0
          (KeygenMakePrologue.projectionStart before)
          (KeygenMakePrologue.declared before blocks) blocks exec
          ⟨slot.val,by have := slot.isLt; omega⟩ (by omega) 0 zeroLive)
      · exact Ne.symm (KeygenMakeObjects.fresh_separate 0
          (KeygenMakePrologue.projectionStart before)
          (KeygenMakePrologue.declared before blocks) blocks exec
          ⟨slot.val,by have := slot.isLt; omega⟩ (by omega) 1 oneLive)
      · exact Ne.symm (KeygenMakeObjects.fresh_separate 0
          (KeygenMakePrologue.projectionStart before)
          (KeygenMakePrologue.declared before blocks) blocks exec
          ⟨slot.val,by have := slot.isLt; omega⟩ (by omega) 2 twoLive)
    have publicBlocks : (KeygenMakeEntry.publicPointer blocks).block≠0 ∧
        (KeygenMakeEntry.publicPointer blocks).block≠1 ∧
        (KeygenMakeEntry.publicPointer blocks).block≠2 := by
      have zeroLive : 0<(KeygenMakePrologue.projectionStart before).heap.size 0 := by
        have moved := scratchLive
        rw [block0] at moved
        exact moved
      have oneLive : 0<(KeygenMakePrologue.projectionStart before).heap.size 1 :=
        pinned_one_live _ pinned
      have twoLive : 0<(KeygenMakePrologue.projectionStart before).heap.size 2 :=
        pinned_two_live _ pinned
      refine ⟨?_,?_,?_⟩
      · have fresh := KeygenMakeObjects.fresh_separate 0
          (KeygenMakePrologue.projectionStart before)
          (KeygenMakePrologue.declared before blocks) blocks exec (4 : Fin 6) (by omega) 0 zeroLive
        exact Ne.symm fresh
      · have fresh := KeygenMakeObjects.fresh_separate 0
          (KeygenMakePrologue.projectionStart before)
          (KeygenMakePrologue.declared before blocks) blocks exec (4 : Fin 6) (by omega) 1 oneLive
        exact Ne.symm fresh
      · have fresh := KeygenMakeObjects.fresh_separate 0
          (KeygenMakePrologue.projectionStart before)
          (KeygenMakePrologue.declared before blocks) blocks exec (4 : Fin 6) (by omega) 2 twoLive
        exact Ne.symm fresh
    refine ⟨facts.1,?_,?_,?_,tablesH,?_,materialBlocks,publicBlocks⟩
    · show KeygenPublicInputMaterial.Legal after.heap
        (KeygenMakeObjects.pointer blocks ⟨(0 : Fin 4).val,_⟩)
      exact legal_of_pointer after.heap blocks _ (by decide) (arrayShape _).2.2
    · show KeygenPublicInputMaterial.Legal after.heap
        (KeygenMakeObjects.pointer blocks ⟨(1 : Fin 4).val,_⟩)
      exact legal_of_pointer after.heap blocks _ (by decide) (arrayShape _).2.2
    · show KeygenPublicInputMaterial.Legal after.heap
        (KeygenMakeObjects.pointer blocks (4 : Fin 6))
      exact legal_of_pointer after.heap blocks (4 : Fin 6) (by decide) (arrayShape 4).2.2
    · exact ⟨scratchH,tablesH⟩

/-! ## 7. The certificate instantiation: globals, call material, snapshots -/

/-- The complete mandatory certificate instantiated at the actual caller
    call: its concrete pinned globals (the `FftGlobalScalars.environment` of
    `FftGlobalMemory.environment`, fixed by the `Pinned` field of the same
    call), the common call material (the 768-word gate trace and the good
    event stream of THIS call, shared by its prefix/gate/suffix), the stored
    leaf words, the caller frame, the source snapshots (the prefix/reverse
    snapshot package) and the bad-flag lifetime (dead after return). No
    certificate-correctness or acceptance input is used. -/
theorem cert_package_of_call (ctx : Context) (before after : State) (v : Value)
    (call : KeygenMakeCertCall.Call ctx before after v true)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (workspace : KeygenMakeCertMaterial.LegalWorkspace before ctx) :
    ∃ (args : Arguments) (gateTrace : List (BitVec 64))
      (events : List CertificateEffects.Event),
      KeygenMakeCertCall.CertBind before ctx args ∧
      CertificateFunctionSyntax.Bound ∧
      CertificateFunctionOutcome.StoredBounds args before.heap after.heap ∧
      gateTrace.length=768 ∧
      (∀ event∈events, CertificateEffects.Good event) ∧
      (∀ w : BitVec 32, ¬Load32 after.heap (C99Automatic32.pointer before.heap) w) ∧
      (∃ snapshot : CertificateFunctionWitness.Witness args before.heap after.heap
          gateTrace events true,
        StableBinaryByteView.flagRead (C99MemoryBridge.encode snapshot.edge)
          (CertificateFunctionWitness.layout args before.heap).bad=some 0) ∧
      ∃ (topState reverseState : CertificateEffects.State) (words : Fin 768 → BitVec 64),
        CertificateReverse.Snapshot (CertificateFunctionWitness.layout args before.heap)
          words topState ∧
        CertificateReverse.Snapshot (CertificateFunctionWitness.layout args before.heap)
          words reverseState := by
  cases call with
  | run args bind afterMem gateTrace events ret body v bit =>
    have profile := KeygenMakeCertCall.bind_callee_profile before ctx args bind dimensions
    have legal := workspace args bind
    have accepted := CertificateFunctionOutcome.accepted args FftGlobalMemory.environment
      before.heap afterMem gateTrace events profile legal body.2
    have reverse := CertificateFunctionOutcome.reverse_source args FftGlobalMemory.environment
      before.heap afterMem gateTrace events profile legal body.2
    obtain ⟨flagSnapshot,flag⟩ := accepted.2.2.2.2.2.2.2
    obtain ⟨_,topState,reverseState,words,first,second,_⟩ := reverse
    exact ⟨args,gateTrace,events,bind,accepted.1,accepted.2.1,accepted.2.2.2.2.1,
      accepted.2.2.2.2.2.2.1,accepted.2.2.2.1,⟨flagSnapshot,flag⟩,
      ⟨topState,reverseState,words,first,second⟩⟩

end FT1536.Source3.KeygenMakeStatementMachine
