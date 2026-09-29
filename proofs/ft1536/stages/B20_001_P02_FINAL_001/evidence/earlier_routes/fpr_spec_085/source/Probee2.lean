import B20.C.ScalarParser
set_option maxRecDepth 16384
set_option maxHeartbeats 8000000
open B20.C.Scalar
example : parseExpr 6 1 ([ "(", "m", ">>", "2", ")"].map String.toList) = some (.bin .shr (.var "m".toList) (.literal .i32 2), []) := by rfl
