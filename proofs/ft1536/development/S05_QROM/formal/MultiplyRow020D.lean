import ScatterRow020D
import RowStart020D

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.MultiplyRow020D
open WordRAM020 PairProgram020 ReadSemantics020A Residue020D BufferField020D
open ActualScatter020D ScatterSums020D ScalarExpr020D
open FT1536.Relation JointInterface019
attribute [local irreducible] exec loopState row

def tailOps (count : Nat) : List Code := [set 22 (lit 0),.loop count (lit 1) scatterTerm,inc 21]
def bodyN (count : Nat) : Code := seqs (RowStart020D.ops++tailOps count)
def body : Code := bodyN 1536

theorem bodyN_shape (i : Input) (s : State) (count : Nat) :
    exec i (bodyN count) s=exec i (inc 21) (exec i (ScatterRow020D.code count) (exec i RowStart020D.code s)) := by
  have a := CdfStep020A.seqs_append i RowStart020D.ops (tailOps count) s
  have b := CdfStep020A.seqs_append i [set 22 (lit 0),.loop count (lit 1) scatterTerm] [inc 21]
    (exec i RowStart020D.code s)
  have c : exec i (seqs [inc 21]) (exec i (ScatterRow020D.code count) (exec i RowStart020D.code s))=
      exec i (inc 21) (exec i (ScatterRow020D.code count) (exec i RowStart020D.code s)) := by
    simp only [exec_seqs_cons,exec_seqs_nil]
  exact a.trans (b.trans c)

/-- A whole outer-loop row: actual ROM key load followed by all1536 terms. -/
theorem bodyN_correct (h : Rq) (tape : Bits tapeSize) (s : State)
    (z : StandaloneRuntime019.CachedBox) (p : Fin 1536) (v : Coeffs) (count : Nat) (hc : count≤1536)
    (h21 : s.reg 21=word (p.val:Int)) (hv : Holds s v)
    (hz : BoxImage020C.readVec s=BoxImage020C.image z) :
    let i := InputLayout020.encode h tape
    let t := exec i (bodyN count) s
    Holds t (fun r => v r+row h (noise z) p count r) ∧ BufferField020D.Frame s t ∧
      t.reg 21=word ((p.val+1:Nat):Int) := by
  let i := InputLayout020.encode h tape
  let q := RowStart020D.result s h p
  have pre := RowStart020D.run_correct h tape s p h21
  have qm := RowStart020D.result_memory s h p
  have qv : Holds q v := by intro r;rw [qm.1];exact hv r
  have qz : BoxImage020C.readVec q=BoxImage020C.image z := by
    change BoxImage020C.readVec s=BoxImage020C.image z
    exact hz
  have qc : q.reg 21=word (p.val:Int) := (RowStart020D.result_counter s h p).trans h21
  have post := ScatterRow020D.code_correct i z h p v count q hc qv qz
    (RowStart020D.result_key s h p) (RowStart020D.result_exponent s h p) qc
  let u := exec i (ScatterRow020D.code count) q
  have ue : eval u (add (r 21) (lit 1))=word ((p.val+1:Nat):Int) :=
    inc_eval u 21 p.val (by have := p.isLt;omega) post.1.2.2.2.2.2
  have he : exec i (bodyN count) s=put u 21 (word ((p.val+1:Nat):Int)) := by
    rw [bodyN_shape,pre]
    simp only [inc,exec_set]
    exact congrArg (put u 21) ue
  dsimp only
  rw [he]
  have fr : BufferField020D.Frame s q := ⟨qm.2.1,qm.2.2,fun j _ => congrFun qm.1 j⟩
  exact ⟨post.1.2.1,BufferField020D.frame_trans fr post.2,put_same _ _ _⟩

theorem body_correct (h : Rq) (tape : Bits tapeSize) (s : State)
    (z : StandaloneRuntime019.CachedBox) (p : Fin 1536) (v : Coeffs)
    (h21 : s.reg 21=word (p.val:Int)) (hv : Holds s v)
    (hz : BoxImage020C.readVec s=BoxImage020C.image z) :
    let i := InputLayout020.encode h tape
    let t := exec i body s
    Holds t (fun r => v r+row h (noise z) p 1536 r) ∧ BufferField020D.Frame s t ∧
      t.reg 21=word ((p.val+1:Nat):Int) :=
  bodyN_correct h tape s z p v 1536 (by decide) h21 hv hz

end FT1536.S05.MultiplyRow020D
