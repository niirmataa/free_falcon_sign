import ReadWordSites020A
import PairArithmetic020B

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CubeRead020C
open WordRAM020 PairProgram020 ReadSemantics020A WordArithmetic020
open PairArithmetic020B BitValue020A ReadWordSites020A
attribute [local irreducible] exec loopState

def base (p : Nat) : Nat := 196*1536*80*1024+p*20
def ops : List Code := [set 3 (add (lit (196*1536*80*1024)) (mul (r 1) (lit 20))),
  readWord 13 (r 3) 10,readWord 14 (add (r 3) (lit 10)) 10]
def readCode : Code := seqs ops
def rawX (i : Input) (p : Nat) : Nat := value (tapeBits i) 10 (base p)
def rawY (i : Input) (p : Nat) : Nat := value (tapeBits i) 10 (base p+10)
def vals (i : Input) (p : Nat) : Int × Int := ((rawX i p:Int)-512,(rawY i p:Int)-512)

theorem window (p : Nat) (hp : p<1536) : base p+20≤tapeSize := by
  unfold base tapeSize
  omega

theorem base_expr (s : State) (p : Nat) (hp : p<1536) (h1 : s.reg 1=word (p:Int)) :
    eval s (add (lit (196*1536*80*1024)) (mul (r 1) (lit 20)))=word (base p:Int) := by
  have fp : Fits (p:Int) := bounded_fits _ (by omega) (by omega)
  have f20 : Fits 20 := bounded_fits _ (by norm_num) (by norm_num)
  have fc : Fits (196*1536*80*1024) := bounded_fits _ (by norm_num) (by norm_num)
  have fm : Fits ((p:Int)*20) := bounded_fits _ (by omega) (by omega)
  change op .add (word (196*1536*80*1024)) (op .mul (s.reg 1) (word 20))=_
  rw [h1,mul_word _ _ fp f20,add_word _ _ fc fm]
  rfl

theorem raw_bounds (i : Input) (p : Nat) : rawX i p<1024 ∧ rawY i p<1024 :=
  ⟨value_lt _ _ _,value_lt _ _ _⟩

theorem read_correct (i : Input) (s : State) (p : Nat) (hp : p<1536)
    (h1 : s.reg 1=word (p:Int)) :
    let q := exec i readCode s
    q.reg 13=word (rawX i p:Int) ∧ q.reg 14=word (rawY i p:Int) ∧
      q.reg 1=word (p:Int) ∧ Frame s q := by
  let s0 := put s 3 (word (base p:Int))
  let s1 := exec i (readWord 13 (r 3) 10) s0
  have hwin := window p hp
  have r1 := register_base i s0 13 (base p) 10 (by decide) (by omega) (put_same _ _ _)
  have b1 : s1.reg 3=word (base p:Int) := by
    exact (r1.2.2 3 (by decide) (by decide) (by decide) (by decide)).trans (put_same _ _ _)
  have r2 := offset_base i s1 14 (base p) 10 10 (by decide) (by omega) b1
  have s01 : s0.reg 1=word (p:Int) := (put_other s 3 1 _ (by decide)).trans h1
  have s11 : s1.reg 1=word (p:Int) := (r1.2.2 1 (by decide) (by decide) (by decide) (by decide)).trans s01
  dsimp only
  simp only [readCode,ops,exec_seqs_cons,exec_seqs_nil,exec_set,base_expr s p hp h1]
  refine ⟨?_,r2.1,?_,frame_trans (frame_put s 3 _) (frame_trans r1.2.1 r2.2.1)⟩
  · exact (r2.2.2 13 (by decide) (by decide) (by decide) (by decide)).trans r1.1
  · exact (r2.2.2 1 (by decide) (by decide) (by decide) (by decide)).trans s11

end FT1536.S05.CubeRead020C
