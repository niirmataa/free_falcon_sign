import B20.C.Integer
open B20.C
theorem xor_neg_bridge (a s : BitVec 64) :
    signedBitsOp .xor a (-s) = bitsOp .xor a (-s) := by
  simp [signedBitsOp, signedSafe]
