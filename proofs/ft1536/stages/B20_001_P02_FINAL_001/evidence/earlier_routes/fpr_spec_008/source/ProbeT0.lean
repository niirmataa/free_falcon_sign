import B20.C.ScalarParser
set_option maxRecDepth 16384
set_option maxHeartbeats 8000000
open B20.C.Scalar
example : (parseUnary 3 (["(", "s", ")"].map String.toList)).isSome = true := by decide
