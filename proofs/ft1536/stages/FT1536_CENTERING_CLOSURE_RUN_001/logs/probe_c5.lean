import MgfProduct
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype
open FT1536.MgfProduct

#check @Finset.mem_product

-- TEST: wariant przez rw zamiast mpr
example (d : Fin 131071 × Fin 131071) :
    (dec d.1, dec d.2) ∈ Finset.Icc (-65535:ℤ) 65535 ×ˢ Finset.Icc (-65535:ℤ) 65535 := by
  have h1 : dec d.1 ∈ Finset.Icc (-65535:ℤ) 65535 := by
    rw [Finset.mem_Icc]; show ((-65535:ℤ) ≤ (d.1.val : ℤ) - 65535) ∧ ((d.1.val : ℤ) - 65535 ≤ 65535); omega
  have h2 : dec d.2 ∈ Finset.Icc (-65535:ℤ) 65535 := by
    rw [Finset.mem_Icc]; show ((-65535:ℤ) ≤ (d.2.val : ℤ) - 65535) ∧ ((d.2.val : ℤ) - 65535 ≤ 65535); omega
  rw [Finset.mem_product]
  exact ⟨h1, h2⟩
