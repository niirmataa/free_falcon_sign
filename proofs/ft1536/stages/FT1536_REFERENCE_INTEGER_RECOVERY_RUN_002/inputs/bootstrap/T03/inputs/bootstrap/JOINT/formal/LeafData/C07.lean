import NodeArithmetic
set_option maxRecDepth 32768
set_option maxHeartbeats 30000000
namespace FT1536Forward
theorem leaf_checked_7 : FT1536Tables.units_7.all leafCheck=true := by decide
#print axioms leaf_checked_7
end FT1536Forward
