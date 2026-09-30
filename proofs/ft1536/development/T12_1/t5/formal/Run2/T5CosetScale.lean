import Run2.T5GateBudget
import Run2.NormalizerComparison

set_option exponentiation.threshold 100000

namespace FT1536.Run2.T5CosetScale
open GaussianFiberTilt CorrectnessProbability LegalKeyErrorTransfer
open FT1536.Relation

/- The coset-scale certificate: all finite-box Gaussian fiber masses of h at
   the sampling exponent `alpha` and at the Chernoff tilt `alpha-alpha/8`
   are compared with ONE common scale. It is the kernel interface of the
   pinned T5 analytic work: Poisson/relative mass comparison of every coset
   and every real shift (leaf list of the exact block LDL), the tilted
   scale identity, and the finite proposal-box transport. Like FiniteFlat
   this is an intermediate mass certificate, NOT a definition of a selected
   subset of keys. -/
def CosetScaleCert (h : Rq) : Prop :=
  ∃ v : ℝ, 0 < v ∧
    (∀ c, T5GateBudget.productLo*v ≤ fiberMass h c alpha ∧
       fiberMass h c alpha ≤ T5GateBudget.productHi*v) ∧
    (∀ c, fiberMass h c (alpha-alpha/8) ≤
       T5GateBudget.productHi*((8 : ℝ)/7)^1536*v)

/- Kernel reduction to the already proved common-scale transfer. -/
theorem flat_of_coset_scale (h : Rq) (hc : CosetScaleCert h) :
    FiniteFlat h GuaranteedDigits.flatBudget := by
  obtain ⟨v, hv, hbounds, _htilt⟩ := hc
  exact NormalizerComparison.finiteFlat_of_common_scale h v
    T5GateBudget.productLo T5GateBudget.productHi GuaranteedDigits.flatBudget
    hv.le
    (by norm_num [GuaranteedDigits.flatBudget])
    (by norm_num [GuaranteedDigits.flatBudget])
    T5GateBudget.flat_factor_margins.1
    T5GateBudget.flat_factor_margins.2.1
    hbounds

/- The tilted normalizer ratio in the exact shape consumed by
   RejectionNumericMargin.actual_rejection_from_tilted_normalizers. -/
theorem tilted_ratio_of_coset_scale (h c : Rq) (hc : CosetScaleCert h) :
    fiberMass h c (alpha-alpha/8)/fiberMass h c alpha ≤
      ((17 : ℝ)/16)*((8 : ℝ)/7)^1536 := by
  obtain ⟨v, hv, hbounds, htilt⟩ := hc
  have hpd : 0 < fiberMass h c alpha := fiberMass_pos h c alpha
  apply (div_le_iff₀ hpd).2
  have hpl0 : 0 < T5GateBudget.productLo := T5GateBudget.productLo_pos
  have hcore : T5GateBudget.productHi ≤ ((17 : ℝ)/16)*T5GateBudget.productLo :=
    (div_le_iff₀ hpl0).mp T5GateBudget.flat_factor_margins.2.2
  have hpow : 0 ≤ ((8 : ℝ)/7)^1536 := by positivity
  calc
    fiberMass h c (alpha-alpha/8) ≤
        T5GateBudget.productHi*((8 : ℝ)/7)^1536*v := htilt c
    _ ≤ (((17 : ℝ)/16)*T5GateBudget.productLo)*((8 : ℝ)/7)^1536*v :=
      mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_right hcore hpow) hv.le
    _ = (((17 : ℝ)/16)*((8 : ℝ)/7)^1536)*(T5GateBudget.productLo*v) := by
      ring
    _ ≤ (((17 : ℝ)/16)*((8 : ℝ)/7)^1536)*fiberMass h c alpha :=
      mul_le_mul_of_nonneg_left (hbounds c).1 (by positivity)

theorem reject_of_coset_scale (h c : Rq) (hc : CosetScaleCert h) :
    rejection h c < GuaranteedDigits.rejectBudget :=
  RejectionNumericMargin.actual_rejection_from_tilted_normalizers h c
    (tilted_ratio_of_coset_scale h c hc)

theorem flat_reject_of_coset_scale (h : Rq) (hc : CosetScaleCert h) :
    FiniteFlat h GuaranteedDigits.flatBudget ∧
      (∀ c, rejection h c ≤ GuaranteedDigits.rejectBudget) :=
  ⟨flat_of_coset_scale h hc, fun c => (reject_of_coset_scale h c hc).le⟩

end FT1536.Run2.T5CosetScale
