-- FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001: nearest-even rounding-gap lemma.
-- Frame: half-integer units (a word T stands for the value T/2). The dyadic
-- lifting to arbitrary 2^-e denominators is the exact scaling map kernel-checked
-- in POST/RINT_REFINEMENT and cross-checked by the tie controls in
-- checks/gap_composition.py. The definition mirrors fpr_rint literally
-- (fpr-emulated.h 99-115): round the MAGNITUDE with ties to even, then apply the
-- symmetric signed reconstruction. Parity tests use trunc-mod, whose zero test
-- is sign-blind. Coverage: T = 2v (strict gap) and T = 2v+1 (tie) range over all
-- integers of both signs.

namespace Ft1536.IntRecovery

/-- Signed nearest-even rint on half-integer words T (value T/2):
magnitude rounding with ties to even, then sign restoration. -/
def rintHalf (T : Int) : Int :=
  if 0 ≤ T then
    (if T % 2 = 0 then T / 2 else if (T / 2) % 2 = 0 then T / 2 else T / 2 + 1)
  else
    -(if (-T) % 2 = 0 then (-T) / 2
      else if ((-T) / 2) % 2 = 0 then (-T) / 2 else (-T) / 2 + 1)

/-- Strict gap: for t = T/2 and integral v with |t - v| < 1/2 (i.e. T = 2v),
rint(t) = v. -/
theorem rint_strict_gap (T v : Int) (h : T = 2 * v) : rintHalf T = v := by
  unfold rintHalf
  by_cases hT : 0 ≤ T
  · by_cases hm : T % 2 = 0
    · simp [hT, hm]; omega
    · by_cases hm2 : (T / 2) % 2 = 0
      · simp [hT, hm2]; omega
      · simp [hT, hm2]; omega
  · by_cases hm : (-T) % 2 = 0
    · simp [hT, hm]; omega
    · by_cases hm2 : ((-T) / 2) % 2 = 0
      · simp [hT, hm2]; omega
      · simp [hT, hm2]; omega

/-- Tie at |t - v| = 1/2 (T = 2v+1) with v even: nearest-even returns v. -/
theorem rint_tie_even_low (T v : Int) (he : v % 2 = 0) (h : T = 2 * v + 1) :
    rintHalf T = v := by
  unfold rintHalf
  by_cases hT : 0 ≤ T
  · by_cases hm : T % 2 = 0
    · simp [hT, hm]; omega
    · by_cases hm2 : (T / 2) % 2 = 0
      · simp [hT, hm2]; omega
      · simp [hT, hm2]; omega
  · by_cases hm : (-T) % 2 = 0
    · simp [hT, hm]; omega
    · by_cases hm2 : ((-T) / 2) % 2 = 0
      · simp [hT, hm2]; omega
      · simp [hT, hm2]; omega

/-- Tie at |t - v| = 1/2 (T = 2v+1) with v odd: nearest-even returns the even
neighbour v+1 (the fpr_rint increment rule). -/
theorem rint_tie_odd_up (T v : Int) (ho : v % 2 ≠ 0) (h : T = 2 * v + 1) :
    rintHalf T = v + 1 := by
  unfold rintHalf
  by_cases hT : 0 ≤ T
  · by_cases hm : T % 2 = 0
    · simp [hT, hm]; omega
    · by_cases hm2 : (T / 2) % 2 = 0
      · simp [hT, hm2]; omega
      · simp [hT, hm2]; omega
  · by_cases hm : (-T) % 2 = 0
    · simp [hT, hm]; omega
    · by_cases hm2 : ((-T) / 2) % 2 = 0
      · simp [hT, hm2]; omega
      · simp [hT, hm2]; omega

/-- Parity accounting is complete: at a tie with v odd the outcome is never v. -/
theorem rint_tie_odd_never_low (T v : Int) (ho : v % 2 ≠ 0) (h : T = 2 * v + 1) :
    rintHalf T ≠ v := by
  rw [rint_tie_odd_up T v ho h]
  intro hc
  omega

/-- Uniqueness of the strict-gap image. -/
theorem rint_strict_unique (T v w : Int) (h1 : T = 2 * v) (h2 : T = 2 * w) : v = w := by
  omega

/-- Pairwise recovery form used by the consumer: two strict-gap words recover
their integral reference pair. -/
theorem rint_pair_recovery (T1 T2 v1 v2 : Int)
    (h1 : T1 = 2 * v1) (h2 : T2 = 2 * v2) :
    rintHalf T1 = v1 ∧ rintHalf T2 = v2 := by
  exact ⟨rint_strict_gap T1 v1 h1, rint_strict_gap T2 v2 h2⟩

end Ft1536.IntRecovery

#print axioms Ft1536.IntRecovery.rint_strict_gap
#print axioms Ft1536.IntRecovery.rint_tie_even_low
#print axioms Ft1536.IntRecovery.rint_tie_odd_up
#print axioms Ft1536.IntRecovery.rint_tie_odd_never_low
#print axioms Ft1536.IntRecovery.rint_pair_recovery
