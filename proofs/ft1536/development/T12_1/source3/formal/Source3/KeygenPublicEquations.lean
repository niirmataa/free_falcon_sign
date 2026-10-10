import Source3.KeygenPublicEvaluationIso
import Source3.KeygenPublicNormalizeMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Construct fInv from the already derived nonzero evaluations, THEN prove
   both equations for the SAME f/g and source-derived final h. -/
namespace FT1536.Source3.KeygenPublicEquations
open KeygenPublicAlgebra (R)
open KeygenPublicEvaluationIso (evaluate reconstruct)
open KeygenPublicSuccessfulSuffix (Nonzero values values_physical)
open KeygenPublicInverseMaterial (quotients)
open FT1536.Run2.CoefficientQuotient (constantCoeffs)

noncomputable def fInverse (f : Geometry.Vec) : Relation.Rq := reconstruct (fun i => (evaluate (Relation.reduceVec f) i)⁻¹)
noncomputable def publicVector (f g : Geometry.Vec) : Relation.Rq := KeygenPublicNormalizePolynomial.vector (quotients f g)

theorem evaluate_inverse (f : Geometry.Vec) (i : Fin 1536) :
    evaluate (fInverse f) i=(evaluate (Relation.reduceVec f) i)⁻¹ :=
  KeygenPublicEvaluationIso.evaluate_reconstruct _ i
theorem evaluation_nonzero (f : Geometry.Vec) (i : Fin 1536) (nonzero : Nonzero f) :
    evaluate (Relation.reduceVec f) i≠0 := by
  have nz := nonzero i
  rw [values_physical] at nz
  exact nz
theorem inverse_equation (f : Geometry.Vec) (nonzero : Nonzero f) :
    Relation.mulRq (fInverse f) (Relation.reduceVec f)=constantCoeffs (1 : R) := by
  apply KeygenPublicRoots.coefficient_injective
  intro i
  change evaluate (Relation.mulRq (fInverse f) (Relation.reduceVec f)) i=evaluate (constantCoeffs (1 : R)) i
  rw [KeygenPublicEvaluationIso.evaluate_mulRq,evaluate_inverse,KeygenPublicEvaluationIso.evaluate_constant]
  exact inv_mul_cancel₀ (evaluation_nonzero f i nonzero)

theorem evaluate_public (f g : Geometry.Vec) (i : Fin 1536) :
    evaluate (publicVector f g) i=evaluate (Relation.reduceVec g) i*(evaluate (Relation.reduceVec f) i)⁻¹ := by
  change (FT1536.Run2.CoefficientQuotient.polynomial (KeygenPublicNormalizePolynomial.vector (quotients f g))).eval
    (KeygenPublicRoots.point i)=_
  rw [KeygenPublicNormalizePolynomial.all_evaluations,quotients,values_physical,values_physical]
  rfl
theorem public_equation (f g : Geometry.Vec) (nonzero : Nonzero f) :
    Relation.mulRq (publicVector f g) (Relation.reduceVec f)=Relation.reduceVec g := by
  apply KeygenPublicRoots.coefficient_injective
  intro i
  change evaluate (Relation.mulRq (publicVector f g) (Relation.reduceVec f)) i=evaluate (Relation.reduceVec g) i
  rw [KeygenPublicEvaluationIso.evaluate_mulRq,evaluate_public,mul_assoc,
    inv_mul_cancel₀ (evaluation_nonzero f i nonzero),mul_one]
theorem both_equations (f g : Geometry.Vec) (nonzero : Nonzero f) :
    Relation.mulRq (publicVector f g) (Relation.reduceVec f)=Relation.reduceVec g ∧
    Relation.mulRq (fInverse f) (Relation.reduceVec f)=constantCoeffs (1 : R) :=
  ⟨public_equation f g nonzero,inverse_equation f nonzero⟩

end FT1536.Source3.KeygenPublicEquations
