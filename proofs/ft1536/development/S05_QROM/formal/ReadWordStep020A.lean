import ReadSemantics020A
import BitValue020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ReadWordStep020A
open WordRAM020 WordArithmetic020 PairProgram020 ReadSemantics020A BitValue020A

def body (base : Expr) : Code := seqs [
  set 4 (sub (r 4) (lit 1)),
  .atom (.loadBit 6 (add base (r 4))),
  set 5 (add (mul (r 5) (lit 2)) (r 6))]

/-- Actual reader body from020, including its load and address check. -/
theorem body_step (i : Input) (s : State) (base : Expr) (b n a : Nat)
    (hbase : eval s base=word b) (hb4 : (4 : Reg) ∉ reads base)
    (h4 : s.reg 4=word ((n+1 : Nat) : Int)) (h5 : s.reg 5=word a)
    (hn : n<384) (ha : a<2^384) (haddr : b+n<tapeSize) :
    exec i (body base) s =
      put (put (put s 4 (word n)) 6 (word (bit (tapeBits i (b+n)))))
        5 (word ((2*a+bit (tapeBits i (b+n)) : Nat) : Int)) := by
  have nf : Fits (n : Int) := tiny_fits (by omega)
  have nsf : Fits ((n+1 : Nat) : Int) := tiny_fits (by omega)
  have bf : Fits (b : Int) := tiny_fits (by simp only [tapeSize] at haddr; omega)
  have af : Fits (a : Int) := nat_fits (lt_trans ha (by norm_num))
  have a2f : Fits ((2*a : Nat) : Int) := nat_fits (by omega)
  have one : Fits (1 : Int) := by norm_num [Fits]
  have two : Fits (2 : Int) := by norm_num [Fits]
  have bitf : Fits ((bit (tapeBits i (b+n)) : Nat) : Int) := tiny_fits (by have := bit_le (tapeBits i (b+n)); omega)
  have dec : eval s (sub (r 4) (lit 1))=word n := by
    change op .sub (s.reg 4) (word 1)=_
    rw [h4,sub_word _ _ nsf one]
    simp only [Nat.cast_add,Nat.cast_one,add_sub_cancel_right]
  let s1 := put s 4 (word n)
  let v := bit (tapeBits i (b+n))
  let s2 := put s1 6 (word v)
  have base1 : eval s1 base=word b := (eval_put s base 4 (word n) hb4).trans hbase
  have adr : eval s1 (add base (r 4))=word ((b+n : Nat) : Int) := by
    change op .add (eval s1 base) (s1.reg 4)=_
    rw [base1,put_same]
    exact add_word _ _ bf nf
  have addressWidth : ((b+n : Nat) : Int)<2^511 := by
    exact_mod_cast (lt_trans haddr (show tapeSize<2^511 by norm_num [tapeSize]))
  have ld : exec i (.atom (.loadBit 6 (add base (r 4)))) s1=s2 := by
    rw [exec_bit,adr,address_exact tapeSize (b+n) haddr addressWidth]
    change put s1 6 (if i.tape ⟨b+n,haddr⟩ then 1 else 0)=put s1 6 (word v)
    have ht := tapeBits_at i (⟨b+n,haddr⟩ : Fin tapeSize)
    dsimp [v]
    rw [ht]
    cases i.tape ⟨b+n,haddr⟩ <;> rfl
  have s2a : s2.reg 5=word a := by
    dsimp [s2,s1]
    rw [put_other _ 6 5 _ (by decide),put_other _ 4 5 _ (by decide),h5]
  have s2v : s2.reg 6=word v := put_same s1 6 (word v)
  have acc : eval s2 (add (mul (r 5) (lit 2)) (r 6))=word ((2*a+v : Nat) : Int) := by
    change op .add (op .mul (s2.reg 5) (word 2)) (s2.reg 6)=_
    rw [s2a,s2v,mul_word _ _ af two]
    have he : (a : Int)*2=((2*a : Nat) : Int) := by push_cast; ring
    rw [he,add_word _ _ a2f bitf]
    rfl
  simp only [body,exec_seqs_cons,exec_seqs_nil,exec_set,dec]
  change put (exec i (.atom (.loadBit 6 (add base (r 4)))) s1) 5
    (eval (exec i (.atom (.loadBit 6 (add base (r 4)))) s1) _) = _
  rw [ld,acc]

end FT1536.S05.ReadWordStep020A
