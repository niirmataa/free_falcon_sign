import PairArithmetic020B

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.PairStores020B
open WordRAM020 PairProgram020 ReadSemantics020A WordArithmetic020 PairArithmetic020B

def slot0 (p : Fin 1536) : Fin ramSize := ⟨2*p.val,by have := p.isLt; unfold ramSize; omega⟩
def slot1 (p : Fin 1536) : Fin ramSize := ⟨2*p.val+1,by have := p.isLt; unfold ramSize; omega⟩
def writePair (s : State) (p : Fin 1536) (x y : Word) : State :=
  {s with ram := Function.update (Function.update s.ram (slot0 p) x) (slot1 p) y}
def stores : Code := seqs [store (mul (r 1) (lit 2)) (r 13),
  store (add (mul (r 1) (lit 2)) (lit 1)) (r 14)]

theorem slot_ne (p : Fin 1536) : slot0 p≠slot1 p := by
  intro h
  have h' := congrArg Fin.val h
  change 2*p.val=2*p.val+1 at h'
  omega

theorem address0 (s : State) (p : Fin 1536) (h1 : s.reg 1=word (p.val:Int)) :
    address ramSize (eval s (mul (r 1) (lit 2)))=some (slot0 p) := by
  have fp : Fits (p.val:Int) := bounded_fits _ (by omega) (by have := p.isLt; omega)
  have f2 : Fits 2 := bounded_fits _ (by norm_num) (by norm_num)
  change address ramSize (op .mul (s.reg 1) (word 2))=_
  rw [h1,mul_word _ _ fp f2]
  have he : (p.val:Int)*2=((2*p.val:Nat):Int) := by push_cast; ring
  rw [he]
  exact address_exact ramSize (2*p.val) (slot0 p).isLt (by have := p.isLt; norm_num; omega)

theorem address1 (s : State) (p : Fin 1536) (h1 : s.reg 1=word (p.val:Int)) :
    address ramSize (eval s (add (mul (r 1) (lit 2)) (lit 1)))=some (slot1 p) := by
  have hp := p.isLt
  have fp : Fits (p.val:Int) := bounded_fits _ (by omega) (by omega)
  have f2 : Fits 2 := bounded_fits _ (by norm_num) (by norm_num)
  have f1 : Fits 1 := bounded_fits _ (by norm_num) (by norm_num)
  have fprod : Fits ((p.val:Int)*2) := bounded_fits _ (by omega) (by omega)
  change address ramSize (op .add (op .mul (s.reg 1) (word 2)) (word 1))=_
  rw [h1,mul_word _ _ fp f2,add_word _ _ fprod f1]
  have he : (p.val:Int)*2+1=((2*p.val+1:Nat):Int) := by push_cast; ring
  rw [he]
  exact address_exact ramSize (2*p.val+1) (slot1 p).isLt (by norm_num; omega)

theorem exec_store (i : Input) (s : State) (a v : Expr) :
    exec i (store a v) s=(match address ramSize (eval s a) with
    | none => fail s | some k => {s with ram := Function.update s.ram k (eval s v)}) := rfl

theorem stores_correct (i : Input) (s : State) (p : Fin 1536)
    (h1 : s.reg 1=word (p.val:Int)) :
    exec i stores s=writePair s p (s.reg 13) (s.reg 14) := by
  simp only [stores,exec_seqs_cons,exec_seqs_nil,exec_store,address0 s p h1]
  rw [address1 {s with ram := Function.update s.ram (slot0 p) (eval s (r 13))} p h1]
  rfl

theorem write_read (s : State) (p : Fin 1536) (x y : Word) :
    (writePair s p x y).ram (slot0 p)=x ∧ (writePair s p x y).ram (slot1 p)=y := by
  simp [writePair,Function.update,slot_ne p]

theorem write_other (s : State) (p : Fin 1536) (x y : Word) (j : Fin ramSize)
    (h0 : j≠slot0 p) (h1 : j≠slot1 p) : (writePair s p x y).ram j=s.ram j := by
  simp [writePair,Function.update,h0,h1]

theorem write_frame (s : State) (p : Fin 1536) (x y : Word) :
    (writePair s p x y).reg=s.reg ∧ (writePair s p x y).out=s.out ∧
      (writePair s p x y).fault=s.fault := ⟨rfl,rfl,rfl⟩

end FT1536.S05.PairStores020B
