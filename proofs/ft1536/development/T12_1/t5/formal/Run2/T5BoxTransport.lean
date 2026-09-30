import Run2.T5BoxBound
import Run2.NormalizerComparison
import Run2.RejectionNumericMargin

set_option exponentiation.threshold 100000

namespace FT1536.Run2.T5BoxTransport
open TriangularGaussian T5GateBudget T5TowerMass T5BoxBound GaussianFiberTilt
open CorrectnessProbability LegalKeyErrorTransfer NormalizerComparison
open RejectionNumericMargin
open FT1536.Relation

/- The only remaining named piece of the finite proposal-box transport
   (obligation (c)): the uniform out-of-box tail against the common scale.
   The two monotone directions are kernel content
   (T5BoxBound.fiberMass_le_infFiberMass). The tail budget is the number
   certified by run/sage/check_t5_flat_reject_margins.sage (boxTail
   ~ 4.2e-1185 <= 2^-2800, margin enormous). -/
noncomputable def transportBudget : ℝ := 1/2^2800

def BoxTransportCert (h : Rq) (v : ℝ) : Prop :=
  ∀ c : Rq, infFiberMass h c alpha - fiberMass h c alpha ≤ transportBudget*v

/- Joint certificate: tower representation of every fiber of h with one
   common scale v (obligation (b)) and the out-of-box tail against the
   same v (obligation (c)). -/
def KeyTowerTransportCert (h : Rq) : Prop :=
  ∃ v : ℝ, 0 < v ∧
    (∀ c : Rq, ∃ hr : TowerRep h c alpha, scale hr.T = v) ∧
    BoxTransportCert h v

theorem transport_factor_margins :
    (1-GuaranteedDigits.flatBudget)*productHi ≤ productLo-transportBudget ∧
    productHi ≤ (1+GuaranteedDigits.flatBudget)*(productLo-transportBudget) ∧
    productHi ≤ (17/16 : ℝ)*(productLo-transportBudget) := by
  unfold productLo productHi gateRowDev gateRatio transportBudget
    GuaranteedDigits.flatBudget
  norm_num

/- End-to-end kernel reduction: the tower representation of all fibers of h
   (obligation (b), algebraic/source content) plus the out-of-box tail
   (obligation (c)) imply the TASK §1 thesis for h. Everything between the
   two certificates and the conclusion is kernel. -/
theorem flat_reject_of_towers (h : Rq) (hk : KeyTowerTransportCert h) :
    FiniteFlat h GuaranteedDigits.flatBudget ∧
      (∀ c, rejection h c ≤ GuaranteedDigits.rejectBudget) := by
  obtain ⟨v, hv, hall, hb⟩ := hk
  have hv0 := hv.le
  have hmono : ∀ c, fiberMass h c alpha ≤ infFiberMass h c alpha := by
    intro c
    obtain ⟨hr, _⟩ := hall c
    exact fiberMass_le_infFiberMass hr
  have hmonoT : ∀ c, fiberMass h c (alpha-alpha/8) ≤
      infFiberMass h c (alpha-alpha/8) := by
    intro c
    obtain ⟨hr, _⟩ := hall c
    have hconv : (alpha-alpha/8 : ℝ) = (7/8 : ℝ)*alpha := by ring
    rw [hconv]
    exact fiberMass_le_infFiberMass (tiltedTowerRep hr)
  have hbounds : ∀ c, (productLo-transportBudget)*v ≤ fiberMass h c alpha ∧
      fiberMass h c alpha ≤ productHi*v := by
    intro c
    obtain ⟨hr, hs⟩ := hall c
    have hinf := infFiberMass_bounds hr
    rw [hs] at hinf
    refine ⟨?_, (hmono c).trans hinf.2⟩
    have hq : (productLo-transportBudget)*v = productLo*v-transportBudget*v := by
      ring
    rw [hq]
    nlinarith [hinf.1, hb c]
  have hflat : FiniteFlat h GuaranteedDigits.flatBudget :=
    finiteFlat_of_common_scale h v (productLo-transportBudget) productHi
      GuaranteedDigits.flatBudget hv0
      (by norm_num [GuaranteedDigits.flatBudget])
      (by norm_num [GuaranteedDigits.flatBudget])
      transport_factor_margins.1 transport_factor_margins.2.1 hbounds
  have hratio : ∀ c, fiberMass h c (alpha-alpha/8)/fiberMass h c alpha ≤
      ((17 : ℝ)/16)*((8 : ℝ)/7)^1536 := by
    intro c
    obtain ⟨hr, hs⟩ := hall c
    have hinft := infFiberMass_tilted hr
    rw [hs] at hinft
    have hconv : (alpha-alpha/8 : ℝ) = (7/8 : ℝ)*alpha := by ring
    have htr := hmonoT c
    rw [hconv] at htr
    have hpd : 0 < fiberMass h c alpha := fiberMass_pos h c alpha
    apply (div_le_iff₀ hpd).2
    rw [hconv]
    have hpow : 0 ≤ ((8 : ℝ)/7)^1536 := by positivity
    calc
      fiberMass h c ((7/8 : ℝ)*alpha) ≤
          productHi*((8 : ℝ)/7)^1536*v := htr.trans hinft
      _ ≤ (((17 : ℝ)/16)*(productLo-transportBudget))*((8 : ℝ)/7)^1536*v :=
        mul_le_mul_of_nonneg_right
          (mul_le_mul_of_nonneg_right transport_factor_margins.2.2 hpow) hv0
      _ = (((17 : ℝ)/16)*((8 : ℝ)/7)^1536)*((productLo-transportBudget)*v) := by
        ring
      _ ≤ (((17 : ℝ)/16)*((8 : ℝ)/7)^1536)*fiberMass h c alpha :=
        mul_le_mul_of_nonneg_left (hbounds c).1 (by positivity)
  refine ⟨hflat, fun c => ?_⟩
  exact (actual_rejection_from_tilted_normalizers h c (hratio c)).le

end FT1536.Run2.T5BoxTransport
