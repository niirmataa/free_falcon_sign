import Source3.KeygenNttRoots
import Run2.QuotientOperations

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- B1.04 quotient injectivity at the pinned physical point family. Source
   pointwise equalities must still be supplied by the complete transform
   and solver check; this module does not assume their source correctness. -/
namespace FT1536.Source3.KeygenNttEvaluation
open Polynomial
open KeygenNttWordAlgebra (R)
open KeygenNttRoots (point)
open FT1536.Run2.CoefficientQuotient

noncomputable def evaluate (v : Coeff R) (i : Fin 1536) : R := (polynomial v).eval (point i)

theorem eval_remainder (p : Polynomial R) (i : Fin 1536) :
    (p %ₘ phi R).eval (point i)=p.eval (point i) := by
  rw [modByMonic_eq_sub_mul_div,eval_sub,eval_mul]
  have root := KeygenNttRoots.points_are_roots i
  rw [IsRoot.def] at root
  rw [root,zero_mul,sub_zero]

theorem evaluate_multiply (v w : Coeff R) (i : Fin 1536) :
    evaluate (multiply v w) i=evaluate v i*evaluate w i := by
  have degree : ((polynomial v*polynomial w)%ₘphi R).degree<1536 := by
    rw [← phi_degree R]
    exact degree_modByMonic_lt _ (phi_monic R)
  unfold evaluate multiply
  rw [polynomial_coefficients _ degree,eval_remainder,eval_mul]

theorem polynomial_sub (v w : Coeff R) : polynomial (v-w)=polynomial v-polynomial w := by
  have add := polynomial_add (v-w) w
  rw [sub_add_cancel] at add
  exact eq_sub_of_add_eq add.symm

theorem evaluate_sub (v w : Coeff R) (i : Fin 1536) :
    evaluate (v-w) i=evaluate v i-evaluate w i := by
  unfold evaluate
  rw [polynomial_sub,eval_sub]

theorem evaluate_constant (r : R) (i : Fin 1536) : evaluate (constantCoeffs r) i=r := by
  unfold evaluate
  rw [polynomial_constant,eval_C]

theorem equation_of_pointwise (f g bigF bigG : Coeff R) (rhs : R)
    (checked : ∀ i, evaluate f i*evaluate bigG i-evaluate g i*evaluate bigF i=rhs) :
    multiply f bigG-multiply g bigF=constantCoeffs rhs := by
  apply KeygenNttRoots.coefficient_injective
  intro i
  change evaluate (multiply f bigG-multiply g bigF) i=evaluate (constantCoeffs rhs) i
  rw [evaluate_sub,evaluate_multiply,evaluate_multiply,evaluate_constant]
  exact checked i

end FT1536.Source3.KeygenNttEvaluation
