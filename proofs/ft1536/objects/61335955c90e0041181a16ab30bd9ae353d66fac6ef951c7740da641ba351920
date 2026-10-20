import Source3.KeygenPublicRootInverseFold
import Source3.KeygenPublicReverseReconstruction

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The exceptional inverse seed reconstructs the two physical top blocks
   with factor2. Combined with the derived reverse image the factor is1536. -/
namespace FT1536.Source3.KeygenPublicRootInversePolynomial
open Polynomial Finset
open KeygenPublicAlgebra (R)
open KeygenPublicSplitPolynomial (polynomial)
open KeygenPublicRoots (firstRoot point)
open KeygenPublicRootInverseFold (image low high)

noncomputable def inverseRoot : R := (2*firstRoot-1)⁻¹
noncomputable def rootImage (a : Nat → R) : Nat → R := image (KeygenPublicReverseEntry.reverseImage a) inverseRoot 768

theorem denominator_nonzero : (2*firstRoot-1 : R)≠0 := by
  intro zero
  have three : (3 : R)=0 := by
    linear_combination 4*KeygenPublicRoots.first_root_relation-(2*firstRoot-1)*zero
  exact (by decide : (3 : R)≠0) three
theorem inverse_cancel : inverseRoot*(2*firstRoot-1)=1 := inv_mul_cancel₀ denominator_nonzero

theorem low_polynomial (a : Nat → R) (z : R) :
    polynomial (image a z 768) 0 768=
      polynomial a 0 768+polynomial a 768 768-C z*(polynomial a 0 768-polynomial a 768 768) := by
  unfold polynomial
  rw [← sum_add_distrib,← sum_sub_distrib,mul_sum,← sum_sub_distrib]
  apply sum_congr rfl
  intro k hk
  have bound := mem_range.mp hk
  simp only [Nat.zero_add]
  rw [KeygenPublicRootInverseFold.image_low a z 768 k bound]
  simp only [low,map_add,map_sub,map_mul]
  rw [Nat.add_comm 768 k]
  ring
theorem high_polynomial (a : Nat → R) (z : R) :
    polynomial (image a z 768) 768 768=C (2*z)*(polynomial a 0 768-polynomial a 768 768) := by
  unfold polynomial
  rw [← sum_sub_distrib,mul_sum]
  apply sum_congr rfl
  intro k hk
  have bound := mem_range.mp hk
  simp only [Nat.zero_add]
  rw [Nat.add_comm 768 k,KeygenPublicRootInverseFold.image_high a z 768 k (by decide) bound]
  simp only [high,map_add,map_mul,map_sub,map_ofNat]
  ring
theorem reconstruction (a : Nat → R) (z : R) :
    polynomial (image a z 768) 0 1536=
      polynomial a 0 768+polynomial a 768 768-C z*(polynomial a 0 768-polynomial a 768 768)+
        X^768*C (2*z)*(polynomial a 0 768-polynomial a 768 768) := by
  rw [show (1536 : Nat)=2*768 from rfl,KeygenPublicSplitPolynomial.split_halves]
  rw [Nat.zero_add,low_polynomial,high_polynomial]
  ring

theorem eval_low (a : Nat → R) (z : R) (power : z^768=firstRoot) :
    (polynomial (image a inverseRoot 768) 0 1536).eval z=2*(polynomial a 0 768).eval z := by
  rw [reconstruction]
  simp only [eval_add,eval_sub,eval_mul,eval_pow,eval_X,eval_C,power]
  calc
    _=(polynomial a 0 768).eval z+(polynomial a 768 768).eval z+
        (inverseRoot*(2*firstRoot-1))*((polynomial a 0 768).eval z-(polynomial a 768 768).eval z) := by ring
    _=2*(polynomial a 0 768).eval z := by rw [inverse_cancel]; ring
theorem eval_high (a : Nat → R) (z : R) (power : z^768=1-firstRoot) :
    (polynomial (image a inverseRoot 768) 0 1536).eval z=2*(polynomial a 768 768).eval z := by
  rw [reconstruction]
  simp only [eval_add,eval_sub,eval_mul,eval_pow,eval_X,eval_C,power]
  calc
    _=(polynomial a 0 768).eval z+(polynomial a 768 768).eval z-
        (inverseRoot*(2*firstRoot-1))*((polynomial a 0 768).eval z-(polynomial a 768 768).eval z) := by ring
    _=2*(polynomial a 768 768).eval z := by rw [inverse_cancel]; ring

theorem all_original (a : Nat → R) (i : Fin 1536) :
    (polynomial (rootImage a) 0 1536).eval (point i)=1536*a i.val := by
  have hi := i.isLt
  have power := KeygenPublicReverseReconstruction.point_power 8 (by decide) i
  change point i^768=KeygenPublicRootTree.nodeRoot 0 (i.val/768) at power
  have original := KeygenPublicReverseReconstruction.original_block a i
  by_cases first : i.val<768
  · have index : i.val/768=0 := by omega
    rw [index,KeygenPublicRootTree.top_low] at power
    rw [index,Nat.zero_mul] at original
    rw [rootImage,eval_low _ _ power,original]
    ring
  · have index : i.val/768=1 := by omega
    rw [index,KeygenPublicRootTree.top_high] at power
    rw [index,Nat.one_mul] at original
    rw [rootImage,eval_high _ _ power,original]
    ring

end FT1536.Source3.KeygenPublicRootInversePolynomial
