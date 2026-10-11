import CapGuard020B
import TrialCorrect020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ActualCap020B
open WordRAM020 PairProgram020 ReadSemantics020A CdfPrefix020A
open CapCore020B CapGuard020B TrialCorrect020A
open FT1536.Relation JointInterface019

/-- Specification only; the executed step is still PairProgram020.trial. -/
noncomputable def sourceTrial (i : Input) (n p k : Nat) : Option StandaloneRuntime019.Block :=
  StandaloneRuntime019.pairTrial StandaloneRuntime019.tables
    (coinsAt i (TrialAddress020A.base n p k))

def Inv (n p k : Nat) (s : State) : Prop :=
  s.reg 0=nw n ∧ s.reg 1=nw p ∧ s.reg 2=nw k

attribute [local irreducible] exec loopState StandaloneRuntime019.pairTrial

/-- The generic step premise is FILLED by the actual table/bit/trial proof. -/
theorem actual_step (h : Rq) (tape : Bits tapeSize) (n p k : Nat) (s : State)
    (hn : n<196) (hp : p<1536) (hk : k<80) (inv : Inv n p k s)
    (empty : observe s=none) :
    let i := InputLayout020.encode h tape
    observe (exec i trial s)=(sourceTrial i n p k).map encoded ∧
      Inv n p (k+1) (exec i trial s) ∧ Preserves s (exec i trial s) := by
  have step := trial_correct h tape s n p k hn hp hk inv.1 inv.2.1 inv.2.2
    ((observe_none s).mp empty)
  refine ⟨step.1,⟨?_,?_,step.2.1⟩,step.2.2.1,step.2.2.2⟩
  · exact (step.2.2.2 0 (by decide) (by decide)).trans inv.1
  · exact (step.2.2.2 1 (by decide) (by decide)).trans inv.2.1

/-- Actual cap suffix for every remaining budget, including all rejections.
    No table-law, trial-correctness or probabilistic hypothesis is an input. -/
theorem loop_correct (h : Rq) (tape : Bits tapeSize) (n p count k : Nat) (s : State)
    (hn : n<196) (hp : p<1536) (budget : k+count≤80)
    (inv : Inv n p k s) (empty : observe s=none) :
    let i := InputLayout020.encode h tape
    let t := loopState (exec i trial) (eq (r 15) (lit 0)) count s
    observe t=(firstFrom (sourceTrial i n p) count k).map encoded ∧ Preserves s t := by
  let i := InputLayout020.encode h tape
  have result := first_success (exec i trial) (eq (r 15) (lit 0)) observe
    (fun j => (sourceTrial i n p j).map encoded) (Inv n p) Preserves 80
    preserves_refl (fun a b => preserves_trans a b) guard_iff
    (fun j q hj hq he => actual_step h tape n p j q hn hp hj hq he)
    count k s budget inv empty
  rw [firstFrom_map] at result
  exact result

end FT1536.S05.ActualCap020B
