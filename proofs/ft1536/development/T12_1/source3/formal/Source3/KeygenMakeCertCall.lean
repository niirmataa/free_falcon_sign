import Source3.KeygenMakeSearchPrefix
import Source3.CertificateM0Environment

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The sixth (mandatory leaf-certificate) gate at the actual caller tail.
   The gate executes the pinned certificate body at its exact interface; no
   certificate acceptance or correctness is a constructor input. Its pinned
   workspace model is block0-based: the bridge from the caller's general
   scratch descriptor is an EXPLICIT binding field, and deriving it from
   source relocation remains OPEN (no scratch-block0 fact is a premise of
   any theorem below). A falsy callee return retries the loop; a truthy
   return is the final accepted break. The profile-false branch skips the
   call and reaches the same final break; under the derived profile the
   call is mandatory. -/
namespace FT1536.Source3.KeygenMakeCertCall
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

/-! ## 1. Fixed source shapes of the sixth gate and the final break -/

theorem tail_source : KeygenMakeProgram.attemptParts.drop 1=KeygenMakeProgram.expectedTail :=
  KeygenMakeProgram.actual_attempt_tail
theorem gate_position : KeygenMakeProgram.get KeygenMakeProgram.expectedTail 2=
    KeygenMakeProgram.certificateGate := by decide +kernel
theorem break_position : KeygenMakeProgram.get KeygenMakeProgram.expectedTail 3=
    (.breakLoop : KeygenMakeSyntax.Stmt) := by decide +kernel
theorem gate_shape : KeygenMakeProgram.certificateGate=
    .branch KeygenMakeProgram.profileTest
      (.scope (.seq (KeygenMakeProgram.failCall .certificate KeygenMakeProgram.certificateArgs) .skip))
      .skip := rfl
theorem profile_shape : KeygenMakeProgram.profileTest=
    .binary .land (.binary .land (KeygenMakeProgram.varExpr "ter")
        (.binary .eq (KeygenMakeProgram.varExpr "logn") (KeygenMakeProgram.number 10)))
      (.binary .eq (KeygenMakeProgram.varExpr "n") (KeygenMakeProgram.number 1536)) := rfl
theorem args_shape : KeygenMakeProgram.certificateArgs=
    [.cast (.pointer .fpr) (.member (KeygenMakeProgram.varExpr "fk") "tmp".toList),
      KeygenMakeProgram.varExpr "f",KeygenMakeProgram.varExpr "g",
      KeygenMakeProgram.varExpr "F",KeygenMakeProgram.varExpr "G",
      KeygenMakeProgram.varExpr "logn",KeygenMakeProgram.varExpr "ter"] := rfl

/-! ## 2. Caller-side argument binding for the certificate call -/

/-- The source `(fpr *)` cast of the uint32 scratch view: the same first
    address, fpr element width, spanning the remaining buffer bytes. -/
def fprCast (p : ArrayPointer) : ArrayPointer :=
  ⟨p.block,p.offset,(p.base+p.elementBytes*p.count-p.offset)/8,8,0⟩

theorem fprCast_offset (p : ArrayPointer) : (fprCast p).offset=p.offset := by
  simp [fprCast,ArrayPointer.offset]

/-- The caller cells read by the seven certificate arguments, plus the
    workspace bridge. The bridge is the OPEN relocation obligation: the
    callee's pinned model binds `tmp` to the block0 view
    `CertificateAfterConversion.workspacePointer args.base 0`, and relating
    that view to the actual scratch descriptor is not derived here. -/
structure CertBind (s : State) (ctx : Context)
    (args : CertificateFunctionReference.Arguments) : Prop where
  context : s.arrays "fk".toList=some ctx.object
  fCell : s.arrays "f".toList=some args.f
  gCell : s.arrays "g".toList=some args.g
  bigFCell : s.arrays "F".toList=some args.bigF
  bigGCell : s.arrays "G".toList=some args.bigG
  lognCell : s.locals "logn".toList=some (.uint32,some (.uint32 args.logn))
  terCell : s.locals "ter".toList=some (.uint32,some (.uint32 args.ter))
  tmpRead : KeygenSearchContext.ReadTmp ctx s ctx.scratch
  workspace : CertificateAfterConversion.workspacePointer args.base 0=fprCast ctx.scratch

/-- The gate guard cells at the sixth gate: ter truthy, logn=10, n=1536. -/
def Profile (s : State) : Prop :=
  s.locals "ter".toList=some (.uint32,some (.uint32 1)) ∧
  s.locals "logn".toList=some (.uint32,some (.uint32 10)) ∧
  s.locals "n".toList=some (.uint64,some (.uint64 1536))

theorem bind_profile (s : State) (ctx : Context) (args : CertificateFunctionReference.Arguments)
    (bind : CertBind s ctx args) (dimensions : KeygenMakeSearchPrefix.Dimensions s) :
    args.logn=10 ∧ args.ter=1 := by
  have hl := Option.some.inj (bind.lognCell.symm.trans dimensions.2.1)
  have ht := Option.some.inj (bind.terCell.symm.trans dimensions.2.2)
  exact ⟨by simpa using hl,by simpa using ht⟩

theorem bind_callee_profile (s : State) (ctx : Context) (args : CertificateFunctionReference.Arguments)
    (bind : CertBind s ctx args) (dimensions : KeygenMakeSearchPrefix.Dimensions s) :
    CertificateFunctionReference.Profile args :=
  bind_profile s ctx args bind dimensions

/-- The sixth-gate guard cells follow from the derived dimensions frame. -/
theorem profile_of_dimensions (s : State) (dimensions : KeygenMakeSearchPrefix.Dimensions s) :
    Profile s :=
  ⟨dimensions.2.2,dimensions.2.1,dimensions.1⟩

/-! ## 3. The certificate call and its gate edges -/

/-- The certificate call at the caller site: the source argument binding,
    the pinned certificate body executed on the caller heap and the returned
    boolean. The body relation is the fixed certificate execution; no
    acceptance, NTRU or certificate-correctness fact is an input. -/
inductive Call (ctx : Context) (before : State) : State → Value → Bool → Prop where
  | run (args : CertificateFunctionReference.Arguments) (bind : CertBind before ctx args)
      (after : Memory) (gateTrace : List (BitVec 64)) (events : List CertificateEffects.Event)
      (ret : Bool) (body : CertificateM0Environment.Exec args before.heap after gateTrace events ret)
      (v : Value) (bit : (ret=true ↔ v.integer≠0)) :
      Call ctx before {before with heap := after} v ret

theorem call_cells (ctx : Context) (before after : State) (v : Value) (ret : Bool)
    (source : Call ctx before after v ret) :
    after.locals=before.locals ∧ after.arrays=before.arrays ∧ after.tables=before.tables := by
  cases source
  exact ⟨rfl,rfl,rfl⟩
theorem call_bit (ctx : Context) (before after : State) (v : Value) (ret : Bool)
    (source : Call ctx before after v ret) : (ret=true ↔ v.integer≠0) := by
  cases source with
  | run args bind after gateTrace events ret body v bit => exact bit

inductive CertificateGate (ctx : Context) (before : State) : Result → Prop where
  | rejected (after : State) (v : Value) (call : Call ctx before after v false) :
      CertificateGate ctx before ⟨after,.continueLoop⟩
  | accepted (after : State) (v : Value) (call : Call ctx before after v true) :
      CertificateGate ctx before ⟨after,.breakLoop⟩
  | unprofiled (noProfile : ¬Profile before) :
      CertificateGate ctx before ⟨before,.breakLoop⟩

theorem gate_cells (ctx : Context) (before : State) (out : Result)
    (source : CertificateGate ctx before out) :
    out.state.locals=before.locals ∧ out.state.arrays=before.arrays ∧ out.state.tables=before.tables := by
  cases source with
  | rejected after v call | accepted after v call =>
    exact call_cells ctx before after v _ call
  | unprofiled noProfile => exact ⟨rfl,rfl,rfl⟩
theorem gate_flow (ctx : Context) (before : State) (out : Result)
    (source : CertificateGate ctx before out) :
    out.flow=.continueLoop ∨ out.flow=.breakLoop := by
  cases source with
  | rejected after v call => exact Or.inl rfl
  | accepted after v call => exact Or.inr rfl
  | unprofiled noProfile => exact Or.inr rfl

/-- Under the caller profile the gate is MANDATORY: an accepted break is the
    truthy certificate return, never the profile-false skip. -/
theorem accepted_break_requires_call (ctx : Context) (before : State) (out : Result)
    (source : CertificateGate ctx before out) (profile : Profile before)
    (accepted : out.flow=.breakLoop) :
    ∃ after v, Call ctx before after v true ∧ out=⟨after,.breakLoop⟩ := by
  cases source with
  | rejected after v call => cases accepted
  | accepted after v call => exact ⟨after,v,call,rfl⟩
  | unprofiled noProfile => exact (noProfile profile).elim

/-- The retry edge is a certificate rejection with its call executed. -/
theorem retry_requires_call (ctx : Context) (before : State) (out : Result)
    (source : CertificateGate ctx before out) (profile : Profile before)
    (rejected : out.flow=.continueLoop) :
    ∃ after v, Call ctx before after v false ∧ out=⟨after,.continueLoop⟩ := by
  cases source with
  | rejected after v call => exact ⟨after,v,call,rfl⟩
  | accepted after v call => cases rejected
  | unprofiled noProfile => exact (noProfile profile).elim

/-- No normal-flow fallthrough past the final break. -/
theorem gate_no_normal (ctx : Context) (before : State) (out : Result)
    (source : CertificateGate ctx before out) : out.flow≠.normal := by
  intro bad
  cases source with
  | rejected after v call => cases bad
  | accepted after v call => cases bad
  | unprofiled noProfile => cases bad

end FT1536.Source3.KeygenMakeCertCall
