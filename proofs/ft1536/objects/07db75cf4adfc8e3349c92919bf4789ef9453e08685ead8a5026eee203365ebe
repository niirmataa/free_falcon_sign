import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Order
import Mathlib.Topology.Algebra.InfiniteSum.Ring
import Mathlib.Topology.Algebra.InfiniteSum.Group
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Analysis.Real.Pi.Bounds
import Mathlib.Analysis.Complex.ExponentialBounds
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

open Real FT1536.ThetaPoisson FT1536.Theta2Split FT1536.Geometry FT1536.MgfProduct

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
      have hts : (∑' i : ℤ, (if i ∈ Finset.Icc (-N) N
            then Real.exp (-s * ((block i j : ℤ) : ℝ)) else 0))
          = ∑ i ∈ Finset.Icc (-N) N, (if i ∈ Finset.Icc (-N) N
            then Real.exp (-s * ((block i j : ℤ) : ℝ)) else 0) :=
        tsum_eq_sum (fun i hi => ite_eq_right hi)
      have h2 : (∑ i ∈ Finset.Icc (-N) N, Real.exp (-s * ((block i j : ℤ) : ℝ)))
          = ∑ i ∈ Finset.Icc (-N) N, (if i ∈ Finset.Icc (-N) N
            then Real.exp (-s * ((block i j : ℤ) : ℝ)) else 0) :=
        (Finset.sum_congr rfl (fun i hi => ite_eq_left hi)).symm
      rw [h2, hts]
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
  have hts : (∑' j : ℤ, W s j) = ∑ j ∈ Finset.Icc (-N) N, W s j :=
    tsum_eq_sum (fun j hj => W_of_not_mem s hj)
  rw [hts]
  exact (Finset.sum_congr rfl (fun j hj => W_of_mem s hj)).symm

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

/-! ## Mostek blockSum ↔ boxSum (bijekcja `dec`) -/

theorem block_comm (i j : ℤ) : block i j = block j i := by
  show (i:ℤ)^2 + i * j + j^2 = j^2 + j * i + i^2
  ring

theorem dec_mem (a : Fin 131071) : dec a ∈ Finset.Icc (-N) N := by
  rw [Finset.mem_Icc]
  show ((-N : ℤ) ≤ (a.val : ℤ) - 65535) ∧ ((a.val : ℤ) - 65535 ≤ N)
  simp only [N]
  omega

theorem dec_inj {a b : Fin 131071} (h : dec a = dec b) : a = b := by
  apply Fin.ext
  simp only [dec] at h
  omega

theorem dec_surj (m : ℤ) (hm : m ∈ Finset.Icc (-N) N) :
    ∃ a : Fin 131071, dec a = m := by
  have hm' : (-65535 : ℤ) ≤ m ∧ m ≤ 65535 := by simpa [N] using hm
  refine ⟨⟨(m + 65535).toNat, ?_⟩, ?_⟩
  · omega
  · simp only [dec]
    omega

-- Uwaga: `linter.constructorNameAsVariable` (lint stylu dla początkujących)
-- wykonuje `Meta.whnf` na typach binderów i zapętla się na instancjach liczb
-- `Fin 131071` w tym dowodzie — crash narzędzia, nie ostrzeżenie. Linter ma
-- wbudowaną opcję wyłączenia (dokumentacja w jego źródle); zakres lokalny.
set_option linter.constructorNameAsVariable false in
theorem blockSum_eq_boxSum (s : ℝ) : blockSum s = boxSum s := by
  have h1 : blockSum s = ∑ p ∈ Finset.Icc (-N) N ×ˢ Finset.Icc (-N) N,
      Real.exp (-s * ((block p.1 p.2 : ℤ) : ℝ)) := by
    show (∑ d : Fin 131071 × Fin 131071, slotVal s d) = _
    refine Finset.sum_nbij (fun d => (dec d.1, dec d.2)) ?_ ?_ ?_ ?_
    · intro d _
      rw [Finset.mem_product]
      exact ⟨dec_mem d.1, dec_mem d.2⟩
    · intro x _ y _ hCC
      obtain ⟨hAA, hBB⟩ := Prod.mk.inj hCC
      exact Prod.ext (dec_inj hAA) (dec_inj hBB)
    · intro p hII
      rw [Finset.mem_coe, Finset.mem_product] at hII
      obtain ⟨hDD, hEE⟩ := hII
      obtain ⟨x, hGG⟩ := dec_surj p.1 hDD
      obtain ⟨y, hHH⟩ := dec_surj p.2 hEE
      have hFF : (fun d => (dec d.1, dec d.2)) (x, y) = p := Prod.ext hGG hHH
      rw [Finset.coe_univ, ← hFF]
      exact Set.mem_image_of_mem _ (Set.mem_univ (x, y))
    · intro d _
      rfl
  have h2 : (∑ p ∈ Finset.Icc (-N) N ×ˢ Finset.Icc (-N) N,
      Real.exp (-s * ((block p.1 p.2 : ℤ) : ℝ))) = boxSum s := by
    have h2' : (∑ p ∈ Finset.Icc (-N) N ×ˢ Finset.Icc (-N) N,
        Real.exp (-s * ((block p.1 p.2 : ℤ) : ℝ)))
        = ∑ x ∈ Finset.Icc (-N) N, ∑ y ∈ Finset.Icc (-N) N,
          Real.exp (-s * ((block x y : ℤ) : ℝ)) :=
      Finset.sum_product' (Finset.Icc (-N) N) (Finset.Icc (-N) N)
        (fun x y => Real.exp (-s * ((block x y : ℤ) : ℝ)))
    rw [h2']
    exact Finset.sum_congr rfl (fun j hj => Finset.sum_congr rfl (fun i hi => by
      rw [block_comm]))
  rw [h1, h2]

/-! ## Kierunek dolny: ogony gaussowskie

Trik: `exp(-(s/2)·i²) = exp(-(s/4)·i²) · exp(-(s/4)·i²) ≤ exp(-(s/4)·i²) · exp(-(s/4)·65536²)`
poza kwadratem (bo `i² ≥ 65536²`). -/

/-- Suma ogonowa wewnętrzna (składnik poza kwadratem). -/
noncomputable def Tg (s : ℝ) : ℝ :=
  ∑' i : ℤ, (if i ∈ Finset.Icc (-N) N then 0
    else Real.exp (-(s/2) * ((i:ℤ):ℝ)^2))

theorem Tg_le (s : ℝ) (hs : 0 < s) :
    Tg s ≤ Real.exp (-(s/4) * 65536^2) * S0 (s/4) := by
  have hpt : ∀ i : ℤ,
      (if i ∈ Finset.Icc (-N) N then 0
        else Real.exp (-(s/2) * ((i:ℤ):ℝ)^2))
      ≤ Real.exp (-(s/4) * 65536^2) * Real.exp (-(s/4) * ((i:ℤ):ℝ)^2) := by
    intro i
    by_cases hi : i ∈ Finset.Icc (-N) N
    · rw [ite_eq_left hi]
      exact mul_nonneg (Real.exp_pos _).le (Real.exp_pos _).le
    · rw [ite_eq_right hi]
      have hci : (i:ℤ) < -N ∨ N < i := by
        rw [Finset.mem_Icc] at hi
        omega
      have hci2 : (i:ℤ) ≤ -65536 ∨ 65536 ≤ i := by
        simp only [N] at hci
        omega
      have hi2 : ((65536:ℤ))^2 ≤ (i:ℤ)^2 := by
        rcases hci2 with h | h
        · nlinarith [sq_nonneg ((i:ℤ) + 65536)]
        · nlinarith [sq_nonneg ((i:ℤ) - 65536)]
      have hi2r : ((65536:ℝ))^2 ≤ ((i:ℤ):ℝ)^2 := by
        exact_mod_cast hi2
      have hexp : Real.exp (-(s/4) * 65536^2) * Real.exp (-(s/4) * ((i:ℤ):ℝ)^2)
          = Real.exp (-(s/4) * (((i:ℤ):ℝ)^2) + -(s/4) * 65536^2) := by
        rw [← Real.exp_add, add_comm]
      rw [hexp]
      exact (Real.exp_le_exp).2 (by
        have hs4 : 0 ≤ s/4 := by positivity
        nlinarith [hs4, hi2r])
  have hsum : Summable fun i : ℤ =>
      (if i ∈ Finset.Icc (-N) N then 0
        else Real.exp (-(s/2) * ((i:ℤ):ℝ)^2)) := by
    refine Summable.of_nonneg_of_le (fun i => ?_) (fun i => ?_)
      (exp_sq_summable_pos (s/2) (by positivity))
    · by_cases hi : i ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hi]
      · rw [ite_eq_right hi]
        exact (Real.exp_pos _).le
    · by_cases hi : i ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hi]
        exact (Real.exp_pos _).le
      · rw [ite_eq_right hi]
  show Tg s ≤ _
  rw [Tg] at *
  have hle := Summable.tsum_le_tsum hpt hsum
    (Summable.mul_left _ (exp_sq_summable_pos (s/4) (by positivity)))
  have hmul : (∑' i : ℤ,
      Real.exp (-(s/4) * 65536^2) * Real.exp (-(s/4) * ((i:ℤ):ℝ)^2))
      = Real.exp (-(s/4) * 65536^2) * S0 (s/4) := by
    rw [tsum_mul_left]
    rfl
  rw [hmul] at hle
  exact hle

/-- Różnica wiersza pełnego i obciętego: rozkład na ogony. -/
theorem row_tail_eq (s : ℝ) (hs : 0 < s) (j : ℤ) (hj : j ∈ Finset.Icc (-N) N) :
    (∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) - W s j
      = ∑' i : ℤ, (if i ∈ Finset.Icc (-N) N then 0
          else Real.exp (-s * ((block i j : ℤ) : ℝ))) := by
  rw [W_of_mem s hj]
  have hsA : Summable fun i : ℤ =>
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
  have hsB : Summable fun i : ℤ =>
      (if i ∈ Finset.Icc (-N) N then 0
        else Real.exp (-s * ((block i j : ℤ) : ℝ))) := by
    refine Summable.of_nonneg_of_le (fun i => ?_) (fun i => ?_)
      (inner_summable s hs j)
    · by_cases hi : i ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hi]
      · rw [ite_eq_right hi]
        exact (Real.exp_pos _).le
    · by_cases hi : i ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hi]
        exact (Real.exp_pos _).le
      · rw [ite_eq_right hi]
  have hpt : ∀ i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))
      = (if i ∈ Finset.Icc (-N) N
          then Real.exp (-s * ((block i j : ℤ) : ℝ)) else 0)
        + (if i ∈ Finset.Icc (-N) N then 0
          else Real.exp (-s * ((block i j : ℤ) : ℝ))) := by
    intro i
    by_cases hi : i ∈ Finset.Icc (-N) N
    · rw [ite_eq_left hi, ite_eq_left hi]
      ring
    · rw [ite_eq_right hi, ite_eq_right hi]
      ring
  have hsplit : (∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ)))
      = (∑' i : ℤ, (if i ∈ Finset.Icc (-N) N
          then Real.exp (-s * ((block i j : ℤ) : ℝ)) else 0))
        + (∑' i : ℤ, (if i ∈ Finset.Icc (-N) N then 0
          else Real.exp (-s * ((block i j : ℤ) : ℝ)))) := by
    rw [tsum_congr hpt, Summable.tsum_add hsA hsB]
  have hmid : (∑' i : ℤ, (if i ∈ Finset.Icc (-N) N
        then Real.exp (-s * ((block i j : ℤ) : ℝ)) else 0))
      = ∑ i ∈ Finset.Icc (-N) N, Real.exp (-s * ((block i j : ℤ) : ℝ)) := by
    have hts : (∑' i : ℤ, (if i ∈ Finset.Icc (-N) N
          then Real.exp (-s * ((block i j : ℤ) : ℝ)) else 0))
        = ∑ i ∈ Finset.Icc (-N) N, (if i ∈ Finset.Icc (-N) N
          then Real.exp (-s * ((block i j : ℤ) : ℝ)) else 0) :=
      tsum_eq_sum (fun i hi => ite_eq_right hi)
    rw [hts]
    exact Finset.sum_congr rfl (fun i hi => ite_eq_left hi)
  rw [hmid] at hsplit
  linarith

/-- Minorant różnicowy wiersza W KWADRACIE: ogon ≤ Tg(s)·exp(-(s/2)·j²). -/
theorem row_tail_le (s : ℝ) (hs : 0 < s) (j : ℤ) (hj : j ∈ Finset.Icc (-N) N) :
    (∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) - W s j
      ≤ Tg s * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) := by
  rw [row_tail_eq s hs j hj]
  have hpt : ∀ i : ℤ,
      (if i ∈ Finset.Icc (-N) N then 0
        else Real.exp (-s * ((block i j : ℤ) : ℝ)))
      ≤ (if i ∈ Finset.Icc (-N) N then 0
        else Real.exp (-(s/2) * ((i:ℤ):ℝ)^2))
          * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) := by
    intro i
    by_cases hi : i ∈ Finset.Icc (-N) N
    · rw [ite_eq_left hi, ite_eq_left hi]
      exact mul_nonneg (le_refl 0) (Real.exp_pos _).le
    · rw [ite_eq_right hi, ite_eq_right hi]
      exact inner_majorant s hs i j
  have hs2 : 0 < s/2 := by positivity
  have hge : Summable fun i : ℤ => Real.exp (-(s/2) * ((i:ℤ):ℝ)^2) :=
    exp_sq_summable_pos (s/2) hs2
  have hmaj : Summable fun i : ℤ =>
      Real.exp (-(s/2) * ((i:ℤ):ℝ)^2) * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) :=
    Summable.mul_right (Real.exp (-(s/2) * ((j:ℤ):ℝ)^2)) hge
  have hnn : ∀ i : ℤ, 0 ≤
      (if i ∈ Finset.Icc (-N) N then 0
        else Real.exp (-(s/2) * ((i:ℤ):ℝ)^2))
        * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) := by
    intro i
    by_cases hi : i ∈ Finset.Icc (-N) N
    · rw [ite_eq_left hi]
      exact mul_nonneg (le_refl 0) (Real.exp_pos _).le
    · rw [ite_eq_right hi]
      exact mul_nonneg (Real.exp_pos _).le (Real.exp_pos _).le
  have hle2 : ∀ i : ℤ,
      (if i ∈ Finset.Icc (-N) N then 0
        else Real.exp (-(s/2) * ((i:ℤ):ℝ)^2))
        * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2)
        ≤ Real.exp (-(s/2) * ((i:ℤ):ℝ)^2) * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) := by
    intro i
    by_cases hi : i ∈ Finset.Icc (-N) N
    · rw [ite_eq_left hi, zero_mul]
      exact mul_nonneg (Real.exp_pos _).le (Real.exp_pos _).le
    · rw [ite_eq_right hi]
  have hsA : Summable fun i : ℤ =>
      (if i ∈ Finset.Icc (-N) N then 0
        else Real.exp (-(s/2) * ((i:ℤ):ℝ)^2))
        * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) :=
    Summable.of_nonneg_of_le hnn hle2 hmaj
  have hsB : Summable fun i : ℤ =>
      (if i ∈ Finset.Icc (-N) N then 0
        else Real.exp (-s * ((block i j : ℤ) : ℝ))) := by
    refine Summable.of_nonneg_of_le (fun i => ?_) (fun i => ?_)
      (inner_summable s hs j)
    · by_cases hi : i ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hi]
      · rw [ite_eq_right hi]
        exact (Real.exp_pos _).le
    · by_cases hi : i ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hi]
        exact (Real.exp_pos _).le
      · rw [ite_eq_right hi]
  have hle := Summable.tsum_le_tsum hpt hsB hsA
  have hfac : (∑' i : ℤ,
      (if i ∈ Finset.Icc (-N) N then 0
        else Real.exp (-(s/2) * ((i:ℤ):ℝ)^2))
        * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2))
      = Tg s * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) := by
    rw [tsum_mul_right]
    rfl
  rw [hfac] at hle
  exact hle

/-- Minorant wiersza POZA KWADRATEM: R j ≤ S₀(s/2)·exp(-(s/2)·j²). -/
theorem row_out_le (s : ℝ) (hs : 0 < s) (j : ℤ) :
    (∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ)))
      ≤ S0 (s/2) * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) := by
  have hpt : ∀ i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))
      ≤ Real.exp (-(s/2) * ((i:ℤ):ℝ)^2) * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) :=
    fun i => inner_majorant s hs i j
  have hs2 : 0 < s/2 := by positivity
  have hge : Summable fun i : ℤ => Real.exp (-(s/2) * ((i:ℤ):ℝ)^2) :=
    exp_sq_summable_pos (s/2) hs2
  have hsum : Summable fun i : ℤ =>
      Real.exp (-(s/2) * ((i:ℤ):ℝ)^2) * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) :=
    Summable.mul_right (Real.exp (-(s/2) * ((j:ℤ):ℝ)^2)) hge
  have hle := Summable.tsum_le_tsum hpt (inner_summable s hs j) hsum
  have hfac : (∑' i : ℤ,
      Real.exp (-(s/2) * ((i:ℤ):ℝ)^2) * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2))
      = S0 (s/2) * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) := by
    rw [tsum_mul_right]
    rfl
  rw [hfac] at hle
  exact hle

/-- Sumy rozłącznych części (j w kwadracie / poza). -/
theorem theta2_sub_boxSum_Tg (s : ℝ) (hs : 0 < s) :
    Theta2 s - boxSum s <= 2 * S0 (s/2) * Tg s := by
  have hR : Summable fun j : ℤ => (∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) :=
    row_summable s hs
  have hW : Summable fun j : ℤ => W s j := by
    refine Summable.of_nonneg_of_le (fun j => ?_) (fun j => W_le_R s hs j) hR
    by_cases hj : j ∈ Finset.Icc (-N) N
    · rw [W_of_mem s hj]
      exact Finset.sum_nonneg (fun i _ => (Real.exp_pos _).le)
    · rw [W_of_not_mem s hj]
  have hWn : ∀ j : ℤ, 0 <= W s j := by
    intro j
    by_cases hj : j ∈ Finset.Icc (-N) N
    · rw [W_of_mem s hj]
      exact Finset.sum_nonneg (fun i _ => (Real.exp_pos _).le)
    · rw [W_of_not_mem s hj]
  have hsub : (∑' j : ℤ,
      ((∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) - W s j))
      = Theta2 s - boxSum s := by
    rw [boxSum_eq_tsum_W]
    exact Summable.tsum_sub hR hW
  -- sumy rozłącznych części — NA POZIOMIE GÓRNYM (współdzielone!)
  have hs1 : Summable fun j : ℤ => (if j ∈ Finset.Icc (-N) N then
      ((∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) - W s j) else 0) := by
    refine Summable.of_nonneg_of_le (fun j => ?_) (fun j => ?_) hR
    · by_cases hj : j ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hj]
        exact sub_nonneg.mpr (W_le_R s hs j)
      · rw [ite_eq_right hj]
    · by_cases hj : j ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hj]
        exact sub_le_self _ (hWn j)
      · rw [ite_eq_right hj]
        exact tsum_nonneg (fun i => (Real.exp_pos _).le)
  have hs2 : Summable fun j : ℤ => (if j ∈ Finset.Icc (-N) N then 0 else
      ((∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) - W s j)) := by
    refine Summable.of_nonneg_of_le (fun j => ?_) (fun j => ?_) hR
    · by_cases hj : j ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hj]
      · rw [ite_eq_right hj]
        exact sub_nonneg.mpr (W_le_R s hs j)
    · by_cases hj : j ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hj]
        exact tsum_nonneg (fun i => (Real.exp_pos _).le)
      · rw [ite_eq_right hj]
        exact sub_le_self _ (hWn j)
  have hsplit : (∑' j : ℤ,
      ((∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) - W s j))
      = (∑' j : ℤ, (if j ∈ Finset.Icc (-N) N then
          ((∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) - W s j) else 0))
        + (∑' j : ℤ, (if j ∈ Finset.Icc (-N) N then 0 else
          ((∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) - W s j))) := by
    have hpt : ∀ j : ℤ,
        ((∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) - W s j)
        = (if j ∈ Finset.Icc (-N) N then
            ((∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) - W s j) else 0)
          + (if j ∈ Finset.Icc (-N) N then 0 else
            ((∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) - W s j)) := by
      intro j
      by_cases hj : j ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hj, ite_eq_left hj]
        ring
      · rw [ite_eq_right hj, ite_eq_right hj]
        ring
    rw [tsum_congr hpt, Summable.tsum_add hs1 hs2]
  -- część w kwadracie
  have hp1 : (∑' j : ℤ, (if j ∈ Finset.Icc (-N) N then
      ((∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) - W s j) else 0))
      <= Tg s * S0 (s/2) := by
    have hTg0 : 0 <= Tg s := tsum_nonneg (fun i => by
      by_cases hi : i ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hi]
      · rw [ite_eq_right hi]
        exact (Real.exp_pos _).le)
    have hpt : ∀ j : ℤ,
        (if j ∈ Finset.Icc (-N) N then
          ((∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) - W s j) else 0)
        <= (if j ∈ Finset.Icc (-N) N then
            Tg s * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) else 0) := by
      intro j
      by_cases hj : j ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hj, ite_eq_left hj]
        exact row_tail_le s hs j hj
      · rw [ite_eq_right hj, ite_eq_right hj]
    have hsA : Summable fun j : ℤ => (if j ∈ Finset.Icc (-N) N then
        Tg s * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) else 0) := by
      refine Summable.of_nonneg_of_le (fun j => ?_) (fun j => ?_)
        (Summable.mul_left (Tg s) (exp_sq_summable_pos (s/2) (by positivity)))
      · by_cases hj : j ∈ Finset.Icc (-N) N
        · rw [ite_eq_left hj]
          exact mul_nonneg hTg0 (Real.exp_pos _).le
        · rw [ite_eq_right hj]
      · by_cases hj : j ∈ Finset.Icc (-N) N
        · rw [ite_eq_left hj]
        · rw [ite_eq_right hj]
          exact mul_nonneg hTg0 (Real.exp_pos _).le
    have hle1 := Summable.tsum_le_tsum hpt hs1 hsA
    have hcm : ∀ j : ℤ,
        (if j ∈ Finset.Icc (-N) N then
          Tg s * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) else 0)
        = Tg s * (if j ∈ Finset.Icc (-N) N then
          Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) else 0) := by
      intro j
      by_cases hj : j ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hj, ite_eq_left hj]
      · rw [ite_eq_right hj, ite_eq_right hj]
        ring
    have hfac : (∑' j : ℤ, (if j ∈ Finset.Icc (-N) N then
        Tg s * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) else 0))
        = Tg s * (∑' j : ℤ, (if j ∈ Finset.Icc (-N) N then
          Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) else 0)) := by
      rw [tsum_congr hcm, tsum_mul_left]
    rw [hfac] at hle1
    have hpt2 : ∀ j : ℤ, (if j ∈ Finset.Icc (-N) N then
        Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) else 0)
        <= Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) := by
      intro j
      by_cases hj : j ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hj]
      · rw [ite_eq_right hj]
        exact (Real.exp_pos _).le
    have hsB : Summable fun j : ℤ => (if j ∈ Finset.Icc (-N) N then
        Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) else 0) := by
      refine Summable.of_nonneg_of_le (fun j => ?_) (fun j => ?_)
        (exp_sq_summable_pos (s/2) (by positivity))
      · by_cases hj : j ∈ Finset.Icc (-N) N
        · rw [ite_eq_left hj]
          exact (Real.exp_pos _).le
        · rw [ite_eq_right hj]
      · by_cases hj : j ∈ Finset.Icc (-N) N
        · rw [ite_eq_left hj]
        · rw [ite_eq_right hj]
          exact (Real.exp_pos _).le
    have hbox := Summable.tsum_le_tsum hpt2 hsB
      (exp_sq_summable_pos (s/2) (by positivity))
    exact le_trans hle1 (mul_le_mul_of_nonneg_left hbox hTg0)
  -- część poza kwadratem
  have hp2 : (∑' j : ℤ, (if j ∈ Finset.Icc (-N) N then 0 else
      ((∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) - W s j)))
      <= S0 (s/2) * Tg s := by
    have hS00 : 0 <= S0 (s/2) := tsum_nonneg (fun i => (Real.exp_pos _).le)
    have hpt : ∀ j : ℤ,
        (if j ∈ Finset.Icc (-N) N then 0 else
          ((∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) - W s j))
        <= (if j ∈ Finset.Icc (-N) N then 0 else
            S0 (s/2) * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2)) := by
      intro j
      by_cases hj : j ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hj, ite_eq_left hj]
      · rw [ite_eq_right hj, ite_eq_right hj]
        rw [W_of_not_mem s hj, sub_zero]
        exact row_out_le s hs j
    have hsC : Summable fun j : ℤ => (if j ∈ Finset.Icc (-N) N then 0 else
        S0 (s/2) * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2)) := by
      refine Summable.of_nonneg_of_le (fun j => ?_) (fun j => ?_)
        (Summable.mul_left (S0 (s/2)) (exp_sq_summable_pos (s/2) (by positivity)))
      · by_cases hj : j ∈ Finset.Icc (-N) N
        · rw [ite_eq_left hj]
        · rw [ite_eq_right hj]
          exact mul_nonneg hS00 (Real.exp_pos _).le
      · by_cases hj : j ∈ Finset.Icc (-N) N
        · rw [ite_eq_left hj]
          exact mul_nonneg hS00 (Real.exp_pos _).le
        · rw [ite_eq_right hj]
    have hle3 := Summable.tsum_le_tsum hpt hs2 hsC
    have hcm : ∀ j : ℤ,
        (if j ∈ Finset.Icc (-N) N then 0 else
          S0 (s/2) * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2))
        = S0 (s/2) * (if j ∈ Finset.Icc (-N) N then 0 else
          Real.exp (-(s/2) * ((j:ℤ):ℝ)^2)) := by
      intro j
      by_cases hj : j ∈ Finset.Icc (-N) N
      · rw [ite_eq_left hj, ite_eq_left hj]
        ring
      · rw [ite_eq_right hj, ite_eq_right hj]
    have hfac : (∑' j : ℤ, (if j ∈ Finset.Icc (-N) N then 0 else
        S0 (s/2) * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2)))
        = S0 (s/2) * Tg s := by
      rw [tsum_congr hcm, tsum_mul_left]
      rfl
    rw [hfac] at hle3
    exact hle3
  -- montaż
  rw [← hsub, hsplit]
  have hTg0' : 0 <= Tg s := tsum_nonneg (fun i => by
    by_cases hi : i ∈ Finset.Icc (-N) N
    · rw [ite_eq_left hi]
    · rw [ite_eq_right hi]
      exact (Real.exp_pos _).le)
  have hadd := add_le_add hp1 hp2
  have hfin : Tg s * S0 (s/2) + S0 (s/2) * Tg s
      = 2 * S0 (s/2) * Tg s := by ring
  linarith

/-- Forma analityczna ogona: Θ₂(s) − boxSum s ≤ 2·S₀(s/2)·e^{-(s/4)·65536²}·S₀(s/4). -/
theorem theta2_sub_boxSum_analytic (s : ℝ) (hs : 0 < s) :
    Theta2 s - boxSum s
      <= 2 * S0 (s/2) * (Real.exp (-(s/4) * 65536^2) * S0 (s/4)) := by
  have h1 := theta2_sub_boxSum_Tg s hs
  have h2 := Tg_le s hs
  have hS0 : (0:ℝ) <= S0 (s/2) := tsum_nonneg (fun i => (Real.exp_pos _).le)
  have h3pos : (0:ℝ) <= 2 * S0 (s/2) := mul_nonneg (by norm_num) hS0
  have h3 : 2 * S0 (s/2) * Tg s
      <= 2 * S0 (s/2) * (Real.exp (-(s/4) * 65536^2) * S0 (s/4)) :=
    mul_le_mul_of_nonneg_left h2 h3pos
  exact le_trans h1 h3

/-! ## Krok numeryczny: ogon ≤ 2⁻³⁰⁰ (dla s = c0 = 1/(2·768²)) -/

/-- Pomocniczy: 4·e^{-X} ≤ 1 dla X ≥ log 4. -/
theorem four_exp_neg_le_one {X : ℝ} (hX : Real.log 4 <= X) :
    (4:ℝ) * Real.exp (-X) <= 1 := by
  have hmono : Real.exp (-X) <= Real.exp (-Real.log 4) :=
    (Real.exp_le_exp).2 (neg_le_neg hX)
  have hval : Real.exp (-Real.log 4) = (4:ℝ)⁻¹ := by
    rw [Real.exp_neg, Real.exp_log (by norm_num : (0:ℝ) < 4)]
  have h4 : (4:ℝ) * Real.exp (-X) <= (4:ℝ) * Real.exp (-Real.log 4) :=
    mul_le_mul_of_nonneg_left hmono (by norm_num)
  rw [hval] at h4
  have h5 : (4:ℝ) * (4:ℝ)⁻¹ = 1 := by norm_num
  rw [h5] at h4
  exact h4

/-- Pomocniczy: log 4 ≤ 2. -/
theorem log_four_le_two : Real.log 4 <= 2 := by
  have hlt := Real.log_two_lt_d9
  have hlt2 : Real.log (4:ℝ) = 2 * Real.log 2 := by
    rw [show (4:ℝ) = 2 * 2 by norm_num, Real.log_mul (by norm_num) (by norm_num)]
    ring
  rw [hlt2]
  nlinarith

/-- S₀(s/2) ≤ 5454 dla s = c0. -/
theorem s0_half_le :
    S0 ((1 / (2 * 768^2)) / 2) <= 5454 := by
  have hu : (0:ℝ) < (1 / (2 * 768^2)) / 2 := by norm_num
  have hu9 : ((1:ℝ) / (2 * 768^2)) / 2 <= 9 := by norm_num
  have hA := (S0_bounds _ hu hu9).2
  have hpiu : (Real.pi / ((1:ℝ) / (2 * 768^2) / 2)) = Real.pi * 2359296 := by
    field_simp
    ring
  have hsq : (Real.pi * 2359296) <= 2727^2 := by
    nlinarith [Real.pi_lt_d2]
  have hsqrt : Real.sqrt (Real.pi / ((1:ℝ) / (2 * 768^2) / 2)) <= 2727 := by
    rw [hpiu]
    have h1 : Real.sqrt (Real.pi * 2359296) <= Real.sqrt (2727^2) :=
      Real.sqrt_le_sqrt hsq
    have h2 : Real.sqrt (2727^2) = 2727 := Real.sqrt_sq (by norm_num)
    rw [h2] at h1
    exact h1
  have hexp4 : (4:ℝ) * Real.exp (-(Real.pi^2 / ((1:ℝ) / (2 * 768^2) / 2))) <= 1 := by
    apply four_exp_neg_le_one
    have h4 : Real.log 4 <= 2 := log_four_le_two
    have hbig : (2:ℝ) <= Real.pi^2 / ((1:ℝ) / (2 * 768^2) / 2) := by
      have h3 : (2:ℝ) <= Real.pi^2 * 2359296 := by
        nlinarith [Real.pi_gt_three]
      have h4b : Real.pi^2 / ((1:ℝ) / (2 * 768^2) / 2) = Real.pi^2 * 2359296 := by
        field_simp
        ring
      rw [h4b]
      exact h3
    linarith
  have hbr : (1:ℝ) + 4 * Real.exp (-(Real.pi^2 / ((1:ℝ) / (2 * 768^2) / 2))) <= 2 := by
    linarith
  calc S0 ((1 / (2 * 768^2)) / 2)
      <= Real.sqrt (Real.pi / ((1:ℝ) / (2 * 768^2) / 2))
          * (1 + 4 * Real.exp (-(Real.pi^2 / ((1:ℝ) / (2 * 768^2) / 2)))) := hA
    _ <= 2727 * 2 := mul_le_mul hsqrt hbr
      (by have h := Real.exp_pos (-(Real.pi^2 / ((1:ℝ) / (2 * 768^2) / 2))); linarith)
      (by norm_num)
    _ = 5454 := by norm_num

/-- S₀(s/4) ≤ 7712 dla s = c0. -/
theorem s0_quarter_le :
    S0 ((1 / (2 * 768^2)) / 4) <= 7712 := by
  have hu : (0:ℝ) < (1 / (2 * 768^2)) / 4 := by norm_num
  have hu9 : ((1:ℝ) / (2 * 768^2)) / 4 <= 9 := by norm_num
  have hA := (S0_bounds _ hu hu9).2
  have hpiu : (Real.pi / ((1:ℝ) / (2 * 768^2) / 4)) = Real.pi * 4718592 := by
    field_simp
    ring
  have hsq : (Real.pi * 4718592) <= 3856^2 := by
    nlinarith [Real.pi_lt_d2]
  have hsqrt : Real.sqrt (Real.pi / ((1:ℝ) / (2 * 768^2) / 4)) <= 3856 := by
    rw [hpiu]
    have h1 : Real.sqrt (Real.pi * 4718592) <= Real.sqrt (3856^2) :=
      Real.sqrt_le_sqrt hsq
    have h2 : Real.sqrt (3856^2) = 3856 := Real.sqrt_sq (by norm_num)
    rw [h2] at h1
    exact h1
  have hexp4 : (4:ℝ) * Real.exp (-(Real.pi^2 / ((1:ℝ) / (2 * 768^2) / 4))) <= 1 := by
    apply four_exp_neg_le_one
    have h4 : Real.log 4 <= 2 := log_four_le_two
    have hbig : (2:ℝ) <= Real.pi^2 / ((1:ℝ) / (2 * 768^2) / 4) := by
      have h3 : (2:ℝ) <= Real.pi^2 * 4718592 := by
        nlinarith [Real.pi_gt_three]
      have h4b : Real.pi^2 / ((1:ℝ) / (2 * 768^2) / 4) = Real.pi^2 * 4718592 := by
        field_simp
        ring
      rw [h4b]
      exact h3
    linarith
  have hbr : (1:ℝ) + 4 * Real.exp (-(Real.pi^2 / ((1:ℝ) / (2 * 768^2) / 4))) <= 2 := by
    linarith
  calc S0 ((1 / (2 * 768^2)) / 4)
      <= Real.sqrt (Real.pi / ((1:ℝ) / (2 * 768^2) / 4))
          * (1 + 4 * Real.exp (-(Real.pi^2 / ((1:ℝ) / (2 * 768^2) / 4)))) := hA
    _ <= 3856 * 2 := mul_le_mul hsqrt hbr
      (by have h := Real.exp_pos (-(Real.pi^2 / ((1:ℝ) / (2 * 768^2) / 4))); linarith)
      (by norm_num)
    _ = 7712 := by norm_num

/-- Granica wykładnicza: e^{-910.2…} ≤ 2⁻³⁴⁰. -/
theorem exp_tail_le :
    Real.exp (-(1 / (2 * 768^2) / 4) * 65536^2) <= (((2:ℝ)^340)⁻¹) := by
  have hpos : (0:ℝ) < ((2:ℝ)^340)⁻¹ := by positivity
  rw [← Real.log_le_log_iff (Real.exp_pos _) hpos]
  rw [Real.log_exp, Real.log_inv, Real.log_pow 2 340]
  have hlt := Real.log_two_lt_d9
  have hL : (-(1 / (2 * 768^2) / 4) * 65536^2 : ℝ) <= -910 := by norm_num
  have hR : (-910:ℝ) <= -(340 * Real.log 2) := by nlinarith [hlt]
  linarith

-- Pomocniczy: 2^40 · (2^340)⁻¹ = (2^300)⁻¹ (próg potęgowy podniesiony —
-- parametr obliczeniowy `norm_num`, nie wyciszenie).
set_option exponentiation.threshold 512 in
theorem pow_tail_aux : (2:ℝ)^40 * ((2:ℝ)^340)⁻¹ = ((2:ℝ)^300)⁻¹ := by norm_num

-- Pomocniczy: arytmetyka progów numerycznych.
set_option exponentiation.threshold 512 in
theorem tail_numeric_aux :
    (2:ℝ) * 5454 * (((2:ℝ)^340)⁻¹ * 7712) <= ((2:ℝ)^300)⁻¹ := by norm_num

/-- KOŃCOWY KROK NUMERYCZNY: ogon ≤ 2⁻³⁰⁰ dla s = c0 = 1/(2·768²). -/
theorem tail_le_pow300 :
    Theta2 (1 / (2 * 768^2)) - boxSum (1 / (2 * 768^2)) <= ((2:ℝ)^300)⁻¹ := by
  have hs : (0:ℝ) < 1 / (2 * 768^2) := by norm_num
  have h1 := theta2_sub_boxSum_analytic (1 / (2 * 768^2)) hs
  have hA := s0_half_le
  have hB := s0_quarter_le
  have hE := exp_tail_le
  have hposA : (0:ℝ) <= S0 ((1 / (2 * 768^2)) / 2) :=
    tsum_nonneg (fun i => (Real.exp_pos _).le)
  have hposB : (0:ℝ) <= S0 ((1 / (2 * 768^2)) / 4) :=
    tsum_nonneg (fun i => (Real.exp_pos _).le)
  have hposE : (0:ℝ) <= Real.exp (-(1 / (2 * 768^2) / 4) * 65536^2) :=
    (Real.exp_pos _).le
  have h2 : Real.exp (-(1 / (2 * 768^2) / 4) * 65536^2) * S0 ((1 / (2 * 768^2)) / 4)
      <= ((2:ℝ)^340)⁻¹ * 7712 :=
    mul_le_mul hE hB hposB (by norm_num)
  have hcmp : (2:ℝ) * S0 ((1 / (2 * 768^2)) / 2)
        * (Real.exp (-(1 / (2 * 768^2) / 4) * 65536^2) * S0 ((1 / (2 * 768^2)) / 4))
      <= (2:ℝ) * 5454 * (((2:ℝ)^340)⁻¹ * 7712) :=
    mul_le_mul (mul_le_mul_of_nonneg_left hA (by norm_num)) h2
      (by nlinarith [hposE, hposB]) (by norm_num)
  have haux : (2:ℝ) * 5454 * 7712 <= (2:ℝ)^40 := by norm_num
  have hpow := pow_tail_aux
  have hall := tail_numeric_aux
  exact le_trans (le_trans h1 hcmp) hall

end FT1536.ThetaBox
