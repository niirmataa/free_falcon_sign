import PairArithmetic020B

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.PairAdvance020B
open WordRAM020 PairProgram020 ReadSemantics020A WordArithmetic020 PairArithmetic020B

def advance : Code := seqs [set 17 qExpr,set 16 (add (r 16) (r 17)),inc 1]
def nextState (s : State) (p : Nat) (a x y : Int) : State :=
  put (put (put s 17 (word (q2 x y))) 16 (word (a+q2 x y))) 1 (word ((p+1:Nat):Int))

theorem advance_correct (i : Input) (s : State) (p : Nat) (a x y : Int)
    (hp : p<1536) (ha : 0≤a ∧ a≤(p:Int)*(3*65535^2))
    (hx : -65535≤x ∧ x≤65535) (hy : -65535≤y ∧ y≤65535)
    (h1 : s.reg 1=word (p:Int)) (h16 : s.reg 16=word a)
    (h13 : s.reg 13=word x) (h14 : s.reg 14=word y) :
    exec i advance s=nextState s p a x y := by
  have pp : (p:Int)<1536 := by exact_mod_cast hp
  have fa : Fits a := bounded_fits _ (by omega) (by nlinarith)
  have hq := q2_bounds x y hx hy
  have fq : Fits (q2 x y) := bounded_fits _ (by omega) (by omega)
  have fp : Fits (p:Int) := bounded_fits _ (by omega) (by omega)
  have fone : Fits 1 := bounded_fits _ (by norm_num) (by norm_num)
  have evalAdd : eval (put s 17 (word (q2 x y))) (add (r 16) (r 17))=word (a+q2 x y) := by
    change op .add ((put s 17 (word (q2 x y))).reg 16) ((put s 17 (word (q2 x y))).reg 17)=_
    rw [put_other _ 17 16 _ (by decide),put_same,h16,add_word _ _ fa fq]
  have evalInc : eval (put (put s 17 (word (q2 x y))) 16 (word (a+q2 x y)))
      (add (r 1) (lit 1))=word ((p+1:Nat):Int) := by
    change op .add ((put (put s 17 (word (q2 x y))) 16 (word (a+q2 x y))).reg 1) (word 1)=_
    rw [put_other _ 16 1 _ (by decide),put_other _ 17 1 _ (by decide),h1,add_word _ _ fp fone]
    rfl
  simp only [advance,inc,exec_seqs_cons,exec_seqs_nil,exec_set,
    qExpr_correct s x y hx hy h13 h14,evalAdd,evalInc]
  rfl

theorem next_counter (s : State) (p : Nat) (a x y : Int) :
    (nextState s p a x y).reg 1=word ((p+1:Nat):Int) := put_same _ _ _

theorem next_norm (s : State) (p : Nat) (a x y : Int) :
    (nextState s p a x y).reg 16=word (a+q2 x y) := by
  unfold nextState
  rw [put_other _ 1 16 _ (by decide),put_same]

theorem next_frame (s : State) (p : Nat) (a x y : Int) : Frame s (nextState s p a x y) :=
  ⟨rfl,rfl,rfl⟩

theorem next_other (s : State) (p : Nat) (a x y : Int) (rr : Reg)
    (h1 : rr≠1) (h16 : rr≠16) (h17 : rr≠17) :
    (nextState s p a x y).reg rr=s.reg rr := by
  unfold nextState
  rw [put_other _ 1 rr _ h1,put_other _ 16 rr _ h16,put_other _ 17 rr _ h17]

end FT1536.S05.PairAdvance020B
