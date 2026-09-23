namespace RedTest

-- which primitives kernel-reduce at all (rfl / decide)?
example : "abc".data = ['a', 'b', 'c'] := by rfl
example : String.toNat? "12" = some 12 := by rfl
example : ("abc".drop 1) = "bc" := by rfl
example : ("abc".dropRight 1) = "ab" := by rfl
example : "abc".length = 3 := by rfl

end RedTest
