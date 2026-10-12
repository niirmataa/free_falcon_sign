import CdfPrefix020A
import PairArithmetic020B

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.NormFinish020C
open WordRAM020 PairProgram020 ReadSemantics020A WordArithmetic020
open CdfPrefix020A PairArithmetic020B

def tailCode : Code := seqs [
  .branch (lt (r 16) (lit 2093922385)) (set 20 (lit 1)) skip,inc 0]
def finish (s : State) (n : Nat) (a : Int) : State :=
  put (if a<2093922385 then put s 20 (word 1) else s) 0 (nw (n+1))

theorem tail_correct (i : Input) (s : State) (n : Nat) (a : Int) (hn : n<196)
    (ha : 0≤a ∧ a≤1536*(3*65535^2))
    (h0 : s.reg 0=nw n) (h16 : s.reg 16=word a) :
    exec i tailCode s=finish s n a := by
  have fa : Fits a := bounded_fits _ (by omega) (by omega)
  have fb : Fits 2093922385 := bounded_fits _ (by norm_num) (by norm_num)
  have fn : Fits (n:Int) := bounded_fits _ (by omega) (by omega)
  have f1 : Fits 1 := bounded_fits _ (by norm_num) (by norm_num)
  have gate : eval s (lt (r 16) (lit 2093922385))=word (if a<2093922385 then 1 else 0) := by
    change op .lt (s.reg 16) (word 2093922385)=_
    rw [h16,lt_word _ _ fa fb]
  have inc0 (q : State) (hq : q.reg 0=nw n) : eval q (add (r 0) (lit 1))=nw (n+1) := by
    change op .add (q.reg 0) (word 1)=_
    rw [hq,add_word _ _ fn f1]
    rfl
  have evalOne (q : State) : eval q (lit 1)=word 1 := rfl
  simp only [tailCode,exec_seqs_cons,exec_seqs_nil,exec_branch,gate]
  by_cases h : a<2093922385
  · rw [ite_eq_left h,ite_eq_right (show word 1≠0 by decide)]
    simp only [exec_set,evalOne,inc]
    rw [inc0 _ ((put_other s 20 0 (word 1) (by decide)).trans h0)]
    simp only [finish,ite_eq_left h]
  · rw [ite_eq_right h,ite_eq_left (show word 0=0 by rfl),exec_skip]
    simp only [inc,exec_set,inc0 s h0,finish,ite_eq_right h]

theorem finish_counter (s : State) (n : Nat) (a : Int) :
    (finish s n a).reg 0=nw (n+1) := put_same _ _ _

theorem finish_memory (s : State) (n : Nat) (a : Int) :
    (finish s n a).ram=s.ram ∧ (finish s n a).out=s.out ∧ (finish s n a).fault=s.fault := by
  unfold finish
  split <;> exact ⟨rfl,rfl,rfl⟩

theorem finish_flag (s : State) (n : Nat) (a : Int) (h20 : s.reg 20=0) :
    (finish s n a).reg 20=if a<2093922385 then word 1 else 0 := by
  unfold finish
  split
  · rw [put_other _ 0 20 _ (by decide),put_same]
  · rw [put_other _ 0 20 _ (by decide),h20]

end FT1536.S05.NormFinish020C
