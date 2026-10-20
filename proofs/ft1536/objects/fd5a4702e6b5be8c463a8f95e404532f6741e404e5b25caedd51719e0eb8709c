import Source3.KeygenMakeSearchMaterial
import Source3.KeygenMakePublicCall
import Source3.KeygenMakeCertChronology

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Accepted certificate material and byte-level transport at the sixth gate.
   The accepted call DERIVES the pinned certificate package (bound syntax,
   stored leaf words, caller frame, dead bad word) at the actual caller call;
   no certificate-correctness or acceptance input is used. Foreign blocks of
   the coefficient/public arrays retain their bytes through every gate edge,
   which transports the SAME physical f/g/F/G and public h representations
   across certificate rejections and the accepted break. The workspace bridge
   (general scratch vs block0 model) remains the OPEN relocation obligation;
   block0 is derived from the bridge field, never assumed. -/
namespace FT1536.Source3.KeygenMakeCertMaterial
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)

/-- Layout legality of the certificate workspace inside the caller heap.
    This is the same kind of explicit local input the pinned accepted theorem
    consumes; it is not a certificate-correctness premise. -/
def LegalWorkspace (s : State) (ctx : Context) : Prop :=
  ∀ (args : CertificateFunctionReference.Arguments)
    (_bind : KeygenMakeCertCall.CertBind s ctx args),
    CertificateFrameEntry.Legal args.base s.heap

/-- The workspace bridge forces the scratch block to be the model's block0;
    this is derived from the bridge FIELD, which is the open relocation
    obligation, never an independent premise. -/
theorem workspace_scratch_block (s : State) (ctx : Context)
    (args : CertificateFunctionReference.Arguments) (bind : KeygenMakeCertCall.CertBind s ctx args) :
    ctx.scratch.block=0 := by
  have equal := congrArg ArrayPointer.block bind.workspace
  simp only [CertificateAfterConversion.workspacePointer,KeygenMakeCertCall.fprCast] at equal
  exact equal.symm

/- The M0 table-block inversion (blocks 1,2) and its consumption in a
   general call_same_block frame stay OPEN here: the ite inversion over the
   pinned `FftGlobalMemory.tables` char-list conditions was not closed with
   clean logs in this window. The byte-level transports above and the
   accepted package below are complete; see the sealed notes. -/

/-! ## 1. The accepted certificate package at the caller call -/

theorem accepted_certificate (ctx : Context) (before after : State) (v : Value)
    (call : KeygenMakeCertCall.Call ctx before after v true)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (workspace : LegalWorkspace before ctx) :
    ∃ (args : CertificateFunctionReference.Arguments) (gateTrace : List (BitVec 64))
      (events : List CertificateEffects.Event),
      KeygenMakeCertCall.CertBind before ctx args ∧
      CertificateFunctionSyntax.Bound ∧
      CertificateFunctionOutcome.StoredBounds args before.heap after.heap ∧
      CertificateFunctionOutcome.CallerFrame args FftGlobalMemory.environment before.heap after.heap ∧
      (∀ w : BitVec 32, ¬Load32 after.heap (C99Automatic32.pointer before.heap) w) ∧
      gateTrace.length=768 ∧
      (∀ event∈events, CertificateEffects.Good event) := by
  cases call with
  | run args bind afterMem gateTrace events ret body v bit =>
    have profile := KeygenMakeCertCall.bind_callee_profile before ctx args bind dimensions
    have package := CertificateFunctionOutcome.accepted args FftGlobalMemory.environment
      before.heap afterMem gateTrace events profile (workspace args bind) body.2
    exact ⟨args,gateTrace,events,bind,package.1,package.2.1,package.2.2.1,
      package.2.2.2.1,package.2.2.2.2.1,package.2.2.2.2.2.2.1⟩

/-! ## 2. Byte transport of the material representations -/

theorem load16_same (before after : Memory) (p : ArrayPointer) (w : BitVec 16)
    (same : ShakeExtractFrame.SameBlock before after p.block)
    (load : C99NarrowReads.Load16 before p w) : C99NarrowReads.Load16 after p w := by
  cases load with
  | load bytes legal width values =>
    refine .load after p bytes ?_ width (fun i => (same.2.2 _).trans (values i))
    obtain ⟨elementBytes,aligned,inside,extent,allocatedBound⟩ := legal
    exact ⟨elementBytes,aligned,inside,by rw [same.1]; exact extent,by rw [same.1]; exact allocatedBound⟩

theorem represents_same (before after : Memory) (p : ArrayPointer) (v : Geometry.Vec)
    (same : ShakeExtractFrame.SameBlock before after p.block)
    (material : KeygenMaterial.Represents before p v) : KeygenMaterial.Represents after p v :=
  KeygenSamplerFrame.represents before after p v same material

theorem cell_same (before after : Memory) (p : ArrayPointer) (i : Nat) (z : KeygenPublicAlgebra.R)
    (same : ShakeExtractFrame.SameBlock before after p.block)
    (cell : KeygenPublicInputCells.Cell before p i z) :
    KeygenPublicInputCells.Cell after p i z := by
  obtain ⟨w,load,bound,equal⟩ := cell
  refine ⟨w,?_,bound,equal⟩
  cases load with
  | load bytes legal width values =>
    refine .load after (KeygenSmallOutput.element p i) bytes ?_ width
      (fun j => (same.2.2 _).trans (values j))
    obtain ⟨elementBytes,aligned,inside,extent,allocatedBound⟩ := legal
    exact ⟨elementBytes,aligned,inside,by rw [same.1]; exact extent,by rw [same.1]; exact allocatedBound⟩

theorem public_represents_same (before after : Memory) (p : ArrayPointer) (v : Relation.Rq)
    (same : ShakeExtractFrame.SameBlock before after p.block)
    (material : KeygenPublicNormalizePolynomial.Represents before p v) :
    KeygenPublicNormalizePolynomial.Represents after p v := by
  intro i
  exact ⟨cell_same before after p i.val _ same (material i).1,
    cell_same before after p (i.val+768) _ same (material i).2⟩

/-! ## 3. The certificate call frame on foreign blocks -/

theorem leave_shape (args : CertificateFunctionReference.Arguments)
    (environment : CertificateFunctionReference.Environment) (caller after : Memory)
    (gateTrace : List (BitVec 64)) (events : List CertificateEffects.Event) (ret : Bool)
    (source : CertificateFunctionReference.Exec args environment caller after gateTrace events ret) :
    after.size=caller.size ∧ after.writable=caller.writable := by
  cases source <;> exact ⟨rfl,rfl⟩

theorem leave_bytes (args : CertificateFunctionReference.Arguments)
    (environment : CertificateFunctionReference.Environment) (caller after : Memory)
    (gateTrace : List (BitVec 64)) (events : List CertificateEffects.Event) (ret : Bool)
    (source : CertificateFunctionReference.Exec args environment caller after gateTrace events ret)
    (block offset : Nat) (outside : ¬offset<caller.size block) :
    after.bytes block offset=caller.bytes block offset := by
  cases source <;> simp [C99Automatic32.leave,outside]

end FT1536.Source3.KeygenMakeCertMaterial
