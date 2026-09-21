import NodeArithmetic
set_option maxRecDepth 32768
set_option maxHeartbeats 30000000
namespace FT1536Forward
theorem leaf_checked_10 : FT1536Tables.units_10.all leafCheck=true := by decide
#print axioms leaf_checked_10
end FT1536Forward
