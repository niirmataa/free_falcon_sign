import Source3.KeygenIntermediateDeterminism102

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenIntermediateLiftPart3102
theorem checked : KeygenIntermediateDeterminism102.checkedCode (KeygenIntermediateLiftData.part 3) = true := by decide +kernel
end FT1536.Source3.KeygenIntermediateLiftPart3102
