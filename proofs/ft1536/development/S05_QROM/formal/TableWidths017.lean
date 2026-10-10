import CDFProbability017

set_option maxRecDepth 32768
set_option exponentiation.threshold 100000
namespace FT1536.S05.TableWidths017
open GaussianLiterals017 CDFProbability017

theorem total_cdf_lower : 2^267≤TableData016.cdf 30720 := by decide +kernel

theorem total_cdf_width : 2^267≤TableData016.cdf 30720 ∧ TableData016.cdf 30720<2^268 := by
  refine ⟨total_cdf_lower,GaussianCheck017.total_cdf_cap.trans_lt ?_⟩
  norm_num

/-- The accepting coin has256 bits, but this actual threshold needs257 bits. -/
theorem center_threshold : TableData016.threshold 30720=2^256 := by decide +kernel

theorem threshold_storage_bound (rows : Rows) (i : SamplerCode016.PairIndex) :
    ActualTables016.tables.threshold i<2^257 :=
  (threshold_cap rows i.val i.isLt).trans_lt (by norm_num)

#print axioms total_cdf_lower
#print axioms total_cdf_width
#print axioms center_threshold
#print axioms threshold_storage_bound
end FT1536.S05.TableWidths017
