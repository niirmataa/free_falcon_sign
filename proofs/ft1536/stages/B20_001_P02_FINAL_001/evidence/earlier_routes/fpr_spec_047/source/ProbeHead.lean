import B20.Pinned.Header
set_option maxRecDepth 16384
set_option maxHeartbeats 8000000
example : (B20.Pinned.headerLines.drop 17).head! = "static inline uint64_t\n" := by decide
