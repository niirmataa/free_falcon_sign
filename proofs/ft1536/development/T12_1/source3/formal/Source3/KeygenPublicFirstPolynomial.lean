import Source3.KeygenPublicFirstValues

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- First split of the ORIGINAL CoefficientQuotient polynomial. These are
   independently proved value identities, not a consequence of canonicality. -/
namespace FT1536.Source3.KeygenPublicFirstPolynomial
open Polynomial Finset
open KeygenPublicAlgebra (R radix)
open FT1536.Run2
open KeygenPublicInputMaterial (coefficient reduced)
open KeygenPublicInputCells (Cell Cells)

noncomputable def low (v : CoefficientQuotient.Coeff R) (z : R) : Polynomial R :=
  ∑ i : Fin 768, C ((v i).1+(v i).2*z)*X^i.val
noncomputable def high (v : CoefficientQuotient.Coeff R) (z : R) : Polynomial R := low v (1-z)

theorem low_coefficient (v : CoefficientQuotient.Coeff R) (z : R) (i : Fin 768) :
    (low v z).coeff i.val=(v i).1+(v i).2*z := by
  classical
  simp only [low,finsetSum_coeff,coeff_C_mul_X_pow]
  rw [Finset.sum_eq_single i]
  · simp
  · intro j member different
    have ne : i.val≠j.val := fun eq => different (Fin.ext eq.symm)
    simp [ne]
  · simp

theorem high_coefficient (v : CoefficientQuotient.Coeff R) (z : R) (i : Fin 768) :
    (high v z).coeff i.val=(v i).1+(v i).2-(v i).2*z := by
  rw [high,low_coefficient]
  ring

theorem low_degree (v : CoefficientQuotient.Coeff R) (z : R) : (low v z).degree<768 := by
  classical
  apply (Polynomial.degree_lt_iff_coeff_zero _ 768).mpr
  intro n hn
  simp only [low,finsetSum_coeff,coeff_C_mul_X_pow]
  apply Finset.sum_eq_zero
  intro j member
  have ne : n≠j.val := by have bound := j.isLt; omega
  simp [ne]

theorem eval_original (v : CoefficientQuotient.Coeff R) (z x : R) (power : x^768=z) :
    (CoefficientQuotient.polynomial v).eval x=(low v z).eval x := by
  classical
  simp only [CoefficientQuotient.polynomial,low,eval_finsetSum,eval_add,eval_mul,eval_C,eval_pow,eval_X]
  apply Finset.sum_congr rfl
  intro i member
  rw [pow_add,power]
  ring

theorem first_low_evaluation (v : CoefficientQuotient.Coeff R) (x : R) (power : x^768=KeygenPublicRoots.firstRoot) :
    (low v KeygenPublicRoots.firstRoot).eval x=(CoefficientQuotient.polynomial v).eval x :=
  (eval_original v _ x power).symm

theorem first_high_evaluation (v : CoefficientQuotient.Coeff R) (x : R) (power : x^768=1-KeygenPublicRoots.firstRoot) :
    (high v KeygenPublicRoots.firstRoot).eval x=(CoefficientQuotient.polynomial v).eval x :=
  (eval_original v _ x power).symm

theorem original_reduced_coefficient (v : Geometry.Vec) (i : Nat) :
    (CoefficientQuotient.polynomial (Relation.reduceVec v)).coeff i=reduced v i := by
  by_cases lo : i<768
  · rw [CoefficientQuotient.coefficient_low _ ⟨i,lo⟩]
    simp only [reduced,coefficient,lo,reduceDIte,Relation.reduceVec]
  · by_cases hi : i<1536
    · have index : i-768+768=i := by omega
      have law := CoefficientQuotient.coefficient_high (Relation.reduceVec v) ⟨i-768,by omega⟩
      rw [index] at law
      rw [law]
      simp only [reduced,coefficient,lo,reduceDIte,hi,Relation.reduceVec]
    · rw [CoefficientQuotient.coefficient_outside _ _ (by omega)]
      simp only [reduced,coefficient,lo,reduceDIte,hi,Int.cast_zero]

theorem source_original_coefficients (s : C99ArrayReference.State) (out : C99ProcedureReference.Result)
    (a : C99MemoryReference.ArrayPointer) (i : Nat) (original : Geometry.Vec)
    (hi : i<768) (width : a.elementBytes=2) (fixed : KeygenPublicFirstValues.Fixed s a i)
    (input : Cells s.heap a 1536 (reduced original))
    (r : KeygenPublicValueExpr.Local s "r" (radix*KeygenPublicRoots.firstRoot))
    (source : KeygenPublicExec.Exec KeygenPublicSource.program [] KeygenPublicFirstValues.body s out) :
    Cell out.state.heap a i ((low (Relation.reduceVec original) KeygenPublicRoots.firstRoot).coeff i) ∧
      Cell out.state.heap a (i+768) ((high (Relation.reduceVec original) KeygenPublicRoots.firstRoot).coeff i) := by
  obtain ⟨first,second,stores⟩ := KeygenPublicFirstValues.source_body s out a i
    (reduced original i) (reduced original (i+768)) KeygenPublicRoots.firstRoot hi width fixed
    (input i (by omega)) (input (i+768) (by omega)) r source
  have lowOriginal : reduced original i=(Relation.reduceVec original ⟨i,hi⟩).1 := by
    simp only [reduced,coefficient,hi,reduceDIte,Relation.reduceVec]
  have highOriginal : reduced original (i+768)=(Relation.reduceVec original ⟨i,hi⟩).2 := by
    simp only [reduced,coefficient,show ¬i+768<768 from by omega,reduceDIte,
      show i+768<1536 from by omega,show i+768-768=i from by omega,Relation.reduceVec]
  have lowCoeff := low_coefficient (Relation.reduceVec original) KeygenPublicRoots.firstRoot ⟨i,hi⟩
  have highCoeff := high_coefficient (Relation.reduceVec original) KeygenPublicRoots.firstRoot ⟨i,hi⟩
  rw [lowCoeff,highCoeff,← lowOriginal,← highOriginal]
  exact ⟨first,second⟩

end FT1536.Source3.KeygenPublicFirstPolynomial
