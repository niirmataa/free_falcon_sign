import Source3.KeygenPublicReverseMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Public-field reconstruction of each actual inverse triple. Its degree<3
   polynomial evaluates to THREE times the original physical input value. -/
namespace FT1536.Source3.KeygenPublicInverseTriplePolynomial
open Polynomial Finset
open KeygenPublicAlgebra (R)
open KeygenPublicRoots (root unity)
open KeygenPublicSplitPolynomial (polynomial)
open KeygenPublicTripleOrder (quadratic)

theorem root_nonzero : root≠0 := by decide
theorem unity_inverse : unity⁻¹=unity^2 := by
  apply inv_eq_of_mul_eq_one_left
  rw [← pow_succ,KeygenPublicTripleOrder.unity_cube]
theorem unity_sum : unity^2+unity+1=0 := by decide
theorem unity_fourth : unity^4=unity := by
  rw [show (4 : Nat)=3+1 from rfl,pow_add,KeygenPublicTripleOrder.unity_cube,pow_one,one_mul]

theorem unscale (A B C x z : R) (hx : x≠0) :
    quadratic A (x⁻¹*B) (x⁻¹^2*C) (x*z)=A+B*z+C*z^2 := by
  unfold quadratic
  field_simp [hx]

def choice (A B C : R) (k : Nat) : R := if k=0 then A else if k=1 then B else C
theorem triple_reconstruction (A B C x : R) (hx : x≠0) (k : Nat) (hk : k<3) :
    quadratic (A+(B+C))
      (x⁻¹*(A+(B*unity⁻¹+C*(unity⁻¹)^2)))
      ((x⁻¹)^2*(A+(B*(unity⁻¹)^2+C*unity⁻¹))) (x*unity^k)=3*choice A B C k := by
  rw [unity_inverse,← pow_mul,show (2*2 : Nat)=4 from rfl,unity_fourth,unscale _ _ _ _ _ hx]
  interval_cases k
  · simp only [pow_zero,mul_one,one_pow,choice,ite_true]
    linear_combination (B+C)*unity_sum
  · simp only [pow_one,choice,show ¬(1 : Nat)=0 from by decide,ite_false,ite_true]
    linear_combination (A+C)*unity_sum + 2*B*KeygenPublicTripleOrder.unity_cube + C*unity_fourth
  · simp only [choice,show ¬(2 : Nat)=0 from by decide,show ¬(2 : Nat)=1 from by decide,ite_false]
    rw [← pow_mul,show (2*2 : Nat)=4 from rfl,unity_fourth]
    linear_combination (A+B)*unity_sum + 2*C*KeygenPublicTripleOrder.unity_cube + B*unity_fourth

theorem value_entry (a : Nat → R) (j k : Nat) (hk : k<3) :
    KeygenPublicInverseFold.value a (3*j+k)=KeygenPublicInverseFold.output
      (a (3*j)) (a (3*j+1)) (a (3*j+2)) (KeygenPublicInverseTables.rootAt (512+j))
      KeygenPublicInverseFold.unity k := by
  have div : (3*j+k)/3=j := by omega
  have rem : (3*j+k)%3=k := by omega
  simp only [KeygenPublicInverseFold.value,div,rem]

theorem block_eval (a : Nat → R) (j k : Nat) (hj : j<512) (hk : k<3) :
    (polynomial (KeygenPublicInverseFold.value a) (3*j) 3).eval
      (KeygenPublicRoots.point ⟨3*j+k,by omega⟩)=3*a (3*j+k) := by
  rw [KeygenPublicTripleOrder.triple_order j k hj hk]
  have v0 := value_entry a j 0 (by decide)
  have v1 := value_entry a j 1 (by decide)
  have v2 := value_entry a j 2 (by decide)
  simp only [Nat.add_zero,KeygenPublicInverseFold.output,ite_true] at v0
  simp only [KeygenPublicInverseFold.output,show ¬(1 : Nat)=0 from by decide,ite_false,ite_true] at v1
  simp only [KeygenPublicInverseFold.output,show ¬(2 : Nat)=0 from by decide,
    show ¬(2 : Nat)=1 from by decide,ite_false] at v2
  have poly : ∀ z : R, (polynomial (KeygenPublicInverseFold.value a) (3*j) 3).eval z=
      quadratic (KeygenPublicInverseFold.value a (3*j)) (KeygenPublicInverseFold.value a (3*j+1))
        (KeygenPublicInverseFold.value a (3*j+2)) z := by
    intro z
    simp [polynomial,sum_range_succ,quadratic]
  rw [poly,v0,v1,v2]
  have inverseRoot : KeygenPublicInverseTables.rootAt (512+j)=(root^KeygenMkgm3Indices.tableExponent (512+j))⁻¹ := by
    rw [KeygenPublicInverseTables.rootAt,inv_pow]
  rw [inverseRoot]
  simp only [KeygenPublicInverseFold.unity]
  change quadratic _ _ _ _=3*a (3*j+k)
  rw [triple_reconstruction _ _ _ _ (pow_ne_zero _ root_nonzero) k hk]
  interval_cases k <;> simp [choice]

theorem all_physical (a : Nat → R) (i : Fin 1536) :
    (polynomial (KeygenPublicInverseFold.value a) (3*(i.val/3)) 3).eval (KeygenPublicRoots.point i)=3*a i.val := by
  have hi := i.isLt
  have index : (⟨3*(i.val/3)+i.val%3,by omega⟩ : Fin 1536)=i := by apply Fin.ext; dsimp; omega
  have law := block_eval a (i.val/3) (i.val%3) (by omega) (by omega)
  rw [index] at law
  simpa only [Nat.div_add_mod] using law

end FT1536.Source3.KeygenPublicInverseTriplePolynomial
