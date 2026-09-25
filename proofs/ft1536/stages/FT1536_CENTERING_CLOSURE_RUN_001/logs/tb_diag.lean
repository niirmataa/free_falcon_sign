import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Order
import Mathlib.Topology.Algebra.InfiniteSum.Ring
import Mathlib.Topology.Algebra.InfiniteSum.Group
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Analysis.Real.Pi.Bounds
import MgfProduct
import ThetaPoisson
import Theta2Split

/-!
# ThetaBox — Faza C: blockSum ↔ Θ₂ z ogonami

`blockSum s` (suma po `Fin 131071²`, MgfProduct) równa się sumie po
kwadracie `Icc (-65535) 65535` na ℤ², a różnica z Θ₂(s) to ogony
gaussowskie. Trik: rozdzielamy Gaussa na pół —
`exp(-(s/2)·i²) ≤ exp(-(s/4)·i²) · exp(-(s/4)·(N+1)²)` poza kwadratem.
-/

attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

namespace FT1536.ThetaBox

open Real FT1536.ThetaPoisson FT1536.Theta2Split FT1536.Geometry MgfProduct

/-- Bok kwadratu centrującego. -/
def N : ℤ := 65535

/-- Suma po kwadracie na ℤ². -/
noncomputable def boxSum (s : ℝ) : ℝ :=
  ∑ j ∈ Finset.Icc (-N) N, ∑ i ∈ Finset.Icc (-N) N,
    Real.exp (-s * ((block i j : ℤ) : ℝ))

/-- Wiersz obcięty do kwadratu (0 poza). -/
noncomputable def W (s : ℝ) (j : ℤ) : ℝ :=
  if j ∈ Finset.Icc (-N) N then
    ∑ i ∈ Finset.Icc (-N) N, Real.exp (-s * ((block i j : ℤ) : ℝ))
  else 0

theorem W_of_mem (s : ℝ) {j : ℤ} (hj : j ∈ Finset.Icc (-N) N) :
    W s j = ∑ i ∈ Finset.Icc (-N) N, Real.exp (-s * ((block i j : ℤ) : ℝ)) := by
  simp only [W]
  exact ite_eq_left hj

theorem W_of_not_mem (s : ℝ) {j : ℤ} (hj : j ∉ Finset.Icc (-N) N) :
    W s j = 0 := by
  simp only [W]
  exact ite_eq_right hj

/-! ## Sumowalność wiersza pełnego -/

theorem inner_majorant (s : ℝ) (hs : 0 < s) (i j : ℤ) :
    Real.exp (-s * ((block i j : ℤ) : ℝ))
      ≤ Real.exp (-(s/2) * ((i:ℤ):ℝ)^2) * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) := by
  have hblock2 : (((i:ℝ)^2 + (j:ℝ)^2) / 2) ≤ ((block i j : ℤ) : ℝ) := by
    show (((i:ℝ)^2 + (j:ℝ)^2) / 2) ≤ (((i:ℤ)^2 + i * j + j^2 : ℤ) : ℝ)
    push_cast
    nlinarith [sq_nonneg ((i:ℝ) + (j:ℝ)), sq_nonneg (j:ℝ)]
  have h1 : -s * ((block i j : ℤ) : ℝ)
      ≤ -(s/2) * (((i:ℤ):ℝ)^2 + ((j:ℤ):ℝ)^2) := by
    have hsmul : s * ((((i:ℤ):ℝ)^2 + ((j:ℤ):ℝ)^2) / 2)
        ≤ s * ((block i j : ℤ) : ℝ) :=
      mul_le_mul_of_nonneg_left hblock2 (le_of_lt hs)
    nlinarith [hsmul]
  have h2 := (Real.exp_le_exp).2 h1
  rw [mul_add, Real.exp_add] at h2
  exact h2

theorem inner_summable (s : ℝ) (hs : 0 < s) (j : ℤ) :
    Summable fun i : ℤ => Real.exp (-s * ((block i j : ℤ) : ℝ)) := by
  refine Summable.of_nonneg_of_le (fun i => (Real.exp_pos _).le)
    (fun i => inner_majorant s hs i j) ?_
  exact Summable.mul_right (Real.exp (-(s/2) * ((j:ℤ):ℝ)^2))
    (exp_sq_summable_pos (s/2) (by positivity))

/-! ## Porównanie wierszy i kierunek łatwy boxSum ≤ Θ₂ -/

theorem W_le_R (s : ℝ) (hs : 0 < s) (j : ℤ) :
    W s j ≤ ∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ)) := by
  by_cases hj : j ∈ Finset.Icc (-N) N
  · rw [W_of_mem s hj]
    have h1 : (∑ i ∈ Finset.Icc (-N) N, Real.exp (-s * ((block i j : ℤ) : ℝ)))
        = ∑' i : ℤ, (if i ∈ Finset.Icc (-N) N
            then Real.exp (-s * ((block i j : ℤ) : ℝ)) else 0) := by
      symm
      refine tsum_eq_sum (fun i hi => ?_)
      done
    have hsum : Summable fun i : ℤ =>
        (if i ∈ Finset.Icc (-N) N
          then Real.exp (-s * ((block i j : ℤ) : ℝ)) else 0) := by
      refine Summable.of_nonneg_of_le (fun i => ?_) (fun i => ?_)
        (inner_summable s hs j)
      · by_cases hi : i ∈ Finset.Icc (-N) N
        · rw [ite_eq_left hi]
          exact (Real.exp_pos _).le
        · rw [ite_eq_right hi]
      · by_cases hi : i ∈ Finset.Icc (-N) N
        · rw [ite_eq_left hi]
        · rw [ite_eq_right hi]
          exact (Real.exp_pos _).le
    rw [h1]
    exact Summable.tsum_le_tsum (fun i => by
      by_cases hi : i ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hi]
      · rw [ite_eq_right hi]
        exact (Real.exp_pos _).le) hsum (inner_summable s hs j)
  · rw [W_of_not_mem s hj]
    exact tsum_nonneg (fun i => (Real.exp_pos _).le)

theorem boxSum_eq_tsum_W (s : ℝ) : boxSum s = ∑' j : ℤ, W s j := by
  symm
  refine tsum_eq_sum (fun j hj => ?_)
  done

theorem boxSum_le_theta2 (s : ℝ) (hs : 0 < s) : boxSum s ≤ Theta2 s := by
  have hW : Summable fun j : ℤ => W s j := by
    refine Summable.of_nonneg_of_le (fun j => ?_) (fun j => W_le_R s hs j)
      (row_summable s hs)
    by_cases hj : j ∈ Finset.Icc (-N) N
    · rw [W_of_mem s hj]
      exact Finset.sum_nonneg (fun i _ => (Real.exp_pos _).le)
    · rw [W_of_not_mem s hj]
  rw [boxSum_eq_tsum_W]
  exact Summable.tsum_le_tsum (fun j => W_le_R s hs j) hW (row_summable s hs)

end FT1536.ThetaBox
