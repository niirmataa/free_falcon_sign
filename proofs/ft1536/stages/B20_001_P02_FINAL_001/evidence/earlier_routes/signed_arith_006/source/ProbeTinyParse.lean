import B20.C.Parser
set_option maxRecDepth 16384
set_option maxHeartbeats 8000000
def tinyTokens : List B20.C.Token :=
  ["static", "inline", "uint64_t", "f", "(", "uint64_t", "x", ")", "{", "return", "x", ";", "}"].map String.toList
theorem tinyLex : B20.C.tokenize 49 "static inline uint64_t f(uint64_t x) { return x; }".toList = some tinyTokens := by decide
example : (B20.C.parseFunctionTokens tinyTokens).isSome = true := by decide
