import MgfProduct
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype
open FT1536.MgfProduct

-- TEST 1: samo membership w produkcie
example (d : Fin 131071 × Fin 131071) :
    (dec d.1, dec d.2) ∈ Finset.Icc (-65535:ℤ) 65535 ×ˢ Finset.Icc (-65535:ℤ) 65535 := by
  have h1 : dec d.1 ∈ Finset.Icc (-65535:ℤ) 65535 := by
    rw [Finset.mem_Icc]; show ((-65535:ℤ) ≤ (d.1.val : ℤ) - 65535) ∧ ((d.1.val : ℤ) - 65535 ≤ 65535); omega
  have h2 : dec d.2 ∈ Finset.Icc (-65535:ℤ) 65535 := by
    rw [Finset.mem_Icc]; show ((-65535:ℤ) ≤ (d.2.val : ℤ) - 65535) ∧ ((d.2.val : ℤ) - 65535 ≤ 65535); omega
  exact Finset.mem_product.mpr ⟨h1, h2⟩

-- TEST 2: mini sum_bij na tym samym kształcie
example : (∑ d : Fin 131071 × Fin 131071, (dec d.1 : ℝ) + dec d.2)
    = ∑ p ∈ Finset.Icc (-65535:ℤ) 65535 ×ˢ Finset.Icc (-65535:ℤ) 65535, (p.1 + p.2 : ℝ) := by
  refine Finset.sum_bij (fun d _ => (dec d.1, dec d.2)) ?_ ?_ ?_ ?_
  · intro d _
    have h1 : dec d.1 ∈ Finset.Icc (-65535:ℤ) 65535 := by
      rw [Finset.mem_Icc]; omega
    have h2 : dec d.2 ∈ Finset.Icc (-65535:ℤ) 65535 := by
      rw [Finset.mem_Icc]; omega
    exact Finset.mem_product.mpr ⟨h1, h2⟩
  · intro a₁ _ a₂ _ hEq
    obtain ⟨hEq1, hEq2⟩ := Prod.mk.inj hEq
    apply Prod.ext
    · apply Fin.ext; simp only [dec] at hEq1; omega
    · apply Fin.ext; simp only [dec] at hEq2; omega
  · intro p hp
    obtain ⟨hpl, hpr⟩ := Finset.mem_product.mp hp
    have e1 : ∃ a : Fin 131071, dec a = p.1 := by
      refine ⟨⟨(p.1 + 65535).toNat, ?_⟩, ?_⟩
      · have : p.1 ∈ Finset.Icc (-65535:ℤ) 65535 := hpl
        rw [Finset.mem_Icc] at this; omega
      · simp only [dec]; have : p.1 ∈ Finset.Icc (-65535:ℤ) 65535 := hpl
        rw [Finset.mem_Icc] at this; omega
    obtain ⟨a, ha⟩ := e1
    have e2 : ∃ b : Fin 131071, dec b = p.2 := by
      refine ⟨⟨(p.2 + 65535).toNat, ?_⟩, ?_⟩
      · have : p.2 ∈ Finset.Icc (-65535:ℤ) 65535 := hpr
        rw [Finset.mem_Icc] at this; omega
      · simp only [dec]; have : p.2 ∈ Finset.Icc (-65535:ℤ) 65535 := hpr
        rw [Finset.mem_Icc] at this; omega
    obtain ⟨b, hb⟩ := e2
    exact ⟨(a, b), Finset.mem_univ _, by simp [ha, hb]⟩
  · intro d _
    rfl
