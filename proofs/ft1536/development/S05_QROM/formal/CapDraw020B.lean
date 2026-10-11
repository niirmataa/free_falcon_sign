import ActualCap020B

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CapDraw020B
open WordRAM020 PairProgram020 ReadSemantics020A BitValue020A CdfPrefix020A TrialCorrect020A CapCore020B CapGuard020B ActualCap020B
open FT1536.Relation JointInterface019
attribute [local irreducible] exec loopState StandaloneRuntime019.pairTrial

def coins (i : Input) (n p : Nat) : StandaloneRuntime019.PairSeed :=
  fun j => coinsAt i (TrialAddress020A.base n p j.val)

def capped : Code := seqs [set 15 (lit 0),set 2 (lit 0),.loop 80 (eq (r 15) (lit 0)) trial]

def fallback : Code := .branch (eq (r 15) (lit 0)) (seqs [set 13 (lit 0),set 14 (lit 0)]) skip

def draw : Code := seqs [capped,fallback]

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
      apply congrArg coins
      simp only [Fin.val_succ]
      omega

attribute [local irreducible] StandaloneRuntime019.first

theorem source_first (i : Input) (n p : Nat) : firstFrom (sourceTrial i n p) 80 0=
    StandaloneRuntime019.first (StandaloneRuntime019.pairTrial StandaloneRuntime019.tables) 80 (coins i n p) := by
  change firstFrom (fun j => StandaloneRuntime019.pairTrial StandaloneRuntime019.tables
    (coinsAt i (TrialAddress020A.base n p j))) 80 0=_
  rw [firstFrom_eq_first]
  simp only [Nat.zero_add]
  apply congrArg (StandaloneRuntime019.first (StandaloneRuntime019.pairTrial StandaloneRuntime019.tables) 80)
  funext j
  rfl

theorem cap_correct (h : Rq) (tape : Bits tapeSize) (n p : Nat) (s : State)
    (hn : n<196) (hp : p<1536) (h0 : s.reg 0=nw n) (h1 : s.reg 1=nw p) :
    let i := InputLayout020.encode h tape
    let t := exec i capped s
    observe t=(StandaloneRuntime019.first (StandaloneRuntime019.pairTrial StandaloneRuntime019.tables) 80 (coins i n p)).map encoded ∧
      Frame s t ∧ ∀ r : Reg, (r.val<2 ∨ 15<r.val) → r≠30 → t.reg r=s.reg r := by
  let i := InputLayout020.encode h tape
  let s0 := put (put s 15 (word 0)) 2 (word 0)
  have h00 : s0.reg 0=nw n := by dsimp [s0];rw [put_other _ 2 0 _ (by decide),put_other _ 15 0 _ (by decide),h0]
  have h01 : s0.reg 1=nw p := by dsimp [s0];rw [put_other _ 2 1 _ (by decide),put_other _ 15 1 _ (by decide),h1]
  have h02 : s0.reg 2=nw 0 := put_same _ _ _
  have h015 : s0.reg 15=0 := by dsimp [s0];rw [put_other _ 2 15 _ (by decide),put_same];rfl
  have post := ActualCap020B.loop_correct h tape n p 80 0 s0 hn hp (by decide) ⟨h00,h01,h02⟩ ((observe_none s0).mpr h015)
  have he : exec i capped s=loopState (exec i trial) (eq (r 15) (lit 0)) 80 s0 := by
    simp only [capped,exec_seqs_cons,exec_seqs_nil,exec_set,lit,eval_lit,exec_loop]
    rfl
  dsimp only
  rw [he]
  refine ⟨?_,frame_trans (frame_trans (frame_put s 15 _) (frame_put _ 2 _)) post.2.1,?_⟩
  · rw [←source_first]
    exact post.1
  · intro r hr hr30
    have h2 : r≠2 := by intro he;subst r;norm_num at hr
    have h15 : r≠15 := by intro he;subst r;norm_num at hr
    rw [post.2.2 r hr hr30]
    dsimp [s0]
    rw [put_other _ 2 r _ h2,put_other _ 15 r _ h15]

theorem fallback_correct (i : Input) (s : State) :
    let t := exec i fallback s
    (t.reg 13,t.reg 14)=(observe s).getD (0,0) ∧ Frame s t ∧
      ∀ r : Reg, r≠13 → r≠14 → t.reg r=s.reg r := by
  unfold fallback
  rw [exec_branch]
  by_cases h : s.reg 15=0
  · rw [ite_eq_right (guard_on s h)]
    simp only [exec_seqs_cons,exec_seqs_nil,exec_set,lit,eval_lit]
    refine ⟨?_,⟨rfl,rfl,rfl⟩,?_⟩
    · rw [(observe_none s).mpr h]
      simp [put]
      rfl
    · intro r h13 h14
      rw [put_other _ 14 r _ h14,put_other _ 13 r _ h13]
  · rw [ite_eq_left (guard_off s h),exec_skip]
    refine ⟨?_,frame_refl s,fun _ _ _ => rfl⟩
    rw [CapGuard020B.observe,ite_eq_right h]
    rfl

theorem zero_encoded : encoded StandaloneRuntime019.zeroBlock=(0,0) := by
  change (word ((65535 : Int)-65535),word ((65535 : Int)-65535))=(0,0)
  norm_num
  rfl

theorem pair_encoded (i : Input) (n p : Nat) :
    encoded (StandaloneRuntime019.pair StandaloneRuntime019.tables (coins i n p)) =
      ((StandaloneRuntime019.first (StandaloneRuntime019.pairTrial StandaloneRuntime019.tables) 80 (coins i n p)).map encoded).getD (0,0) := by
  unfold StandaloneRuntime019.pair
  cases ht : StandaloneRuntime019.first (StandaloneRuntime019.pairTrial StandaloneRuntime019.tables) 80 (coins i n p) with
  | none => exact zero_encoded
  | some z => rfl

/-- The ACTUAL cap80 with zero fallback, including exhaustion of every trial.
    This stops before pair's RAM stores/norm accumulation; those remain separate. -/
theorem draw_correct (h : Rq) (tape : Bits tapeSize) (n p : Nat) (s : State)
    (hn : n<196) (hp : p<1536) (h0 : s.reg 0=nw n) (h1 : s.reg 1=nw p) :
    let i := InputLayout020.encode h tape
    let t := exec i draw s
    (t.reg 13,t.reg 14)=encoded (StandaloneRuntime019.pair StandaloneRuntime019.tables (coins i n p)) ∧
      Frame s t ∧ ∀ r : Reg, (r.val<2 ∨ 15<r.val) → r≠30 → t.reg r=s.reg r := by
  let i := InputLayout020.encode h tape
  have cap := cap_correct h tape n p s hn hp h0 h1
  have fb := fallback_correct i (exec i capped s)
  dsimp only
  simp only [draw,exec_seqs_cons,exec_seqs_nil]
  refine ⟨?_,frame_trans cap.2.1 fb.2.1,?_⟩
  · rw [pair_encoded,fb.1,cap.1]
  · intro r hr hr30
    have h13 : r≠13 := by intro he;subst r;norm_num at hr
    have h14 : r≠14 := by intro he;subst r;norm_num at hr
    exact (fb.2.2 r h13 h14).trans (cap.2.2 r hr hr30)

end FT1536.S05.CapDraw020B
