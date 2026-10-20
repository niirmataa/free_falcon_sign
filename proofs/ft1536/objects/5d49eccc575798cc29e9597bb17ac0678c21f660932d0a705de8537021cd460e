import FT1536.RetryDivergence

namespace FT1536.Run2.EmitMixture
open Finset Divergence
variable {α : Type} [Fintype α]

noncomputable def mix (pi : ℝ) (h0 : 0 ≤ pi) (h1 : pi ≤ 1) (l : Law (Option α)) :
    Law (Option α) where
  mass o := pi*l.mass o + if o = none then 1-pi else 0
  nonneg o := add_nonneg (mul_nonneg h0 (l.nonneg o)) (by split_ifs <;> linarith)
  total := by
    rw [sum_add_distrib, ← mul_sum, l.total]
    simp

theorem abort_mass (pi : ℝ) (h0 : 0 ≤ pi) (h1 : pi ≤ 1) (l : Law (Option α)) :
    (mix pi h0 h1 l).mass none = 1-pi+pi*l.mass none := by simp [mix]; ring

theorem success_mass (l : Law (Option α)) : ∑ x, l.mass (some x) = 1-l.mass none := by
  have h := l.total
  rw [Fintype.sum_option] at h
  linarith

theorem nonabort_probability (pi : ℝ) (h0 : 0 ≤ pi) (h1 : pi ≤ 1) (l : Law (Option α)) :
    (∑ x, (mix pi h0 h1 l).mass (some x)) = pi*(1-l.mass none) := by
  simp only [mix, Option.some_ne_none, ite_false, add_zero, ← mul_sum, success_mass]

theorem mix_ac (pi : ℝ) (h0 : 0 < pi) (h1 : pi ≤ 1) (l : Law (Option α)) :
    AC l (mix pi h0.le h1 l) := by
  intro o ho
  have hh : 0 ≤ if o = none then 1-pi else 0 := by split_ifs <;> linarith
  have hm : pi*l.mass o = 0 := by
    have hn := mul_nonneg h0.le (l.nonneg o)
    change pi*l.mass o + _ = 0 at ho
    linarith
  exact (mul_eq_zero.mp hm).resolve_left (ne_of_gt h0)

theorem exact_second (pi : ℝ) (h0 : 0 < pi) (h1 : pi ≤ 1) (l : Law (Option α)) :
    second l (mix pi h0.le h1 l) =
      (1-l.mass none)/pi + l.mass none^2/(1-pi+pi*l.mass none) := by
  unfold second
  rw [Fintype.sum_option, abort_mass]
  have hs : (∑ x, l.mass (some x)^2 / (mix pi h0.le h1 l).mass (some x)) =
      (1-l.mass none)/pi := by
    calc
      _ = ∑ x, l.mass (some x)/pi := by
        apply sum_congr rfl
        intro x _
        simp only [mix, Option.some_ne_none, ite_false, add_zero]
        by_cases hx : l.mass (some x) = 0
        · simp [hx]
        · field_simp
      _ = _ := by rw [← sum_div, success_mass]
  rw [hs, add_comm]

theorem second_le_inv (pi : ℝ) (h0 : 0 < pi) (h1 : pi ≤ 1) (l : Law (Option α)) :
    second l (mix pi h0.le h1 l) ≤ 1/pi := by
  have hh (o : Option α) : l.mass o^2 / (mix pi h0.le h1 l).mass o ≤ l.mass o/pi := by
    by_cases hz : l.mass o = 0
    · simp [hz]
    · have hp : 0 < l.mass o := lt_of_le_of_ne (l.nonneg o) (Ne.symm hz)
      have hc : pi*l.mass o ≤ (mix pi h0.le h1 l).mass o := by
        simp only [mix]
        have he : 0 ≤ if o = none then 1-pi else 0 := by split_ifs <;> linarith
        linarith
      have hk : 0 < (mix pi h0.le h1 l).mass o := (mul_pos h0 hp).trans_le hc
      apply (div_le_iff₀ hk).2
      have hm := mul_le_mul_of_nonneg_left hc (div_nonneg hp.le h0.le)
      have he : l.mass o/pi*(pi*l.mass o) = l.mass o^2 := by field_simp
      rwa [he] at hm
  calc
    _ ≤ ∑ o, l.mass o/pi := sum_le_sum fun o _ => hh o
    _ = _ := by rw [← sum_div, l.total]

theorem exact_chi2 (pi : ℝ) (h0 : 0 < pi) (h1 : pi ≤ 1) (l : Law (Option α)) :
    1+(chi2 l (mix pi h0.le h1 l)).toReal =
      (1-l.mass none)/pi + l.mass none^2/(1-pi+pi*l.mass none) := by
  rw [chi2_toReal _ _ (mix_ac pi h0 h1 l)]
  have h := exact_second pi h0 h1 l
  linarith

theorem pi_one (l : Law (Option α)) (o : Option α) :
    (mix 1 (by norm_num) (by norm_num) l).mass o = l.mass o := by simp [mix]

theorem pi_one_abort_zero (l : Law (Option α)) (hb : l.mass none = 0) :
    second l (mix 1 (by norm_num) (by norm_num) l) = 1 := by
  simpa [hb] using exact_second 1 (by norm_num) (by norm_num) l

theorem pi_zero_abort_one (l : Law (Option α)) (hb : l.mass none = 1) (o : Option α) :
    (mix 0 (by norm_num) (by norm_num) l).mass o = l.mass o := by
  cases o with
  | none => simp [mix,hb]
  | some x =>
    have hs := success_mass l
    rw [hb, sub_self] at hs
    have hx : l.mass (some x) = 0 := (sum_eq_zero_iff_of_nonneg (fun y _ => l.nonneg (some y))).mp hs x (mem_univ x)
    simp [mix,hx]

theorem pi_zero_mismatch (l : Law (Option α)) (hb : l.mass none ≠ 1) :
    chi2 l (mix 0 (by norm_num) (by norm_num) l) = ⊤ := by
  have hs := success_mass l
  have hex : ∃ x, l.mass (some x) ≠ 0 := by
    by_contra hn
    push Not at hn
    simp [hn] at hs
    exact hb (by linarith)
  obtain ⟨x,hx⟩ := hex
  exact support_mismatch _ _ (some x) (by simp [mix]) hx

/- Emit can already contain an abort; no disjoint-support hypothesis appears. -/
theorem cap_emit [DecidableEq α] {β : Type} [Fintype β] [DecidableEq β]
    (trial : Law (Option α)) (accepted : Law α) (emit : α → Option β)
    (h : ∀ x, trial.mass (some x) = (1-trial.mass none)*accepted.mass x)
    (n : ℕ) (o : Option β) :
    ((MathSign.cap trial n).map (MathSign.emit emit)).mass o =
      (1-trial.mass none^n) * (accepted.map emit).mass o +
      if o = none then trial.mass none^n else 0 := by
  have hm := MathSign.cap_mixture trial accepted h n
  simp only [Law.map, Law.bind, Law.pure, Fintype.sum_option]
  dsimp only [MathSign.emit]
  rw [hm.1]
  simp_rw [hm.2]
  rw [mul_sum]
  simp_rw [mul_assoc]
  by_cases ho : o = none <;> simp [ho, add_comm, mul_ite]
  apply sum_congr rfl
  intro x _
  by_cases hx : o = emit x <;> simp [hx]

end FT1536.Run2.EmitMixture
