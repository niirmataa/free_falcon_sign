import Source3.KeygenMakeWorkspaceRelocation
import Source3.KeygenMakeCertMaterial
import Source3.KeygenMkgm3Layout

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The workspace bridge discharged from source facts. The bridge equates the
   callee's block0 workspace model with the fpr cast of the general `fk->tmp`
   scratch descriptor. Relocation (module `KeygenMakeWorkspaceRelocation`)
   removes its block condition; the workspace-extent condition is exactly the
   reserved certificate workspace extent. This module assembles the caller
   binding `CertBind` from the caller cell bindings plus those source facts,
   so no bridge equality is an input. The certificate execution itself and
   its transport across the block relocation remain separate obligations;
   no certificate outcome is a premise here. -/
namespace FT1536.Source3.KeygenMakeWorkspaceBridge
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open KeygenSearchContext (Context)
open CertificateFunctionReference (Arguments)

/-! ## 1. Source facts for the workspace shape -/

/-- Allocation shape of the `fk->tmp` buffer at the sixth gate: the fpr cast
    spans exactly the reserved certificate workspace extent (286720 bytes,
    `35840` fpr words) and its first word is 8-aligned as required by the
    certificate frame. The extent is witnessed by the pinned `temp_size`
    reservation; deriving it from the enclosing allocation execution is the
    remaining composition obligation. -/
structure Shape (ctx : Context) : Prop where
  extent : KeygenMakeWorkspaceRelocation.extent ctx.scratch=286720
  aligned : ArrayPointer.offset ctx.scratch%8=0

/-- The caller cells read at the sixth gate: every `CertBind` component
    except the workspace bridge, which is derived from source facts. -/
structure Cells (s : State) (ctx : Context) (args : Arguments) : Prop where
  context : s.arrays "fk".toList=some ctx.object
  fCell : s.arrays "f".toList=some args.f
  gCell : s.arrays "g".toList=some args.g
  bigFCell : s.arrays "F".toList=some args.bigF
  bigGCell : s.arrays "G".toList=some args.bigG
  lognCell : s.locals "logn".toList=some (.uint32,some (.uint32 args.logn))
  terCell : s.locals "ter".toList=some (.uint32,some (.uint32 args.ter))
  tmpRead : KeygenSearchContext.ReadTmp ctx s ctx.scratch

theorem workspace_of_source (ctx : Context) (args : Arguments) (shape : Shape ctx)
    (base : args.base=ArrayPointer.offset ctx.scratch) (block0 : ctx.scratch.block=0) :
    CertificateAfterConversion.workspacePointer args.base 0=
      KeygenMakeCertCall.fprCast ctx.scratch := by
  rw [base]
  exact (KeygenMakeWorkspaceRelocation.bridge_iff (ArrayPointer.offset ctx.scratch) ctx.scratch).mpr
    ⟨block0,rfl,by rw [shape.extent]⟩

theorem cert_bind_of_source (s : State) (ctx : Context) (args : Arguments)
    (cells : Cells s ctx args) (shape : Shape ctx)
    (base : args.base=ArrayPointer.offset ctx.scratch) (block0 : ctx.scratch.block=0) :
    KeygenMakeCertCall.CertBind s ctx args :=
  { context := cells.context
    fCell := cells.fCell
    gCell := cells.gCell
    bigFCell := cells.bigFCell
    bigGCell := cells.bigGCell
    lognCell := cells.lognCell
    terCell := cells.terCell
    tmpRead := cells.tmpRead
    workspace := workspace_of_source ctx args shape base block0 }

/-! ## 2. Relocation of the caller binding -/

def swapState (b : Nat) (s : State) : State where
  heap := KeygenMakeWorkspaceRelocation.swap b s.heap
  locals := s.locals
  arrays := fun n => (s.arrays n).map (KeygenMakeWorkspaceRelocation.swapPtr b)
  globals := s.globals
  tables := fun n => (s.tables n).map (KeygenMakeWorkspaceRelocation.swapPtr b)

def relocateCtx (b : Nat) (ctx : Context) : Context where
  object := KeygenMakeWorkspaceRelocation.swapPtr b ctx.object
  scratch := KeygenMakeWorkspaceRelocation.swapPtr b ctx.scratch
  virtualBase := fun i => ctx.virtualBase (KeygenMakeWorkspaceRelocation.swapBlock b i)

def swapArgs (b : Nat) (args : Arguments) : Arguments where
  base := args.base
  f := KeygenMakeWorkspaceRelocation.swapPtr b args.f
  g := KeygenMakeWorkspaceRelocation.swapPtr b args.g
  bigF := KeygenMakeWorkspaceRelocation.swapPtr b args.bigF
  bigG := KeygenMakeWorkspaceRelocation.swapPtr b args.bigG
  logn := args.logn
  ter := args.ter

theorem field_relocated (b : Nat) (ctx : Context) (offset width : Nat) :
    KeygenSearchContext.field (relocateCtx b ctx) offset width=
      KeygenMakeWorkspaceRelocation.swapPtr b (KeygenSearchContext.field ctx offset width) := rfl

theorem pointerWord_relocated (b : Nat) (ctx : Context) :
    KeygenSearchContext.pointerWord (relocateCtx b ctx)=KeygenSearchContext.pointerWord ctx := by
  simp only [KeygenSearchContext.pointerWord,relocateCtx]
  rw [KeygenMakeWorkspaceRelocation.swapPtr_block,KeygenMakeWorkspaceRelocation.swapPtr_offset,
    KeygenMakeWorkspaceRelocation.swapBlock_self]

theorem bound_relocated (b : Nat) (s : State) (ctx : Context)
    (source : KeygenSearchContext.Bound s ctx) :
    KeygenSearchContext.Bound (swapState b s) (relocateCtx b ctx) := by
  simp only [KeygenSearchContext.Bound,swapState,relocateCtx]
  rw [source]
  rfl

theorem objectLegal_relocated (b : Nat) (s : State) (ctx : Context)
    (source : KeygenSearchContext.ObjectLegal s.heap ctx) :
    KeygenSearchContext.ObjectLegal (swapState b s).heap (relocateCtx b ctx) := by
  simp only [KeygenSearchContext.ObjectLegal,swapState,relocateCtx,
    KeygenMakeWorkspaceRelocation.swap_size,KeygenMakeWorkspaceRelocation.swapBlock_self,
    KeygenMakeWorkspaceRelocation.swapPtr_offset,KeygenMakeWorkspaceRelocation.swapPtr_block]
  exact source

theorem pointerLegal_relocated (b : Nat) (ctx : Context)
    (source : KeygenSearchContext.PointerLegal ctx) :
    KeygenSearchContext.PointerLegal (relocateCtx b ctx) := by
  simp only [KeygenSearchContext.PointerLegal,relocateCtx,
    KeygenMakeWorkspaceRelocation.swapPtr_block,
    KeygenMakeWorkspaceRelocation.swapPtr_base,KeygenMakeWorkspaceRelocation.swapPtr_count,
    KeygenMakeWorkspaceRelocation.swapPtr_elementBytes,KeygenMakeWorkspaceRelocation.swapPtr_index]
  rw [KeygenMakeWorkspaceRelocation.swapBlock_self]
  exact source

theorem readTmp_relocated (b : Nat) (ctx : Context) (s : State)
    (source : KeygenSearchContext.ReadTmp ctx s ctx.scratch) :
    KeygenSearchContext.ReadTmp (relocateCtx b ctx) (swapState b s) (relocateCtx b ctx).scratch := by
  cases source with
  | read binding legal pointer bytes =>
    have loads := (KeygenMakeWorkspaceRelocation.load64_swap b s.heap
      (KeygenSearchContext.field ctx 432 8) (KeygenSearchContext.pointerWord ctx)).1 bytes
    rw [← field_relocated b ctx 432 8,← pointerWord_relocated b ctx] at loads
    exact KeygenSearchContext.ReadTmp.read (bound_relocated b s ctx binding)
      (objectLegal_relocated b s ctx legal) (pointerLegal_relocated b ctx pointer) loads

theorem cells_relocated (b : Nat) (s : State) (ctx : Context) (args : Arguments)
    (cells : Cells s ctx args) : Cells (swapState b s) (relocateCtx b ctx) (swapArgs b args) := by
  refine ⟨?_,?_,?_,?_,?_,?_,?_,?_⟩
  · simp only [swapState,relocateCtx]
    rw [cells.context]
    rfl
  · simp only [swapState,swapArgs]
    rw [cells.fCell]
    rfl
  · simp only [swapState,swapArgs]
    rw [cells.gCell]
    rfl
  · simp only [swapState,swapArgs]
    rw [cells.bigFCell]
    rfl
  · simp only [swapState,swapArgs]
    rw [cells.bigGCell]
    rfl
  · simp only [swapState,swapArgs]
    exact cells.lognCell
  · simp only [swapState,swapArgs]
    exact cells.terCell
  · exact readTmp_relocated b ctx s cells.tmpRead

/-- The canonical relocation of the workspace: after moving the scratch
    block to the certificate model's block0, the caller cells bind a full
    `CertBind` with the workspace bridge DERIVED from the extent source
    fact alone. The block condition is discharged by relocation, not
    assumed. -/
theorem cert_bind_relocated (s : State) (ctx : Context) (args : Arguments)
    (cells : Cells s ctx args) (shape : Shape ctx)
    (base : args.base=ArrayPointer.offset ctx.scratch) :
    KeygenMakeCertCall.CertBind (swapState ctx.scratch.block s)
      (relocateCtx ctx.scratch.block ctx) (swapArgs ctx.scratch.block args) :=
  { context := (cells_relocated ctx.scratch.block s ctx args cells).context
    fCell := (cells_relocated ctx.scratch.block s ctx args cells).fCell
    gCell := (cells_relocated ctx.scratch.block s ctx args cells).gCell
    bigFCell := (cells_relocated ctx.scratch.block s ctx args cells).bigFCell
    bigGCell := (cells_relocated ctx.scratch.block s ctx args cells).bigGCell
    lognCell := (cells_relocated ctx.scratch.block s ctx args cells).lognCell
    terCell := (cells_relocated ctx.scratch.block s ctx args cells).terCell
    tmpRead := (cells_relocated ctx.scratch.block s ctx args cells).tmpRead
    workspace := by
      have derived := KeygenMakeWorkspaceRelocation.bridge_of_extent ctx.scratch shape.extent
      rw [← base] at derived
      simpa [swapArgs,relocateCtx] using derived }

/-! ## 3. The certificate frame legality from source facts -/

theorem legal_of_shape (s : State) (ctx : Context) (args : Arguments)
    (shape : Shape ctx) (scratchLegal : KeygenMkgm3Layout.Legal s.heap ctx.scratch)
    (block0 : ctx.scratch.block=0) (space : C99Automatic32.Space s.heap)
    (base : args.base=ArrayPointer.offset ctx.scratch) :
    CertificateFrameEntry.Legal args.base s.heap := by
  rw [base]
  have width := scratchLegal.1
  have extent := scratchLegal.2.2.2.1
  have writable := scratchLegal.2.2.2.2.2
  have shapeExtent := shape.extent
  dsimp [KeygenMakeWorkspaceRelocation.extent] at shapeExtent
  have indexBound : ctx.scratch.index≤ctx.scratch.count := by
    have bound := scratchLegal.2.2.1
    dsimp [KeygenMkgm3Layout.scratchWords] at bound
    omega
  have offsetBound : ArrayPointer.offset ctx.scratch≤
      ctx.scratch.base+ctx.scratch.elementBytes*ctx.scratch.count := by
    dsimp [ArrayPointer.offset]
    rw [width]
    omega
  refine ⟨shape.aligned,?_,?_,space⟩
  · rw [block0] at extent
    rw [width] at shapeExtent offsetBound
    dsimp [CertificateWorkspace.bytes]
    omega
  · rw [← block0]
    exact writable

theorem legalWorkspace_of_shape (s : State) (ctx : Context) (shape : Shape ctx)
    (scratchLegal : KeygenMkgm3Layout.Legal s.heap ctx.scratch)
    (block0 : ctx.scratch.block=0) (space : C99Automatic32.Space s.heap) :
    KeygenMakeCertMaterial.LegalWorkspace s ctx := by
  intro args bind
  have parts := (KeygenMakeWorkspaceRelocation.bridge_iff args.base ctx.scratch).mp bind.workspace
  exact legal_of_shape s ctx args shape scratchLegal block0 space parts.2.1

/-! ## 4. Accepted package consumption with the bridge discharged -/

theorem accepted_certificate_source (ctx : Context) (before after : State) (v : Value)
    (call : KeygenMakeCertCall.Call ctx before after v true)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (shape : Shape ctx) (scratchLegal : KeygenMkgm3Layout.Legal before.heap ctx.scratch)
    (block0 : ctx.scratch.block=0) (space : C99Automatic32.Space before.heap) :
    ∃ (args : CertificateFunctionReference.Arguments) (gateTrace : List (BitVec 64))
      (events : List CertificateEffects.Event),
      KeygenMakeCertCall.CertBind before ctx args ∧
      CertificateFunctionSyntax.Bound ∧
      CertificateFunctionOutcome.StoredBounds args before.heap after.heap ∧
      CertificateFunctionOutcome.CallerFrame args FftGlobalMemory.environment before.heap after.heap ∧
      (∀ w : BitVec 32, ¬Load32 after.heap (C99Automatic32.pointer before.heap) w) ∧
      gateTrace.length=768 ∧
      (∀ event∈events, CertificateEffects.Good event) :=
  KeygenMakeCertMaterial.accepted_certificate ctx before after v call dimensions
    (legalWorkspace_of_shape before ctx shape scratchLegal block0 space)

end FT1536.Source3.KeygenMakeWorkspaceBridge
