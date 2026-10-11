import ActualCoordinate020A

namespace FT1536.S05.CoordinateSites020A
open WordRAM020 WordArithmetic020 PairProgram020 ReadSemantics020A BitValue020A CdfPrefix020A
open FT1536.Relation JointInterface019

theorem direct (h : Rq) (tape : Bits tapeSize) (s : State) (dst : Reg) (b : Nat)
    (ha : b+384≤tapeSize) (hb : s.reg 3=nw b) :
    let i := InputLayout020.encode h tape
    let t := exec i (coordinate dst (r 3)) s
    t.reg dst=nw (StandaloneRuntime019.coord StandaloneRuntime019.tables (fun j => tapeBits i (b+j.val))).val ∧
      Frame s t ∧ ∀ k : Reg, (k.val<4 ∨ 12<k.val) → k≠30 → k≠dst → t.reg k=s.reg k := by
  apply ActualCoordinate020A.actual_coordinate h tape s dst (r 3) b ha hb
  all_goals simp [reads,r]

theorem offset (h : Rq) (tape : Bits tapeSize) (s : State) (dst : Reg) (b off : Nat)
    (ha : b+off+384≤tapeSize) (hb : s.reg 3=nw b) :
    let i := InputLayout020.encode h tape
    let t := exec i (coordinate dst (add (r 3) (lit off))) s
    t.reg dst=nw (StandaloneRuntime019.coord StandaloneRuntime019.tables (fun j => tapeBits i (b+off+j.val))).val ∧
      Frame s t ∧ ∀ k : Reg, (k.val<4 ∨ 12<k.val) → k≠30 → k≠dst → t.reg k=s.reg k := by
  apply ActualCoordinate020A.actual_coordinate h tape s dst (add (r 3) (lit off)) (b+off) ha
  · change op .add (s.reg 3) (word off)=nw (b+off)
    rw [hb]
    exact add_word _ _ (tiny_fits (by simp only [tapeSize] at ha; omega))
      (tiny_fits (by simp only [tapeSize] at ha; omega))
  all_goals simp [reads,add,r,lit]

end FT1536.S05.CoordinateSites020A
