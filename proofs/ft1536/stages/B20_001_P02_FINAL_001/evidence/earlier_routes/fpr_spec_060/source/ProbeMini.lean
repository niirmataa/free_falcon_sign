import B20.C.ScalarParser
set_option maxRecDepth 16384
set_option maxHeartbeats 8000000
open B20.C.Scalar
open B20.C (Token)
example : parseUnary 4 (["(", "uint64_t", ")", "s"].map String.toList) = some (.cast .u64 (.var "s".toList), []) := by rfl
