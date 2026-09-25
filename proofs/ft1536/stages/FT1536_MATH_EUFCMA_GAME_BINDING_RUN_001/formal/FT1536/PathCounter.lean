import FT1536.Divergence
import FT1536.EventTransfer
import FT1536.PaidSteps

/-! # Pathwise paid-step counter (the `Q_s` bound from per-run budgets)

`PaidSteps.paid_counter_chi2` bounds the transcript second moment by the
number of paid *indices*. For an adaptive adversary the Sign steps sit at
history-dependent positions: index `i` may be paid on some histories and
shared on others. What the adversary budget actually bounds is the number of
Sign queries **along every run** (every path through the history tree).

This module proves the pathwise counter lemma: if along each path at most
`Q_s` transitions are paid (differing kernels with `second ≤ 1+e`), while all
other transitions use literally equal kernels, then the whole transcript
obeys `second ≤ (1+e)^Q_s`.

Proof: the potential `Φ_k = ∑_x (∏ step density ratios) / (1+e)^(paid count
on x)` is non-increasing (each step contributes a factor
`second/(1+e)^paid ≤ 1`), starts at `1`, and dominates
`second·(1+e)^(-Q_s)`. No `sorry` in this module. -/

namespace FT1536.PathCounter
open Finset Divergence

variable {α : Type} [Fintype α]

/-- Number of paid transitions along the run that produced `x`: step `i` is
evaluated on the length-`i` prefix (`x.1` in the recursive shape). -/
def countPath (paidAt : (k : ℕ) → Hist α k → Bool) : (n : ℕ) → Hist α n → ℕ
  | 0, _ => 0
  | n+1, x => countPath paidAt n x.1 + (if paidAt n x.1 then 1 else 0)

omit [Fintype α] in
theorem countPath_succ (paidAt : (k : ℕ) → Hist α k → Bool) (n : ℕ) (x : Hist α (n+1)) :
    countPath paidAt (n+1) x = countPath paidAt n x.1 + (if paidAt n x.1 then 1 else 0) := rfl

omit [Fintype α] in
theorem countPath_zero (paidAt : (k : ℕ) → Hist α k → Bool) (x : Hist α 0) :
    countPath paidAt 0 x = 0 := rfl

/-- Step density ratio `j²/p` at one transition. -/
noncomputable def stepRatio {k : ℕ} (j p : Hist α k → Law α) (x : Hist α k) (a : α) : ℝ :=
  (j x).mass a ^ 2 / (p x).mass a

/-- The product identity for density ratios (division by zero evaluates to 0
on both sides, so it holds unconditionally). -/
theorem stepRatio_split {k : ℕ} (j p : Hist α k → Law α) (x : Hist α k) (a : α)
    (T S : Law (Hist α k)) :
    (T.mass x * (j x).mass a) ^ 2 / (S.mass x * (p x).mass a) =
      (T.mass x ^ 2 / S.mass x) * stepRatio j p x a := by
  unfold stepRatio
  by_cases hs : S.mass x = 0
  · simp [hs]
  · by_cases hp : (p x).mass a = 0
    · simp [hp]
    · field_simp

/-- The potential `Φ_n`: path-density weighted by `(1+e)^(-paid count)`. -/
noncomputable def potential (j p : (n : ℕ) → Hist α n → Law α)
    (paidAt : (k : ℕ) → Hist α k → Bool) (e : ℝ) (n : ℕ) : ℝ :=
  ∑ x : Hist α n, ((transcript j n).mass x ^ 2 / (transcript p n).mass x)
    / (1 + e) ^ countPath paidAt n x

/-- One-step update of the potential: the added factor is
`second / (1+e)^paid ≤ 1`. -/
theorem potential_succ_le (j p : (n : ℕ) → Hist α n → Law α)
    (paidAt : (k : ℕ) → Hist α k → Bool) (e : ℝ) (he : 0 ≤ e)
    (hshared : ∀ k x, paidAt k x = false → j k x = p k x)
    (hpaid : ∀ k x, paidAt k x = true → second (j k x) (p k x) ≤ 1 + e)
    (k : ℕ) :
    potential j p paidAt e (k+1) ≤ potential j p paidAt e k := by
  unfold potential
  have hsplit : (∑ x : Hist α (k+1),
      ((transcript j (k+1)).mass x ^ 2 / (transcript p (k+1)).mass x)
        / (1 + e) ^ countPath paidAt (k+1) x)
      = ∑ h : Hist α k,
          (((transcript j k).mass h ^ 2 / (transcript p k).mass h)
            / (1 + e) ^ countPath paidAt k h
            * (∑ a : α, stepRatio (j k) (p k) h a / (1 + e) ^ (if paidAt k h then 1 else 0))) := by
    rw [Fintype.sum_prod_type]
    refine Finset.sum_congr rfl ?_
    intro h _
    rw [Finset.mul_sum]
    refine Finset.sum_congr rfl ?_
    intro a _
    have hj : (transcript j (k+1)).mass (h, a)
        = (transcript j k).mass h * (j k h).mass a := rfl
    have hp : (transcript p (k+1)).mass (h, a)
        = (transcript p k).mass h * (p k h).mass a := rfl
    rw [hj, hp, stepRatio_split (j k) (p k) h a (transcript j k) (transcript p k),
      countPath_succ paidAt k (h, a), pow_add]
    have hne : (1 + e : ℝ) ≠ 0 := by linarith
    field_simp
  rw [hsplit]
  refine Finset.sum_le_sum ?_
  intro h _
  have hsum : (∑ a : α, stepRatio (j k) (p k) h a / (1 + e) ^ (if paidAt k h then 1 else 0)) ≤ 1 := by
    rw [← Finset.sum_div]
    have hstep : (∑ a : α, stepRatio (j k) (p k) h a) = second (j k h) (p k h) := by
      unfold second stepRatio
      rfl
    cases hpk : paidAt k h with
    | true =>
      rw [hstep]
      have hform : ((1 + e) ^ (if true = true then (1:ℕ) else 0)) = 1 + e := by simp
      rw [hform]
      have hb := hpaid k h hpk
      have hne : (0:ℝ) ≤ 1 + e := by linarith
      exact (div_le_div_of_nonneg_right hb hne).trans_eq
        (div_self (by linarith))
    | false =>
      rw [hstep, hshared k h hpk]
      have hform : ((1 + e) ^ (if false = true then (1:ℕ) else 0)) = 1 := by simp
      rw [hform, PaidSteps.second_self]
      simp
  have hbase : 0 ≤ ((transcript j k).mass h ^ 2 / (transcript p k).mass h)
      / (1 + e) ^ countPath paidAt k h :=
    div_nonneg (div_nonneg (sq_nonneg _) ((transcript p k).nonneg h))
      (pow_nonneg (by linarith : (0:ℝ) ≤ 1 + e) _)
  have := mul_le_mul_of_nonneg_left hsum hbase
  simpa [mul_one] using this

-- The potential starts at 1 and never grows.
theorem potential_le_one (j p : (n : ℕ) → Hist α n → Law α)
    (paidAt : (k : ℕ) → Hist α k → Bool) (e : ℝ) (he : 0 ≤ e)
    (hshared : ∀ k x, paidAt k x = false → j k x = p k x)
    (hpaid : ∀ k x, paidAt k x = true → second (j k x) (p k x) ≤ 1 + e)
    (n : ℕ) :
    potential j p paidAt e n ≤ 1 := by
  have hP0 : potential j p paidAt e 0 = 1 := by
    unfold potential
    simp [transcript, countPath, Law.pure]
  induction n with
  | zero => exact le_of_eq hP0
  | succ k ih => exact (potential_succ_le j p paidAt e he hshared hpaid k).trans ih

/-- **Pathwise paid-step counter lemma.** Per-run paid count ≤ `Qs` implies
the transcript second moment is at most `(1+e)^Qs`, independently of the
total number of machine transitions. -/
theorem paid_counter_pathwise
    (j p : (n : ℕ) → Hist α n → Law α)
    (paidAt : (k : ℕ) → Hist α k → Bool) (e : ℝ) (he : 0 ≤ e)
    (hshared : ∀ k x, paidAt k x = false → j k x = p k x)
    (hpaid : ∀ k x, paidAt k x = true → second (j k x) (p k x) ≤ 1 + e)
    (Qs : ℕ) {n : ℕ}
    (hcount : ∀ x : Hist α n, countPath paidAt n x ≤ Qs) :
    second (transcript j n) (transcript p n) ≤ (1 + e) ^ Qs := by
  have hPn : potential j p paidAt e n ≤ 1 :=
    potential_le_one j p paidAt e he hshared hpaid n
  have hsumeq : (second (transcript j n) (transcript p n))
      = ∑ x : Hist α n,
          (((transcript j n).mass x ^ 2 / (transcript p n).mass x)
            / (1 + e) ^ countPath paidAt n x) * (1 + e) ^ countPath paidAt n x := by
    show (∑ x : Hist α n, (transcript j n).mass x ^ 2 / (transcript p n).mass x) = _
    refine Finset.sum_congr rfl ?_
    intro x _
    have hpow : (1 + e : ℝ) ^ countPath paidAt n x ≠ 0 :=
      pow_ne_zero _ (by linarith)
    field_simp
  rw [hsumeq]
  calc (∑ x : Hist α n,
        (((transcript j n).mass x ^ 2 / (transcript p n).mass x)
          / (1 + e) ^ countPath paidAt n x) * (1 + e) ^ countPath paidAt n x)
      ≤ ∑ x : Hist α n,
        (((transcript j n).mass x ^ 2 / (transcript p n).mass x)
          / (1 + e) ^ countPath paidAt n x) * (1 + e) ^ Qs := by
        refine Finset.sum_le_sum ?_
        intro x _
        have hcx : countPath paidAt n x ≤ Qs := hcount x
        have hpow := pow_le_pow_right₀ (by linarith : (1:ℝ) ≤ 1 + e) hcx
        have hne : 0 ≤ ((transcript j n).mass x ^ 2 / (transcript p n).mass x)
            / (1 + e) ^ countPath paidAt n x :=
          div_nonneg (div_nonneg (sq_nonneg _) ((transcript p n).nonneg x))
            (pow_nonneg (by linarith : (0:ℝ) ≤ 1 + e) _)
        exact mul_le_mul_of_nonneg_left hpow hne
    _ = (∑ x : Hist α n,
          ((transcript j n).mass x ^ 2 / (transcript p n).mass x)
            / (1 + e) ^ countPath paidAt n x) * (1 + e) ^ Qs := by
        rw [← Finset.sum_mul]
    _ ≤ (1 + e) ^ Qs := by
        have hmul : potential j p paidAt e n * (1 + e) ^ Qs ≤ (1 + e) ^ Qs := by
          have h := mul_le_mul_of_nonneg_right hPn
            (pow_nonneg (by linarith : (0:ℝ) ≤ 1 + e) Qs)
          rw [one_mul] at h
          exact h
        have hdef : (((∑ x : Hist α n,
            ((transcript j n).mass x ^ 2 / (transcript p n).mass x)
              / (1 + e) ^ countPath paidAt n x)) * (1 + e) ^ Qs)
            = potential j p paidAt e n * (1 + e) ^ Qs := rfl
        rw [hdef]
        exact hmul

end FT1536.PathCounter
