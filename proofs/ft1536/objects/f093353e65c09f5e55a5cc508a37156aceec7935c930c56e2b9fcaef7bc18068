import Run2.A2Theta
import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation

namespace FT1536.Run2.ShiftedGaussian
open A2Theta

noncomputable def dualTerm (a t : ℝ) (n : ℤ) : ℂ :=
  Complex.exp (-(Real.pi : ℂ)/a*(n : ℂ)^2 + 2*Real.pi*Complex.I*n*t)

/- Poisson for an arbitrary real shift, derived from Mathlib's proved
   one-dimensional identity. No numerical/theta assertion is a premise. -/
theorem complex_poisson_shift (a t : ℝ) (ha : 0 < a) :
    (∑' n : ℤ, Complex.exp (-(Real.pi : ℂ)*a*((n : ℂ)+t)^2)) =
      (1/(a : ℂ)^(1/2 : ℂ)) * ∑' n : ℤ, dualTerm a t n := by
  have haC : (a : ℂ) ≠ 0 := by exact_mod_cast ne_of_gt ha
  have hp := Complex.tsum_exp_neg_quadratic
    (by exact ha : 0 < (a : ℂ).re) (-(a : ℂ)*t)
  calc
    _ = Complex.exp (-(Real.pi : ℂ)*a*(t : ℂ)^2) *
        (∑' n : ℤ, Complex.exp (-(Real.pi : ℂ)*a*(n : ℂ)^2+
          2*Real.pi*(-(a : ℂ)*t)*n)) := by
      rw [← tsum_mul_left]
      apply tsum_congr
      intro n
      rw [← Complex.exp_add]
      congr 1
      ring
    _ = Complex.exp (-(Real.pi : ℂ)*a*(t : ℂ)^2) *
        ((1/(a : ℂ)^(1/2 : ℂ)) *
          ∑' n : ℤ, Complex.exp (-(Real.pi : ℂ)/a*((n : ℂ)+Complex.I*(-(a : ℂ)*t))^2)) := by
      rw [hp]
    _ = _ := by
      rw [← mul_assoc, mul_comm (Complex.exp _) (1/(a : ℂ)^(1/2 : ℂ)), mul_assoc,
        ← tsum_mul_left]
      congr 1
      apply tsum_congr
      intro n
      rw [← Complex.exp_add]
      unfold dualTerm
      congr 1
      field_simp [haC]
      ring_nf
      simp only [Complex.I_sq]
      ring

theorem dual_term_norm (a t : ℝ) (n : ℤ) :
    ‖dualTerm a t n‖ = Real.exp (-Real.pi/a*(n : ℝ)^2) := by
  rw [dualTerm, Complex.norm_exp]
  congr 1
  simp [pow_two, Complex.mul_re, Complex.div_ofReal_re, Complex.div_ofReal_im]

noncomputable def dualTail (a t : ℝ) (n : ℤ) : ℂ :=
  if n=0 then 0 else dualTerm a t n

theorem dual_tail_majorant (a t r : ℝ) (hr0 : 0 < r) (hr1 : r < 1)
    (hbase : Real.exp (-Real.pi/a) ≤ r) (n : ℤ) : ‖dualTail a t n‖ ≤ axis r n := by
  by_cases hn : n=0
  · simp [dualTail, axis, hn]
  · simp only [dualTail, axis, hn, ite_false, dual_term_norm]
    calc
      _ = gaussianAtom (Real.pi/a) (n,0) := by
        simp [gaussianAtom, Geometry.block, neg_div]
      _ = powerWeight (Real.exp (-(Real.pi/a))) (n,0) := gaussian_as_power _ _
      _ ≤ powerWeight r (n,0) := by
        unfold powerWeight
        exact pow_le_pow_left₀ (Real.exp_pos _).le (by simpa only [neg_div] using hbase) _
      _ ≤ r^n.natAbs := pow_le_pow_of_le_one hr0.le hr1.le (degree_axis n)

theorem dual_series_deviation (a t r : ℝ) (hr0 : 0 < r) (hr1 : r < 1)
    (hbase : Real.exp (-Real.pi/a) ≤ r) :
    ‖(∑' n : ℤ, dualTerm a t n)-1‖ ≤ 2*r/(1-r) := by
  have haxis := hasSum_axis r hr0.le hr1
  have hbound := dual_tail_majorant a t r hr0 hr1 hbase
  have hnorm : Summable (fun n : ℤ => ‖dualTail a t n‖) :=
    haxis.summable.of_nonneg_of_le (fun _ => norm_nonneg _) hbound
  have htail : Summable (dualTail a t) := hnorm.of_norm
  have hs := (hasSum_ite_eq (0 : ℤ) (1 : ℂ)).add htail.hasSum
  have he (n : ℤ) : (if n=0 then (1 : ℂ) else 0)+dualTail a t n=dualTerm a t n := by
    by_cases hn : n=0 <;> simp [dualTail, dualTerm, hn]
  simp_rw [he] at hs
  have heq : (∑' n : ℤ, dualTerm a t n)-1 = ∑' n : ℤ, dualTail a t n := by
    rw [hs.tsum_eq]
    ring
  rw [heq]
  have hu := hnorm.tsum_le_tsum hbound haxis.summable
  rw [haxis.tsum_eq] at hu
  exact (norm_tsum_le_tsum_norm hnorm).trans hu

noncomputable def continuousMass (a : ℝ) : ℝ := 1/a^(1/2 : ℝ)
noncomputable def shiftedMass (a t : ℝ) : ℝ :=
  ∑' n : ℤ, Real.exp (-Real.pi*a*((n : ℝ)+t)^2)

theorem shifted_summable (a t : ℝ) (ha : 0 < a) :
    Summable (fun n : ℤ => Real.exp (-Real.pi*a*((n : ℝ)+t)^2)) := by
  have hk : 0 < Real.pi*a/2 := by positivity
  have hinj : Function.Injective (fun n : ℤ => (n,(0 : ℤ))) := by
    intro x y h
    exact congrArg Prod.fst h
  have hs := (gaussian_summable (Real.pi*a/2) hk).comp_injective hinj
  have hc : Summable (fun n : ℤ => Real.exp (-Real.pi*a/2*(n : ℝ)^2)) := by
    simpa [Function.comp_def, gaussianAtom, Geometry.block, neg_div] using hs
  refine (hc.mul_left (Real.exp (Real.pi*a*t^2))).of_nonneg_of_le
    (fun n => (Real.exp_pos _).le) ?_
  intro n
  rw [← Real.exp_add]
  apply Real.exp_le_exp.mpr
  have hh := mul_nonneg (mul_pos Real.pi_pos ha).le (sq_nonneg ((n : ℝ)+2*t))
  nlinarith

theorem continuousMass_positive (a : ℝ) (ha : 0 < a) : 0 < continuousMass a := by
  unfold continuousMass
  positivity

theorem real_poisson_shift (a t : ℝ) (ha : 0 < a) :
    shiftedMass a t = continuousMass a*(∑' n : ℤ, dualTerm a t n).re := by
  have hp := complex_poisson_shift a t ha
  have hc : ((continuousMass a : ℝ) : ℂ) = 1/(a : ℂ)^(1/2 : ℂ) := by
    simp only [continuousMass, Complex.ofReal_div, Complex.ofReal_one,
      Complex.ofReal_cpow ha.le, Complex.ofReal_ofNat]
  have hs : ((shiftedMass a t : ℝ) : ℂ) =
      ∑' n : ℤ, Complex.exp (-(Real.pi : ℂ)*a*((n : ℂ)+t)^2) := by
    simp only [shiftedMass, Complex.ofReal_tsum, Complex.ofReal_exp, Complex.ofReal_mul,
      Complex.ofReal_neg, Complex.ofReal_pow, Complex.ofReal_add, Complex.ofReal_intCast]
  rw [← hs, ← hc] at hp
  have hh := congrArg Complex.re hp
  simpa only [Complex.ofReal_re, Complex.mul_re, Complex.ofReal_im, zero_mul, sub_zero] using hh

theorem shifted_mass_bounds (a t r : ℝ) (ha : 0 < a) (hr0 : 0 < r) (hr1 : r < 1)
    (hbase : Real.exp (-Real.pi/a) ≤ r) :
    (1-2*r/(1-r))*continuousMass a ≤ shiftedMass a t ∧
      shiftedMass a t ≤ (1+2*r/(1-r))*continuousMass a := by
  have hd := dual_series_deviation a t r hr0 hr1 hbase
  have hr := (Complex.abs_re_le_norm ((∑' n : ℤ, dualTerm a t n)-1)).trans hd
  simp only [Complex.sub_re, Complex.one_re] at hr
  obtain ⟨hl,hu⟩ := abs_le.mp hr
  rw [real_poisson_shift a t ha]
  have hc := (continuousMass_positive a ha).le
  constructor
  · have hh := mul_le_mul_of_nonneg_left (show 1-2*r/(1-r) ≤
        (∑' n : ℤ, dualTerm a t n).re by linarith) hc
    simpa only [mul_comm] using hh
  · have hh := mul_le_mul_of_nonneg_left (show (∑' n : ℤ, dualTerm a t n).re ≤
        1+2*r/(1-r) by linarith) hc
    simpa only [mul_comm] using hh

end FT1536.Run2.ShiftedGaussian
