import Run2.T5BoxBound

set_option exponentiation.threshold 100000

namespace FT1536.Run2.T5Tilt
open TriangularGaussian T5GateBudget T5TowerMass T5Cholesky T5BoxBound
open FT1536.Relation FT1536.Geometry CoefficientQuotient ActualNTRUFiber

/- Quadratic layer of the uniform-MGF step (obligation (c), analytic part):
   the tilted coset sum is again a tower total, up to one explicit scalar
   which is purely quadratic in the tilt (no linear term; the linear part
   vanishes because the completion shift projects back to the coset
   representative). This is the kernel form of the T5 "every real shift"
   guarantee used for coordinate tails. -/

/- Bilinear form of the Cholesky quadratic. -/
def GBil {n : ℕ} (d : Fin n → ℝ) (L : Fin n → Fin n → ℝ) (x y : Fin n → ℝ) : ℝ :=
  ∑ j : Fin n, d j * (∑ i : Fin n, L j i * x i) * (∑ i : Fin n, L j i * y i)

theorem GForm_eq_GBil {n : ℕ} (d : Fin n → ℝ) (L : Fin n → Fin n → ℝ) (x : Fin n → ℝ) :
    GForm d L x = GBil d L x x := by
  unfold GForm GBil
  apply Finset.sum_congr rfl
  intro j _
  ring

theorem GBil_add_left {n : ℕ} (d : Fin n → ℝ) (L : Fin n → Fin n → ℝ)
    (x y z : Fin n → ℝ) :
    GBil d L (fun i => x i + y i) z = GBil d L x z + GBil d L y z := by
  unfold GBil
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro j _
  simp only [mul_add, Finset.sum_add_distrib]
  ring

theorem GBil_add_right {n : ℕ} (d : Fin n → ℝ) (L : Fin n → Fin n → ℝ)
    (z x y : Fin n → ℝ) :
    GBil d L z (fun i => x i + y i) = GBil d L z x + GBil d L z y := by
  unfold GBil
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro j _
  simp only [mul_add, Finset.sum_add_distrib]

theorem GBil_sub_left {n : ℕ} (d : Fin n → ℝ) (L : Fin n → Fin n → ℝ)
    (x y z : Fin n → ℝ) :
    GBil d L (fun i => x i - y i) z = GBil d L x z - GBil d L y z := by
  unfold GBil
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro j _
  simp only [mul_sub, Finset.sum_sub_distrib]
  ring

theorem GBil_sub_right {n : ℕ} (d : Fin n → ℝ) (L : Fin n → Fin n → ℝ)
    (z x y : Fin n → ℝ) :
    GBil d L z (fun i => x i - y i) = GBil d L z x - GBil d L z y := by
  unfold GBil
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro j _
  simp only [mul_sub, Finset.sum_sub_distrib]

theorem GBil_symm {n : ℕ} (d : Fin n → ℝ) (L : Fin n → Fin n → ℝ) (x y : Fin n → ℝ) :
    GBil d L x y = GBil d L y x := by
  unfold GBil
  apply Finset.sum_congr rfl
  intro j _
  ring

theorem GForm_add_shift {n : ℕ} (d : Fin n → ℝ) (L : Fin n → Fin n → ℝ)
    (v w : Fin n → ℝ) :
    GForm d L (fun i => v i + w i)
      = GForm d L v + 2*GBil d L v w + GForm d L w := by
  rw [GForm_eq_GBil d L (fun i => v i + w i)]
  rw [GBil_add_left d L, GBil_add_right d L, GBil_add_right d L]
  rw [GBil_symm d L w v, ← GForm_eq_GBil d L v, ← GForm_eq_GBil d L w]
  ring

theorem GForm_sub_shift {n : ℕ} (d : Fin n → ℝ) (L : Fin n → Fin n → ℝ)
    (v w : Fin n → ℝ) :
    GForm d L (fun i => v i - w i)
      = GForm d L v - 2*GBil d L v w + GForm d L w := by
  rw [GForm_eq_GBil d L (fun i => v i - w i)]
  rw [GBil_sub_left d L, GBil_sub_right d L, GBil_sub_right d L]
  rw [GBil_symm d L w v, ← GForm_eq_GBil d L v, ← GForm_eq_GBil d L w]
  ring

/- Completion of squares with a linear perturbation: subtracting
   2*GBil rho w from the quadratic shifts the linear slot by rho and changes
   the value by an explicit constant. -/
theorem gform_tilt_completion {n : ℕ} (d : Fin n → ℝ) (L : Fin n → Fin n → ℝ)
    (v rho w : Fin n → ℝ) :
    GForm d L (fun i => v i + w i) - 2*GBil d L rho w
      = GForm d L (fun i => (v i - rho i) + w i)
        + (GForm d L v - GForm d L (fun i => v i - rho i)) := by
  rw [GForm_add_shift d L v w, GForm_add_shift d L (fun i => v i - rho i) w,
    GBil_sub_left d L v rho w]
  rw [GForm_sub_shift d L v rho]
  ring

theorem GForm_smul {n : ℕ} (d : Fin n → ℝ) (L : Fin n → Fin n → ℝ)
    (k : ℝ) (x : Fin n → ℝ) :
    GForm d L (fun i => k*x i) = k^2 * GForm d L x := by
  unfold GForm
  have hmain : (∑ j : Fin n, d j * (∑ i : Fin n, L j i * (k*x i))^2)
      = ∑ j : Fin n, k^2 * (d j * (∑ i : Fin n, L j i * x i)^2) := by
    apply Finset.sum_congr rfl
    intro j _
    have h1 : (∑ i : Fin n, L j i * (k*x i)) = k*(∑ i : Fin n, L j i * x i) := by
      have h1a : (∑ i : Fin n, L j i * (k*x i))
          = ∑ i : Fin n, k*(L j i * x i) :=
        Finset.sum_congr rfl (fun i _ => by ring)
      rw [h1a, Finset.mul_sum]
    rw [h1]
    ring
  rw [hmain, Finset.mul_sum]

theorem GBil_smul_right {n : ℕ} (d : Fin n → ℝ) (L : Fin n → Fin n → ℝ)
    (x : Fin n → ℝ) (k : ℝ) (y : Fin n → ℝ) :
    GBil d L x (fun i => k*y i) = k*GBil d L x y := by
  unfold GBil
  have hmain : (∑ j : Fin n, (d j * (∑ i : Fin n, L j i * x i)) *
        (∑ i : Fin n, L j i * (k*y i)))
      = ∑ j : Fin n, k*((d j * (∑ i : Fin n, L j i * x i)) *
        (∑ i : Fin n, L j i * y i)) := by
    apply Finset.sum_congr rfl
    intro j _
    have h1 : (∑ i : Fin n, L j i * (k*y i)) = k*(∑ i : Fin n, L j i * y i) := by
      have h1a : (∑ i : Fin n, L j i * (k*y i))
          = ∑ i : Fin n, k*(L j i * y i) :=
        Finset.sum_congr rfl (fun i _ => by ring)
      rw [h1a, Finset.mul_sum]
    rw [h1]
    ring
  rw [hmain, Finset.mul_sum]

theorem GBil_smul_left {n : ℕ} (d : Fin n → ℝ) (L : Fin n → Fin n → ℝ)
    (k : ℝ) (x y : Fin n → ℝ) :
    GBil d L (fun i => k*x i) y = k*GBil d L x y := by
  rw [GBil_symm, GBil_smul_right, GBil_symm]

end FT1536.Run2.T5Tilt
