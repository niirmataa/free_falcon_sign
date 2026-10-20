import FT1536.Divergence
import Run2.LawBinding

/-! # Second-moment toolkit (rung B4)

Tools for the missing `delta -> e` composition: pointwise multiplicative
bounds on a law pair give `second j p <= (1+d)^2` (hence a chi-square
certificate `e <= (1+d)^2 - 1`), and conditioning on an event transfers
`second` with the conservative `1/m^2` factor. All statements are about
the pinned types `FT1536.Law` and `FT1536.Divergence.second/AC`; no new
model is introduced. No unfinished-proof markers; standard axioms only.
-/

namespace FT1536.SecondMoment
open Finset

variable {α : Type*} [Fintype α]

/-- The second-moment functional is nonnegative. -/
theorem second_nonneg (j p : Law α) :
    0 ≤ Divergence.second j p := by
  show 0 ≤ ∑ x, j.mass x ^ 2 / p.mass x
  exact sum_nonneg (fun x _ => div_nonneg (sq_nonneg _) (p.nonneg x))

/-- Pointwise multiplicative bound => `second j p <= (1+d)^2`.
    Workhorse for chi-square certificates: a law within a one-sided factor `1+d`
    of the honest law pointwise (`j x <= (1+d) * p x`) has
    `e <= (1+d)^2 - 1`. -/
theorem second_le_of_pointwise (j p : Law α) (d : ℝ)
    (hd : 0 ≤ d) (hpt : ∀ x, j.mass x ≤ (1 + d) * p.mass x) :
    Divergence.second j p ≤ (1 + d) ^ 2 := by
  have hterm : ∀ x, j.mass x ^ 2 / p.mass x ≤ (1 + d) ^ 2 * p.mass x := by
    intro x
    rcases eq_or_ne (p.mass x) 0 with hp | hp
    · have hj : j.mass x = 0 := by
        have := hpt x
        rw [hp, mul_zero] at this
        exact le_antisymm this (j.nonneg x)
      rw [hj, hp]
      simp
    · have hj := hpt x
      have hnn : (0:ℝ) ≤ (1 + d) * p.mass x :=
        mul_nonneg (by linarith [hd]) (p.nonneg x)
      have hs : j.mass x ^ 2 ≤ ((1 + d) * p.mass x) ^ 2 := by
        rw [pow_two, pow_two]
        calc j.mass x * j.mass x
            ≤ ((1 + d) * p.mass x) * j.mass x :=
              mul_le_mul_of_nonneg_right hj (j.nonneg x)
          _ ≤ ((1 + d) * p.mass x) * ((1 + d) * p.mass x) :=
              mul_le_mul_of_nonneg_left hj hnn
      have hcancel : ((1 + d) * p.mass x) ^ 2 / p.mass x
          = (1 + d) ^ 2 * p.mass x := by
        field_simp [hp]
      have hdiv : j.mass x ^ 2 / p.mass x
          ≤ ((1 + d) * p.mass x) ^ 2 / p.mass x :=
        div_le_div_of_nonneg_right hs (p.nonneg x)
      rw [← hcancel]
      exact hdiv
  have hsum : (∑ x, j.mass x ^ 2 / p.mass x)
      ≤ ∑ x, (1 + d) ^ 2 * p.mass x := sum_le_sum (fun x _ => hterm x)
  have htot : (∑ x, (1 + d) ^ 2 * p.mass x) = (1 + d) ^ 2 := by
    rw [← mul_sum, p.total, mul_one]
  rw [htot] at hsum
  show (∑ x, j.mass x ^ 2 / p.mass x) ≤ (1 + d) ^ 2
  exact hsum

/-- Conditioning of a law on an event of POSITIVE mass (the hypothesis is
    mandatory: at mass zero the normalization fails). -/
noncomputable def LawCond (j : Law α) (E : α → Prop) [DecidablePred E]
    (hm : j.event E ≠ 0) : Law α where
  mass x := (if E x then j.mass x else 0) / j.event E
  nonneg x := by
    rcases em (E x) with h | h <;> simp only [h]
    · exact div_nonneg (j.nonneg x) (j.event_nonneg E)
    · exact div_nonneg (le_refl 0) (j.event_nonneg E)
  total := by
    show (∑ x, (if E x then j.mass x else 0) / j.event E) = 1
    have hkey : (∑ x, (if E x then j.mass x else 0) / j.event E)
        = (∑ x, (if E x then j.mass x else 0)) / j.event E :=
      (sum_div _ _ _).symm
    rw [hkey, (show (∑ x, (if E x then j.mass x else 0)) = j.event E from rfl),
      div_self hm]

theorem LawCond_mass (j : Law α) (E : α → Prop) [DecidablePred E]
    (hm : j.event E ≠ 0) (x : α) :
    (LawCond j E hm).mass x = (if E x then j.mass x else 0) / j.event E := rfl

/-- Conservative conditioning transfer: `second (j | E) p <= second j p / m^2`
    with `m = j.event E` (fallback route of B4; the primary route is a
    direct analysis of the emitted law). -/
theorem second_cond_le (j p : Law α) (E : α → Prop) [DecidablePred E]
    (hm : j.event E ≠ 0) :
    Divergence.second (LawCond j E hm) p
      ≤ Divergence.second j p / (j.event E) ^ 2 := by
  have hpt : ∀ x,
      ((if E x then j.mass x else 0) / j.event E) ^ 2 / p.mass x
        = ((if E x then j.mass x else 0) ^ 2 / p.mass x) / j.event E ^ 2 := by
    intro x
    rcases eq_or_ne (p.mass x) 0 with hp | hp
    · rw [hp]
      simp
    · field_simp [hp, hm]
  have hmono : ∀ x,
      (if E x then j.mass x else 0) ^ 2 / p.mass x
        ≤ j.mass x ^ 2 / p.mass x := by
    intro x
    rcases em (E x) with h | h
    · simp [h]
    · simp [h]
      exact div_nonneg (sq_nonneg _) (p.nonneg x)
  have h1 : (∑ x, ((if E x then j.mass x else 0) / j.event E) ^ 2 / p.mass x)
      ≤ (∑ x, ((if E x then j.mass x else 0) ^ 2 / p.mass x) / j.event E ^ 2) :=
    sum_le_sum (fun x _ => le_of_eq (hpt x))
  have h2 : (∑ x, ((if E x then j.mass x else 0) ^ 2 / p.mass x) / j.event E ^ 2)
      = (∑ x, (if E x then j.mass x else 0) ^ 2 / p.mass x) / j.event E ^ 2 :=
    (sum_div _ _ _).symm
  have h3 : (∑ x, (if E x then j.mass x else 0) ^ 2 / p.mass x)
      ≤ ∑ x, j.mass x ^ 2 / p.mass x :=
    sum_le_sum (fun x _ => hmono x)
  show (∑ x, ((if E x then j.mass x else 0) / j.event E) ^ 2 / p.mass x)
      ≤ Divergence.second j p / j.event E ^ 2
  calc (∑ x, ((if E x then j.mass x else 0) / j.event E) ^ 2 / p.mass x)
        ≤ (∑ x, ((if E x then j.mass x else 0) ^ 2 / p.mass x) / j.event E ^ 2) :=
          h1
    _ = (∑ x, (if E x then j.mass x else 0) ^ 2 / p.mass x) / j.event E ^ 2 := h2
    _ ≤ (∑ x, j.mass x ^ 2 / p.mass x) / j.event E ^ 2 :=
          div_le_div_of_nonneg_right h3 (sq_nonneg _)
    _ = Divergence.second j p / j.event E ^ 2 := rfl

/-- AC transfer from a pointwise multiplicative bound. -/
theorem ac_of_pointwise {d : ℝ} (j p : Law α)
    (hpt : ∀ x, j.mass x ≤ (1 + d) * p.mass x) :
    Divergence.AC j p := by
  intro x hx
  have := hpt x
  rw [hx, mul_zero] at this
  exact le_antisymm this (j.nonneg x)

/-- THE B4 certificate constructor (pointwise route): a sampler whose law
    is within `(1+d)` of the honest fresh-Sign law pointwise has a full
    `LocalJointCertificate` with `e = (1+d)^2 - 1` (so `e ~ 2d` for small
    `d`). Binder types are inferred from `samplerLaw`'s signature. -/
theorem localJointCertificate_of_pointwise
    (S : FT1536.Run2.Sampler) (d : ℝ) (hd : 0 ≤ d)
    (hpt : ∀ h st m r z,
      (FT1536.Run2.samplerLaw S h st m r).mass z
        ≤ (1 + d) * (FT1536.SigmaMath.freshHonest h).mass z) :
    FT1536.Run2.LocalJointCertificate S ((1 + d) ^ 2 - 1) where
  nonnegative := by
    have h : ((1 + d) ^ 2 - 1) = 2 * d + d ^ 2 := by ring
    rw [h]
    positivity
  ac h st m r :=
    ac_of_pointwise (FT1536.Run2.samplerLaw S h st m r)
      (FT1536.SigmaMath.freshHonest h) (hpt h st m r)
  moment h st m r := by
    have h1 := second_le_of_pointwise (FT1536.Run2.samplerLaw S h st m r)
      (FT1536.SigmaMath.freshHonest h) d hd (hpt h st m r)
    have h2 : (1 + d) ^ 2 = 1 + ((1 + d) ^ 2 - 1) := by ring
    rw [← h2]
    exact h1

/-- Layer composition through `Divergence.joint` (via the pinned
    `joint_chi2`): second moments multiply across layers, so per-layer
    certificates `(1+e1)`, `(1+e2)` compose to `(1+e1)*(1+e2)`. -/
theorem second_joint_le {β : Type*} [Fintype β]
    (j p : Law α) (l k : α → Law β) (e1 e2 : ℝ)
    (hj : Divergence.second j p ≤ 1 + e1)
    (hl : ∀ x, Divergence.second (l x) (k x) ≤ 1 + e2)
    (he2 : 0 ≤ 1 + e2) :
    Divergence.second (Divergence.joint j l) (Divergence.joint p k)
      ≤ (1 + e1) * (1 + e2) := by
  have hterm : ∀ x,
      (j.mass x ^ 2 / p.mass x) * Divergence.second (l x) (k x)
        ≤ (j.mass x ^ 2 / p.mass x) * (1 + e2) := by
    intro x
    exact mul_le_mul_of_nonneg_left (hl x)
      (div_nonneg (sq_nonneg _) (p.nonneg x))
  have h1 : (∑ x, (j.mass x ^ 2 / p.mass x) * Divergence.second (l x) (k x))
      ≤ ∑ x, (j.mass x ^ 2 / p.mass x) * (1 + e2) :=
    sum_le_sum (fun x _ => hterm x)
  have h2 : (∑ x, (j.mass x ^ 2 / p.mass x) * (1 + e2))
      = Divergence.second j p * (1 + e2) := by
    show (∑ x, (j.mass x ^ 2 / p.mass x) * (1 + e2))
      = (∑ x, j.mass x ^ 2 / p.mass x) * (1 + e2)
    rw [← sum_mul]
  calc Divergence.second (Divergence.joint j l) (Divergence.joint p k)
        = ∑ x, (j.mass x ^ 2 / p.mass x)
            * Divergence.second (l x) (k x) :=
          Divergence.joint_chi2 j p l k
    _ ≤ ∑ x, (j.mass x ^ 2 / p.mass x) * (1 + e2) := h1
    _ = Divergence.second j p * (1 + e2) := h2
    _ ≤ (1 + e1) * (1 + e2) := mul_le_mul_of_nonneg_right hj he2

end FT1536.SecondMoment
