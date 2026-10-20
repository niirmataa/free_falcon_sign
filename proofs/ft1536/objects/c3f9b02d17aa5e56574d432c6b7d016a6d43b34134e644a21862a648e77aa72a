import Source3.KeygenPublicAlgebra
import Source3.KeygenMkgm3IndexCert
import Run2.CoefficientQuotient
import Mathlib.Algebra.Polynomial.Roots

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option exponentiation.threshold 32768
set_option Elab.async false

/- Mathematical geometry for the q18433 source generator and physical
   ternary ordering. This module does NOT assert that an executed mq_mkgm3
   has populated these words, or that a public NTT evaluates at these points.
   Those source/memory refinements remain separate B1.06 obligations. -/
namespace FT1536.Source3.KeygenPublicRoots
open KeygenPublicAlgebra (R)
open KeygenMkgm3Indices (tableExponent reverse9 lastIndex)
open KeygenMkgm3Rows (exponent)
open FT1536.Run2
open Polynomial

def generator : R := 25
def root : R := generator^2
def firstRoot : R := root^768
def pointExponent (i : Fin 1536) : Nat := tableExponent (512+i.val/3)+1536*(i.val%3)
def point (i : Fin 1536) : R := root^pointExponent i
def unity : R := firstRoot^2
theorem source_generator : KeygenAttemptPin.vrfyLines[829]?=
    some "\tg = mq_montymul(25, R2t, Qt, Q0It);\n" := by decide
theorem generator_pow (n : Nat) : generator^n=((25^n%18433 : Nat) : R) := by
  rw [ZMod.natCast_mod,Nat.cast_pow]
  rfl
theorem order_power : 25^9216%18433=1 := by decide
theorem order_half : 25^4608%18433≠1 := by decide
theorem order_third : 25^3072%18433≠1 := by decide
theorem generator_order : orderOf generator=9216 := by
  apply orderOf_eq_of_pow_and_pow_div_prime (by decide)
  · rw [generator_pow,order_power,Nat.cast_one]
  · intro q hq hd
    have hf : q∣2^10*3^2 := by norm_num at hd ⊢; exact hd
    have factors : q=2 ∨ q=3 := by
      rcases hq.dvd_mul.mp hf with h | h
      · exact Or.inl ((Nat.prime_dvd_prime_iff_eq hq (by decide)).mp (hq.dvd_of_dvd_pow h))
      · exact Or.inr ((Nat.prime_dvd_prime_iff_eq hq (by decide)).mp (hq.dvd_of_dvd_pow h))
    rcases factors with rfl | rfl
    · intro equal
      rw [generator_pow] at equal
      have he := (ZMod.natCast_eq_natCast_iff' _ 1 18433).mp equal
      simp only [Nat.mod_mod,show 1%18433=1 from rfl] at he
      exact order_half he
    · intro equal
      rw [generator_pow] at equal
      have he := (ZMod.natCast_eq_natCast_iff' _ 1 18433).mp equal
      simp only [Nat.mod_mod,show 1%18433=1 from rfl] at he
      exact order_third he
theorem root_order : orderOf root=4608 := by
  rw [root,orderOf_pow' generator (by decide : 2≠0),generator_order]
  decide
theorem first_root_order : orderOf firstRoot=6 := by
  rw [firstRoot,orderOf_pow' root (by decide : 768≠0),root_order]
  decide
theorem first_root_relation : firstRoot^2-firstRoot+1=0 := by
  rw [firstRoot,root,← pow_mul,generator_pow]
  decide
theorem first_root_fifth : firstRoot^5=1-firstRoot := by
  linear_combination (firstRoot^3+firstRoot^2-1)*first_root_relation
theorem last_exponent (j : Nat) (hj : j<512) : tableExponent (512+j)=exponent (reverse9 j) := by
  obtain ⟨bound,involution,_⟩ := (KeygenMkgm3IndexCert.all_indices j (by omega)).1 hj
  have law := ((KeygenMkgm3IndexCert.all_indices (reverse9 j) (by omega)).1 bound).2.2
  simpa only [lastIndex,involution] using law
theorem last_bounds (j : Nat) (hj : j<512) : 0<tableExponent (512+j) ∧ tableExponent (512+j)<1536 := by
  have bound := ((KeygenMkgm3IndexCert.all_indices j (by omega)).1 hj).1
  rw [last_exponent j hj]
  unfold exponent
  omega
theorem last_injective (j k : Nat) (hj : j<512) (hk : k<512) (equal : tableExponent (512+j)=tableExponent (512+k)) : j=k := by
  rw [last_exponent j hj,last_exponent k hk] at equal
  have he : reverse9 j=reverse9 k := by unfold exponent at equal; omega
  have reversed := congrArg reverse9 he
  rw [((KeygenMkgm3IndexCert.all_indices j (by omega)).1 hj).2.1,
    ((KeygenMkgm3IndexCert.all_indices k (by omega)).1 hk).2.1] at reversed
  exact reversed
theorem point_exponent_bounds (i : Fin 1536) : 0<pointExponent i ∧ pointExponent i<4608 := by
  have hi := i.isLt
  have bound := last_bounds (i.val/3) (by omega)
  unfold pointExponent
  omega
theorem point_exponent_injective : Function.Injective pointExponent := by
  intro i j equal
  have hi := i.isLt; have hj := j.isLt
  have bi := last_bounds (i.val/3) (by omega); have bj := last_bounds (j.val/3) (by omega)
  have he : tableExponent (512+i.val/3)=tableExponent (512+j.val/3) := by unfold pointExponent at equal; omega
  have divEqual := last_injective (i.val/3) (j.val/3) (by omega) (by omega) he
  apply Fin.ext
  unfold pointExponent at equal
  omega
theorem points_distinct : Function.Injective point := by
  intro i j equal
  apply point_exponent_injective
  apply pow_injOn_Iio_orderOf (x := root)
  · simpa only [Set.mem_Iio,root_order] using (point_exponent_bounds i).2
  · simpa only [Set.mem_Iio,root_order] using (point_exponent_bounds j).2
  · exact equal
theorem point_exponent_mod_six (i : Fin 1536) : pointExponent i%6=1 ∨ pointExponent i%6=5 := by
  have hi := i.isLt
  rw [pointExponent,last_exponent (i.val/3) (by omega)]
  unfold exponent
  omega
theorem point_half_power (i : Fin 1536) : point i^768=firstRoot ∨ point i^768=1-firstRoot := by
  have swap : point i^768=firstRoot^pointExponent i := by
    rw [point,firstRoot,← pow_mul,← pow_mul,Nat.mul_comm]
  rw [swap,← pow_mod_orderOf firstRoot (pointExponent i),first_root_order]
  rcases point_exponent_mod_six i with h | h
  · exact Or.inl (by rw [h,pow_one])
  · exact Or.inr (by rw [h,first_root_fifth])
theorem points_are_roots (i : Fin 1536) : (CoefficientQuotient.phi R).IsRoot (point i) := by
  rw [IsRoot.def]
  unfold CoefficientQuotient.phi
  simp only [eval_add,eval_sub,eval_pow,eval_X,eval_one]
  rw [show (1536 : Nat)=768*2 from rfl,pow_mul]
  rcases point_half_power i with h | h
  · rw [h]; exact first_root_relation
  · rw [h]; linear_combination first_root_relation
theorem coefficient_injective (v w : CoefficientQuotient.Coeff R)
    (evaluations : ∀ i, (CoefficientQuotient.polynomial v).eval (point i)=
      (CoefficientQuotient.polynomial w).eval (point i)) : v=w := by
  have degree (v : CoefficientQuotient.Coeff R) : (CoefficientQuotient.polynomial v).natDegree<1536 := by
    by_cases zero : CoefficientQuotient.polynomial v=0
    · rw [zero]; simp
    · exact (natDegree_lt_iff_degree_lt zero).mpr (CoefficientQuotient.polynomial_degree v)
  have equal := eq_of_natDegree_lt_card_of_eval_eq (CoefficientQuotient.polynomial v)
    (CoefficientQuotient.polynomial w) points_distinct evaluations
    (by rw [Fintype.card_fin,max_lt_iff]; exact ⟨degree v,degree w⟩)
  have same := congrArg CoefficientQuotient.coefficients equal
  simpa only [CoefficientQuotient.coefficients_polynomial] using same

end FT1536.Source3.KeygenPublicRoots
