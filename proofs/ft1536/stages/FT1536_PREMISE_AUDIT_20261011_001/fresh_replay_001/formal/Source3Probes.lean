import AllSource3
import Mathlib.Data.Fintype.Pigeonhole

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.PremiseAudit
open Source3
open C99ArrayReference (State)
open C99MemoryReference
open KeygenMakeInvocation

theorem no_virtual_legal (vb : Nat → Nat) : ¬VirtualLegal vb := by
  intro h
  apply not_injective_infinite_finite (fun n : Nat => (⟨vb n,h.bounded n⟩ : Fin (2^64)))
  intro a b equal
  exact h.distinct a b (congrArg Fin.val equal)

theorem invocation_only_failure (env : Env) (caller : State)
    (events : List KeygenEntropySource.Event) (out : C99ProcedureReference.Result)
    (source : Invocation env caller events out) :
    out.flow = .returned (some (.int32 0)) := by
  cases source with
  | encoded bound after loopOut attempts tailOut binding readyPrefix loop succeeded cells legal tail =>
    exact (no_virtual_legal env.vb legal).elim
  | capped bound after loopOut attempts binding readyPrefix loop aborted =>
    rw [KeygenMakeLifetime.close_flow,aborted]
    rfl

theorem no_successful_invocation (env : Env) (caller : State)
    (events : List KeygenEntropySource.Event) (out : C99ProcedureReference.Result)
    (source : Invocation env caller events out) :
    out.flow ≠ .returned (some (.int32 1)) := by
  rw [invocation_only_failure env caller events out source]
  decide

def emptyMemory : Memory := ⟨fun _ _ => none,fun _ => 0,fun _ => false⟩
def emptyState : State := ⟨emptyMemory,fun _ => none,fun _ => none,fun _ => none,fun _ => none⟩

theorem no_all_state_dimensions : ¬(∀ s : State, KeygenMakeSearchPrefix.Dimensions s) := by
  intro h
  have impossible := (h emptyState).2.1
  cases impossible

def dimensionLocals : C99ScalarReference.Env :=
  C99ScalarReference.set
    (C99ScalarReference.set
      (C99ScalarReference.set emptyState.locals "n".toList (.uint64,some (.uint64 1536)))
      "logn".toList (.uint32,some (.uint32 10)))
    "ter".toList (.uint32,some (.uint32 1))
def dimensionState : State := {emptyState with locals := dimensionLocals}

theorem dimensions_inhabited : KeygenMakeSearchPrefix.Dimensions dimensionState := by
  unfold KeygenMakeSearchPrefix.Dimensions C99CountedWords.Limit dimensionState dimensionLocals C99ScalarReference.set
  decide +kernel

def readonly (s : State) : State := {s with heap := {s.heap with writable := fun _ => false}}

theorem load64_readonly (heap : Memory) (p : ArrayPointer) (v : BitVec 64)
    (h : Load64 heap p v) : Load64 {heap with writable := fun _ => false} p v := by
  cases h with
  | load bytes allocated typeSize initialized =>
    exact .load _ _ bytes allocated typeSize initialized

theorem certbind_readonly (s : State) (ctx : KeygenSearchContext.Context)
    (args : CertificateFunctionReference.Arguments)
    (h : KeygenMakeCertCall.CertBind s ctx args) :
    KeygenMakeCertCall.CertBind (readonly s) ctx args := by
  refine ⟨h.context,h.fCell,h.gCell,h.bigFCell,h.bigGCell,h.lognCell,h.terCell,?_,h.workspace⟩
  cases h.tmpRead with
  | read binding legal pointer bytes =>
    refine .read binding legal pointer ?_
    exact load64_readonly s.heap _ _ bytes

theorem all_workspace_iff_no_binding (ctx : KeygenSearchContext.Context) :
    (∀ s : State, KeygenMakeCertMaterial.LegalWorkspace s ctx) ↔
    (∀ s args, ¬KeygenMakeCertCall.CertBind s ctx args) := by
  constructor
  · intro all s args binding
    have impossible := (all (readonly s) args (certbind_readonly s ctx args binding)).writable
    cases impossible
  · intro absent s args binding
    exact (absent s args binding).elim

theorem all_workspace_excludes_call (ctx : KeygenSearchContext.Context)
    (all : ∀ s : State, KeygenMakeCertMaterial.LegalWorkspace s ctx)
    (before after : State) (v : C99IntegerReference.Value) (ret : Bool) :
    ¬KeygenMakeCertCall.Call ctx before after v ret := by
  intro call
  cases call with
  | run args bind after gateTrace events ret body v bit =>
    exact (all_workspace_iff_no_binding ctx).mp all before args bind

theorem workspace_vacuous_nonzero_scratch (ctx : KeygenSearchContext.Context)
    (nonzero : ctx.scratch.block ≠ 0) :
    ∀ s : State, KeygenMakeCertMaterial.LegalWorkspace s ctx := by
  intro s args binding
  exact (nonzero (KeygenMakeCertMaterial.workspace_scratch_block s ctx args binding)).elim

theorem attempt_spine_premises_impossible (ctx : KeygenSearchContext.Context)
    (before : State) (out : C99ProcedureReference.Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (source : KeygenMakeCertChronology.AttemptExec ctx before out)
    (accepted : out.flow = .breakLoop)
    (workspace : ∀ s : State, KeygenMakeCertMaterial.LegalWorkspace s ctx) : False := by
  cases KeygenMakeAttemptSpine.accepted_spine ctx before out i remaining source accepted with
  | run entry middle sampled res normed publicState rawState publicValue solverValue certValue
      cap sampleF sampleG resultants norms publicCall publicNonzero solverCall solverReturned certificate =>
    exact all_workspace_excludes_call ctx workspace rawState out.state certValue true certificate

theorem allocated_empty_false (p : ArrayPointer) : ¬Allocated emptyMemory p := by
  rintro ⟨positive,_,inside,extent,_⟩
  have hcount : 0 < p.count := by omega
  have hp := Nat.mul_pos positive hcount
  change p.base+p.elementBytes*p.count ≤ 0 at extent
  omega

def wordMemory : Memory := ⟨fun _ _ => some 0,fun _ => 8,fun _ => true⟩
def wordPointer : ArrayPointer := ⟨0,0,1,8,0⟩
theorem allocated_witness : Allocated wordMemory wordPointer := by
  unfold Allocated wordMemory wordPointer
  decide +kernel
theorem load64_witness : Load64 wordMemory wordPointer 0 := by
  have h : le64 (fun _ => (0 : BitVec 8)) = 0 := by decide +kernel
  rw [← h]
  exact .load wordMemory wordPointer (fun _ => 0) allocated_witness rfl (fun _ => rfl)

theorem no_empty_law : ¬Nonempty (Law Empty) := by
  rintro ⟨p⟩
  have h := p.total
  simp at h

theorem evalword_load32_trivial (s : State) (name : C99ArrayReference.Name)
    (index : CLogic.Expr) (z : KeygenPublicAlgebra.R) :
    KeygenPublicTableStore.EvalWord s (.load32 name index) z := by
  intro v h
  cases h

theorem ntt_cells_zero_trivial (heap : Memory) (p : ArrayPointer)
    (a : Nat → KeygenNttWordAlgebra.R) : KeygenNttCells.Cells heap p 0 a := by
  intro i h
  omega

theorem profile_false_branch_reachable (ctx : KeygenSearchContext.Context) :
    KeygenMakeCertCall.CertificateGate ctx emptyState ⟨emptyState,.breakLoop⟩ := by
  apply KeygenMakeCertCall.CertificateGate.unprofiled
  intro profile
  have h := profile.1
  cases h

def roomyMemory : Memory := ⟨fun _ _ => none,fun _ => 1048576,fun _ => true⟩

theorem certificate_frame_legal_witness : CertificateFrameEntry.Legal 0 roomyMemory := by
  constructor
  · decide +kernel
  · decide +kernel
  · rfl
  · unfold C99Automatic32.Space C99Automatic32.address C99Automatic32.align4 roomyMemory
    decide +kernel

theorem certificate_bound_trivial : CertificateFunctionSyntax.Bound :=
  CertificateFunctionSyntax.bound

#print axioms no_virtual_legal
#print axioms invocation_only_failure
#print axioms no_successful_invocation
#print axioms no_all_state_dimensions
#print axioms dimensions_inhabited
#print axioms certbind_readonly
#print axioms all_workspace_iff_no_binding
#print axioms all_workspace_excludes_call
#print axioms workspace_vacuous_nonzero_scratch
#print axioms attempt_spine_premises_impossible
#print axioms allocated_empty_false
#print axioms allocated_witness
#print axioms load64_witness
#print axioms no_empty_law
#print axioms evalword_load32_trivial
#print axioms ntt_cells_zero_trivial
#print axioms profile_false_branch_reachable
#print axioms certificate_frame_legal_witness
#print axioms certificate_bound_trivial
end FT1536.PremiseAudit
