import Source3.PublicTriplePredicate170

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.TripleBlockCertificate170_0
open PublicTriplePredicate170 (predicate)

theorem block0 : PublicBlockChecks170.block predicate 0=true := by decide +kernel
theorem block1 : PublicBlockChecks170.block predicate 1=true := by decide +kernel
theorem block2 : PublicBlockChecks170.block predicate 2=true := by decide +kernel
theorem block3 : PublicBlockChecks170.block predicate 3=true := by decide +kernel
theorem block4 : PublicBlockChecks170.block predicate 4=true := by decide +kernel
theorem block5 : PublicBlockChecks170.block predicate 5=true := by decide +kernel

end FT1536.Source3.TripleBlockCertificate170_0
