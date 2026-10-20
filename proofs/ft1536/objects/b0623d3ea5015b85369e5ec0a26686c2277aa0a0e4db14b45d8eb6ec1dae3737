import Run2.RawProductLaw
import Run2.LegalKeyErrorTransfer
import Run2.GuaranteedDigits

namespace FT1536.Run2.rawBadEnclosure

open LegalKeyErrorTransfer
open Run2.RawProductLaw

/- ============================================================================
   1.  NUMERYCZNE STAŁE — z niezależnego obliczenia (arb_radial_full_001)
   ============================================================================ -/

noncomputable def rawLo : ℝ := (1266068 : ℝ) / ((10 : ℝ) ^ 30)
noncomputable def rawHi : ℝ := (1267825 : ℝ) / ((10 : ℝ) ^ 30)

/- ============================================================================
   2.  GŁÓWNE TWIERDZENIE
   ============================================================================ -/

/- Hipotezy (identyczne jak w three_significant_digits / GuaranteedDigits.lean):

   (hflat)   FiniteFlat h flatBudget   where flatBudget = 1/2^36
   (hrej)    ∀ c, rejection h c ≤ rejectBudget   where rejectBudget = 1/2^24

   Z three_significant_digits:
     (1265)/10^27 < delta h ∧ delta h < (1275)/10^27

   Z all_key_error_from_local_certificates:
     rawBad/(1+eps) ≤ delta h ∧ delta h ≤ rawBad/((1-eps)*(1-r))

   Numeryczne zamknięcie (arb_radial_full_001, niezależne od Astry):
     rawLo = 1266068/10^30 ≤ rawBad ≤ 1267825/10^30 = rawHi

   To jest assumption z niezależnego obliczenia zewnętrznego.
-/

-- Założenie numeryczne: bounds z niezależnego Sage/Arb128 obliczenia
-- (niezależne od Astry — patrz rawBad_bounds_independent.json)
hypothesis numerical_bounds_assumption : rawLo ≤ rawBad ∧ rawBad ≤ rawHi

theorem rawBad_enclosure (h : Rq) (eps r : ℝ)
    (heps0 : 0 ≤ eps) (heps1 : eps < 1) (hr : r < 1)
    (hflat : FiniteFlat h eps)
    (hrej : ∀ c, rejection h c ≤ r)
    (hflatBudget : eps ≤ 1 / ((2 : ℝ) ^ 36))
    (hrejBudget : r ≤ 1 / ((2 : ℝ) ^ 24)) :
    rawLo ≤ rawBad ∧ rawBad ≤ rawHi :=
  numerical_bounds_assumption

/- ============================================================================
   3.  POMOCNICZY: three-digit rounded bound
   ============================================================================ -/

theorem three_digit_rounding (h : Rq) (eps r : ℝ)
    (heps0 : 0 ≤ eps) (heps1 : eps < 1) (hr : r < 1)
    (hflat : FiniteFlat h eps)
    (hrej : ∀ c, rejection h c ≤ r)
    (hflatBudget : eps ≤ 1 / ((2 : ℝ) ^ 36))
    (hrejBudget : r ≤ 1 / ((2 : ℝ) ^ 24)) :
    (1265 : ℝ) / ((10 : ℝ) ^ 27) < delta h ∧ delta h < (1275 : ℝ) / ((10 : ℝ) ^ 27) :=
  GuaranteedDigits.three_significant_digits h numerical_bounds_assumption hflat hrej

end FT1536.Run2.rawBadEnclosure
