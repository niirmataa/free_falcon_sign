import TrialAddress020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.TrialRead020A
open WordRAM020 WordArithmetic020 PairProgram020 ReadSemantics020A BitValue020A CdfPrefix020A
open FT1536.Relation JointInterface019
attribute [local irreducible] StandaloneRuntime019.coord exec loopState

def x (i : Input) (b : Nat) : Nat :=
  (StandaloneRuntime019.coord StandaloneRuntime019.tables (fun j => tapeBits i (b+j.val))).val

def y (i : Input) (b : Nat) : Nat :=
  (StandaloneRuntime019.coord StandaloneRuntime019.tables (fun j => tapeBits i (b+384+j.val))).val

def readPrefix : Code := seqs [set 3 TrialAddress020A.addressExpr,
  coordinate 13 (r 3),coordinate 14 (add (r 3) (lit 384)),
  readWord 7 (add (r 3) (lit 768)) 256]

theorem outside_ne (r j : Reg) (hr : r.val<3 ∨ 14<r.val) (hj : 3≤j.val ∧ j.val≤14) : r≠j := by
  intro he; subst j; omega

/-- Three actual word reads and both actual coordinate calls of a trial,
    tied to its affine tape slice and preserving the cap/norm counters. -/
theorem read_correct (h : Rq) (tape : Bits tapeSize) (s : State) (n p k : Nat)
    (hn : n<196) (hp : p<1536) (hk : k<80)
    (h0 : s.reg 0=nw n) (h1 : s.reg 1=nw p) (h2 : s.reg 2=nw k) :
    let i := InputLayout020.encode h tape
    let b := TrialAddress020A.base n p k
    let t := exec i readPrefix s
    t.reg 13=nw (x i b) ∧ t.reg 14=nw (y i b) ∧ t.reg 7=nw (value (tapeBits i) 256 (b+768)) ∧
      Frame s t ∧ ∀ r : Reg, (r.val<3 ∨ 14<r.val) → r≠30 → t.reg r=s.reg r := by
  let i := InputLayout020.encode h tape
  let b := TrialAddress020A.base n p k
  have hb : b+1024≤tapeSize := (TrialAddress020A.window n p k hn hp hk).2
  let s1 := put s 3 (nw b)
  have h13 : s1.reg 3=nw b := put_same _ _ _
  let s2 := exec i (coordinate 13 (r 3)) s1
  have xc := CoordinateSites020A.direct h tape s1 13 b (by omega) h13
  have h23 : s2.reg 3=nw b := (xc.2.2 3 (by decide) (by decide) (by decide)).trans h13
  let s3 := exec i (coordinate 14 (add (r 3) (lit 384))) s2
  have yc := CoordinateSites020A.offset h tape s2 14 b 384 (by omega) h23
  have h33 : s3.reg 3=nw b := (yc.2.2 3 (by decide) (by decide) (by decide)).trans h23
  let s4 := exec i (readWord 7 (add (r 3) (lit 768)) 256) s3
  have ac := ReadWordSites020A.offset_base i s3 7 b 768 256 (by decide) (by omega) h33
  have hex : exec i readPrefix s=s4 := by
    simp only [readPrefix,exec_seqs_cons,exec_seqs_nil]
    rw [TrialAddress020A.machine_store i s n p k hn hp hk h0 h1 h2]
  dsimp only
  rw [hex]
  refine ⟨?_,?_,ac.1,?_,?_⟩
  · exact (ac.2.2 13 (by decide) (by decide) (by decide) (by decide)).trans
      ((yc.2.2 13 (by decide) (by decide) (by decide)).trans xc.1)
  · exact (ac.2.2 14 (by decide) (by decide) (by decide) (by decide)).trans yc.1
  · exact frame_trans (frame_put s 3 _) (frame_trans xc.2.1 (frame_trans yc.2.1 ac.2.1))
  · intro r hr hr30
    have nr (j : Reg) (hj : 3≤j.val ∧ j.val≤14) : r≠j := outside_ne r j hr hj
    have hc : r.val<4 ∨ 12<r.val := by omega
    calc
      s4.reg r = s3.reg r := ac.2.2 r (nr 4 (by decide)) (nr 5 (by decide)) (nr 6 (by decide)) (nr 7 (by decide))
      _ = s2.reg r := yc.2.2 r hc hr30 (nr 14 (by decide))
      _ = s1.reg r := xc.2.2 r hc hr30 (nr 13 (by decide))
      _ = s.reg r := put_other s 3 r _ (nr 3 (by decide))

end FT1536.S05.TrialRead020A
