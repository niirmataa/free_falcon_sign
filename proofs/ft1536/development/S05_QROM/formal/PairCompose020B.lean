import PairShape020B

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.PairCompose020B
open WordRAM020 PairProgram020 ReadSemantics020A CdfPrefix020A TrialCorrect020A
open PairArithmetic020B PairStores020B PairAdvance020B CapDraw020B
open PairShape020B
open FT1536.Relation JointInterface019
attribute [local irreducible] exec loopState StandaloneRuntime019.pair StandaloneRuntime019.first

def PairPost (s t : State) (p : Fin 1536) (a x y : Int) : Prop :=
  t.ram (slot0 p)=word x ∧ t.ram (slot1 p)=word y ∧
  (∀ j : Fin ramSize, j≠slot0 p → j≠slot1 p → t.ram j=s.ram j) ∧
  t.reg 16=word (a+q2 x y) ∧ t.reg 1=nw (p.val+1) ∧
  t.out=s.out ∧ t.fault=s.fault ∧
  (∀ rr : Reg, (rr.val=0 ∨ 17<rr.val) → rr≠30 → t.reg rr=s.reg rr)

theorem compose (i : Input) (s : State) (p : Fin 1536) (a x y : Int)
    (ha : 0≤a ∧ a≤(p.val:Int)*(3*65535^2))
    (hx : -65535≤x ∧ x≤65535) (hy : -65535≤y ∧ y≤65535)
    (q13 : (exec i draw s).reg 13=word x) (q14 : (exec i draw s).reg 14=word y)
    (q1 : (exec i draw s).reg 1=nw p.val) (q16 : (exec i draw s).reg 16=word a)
    (fr : Frame s (exec i draw s))
    (regs : ∀ rr : Reg, (rr.val<2 ∨ 15<rr.val) → rr≠30 → (exec i draw s).reg rr=s.reg rr) :
    PairPost s (exec i PairProgram020.pair s) p a x y := by
  let q := exec i draw s
  let w := writePair q p (word x) (word y)
  have st : exec i stores q=w := by rw [stores_correct i q p q1,q13,q14]
  have adv := advance_correct i w p.val a x y p.isLt ha hx hy q1 q16 q13 q14
  have he : exec i PairProgram020.pair s=nextState w p.val a x y := by
    rw [pair_shape,st,adv]
  rw [he]
  refine ⟨(write_read q p (word x) (word y)).1,
    (write_read q p (word x) (word y)).2,?_,next_norm _ _ _ _ _,
    next_counter _ _ _ _ _,fr.2.1.symm,fr.2.2.symm,?_⟩
  · intro j hfirst hsecond
    exact (write_other q p (word x) (word y) j hfirst hsecond).trans (congrFun fr.1.symm j)
  · intro rr hr h30
    have hn1 : rr≠1 := by intro heq;subst rr;norm_num at hr
    have hn16 : rr≠16 := by intro heq;subst rr;norm_num at hr
    have hn17 : rr≠17 := by intro heq;subst rr;norm_num at hr
    exact (next_other w p.val a x y rr hn1 hn16 hn17).trans (regs rr (by omega) h30)

end FT1536.S05.PairCompose020B
