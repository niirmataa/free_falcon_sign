import B20.C.ScalarParser
example : ((((1#32 : BitVec 32).setWidth 64) <<< 62)) = 4611686018427387904#64 := by
  simp only []
example : ((((1#32 : BitVec 32).setWidth 64) <<< 62)) = 4611686018427387904#64 := by
  simp
