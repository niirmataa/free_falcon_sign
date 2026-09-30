import Run2.RawIndependence
import Run2.RawRadialEnclosure

set_option maxHeartbeats 4000000
set_option maxRecDepth 65536

-- Local instance hygiene (wzorzec LEAN_INSTANCE_HYGIENE): bez democji
-- składnia `mean ⟨law⟩ (λ…)` syntezyzuje Fintype przez Fintype.ofFinite
-- i unifier rozwija dane elems (Fin.foldr.loop) — pętla elaboratora.
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

/- ============================================================================
   Redukcja hipotez numerycznych z RawRadialEnclosure do prymitywnych
   obowiązków geometryczno-probabilistycznych.

   enclosure_of_radial_certificates spożywa cztery hipotezy. Dwie z nich
   (pairPenalty <= multiCap, emitPenalty <= emitCap) są tu sprowadzone do
   jednoblokowych/ogonowych zdań z dokładną arytmetyką wymierną (norm_num).

   Dokładność bez slacku:
   - pairPenalty = 768*767*changeProbability^2 (RawIndependence.pairPenalty_exact),
     więc changeProbability^2 <= multiCap/(768*767) jest RÓWNOZNACZNE
     pairPenalty <= multiCap; changeCap2 jest tym ilorazem, nie zaokrągleniem.
   - emitPenalty = masa unsignedHalf na drugiej połowie (rawLaw); emitBad jest
     z nią defeq (delta+beta), a przez raw_second_cylinder (niezależność
     połówek BoxPair) to masa unsignedHalf na jednej połowie wektora.
     Interfejs przez mean/indicator (słownictwo radial_sandwich).

   Pozostałe dwie hipotezy (hsumL/hsumU — przedział silnika z poprawkami
   ogranicza radialSum) pozostają obowiązkami wiązania binning/trójkąty
   (kolejny etap); tutaj przyjęte w postaci z enclosure.
   ============================================================================ -/

namespace FT1536.Run2.RadialObligations

open RawRadialEvents RawIndependence RawRadialEnclosure RawProductLaw
open LegalKeyErrorTransfer
open PublicSimulation

/-- Predykat niepodpisanego rozkładu na połowie wektora; emitBad jest z nim
    defeq po delta+beta. -/
def unsignedHalf : PublicSimulation.BoxVec → Prop :=
  fun v => ¬PublicSimulation.signed16 v

/-- changeProbability^2 <= changeCap2 <=> pairPenalty <= multiCap.
    changeCap2 = multiCap/(768*767) dokładnie (589056 = 768*767). -/
def changeCap2 : ℚ := 17142909382589539438 / (589056 * 10^62)

theorem changeCap2_margin_Q : (589056:ℚ)*changeCap2 ≤ multiCap := by
  norm_num [changeCap2, multiCap]

theorem mul768_cast : ((589056:ℚ) : ℝ) = (768:ℝ)*767 := by
  norm_num

/-- Redukcja hpair: pary zmian przez kwadrat prawdopodobieństwa jednej zmiany. -/
theorem pairPenalty_of_changeCap
    (h : changeProbability^2 ≤ (changeCap2:ℝ)) : pairPenalty ≤ (multiCap:ℝ) := by
  rw [pairPenalty_exact]
  have h0 : (0:ℝ) ≤ 768*767 := by norm_num
  refine le_trans (mul_le_mul_of_nonneg_left h h0) ?_
  rw [← mul768_cast]
  exact_mod_cast changeCap2_margin_Q

/-- Redukcja hemit: emitPenalty = masa unsignedHalf na drugiej połowie. -/
theorem emitPenalty_reduce :
    emitPenalty = mean rawLaw (fun z => indicator (unsignedHalf z.2)) := by
  classical
  have hA : mean rawLaw (fun z => indicator (emitBad z)) = emitPenalty :=
    mean_indicator _ _
  calc emitPenalty = mean rawLaw (fun z => indicator (emitBad z)) := hA.symm
    _ = mean rawLaw (fun z => indicator (unsignedHalf z.2)) := rfl

theorem emitPenalty_of_tailCap
    (htail : mean rawLaw (fun z => indicator (unsignedHalf z.2)) ≤ (emitCap:ℝ)) :
    emitPenalty ≤ (emitCap:ℝ) := by
  rw [emitPenalty_reduce]
  exact htail

/-- Wtyczka do enclosure: hpair/hemit zastąpione prymitywnymi obowiązkami;
    hsumL/hsumU zostają obowiązkami wiązania silnika (kolejny etap). -/
theorem enclosure_of_reduced_obligations
    (hsumL : (engineLo:ℝ) - (aliasCap:ℝ) ≤ radialSum)
    (hsumU : radialSum ≤ (engineHi:ℝ) + (missCap:ℝ))
    (hchange : changeProbability^2 ≤ (changeCap2:ℝ))
    (htail : mean rawLaw (fun z => indicator (unsignedHalf z.2)) ≤ (emitCap:ℝ)) :
    GuaranteedDigits.rawLo ≤ rawBad ∧ rawBad ≤ GuaranteedDigits.rawHi :=
  enclosure_of_radial_certificates hsumL hsumU
    (pairPenalty_of_changeCap hchange) (emitPenalty_of_tailCap htail)

#print axioms changeCap2_margin_Q
#print axioms pairPenalty_of_changeCap
#print axioms emitPenalty_reduce
#print axioms emitPenalty_of_tailCap
#print axioms enclosure_of_reduced_obligations

end FT1536.Run2.RadialObligations
