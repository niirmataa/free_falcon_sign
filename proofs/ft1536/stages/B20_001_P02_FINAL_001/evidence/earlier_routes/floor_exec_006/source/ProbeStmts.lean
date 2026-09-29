import B20.C.Parser
set_option maxRecDepth 16384
set_option maxHeartbeats 8000000
example : (B20.C.parseStmts 8 ["return".toList, ['x'], [';'], ['}']]).isSome = true := by decide
