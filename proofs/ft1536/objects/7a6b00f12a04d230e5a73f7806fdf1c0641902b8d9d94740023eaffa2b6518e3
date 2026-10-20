import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Order
import Mathlib.Topology.Algebra.InfiniteSum.Ring
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Analysis.Real.Pi.Bounds

/-!
# ThetaPoisson — Faza A: kanapka Θ(c) i wartość S₀ przez sumację Poissona

* `thetaQ c = ∑' n:ℤ, exp(-c·n²)` — theta jednowymiarowa.
* Kanapka: `1 ≤ thetaQ c ≤ 1 + 4·exp(-c)` dla `c ≥ 1`.
* `S0 u = ∑' n:ℤ, exp(-u·n²) = √(π/u)·thetaQ(π²/u)` dla `u > 0`
  (dokładna wartość przez `Real.tsum_exp_neg_mul_int_sq`).
* `S0_bounds`: dolna i górna granica dla `0 < u ≤ 9`.
-/

namespace FT1536.ThetaPoisson

open Real

/-! ## Narzędzia -/

theorem two_le_exp_one : (2:ℝ) ≤ Real.exp 1 := by
  have h := Real.add_one_le_exp 1
  linarith

/-! ## Sumowalność -/

theorem exp_sq_summable_nat (c : ℝ) (hc : 1 ≤ c) :
    Summable (fun n : ℕ => Real.exp (-(c:ℝ) * (n:ℝ)^2)) := by
  have hsplit : ∀ n : ℕ,
      Real.exp (-(c:ℝ) * (n:ℝ)^2)
        = Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2)
          * Real.exp (c * (2 * (n:ℝ) + 1)) := by
    intro n
    rw [← Real.exp_add]
    congr 1
    have hexp : ((n:ℝ) + 1)^2 = (n:ℝ)^2 + 2*(n:ℝ) + 1 := by ring
    rw [hexp]
    ring
  refine summable_of_ratio_norm_eventually_le (r := 1/2) (by norm_num) ?_
  filter_upwards with n
  have hnc : (1:ℝ) ≤ c * (2*(n:ℝ) + 1) := by
    have hc1 : (1:ℝ) ≤ (c:ℝ) := by exact_mod_cast hc
    have hn0 : (0:ℝ) ≤ (n:ℝ) := Nat.cast_nonneg n
    have hn1 : (1:ℝ) ≤ 2*(n:ℝ) + 1 := by linarith
    nlinarith
  have hmono : Real.exp 1 ≤ Real.exp (c * (2*(n:ℝ) + 1)) :=
    (Real.exp_le_exp).2 hnc
  have hpos : 0 < Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2) := Real.exp_pos _
  have hkey : 2 * Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2)
      ≤ Real.exp (-(c:ℝ) * (n:ℝ)^2) := by
    rw [hsplit n]
    calc 2 * Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2)
        ≤ Real.exp 1 * Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2) :=
            mul_le_mul_of_nonneg_right two_le_exp_one hpos.le
      _ = Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2) * Real.exp 1 := by ring
      _ ≤ Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2) * Real.exp (c * (2*(n:ℝ) + 1)) :=
            mul_le_mul_of_nonneg_left hmono hpos.le
  simp only [Real.norm_eq_abs, abs_of_nonneg (Real.exp_pos _).le,
    Nat.cast_add, Nat.cast_one]
  nlinarith [hkey]

theorem exp_sq_even (c : ℝ) :
    Function.Even (fun n : ℤ => Real.exp (-c * (n:ℝ)^2)) := by
  intro n
  show Real.exp (-(c:ℝ) * (((-n : ℤ) : ℝ)^2)) = Real.exp (-(c:ℝ) * ((n:ℝ)^2))
  push_cast
  congr 1
  ring

theorem exp_sq_summable (c : ℝ) (hc : 1 ≤ c) :
    Summable (fun n : ℤ => Real.exp (-(c:ℝ) * (n:ℝ)^2)) := by
  rw [summable_int_iff_summable_nat_and_neg]
  have hn := exp_sq_summable_nat c hc
  refine ⟨hn, hn.congr (fun n => ?_)⟩
  push_cast
  congr 1
  ring

theorem exp_sq_summable_nat_succ (c : ℝ) (hc : 1 ≤ c) :
    Summable (fun k : ℕ => Real.exp (-(c:ℝ) * ((k:ℝ) + 1)^2)) := by
  have h := (summable_nat_add_iff 1).mpr (exp_sq_summable_nat c hc)
  refine Summable.congr h (fun k => ?_)
  show Real.exp (-(c:ℝ) * (((k + 1 : ℕ) : ℝ)^2))
     = Real.exp (-(c:ℝ) * ((k:ℝ) + 1)^2)
  push_cast; rfl

/-! ## Θ(c) — definicja i kanapka -/

noncomputable def thetaQ (c : ℝ) : ℝ := ∑' n : ℤ, Real.exp (-c * (n:ℝ)^2)

theorem thetaQ_ge_one (c : ℝ) (hc : 1 ≤ c) : 1 ≤ thetaQ c := by
  have h := Summable.le_tsum (exp_sq_summable c hc) 0
    (fun j _ => (Real.exp_pos _).le)
  have h0 : Real.exp (-c * ((0:ℤ):ℝ)^2) = 1 := by norm_num
  rw [h0] at h
  exact h

theorem thetaQ_le (c : ℝ) (hc : 1 ≤ c) : thetaQ c ≤ 1 + 4 * Real.exp (-c) := by
  have hsum := exp_sq_summable c hc
  have hdecomp0 := tsum_int_eq_zero_add_two_mul_tsum_pnat (exp_sq_even c) hsum
  -- 2•X = X + X = 2*X (nsmul w AddCommGroup — nie SMul ℝ ℝ!)
  have hsmul : ∀ (X : ℝ), (2:ℕ) • X = 2 * X := fun X => by
    rw [two_nsmul]
    ring
  rw [hsmul] at hdecomp0
  -- wymuszam jawne postacie zredukowane (defeq przez beta)
  have hdecomp1 : (∑' n : ℤ, Real.exp (-c * (n:ℝ)^2))
      = Real.exp (-c * ((0:ℤ):ℝ)^2)
        + 2 * (∑' n : ℕ+, Real.exp (-c * (((((n : ℕ+) : ℕ) : ℤ) : ℝ)^2))) := hdecomp0
  -- reindexacja ℕ+ → ℕ przez bijekcję k ↦ k+1
  have hpnat : (∑' n : ℕ+, Real.exp (-c * (((((n : ℕ+) : ℕ) : ℤ) : ℝ)^2)))
      = (∑' k : ℕ, Real.exp (-c * ((k:ℝ) + 1)^2)) := by
    have heq := Equiv.tsum_eq (Equiv.pnatEquivNat.symm)
      (fun n : ℕ+ => Real.exp (-c * (((((n : ℕ+) : ℕ) : ℤ) : ℝ)^2)))
    rw [← heq]
    congr 1
    funext k
    show Real.exp (-c * (Int.cast (Nat.cast (k + 1)))^2)
       = Real.exp (-c * ((k:ℝ) + 1)^2)
    push_cast; rfl
  rw [hpnat] at hdecomp1
  have h0 : Real.exp (-c * ((0:ℤ):ℝ)^2) = 1 := by norm_num
  rw [h0] at hdecomp1
  -- hdecomp1 : ∑' n:ℤ = 1 + 2 * ∑' k:ℕ, exp(-c·(k+1)²)
  have hexpc : Real.exp (-(c:ℝ)) ≤ 1/2 := by
    have h : Real.exp (-(c:ℝ)) ≤ Real.exp (-(1:ℝ)) :=
      (Real.exp_le_exp).2 (by linarith)
    rw [Real.exp_neg 1] at h
    have he : (0:ℝ) < Real.exp 1 := Real.exp_pos 1
    have h2e : (2:ℝ) ≤ Real.exp 1 := two_le_exp_one
    have hp : 0 ≤ (Real.exp 1)⁻¹ := by positivity
    have hprod : (Real.exp 1)⁻¹ * Real.exp 1 = 1 := inv_mul_cancel₀ (ne_of_gt he)
    have hle : (Real.exp 1)⁻¹ * 2 ≤ (Real.exp 1)⁻¹ * Real.exp 1 :=
      mul_le_mul_of_nonneg_left h2e hp
    rw [hprod] at hle
    rw [le_div_iff₀ (by norm_num : (0:ℝ) < 2)]
    nlinarith
  -- porównanie punktowe z szeregiem geometrycznym
  have hpoint : ∀ k : ℕ,
      Real.exp (-(c:ℝ) * ((k:ℝ) + 1)^2)
        ≤ Real.exp (-(c:ℝ)) * (Real.exp (-(c:ℝ)))^(k:ℕ) := by
    intro k
    have hkm : (k:ℝ) + 1 ≤ ((k:ℝ) + 1)^2 := by
      have h1 : (1:ℝ) ≤ (k:ℝ) + 1 := by
        have : (0:ℝ) ≤ (k:ℝ) := Nat.cast_nonneg (k:ℕ)
        linarith
      nlinarith
    have hc0 : (0:ℝ) ≤ c := by linarith
    have hmul : ((k:ℝ) + 1) * (c:ℝ) ≤ ((k:ℝ) + 1)^2 * (c:ℝ) :=
      mul_le_mul_of_nonneg_right hkm hc0
    have h1 : (-(c:ℝ)) * ((k:ℝ) + 1)^2 ≤ (-(c:ℝ)) * ((k:ℝ) + 1) := by
      nlinarith [hmul]
    have h2 := (Real.exp_le_exp).2 h1
    have hcst : ((k:ℝ) + 1) = ((k + 1:ℕ):ℝ) := by
      push_cast; rfl
    have hpow : Real.exp (-(c:ℝ) * ((k:ℝ) + 1))
        = Real.exp (-(c:ℝ)) * (Real.exp (-(c:ℝ)))^(k:ℕ) := by
      rw [hcst, Real.exp_mul, Real.rpow_natCast, pow_succ]
      ring
    exact h2.trans (le_of_eq hpow)
  have hge0 : 0 ≤ Real.exp (-(c:ℝ)) := (Real.exp_pos _).le
  have hlt1 : Real.exp (-(c:ℝ)) < 1 := by
    rw [← Real.exp_zero]
    exact (Real.exp_lt_exp).2 (by linarith)
  have hbase : Summable (fun k : ℕ => (Real.exp (-(c:ℝ)))^(k:ℕ)) :=
    summable_geometric_of_lt_one hge0 hlt1
  have hshiftg : Summable (fun k : ℕ =>
      Real.exp (-(c:ℝ)) * (Real.exp (-(c:ℝ)))^(k:ℕ)) :=
    Summable.mul_left (Real.exp (-(c:ℝ))) hbase
  have hval : ∑' k : ℕ, Real.exp (-(c:ℝ)) * (Real.exp (-(c:ℝ)))^(k:ℕ)
      = Real.exp (-(c:ℝ)) / (1 - Real.exp (-(c:ℝ))) := by
    rw [tsum_mul_left, tsum_geometric_of_lt_one hge0 hlt1]
    field_simp
  have hle : ∑' k : ℕ, Real.exp (-(c:ℝ) * ((k:ℝ) + 1)^2)
      ≤ Real.exp (-(c:ℝ)) / (1 - Real.exp (-(c:ℝ))) := by
    have h1 := Summable.tsum_le_tsum (fun k => hpoint k)
      (exp_sq_summable_nat_succ c hc) hshiftg
    rw [hval] at h1
    exact h1
  have hfin : Real.exp (-(c:ℝ)) / (1 - Real.exp (-(c:ℝ)))
      ≤ 2 * Real.exp (-(c:ℝ)) := by
    have hp : 0 < 1 - Real.exp (-(c:ℝ)) := by
      have : Real.exp (-(c:ℝ)) < 1 := hlt1
      linarith
    rw [div_le_iff₀ hp]
    have h1 : (1:ℝ) ≤ 2 * (1 - Real.exp (-(c:ℝ))) := by linarith [hexpc]
    calc Real.exp (-(c:ℝ)) = 1 * Real.exp (-(c:ℝ)) := by rw [one_mul]
      _ ≤ 2 * (1 - Real.exp (-(c:ℝ))) * Real.exp (-(c:ℝ)) :=
          mul_le_mul_of_nonneg_right h1 hge0
      _ = 2 * Real.exp (-(c:ℝ)) * (1 - Real.exp (-(c:ℝ))) := by ring
  show ∑' n : ℤ, Real.exp (-c * (n:ℝ)^2) ≤ 1 + 4 * Real.exp (-c)
  rw [hdecomp1]
  calc 1 + 2 * (∑' k : ℕ, Real.exp (-(c:ℝ) * ((k:ℝ) + 1)^2))
      ≤ 1 + 2 * (Real.exp (-(c:ℝ)) / (1 - Real.exp (-(c:ℝ)))) :=
        add_le_add (le_refl 1) (mul_le_mul_of_nonneg_left hle (by norm_num))
    _ ≤ 1 + 2 * (2 * Real.exp (-(c:ℝ))) :=
        add_le_add (le_refl 1) (mul_le_mul_of_nonneg_left hfin (by norm_num))
    _ = 1 + 4 * Real.exp (-c) := by ring

/-! ## S₀ i dokładna wartość Poissona -/

noncomputable def S0 (u : ℝ) : ℝ := ∑' n : ℤ, Real.exp (-(u:ℝ) * (n:ℝ)^2)

theorem S0_poisson (u : ℝ) (hu : 0 < u) :
    S0 u = Real.sqrt (Real.pi / u) * thetaQ (Real.pi^2 / u) := by
  have ha : 0 < u / Real.pi := by positivity
  have h := Real.tsum_exp_neg_mul_int_sq ha
  -- h : ∑' n, exp(-π·(u/π)·n²) = 1/(u/π)^(1/2) · ∑' n, exp(-π/(u/π)·n²)
  have hconv : ∀ n : ℤ,
      (-Real.pi * (u / Real.pi)) * (n:ℝ)^2 = (-(u:ℝ)) * (n:ℝ)^2 := by
    intro n
    field_simp
  have hconv2 : ∀ n : ℤ,
      (-Real.pi / (u / Real.pi)) * (n:ℝ)^2
        = (-(Real.pi^2 / u)) * (n:ℝ)^2 := by
    intro n
    field_simp
  have hfun : (fun n : ℤ => Real.exp ((-Real.pi * (u / Real.pi)) * (n:ℝ)^2))
      = fun n : ℤ => Real.exp (-(u:ℝ) * (n:ℝ)^2) := by
    funext n
    rw [hconv n]
  have hfun2 : (fun n : ℤ => Real.exp ((-Real.pi / (u / Real.pi)) * (n:ℝ)^2))
      = fun n : ℤ => Real.exp (-(Real.pi^2 / u) * (n:ℝ)^2) := by
    funext n
    rw [hconv2 n]
  rw [hfun, hfun2] at h
  have hpowconv : (1:ℝ) / (u / Real.pi)^(1/2:ℝ) = Real.sqrt (Real.pi / u) := by
    rw [one_div, ← Real.inv_rpow (by positivity) (1/2:ℝ)]
    have hflip : (u / Real.pi)⁻¹ = Real.pi / u := by field_simp
    rw [hflip, Real.sqrt_eq_rpow]
  show ∑' n : ℤ, Real.exp (-(u:ℝ) * (n:ℝ)^2)
      = Real.sqrt (Real.pi / u) * thetaQ (Real.pi^2 / u)
  rw [hpowconv] at h
  rw [h]
  rfl

theorem S0_bounds (u : ℝ) (hu : 0 < u) (hu9 : u ≤ 9) :
    Real.sqrt (Real.pi / u) ≤ S0 u ∧
    S0 u ≤ Real.sqrt (Real.pi / u) * (1 + 4 * Real.exp (-(Real.pi^2 / u))) := by
  have hc : 1 ≤ Real.pi^2 / u := by
    have h3 : (3:ℝ) ≤ Real.pi := le_of_lt Real.pi_gt_three
    exact (one_le_div_iff).2 (Or.inl ⟨hu, by nlinarith [h3, hu9]⟩)
  constructor
  · rw [S0_poisson u hu]
    exact le_mul_of_one_le_right (by positivity) (thetaQ_ge_one _ hc)
  · rw [S0_poisson u hu]
    exact mul_le_mul_of_nonneg_left (thetaQ_le _ hc) (by positivity)

end FT1536.ThetaPoisson
