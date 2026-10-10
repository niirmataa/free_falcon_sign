import Source3.KeygenPublicNormalizeEntry

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The actual normalized coefficient image defines Relation.Rq and has
   every ORIGINAL physical evaluation equal to the actual inverse input. -/
namespace FT1536.Source3.KeygenPublicNormalizePolynomial
open Polynomial Finset
open KeygenPublicAlgebra (R)
open KeygenPublicSplitPolynomial (polynomial)
open KeygenPublicNormalizeEntry (normalized)
open KeygenPublicNormalizeAtoms (inverseN)
open KeygenPublicRootInversePolynomial (rootImage)
open FT1536.Run2

noncomputable def vector (a : Nat → R) : Relation.Rq := CoefficientQuotient.coefficients (polynomial (normalized a) 0 1536)
def Represents (heap : C99MemoryReference.Memory) (p : C99MemoryReference.ArrayPointer) (h : Relation.Rq) : Prop :=
  ∀ i : Fin 768, KeygenPublicInputCells.Cell heap p i.val (h i).1 ∧
    KeygenPublicInputCells.Cell heap p (i.val+768) (h i).2

theorem vector_low (a : Nat → R) (i : Fin 768) : (vector a i).1=normalized a i.val := by
  change (polynomial (normalized a) 0 1536).coeff i.val=normalized a i.val
  rw [KeygenPublicSplitPolynomial.coefficient _ _ _ _ (by have bound := i.isLt; omega),Nat.zero_add]
theorem vector_high (a : Nat → R) (i : Fin 768) : (vector a i).2=normalized a (i.val+768) := by
  change (polynomial (normalized a) 0 1536).coeff (i.val+768)=normalized a (i.val+768)
  rw [KeygenPublicSplitPolynomial.coefficient _ _ _ _ (by have bound := i.isLt; omega),Nat.zero_add]
theorem vector_polynomial (a : Nat → R) : CoefficientQuotient.polynomial (vector a)=polynomial (normalized a) 0 1536 :=
  CoefficientQuotient.polynomial_coefficients _ (KeygenPublicSplitPolynomial.degree_bound _ _ _)
theorem scaled_polynomial (a : Nat → R) : polynomial (normalized a) 0 1536=C inverseN*polynomial (rootImage a) 0 1536 := by
  unfold polynomial normalized
  rw [mul_sum]
  apply sum_congr rfl
  intro k _
  simp only [map_mul]
  ring

theorem all_evaluations (a : Nat → R) (i : Fin 1536) :
    (CoefficientQuotient.polynomial (vector a)).eval (KeygenPublicRoots.point i)=a i.val := by
  rw [vector_polynomial,scaled_polynomial,eval_mul,eval_C,KeygenPublicRootInversePolynomial.all_original]
  calc
    inverseN*(1536*a i.val)=(1536*inverseN)*a i.val := by ring
    _=a i.val := by rw [KeygenPublicNormalizeAtoms.dimension_cancel,one_mul]
theorem canonical_material (a : Nat → R) (heap : C99MemoryReference.Memory) (p : C99MemoryReference.ArrayPointer)
    (cells : KeygenPublicInputCells.Cells heap p 1536 (normalized a)) : Represents heap p (vector a) := by
  intro i
  have bound := i.isLt
  rw [vector_low,vector_high]
  exact ⟨cells i.val (by omega),cells (i.val+768) (by omega)⟩

end FT1536.Source3.KeygenPublicNormalizePolynomial
