import TrialCorrect020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CapLoop020A
open WordRAM020 PairProgram020 ReadSemantics020A BitValue020A CdfPrefix020A TrialCorrect020A
open FT1536.Relation JointInterface019
attribute [local irreducible] exec StandaloneRuntime019.pairTrial StandaloneRuntime019.coord StandaloneRuntime019.search StandaloneRuntime019.word StandaloneRuntime019.value

def firstFrom {A : Type} (trial : Nat → Option A) : Nat → Nat → Option A
  | 0,_ => none
  | count+1,k => match trial k with | some z => some z | none => firstFrom trial count (k+1)

theorem firstFrom_eq_first {C A : Type} (trial : C → Option A) (coins : Nat → C) (count k : Nat) :
    firstFrom (fun j => trial (coins j)) count k=StandaloneRuntime019.first trial count (fun j => coins (k+j.val)) := by
  induction count generalizing k with
  | zero => rfl
  | succ count ih =>
    simp only [firstFrom,StandaloneRuntime019.first,Fin.val_zero,Nat.add_zero]
    cases ht : trial (coins k) with
    | some z => rfl
    | none =>
      change firstFrom (fun j => trial (coins j)) count (k+1)=
        StandaloneRuntime019.first trial count (fun j => coins (k+j.succ.val))
      rw [ih]
      apply congrArg (StandaloneRuntime019.first trial count)
      funext j
      congr 1
      simp only [Fin.val_succ]
      omega

theorem answer_none (s : State) : answer s=none ↔ s.reg 15=0 := by
  unfold answer
  split <;> simp_all

theorem guard_on (s : State) (h : s.reg 15=0) : eval s (eq (r 15) (lit 0))≠0 := by
  change word (if s.reg 15=0 then 1 else 0)≠0
  rw [ite_eq_left h]
  decide

theorem guard_off (s : State) (h : s.reg 15≠0) : eval s (eq (r 15) (lit 0))=0 := by
  change word (if s.reg 15=0 then 1 else 0)=0
  rw [ite_eq_right h]
  rfl

theorem loop_zero (f : State → State) (g : Expr) (s : State) : loopState f g 0 s=s := rfl

theorem loop_succ (f : State → State) (g : Expr) (n : Nat) (s : State) :
    loopState f g (n+1) s = if eval s g=0 then s else loopState f g n (f s) := rfl


theorem stopped (i : Input) (count : Nat) (s : State) (h : answer s≠none) :
    loopState (exec i trial) (eq (r 15) (lit 0)) count s=s := by
  cases count with
  | zero => exact loop_zero _ _ _
  | succ n =>
    rw [loop_succ,ite_eq_left (guard_off s (fun he => h ((answer_none s).mpr he)))]


/-- Specification alias only; actual execution remains PairProgram020.trial. -/
noncomputable def sourceTrial (i : Input) (n p k : Nat) : Option StandaloneRuntime019.Block :=
  StandaloneRuntime019.pairTrial StandaloneRuntime019.tables (coinsAt i (TrialAddress020A.base n p k))

attribute [local irreducible] loopState sourceTrial

/-- Remaining-budget invariant for the ACTUAL stateful cap. Rejected trials
    advance the source tape index; accepted trials stop before another read. -/
theorem loop_correct (i : Input) (h : Rq) (tape : Bits tapeSize) (n p count k : Nat) (s : State)
    (hi : i=InputLayout020.encode h tape) (hn : n<196) (hp : p<1536) (hbudget : k+count≤80)
    (h0 : s.reg 0=nw n) (h1 : s.reg 1=nw p) (h2 : s.reg 2=nw k) (h15 : s.reg 15=0) :
    let t := loopState (exec i trial) (eq (r 15) (lit 0)) count s
    answer t=(firstFrom (sourceTrial i n p) count k).map encoded ∧ Frame s t ∧
      ∀ r : Reg, (r.val<2 ∨ 15<r.val) → r≠30 → t.reg r=s.reg r := by
  change answer (loopState (exec i trial) (eq (r 15) (lit 0)) count s) =
    (firstFrom (sourceTrial i n p) count k).map encoded ∧
    Frame s (loopState (exec i trial) (eq (r 15) (lit 0)) count s) ∧
    ∀ rr : Reg, (rr.val<2 ∨ 15<rr.val) → rr≠30 →
      (loopState (exec i trial) (eq (r 15) (lit 0)) count s).reg rr=s.reg rr
  induction count generalizing k s with
  | zero =>
    rw [loop_zero]
    change answer s=none ∧ Frame s s ∧ _
    exact ⟨(answer_none s).mpr h15,frame_refl s,fun _ _ _ => rfl⟩
  | succ count ih =>
    have hk : k<80 := by omega
    let s' := exec i trial s
    have step := trial_correct h tape s n p k hn hp hk h0 h1 h2 h15
    rw [←hi] at step
    have hs' : answer s'=(sourceTrial i n p k).map encoded := step.1
    rw [loop_succ,ite_eq_right (guard_on s h15)]
    cases ht : sourceTrial i n p k with
    | none =>
      have hnone : answer s'=none := by simpa only [ht,Option.map_none] using hs'
      have h0' : s'.reg 0=nw n := (step.2.2.2 0 (by norm_num) (by norm_num)).trans h0
      have h1' : s'.reg 1=nw p := (step.2.2.2 1 (by norm_num) (by norm_num)).trans h1
      have post := ih (k+1) s' (by omega) h0' h1' step.2.1 ((answer_none s').mp hnone)
      simp only [firstFrom,ht]
      refine ⟨post.1,frame_trans step.2.2.1 post.2.1,?_⟩
      intro r hr h30
      exact (post.2.2 r hr h30).trans (step.2.2.2 r hr h30)
    | some z =>
      have hsome : answer s'=some (encoded z) := by simpa only [ht,Option.map_some] using hs'
      have hstop : answer s'≠none := by rw [hsome];exact Option.noConfusion
      rw [stopped i count s' hstop]
      simp only [firstFrom,ht,Option.map_some]
      exact ⟨hsome,step.2.2.1,step.2.2.2⟩

end FT1536.S05.CapLoop020A
