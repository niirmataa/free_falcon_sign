import TrialCorrect020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CapLoop020A
open WordRAM020 PairProgram020 ReadSemantics020A BitValue020A CdfPrefix020A TrialCorrect020A
open FT1536.Relation JointInterface019
attribute [local irreducible] exec loopState StandaloneRuntime019.pairTrial

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

theorem stopped (i : Input) (count : Nat) (s : State) (h : answer s≠none) :
    loopState (exec i trial) (eq (r 15) (lit 0)) count s=s := by
  cases count with
  | zero => rfl
  | succ n =>
    change (if eval s (eq (r 15) (lit 0))=0 then s else
      loopState (exec i trial) (eq (r 15) (lit 0)) n (exec i trial s))=s
    rw [ite_eq_left (guard_off s (fun he => h ((answer_none s).mpr he)))]

theorem loop_succ (f : State → State) (g : Expr) (n : Nat) (s : State) :
    loopState f g (n+1) s = if eval s g=0 then s else loopState f g n (f s) := rfl

def sourceTrial (i : Input) (n p k : Nat) : Option StandaloneRuntime019.Block :=
  StandaloneRuntime019.pairTrial StandaloneRuntime019.tables (coinsAt i (TrialAddress020A.base n p k))


end FT1536.S05.CapLoop020A
