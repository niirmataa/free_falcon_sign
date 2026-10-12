import CubeRead020C
import StoreExpressions020C
import NormResponse020C

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CubeStep020C
open WordRAM020 PairProgram020 ReadSemantics020A WordArithmetic020 CdfPrefix020A
open PairStores020B PairArithmetic020B CubeRead020C NormResponse020C
attribute [local irreducible] exec loopState

def tailOps : List Code := [store (mul (r 1) (lit 2)) (sub (r 13) (lit 512)),
  store (add (mul (r 1) (lit 2)) (lit 1)) (sub (r 14) (lit 512)),inc 1]
def tailCode : Code := seqs tailOps
def body : Code := seqs (CubeRead020C.ops++tailOps)
def result (s : State) (p : Fin 1536) (x y : Nat) : State :=
  put (writePair s p (word ((x:Int)-512)) (word ((y:Int)-512))) 1 (nw (p.val+1))

theorem tail_correct (i : Input) (s : State) (p : Fin 1536) (x y : Nat)
    (hx : x<1024) (hy : y<1024) (h1 : s.reg 1=nw p.val)
    (h13 : s.reg 13=nw x) (h14 : s.reg 14=nw y) :
    exec i tailCode s=result s p x y := by
  have fx : Fits (x:Int) := bounded_fits _ (by omega) (by omega)
  have fy : Fits (y:Int) := bounded_fits _ (by omega) (by omega)
  have f512 : Fits 512 := bounded_fits _ (by norm_num) (by norm_num)
  have fp : Fits (p.val:Int) := bounded_fits _ (by omega) (by have := p.isLt;omega)
  have f1 : Fits 1 := bounded_fits _ (by norm_num) (by norm_num)
  have ex : eval s (sub (r 13) (lit 512))=word ((x:Int)-512) := by
    change op .sub (s.reg 13) (word 512)=_
    rw [h13,sub_word _ _ fx f512]
  have ey : eval s (sub (r 14) (lit 512))=word ((y:Int)-512) := by
    change op .sub (s.reg 14) (word 512)=_
    rw [h14,sub_word _ _ fy f512]
  have he := CdfStep020A.seqs_append i
    [store (mul (r 1) (lit 2)) (sub (r 13) (lit 512)),
      store (add (mul (r 1) (lit 2)) (lit 1)) (sub (r 14) (lit 512))] [inc 1] s
  change exec i tailCode s=exec i (seqs [inc 1])
    (exec i (StoreExpressions020C.storesBy (sub (r 13) (lit 512)) (sub (r 14) (lit 512))) s) at he
  rw [he,StoreExpressions020C.stores_correct i s p _ _ h1,ex,ey]
  simp only [exec_seqs_cons,exec_seqs_nil,inc,exec_set]
  change put (writePair s p (word ((x:Int)-512)) (word ((y:Int)-512))) 1
    (op .add (s.reg 1) (word 1))=result s p x y
  rw [h1,add_word _ _ fp f1]
  rfl

theorem body_shape (i : Input) (s : State) : exec i body s=exec i tailCode (exec i CubeRead020C.readCode s) :=
  CdfStep020A.seqs_append i CubeRead020C.ops tailOps s

theorem body_correct (i : Input) (s : State) (p : Fin 1536) (h1 : s.reg 1=nw p.val) :
    let t := exec i body s
    t.ram (slot0 p)=word (vals i p.val).1 ∧ t.ram (slot1 p)=word (vals i p.val).2 ∧
    (∀ j : Fin ramSize, j≠slot0 p → j≠slot1 p → t.ram j=s.ram j) ∧
    t.reg 1=nw (p.val+1) ∧ Preserves s t := by
  let q := exec i CubeRead020C.readCode s
  have rd := read_correct i s p.val p.isLt h1
  have bd := raw_bounds i p.val
  have he : exec i body s=result q p (rawX i p.val) (rawY i p.val) := by
    rw [body_shape,tail_correct i q p _ _ bd.1 bd.2 rd.2.2.1 rd.1 rd.2.1]
  dsimp only
  rw [he]
  have fr : Preserves s q := ⟨rd.2.2.2.2.1.symm,rd.2.2.2.2.2.symm,
    fun j _ => congrFun rd.2.2.2.1.symm j⟩
  refine ⟨(write_read q p _ _).1,(write_read q p _ _).2,?_,put_same _ _ _,?_,?_,?_⟩
  · intro j hfirst hsecond
    exact (write_other q p _ _ j hfirst hsecond).trans (congrFun rd.2.2.2.1.symm j)
  · exact fr.1
  · exact fr.2.1
  · intro j hj
    exact (VectorPrefix020C.suffix_step p q (writePair q p _ _)
      (write_other q p _ _) j hj).trans (fr.2.2 j hj)

end FT1536.S05.CubeStep020C
