import MgfProduct
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

-- TEST: sama instancja Fintype/Finset.univ dla produktu Fin
example (a : Fin 131071 × Fin 131071) : a ∈ (Finset.univ : Finset (Fin 131071 × Fin 131071)) :=
  Finset.mem_univ a

-- TEST 2: jawnie z domyslna instancja produktu
example (a : Fin 131071 × Fin 131071) :
    a ∈ (Finset.univ : Finset (Fin 131071 × Fin 131071)) := by
  simp only [Finset.mem_univ]
