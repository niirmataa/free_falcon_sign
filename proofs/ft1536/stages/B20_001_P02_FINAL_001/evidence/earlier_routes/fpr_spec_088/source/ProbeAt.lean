import B20.C.ScalarParser
example (a b : Nat) (h1 : a = b) (h2 : b = 0) : a = 0 := by
  simp only [] at h1 h2
    h1
  omega
