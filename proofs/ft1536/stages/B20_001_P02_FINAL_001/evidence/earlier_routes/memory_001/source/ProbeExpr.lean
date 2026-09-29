import B20.C.Parser
set_option maxRecDepth 16384
set_option maxHeartbeats 8000000
example : B20.C.parseExpr 1 [['x']] = some (.var ['x'], []) := by decide
example : B20.C.parseExpr 16 [['x']] = some (.var ['x'], []) := by decide
