import B20.C.ScalarParser
set_option maxRecDepth 16384
set_option maxHeartbeats 8000000
open B20.C.Scalar
example : parseExpr 4 1 (["s", "<<", "63"].map String.toList) = some ((.bin .shl (.var "s".toList) (.literal .i32 63)), []) := by rfl
