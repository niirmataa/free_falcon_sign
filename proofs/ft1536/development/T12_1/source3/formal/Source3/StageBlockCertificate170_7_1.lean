import Source3.PublicStagePredicate170_7

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StageBlockCertificate170_7_1
open PublicStagePredicate170_7 (predicate)

theorem block6 : PublicBlockChecks170.block predicate 6=true := by decide +kernel
theorem block7 : PublicBlockChecks170.block predicate 7=true := by decide +kernel
theorem block8 : PublicBlockChecks170.block predicate 8=true := by decide +kernel
theorem block9 : PublicBlockChecks170.block predicate 9=true := by decide +kernel
theorem block10 : PublicBlockChecks170.block predicate 10=true := by decide +kernel
theorem block11 : PublicBlockChecks170.block predicate 11=true := by decide +kernel

end FT1536.Source3.StageBlockCertificate170_7_1
