import ScatterRead020D
import ScatterAlgebra020D
import CdfStep020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ScatterTerm020D
open WordRAM020 PairProgram020 ReadSemantics020A Residue020D Interleaved020D
open BufferField020D ScatterBranches020D ScalarExpr020D MachineAtoms020D DataWords020D
attribute [local irreducible] exec loopState

def sumExp (e : Fin 1536) (j : Fin 1536) : Fin 3072 :=
  ⟨e.val+exponentN j.val,by have := e.isLt;have := exponent_bound j.val j.isLt;omega⟩
def tailCode : Code := seqs [branches,inc 22]

theorem term_shape (i : Input) (s : State) :
    exec i scatterTerm s=exec i tailCode (exec i ScatterRead020D.readCode s) :=
  CdfStep020A.seqs_append i ScatterRead020D.ops [branches,inc 22] s

/-- The whole actual scatterTerm, including signed input reduction, both
    middle-case writes and counter advance. -/
theorem term_correct (i : Input) (s : State) (v : Coeffs) (e j : Fin 1536) (a : F) (x : Int)
    (hv : Holds s v) (hx : -65535≤x ∧ x≤65535)
    (h22 : s.reg 22=word (j.val:Int)) (h23 : s.reg 23=word (e.val:Int))
    (h18 : s.reg 18=fw a) (hm : s.ram (dataSlot true j)=word x) :
    let t := exec i scatterTerm s
    Holds t (reduced v (sumExp e j) (a*(x:F))) ∧ BufferField020D.Frame s t ∧
      t.reg 22=word ((j.val+1:Nat):Int) ∧ t.reg 18=fw a ∧
      t.reg 23=word (e.val:Int) ∧ t.reg 21=s.reg 21 := by
  let q := ScatterRead020D.result s j e.val a x
  have rq := ScatterRead020D.read_correct i s j e.val a x e.isLt hx h22 h23 h18 hm
  have qmem := ScatterRead020D.result_memory s j e.val a x
  have qreg (rr : Reg) (h24 : rr≠24) (h19 : rr≠19) (h25 : rr≠25) (h17 : rr≠17) : q.reg rr=s.reg rr :=
    ScatterRead020D.result_other s j e.val a x rr h24 h19 h25 h17
  have qbuf : Holds q v := by intro r;rw [qmem.1];exact hv r
  have branch := branches_correct i q v (sumExp e j) (a*(x:F)) qbuf
    (ScatterRead020D.result_exponent s j e.val a x) (ScatterRead020D.result_product s j e.val a x)
  let u := exec i branches q
  have u22 : u.reg 22=word (j.val:Int) := (branch.2.2 22 (by decide) (by decide)).trans
    ((qreg 22 (by decide) (by decide) (by decide) (by decide)).trans h22)
  have inc22 : eval u (add (r 22) (lit 1))=word ((j.val+1:Nat):Int) :=
    inc_eval u 22 j.val (by have := j.isLt;omega) u22
  have he : exec i scatterTerm s=put u 22 (word ((j.val+1:Nat):Int)) := by
    rw [term_shape,rq]
    simp only [tailCode,exec_seqs_cons,exec_seqs_nil,inc,exec_set]
    exact congrArg (put u 22) inc22
  dsimp only
  rw [he]
  have fq : BufferField020D.Frame s q := ⟨qmem.2.1,qmem.2.2,fun j _ => congrFun qmem.1 j⟩
  have fu := BufferField020D.frame_trans fq branch.2.1
  refine ⟨branch.1,fu,put_same _ _ _,?_,?_,?_⟩
  · rw [put_other _ 22 18 _ (by decide)]
    exact (branch.2.2 18 (by decide) (by decide)).trans
      ((qreg 18 (by decide) (by decide) (by decide) (by decide)).trans h18)
  · rw [put_other _ 22 23 _ (by decide)]
    exact (branch.2.2 23 (by decide) (by decide)).trans
      ((qreg 23 (by decide) (by decide) (by decide) (by decide)).trans h23)
  · rw [put_other _ 22 21 _ (by decide)]
    exact (branch.2.2 21 (by decide) (by decide)).trans (qreg 21 (by decide) (by decide) (by decide) (by decide))

end FT1536.S05.ScatterTerm020D
