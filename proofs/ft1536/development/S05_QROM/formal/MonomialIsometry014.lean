import CoefficientGram013

set_option maxRecDepth 32768

/- Q-SAMPLER obligation: exact multiplication by X preserves Geometry.Q0.
   The wrap at degree1536 is the A2 rotation, not a signed cyclic shift. -/
namespace FT1536.S05.MonomialIsometry014
open Polynomial Finset
open FT1536.Geometry FT1536.Run2.CoefficientQuotient

noncomputable def root : FT1536.Run2.CoefficientQuotient.Q ℤ := AdjoinRoot.root (phi ℤ)

theorem root_relation : root^1536=root^768-1 := by
  have h := AdjoinRoot.mk_self (f := phi ℤ)
  change AdjoinRoot.mk (phi ℤ) (X^1536-X^768+1)=0 at h
  rw [map_add,map_sub,map_pow,map_pow,map_one,AdjoinRoot.mk_X] at h
  change root^1536-root^768+1=0 at h
  calc
    _ = (root^1536-root^768+1)+(root^768-1) := by ring
    _ = _ := by rw [h,zero_add]

theorem quotient_sum (v : Vec) :
    toQuot v=∑ i : Fin 768, ((v i).1*root^i.val+(v i).2*root^(i.val+768)) := by
  unfold toQuot polynomial
  rw [map_sum]
  apply sum_congr rfl
  intro i _
  simp only [map_add,map_mul,map_pow,AdjoinRoot.mk_C,AdjoinRoot.mk_X]
  have lo := map_intCast (AdjoinRoot.of (phi ℤ)) (v i).1
  have hi := map_intCast (AdjoinRoot.of (phi ℤ)) (v i).2
  simp only [Int.cast_id] at lo hi
  rw [lo,hi]
  rfl

def shift (v : Vec) : Vec :=
  Fin.cons (-(v (Fin.last 767)).2,(v (Fin.last 767)).1+(v (Fin.last 767)).2)
    (fun i : Fin 767 => v i.castSucc)

theorem rotation_block (x y : ℤ) : block (-y) (x+y)=block x y := by
  unfold block
  ring

theorem Q0_shift (v : Vec) : Q0 (shift v)=Q0 v := by
  unfold Q0
  rw [Fin.sum_univ_succ,Fin.sum_univ_castSucc (f := fun i : Fin 768 => block (v i).1 (v i).2)]
  simp only [shift,Fin.cons_zero,Fin.cons_succ,rotation_block]
  exact add_comm _ _

theorem quotient_shift (v : Vec) : toQuot (shift v)=root*toQuot v := by
  rw [quotient_sum,quotient_sum]
  rw [Fin.sum_univ_succ,Fin.sum_univ_castSucc (f := fun i : Fin 768 =>
    (v i).1*root^i.val+(v i).2*root^(i.val+768))]
  simp only [shift,Fin.cons_zero,Fin.cons_succ,Fin.val_zero,Fin.val_succ,Fin.val_castSucc,
    Fin.val_last,pow_zero,mul_one,zero_add,Int.cast_neg,Int.cast_add]
  rw [mul_add,mul_sum]
  have term (i : Fin 767) :
      (v i.castSucc).1*root^(i.val+1)+(v i.castSucc).2*root^(i.val+1+768)=
      root*((v i.castSucc).1*root^i.val+(v i.castSucc).2*root^(i.val+768)) := by
    rw [show i.val+1+768=(i.val+768)+1 by omega,pow_succ,pow_succ]
    ring
  simp_rw [term]
  have last : root*((v (Fin.last 767)).1*root^767+(v (Fin.last 767)).2*root^(767+768))=
      -(v (Fin.last 767)).2+((v (Fin.last 767)).1+(v (Fin.last 767)).2)*root^768 := by
    have h1 : root*root^767=root^768 := by rw [← pow_succ']
    have h2 : root*root^(767+768)=root^1536 := by rw [← pow_succ']
    calc
      _ = (v (Fin.last 767)).1*(root*root^767)+(v (Fin.last 767)).2*(root*root^(767+768)) := by ring
      _ = _ := by rw [h1,h2,root_relation]; ring
  rw [last]
  ring

def shifted : ℕ → Vec → Vec
  | 0,v => v
  | n+1,v => shift (shifted n v)

theorem quotient_shifted (n : ℕ) (v : Vec) : toQuot (shifted n v)=root^n*toQuot v := by
  induction n with
  | zero => simp [shifted]
  | succ n ih => rw [shifted,quotient_shift,ih,pow_succ']; ring

theorem Q0_shifted (n : ℕ) (v : Vec) : Q0 (shifted n v)=Q0 v := by
  induction n with
  | zero => rfl
  | succ n ih => rw [shifted,Q0_shift,ih]

def unitVec (high : Bool) (j : Fin 768) : Vec :=
  fun i => if i=j then (if high then (0,1) else (1,0)) else (0,0)

theorem quotient_unit (high : Bool) (j : Fin 768) :
    toQuot (unitVec high j)=root^(j.val+if high then 768 else 0) := by
  rw [quotient_sum]
  rw [sum_eq_single j]
  · cases high <;> simp [unitVec]
  · intro i _ hi
    simp [unitVec,hi]
  · simp

theorem multiply_unit (v : Vec) (high : Bool) (j : Fin 768) :
    multiply v (unitVec high j)=shifted (j.val+if high then 768 else 0) v := by
  apply toQuot_injective ℤ
  rw [toQuot_multiply,quotient_unit,quotient_shifted,mul_comm]

theorem Q0_multiply_unit (v : Vec) (high : Bool) (j : Fin 768) :
    Q0 (multiply v (unitVec high j))=Q0 v := by
  rw [multiply_unit,Q0_shifted]

#print axioms root_relation
#print axioms quotient_sum
#print axioms rotation_block
#print axioms Q0_shift
#print axioms quotient_shift
#print axioms quotient_shifted
#print axioms Q0_shifted
#print axioms quotient_unit
#print axioms multiply_unit
#print axioms Q0_multiply_unit
end FT1536.S05.MonomialIsometry014
