import Source3.PublicTriplePredicate170

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.TripleBlockCertificate170_2
open PublicTriplePredicate170 (predicate)

theorem block12 : PublicBlockChecks170.block predicate 12=true := by decide +kernel
theorem block13 : PublicBlockChecks170.block predicate 13=true := by decide +kernel
theorem block14 : PublicBlockChecks170.block predicate 14=true := by decide +kernel
theorem block15 : PublicBlockChecks170.block predicate 15=true := by decide +kernel
theorem block16 : PublicBlockChecks170.block predicate 16=true := by decide +kernel
theorem block17 : PublicBlockChecks170.block predicate 17=true := by decide +kernel

end FT1536.Source3.TripleBlockCertificate170_2
