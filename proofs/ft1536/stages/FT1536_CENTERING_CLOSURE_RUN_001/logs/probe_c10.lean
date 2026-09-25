import MgfProduct
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

example : (∑ x ∈ Finset.Icc (0:ℤ) 2, (x:ℝ)) = ∑ y ∈ Finset.Icc (0:ℤ) 2, (y:ℝ) := by
  refine Finset.sum_nbij (fun x => x) ?_ ?_ ?_ ?_
  · intro a ha; exact ha
  · intro x _ y _ hEq; exact hEq
  · intro p hp; exact ⟨p, hp, rfl⟩
  · intro a _; rfl
