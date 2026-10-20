import Source3.KeygenPublicRootTree

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Original-polynomial invariant of the exact recursively folded public
   row/stage images. The final blocks are still before the source triple. -/
namespace FT1536.Source3.KeygenPublicRadixPolynomial
open Polynomial Finset
open KeygenPublicAlgebra (R)
open KeygenPublicRadixStages (size count image)
open KeygenPublicRootTree (twiddle nodeRoot)
open KeygenPublicSplitPolynomial (polynomial lowPolynomial highPolynomial)
open FT1536.Run2

def split (a : Nat → R) (m h j k : Nat) : R :=
  if k<h then KeygenPublicRadixFold.low a (j*(2*h)) h (KeygenPublicRadixRow.root m j) k
  else KeygenPublicRadixFold.high a (j*(2*h)) h (KeygenPublicRadixRow.root m j) (k-h)
def Invariant (f : Polynomial R) (a : Nat → R) (k : Nat) : Prop :=
  ∀ j<count k, ∀ z : R, z^size k=nodeRoot k j → f.eval z=(polynomial a (j*size k) (size k)).eval z

theorem rows_values (a : Nat → R) (m h n : Nat) : ∀ b k, k<2*h →
    KeygenPublicRadixRows.image a m h n (b*(2*h)+k)=
      if b<n then split a m h b k else a (b*(2*h)+k) := by
  induction n with
  | zero => intro b k hk; simp only [KeygenPublicRadixRows.image,Nat.not_lt_zero,ite_false]
  | succ n ih =>
      intro b k hk
      rw [KeygenPublicRadixRows.image]
      by_cases equal : b=n
      · subst b
        by_cases low : k<h
        · rw [KeygenPublicRadixFold.image_low _ (n*(2*h)) h h k _ low]
          unfold KeygenPublicRadixFold.low
          rw [ih n k hk]
          have highValue := ih n (h+k) (by omega)
          rw [← Nat.add_assoc] at highValue
          rw [highValue]
          simp only [Nat.lt_irrefl,ite_false,Nat.lt_succ_self,ite_true,split,low,KeygenPublicRadixFold.low]
        · have idx : n*(2*h)+k=n*(2*h)+h+(k-h) := by omega
          rw [idx,KeygenPublicRadixFold.image_high _ (n*(2*h)) h h (k-h) _ (by omega) (by omega)]
          unfold KeygenPublicRadixFold.high
          rw [ih n (k-h) (by omega)]
          have highValue := ih n (h+(k-h)) (by omega)
          rw [← Nat.add_assoc] at highValue
          rw [highValue]
          simp only [Nat.lt_irrefl,ite_false,Nat.lt_succ_self,ite_true,split,low,KeygenPublicRadixFold.high]
      · have outside : ¬(n*(2*h)≤b*(2*h)+k ∧ b*(2*h)+k<n*(2*h)+h) ∧
            ¬(n*(2*h)+h≤b*(2*h)+k ∧ b*(2*h)+k<n*(2*h)+h+h) := by
          rcases Nat.lt_or_gt_of_ne equal with earlier | later
          · have mul := Nat.mul_le_mul_right (2*h) (show b+1≤n by omega)
            rw [Nat.add_mul,Nat.one_mul] at mul
            constructor <;> omega
          · have mul := Nat.mul_le_mul_right (2*h) (show n+1≤b by omega)
            rw [Nat.add_mul,Nat.one_mul] at mul
            constructor <;> omega
        simp only [KeygenPublicRadixFold.image,outside.1,outside.2,ite_false]
        rw [ih b k hk]
        have same : (b<n) ↔ b<n+1 := by omega
        simp only [same]

theorem low_row (a : Nat → R) (m h j : Nat) (hj : j<m) :
    polynomial (KeygenPublicRadixRows.image a m h m) ((2*j)*h) h=
      lowPolynomial a (j*(2*h)) h (KeygenPublicRadixRow.root m j) := by
  have base : (2*j)*h=j*(2*h) := by ring
  rw [base]
  unfold lowPolynomial polynomial
  apply sum_congr rfl
  intro k hk
  have bound := mem_range.mp hk
  have value := rows_values a m h m j k (by omega)
  simp only [hj,ite_true,split,bound,Nat.zero_add] at value ⊢
  rw [value]
theorem high_row (a : Nat → R) (m h j : Nat) (hj : j<m) :
    polynomial (KeygenPublicRadixRows.image a m h m) ((2*j+1)*h) h=
      highPolynomial a (j*(2*h)) h (KeygenPublicRadixRow.root m j) := by
  have base : (2*j+1)*h=j*(2*h)+h := by ring
  rw [base]
  unfold highPolynomial polynomial
  apply sum_congr rfl
  intro k hk
  have bound := mem_range.mp hk
  have value := rows_values a m h m j (h+k) (by omega)
  simp only [hj,ite_true,split,show ¬h+k<h from by omega,ite_false,Nat.add_sub_cancel_left] at value
  simp only [Nat.zero_add,Nat.add_assoc]
  rw [value]

theorem polynomial_of_coefficients (a : Nat → R) (base n : Nat) (f : Polynomial R)
    (degree : f.degree<n) (equal : ∀ i<n, a (base+i)=f.coeff i) : polynomial a base n=f := by
  apply Polynomial.ext
  intro i
  by_cases hi : i<n
  · rw [KeygenPublicSplitPolynomial.coefficient a base n i hi]; exact equal i hi
  · rw [(degree_lt_iff_coeff_zero _ n).mp (KeygenPublicSplitPolynomial.degree_bound a base n) i (by omega),
      (degree_lt_iff_coeff_zero _ n).mp degree i (by omega)]

theorem first_low (v : Geometry.Vec) :
    polynomial (KeygenPublicFirstFold.image v 768) 0 768=KeygenPublicFirstFold.lowP v := by
  apply polynomial_of_coefficients
  · exact KeygenPublicFirstPolynomial.low_degree _ _
  · intro i hi
    simp only [Nat.zero_add]
    exact KeygenPublicFirstFold.image_low v 768 i hi hi
theorem first_high (v : Geometry.Vec) :
    polynomial (KeygenPublicFirstFold.image v 768) 768 768=KeygenPublicFirstFold.highP v := by
  apply polynomial_of_coefficients
  · exact KeygenPublicFirstPolynomial.low_degree _ _
  · intro i hi
    rw [KeygenPublicFirstFold.image_high v 768 (768+i) (by omega) (by omega)]
    rw [Nat.add_sub_cancel_left]
theorem first_invariant (v : Geometry.Vec) :
    Invariant (CoefficientQuotient.polynomial (Relation.reduceVec v)) (KeygenPublicFirstFold.image v 768) 0 := by
  intro j hj z power
  change j<2 at hj
  interval_cases j
  · change z^768=nodeRoot 0 0 at power
    rw [KeygenPublicRootTree.top_low] at power
    change _=(polynomial _ 0 768).eval z
    rw [first_low]
    exact KeygenPublicFirstPolynomial.eval_original _ _ z power
  · change z^768=nodeRoot 0 1 at power
    rw [KeygenPublicRootTree.top_high] at power
    change _=(polynomial _ 768 768).eval z
    rw [first_high]
    exact KeygenPublicFirstPolynomial.eval_original _ _ z power

theorem next_invariant (f : Polynomial R) (a : Nat → R) (k : Nat) (hk : k<8)
    (input : Invariant f a k) :
    Invariant f (KeygenPublicRadixRows.image a (count k) (size k/2) (count k)) (k+1) := by
  intro b hb z power
  obtain ⟨_,_,_,halves,nextSize,nextCount,_⟩ := KeygenPublicRadixStages.dimensions k hk
  have parentBound : b/2<count k := by rw [nextCount] at hb; omega
  have shape : b=2*(b/2) ∨ b=2*(b/2)+1 := by omega
  obtain ⟨childLow,childHigh⟩ := KeygenPublicRootTree.children k (b/2) hk parentBound
  rcases shape with equal | equal
  · rw [equal,nextSize,childLow] at power
    have parent : z^size k=nodeRoot k (b/2) := by
      rw [halves,Nat.mul_comm 2 (size k/2),pow_mul,power,KeygenPublicRootTree.parent_square k (b/2) hk]
    have evaluated := (input (b/2) parentBound z parent).trans
      (show (polynomial a ((b/2)*size k) (size k)).eval z=
        (lowPolynomial a ((b/2)*size k) (size k/2) (twiddle k (b/2))).eval z from by
        have law := KeygenPublicSplitPolynomial.eval_low a ((b/2)*size k) (size k/2) (twiddle k (b/2)) z power
        rw [← halves] at law
        exact law)
    rw [equal,nextSize,low_row a (count k) (size k/2) (b/2) parentBound]
    rw [← halves]
    exact evaluated
  · rw [equal,nextSize,childHigh] at power
    have parent : z^size k=nodeRoot k (b/2) := by
      rw [halves,Nat.mul_comm 2 (size k/2),pow_mul,power,KeygenPublicRootTree.parent_square k (b/2) hk]
      ring
    have evaluated := (input (b/2) parentBound z parent).trans
      (show (polynomial a ((b/2)*size k) (size k)).eval z=
        (highPolynomial a ((b/2)*size k) (size k/2) (twiddle k (b/2))).eval z from by
        have law := KeygenPublicSplitPolynomial.eval_high a ((b/2)*size k) (size k/2) (twiddle k (b/2)) z power
        rw [← halves] at law
        exact law)
    rw [equal,nextSize,high_row a (count k) (size k/2) (b/2) parentBound]
    rw [← halves]
    exact evaluated

theorem stages_invariant (v : Geometry.Vec) (k : Nat) (hk : k≤8) :
    Invariant (CoefficientQuotient.polynomial (Relation.reduceVec v))
      (image (KeygenPublicFirstFold.image v 768) k) k := by
  induction k with
  | zero => exact first_invariant v
  | succ k ih => exact next_invariant _ _ k (by omega) (ih (by omega))

theorem original_block (v : Geometry.Vec) (i : Fin 1536) :
    (polynomial (KeygenPublicRadixEntry.radixImage v) (3*(i.val/3)) 3).eval (KeygenPublicRoots.point i)=
      (CoefficientQuotient.polynomial (Relation.reduceVec v)).eval (KeygenPublicRoots.point i) := by
  have hi := i.isLt
  have index : (⟨3*(i.val/3)+i.val%3,by omega⟩ : Fin 1536)=i := by apply Fin.ext; dsimp; omega
  have power := KeygenPublicRootTree.leaf_power (i.val/3) (i.val%3) (by omega) (by omega)
  rw [index] at power
  have value := stages_invariant v 8 (by decide) (i.val/3) (by change i.val/3<512; omega) (KeygenPublicRoots.point i) power
  change _=(polynomial (KeygenPublicRadixEntry.radixImage v) ((i.val/3)*3) 3).eval _ at value
  rw [Nat.mul_comm (i.val/3) 3] at value
  exact value.symm

end FT1536.Source3.KeygenPublicRadixPolynomial
