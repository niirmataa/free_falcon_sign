import FT1536.Divergence

namespace FT1536.EventTransfer
open Finset Divergence
variable {α : Type*} [Fintype α]

theorem event_quadratic (j p : Law α) (d : Density j p)
    (E : α → Prop) [DecidablePred E] (D : ℝ) (hD : energy p d.ratio - 1 ≤ D) :
    (p.event E - j.event E)^2 ≤ D * p.event E * (1 - p.event E) := by
  let f : α → ℝ := fun x => if E x then 1 else 0
  let a := p.event E
  let b := j.event E
  have mean (q : Law α) : (∑ x, q.mass x * f x) = q.event E := by
    apply sum_congr rfl
    intro x _
    dsimp [f]
    split_ifs <;> ring
  have square (q : Law α) : (∑ x, q.mass x * f x ^ 2) = q.event E := by
    apply sum_congr rfl
    intro x _
    dsimp [f]
    split_ifs <;> ring
  have variance : (∑ x, p.mass x * (f x - a)^2) = a*(1-a) := by
    calc
      _ = (∑ x, p.mass x * f x ^ 2) -
          2*a*(∑ x, p.mass x * f x) + a^2 * ∑ x, p.mass x := by
        rw [mul_sum, mul_sum, ← sum_sub_distrib, ← sum_add_distrib]
        apply sum_congr rfl
        intro x _
        ring
      _ = _ := by rw [square, mean, p.total]; dsimp [a]; ring
  have covariance : (∑ x, p.mass x * (d.ratio x - 1) * (f x - a)) = b-a := by
    calc
      _ = (∑ x, j.mass x * f x) - a*(∑ x, p.mass x * d.ratio x) -
          (∑ x, p.mass x * f x) + a*(∑ x, p.mass x) := by
        rw [mul_sum, mul_sum, ← sum_sub_distrib, ← sum_sub_distrib, ← sum_add_distrib]
        apply sum_congr rfl
        intro x _
        rw [d.factor]
        ring
      _ = _ := by rw [mean, density_mean, mean, p.total]; dsimp [a,b]; ring
  have cs := weighted_cauchy p (fun x => d.ratio x - 1) (fun x => f x - a)
  rw [covariance, centered_energy, variance] at cs
  have hn : 0 ≤ a*(1-a) := mul_nonneg (p.event_nonneg E) (sub_nonneg.mpr (p.event_le_one E))
  have hm := mul_le_mul_of_nonneg_right hD hn
  dsimp [a,b] at cs hm
  nlinarith

noncomputable def phi (D b : ℝ) : ℝ :=
  (2*b+D+Real.sqrt (D^2+4*D*b*(1-b))) / (2*(1+D))

theorem discriminant_nonneg {D b : ℝ} (hD : 0 ≤ D) (hb : 0 ≤ b) (hb1 : b ≤ 1) :
    0 ≤ D^2+4*D*b*(1-b) := by positivity

theorem phi_bound {a b D : ℝ} (hD : 0 ≤ D) (hb : 0 ≤ b) (hb1 : b ≤ 1)
    (hq : (a-b)^2 ≤ D*a*(1-a)) : a ≤ phi D b := by
  have hn := discriminant_nonneg hD hb hb1
  have hs := Real.sq_sqrt hn
  have hs0 := Real.sqrt_nonneg (D^2+4*D*b*(1-b))
  have hpoly : (1+D)*a^2-(2*b+D)*a+b^2 ≤ 0 := by nlinarith [hq]
  have hp := mul_nonpos_of_nonneg_of_nonpos (show 0 ≤ 4*(1+D) by positivity) hpoly
  unfold phi
  apply (le_div_iff₀ (show 0 < 2*(1+D) by positivity)).2
  by_contra h
  have ht : Real.sqrt (D^2+4*D*b*(1-b)) < 2*(1+D)*a-(2*b+D) := by linarith
  have hsq := mul_pos (sub_pos.mpr ht) (show 0 <
      2*(1+D)*a-(2*b+D)+Real.sqrt (D^2+4*D*b*(1-b)) by linarith)
  nlinarith [hsq]

theorem phi_zero_delta (b : ℝ) : phi 0 b = b := by simp [phi]

theorem phi_at_zero {D : ℝ} (hD : 0 ≤ D) : phi D 0 = D/(1+D) := by
  have hd : 1+D ≠ 0 := by positivity
  simp [phi, Real.sqrt_sq hD]
  field_simp
  ring

theorem phi_at_one {D : ℝ} (hD : 0 ≤ D) : phi D 1 = 1 := by
  have hd : 1+D ≠ 0 := by positivity
  simp only [phi, mul_one, sub_self, mul_zero, add_zero, Real.sqrt_sq_eq_abs,
    abs_of_nonneg hD]
  field_simp
  ring

theorem phi_ge_b {D b : ℝ} (hD : 0 ≤ D) (hb : 0 ≤ b) (hb1 : b ≤ 1) : b ≤ phi D b := by
  apply phi_bound hD hb hb1
  simp only [sub_self, ne_eq, OfNat.ofNat_ne_zero, not_false_eq_true, zero_pow]
  positivity

theorem phi_le_one {D b : ℝ} (hD : 0 ≤ D) (hb : 0 ≤ b) (hb1 : b ≤ 1) : phi D b ≤ 1 := by
  have hs := Real.sq_sqrt (discriminant_nonneg hD hb hb1)
  have hs0 := Real.sqrt_nonneg (D^2+4*D*b*(1-b))
  have hn : 0 ≤ 2*(1-b)+D := by positivity
  have hh : Real.sqrt (D^2+4*D*b*(1-b)) ≤ 2*(1-b)+D := by
    nlinarith [sq_nonneg (1-b), mul_nonneg hD (sq_nonneg (1-b))]
  unfold phi
  apply (div_le_iff₀ (show 0 < 2*(1+D) by positivity)).2
  linarith

theorem phi_satisfies {D b : ℝ} (hD : 0 ≤ D) (hb : 0 ≤ b) (hb1 : b ≤ 1) :
    (phi D b - b)^2 = D * phi D b * (1-phi D b) := by
  have hs := Real.sq_sqrt (discriminant_nonneg hD hb hb1)
  have hd : 2*(1+D) ≠ 0 := by positivity
  unfold phi
  generalize hx : Real.sqrt (D^2+4*D*b*(1-b)) = s at *
  field_simp
  nlinarith [hs]

theorem phi_mono {D b c : ℝ} (hD : 0 ≤ D) (hb : 0 ≤ b)
    (hbc : b ≤ c) (hc : c ≤ 1) : phi D b ≤ phi D c := by
  have hb1 := hbc.trans hc
  have hc0 := hb.trans hbc
  by_cases h : phi D b ≤ c
  · exact h.trans (phi_ge_b hD hc0 hc)
  · have hq := phi_satisfies hD hb hb1
    apply phi_bound hD hc0 hc
    have hcb : c < phi D b := lt_of_not_ge h
    nlinarith [sq_nonneg (c-b)]

end FT1536.EventTransfer
