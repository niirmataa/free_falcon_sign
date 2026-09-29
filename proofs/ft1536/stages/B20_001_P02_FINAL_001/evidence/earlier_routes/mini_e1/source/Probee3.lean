import B20.C.ScalarParser
set_option maxRecDepth 16384
set_option maxHeartbeats 8000000
open B20.C.Scalar
#check parseExpr 6 1 (["(", "(", "uint64_t", ")", "s", "<<", "63", ")", "|", "(", "m", ">>", "2", ")"].map String.toList)
