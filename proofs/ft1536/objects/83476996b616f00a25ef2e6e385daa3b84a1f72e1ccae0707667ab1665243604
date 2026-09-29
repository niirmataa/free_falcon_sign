import B20.C.ScalarParser
set_option maxRecDepth 16384
set_option maxHeartbeats 8000000
open B20.C.Scalar
example : (parseExpr 4 1 (["(", "(", "uint64_t", ")", "s", "<<", "63", ")"].map String.toList)).isSome = true := by decide
