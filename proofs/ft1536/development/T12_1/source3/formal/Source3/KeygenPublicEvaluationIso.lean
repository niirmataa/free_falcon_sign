import Source3.KeygenPublicNormalizePolynomial
import Run2.QuotientOperations

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Evaluation isomorphism in the PUBLIC field and ORIGINAL physical order.
   Its inverse is the proved normalized image, not an assumed B3 transform. -/
namespace FT1536.Source3.KeygenPublicEvaluationIso
open Polynomial
open KeygenPublicAlgebra (R)
open KeygenPublicRoots (point)
open FT1536.Run2.CoefficientQuotient

noncomputable def evaluate (v : Relation.Rq) (i : Fin 1536) : R := (polynomial v).eval (point i)
def extend (a : Fin 1536 → R) (j : Nat) : R := a ⟨j%1536,Nat.mod_lt j (by decide)⟩
noncomputable def reconstruct (a : Fin 1536 → R) : Relation.Rq := KeygenPublicNormalizePolynomial.vector (extend a)

theorem extend_physical (a : Fin 1536 → R) (i : Fin 1536) : extend a i.val=a i := by
  have index : (⟨i.val%1536,Nat.mod_lt i.val (by decide)⟩ : Fin 1536)=i := Fin.ext (Nat.mod_eq_of_lt i.isLt)
  unfold extend
  rw [index]
theorem evaluate_reconstruct (a : Fin 1536 → R) (i : Fin 1536) : evaluate (reconstruct a) i=a i := by
  rw [evaluate,reconstruct,KeygenPublicNormalizePolynomial.all_evaluations,extend_physical]
theorem evaluate_injective : Function.Injective evaluate := by
  intro v w equal
  exact KeygenPublicRoots.coefficient_injective v w (fun i => congrFun equal i)
theorem reconstruct_evaluate (v : Relation.Rq) : reconstruct (evaluate v)=v := by
  apply evaluate_injective
  funext i
  exact evaluate_reconstruct (evaluate v) i
noncomputable def evaluationEquiv : Relation.Rq ≃ (Fin 1536 → R) where
  toFun := evaluate
  invFun := reconstruct
  left_inv := reconstruct_evaluate
  right_inv := fun a => funext (evaluate_reconstruct a)

theorem eval_remainder (p : Polynomial R) (i : Fin 1536) : (p %ₘ phi R).eval (point i)=p.eval (point i) := by
  rw [modByMonic_eq_sub_mul_div,eval_sub,eval_mul]
  have root := KeygenPublicRoots.points_are_roots i
  rw [IsRoot.def] at root
  rw [root,zero_mul,sub_zero]
theorem evaluate_mulRq (v w : Relation.Rq) (i : Fin 1536) :
    evaluate (Relation.mulRq v w) i=evaluate v i*evaluate w i := by
  have degree : ((polynomial v*polynomial w)%ₘphi R).degree<1536 := by
    rw [← phi_degree R]
    exact degree_modByMonic_lt _ (phi_monic R)
  change evaluate (multiply v w) i=evaluate v i*evaluate w i
  unfold evaluate multiply
  rw [polynomial_coefficients _ degree,eval_remainder,eval_mul]
theorem evaluate_constant (z : R) (i : Fin 1536) : evaluate (constantCoeffs z) i=z := by
  rw [evaluate,polynomial_constant,eval_C]

end FT1536.Source3.KeygenPublicEvaluationIso
