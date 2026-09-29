import B20.C.Integer
open B20.C
example (a s : BitVec 64) : signedBitsOp .xor a (-s) = bitsOp .xor a (-s) := by
  simp [signedBitsOp, signedSafe]
