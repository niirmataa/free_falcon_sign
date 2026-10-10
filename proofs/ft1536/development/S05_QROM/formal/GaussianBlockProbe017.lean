import GaussianCheck017

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option exponentiation.threshold 100000

namespace FT1536.S05.GaussianBlockProbe017

def smallBlock : Bool := (List.range 8).all GaussianCheck017.row
theorem first_block : smallBlock=true := by decide +kernel
#print axioms first_block
end FT1536.S05.GaussianBlockProbe017
