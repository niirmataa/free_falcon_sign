import Source3.FprAddTotal
import Source3.FprMulTotal
import Source3.FprDivTotal
import Source3.FprFuelPins
import Source3.StableBinaryRefinementGoal

namespace FT1536.Source3.FprAllTotal

theorem all_pinned_fpr_words_defined : StableBinaryRefinementGoal.allPinnedFprWordsDefined :=
  ⟨FprAddTotal.add_total,FprMulTotal.mul_total,FprDivTotal.div_total⟩

end FT1536.Source3.FprAllTotal

#check @FT1536.Source3.FprAllTotal.all_pinned_fpr_words_defined
#print FT1536.Source3.FprAllTotal.all_pinned_fpr_words_defined
#print axioms FT1536.Source3.FprAllTotal.all_pinned_fpr_words_defined
