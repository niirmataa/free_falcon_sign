import Run2.RadialBinningSandwich

set_option maxHeartbeats 4000000
set_option maxRecDepth 65536

-- Local instance hygiene (bez democji mean ⟨law⟩ (λ…) rozwija elems — pętla).
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

/- ============================================================================
   Most (b): postac sumowa/iloczynowa pod certyfikat konwolucji.

   Certyfikat (b) wiaze wartosci gap silnika z masami okien windowMassWin.
   Silnik liczy je jako okno CDF 1535-fold CYKLICZNEJ konwolucji
   (DiscreteFourier.inverse_power_is_cyclic_convolution — juz udowodnione).
   Tu kernelowo spinamy warstwe opisowa:
   - `restEnergy_as_sums`: energia reszty = suma 1535 energii blokow
     (before minus wyrzucony blok),
   - `rawLaw_mass_prod`: masa rawLaw = iloczyn 1536 mas blockLaw
     (actual_mass_product + definicje productLaw/vectorLaw),
   - `restMass` + `windowMassWin_restMass`: summand okna = masa reszty
     (iloczyn 1535 mas) razy wskaznik okna — dokladny obiekt, ktorego
     rozkladem jest 1535-fold convolution power (GeneratingFunction.iid_pgf /
     DiscreteFourier).
   ============================================================================ -/

namespace FT1536.Run2.RestEnergyBridge

open Finset PublicSimulation Geometry RawProductLaw RawRadialEvents CenteringTriangle
open RadialWindowSplit RadialBinningSandwich RadialSymmetry

/-! ## Energia reszty jako suma wszystkich bloków minus wybrany -/

theorem restEnergy_as_sums (z : BoxPair) (i : Fin 768) :
    restEnergy z i =
      ((∑ j : Fin 768, blockEnergy (z.1 j)) - blockEnergy (z.1 i))
        + (∑ j : Fin 768, blockEnergy (z.2 j)) := by
  rw [restEnergy, before_as_sums]
  ring

/-! ## Masa rawLaw jako iloczyn mas bloków -/

theorem rawLaw_mass_prod (z : BoxPair) :
    rawLaw.mass z =
      (∏ j : Fin 768, blockLaw.mass (z.1 j)) * (∏ j : Fin 768, blockLaw.mass (z.2 j)) := by
  rw [actual_mass_product]
  simp only [productLaw, vectorLaw]

/-! ## Masa reszty i summand okna -/

noncomputable def restMass (z : BoxPair) (i : Fin 768) : ℝ :=
  rawLaw.mass z / blockLaw.mass (z.1 i)

theorem windowMassWin_restMass (i : Fin 768) (b : Block) (W : ℤ → Prop) :
    windowMassWin i b W =
      ∑ z : BoxPair, restMass z i * indicator (z.1 i = b ∧ W (restEnergy z i)) :=
  rfl

/-- Summand okna = masa reszty (iloczyn 1535 mas bloków poza i-tym) razy
    wskaznik okna — obiekt 1535-fold convolution power z DiscreteFourier. -/
theorem restMass_prod (z : BoxPair) (i : Fin 768) :
    restMass z i * blockLaw.mass (z.1 i) =
      (∏ j : Fin 768, blockLaw.mass (z.1 j)) * (∏ j : Fin 768, blockLaw.mass (z.2 j)) := by
  rw [restMass, rawLaw_mass_prod]
  have hne : blockLaw.mass (z.1 i) ≠ 0 := blockLaw_mass_ne (z.1 i)
  field_simp [hne]

#print axioms restEnergy_as_sums
#print axioms rawLaw_mass_prod
#print axioms windowMassWin_restMass
#print axioms restMass_prod

end FT1536.Run2.RestEnergyBridge
