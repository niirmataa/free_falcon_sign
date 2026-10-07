import Source3.KeygenNttTwiddleTree
import Source3.KeygenNttSubpolynomial
import Source3.KeygenNttExecution

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Polynomial evaluation is propagated through the same source-ordered
   block updates already bound to the complete forward execution. -/
namespace FT1536.Source3.KeygenNttRoundPolynomial
open Polynomial Finset
open KeygenNttWordAlgebra (R)
open KeygenNttGeometry (m t ht)
open KeygenNttMiddleValues (root blocks rounds)
open KeygenNttSubpolynomial (polynomial lowPolynomial highPolynomial)
open KeygenNttTwiddleTree (nodeRoot)
open KeygenNttPolynomial (Coeff coefficient)
open KeygenNttFirstValues (firstRoot)
open FT1536.Run2

def splitValue (a : Nat → R) (i j k : Nat) : R :=
  if k<ht i then KeygenNttBinaryValues.low a (j*t i) (ht i) (root i j) k
  else KeygenNttBinaryValues.high a (j*t i) (ht i) (root i j) (k-ht i)
def firstArray (v : Coeff) : Nat → R := KeygenNttFirstValues.values (coefficient v) firstRoot
def Invariant (f : Polynomial R) (a : Nat → R) (i : Nat) : Prop :=
  ∀ j<m i, ∀ z : R, z^t i=nodeRoot i j → f.eval z=(polynomial a (j*t i) (t i)).eval z

theorem before_block (b j d k : Nat) (hj : b<j) (hk : k<d) : b*d+k<j*d := by
  have h := Nat.mul_le_mul_right d (show b+1≤j by omega)
  rw [Nat.add_mul,Nat.one_mul] at h
  omega

theorem after_block (b j d k : Nat) (hj : j<b) : j*d+d≤b*d+k := by
  have h := Nat.mul_le_mul_right d (show j+1≤b by omega)
  rw [Nat.add_mul,Nat.one_mul] at h
  omega

theorem blocks_values (a : Nat → R) (i : Nat) (hi : i≤7) (n : Nat) :
    ∀ j k, k<t i → blocks a i n (j*t i+k)=(if j<n then splitValue a i j k else a (j*t i+k)) := by
  have halves := (KeygenNttGeometry.active_halving i hi).1
  induction n with
  | zero => intro j k hk; simp only [blocks,Nat.not_lt_zero,ite_false]
  | succ n ih =>
      intro j k hk
      rw [blocks,KeygenNttMiddleValues.blockValues]
      by_cases earlier : j<n
      · have pos := before_block j n (t i) k earlier hk
        simp only [KeygenNttBinaryValues.values,pos,ite_true]
        rw [ih j k hk]
        simp only [earlier,show j<n+1 by omega,ite_true]
      · by_cases equal : j=n
        · subst j
          have p0 : ¬n*t i+k<n*t i := by omega
          by_cases low : k<ht i
          · have p1 : n*t i+k<n*t i+ht i := by omega
            simp only [KeygenNttBinaryValues.values,p0,ite_false,p1,ite_true,Nat.add_sub_cancel_left,
              Nat.lt_succ_self,splitValue,low]
            unfold KeygenNttBinaryValues.low
            simp only [Nat.add_assoc]
            rw [ih n k hk,ih n (ht i+k) (by omega)]
            simp only [Nat.lt_irrefl,ite_false]
          · have p1 : ¬n*t i+k<n*t i+ht i := by omega
            have p2 : n*t i+k<n*t i+2*ht i := by omega
            have difference : n*t i+k-(n*t i+ht i)=k-ht i := by omega
            simp only [KeygenNttBinaryValues.values,p0,p1,ite_false,p2,ite_true,difference,
              Nat.lt_succ_self,splitValue,low]
            unfold KeygenNttBinaryValues.high
            simp only [Nat.add_assoc]
            rw [ih n (k-ht i) (by omega),ih n (ht i+(k-ht i)) (by omega)]
            simp only [Nat.lt_irrefl,ite_false]
        · have pos := after_block j n (t i) k (by omega)
          have p0 : ¬j*t i+k<n*t i := by omega
          have p1 : ¬j*t i+k<n*t i+ht i := by omega
          have p2 : ¬j*t i+k<n*t i+2*ht i := by omega
          simp only [KeygenNttBinaryValues.values,p0,p1,p2,ite_false]
          rw [ih j k hk]
          simp only [earlier,show ¬j<n+1 by omega,ite_false]

theorem low_round (a : Nat → R) (i j : Nat) (hi : i≤7) (hj : j<m i) :
    polynomial (blocks a i (m i)) ((2*j)*ht i) (ht i)=lowPolynomial a (j*t i) (ht i) (root i j) := by
  have halves := (KeygenNttGeometry.active_halving i hi).1
  have base : (2*j)*ht i=j*t i := by rw [halves]; ring
  rw [base]
  unfold lowPolynomial polynomial
  apply sum_congr rfl
  intro k hk
  have bound := mem_range.mp hk
  have values := blocks_values a i hi (m i) j k (by omega)
  simp only [hj,ite_true,splitValue,bound,Nat.zero_add] at values ⊢
  rw [values]

theorem high_round (a : Nat → R) (i j : Nat) (hi : i≤7) (hj : j<m i) :
    polynomial (blocks a i (m i)) ((2*j+1)*ht i) (ht i)=highPolynomial a (j*t i) (ht i) (root i j) := by
  have halves := (KeygenNttGeometry.active_halving i hi).1
  have base : (2*j+1)*ht i=j*t i+ht i := by rw [halves]; ring
  rw [base]
  unfold highPolynomial polynomial
  apply sum_congr rfl
  intro k hk
  have bound := mem_range.mp hk
  have values := blocks_values a i hi (m i) j (ht i+k) (by omega)
  have high : ¬ht i+k<ht i := by omega
  simp only [hj,ite_true,splitValue,high,ite_false,Nat.add_sub_cancel_left] at values
  simp only [Nat.zero_add,Nat.add_assoc]
  rw [values]

theorem half_of_cells (a : Nat → R) (base : Nat) (b : Fin 768 → R)
    (equal : ∀ k (hk : k<768), a (base+k)=b ⟨k,hk⟩) :
    polynomial a base 768=KeygenNttPolynomial.halfPolynomial b := by
  apply Polynomial.ext
  intro k
  by_cases hk : k<768
  · rw [KeygenNttSubpolynomial.coefficient a base 768 k hk,
      KeygenNttPolynomial.half_coefficient b ⟨k,hk⟩]
    exact equal k hk
  · rw [(degree_lt_iff_coeff_zero _ 768).mp (KeygenNttSubpolynomial.degree_bound a base 768) k (by omega),
      (degree_lt_iff_coeff_zero _ 768).mp (KeygenNttPolynomial.half_degree b) k (by omega)]

theorem first_low (v : Coeff) : polynomial (firstArray v) 0 768=KeygenNttPolynomial.lowPolynomial v firstRoot := by
  apply half_of_cells
  intro k hk
  simp only [firstArray,KeygenNttFirstValues.values,Nat.zero_add,hk,ite_true,KeygenNttFirstValues.low]
  rw [KeygenNttPolynomial.coefficient_low v ⟨k,hk⟩,KeygenNttPolynomial.coefficient_high v ⟨k,hk⟩]

theorem first_high (v : Coeff) : polynomial (firstArray v) 768 768=KeygenNttPolynomial.highPolynomial v firstRoot := by
  apply half_of_cells
  intro k hk
  have high : ¬768+k<768 := by omega
  simp only [firstArray,KeygenNttFirstValues.values,high,ite_false,Nat.add_sub_cancel_left,KeygenNttFirstValues.high]
  rw [KeygenNttPolynomial.coefficient_low v ⟨k,hk⟩,KeygenNttPolynomial.coefficient_high v ⟨k,hk⟩]

theorem first_invariant (v : Coeff) : Invariant (CoefficientQuotient.polynomial v) (firstArray v) 0 := by
  intro j hj z power
  change j<2 at hj
  interval_cases j
  · change z^768=nodeRoot 0 0 at power
    rw [KeygenNttTwiddleTree.top_low] at power
    change _=(polynomial (firstArray v) 0 768).eval z
    rw [first_low]
    exact KeygenNttPolynomial.eval_low v firstRoot z power
  · change z^768=nodeRoot 0 1 at power
    rw [KeygenNttTwiddleTree.top_high] at power
    change _=(polynomial (firstArray v) 768 768).eval z
    rw [first_high]
    exact KeygenNttPolynomial.eval_high v firstRoot z power

theorem next_invariant (f : Polynomial R) (a : Nat → R) (i : Nat) (hi : i≤7)
    (input : Invariant f a i) : Invariant f (blocks a i (m i)) (i+1) := by
  intro b hb z power
  have next := KeygenNttGeometry.next_header i
  have halves := (KeygenNttGeometry.active_halving i hi).1
  have parentBound : b/2<m i := by rw [next.2] at hb; omega
  have shape : b=2*(b/2) ∨ b=2*(b/2)+1 := by omega
  obtain ⟨childLow,childHigh⟩ := KeygenNttTwiddleTree.children i (b/2) hi parentBound
  rcases shape with equal | equal
  · rw [equal,next.1,childLow] at power
    have parent : z^t i=nodeRoot i (b/2) := by
      rw [halves,Nat.mul_comm 2 (ht i),pow_mul,power,KeygenNttTwiddleTree.parent_square i (b/2) hi]
    have evaluated := (input (b/2) parentBound z parent).trans
      (show (polynomial a ((b/2)*t i) (t i)).eval z=(lowPolynomial a ((b/2)*t i) (ht i) (root i (b/2))).eval z from by
        rw [halves]
        exact KeygenNttSubpolynomial.eval_low a _ _ _ z power)
    rw [equal,next.1,low_round a i (b/2) hi parentBound]
    exact evaluated
  · rw [equal,next.1,childHigh] at power
    have parent : z^t i=nodeRoot i (b/2) := by
      rw [halves,Nat.mul_comm 2 (ht i),pow_mul,power,KeygenNttTwiddleTree.parent_square i (b/2) hi]
      ring
    have evaluated := (input (b/2) parentBound z parent).trans
      (show (polynomial a ((b/2)*t i) (t i)).eval z=(highPolynomial a ((b/2)*t i) (ht i) (root i (b/2))).eval z from by
        rw [halves]
        exact KeygenNttSubpolynomial.eval_high a _ _ _ z power)
    rw [equal,next.1,high_round a i (b/2) hi parentBound]
    exact evaluated

theorem rounds_invariant (v : Coeff) (i : Nat) (hi : i≤8) :
    Invariant (CoefficientQuotient.polynomial v) (rounds (firstArray v) i) i := by
  induction i with
  | zero => exact first_invariant v
  | succ i ih => exact next_invariant _ _ i (by omega) (ih (by omega))

theorem transform_evaluation (v : Coeff) (q : Fin 1536) :
    KeygenNttExecution.transform (coefficient v) q.val=(CoefficientQuotient.polynomial v).eval (KeygenNttRoots.point q) := by
  have hq := q.isLt
  have hj : q.val/3<512 := by omega
  have hk : q.val%3<3 := Nat.mod_lt _ (by decide)
  have index : (⟨3*(q.val/3)+q.val%3,by omega⟩ : Fin 1536)=q := by
    apply Fin.ext
    change 3*(q.val/3)+q.val%3=q.val
    omega
  have power := KeygenNttTwiddleTree.leaf_power (q.val/3) (q.val%3) hj hk
  rw [index] at power
  have evaluated := rounds_invariant v 8 (by decide) (q.val/3) hj (KeygenNttRoots.point q) power
  change _=(polynomial (rounds (firstArray v) 8) ((q.val/3)*3) 3).eval (KeygenNttRoots.point q) at evaluated
  rw [Nat.mul_comm (q.val/3) 3,KeygenNttSubpolynomial.triple_polynomial] at evaluated
  have point := KeygenNttRoots.triple_order (q.val/3) (q.val%3) hj hk
  rw [index] at point
  change KeygenNttCells.quadratic _ _ _ (KeygenNttTripleValues.root (q.val/3)*KeygenNttRoots.unity^(q.val%3))=_
  rw [KeygenNttTripleValues.root,← point]
  exact evaluated.symm

end FT1536.Source3.KeygenNttRoundPolynomial
