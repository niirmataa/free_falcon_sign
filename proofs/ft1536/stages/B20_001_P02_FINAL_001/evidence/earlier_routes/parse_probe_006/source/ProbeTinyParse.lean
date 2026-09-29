import B20.C.Parser
set_option maxRecDepth 16384
set_option maxHeartbeats 8000000
example : (B20.C.parseFunction "static inline uint64_t f(uint64_t x) { return x; }".toList).isSome = true := by decide
