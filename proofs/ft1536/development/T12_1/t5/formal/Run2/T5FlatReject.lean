import Run2.T5CosetScale
import Run2.T5KeyGenQuant
import Run2.GuaranteedDigits

set_option exponentiation.threshold 100000

namespace FT1536.Run2.T5FlatReject
open FT1536.Relation
open GaussianFiberTilt CorrectnessProbability LegalKeyErrorTransfer
open T5CosetScale T5KeyGenQuant

/- The remaining analytic obligation of the T5 route, stated as one named
   primitive (RadialObligations pattern). Discharging it requires:
   (1) the source leaf/Gram binding: the 768 accepted gate words are the
       primary-leaf source of the exact block LDL of the key's trapdoor
       Gram (pinned T5 a2 bridge, source refinement);
   (2) the Poisson/relative mass comparison of every coset and every real
       shift at exponents alpha and alpha-alpha/8, with tower coefficients
       bounded by T5GateBudget.gateCoefficientCap (kernel margins:
       T5GateBudget.product_sandwich + scale_tilt_ratio);
   (3) the finite proposal-box transport: uniform out-of-box tails at both
       scales (numeric cap to be certified by the Sage checker).
   It is a mass certificate obligation, NOT a new conditioning on keys. -/
def T5AnalyticObligation : Prop :=
  ∀ h : Rq, successfulKeyGen h → CosetScaleCert h

/- TASK §1 core theorem, in the explicit decomposition allowed by §6.1:
   for every successful KeyGen output the flatness and rejection bounds
   follow kernel-side from the named analytic obligation. -/
theorem all_key_flat_reject (h : Rq) (hk : successfulKeyGen h)
    (hob : T5AnalyticObligation) :
    FiniteFlat h GuaranteedDigits.flatBudget ∧
      (∀ c, rejection h c ≤ GuaranteedDigits.rejectBudget) :=
  flat_reject_of_coset_scale h (hob h hk)

/- Combined form matching the TASK §1 statement shape. -/
def FlatRejectObligation (h : Rq) : Prop :=
  FiniteFlat h GuaranteedDigits.flatBudget ∧
    (∀ c, rejection h c ≤ GuaranteedDigits.rejectBudget)

theorem all_key_flat_reject_obligation (hob : T5AnalyticObligation) :
    ∀ h : Rq, successfulKeyGen h → FlatRejectObligation h :=
  fun h hk => all_key_flat_reject h hk hob

/- Consequence for all successful keys: the three guaranteed digits of the
   correctness error, conditional on the raw radial enclosure (the (b)/R
   numeric layer, out of scope here). -/
theorem all_key_three_digits (h : Rq) (hk : successfulKeyGen h)
    (hob : T5AnalyticObligation)
    (hraw : GuaranteedDigits.rawLo ≤ LegalKeyErrorTransfer.rawBad ∧
      LegalKeyErrorTransfer.rawBad ≤ GuaranteedDigits.rawHi) :
    (1265 : ℝ)/10^27 < CorrectnessProbability.delta h ∧
      CorrectnessProbability.delta h < (1275 : ℝ)/10^27 := by
  obtain ⟨hflat, hrej⟩ := all_key_flat_reject h hk hob
  exact GuaranteedDigits.three_significant_digits h hraw hflat hrej

#print axioms T5GateBudget.product_sandwich
#print axioms T5GateBudget.flat_factor_margins
#print axioms T5GateBudget.scale_tilt_ratio
#print axioms T5CosetScale.flat_of_coset_scale
#print axioms T5CosetScale.reject_of_coset_scale
#print axioms T5KeyGenQuant.gate_full_floor
#print axioms all_key_flat_reject
#print axioms all_key_three_digits

end FT1536.Run2.T5FlatReject
