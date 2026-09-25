import FT1536.Basic

namespace FT1536.Divergence
open Finset
variable {α β : Type*} [Fintype α] [Fintype β]

def AC (j p : Law α) : Prop := ∀ x, p.mass x = 0 → j.mass x = 0

noncomputable def second (j p : Law α) : ℝ := ∑ x, j.mass x ^ 2 / p.mass x

noncomputable def chi2 (j p : Law α) : ENNReal := by
  classical
  exact if AC j p then ENNReal.ofReal (second j p - 1) else ⊤

theorem support_mismatch (j p : Law α) (x : α) (hp : p.mass x = 0)
    (hj : j.mass x ≠ 0) : chi2 j p = ⊤ := by
  classical
  simp only [chi2]
  exact if_neg (fun h => hj (h x hp))

/- A density is relative to the honest law p, not the reverse direction. -/
structure Density (j p : Law α) where
  ratio : α → ℝ
  nonneg : ∀ x, 0 ≤ ratio x
  factor : ∀ x, j.mass x = p.mass x * ratio x

noncomputable def densityOfAC (j p : Law α) (h : AC j p) : Density j p where
  ratio x := j.mass x / p.mass x
  nonneg x := div_nonneg (j.nonneg x) (p.nonneg x)
  factor x := by
    by_cases hx : p.mass x = 0
    · simp [hx, h x hx]
    · field_simp

noncomputable def energy (p : Law α) (r : α → ℝ) : ℝ := ∑ x, p.mass x * r x ^ 2

theorem density_mean (j p : Law α) (d : Density j p) :
    ∑ x, p.mass x * d.ratio x = 1 := by
  simpa only [← d.factor] using j.total

theorem energy_eq_second (j p : Law α) (d : Density j p) :
    energy p d.ratio = second j p := by
  apply sum_congr rfl
  intro x _
  rw [d.factor]
  by_cases hx : p.mass x = 0
  · simp [hx]
  · field_simp

theorem centered_energy (j p : Law α) (d : Density j p) :
    (∑ x, p.mass x * (d.ratio x - 1)^2) = energy p d.ratio - 1 := by
  calc
    _ = (∑ x, p.mass x * d.ratio x ^ 2) -
        2 * (∑ x, p.mass x * d.ratio x) + ∑ x, p.mass x := by
      simp_rw [← mul_sum, ← sum_sub_distrib, ← sum_add_distrib]
      apply sum_congr rfl
      intro x _
      ring
    _ = _ := by rw [density_mean, p.total]; unfold energy; ring

theorem weighted_cauchy (p : Law α) (u v : α → ℝ) :
    (∑ x, p.mass x * u x * v x)^2 ≤
      (∑ x, p.mass x * u x ^ 2) * ∑ x, p.mass x * v x ^ 2 := by
  apply sum_sq_le_sum_mul_sum_of_sq_le_mul
  · intro x _; exact mul_nonneg (p.nonneg x) (sq_nonneg _)
  · intro x _; exact mul_nonneg (p.nonneg x) (sq_nonneg _)
  · intro x _; exact le_of_eq (by ring)

theorem energy_ge_one (j p : Law α) (d : Density j p) : 1 ≤ energy p d.ratio := by
  have h : 0 ≤ ∑ x, p.mass x * (d.ratio x - 1)^2 :=
    sum_nonneg fun x _ => mul_nonneg (p.nonneg x) (sq_nonneg _)
  rw [centered_energy] at h
  linarith

/- Full-history step: the next transition k(x) may depend arbitrarily on x.
The pair (x,y), rather than a state with forgotten observations, is retained. -/
noncomputable def joint (p : Law α) (k : α → Law β) : Law (α × β) where
  mass z := p.mass z.1 * (k z.1).mass z.2
  nonneg z := mul_nonneg (p.nonneg _) ((k _).nonneg _)
  total := by simp [Fintype.sum_prod_type, ← mul_sum, Law.total]

theorem joint_chi2 (j p : Law α) (l k : α → Law β) :
    second (joint j l) (joint p k) =
      ∑ x, (j.mass x ^ 2 / p.mass x) * second (l x) (k x) := by
  simp only [second, joint, Fintype.sum_prod_type]
  apply sum_congr rfl
  intro x _
  rw [mul_sum]
  apply sum_congr rfl
  intro y _
  simp only [mul_pow, mul_div_mul_comm]

theorem joint_ac (j p : Law α) (l k : α → Law β) (h : AC j p)
    (hk : ∀ x, j.mass x ≠ 0 → AC (l x) (k x)) : AC (joint j l) (joint p k) := by
  intro z hz
  rcases mul_eq_zero.mp hz with hz | hz
  · simp [joint, h z.1 hz]
  · by_cases hj : j.mass z.1 = 0
    · simp [joint, hj]
    · simp [joint, hk z.1 hj z.2 hz]

theorem joint_bound (j p : Law α) (l k : α → Law β) (C : ℝ)
    (h : ∀ x, j.mass x ≠ 0 → second (l x) (k x) ≤ C) :
    second (joint j l) (joint p k) ≤ second j p * C := by
  rw [joint_chi2, second, sum_mul]
  apply sum_le_sum
  intro x _
  by_cases hx : j.mass x = 0
  · simp [hx]
  · exact mul_le_mul_of_nonneg_left (h x hx) (div_nonneg (sq_nonneg _) (p.nonneg _))

theorem image_conditional_bound (j p : Law α) (l k : α → Law β)
    (eImg eSign : ℝ) (hImg : second j p ≤ 1 + eImg) (hs : 0 ≤ 1 + eSign)
    (hSign : ∀ x, j.mass x ≠ 0 → second (l x) (k x) ≤ 1 + eSign) :
    second (joint j l) (joint p k) - 1 ≤ (1+eImg)*(1+eSign)-1 := by
  have h := joint_bound j p l k (1+eSign) hSign
  have h' := mul_le_mul_of_nonneg_right hImg hs
  linarith

end FT1536.Divergence
