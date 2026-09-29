import B20.C.ScalarParser
open BitVec
-- which parse wins for -A >>> n ?
example : (-(1#64) >>> 1) = 9223372036854775807#64 := by decide
example : (-((1#64) >>> 1)) = 18446744073709551615#64 := by decide
#check (-(1#64) >>> 1)
#check (-((1#64) >>> 1))
