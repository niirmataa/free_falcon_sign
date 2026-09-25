import MgfProduct
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype
open FT1536.MgfProduct

example : (Finset.sum Finset.univ
      (fun d : Fin 131071 × Fin 131071 => (dec d.1 : ℝ) + (dec d.2 : ℝ)))
    = ∑ p ∈ Finset.Icc (-65535:ℤ) 65535 ×ˢ Finset.Icc (-65535:ℤ) 65535, (p.1 + p.2 : ℝ) := by
  refine Finset.sum_bij (fun d _ => (dec d.1, dec d.2)) ?_ ?_ ?_ ?_
  · intro d _
    rw [Finset.mem_product]
    have h1 : dec d.1 ∈ Finset.Icc (-65535:ℤ) 65535 := by rw [Finset.mem_Icc]; show ((-65535:ℤ) ≤ (d.1.val : ℤ) - 65535) ∧ ((d.1.val : ℤ) - 65535 ≤ 65535); omega
    have h2 : dec d.2 ∈ Finset.Icc (-65535:ℤ) 65535 := by rw [Finset.mem_Icc]; show ((-65535:ℤ) ≤ (d.2.val : ℤ) - 65535) ∧ ((d.2.val : ℤ) - 65535 ≤ 65535); omega
    exact ⟨h1, h2⟩
  · intro x _ y _ hEq
    obtain ⟨hEq1, hEq2⟩ := Prod.mk.inj hEq
    apply Prod.ext <;> apply Fin.ext <;> simp only [dec] at hEq1 hEq2 <;> omega
  · intro p hp
    rw [Finset.mem_product] at hp
    obtain ⟨hpl, hpr⟩ := hp
    have e1 : ∃ a : Fin 131071, dec a = p.1 := by
      refine ⟨⟨(p.1 + 65535).toNat, ?_⟩, ?_⟩
      · rw [Finset.mem_Icc] at hpl; omega
      · simp only [dec]; rw [Finset.mem_Icc] at hpl; omega
    have e2 : ∃ b : Fin 131071, dec b = p.2 := by
      refine ⟨⟨(p.2 + 65535).toNat, ?_⟩, ?_⟩
      · rw [Finset.mem_Icc] at hpr; omega
      · simp only [dec]; rw [Finset.mem_Icc] at hpr; omega
    obtain ⟨x, hx⟩ := e1
    obtain ⟨y, hy⟩ := e2
    have hmem : (x, y) ∈ Finset.univ := by simp only [Finset.mem_univ]
    have heq : (dec x, dec y) = p := Prod.ext hx hy
    exact @Exists.intro (Fin 131071 × Fin 131071)
      (fun a => ∃ (ha : a ∈ Finset.univ), (dec a.1, dec a.2) = p)
      (x, y)
      (@Exists.intro ((x, y) ∈ Finset.univ)
        (fun _ => (dec (x, y).1, dec (x, y).2) = p)
        hmem heq)
  · intro d _
    rfl
