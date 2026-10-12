import EmitWord020D
import ScalarExpr020D
import CdfStep020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.EmitEntry020D
open WordRAM020 PairProgram020 ReadSemantics020A ScalarExpr020D
open FT1536.Run2.BitArithmetic (encodeNat)
attribute [local irreducible] exec loopState

def code (ops : List Code) (width : Nat) : Code := seqs (ops++[emitWord width,inc 21])

theorem shape (i : Input) (s : State) (ops : List Code) (width : Nat) :
    exec i (code ops width) s=exec i (inc 21) (exec i (emitWord width) (exec i (seqs ops) s)) := by
  have h := CdfStep020A.seqs_append i ops [emitWord width,inc 21] s
  simpa only [code,exec_seqs_cons,exec_seqs_nil] using h

/-- Generic entry emission; both actual key/reply prefixes must fill these
    concrete register/memory premises before whole-output use. -/
theorem from_prefix (i : Input) (s q : State) (ops : List Code) (width p b a : Nat)
    (hw : width≤384) (hp : p<1536) (hb : b+width≤outputSize) (ha : a<2^width)
    (hq : exec i (seqs ops) s=q) (q21 : q.reg 21=word (p:Int))
    (q28 : q.reg 28=word (b:Int)) (q30 : q.reg 30=word (a:Int))
    (qmem : q.ram=s.ram ∧ q.out=s.out ∧ q.fault=s.fault) :
    let t := exec i (code ops width) s
    t.reg 21=word ((p+1:Nat):Int) ∧ t.reg 28=word ((b+width:Nat):Int) ∧
      t.out=OutputSlice020D.write s.out b (encodeNat a width) ∧ t.ram=s.ram ∧ t.fault=s.fault := by
  have post := EmitWord020D.emitWord_correct i q width b a hw hb ha q28 q30
  let u := exec i (emitWord width) q
  have u21 : u.reg 21=word (p:Int) := (post.2.2.2.2.2.2 21 (by decide) (by decide) (by decide)).trans q21
  have ei : eval u (add (r 21) (lit 1))=word ((p+1:Nat):Int) := inc_eval u 21 p (by omega) u21
  have he : exec i (code ops width) s=put u 21 (word ((p+1:Nat):Int)) := by
    rw [shape,hq]
    simp only [inc,exec_set]
    exact congrArg (put u 21) ei
  dsimp only
  rw [he]
  refine ⟨put_same _ _ _,?_,?_,post.2.2.2.2.1.trans qmem.1,post.2.2.2.2.2.1.trans qmem.2.2⟩
  · exact (put_other u 21 28 _ (by decide)).trans post.2.2.1
  · change u.out=OutputSlice020D.write s.out b (encodeNat a width)
    rw [post.2.2.2.1,qmem.2.1]

end FT1536.S05.EmitEntry020D
