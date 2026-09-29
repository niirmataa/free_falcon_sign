import B20.C.Parser
import B20.Pinned.Header
set_option maxRecDepth 16384
set_option maxHeartbeats 8000000
#check B20.C.parseFunction
example : (B20.Pinned.headerLines.drop 17).head! = "static inline uint64_t\n" := by decide
example : (B20.C.parseFunction
    (((B20.Pinned.headerLines.drop 17).take 6).flatMap String.toList)).isSome = true := by decide
