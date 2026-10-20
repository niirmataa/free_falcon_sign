import Run2.RadialSymmetry
import Run2.RawIndependence

set_option maxHeartbeats 4000000
set_option maxRecDepth 65536

-- Local instance hygiene (bez democji mean ⟨law⟩ (λ…) rozwija elems — pętla).
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

/- ============================================================================
   Dekompozycja warunkowa masy trójkąta (punkt 3 wiązania silnika).

   Silnik dla pary (a,b) z trójkąta kanonicznego liczy `weight(a,b) * gap(a,b)`:
   waga bloku t^{Q(a,b)}/G razy okno CDF zbioru 1535 pozostałych bloków.
   Tu dowodzimy kernelowo postać `weight * gap` masy zdarzenia:

   - tożsamość punktowa: radialHit z i <=> restEnergy z i lezy w oknie
     [B - centeredEnergy, B - blockEnergy) (omega; before = rest + e),
   - rozklad: mean rawLaw (radialHit ∧ region1) =
       ∑ b, blockLaw.mass b * indicator (region1 b) * windowMass i b,
     gdzie windowMass i b = P_rest(restEnergy w oknie b) — masa okna
     zbioru pozostalych blokow (dokladnie gap silnika).

   Kolejne: sandwich binningowy (okna llo/lhi ⊂/⊃ prawdziwe okno),
   wiazanie CDF-konwolucji cyklicznej (certyfikat PackedConvolution)
   i skladanie endpointow+poprawek => hsumL/hsumU.
   ============================================================================ -/

namespace FT1536.Run2.RadialWindowSplit

open Finset PublicSimulation Geometry RawProductLaw RawRadialEvents CenteringTriangle
open RawIndependence RadialTriangleSplit

/-! ## Energia reszty i okno zdarzenia -/

def restEnergy (z : BoxPair) (i : Fin 768) : ℤ := before z - blockEnergy (z.1 i)

def restWindow (i : Fin 768) (b : Block) (z : BoxPair) : Prop :=
  B - centeredEnergy b ≤ restEnergy z i ∧ restEnergy z i < B - blockEnergy b

theorem radialHit_window (z : BoxPair) (i : Fin 768) :
    radialHit z i ↔ restWindow i (z.1 i) z := by
  simp only [radialHit, oneChange, restWindow, restEnergy]
  constructor
  · intro h
    omega
  · intro h
    omega

/-! ## Dodatniość mas bloku (do dzielenia) -/

theorem blockLaw_mass_pos (b : Block) : 0 < blockLaw.mass b := by
  simp only [blockLaw, Law.weighted, blockWeight]
  exact div_pos (Real.exp_pos _) blockNormalizer_pos

theorem blockLaw_mass_ne (b : Block) : blockLaw.mass b ≠ 0 :=
  (blockLaw_mass_pos b).ne'

/-! ## Masa okna reszty (gap silnika) -/

noncomputable def windowMass (i : Fin 768) (b : Block) : ℝ :=
  ∑ z : BoxPair, (rawLaw.mass z / blockLaw.mass (z.1 i)) *
    indicator (z.1 i = b ∧ restWindow i b z)

/-! ## Rozklad warunkowy: masa = ∑ b, waga b * masa okna b -/

theorem canonical_window_split (i : Fin 768) :
    mean rawLaw (fun z => indicator (radialHit z i ∧ region1 (z.1 i))) =
      ∑ b : Block, blockLaw.mass b * indicator (region1 b) * windowMass i b := by
  classical
  simp only [mean]
  have hpt : ∀ z : BoxPair,
      rawLaw.mass z * indicator (radialHit z i ∧ region1 (z.1 i))
        = ∑ b : Block, blockLaw.mass b * indicator (region1 b) *
            ((rawLaw.mass z / blockLaw.mass (z.1 i)) *
              indicator (z.1 i = b ∧ restWindow i b z)) := by
    intro z
    have hne : blockLaw.mass (z.1 i) ≠ 0 := blockLaw_mass_ne (z.1 i)
    have hwin := radialHit_window z i
    have hform : indicator (radialHit z i ∧ region1 (z.1 i))
        = indicator (restWindow i (z.1 i) z ∧ region1 (z.1 i)) :=
      congrArg indicator
        (propext ⟨fun h => ⟨hwin.mp h.1, h.2⟩, fun h => ⟨hwin.mpr h.1, h.2⟩⟩)
    rw [hform]
    have hsift : (∑ b : Block, blockLaw.mass b * indicator (region1 b) *
        ((rawLaw.mass z / blockLaw.mass (z.1 i)) *
          indicator (z.1 i = b ∧ restWindow i b z)))
        = blockLaw.mass (z.1 i) * indicator (region1 (z.1 i)) *
          ((rawLaw.mass z / blockLaw.mass (z.1 i)) *
            indicator (z.1 i = z.1 i ∧ restWindow i (z.1 i) z)) := by
      rw [Finset.sum_eq_single (z.1 i)]
      · intro b _ hb
        have hneq : ¬(z.1 i = b) := fun h => hb h.symm
        simp [hneq, indicator]
      · intro ha
        exact absurd (Finset.mem_univ (z.1 i)) ha
    rw [hsift]
    simp only [eq_self, true_and]
    rw [indicator_and]
    field_simp [hne]
  simp_rw [hpt]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro b _
  rw [← Finset.mul_sum, windowMass]

#print axioms radialHit_window
#print axioms blockLaw_mass_pos
#print axioms canonical_window_split

end FT1536.Run2.RadialWindowSplit
