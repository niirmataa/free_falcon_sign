import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum

/-! Reviewer-local checks of old-target residual and correlated ledger.
    These theorems concern algebra, not a reached C execution. -/
namespace IndependentReview
variable {R : Type*} [CommRing R]

theorem update_defect_survives (old y rx addErr subErr lastErr : R) :
  ((old + rx + addErr - y + subErr) - rx + lastErr) - (old - y) =
    addErr + subErr + lastErr := by ring

theorem stale_rx_adds_residual (old y stored recomputed a b c : R) :
  ((old + stored + a - y + b) - recomputed + c) - (old - y) =
    a + b + c + (stored - recomputed) := by ring

theorem target_basis_cancel (t₀ t₁ z₀ z₁ d₀ d₁ : R) :
  (-t₀*d₀ - t₁*d₁) + ((t₀-z₀)*d₀ + (t₁-z₁)*d₁) =
  -z₀*d₀-z₁*d₁ := by ring

theorem common_inverse_second (nu c u v : R) :
  (nu*c*v)*u + (-nu*c*u)*v = 0 := by ring

theorem strict_target : (6557/16000 : ℚ) < 1/2 := by norm_num
end IndependentReview

#print axioms IndependentReview.update_defect_survives
#print axioms IndependentReview.stale_rx_adds_residual
#print axioms IndependentReview.target_basis_cancel
#print axioms IndependentReview.common_inverse_second
#print axioms IndependentReview.strict_target
