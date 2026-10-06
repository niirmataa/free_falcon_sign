import Source3.KeygenNttPolynomial
import Mathlib.Algebra.Polynomial.Roots
import Mathlib.Algebra.Field.ZMod
import Mathlib.Tactic.NormNum.Prime

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- B1.04 evaluation geometry in source triple order: gm[512+j], followed
   by multiplication of its unscaled root by w and w^2. This certifies
   that point family; whole-transform evaluation at it is a separate proof. -/
namespace FT1536.Source3.KeygenNttRoots
open KeygenNttWordAlgebra (R)
open KeygenMkgm3Rows (root exponent)
open KeygenMkgm3Indices (tableExponent reverse9 lastIndex)
open KeygenNttFirstValues (firstRoot)
open FT1536.Run2
open Polynomial

instance modulusPrime : Fact (Nat.Prime 2147355649) := ⟨by norm_num⟩

def pointExponent (i : Fin 1536) : Nat := tableExponent (512+i.val/3)+1536*(i.val%3)
def point (i : Fin 1536) : R := root^pointExponent i
def unity : R := firstRoot^2

theorem last_exponent (j : Nat) (hj : j<512) : tableExponent (512+j)=exponent (reverse9 j) := by
  obtain ⟨bound,involution,_⟩ := (KeygenMkgm3IndexCert.all_indices j (by omega)).1 hj
  have law := ((KeygenMkgm3IndexCert.all_indices (reverse9 j) (by omega)).1 bound).2.2
  simpa only [lastIndex,involution] using law

theorem last_bounds (j : Nat) (hj : j<512) :
    0<tableExponent (512+j) ∧ tableExponent (512+j)<1536 := by
  have bound := ((KeygenMkgm3IndexCert.all_indices j (by omega)).1 hj).1
  rw [last_exponent j hj]
  unfold exponent
  omega

theorem exponent_injective (u v : Nat) (h : exponent u=exponent v) : u=v := by
  unfold exponent at h
  omega

theorem last_injective (j k : Nat) (hj : j<512) (hk : k<512)
    (h : tableExponent (512+j)=tableExponent (512+k)) : j=k := by
  rw [last_exponent j hj,last_exponent k hk] at h
  have he := congrArg reverse9 (exponent_injective _ _ h)
  rw [((KeygenMkgm3IndexCert.all_indices j (by omega)).1 hj).2.1,
    ((KeygenMkgm3IndexCert.all_indices k (by omega)).1 hk).2.1] at he
  exact he

theorem point_exponent_bounds (i : Fin 1536) : 0<pointExponent i ∧ pointExponent i<4608 := by
  have hi := i.isLt
  have bound := last_bounds (i.val/3) (by omega)
  unfold pointExponent
  omega

theorem point_exponent_injective : Function.Injective pointExponent := by
  intro i j equal
  have hi := i.isLt
  have hj := j.isLt
  have bi := last_bounds (i.val/3) (by omega)
  have bj := last_bounds (j.val/3) (by omega)
  have he : tableExponent (512+i.val/3)=tableExponent (512+j.val/3) := by
    unfold pointExponent at equal
    omega
  have hdiv := last_injective (i.val/3) (j.val/3) (by omega) (by omega) he
  apply Fin.ext
  unfold pointExponent at equal
  omega

theorem points_distinct : Function.Injective point := by
  intro i j equal
  apply point_exponent_injective
  apply pow_injOn_Iio_orderOf (x := root)
  · simpa only [Set.mem_Iio,KeygenMkgm3Rows.root_order] using (point_exponent_bounds i).2
  · simpa only [Set.mem_Iio,KeygenMkgm3Rows.root_order] using (point_exponent_bounds j).2
  · exact equal

theorem first_root_order : orderOf firstRoot=6 := by
  exact KeygenMkgm3Table.exact_order 1 (by decide)

theorem first_root_fifth : firstRoot^5=1-firstRoot := by
  have h := KeygenNttPolynomial.first_root_relation
  linear_combination (firstRoot^3+firstRoot^2-1)*h

theorem point_exponent_mod_six (i : Fin 1536) : pointExponent i%6=1 ∨ pointExponent i%6=5 := by
  have hi := i.isLt
  rw [pointExponent,last_exponent (i.val/3) (by omega)]
  unfold exponent
  omega

theorem point_half_power (i : Fin 1536) : point i^768=firstRoot ∨ point i^768=1-firstRoot := by
  have hroot : firstRoot=root^768 := rfl
  have swap : point i^768=firstRoot^pointExponent i := by
    rw [point,hroot,← pow_mul,← pow_mul,Nat.mul_comm]
  rw [swap,← pow_mod_orderOf firstRoot (pointExponent i),first_root_order]
  rcases point_exponent_mod_six i with he | he
  · exact Or.inl (by rw [he,pow_one])
  · exact Or.inr (by rw [he,first_root_fifth])

theorem points_are_roots (i : Fin 1536) : (CoefficientQuotient.phi R).IsRoot (point i) := by
  rw [IsRoot.def,KeygenNttPolynomial.first_factorization,eval_mul]
  rcases point_half_power i with h | h
  · simp only [KeygenNttPolynomial.halfModulus,eval_sub,eval_pow,eval_X,eval_C,h,sub_self,zero_mul]
  · simp only [KeygenNttPolynomial.halfModulus,eval_sub,eval_pow,eval_X,eval_C,h,sub_self,mul_zero]

theorem unity_cube : unity^3=1 := by
  rw [unity,← pow_mul]
  change firstRoot^6=1
  rw [← first_root_order]
  exact pow_orderOf_eq_one firstRoot

theorem unity_power : unity=root^1536 := by
  rw [unity,show firstRoot=root^768 from rfl,← pow_mul]

theorem triple_order (j k : Nat) (hj : j<512) (hk : k<3) :
    point ⟨3*j+k,by omega⟩=root^tableExponent (512+j)*unity^k := by
  have div : (3*j+k)/3=j := by omega
  have rem : (3*j+k)%3=k := by omega
  rw [point,pointExponent,div,rem,pow_add,unity_power,← pow_mul]

/- Root-count injectivity is independent of a source execution and cannot
   substitute for the still-required complete NTT evaluation theorem. -/
theorem polynomial_injective (p q : Polynomial R) (hp : p.degree<1536) (hq : q.degree<1536)
    (evaluations : ∀ i, p.eval (point i)=q.eval (point i)) : p=q := by
  apply eq_of_natDegree_lt_card_of_eval_eq p q points_distinct evaluations
  rw [Fintype.card_fin,max_lt_iff]
  have bound (f : Polynomial R) (hd : f.degree<1536) : f.natDegree<1536 := by
    by_cases hz : f=0
    · subst f
      simp
    · exact (natDegree_lt_iff_degree_lt hz).mpr hd
  exact ⟨bound p hp,bound q hq⟩

theorem coefficient_injective (v w : CoefficientQuotient.Coeff R)
    (evaluations : ∀ i, (CoefficientQuotient.polynomial v).eval (point i)=
      (CoefficientQuotient.polynomial w).eval (point i)) : v=w := by
  have equal := polynomial_injective _ _ (CoefficientQuotient.polynomial_degree v)
    (CoefficientQuotient.polynomial_degree w) evaluations
  have same := congrArg CoefficientQuotient.coefficients equal
  simpa only [CoefficientQuotient.coefficients_polynomial] using same

end FT1536.Source3.KeygenNttRoots
