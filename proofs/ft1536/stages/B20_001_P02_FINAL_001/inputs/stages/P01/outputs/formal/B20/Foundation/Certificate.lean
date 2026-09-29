import Mathlib
import B20.Foundation.CertificateInput

namespace B20.Foundation

structure RationalInterval where
  lowerNum : Int
  lowerDen : Int
  upperNum : Int
  upperDen : Int
  deriving DecidableEq, Repr

namespace RationalInterval

def lower (i : RationalInterval) : Rat :=
  (i.lowerNum : Rat) / (i.lowerDen : Rat)

def upper (i : RationalInterval) : Rat :=
  (i.upperNum : Rat) / (i.upperDen : Rat)

/-- Exact rational interval certificate for `lower < √2 < upper`, checked
over `ℤ`: positivity of all four fields, strict bounds `lower² < 2·lowerDen²`
and `2·upperDen² < upperNum²`, and consistent endpoints. -/
def Certifies (i : RationalInterval) : Prop :=
  0 < i.lowerNum ∧ 0 < i.lowerDen ∧ 0 < i.upperNum ∧ 0 < i.upperDen ∧
  i.lowerNum * i.lowerNum < 2 * i.lowerDen * i.lowerDen ∧
  2 * i.upperDen * i.upperDen < i.upperNum * i.upperNum ∧
  i.lowerNum * i.upperDen < i.upperNum * i.lowerDen

instance decidableCertifies (i : RationalInterval) : Decidable i.Certifies := by
  unfold RationalInterval.Certifies
  infer_instance

def checkSqrt2 (i : RationalInterval) : Bool := decide i.Certifies

end RationalInterval

def sqrt2Witness : RationalInterval :=
  { lowerNum := CertificateInput.lowerNum
    lowerDen := CertificateInput.lowerDen
    upperNum := CertificateInput.upperNum
    upperDen := CertificateInput.upperDen }

theorem certificate_sound (i : RationalInterval)
    (h : i.checkSqrt2 = true) :
    (i.lower : ℝ) < Real.sqrt 2 ∧ Real.sqrt 2 < (i.upper : ℝ) := by
  have hc : i.Certifies :=
    of_decide_eq_true (by simpa [RationalInterval.checkSqrt2] using h)
  rcases hc with ⟨hln, hld, hun, hud, hloInt, hhiInt, hordInt⟩
  have hdenl : (0:ℝ) < i.lowerDen := by exact_mod_cast hld
  have hdenr : (0:ℝ) < i.upperDen := by exact_mod_cast hud
  have cast_lower : (i.lower : ℝ) = (i.lowerNum : ℝ) / (i.lowerDen : ℝ) := by
    simp [RationalInterval.lower]
  have cast_upper : (i.upper : ℝ) = (i.upperNum : ℝ) / (i.upperDen : ℝ) := by
    simp [RationalInterval.upper]
  have hpos_lower : (0:ℝ) < i.lower := by
    rw [cast_lower]
    exact div_pos (by exact_mod_cast hln) hdenl
  have hloReal : (i.lowerNum:ℝ) * i.lowerNum < 2 * i.lowerDen * i.lowerDen := by
    exact_mod_cast hloInt
  have hlo : (i.lower:ℝ)^2 < 2 := by
    rw [cast_lower, div_pow, div_lt_iff₀ (by positivity)]
    nlinarith [hloReal]
  have hhiReal : (2:ℝ) * i.upperDen * i.upperDen < i.upperNum * i.upperNum := by
    exact_mod_cast hhiInt
  have hhi : (2:ℝ) < (i.upper:ℝ)^2 := by
    rw [cast_upper, div_pow, lt_div_iff₀ (by positivity)]
    nlinarith [hhiReal]
  have hord : (i.lower:ℝ) < i.upper := by
    rw [cast_lower, cast_upper, div_lt_div_iff₀ hdenl hdenr]
    exact_mod_cast hordInt
  constructor
  · exact Real.lt_sqrt_of_sq_lt hlo
  · exact (Real.sqrt_lt' (lt_of_lt_of_le hpos_lower (le_of_lt hord))).2 hhi

theorem CertificateSound (i : RationalInterval)
    (h : i.checkSqrt2 = true) :
    (i.lower : ℝ) < Real.sqrt 2 ∧ Real.sqrt 2 < (i.upper : ℝ) :=
  certificate_sound i h

theorem sqrt2Witness_checked : sqrt2Witness.checkSqrt2 = true := by
  decide

theorem sqrt2Witness_sound :
    (sqrt2Witness.lower:ℝ) < Real.sqrt 2 ∧ Real.sqrt 2 < (sqrt2Witness.upper:ℝ) :=
  certificate_sound sqrt2Witness sqrt2Witness_checked

/-! ## Negative controls (TASK §5): malformed certificates are rejected.

The checker is a decision procedure over `ℤ`; each malformed certificate below
violates at least one required conjunct and `checkSqrt2` returns `false`.
-/

/-- False inequality: `lower = 3/2` claims `9 < 8`. -/
def falseInequalityCert : RationalInterval :=
  { lowerNum := 3, lowerDen := 2, upperNum := 3, upperDen := 2 }

theorem false_inequality_rejected : falseInequalityCert.checkSqrt2 = false := by
  decide

theorem false_inequality_not_certified : ¬ falseInequalityCert.Certifies := by
  decide

/-- Reversed endpoints: `lower = 3/2`, `upper = 7/5` (the valid witness
`7/5 < √2 < 3/2` with the endpoints swapped). -/
def reversedEndpointCert : RationalInterval :=
  { lowerNum := 3, lowerDen := 2, upperNum := 7, upperDen := 5 }

theorem reversed_endpoint_rejected : reversedEndpointCert.checkSqrt2 = false := by
  decide

theorem reversed_endpoint_not_certified : ¬ reversedEndpointCert.Certifies := by
  decide

/-- Missing denominator: `lowerDen = 0`. -/
def missingDenominatorCert : RationalInterval :=
  { lowerNum := 1, lowerDen := 0, upperNum := 3, upperDen := 2 }

theorem missing_denominator_rejected : missingDenominatorCert.checkSqrt2 = false := by
  decide

theorem missing_denominator_not_certified : ¬ missingDenominatorCert.Certifies := by
  decide

/-- Sanity: the genuine witness is accepted while every negative control is
rejected (`checkSqrt2` decides all four). -/
theorem certificate_checker_discriminates :
    sqrt2Witness.checkSqrt2 = true ∧
      falseInequalityCert.checkSqrt2 = false ∧
      reversedEndpointCert.checkSqrt2 = false ∧
      missingDenominatorCert.checkSqrt2 = false :=
  ⟨sqrt2Witness_checked, false_inequality_rejected, reversed_endpoint_rejected,
    missing_denominator_rejected⟩

end B20.Foundation
