import FT1536.MathSign
import FT1536.Divergence

namespace FT1536.MathSign
open Finset Divergence
variable {α : Type*} [Fintype α]

noncomputable def withAbort (p : ℝ) (hp : 0 ≤ p) (hp1 : p ≤ 1) (l : Law α) : Law (Option α) where
  mass x := match x with
    | none => 1-p
    | some a => p*l.mass a
  nonneg x := by cases x with
    | none => exact sub_nonneg.mpr hp1
    | some a => exact mul_nonneg hp (l.nonneg a)
  total := by simp [Fintype.sum_option, ← mul_sum, Law.total]

noncomputable def successOnly (l : Law α) : Law (Option α) := withAbort 1 (by norm_num) (by norm_num) l

theorem geometric_acceptance (f : ℝ) (n : ℕ) :
    (∑ i ∈ range n, f^i)*(1-f) = 1-f^n := by
  induction n with
  | zero => simp
  | succ n ih => rw [sum_range_succ, add_mul, ih, pow_succ]; ring

theorem cap_mixture [DecidableEq α] (trial : Law (Option α)) (l : Law α)
    (h : ∀ x, trial.mass (some x) = (1-trial.mass none)*l.mass x) (n : ℕ) :
    (cap trial n).mass none = trial.mass none^n ∧
    ∀ x, (cap trial n).mass (some x) = (1-trial.mass none^n)*l.mass x := by
  refine ⟨cap_none trial n, ?_⟩
  intro x
  rw [cap_some, h, ← mul_assoc, geometric_acceptance]

theorem cap16_success_probability (a : ℝ) (ha : 0 ≤ a) (ha1 : a ≤ 1) :
    0 ≤ 1-(1-a)^16 ∧ 1-(1-a)^16 ≤ 1 := by
  have h0 : 0 ≤ 1-a := by linarith
  have h1 : 1-a ≤ 1 := by linarith
  constructor
  · exact sub_nonneg.mpr (pow_le_one₀ h0 h1)
  · have hh := pow_nonneg h0 16; linarith

theorem success_vs_capped_second (p : ℝ) (hp : 0 < p) (hp1 : p ≤ 1) (l : Law α) :
    second (successOnly l) (withAbort p hp.le hp1 l) = 1/p := by
  unfold second successOnly
  simp only [Fintype.sum_option, withAbort, sub_self, zero_pow (by norm_num : 2 ≠ 0),
    zero_div, one_mul, zero_add]
  calc
    _ = ∑ x, l.mass x / p := by
      apply sum_congr rfl
      intro x _
      by_cases hx : l.mass x = 0
      · simp [hx]
      · field_simp
    _ = _ := by rw [← sum_div, l.total]

theorem zero_success_support_mismatch (l : Law α) (x : α) (hx : l.mass x ≠ 0) :
    chi2 (successOnly l) (withAbort 0 (by norm_num) (by norm_num) l) = ⊤ := by
  apply support_mismatch _ _ (some x)
  · simp [withAbort]
  · simpa [successOnly, withAbort] using hx

end FT1536.MathSign
