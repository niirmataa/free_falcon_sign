import Source3.PublicStagePredicate170_3

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StageBlockCertificate170_3_3
open PublicStagePredicate170_3 (predicate)

theorem block18 : PublicBlockChecks170.block predicate 18=true := by decide +kernel
theorem block19 : PublicBlockChecks170.block predicate 19=true := by decide +kernel
theorem block20 : PublicBlockChecks170.block predicate 20=true := by decide +kernel
theorem block21 : PublicBlockChecks170.block predicate 21=true := by decide +kernel
theorem block22 : PublicBlockChecks170.block predicate 22=true := by decide +kernel
theorem block23 : PublicBlockChecks170.block predicate 23=true := by decide +kernel

end FT1536.Source3.StageBlockCertificate170_3_3
