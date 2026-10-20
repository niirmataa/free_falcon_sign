import Run2.RawRadialEvents
import Run2.GuaranteedDigits

set_option maxHeartbeats 4000000

/- ============================================================================
   Kernelowe domknięcie rawBad konkretnym rachunkiem radialnym.

   Wejście numeryczne (z obliczeń zewnętrznych, NIE dowodzone tutaj):
   - engineLo/engineHi: dokładne endpointy przedziału z
     run/arb_radial_full_001/arb_radial_result.json (lower_endpoint,
     upper_endpoint — liczby wymierne zapisane w całości).
   - aliasCap/missCap/multiCap/emitCap: zaokrąglenia W GÓRĘ (domknięcia
     z góry) kulek Arb z run/radial_closure_001/centering_interval_closure.json
     (aliases, input_tail, multiple_changes, signed16_emit). Zaokrąglenie w
     górę jest bezpieczne: błąd cięcia (rzędu 1e-53..1e-315) jest węższy od
     promieni kulek (1e-183..1e-446) i po właściwej stronie.

   Co dowodzi kernel (bez niedomkniętych dowodów i bez natywnej dezyduji):
   - lower_margin/upper_margin: dokładne nierówności wymierne
     engineLo-alias-multi-emit >= rawLo oraz engineHi+miss+multi <= rawHi
     (norm_num na exact QQ);
   - enclosure_of_radial_certificates: CZTERY nazwane hipotezy numeryczne
     + już udowodniony radial_sandwich => rawLo <= rawBad <= rawHi;
   - three_digits_of_radial_certificates: to zamyka warunkowy
     GuaranteedDigits.three_significant_digits bez axioms.

   Rozkład poprawek jest ten sam, co w run/sage/close_radial_interval.sage:
     raw_lower = lo - alias - multi - emit_loss
     raw_upper = hi + missing + multi
   z tą różnicą, że część parowa (multi) i emit są przypięte do jawnych
   stężeń zdarzeń z RawRadialEvents (pairPenalty, emitPenalty), a nie
   trzymane zbiorczo.
   ============================================================================ -/

namespace FT1536.Run2.RawRadialEnclosure

open RawRadialEvents LegalKeyErrorTransfer CorrectnessProbability

/-- Endpointy silnika: dokładne rationals z arb_radial_result.json. -/
def engineLo : ℚ :=
  260415179501425196834990831484427648595 /
    205688069665150755269371147819668813122841983204197482918576128
def engineHi : ℚ :=
  130388256047913744896577852830398542397 /
    102844034832575377634685573909834406561420991602098741459288064

/-- Górne domknięcia poprawek (rounding-up kulek Arb). -/
def aliasCap : ℚ := 99099791888604981023 / 10^53
def missCap  : ℚ := 215592228110355906518 / 10^58
def multiCap : ℚ := 17142909382589539438 / 10^62
def emitCap  : ℚ := 11261106164085308753 / 100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

/-! Marginesy numeryczne: czysty rachunek wymierny, kernel przez norm_num. -/

theorem lower_margin_Q :
    engineLo - aliasCap - multiCap - emitCap ≥ 1266068 / 10^30 := by
  norm_num [engineLo, aliasCap, multiCap, emitCap]

theorem upper_margin_Q :
    engineHi + missCap + multiCap ≤ 1267826 / 10^30 := by
  norm_num [engineHi, missCap, multiCap]

theorem lower_cast : ((1266068 / 10^30 : ℚ) : ℝ) = GuaranteedDigits.rawLo := by
  norm_num [GuaranteedDigits.rawLo]

theorem lower_margin :
    (engineLo:ℝ) - (aliasCap:ℝ) - (multiCap:ℝ) - (emitCap:ℝ) ≥
      GuaranteedDigits.rawLo := by
  rw [← lower_cast]
  exact_mod_cast lower_margin_Q

theorem upper_cast : ((1267826 / 10^30 : ℚ) : ℝ) = GuaranteedDigits.rawHi := by
  norm_num [GuaranteedDigits.rawHi]

theorem upper_margin :
    (engineHi:ℝ) + (missCap:ℝ) + (multiCap:ℝ) ≤ GuaranteedDigits.rawHi := by
  rw [← upper_cast]
  exact_mod_cast upper_margin_Q

/-!
Cztery jawne, nazwane hipotezy numeryczne. Każda pochodzi z obliczenia
zewnętrznego (przedział FLINT/Arb + krawędzie Chernoffa) i pozostaje
obowiązaniem do osobnego rozliczenia; tutaj są jedynie spożyte.
-/

theorem enclosure_of_radial_certificates
    (hsumL : (engineLo:ℝ) - (aliasCap:ℝ) ≤ radialSum)
    (hsumU : radialSum ≤ (engineHi:ℝ) + (missCap:ℝ))
    (hpair : pairPenalty ≤ (multiCap:ℝ))
    (hemit : emitPenalty ≤ (emitCap:ℝ)) :
    GuaranteedDigits.rawLo ≤ rawBad ∧ rawBad ≤ GuaranteedDigits.rawHi := by
  have hs := RawRadialEvents.radial_sandwich
  constructor
  · have hmid : radialSum - pairPenalty - emitPenalty ≤ rawBad := hs.1
    have hlo : GuaranteedDigits.rawLo ≤ radialSum - pairPenalty - emitPenalty := by
      have := lower_margin
      linarith
    exact hlo.trans hmid
  · have hmid : rawBad ≤ radialSum + pairPenalty := hs.2
    have hhi : radialSum + pairPenalty ≤ GuaranteedDigits.rawHi := by
      have := upper_margin
      linarith
    exact hmid.trans hhi

/-- Pełny warunkowy transfer do gwarantowanych cyfr, wyłącznie z czterech
    hipotez numerycznych i udowodnionego sandwicha. Bez aksjomatów. -/
theorem three_digits_of_radial_certificates
    (h : FT1536.Relation.Rq)
    (hsumL : (engineLo:ℝ) - (aliasCap:ℝ) ≤ radialSum)
    (hsumU : radialSum ≤ (engineHi:ℝ) + (missCap:ℝ))
    (hpair : pairPenalty ≤ (multiCap:ℝ))
    (hemit : emitPenalty ≤ (emitCap:ℝ))
    (flat : FiniteFlat h GuaranteedDigits.flatBudget)
    (reject : ∀ c, rejection h c ≤ GuaranteedDigits.rejectBudget) :
    (1265 : ℝ)/10^27 < delta h ∧ delta h < (1275 : ℝ)/10^27 :=
  GuaranteedDigits.three_significant_digits h
    (enclosure_of_radial_certificates hsumL hsumU hpair hemit) flat reject

#print axioms lower_margin_Q
#print axioms upper_margin_Q
#print axioms enclosure_of_radial_certificates
#print axioms three_digits_of_radial_certificates

end FT1536.Run2.RawRadialEnclosure
