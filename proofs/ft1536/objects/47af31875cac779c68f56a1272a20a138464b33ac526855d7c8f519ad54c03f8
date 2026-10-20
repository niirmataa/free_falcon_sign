import Run2.RadialWindowSplit
import Run2.RadialObligations

set_option maxHeartbeats 4000000
set_option maxRecDepth 65536

-- Local instance hygiene (bez democji mean ⟨law⟩ (λ…) rozwija elems — pętla).
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

/- ============================================================================
   Sandwich binningowy i pelny lancuch do rawLo <= rawBad <= rawHi
   (punkty a-c wiązania silnika).

   Silnik dzieli os norm na bin-y szerokosci 16 i liczy okna CDF
   [llo..lhi] / [ulo..uhi] z marginesem blocks*(width-1)=1535*15 na
   zawijanie wag. Tu kernelowo:
   (a) arytmetyka floor/ceil binow + inkluzje loWin ⊆ trueWin ⊆ hiWin,
       stad `windowMassLo <= windowMass <= windowMassHi` (monotonicznosc);
   (c) sklejenie przez radialSum_4_768 + canonical_window_split:
       `4*768*∑ windowMassLo <= radialSum <= 4*768*∑ windowMassHi`,
       a z certyfikatami (b) i capami poprawek => rawLo <= rawBad <= rawHi
       => warunkowe trzy cyfry.
   (b) certyfikat: wartosci gap silnika (CDF cyklicznej konwolucji, dowód
       przez PackedConvolution.certificate_sound + FLINT) sa masami okien
       loWin/hiWin z wagami blokow — przyjety jako nazwane hipotezy hbLo/hbHi.
   ============================================================================ -/

namespace FT1536.Run2.RadialBinningSandwich

open Finset PublicSimulation Geometry RawProductLaw RawRadialEvents CenteringTriangle
open RawIndependence RadialTriangleSplit RadialSymmetry RadialWindowSplit
open RadialObligations RawRadialEnclosure LegalKeyErrorTransfer CorrectnessProbability

/-! ## Biny szerokosci 16 (podział silnika) -/

def binLo (x : ℤ) : ℤ := (x + 15) / 16
def binUp (x : ℤ) : ℤ := x / 16

theorem binLo_spec (x : ℤ) : x ≤ binLo x * 16 ∧ binLo x * 16 < x + 16 := by
  simp only [binLo]
  omega

theorem binUp_spec (x : ℤ) : binUp x * 16 ≤ x ∧ x < (binUp x + 1) * 16 := by
  simp only [binUp]
  omega

/-! ## Okna: prawdziwe i binowe (lo/hi wg silnika) -/

def trueWin (Q Qc : ℤ) (E : ℤ) : Prop := B - Qc ≤ E ∧ E < B - Q

def loWin (Q Qc : ℤ) (E : ℤ) : Prop :=
  binLo (B - Qc) * 16 ≤ E ∧ E ≤ (binUp (B - Q - 1 - 1535*15) + 1) * 16 - 1

def hiWin (Q Qc : ℤ) (E : ℤ) : Prop :=
  binLo (B - Qc - 1535*15) * 16 ≤ E ∧ E ≤ (binUp (B - Q - 1) + 1) * 16 - 1

theorem loWin_subset_trueWin (Q Qc E : ℤ) (h : loWin Q Qc E) : trueWin Q Qc E := by
  simp only [loWin, trueWin] at h ⊢
  have h1 := binLo_spec (B - Qc)
  have h2 := binUp_spec (B - Q - 1 - 1535*15)
  omega

theorem trueWin_subset_hiWin (Q Qc E : ℤ) (h : trueWin Q Qc E) : hiWin Q Qc E := by
  simp only [hiWin, trueWin] at h ⊢
  have h1 := binLo_spec (B - Qc - 1535*15)
  have h2 := binUp_spec (B - Q - 1)
  omega

/-! ## Masa okna dla dowolnego predykatu na energii reszty -/

noncomputable def windowMassWin (i : Fin 768) (b : Block) (W : ℤ → Prop) : ℝ :=
  ∑ z : BoxPair, (rawLaw.mass z / blockLaw.mass (z.1 i)) *
    indicator (z.1 i = b ∧ W (restEnergy z i))

theorem windowMass_eq_win (i : Fin 768) (b : Block) :
    windowMass i b =
      windowMassWin i b (fun E => B - centeredEnergy b ≤ E ∧ E < B - blockEnergy b) :=
  rfl

theorem windowMassWin_mono (i : Fin 768) (b : Block) (W W' : ℤ → Prop)
    (h : ∀ E, W E → W' E) :
    windowMassWin i b W ≤ windowMassWin i b W' := by
  classical
  simp only [windowMassWin]
  apply Finset.sum_le_sum
  intro z _
  by_cases hz : z.1 i = b
  · by_cases hw : W (restEnergy z i)
    · have hw' := h (restEnergy z i) hw
      simp [indicator, hz, hw, hw']
    · by_cases hw' : W' (restEnergy z i)
      · simp [indicator, hz, hw, hw']
        exact div_nonneg (rawLaw.nonneg z) (blockLaw_mass_pos b).le
      · simp [indicator, hz, hw, hw']
  · simp [indicator, hz]

theorem windowMass_bin_sandwich (i : Fin 768) (b : Block) :
    windowMassWin i b (loWin (blockEnergy b) (centeredEnergy b)) ≤ windowMass i b ∧
      windowMass i b ≤ windowMassWin i b (hiWin (blockEnergy b) (centeredEnergy b)) := by
  classical
  rw [windowMass_eq_win]
  constructor
  · apply windowMassWin_mono
    intro E hE
    exact loWin_subset_trueWin (blockEnergy b) (centeredEnergy b) E hE
  · apply windowMassWin_mono
    intro E hE
    exact trueWin_subset_hiWin (blockEnergy b) (centeredEnergy b) E hE

/-! ## Sandwich na radialSum (sklejenie struktury i okien) -/

noncomputable def loTriangleMass : ℝ :=
  ∑ b : Block, blockLaw.mass b * indicator (region1 b) *
    windowMassWin 0 b (loWin (blockEnergy b) (centeredEnergy b))

noncomputable def hiTriangleMass : ℝ :=
  ∑ b : Block, blockLaw.mass b * indicator (region1 b) *
    windowMassWin 0 b (hiWin (blockEnergy b) (centeredEnergy b))

theorem radialSum_bin_sandwich :
    (4:ℝ) * 768 * loTriangleMass ≤ radialSum ∧
      radialSum ≤ (4:ℝ) * 768 * hiTriangleMass := by
  classical
  rw [radialSum_4_768, canonical_window_split 0]
  constructor
  · apply mul_le_mul_of_nonneg_left _ (by norm_num)
    simp only [loTriangleMass]
    apply Finset.sum_le_sum
    intro b _
    apply mul_le_mul_of_nonneg_left _
      (mul_nonneg (blockLaw.nonneg b) (indicator_nonnegative _))
    exact (windowMass_bin_sandwich 0 b).1
  · apply mul_le_mul_of_nonneg_left _ (by norm_num)
    simp only [hiTriangleMass]
    apply Finset.sum_le_sum
    intro b _
    apply mul_le_mul_of_nonneg_left _
      (mul_nonneg (blockLaw.nonneg b) (indicator_nonnegative _))
    exact (windowMass_bin_sandwich 0 b).2

/-! ## Pelny lancuch: certyfikaty (b) + capy => rawLo <= rawBad <= rawHi -/

theorem enclosure_of_binning_certificates
    (hbLo : (engineLo:ℝ) - (aliasCap:ℝ) ≤ (4:ℝ) * 768 * loTriangleMass)
    (hbHi : (4:ℝ) * 768 * hiTriangleMass ≤ (engineHi:ℝ) + (missCap:ℝ))
    (hchange : changeProbability^2 ≤ (changeCap2:ℝ))
    (htail : mean rawLaw (fun z => indicator (unsignedHalf z.2)) ≤ (emitCap:ℝ)) :
    GuaranteedDigits.rawLo ≤ rawBad ∧ rawBad ≤ GuaranteedDigits.rawHi := by
  classical
  obtain ⟨hlo, hhi⟩ := radialSum_bin_sandwich
  have hsumL : (engineLo:ℝ) - (aliasCap:ℝ) ≤ radialSum := hbLo.trans hlo
  have hsumU : radialSum ≤ (engineHi:ℝ) + (missCap:ℝ) := hhi.trans hbHi
  exact enclosure_of_reduced_obligations hsumL hsumU hchange htail

theorem three_digits_of_binning_certificates
    (h : FT1536.Relation.Rq)
    (hbLo : (engineLo:ℝ) - (aliasCap:ℝ) ≤ (4:ℝ) * 768 * loTriangleMass)
    (hbHi : (4:ℝ) * 768 * hiTriangleMass ≤ (engineHi:ℝ) + (missCap:ℝ))
    (hchange : changeProbability^2 ≤ (changeCap2:ℝ))
    (htail : mean rawLaw (fun z => indicator (unsignedHalf z.2)) ≤ (emitCap:ℝ))
    (flat : FiniteFlat h GuaranteedDigits.flatBudget)
    (reject : ∀ c, rejection h c ≤ GuaranteedDigits.rejectBudget) :
    (1265 : ℝ)/10^27 < delta h ∧ delta h < (1275 : ℝ)/10^27 :=
  GuaranteedDigits.three_significant_digits h
    (enclosure_of_binning_certificates hbLo hbHi hchange htail) flat reject

#print axioms binLo_spec
#print axioms loWin_subset_trueWin
#print axioms windowMass_bin_sandwich
#print axioms radialSum_bin_sandwich
#print axioms enclosure_of_binning_certificates
#print axioms three_digits_of_binning_certificates

end FT1536.Run2.RadialBinningSandwich
