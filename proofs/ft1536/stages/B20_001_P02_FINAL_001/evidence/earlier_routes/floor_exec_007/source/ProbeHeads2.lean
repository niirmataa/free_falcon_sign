import B20.C.ScalarParser
open BitVec
example : (Neg.neg (1#64 : BitVec 64)) = (BitVec.neg 1#64) := rfl
example : ((1#64 : BitVec 64) >>> 1) = (BitVec.ushiftRight 1#64 1) := rfl
example : ((1#64 : BitVec 64) &&& 1#64) = (BitVec.and 1#64 1#64) := rfl
