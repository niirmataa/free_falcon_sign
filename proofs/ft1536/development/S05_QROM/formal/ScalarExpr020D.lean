import Residue020D
import ReadSemantics020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ScalarExpr020D
open WordRAM020 PairProgram020 ReadSemantics020A WordArithmetic020 PairArithmetic020B Residue020D

theorem small_nat (a : Nat) (ha : a<100000) : Fits (a:Int) :=
  bounded_fits _ (by omega) (by omega)

theorem nat_lt (s : State) (rr : Reg) (a b : Nat) (ha : a<100000) (hb : b<100000)
    (hr : s.reg rr=word (a:Int)) :
    eval s (lt (r rr) (lit b))=word (if a<b then 1 else 0) := by
  change op .lt (s.reg rr) (word (b:Int))=_
  rw [hr,lt_word _ _ (small_nat a ha) (small_nat b hb)]
  simp only [Int.ofNat_lt]

theorem nat_sub (s : State) (rr : Reg) (a b : Nat) (ha : a<100000) (hb : b≤a)
    (hr : s.reg rr=word (a:Int)) :
    eval s (sub (r rr) (lit b))=word ((a-b:Nat):Int) := by
  change op .sub (s.reg rr) (word (b:Int))=_
  rw [hr,sub_word _ _ (small_nat a ha) (small_nat b (by omega))]
  apply congrArg word
  exact (Nat.cast_sub hb).symm

theorem negate_field (s : State) (rr : Reg) (c : F) (hr : s.reg rr=fw c) :
    eval s (sub (lit 0) (r rr))=word (-(c.val:Int)) := by
  change op .sub (word 0) (s.reg rr)=_
  rw [hr]
  change op .sub (word (0:Int)) (word (c.val:Int))=_
  rw [sub_word (0:Int) (c.val:Int) (show Fits (0:Int) from small_nat 0 (by decide)) (field_fits c)]
  simp only [zero_sub]

theorem inc_eval (s : State) (rr : Reg) (a : Nat) (ha : a<100000)
    (hr : s.reg rr=word (a:Int)) : eval s (add (r rr) (lit 1))=word ((a+1:Nat):Int) := by
  change op .add (s.reg rr) (word 1)=_
  rw [hr,add_word (a:Int) (1:Int) (small_nat a ha) (show Fits (1:Int) from small_nat 1 (by decide))]
  rfl

end FT1536.S05.ScalarExpr020D
