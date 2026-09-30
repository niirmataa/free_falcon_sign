import Run2.RadialBinningSandwich
import Run2.PackedConvolution

/-!
# ConvolutionCert — certyfikat splotu dla `hbLo`/`hbHi` (pkt 1 planu).

`RadialBinningSandwich.enclosure_of_binning_certificates` przyjmuje dwie
hipotezy liczbowe:
  `hbLo : engineLo - aliasCap <= 4*768*loTriangleMass`,
  `hbHi : 4*768*hiTriangleMass <= engineHi + missCap`.

Silnik (`repro/radial_engine.triangle`) liczy ich strony tak: sumuje po
 parach trójkąta region1 po `waga(blok) * [CDF(lhi) - CDF(llo-1)]`, gdzie
CDF pochodzi z cyklicznego splotu 1535-krotnego szeregu jednoblokowego
(liczniki `x^2+xy+y^2` w boxie * `exp(-E/1179648)`; DFT^1535 mod 2^25,
stąd `aliasCap` na zawijanie).

Rozbicie dowodu na warstwy (tu realizowane):

* (W1) warstwa strukturalna - PROWADZONA w tym pliku. Okno `loWin`/`hiWin`
  jest przedzialem progowym energii reszty, wiec jego masa `windowMassWin`
  to ROZNICA dwoch progow CDF (`windowMassWin_Icc`; straz niezwyrodlonosci
  `T1 <= T2+1` pokrywa sie ze strazem silnika `lhi >= llo`). Splot nie jest
  tu potrzebny - wchodzi wylacznie jako metoda oceny progow przez silnik.
* (W2) certyfikat zewnetrzny (DOKLADNY BRAKUJACY TYP) - `certLo`/`certHi`
  w `hbLo_cert`/`hbHi_cert` ponizej: wartosc silnika (kule ARB + calkowity
  splot FLINT przez `PackedConvolution.certificate_sound`) wiaze sie z
  progami CDF obiektow `windowMassLe/Lt`. UWAGA skali: pelne certyfikaty
  calkowite splotu maja ~2^30 bitow na wartosc upakowana (n = 2^25,
  base ~ 2^32) - nie da sie ich zamknac jako literalow zrodlowych; wymagaja
  drzewa iloczynow z certyfikatami posrednimi ALBO dowodu strukturalnego
  splotu (generujace) po stronie kernela.
* (W3) porownania rationalne - kernelowo; capy `aliasCap`/`missCap`
  sa literalami QQ (`RawRadialEnclosure`).

Zakres tego pliku: definicje odpowiadajace formule silnika, pelne (W1),
oraz montaz `hbLo_cert`/`hbHi_cert` z jawnym typem brakujacego certyfikatu.
-/

set_option maxHeartbeats 4000000
set_option maxRecDepth 65536

attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

namespace FT1536.ConvolutionCert

open Finset FT1536.PublicSimulation FT1536.Geometry
open FT1536.Run2.RawProductLaw FT1536.Run2.RawRadialEvents
open FT1536.Run2.RadialWindowSplit FT1536.Run2.RadialSymmetry
open FT1536.Run2.RadialTriangleSplit FT1536.Run2.RadialBinningSandwich
open FT1536.Run2.RawRadialEnclosure FT1536.Run2.RawIndependence
open FT1536.Run2.RadialObligations FT1536.Run2.LegalKeyErrorTransfer
open FT1536.Run2.CorrectnessProbability

/-! ## 1. Progi binowe okien (dokładnie jak `radial_engine.triangle`) -/

/-- Dolny próg okna `loWin` (energia reszty): `binLo (B - Qc) * 16`. -/
def loT1 (_Q Qc : ℤ) : ℤ := binLo (B - Qc) * 16
/-- Górny próg okna `loWin`: `(binUp (B - Q - 1 - 1535*15) + 1) * 16 - 1`. -/
def loT2 (Q _Qc : ℤ) : ℤ := (binUp (B - Q - 1 - 1535*15) + 1) * 16 - 1
/-- Dolny próg okna `hiWin`. -/
def hiT1 (_Q Qc : ℤ) : ℤ := binLo (B - Qc - 1535*15) * 16
/-- Górny próg okna `hiWin`. -/
def hiT2 (Q _Qc : ℤ) : ℤ := (binUp (B - Q - 1) + 1) * 16 - 1

theorem loWin_eq_Icc (Q Qc E : ℤ) :
    loWin Q Qc E = (loT1 Q Qc <= E /\ E <= loT2 Q Qc) :=
  rfl

theorem hiWin_eq_Icc (Q Qc E : ℤ) :
    hiWin Q Qc E = (hiT1 Q Qc <= E /\ E <= hiT2 Q Qc) :=
  rfl

/-! ## 2. Masa okna przez progi CDF (warstwa W1) -/

/-- Masa okna półprostego `E <= T` dla bloku odniesienia `b` (slot 0). -/
noncomputable def windowMassLe (b : Block) (T : ℤ) : ℝ :=
  windowMassWin 0 b (fun E => E <= T)

/-- Masa okna półprostego `E < T`. -/
noncomputable def windowMassLt (b : Block) (T : ℤ) : ℝ :=
  windowMassWin 0 b (fun E => E < T)

/-- Kongruencja okna: `windowMassWin` zależy od predykatu tylko przez
    zbiór poziomów. -/
theorem windowMassWin_congr (i : Fin 768) (b : Block) (W W' : ℤ -> Prop)
    (h : forall E, W E <-> W' E) :
    windowMassWin i b W = windowMassWin i b W' := by
  classical
  simp only [windowMassWin]
  apply Finset.sum_congr rfl
  intro z _
  by_cases hz : z.1 i = b
  · by_cases hw : W (restEnergy z i)
    · have hw' := (h (restEnergy z i)).mp hw
      simp [indicator, hz, hw, hw']
    · have hw' : Not (W' (restEnergy z i)) := fun hh => hw ((h (restEnergy z i)).mpr hh)
      simp [indicator, hz, hw, hw']
  · simp [indicator, hz]

/-- **Klucz W1**: okno przedziałowe = różnica progów półprostych
    (dla okna niezwyrodlonego `T1 <= T2 + 1`; to jest cała „matematyka
    splotu" potrzebna kernelowo — splot liczy wartości progów, nie
    strukturę okna). -/
theorem windowMassWin_Icc (b : Block) (T1 T2 : ℤ) (hnd : T1 <= T2 + 1) :
    windowMassWin 0 b (fun E => T1 <= E /\ E <= T2)
      = windowMassLe b T2 - windowMassLt b T1 := by
  classical
  simp only [windowMassWin, windowMassLe, windowMassLt]
  rw [<- Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro z _
  by_cases hb : z.1 0 = b
  · by_cases h2 : restEnergy z 0 <= T2
    · by_cases h1 : T1 <= restEnergy z 0
      · have n1 : Not (restEnergy z 0 < T1) := by omega
        simp [indicator, hb, h1, h2, n1]
      · have lt1 : restEnergy z 0 < T1 := by omega
        simp [indicator, hb, h1, h2, lt1]
    · have n3 : Not (restEnergy z 0 < T1) := by omega
      simp [indicator, hb, h2, n3]
  · simp [indicator, hb]

/-- Okno wyrodnione (`T2 < T1`): masa zerowa (odpowiednik strażnika
    `if lhi >= llo` w silniku). -/
theorem windowMassWin_Icc_empty (b : Block) (T1 T2 : ℤ) (he : T2 + 1 <= T1) :
    windowMassWin 0 b (fun E => T1 <= E /\ E <= T2) = 0 := by
  classical
  simp only [windowMassWin]
  apply Finset.sum_eq_zero
  intro z _
  by_cases hb : z.1 0 = b
  · have nE : Not (T1 <= restEnergy z 0 /\ restEnergy z 0 <= T2) := by omega
    simp [indicator, hb, nE]
  · simp [indicator, hb]

/-! ## 3. Forma silnika: sumy po parach trójkąta z progami lo/hi -/

/-- Różnica progów CDF okna lo dla bloku `b` (ekwiwalent `triangle`:
    `if lhi >= llo then CDF(lhi) - CDF(llo-1) else 0`). -/
noncomputable def engineGapLo (b : Block) : ℝ :=
  if loT1 (blockEnergy b) (centeredEnergy b) <= loT2 (blockEnergy b) (centeredEnergy b) + 1 then
    windowMassLe b (loT2 (blockEnergy b) (centeredEnergy b))
      - windowMassLt b (loT1 (blockEnergy b) (centeredEnergy b))
  else 0

/-- Różnica progów CDF okna hi dla bloku `b`. -/
noncomputable def engineGapHi (b : Block) : ℝ :=
  if hiT1 (blockEnergy b) (centeredEnergy b) <= hiT2 (blockEnergy b) (centeredEnergy b) + 1 then
    windowMassLe b (hiT2 (blockEnergy b) (centeredEnergy b))
      - windowMassLt b (hiT1 (blockEnergy b) (centeredEnergy b))
  else 0

/-- Suma lo-okien z wagami bloków po region1 (odpowiednik `triangle(low)`). -/
noncomputable def engineTriangleLo : ℝ :=
  ∑ b : Block, blockLaw.mass b * indicator (region1 b) * engineGapLo b

/-- Suma hi-okien z wagami bloków po region1 (odpowiednik `triangle(up)`). -/
noncomputable def engineTriangleHi : ℝ :=
  ∑ b : Block, blockLaw.mass b * indicator (region1 b) * engineGapHi b

theorem windowMassWin_loWin (b : Block) :
    windowMassWin 0 b (loWin (blockEnergy b) (centeredEnergy b)) = engineGapLo b := by
  classical
  have hwin : windowMassWin 0 b (loWin (blockEnergy b) (centeredEnergy b))
      = windowMassWin 0 b (fun E =>
          loT1 (blockEnergy b) (centeredEnergy b) <= E /\
            E <= loT2 (blockEnergy b) (centeredEnergy b)) := rfl
  rw [hwin]
  by_cases hnd : loT1 (blockEnergy b) (centeredEnergy b)
      <= loT2 (blockEnergy b) (centeredEnergy b) + 1
  · simp [engineGapLo, hnd]
    exact windowMassWin_Icc b (loT1 (blockEnergy b) (centeredEnergy b))
      (loT2 (blockEnergy b) (centeredEnergy b)) hnd
  · simp [engineGapLo, hnd]
    have he : loT2 (blockEnergy b) (centeredEnergy b) + 1
        <= loT1 (blockEnergy b) (centeredEnergy b) := by omega
    exact windowMassWin_Icc_empty b (loT1 (blockEnergy b) (centeredEnergy b))
      (loT2 (blockEnergy b) (centeredEnergy b)) he

theorem windowMassWin_hiWin (b : Block) :
    windowMassWin 0 b (hiWin (blockEnergy b) (centeredEnergy b)) = engineGapHi b := by
  classical
  have hwin : windowMassWin 0 b (hiWin (blockEnergy b) (centeredEnergy b))
      = windowMassWin 0 b (fun E =>
          hiT1 (blockEnergy b) (centeredEnergy b) <= E /\
            E <= hiT2 (blockEnergy b) (centeredEnergy b)) := rfl
  rw [hwin]
  by_cases hnd : hiT1 (blockEnergy b) (centeredEnergy b)
      <= hiT2 (blockEnergy b) (centeredEnergy b) + 1
  · simp [engineGapHi, hnd]
    exact windowMassWin_Icc b (hiT1 (blockEnergy b) (centeredEnergy b))
      (hiT2 (blockEnergy b) (centeredEnergy b)) hnd
  · simp [engineGapHi, hnd]
    have he : hiT2 (blockEnergy b) (centeredEnergy b) + 1
        <= hiT1 (blockEnergy b) (centeredEnergy b) := by omega
    exact windowMassWin_Icc_empty b (hiT1 (blockEnergy b) (centeredEnergy b))
      (hiT2 (blockEnergy b) (centeredEnergy b)) he

/-- **Mostek strukturalny lo**: `loTriangleMass` = forma silnika (W1 + def.). -/
theorem loTriangleMass_eq_engine :
    loTriangleMass = engineTriangleLo := by
  classical
  simp only [loTriangleMass, engineTriangleLo]
  apply Finset.sum_congr rfl
  intro b _
  rw [windowMassWin_loWin]

/-- **Mostek strukturalny hi**. -/
theorem hiTriangleMass_eq_engine :
    hiTriangleMass = engineTriangleHi := by
  classical
  simp only [hiTriangleMass, engineTriangleHi]
  apply Finset.sum_congr rfl
  intro b _
  rw [windowMassWin_hiWin]

/-! ## 4. Dokładny brakujący typ certyfikatu (W2) i montaż

`certLo`/`certHi` to ZUPEŁNY i DOKŁADNY kształt certyfikatu splotu:
wartość silnika z kulek ARB i całkowitego splotu FLINT
(`PackedConvolution.certificate_sound`) wiąże się z progami CDF
`windowMassLe/Lt` — po stronie kernela nie ma już żadnej niejasności.

Zewnętrzny dowód `certLo` wymaga: (a) certyfikatu całkowitego splotu
1535-krotnego (drzewo iloczynów `certificate_sound`; pełne wartości
upakowane mają ~2^30 bitów — certyfikaty pośrednie lub dowód strukturalny),
(b) oszacowania ogona aliasów (zawijanie mod 2^25) i pominiętych bloków
(cutoff/box) przez `aliasCap` (kule ARB, `centering_interval_closure`),
(c) porównania rationalnego końcówek — już kernelowo w `lower_margin_Q`. -/

theorem hbLo_cert
    (certLo : (engineLo:ℝ) - (aliasCap:ℝ) <= (4:ℝ) * 768 * engineTriangleLo) :
    (engineLo:ℝ) - (aliasCap:ℝ) <= (4:ℝ) * 768 * loTriangleMass := by
  rw [loTriangleMass_eq_engine]
  exact certLo

theorem hbHi_cert
    (certHi : (4:ℝ) * 768 * engineTriangleHi <= (engineHi:ℝ) + (missCap:ℝ)) :
    (4:ℝ) * 768 * hiTriangleMass <= (engineHi:ℝ) + (missCap:ℝ) := by
  rw [hiTriangleMass_eq_engine]
  exact certHi

/-- Montaż: certyfikaty splotu + capy + przesłanki ogonowe => trzy cyfry.
    Wejście `hchange`/`htail` domyka `FinalTails.coord_tail_9217` /
    `FinalTails.emit_tail_cap`. -/
theorem three_digits_of_conv_certificates
    (h : FT1536.Relation.Rq)
    (certLo : (engineLo:ℝ) - (aliasCap:ℝ) <= (4:ℝ) * 768 * engineTriangleLo)
    (certHi : (4:ℝ) * 768 * engineTriangleHi <= (engineHi:ℝ) + (missCap:ℝ))
    (hchange : changeProbability^2 <= (changeCap2:ℝ))
    (htail : mean rawLaw (fun z => indicator (unsignedHalf z.2)) <= (emitCap:ℝ))
    (flat : FiniteFlat h (FT1536.Run2.GuaranteedDigits.flatBudget))
    (reject : forall c, rejection h c <= (FT1536.Run2.GuaranteedDigits.rejectBudget)) :
    (1265 : ℝ)/10^27 < delta h /\ delta h < (1275 : ℝ)/10^27 :=
  three_digits_of_binning_certificates h (hbLo_cert certLo) (hbHi_cert certHi)
    hchange htail flat reject

#print axioms windowMassWin_congr
#print axioms windowMassWin_Icc
#print axioms windowMassWin_Icc_empty
#print axioms windowMassWin_loWin
#print axioms loTriangleMass_eq_engine
#print axioms hiTriangleMass_eq_engine
#print axioms hbLo_cert
#print axioms three_digits_of_conv_certificates

end FT1536.ConvolutionCert
