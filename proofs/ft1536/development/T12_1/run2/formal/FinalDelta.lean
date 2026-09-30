import ThetaAssembly
import ThetaFinal
import FinalTails
import Run2.ChangedTailReduction
import Run2.RadialBinningSandwich
import ConvolutionCert

/-!
# FinalDelta — montaż `all_keys_delta` (finał łańcucha delta).

Łańcuch dowodowy (po FinalTails i ConvolutionCert):

  * `hchange` ← `ChangedTailReduction.hchange_of_tau` na `coord_tail_9217`
    (FinalTails — **dowodzone**, nie zakładane);
  * `htail`   ← `emit_tail_cap` (FinalTails — **dowodzone**);
  * `hbLo`/`hbHi` ← `ConvolutionCert.hbLo_cert`/`hbHi_cert` z przesłanek
    `certLo`/`certHi` (droga (b), decyzja właściciela: strukturalny dowód
    splotu kernel-side — szeregi generujące; `certificate_sound` zbędny);
  * `flat`/`reject` — przesłanki modelu (jak `hraw`/`hbridge`).

Dwie formy wyniku: `all_keys_delta` (wejście binning) i
`all_keys_delta_of_conv_cert` (wejście splotowe — forma finalna).
-/

set_option maxHeartbeats 4000000
set_option maxRecDepth 65536

-- Higiena instancji (jak w FinalTails i modułach Run2).
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

namespace FT1536.FinalDelta

open Finset
open FT1536.FinalTails (coord_tail_9217 emit_tail_cap)
open FT1536.ConvolutionCert
open FT1536.Run2.ChangedTailReduction
open FT1536.Run2.RawProductLaw
open FT1536.Run2.RawRadialEvents
open FT1536.Run2.RadialWindowSplit
open FT1536.Run2.RadialSymmetry
open FT1536.Run2.RadialTriangleSplit
open FT1536.Run2.RadialBinningSandwich
open FT1536.Run2.RawRadialEnclosure
open FT1536.Run2.RawIndependence
open FT1536.Run2.RadialObligations
open FT1536.Run2.LegalKeyErrorTransfer
open FT1536.Run2.CorrectnessProbability

/-- **`all_keys_delta`** — dla każdego klucza prawnego `h`:
`1265/10^27 < delta h < 1275/10^27`. Wejście binning (`hbLo`/`hbHi`
mianowane — wiązanie silnika); `hchange`/`htail` dowodzone (FinalTails). -/
theorem all_keys_delta (h : FT1536.Relation.Rq)
    (hbLo : (engineLo:ℝ) - (aliasCap:ℝ) ≤ (4:ℝ) * 768 * loTriangleMass)
    (hbHi : (4:ℝ) * 768 * hiTriangleMass ≤ (engineHi:ℝ) + (missCap:ℝ))
    (flat : FiniteFlat h (FT1536.Run2.GuaranteedDigits.flatBudget))
    (reject : ∀ c, rejection h c ≤ (FT1536.Run2.GuaranteedDigits.rejectBudget)) :
    (1265 : ℝ)/10^27 < delta h ∧ delta h < (1275 : ℝ)/10^27 :=
  three_digits_of_binning_certificates h hbLo hbHi
    (hchange_of_tau coord_tail_9217) emit_tail_cap flat reject

/-- **`all_keys_delta_of_conv_cert`** — forma finalna: jedyne przesłanki
liczbowe to `certLo`/`certHi` (certyfikat splotu, droga (b) — strukturalny
dowód kernel-side przez szeregi generujące). `hbLo`/`hbHi` domknięte
przez `hbLo_cert`/`hbHi_cert` (mostki `lo/hiTriangleMass_eq_engine`). -/
theorem all_keys_delta_of_conv_cert (h : FT1536.Relation.Rq)
    (certLo : (engineLo:ℝ) - (aliasCap:ℝ) ≤ (4:ℝ) * 768 * engineTriangleLo)
    (certHi : (4:ℝ) * 768 * engineTriangleHi ≤ (engineHi:ℝ) + (missCap:ℝ))
    (flat : FiniteFlat h (FT1536.Run2.GuaranteedDigits.flatBudget))
    (reject : ∀ c, rejection h c ≤ (FT1536.Run2.GuaranteedDigits.rejectBudget)) :
    (1265 : ℝ)/10^27 < delta h ∧ delta h < (1275 : ℝ)/10^27 :=
  three_digits_of_conv_certificates h certLo certHi
    (hchange_of_tau coord_tail_9217) emit_tail_cap flat reject

end FT1536.FinalDelta
