import Source3.KeygenPublicInverseTriplePolynomial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Unnormalized block-polynomial reconstruction in the public field.
   These laws apply to the explicitly derived source row/stage image. -/
namespace FT1536.Source3.KeygenPublicReversePolynomial
open Polynomial Finset
open KeygenPublicAlgebra (R)
open KeygenPublicSplitPolynomial (polynomial)

def merge (a : Nat → R) (m h j k : Nat) : R :=
  if k<h then KeygenPublicReverseFold.low a (j*(2*h)) h k
  else KeygenPublicReverseFold.high a (j*(2*h)) h (KeygenPublicReverseRow.root m j) (k-h)

theorem rows_values (a : Nat → R) (m h n : Nat) : ∀ b k, k<2*h →
    KeygenPublicReverseRows.image a m h n (b*(2*h)+k)=
      if b<n then merge a m h b k else a (b*(2*h)+k) := by
  induction n with
  | zero => intro b k hk; simp only [KeygenPublicReverseRows.image,Nat.not_lt_zero,ite_false]
  | succ n ih =>
      intro b k hk
      rw [KeygenPublicReverseRows.image]
      by_cases equal : b=n
      · subst b
        by_cases low : k<h
        · rw [KeygenPublicReverseFold.image_low _ (n*(2*h)) h h k _ low]
          unfold KeygenPublicReverseFold.low
          rw [ih n k hk]
          have highValue := ih n (h+k) (by omega)
          rw [← Nat.add_assoc] at highValue
          rw [highValue]
          simp only [Nat.lt_irrefl,ite_false,Nat.lt_succ_self,ite_true,merge,low,KeygenPublicReverseFold.low]
        · have idx : n*(2*h)+k=n*(2*h)+h+(k-h) := by omega
          rw [idx,KeygenPublicReverseFold.image_high _ (n*(2*h)) h h (k-h) _ (by omega) (by omega)]
          unfold KeygenPublicReverseFold.high
          rw [ih n (k-h) (by omega)]
          have highValue := ih n (h+(k-h)) (by omega)
          rw [← Nat.add_assoc] at highValue
          rw [highValue]
          simp only [Nat.lt_irrefl,ite_false,Nat.lt_succ_self,ite_true,merge,low,KeygenPublicReverseFold.high]
      · have outside : ¬(n*(2*h)≤b*(2*h)+k ∧ b*(2*h)+k<n*(2*h)+h) ∧
            ¬(n*(2*h)+h≤b*(2*h)+k ∧ b*(2*h)+k<n*(2*h)+h+h) := by
          rcases Nat.lt_or_gt_of_ne equal with earlier | later
          · have mul := Nat.mul_le_mul_right (2*h) (show b+1≤n by omega)
            rw [Nat.add_mul,Nat.one_mul] at mul
            constructor <;> omega
          · have mul := Nat.mul_le_mul_right (2*h) (show n+1≤b by omega)
            rw [Nat.add_mul,Nat.one_mul] at mul
            constructor <;> omega
        simp only [KeygenPublicReverseFold.image,outside.1,outside.2,ite_false]
        rw [ih b k hk]
        have same : (b<n) ↔ b<n+1 := by omega
        simp only [same]

theorem low_row (a : Nat → R) (m h j : Nat) (hj : j<m) :
    polynomial (KeygenPublicReverseRows.image a m h m) (j*(2*h)) h=
      polynomial a (j*(2*h)) h+polynomial a (j*(2*h)+h) h := by
  unfold polynomial
  rw [← sum_add_distrib]
  apply sum_congr rfl
  intro k hk
  have bound := mem_range.mp hk
  rw [rows_values a m h m j k (by omega)]
  simp only [hj,ite_true,merge,bound,KeygenPublicReverseFold.low,Nat.add_assoc]
  simp only [map_add]
  ring
theorem high_row (a : Nat → R) (m h j : Nat) (hj : j<m) :
    polynomial (KeygenPublicReverseRows.image a m h m) (j*(2*h)+h) h=
      C (KeygenPublicReverseRow.root m j)*(polynomial a (j*(2*h)) h-polynomial a (j*(2*h)+h) h) := by
  unfold polynomial
  rw [← sum_sub_distrib,mul_sum]
  apply sum_congr rfl
  intro k hk
  have bound := mem_range.mp hk
  have val := rows_values a m h m j (h+k) (by omega)
  simp only [hj,ite_true,merge,show ¬h+k<h from by omega,ite_false,Nat.add_sub_cancel_left,
    KeygenPublicReverseFold.high,Nat.add_assoc] at val
  simp only [Nat.add_assoc]
  rw [val]
  simp only [map_sub,map_mul]
  ring
theorem reconstruction (a : Nat → R) (m h j : Nat) (hj : j<m) :
    polynomial (KeygenPublicReverseRows.image a m h m) (j*(2*h)) (2*h)=
      polynomial a (j*(2*h)) h+polynomial a (j*(2*h)+h) h+
        X^h*C (KeygenPublicReverseRow.root m j)*(polynomial a (j*(2*h)) h-polynomial a (j*(2*h)+h) h) := by
  rw [KeygenPublicSplitPolynomial.split_halves,low_row a m h j hj,high_row a m h j hj]
  ring

theorem inverse_root (m j : Nat) :
    KeygenPublicReverseRow.root m j=(KeygenPublicRadixRow.root m j)⁻¹ := by
  rw [KeygenPublicReverseRow.root,KeygenPublicInverseTables.rootAt,inv_pow]
  rfl
theorem root_nonzero (m j : Nat) : KeygenPublicRadixRow.root m j≠0 :=
  pow_ne_zero _ KeygenPublicInverseTriplePolynomial.root_nonzero

theorem eval_low (a : Nat → R) (m h j : Nat) (hj : j<m) (z : R)
    (power : z^h=KeygenPublicRadixRow.root m j) :
    (polynomial (KeygenPublicReverseRows.image a m h m) (j*(2*h)) (2*h)).eval z=
      2*(polynomial a (j*(2*h)) h).eval z := by
  rw [reconstruction a m h j hj]
  simp only [eval_add,eval_mul,eval_pow,eval_X,eval_C,eval_sub,power,inverse_root]
  rw [mul_assoc (KeygenPublicRadixRow.root m j),mul_inv_cancel_left₀ (root_nonzero m j)]
  ring
theorem eval_high (a : Nat → R) (m h j : Nat) (hj : j<m) (z : R)
    (power : z^h= -KeygenPublicRadixRow.root m j) :
    (polynomial (KeygenPublicReverseRows.image a m h m) (j*(2*h)) (2*h)).eval z=
      2*(polynomial a (j*(2*h)+h) h).eval z := by
  rw [reconstruction a m h j hj]
  simp only [eval_add,eval_mul,eval_pow,eval_X,eval_C,eval_sub,power,inverse_root,neg_mul]
  rw [mul_assoc (KeygenPublicRadixRow.root m j),mul_inv_cancel_left₀ (root_nonzero m j)]
  ring

end FT1536.Source3.KeygenPublicReversePolynomial
