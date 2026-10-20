import Source3.KeygenMakeWorkspaceBridge
import Source3.KeygenMakeWorkspaceExtent

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The workspace `Shape` extracted from the enclosing allocation execution:
   the pinned `fk->tmp_len = temp_size(logn, ternary);` store of the exact
   reservation value and the pinned `fk->tmp = malloc(fk->tmp_len);` binding
   of a fresh block of exactly those bytes. The reservation arithmetic is the
   exact mirror of module `KeygenMakeWorkspaceExtent`; the malloc descriptor
   is the block-model scratch of the reserved extent. From the executed
   binding the extent/alignment `Shape` facts and the scratch legality frame
   are DERIVED, so the accepted-package consumption takes no `Shape`, no
   scratch-legality and (after relocation) no scratch-block input. Residual
   gaps are named, not assumed: executing `temp_size` and `falcon_keygen_new`
   through the C statement machine, the member-read `ReadTmp` tie at gate
   time, and the certificate `Exec` transport across the block relocation
   remain open. The pinned source comment at the fpr-cast site explicitly
   relies on the malloc alignment; the block allocation model realizes it.
   No certificate outcome is a premise. -/
namespace FT1536.Source3.KeygenMakeWorkspaceAllocation
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open KeygenSearchContext (Context)
open KeygenMakeWorkspaceBridge (Shape)

/-! ## 1. Pinned source shapes of the enclosing allocation -/

theorem creation_source : (Pinned.keygenLines.drop 5146).take 4=
    ["falcon_keygen *\n","falcon_keygen_new(unsigned logn, int ternary)\n",
      "{\n","\tfalcon_keygen *fk;\n"] := by decide
theorem fk_object_allocation : (Pinned.keygenLines.drop 5163).take 2=
    ["\tfk = malloc(sizeof *fk);\n","\tif (fk == NULL) {\n"] := by decide
theorem profile_stores : (Pinned.keygenLines.drop 5167).take 5=
    ["\tfk->logn = logn;\n","\tfk->ternary = ternary;\n","\tshake_init(&fk->rng, 512);\n",
      "\tfk->seeded = 0;\n","\tfk->flipped = 0;\n"] := by decide
theorem scratch_binding : (Pinned.keygenLines.drop 5173).take 9=
    ["\tfk->tmp_len = temp_size(logn, ternary);\n","#if MEMCHECK\n",
      "\tfk->tmp = malloc(fk->tmp_len + sizeof MEMCHECK_MARK);\n","#else\n",
      "\tfk->tmp = malloc(fk->tmp_len);\n","#endif\n","\tif (fk->tmp == NULL) {\n",
      "\t\tfree(fk);\n","\t\treturn NULL;\n"] := by decide
theorem alignment_source : (Pinned.keygenLines.drop 6171).take 2=
    ["\t * source array fk->tmp was obtained with malloc(), and is thus\n",
      "\t * already aligned).\n"] := by decide

/-! ## 2. The reservation value stored in `fk->tmp_len` -/

/-- The value `temp_size(10,1)` computes and `fk->tmp_len` stores at the M0
    inputs: the fold maximum of the pinned candidate mirror. -/
def tempSizeBytes : Nat := KeygenMakeWorkspaceExtent.candidates.foldl max 0

theorem tempSize_exact : tempSizeBytes=286720 :=
  KeygenMakeWorkspaceExtent.candidates_fold_max.trans KeygenMakeWorkspaceExtent.cert_candidate_value
theorem tempSize_workspace : tempSizeBytes=CertificateWorkspace.bytes :=
  KeygenMakeWorkspaceExtent.reservation_matches_workspace
theorem tempSize_bound : tempSizeBytes<2^64 := by
  rw [tempSize_exact]
  decide

/-! ## 3. The malloc scratch descriptor -/

/-- Word count of the `uint32_t *tmp` view of the reserved workspace. -/
def scratchCount : Nat := 71680

/-- The scratch descriptor the pinned malloc binding returns: a fresh block
    of exactly `tempSizeBytes` bytes viewed as `uint32_t` words. -/
def scratchOf (block : Nat) : ArrayPointer := ⟨block,0,scratchCount,4,0⟩

theorem scratchCount_value : 4*scratchCount=286720 := by decide
theorem scratchCount_temp : 4*scratchCount=tempSizeBytes :=
  scratchCount_value.trans tempSize_exact.symm
theorem scratch_fit : 0+KeygenMkgm3Layout.scratchWords≤scratchCount := by decide
theorem scratch_count (block : Nat) : (scratchOf block).count=scratchCount := rfl
theorem scratch_offset (block : Nat) : ArrayPointer.offset (scratchOf block)=0 := rfl
theorem scratch_aligned (block : Nat) : ArrayPointer.offset (scratchOf block)%8=0 := rfl
theorem scratch_extent (block : Nat) :
    KeygenMakeWorkspaceRelocation.extent (scratchOf block)=tempSizeBytes := by
  have words := scratchCount_temp
  show 0+4*scratchCount-(0+4*0)=tempSizeBytes
  omega

/-! ## 4. The allocation execution of the binding -/

/-- The executed `fk->tmp_len`/`fk->tmp` allocation binding of the enclosing
    `falcon_keygen_new` at the M0 reservation value: the pinned `tmp_len`
    member store of the exact reservation, the pinned `malloc` of a fresh
    block of exactly those bytes, and the pointer store into the `tmp`
    member. The descriptor is the block-model scratch of that block. -/
inductive Binding (ctx : Context) (before : Memory) : Memory → Prop where
  | run (block : Nat) (middle stored : Memory)
      (scratch : ctx.scratch=scratchOf block)
      (tmpLen : Store64 before (KeygenSearchContext.field ctx 440 8)
        (BitVec.ofNat 64 tempSizeBytes) middle)
      (fresh : KeygenRngSource.Fresh middle block)
      (allocated : stored=KeygenMakeObjects.allocated middle block tempSizeBytes)
      (tmp : Store64 stored (KeygenSearchContext.field ctx 432 8)
        (KeygenSearchContext.pointerWord ctx) after) :
      Binding ctx before after

theorem binding_shape {ctx : Context} {before after : Memory}
    (source : Binding ctx before after) : Shape ctx := by
  cases source with
  | run block middle stored scratch tmpLen fresh allocated tmp =>
    refine ⟨?_,?_⟩
    · rw [scratch]
      exact (scratch_extent block).trans tempSize_exact
    · rw [scratch]
      exact scratch_aligned block

theorem binding_legal {ctx : Context} {before after : Memory}
    (source : Binding ctx before after) :
    KeygenMkgm3Layout.Legal after ctx.scratch := by
  cases source with
  | run block middle stored scratch tmpLen fresh allocated tmp =>
    obtain ⟨allocFits,width,writable,keepSize,keepWritable,bytes,frame⟩ := tmp
    have sizeBlock : after.size block=tempSizeBytes := by
      rw [keepSize,allocated]
      simp [KeygenMakeObjects.allocated]
    have writableBlock : after.writable block=true := by
      rw [keepWritable,allocated]
      simp [KeygenMakeObjects.allocated]
    rw [scratch]
    show (scratchOf block).elementBytes=4 ∧ _ ∧ _ ∧ _ ∧ _ ∧ _
    refine ⟨rfl,?_,?_,?_,?_,?_⟩
    · exact Nat.zero_mod 4
    · exact scratch_fit
    · have words := scratchCount_temp
      dsimp [scratchOf]
      rw [sizeBlock]
      omega
    · have bounded := tempSize_bound
      dsimp [scratchOf]
      rw [sizeBlock]
      exact bounded
    · dsimp [scratchOf]
      rw [writableBlock]

theorem binding_tmp_load {ctx : Context} {before after : Memory}
    (source : Binding ctx before after) :
    Load64 after (KeygenSearchContext.field ctx 432 8)
      (KeygenSearchContext.pointerWord ctx) := by
  cases source with
  | run block middle stored scratch tmpLen fresh allocated tmp =>
    obtain ⟨allocFits,width,writable,keepSize,keepWritable,bytes,frame⟩ := tmp
    have he : le64 (byte64 (KeygenSearchContext.pointerWord ctx))=
        KeygenSearchContext.pointerWord ctx := B20.Word.LE.join_byteOf _
    have hl : Load64 after (KeygenSearchContext.field ctx 432 8)
        (le64 (byte64 (KeygenSearchContext.pointerWord ctx))) := by
      apply Load64.load after (KeygenSearchContext.field ctx 432 8)
        (byte64 (KeygenSearchContext.pointerWord ctx))
      · have ha := allocFits
        simpa only [C99MemoryReference.Allocated,keepSize] using ha
      · exact width
      · intro i
        exact bytes i
    rw [he] at hl
    exact hl

/-- The gate-time member read of the bound scratch pointer: the `ReadTmp`
    bytes premise follows from the executed binding when the caller cells
    and the fk object legality hold at the gate. -/
theorem readTmp_of_binding (ctx : Context) (entered gate : State)
    (source : Binding ctx entered.heap gate.heap)
    (bound : KeygenSearchContext.Bound gate ctx)
    (legal : KeygenSearchContext.ObjectLegal gate.heap ctx)
    (pointer : KeygenSearchContext.PointerLegal ctx) :
    KeygenSearchContext.ReadTmp ctx gate ctx.scratch :=
  KeygenSearchContext.ReadTmp.read bound legal pointer (binding_tmp_load source)

/-! ## 5. Relocation composition with the derived shape -/

theorem shape_relocated (b : Nat) (ctx : Context) (shape : Shape ctx) :
    Shape (KeygenMakeWorkspaceBridge.relocateCtx b ctx) := by
  refine ⟨?_,?_⟩
  · have source := shape.extent
    simpa only [KeygenMakeWorkspaceBridge.relocateCtx,
      KeygenMakeWorkspaceRelocation.extent_swapPtr] using source
  · have source := shape.aligned
    simpa only [KeygenMakeWorkspaceBridge.relocateCtx,
      KeygenMakeWorkspaceRelocation.swapPtr_offset] using source

theorem legal_relocated (b : Nat) (ctx : Context) (before : Memory)
    (legal : KeygenMkgm3Layout.Legal before ctx.scratch) :
    KeygenMkgm3Layout.Legal (KeygenMakeWorkspaceRelocation.swap b before)
      (KeygenMakeWorkspaceRelocation.swapPtr b ctx.scratch) := by
  obtain ⟨width,aligned,count,fit,bounded,writable⟩ := legal
  show (KeygenMakeWorkspaceRelocation.swapPtr b ctx.scratch).elementBytes=4 ∧ _ ∧ _ ∧ _ ∧ _ ∧ _
  refine ⟨?_,?_,?_,?_,?_,?_⟩
  · rw [KeygenMakeWorkspaceRelocation.swapPtr_elementBytes]
    exact width
  · rw [KeygenMakeWorkspaceRelocation.swapPtr_base]
    exact aligned
  · rw [KeygenMakeWorkspaceRelocation.swapPtr_index,KeygenMakeWorkspaceRelocation.swapPtr_count]
    exact count
  · rw [KeygenMakeWorkspaceRelocation.swap_size,KeygenMakeWorkspaceRelocation.swapPtr_block,
      KeygenMakeWorkspaceRelocation.swapBlock_self,KeygenMakeWorkspaceRelocation.swapPtr_base,
      KeygenMakeWorkspaceRelocation.swapPtr_count]
    exact fit
  · rw [KeygenMakeWorkspaceRelocation.swap_size,KeygenMakeWorkspaceRelocation.swapPtr_block,
      KeygenMakeWorkspaceRelocation.swapBlock_self]
    exact bounded
  · rw [KeygenMakeWorkspaceRelocation.swap_writable,KeygenMakeWorkspaceRelocation.swapPtr_block,
      KeygenMakeWorkspaceRelocation.swapBlock_self]
    exact writable

/-! ## 6. Composition with the accepted-package consumption -/

/-- The accepted-package facts consumed from the pinned certificate theorem:
    the caller binding, the syntax bound, stored bounds and caller frame, the
    dead automatic flag, the 768-word gate trace and good events. -/
def AcceptedPackage (ctx : Context) (before after : State) : Prop :=
  ∃ (args : CertificateFunctionReference.Arguments) (gateTrace : List (BitVec 64))
    (events : List CertificateEffects.Event),
    KeygenMakeCertCall.CertBind before ctx args ∧
    CertificateFunctionSyntax.Bound ∧
    CertificateFunctionOutcome.StoredBounds args before.heap after.heap ∧
    CertificateFunctionOutcome.CallerFrame args FftGlobalMemory.environment before.heap after.heap ∧
    (∀ w : BitVec 32, ¬Load32 after.heap (C99Automatic32.pointer before.heap) w) ∧
    gateTrace.length=768 ∧
    (∀ event∈events, CertificateEffects.Good event)

theorem cert_bind_of_allocation (s entered : State) (ctx : Context)
    (args : CertificateFunctionReference.Arguments)
    (cells : KeygenMakeWorkspaceBridge.Cells s ctx args)
    (binding : Binding ctx entered.heap s.heap)
    (base : args.base=ArrayPointer.offset ctx.scratch) (block0 : ctx.scratch.block=0) :
    KeygenMakeCertCall.CertBind s ctx args :=
  KeygenMakeWorkspaceBridge.cert_bind_of_source s ctx args cells (binding_shape binding) base block0

theorem cert_bind_relocated_of_allocation (s entered : State) (ctx : Context)
    (args : CertificateFunctionReference.Arguments)
    (cells : KeygenMakeWorkspaceBridge.Cells s ctx args)
    (binding : Binding ctx entered.heap s.heap)
    (base : args.base=ArrayPointer.offset ctx.scratch) :
    KeygenMakeCertCall.CertBind (KeygenMakeWorkspaceBridge.swapState ctx.scratch.block s)
      (KeygenMakeWorkspaceBridge.relocateCtx ctx.scratch.block ctx)
      (KeygenMakeWorkspaceBridge.swapArgs ctx.scratch.block args) :=
  KeygenMakeWorkspaceBridge.cert_bind_relocated s ctx args cells (binding_shape binding) base

theorem legalWorkspace_of_allocation (s entered : State) (ctx : Context)
    (binding : Binding ctx entered.heap s.heap)
    (block0 : ctx.scratch.block=0) (space : C99Automatic32.Space s.heap) :
    KeygenMakeCertMaterial.LegalWorkspace s ctx :=
  KeygenMakeWorkspaceBridge.legalWorkspace_of_shape s ctx (binding_shape binding)
    (binding_legal binding) block0 space

theorem accepted_certificate_of_allocation (ctx : Context) (entered before after : State)
    (v : Value) (binding : Binding ctx entered.heap before.heap)
    (call : KeygenMakeCertCall.Call ctx before after v true)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (block0 : ctx.scratch.block=0) (space : C99Automatic32.Space before.heap) :
    AcceptedPackage ctx before after :=
  KeygenMakeWorkspaceBridge.accepted_certificate_source ctx before after v call dimensions
    (binding_shape binding) (binding_legal binding) block0 space

/-- The accepted-package consumption in the canonical relocated world: the
    scratch block comes from the relocation theorem and the shape/legality
    from the allocation execution, so neither is an input. -/
theorem accepted_certificate_relocated_of_allocation (ctx : Context) (entered before after : State)
    (v : Value) (binding : Binding ctx entered.heap before.heap)
    (call : KeygenMakeCertCall.Call (KeygenMakeWorkspaceBridge.relocateCtx ctx.scratch.block ctx)
      (KeygenMakeWorkspaceBridge.swapState ctx.scratch.block before)
      (KeygenMakeWorkspaceBridge.swapState ctx.scratch.block after) v true)
    (dimensions : KeygenMakeSearchPrefix.Dimensions
      (KeygenMakeWorkspaceBridge.swapState ctx.scratch.block before))
    (space : C99Automatic32.Space
      (KeygenMakeWorkspaceBridge.swapState ctx.scratch.block before).heap) :
    AcceptedPackage (KeygenMakeWorkspaceBridge.relocateCtx ctx.scratch.block ctx)
      (KeygenMakeWorkspaceBridge.swapState ctx.scratch.block before)
      (KeygenMakeWorkspaceBridge.swapState ctx.scratch.block after) :=
  KeygenMakeWorkspaceBridge.accepted_certificate_source
    (KeygenMakeWorkspaceBridge.relocateCtx ctx.scratch.block ctx)
    (KeygenMakeWorkspaceBridge.swapState ctx.scratch.block before)
    (KeygenMakeWorkspaceBridge.swapState ctx.scratch.block after) v call dimensions
    (shape_relocated ctx.scratch.block ctx (binding_shape binding))
    (legal_relocated ctx.scratch.block ctx before.heap (binding_legal binding))
    (KeygenMakeWorkspaceRelocation.relocated_scratch_block ctx.scratch) space

end FT1536.Source3.KeygenMakeWorkspaceAllocation
