import Run2.LegalKeyErrorTransfer
namespace FT1536.Run2.GuaranteedDigits
open LegalKeyErrorTransfer CorrectnessProbability
noncomputable def rawLo : ℝ := 1266068 / 10^30
noncomputable def rawHi : ℝ := 1267826 / 10^30
noncomputable def flatBudget : ℝ := 1 / 2^36
noncomputable def rejectBudget : ℝ := 1 / 2^24
theorem exact_decimal_margin :
  (1265 : ℝ)/10^27 < rawLo/(1+flatBudget) ∧
  rawHi/((1-flatBudget)*(1-rejectBudget)) < (1275 : ℝ)/10^27 := by
  norm_num [rawLo,rawHi,flatBudget,rejectBudget]
theorem three_significant_digits (h : FT1536.Relation.Rq)
    (raw : rawLo ≤ rawBad ∧ rawBad ≤ rawHi)
    (flat : FiniteFlat h flatBudget)
    (reject : ∀ c,rejection h c ≤ rejectBudget) :
    (1265 : ℝ)/10^27 < delta h ∧ delta h < (1275 : ℝ)/10^27 := by
  have hh := all_key_error_from_local_certificates h flatBudget rejectBudget
    (by norm_num [flatBudget]) (by norm_num [flatBudget]) (by norm_num [rejectBudget]) flat reject
  have hl := div_le_div_of_nonneg_right raw.1 (show 0≤1+flatBudget by norm_num [flatBudget])
  have hu := div_le_div_of_nonneg_right raw.2
    (show 0≤(1-flatBudget)*(1-rejectBudget) by norm_num [flatBudget,rejectBudget])
  exact ⟨exact_decimal_margin.1.trans_le (hl.trans hh.1), (hh.2.trans hu).trans_lt exact_decimal_margin.2⟩
end FT1536.Run2.GuaranteedDigits
