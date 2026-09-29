import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum
import Mathlib.Algebra.Group.Hom.Defs

/-!
Niirmata / FT1536, RUN_002. Source attribution: Falcon Project / Thomas Pornin.
These are exact algebraic identities, NOT a C execution/refinement theorem.
The source occurrences and all missing bridges are in LEDGER_TERM_BINDINGS.json.
No source error estimate is assumed in the identities below.
-/
namespace Run002

section Ring
variable {R : Type*} [CommRing R]

/-- An arbitrary deterministic rounded product cancels when the same value is
used twice. The update-add and final-subtract defects do not cancel. -/
theorem same_product_cancel (t z p ea ec es : R) :
    ((t + p + ea - z + ec) - p + es) - (t - z) = ea + ec + es := by
  ring

/-- If the snapshots differ, their difference is an additional term. -/
theorem stale_product_defect (t z p p' ea ec es : R) :
    ((t + p + ea - z + ec) - p' + es) - (t - z) =
      ea + ec + es + (p - p') := by
  ring

/-- Terminal 1643--1646 relative to OLD t0 and the SAME Y0.
The actual stored half value cancels; the update-add defect remains. -/
theorem terminal_integer_defect (t0 y0 rx eadd esub elast : R) :
    ((t0 + rx + eadd - y0 + esub) - rx + elast) - (t0 - y0) =
      eadd + esub + elast := by
  ring

/-- In the H6P innovation frame the mean is already updated. This is a
different identity, accounting for the missing interface explicitly. -/
theorem innovation_to_old_target (t0 y0 rx eadd : R) :
    ((t0 + rx + eadd) - y0) - rx = t0 - y0 + eadd := by
  ring

/-- Common reciprocal error has a determinant image and zero second image. -/
theorem common_reciprocal_image (c nu b00 b01 b10 b11 : R) :
    (nu * c * b11) * b00 + (-nu * c * b01) * b10 =
      nu * c * (b00 * b11 - b01 * b10) := by
  ring

theorem common_reciprocal_second (c nu b01 b11 : R) :
    (nu * c * b11) * b01 + (-nu * c * b01) * b11 = 0 := by
  ring

/-- A4+B can be grouped before taking absolute values. Here B uses the
shadow residual (t-Z); it is NOT the old prose's separate -Z*DeltaB term. -/
theorem correlated_basis_transfer (t0 t1 a b dg dG : R) :
    (-t0 * dg - t1 * dG) + ((t0 - a) * dg + (t1 - b) * dG) =
      -a * dg - b * dG := by
  ring

/-- Ten-term first-coordinate identity in root space. t0,t1 are target words,
lambda*q=Cw; kappa is the complete nonterminal defect, tau the terminal part.
The bridge bounding these defects for C is intentionally not asserted. -/
theorem ledger_first (c cw lam q g G wg wf wG wF a b rho0 rho1 k0 k1 u0 u1 d e : R)
    (hcw : lam * q = cw) :
    ((lam * wF + rho0 - a + k0 + u0) * wg +
      (-lam * wf + rho1 - b + k1 + u1) * wG + d + e) -
      (c - a * g - b * G) =
    (cw - c) +
    lam * (wg * wF - wf * wG - q) +
    (rho0 * wg + rho1 * wG) +
    (-(lam * wF + rho0) * (wg - g) - (-lam * wf + rho1) * (wG - G)) +
    (((lam * wF + rho0) - a) * (wg - g) + ((-lam * wf + rho1) - b) * (wG - G)) +
    (k0 * g + k1 * G) + (u0 * g + u1 * G) +
    ((k0 + u0) * (wg - g) + (k1 + u1) * (wG - G)) + d + e := by
  rw [← hcw]
  ring

/-- Same ten slots, with zero A1/A2 in the second coordinate. w01,w11 include
their source signs (-f,-F); the source adds y*w11 before x*w01. -/
theorem ledger_second (lam f F wf wF a b rho0 rho1 k0 k1 u0 u1 d e : R) :
    ((-lam * wf + rho1 - b + k1 + u1) * wF +
      (lam * wF + rho0 - a + k0 + u0) * wf + d + e) -
      (-a * f - b * F) =
    0 + 0 +
    (rho0 * wf + rho1 * wF) +
    (-(lam * wF + rho0) * (wf - f) - (-lam * wf + rho1) * (wF - F)) +
    (((lam * wF + rho0) - a) * (wf - f) + ((-lam * wf + rho1) - b) * (wF - F)) +
    (k0 * f + k1 * F) + (u0 * f + u1 * F) +
    ((k0 + u0) * (wf - f) + (k1 + u1) * (wF - F)) + d + e := by
  ring

/-- Literal FPC_MUL real component: multiplication/subtraction residuals at
their actual operand snapshots. No relative-error assumption. -/
theorem cm_real_defect (ar ai br bi m0 m1 s : R) :
    ((ar * br + m0) - (ai * bi + m1) + s) - (ar * br - ai * bi) =
      m0 - m1 + s := by
  ring

theorem cm_imag_defect (ar ai br bi m0 m1 s : R) :
    ((ar * bi + m0) + (ai * br + m1) + s) - (ar * bi + ai * br) =
      m0 + m1 + s := by
  ring

theorem suffix_defect (p0 p1 e0 e1 ea : R) :
    ((p0 + e0) + (p1 + e1) + ea) - (p0 + p1) = e0 + e1 + ea := by
  ring

end Ring

section Additive
variable {V S : Type*} [AddCommGroup V] [AddCommGroup S]

/-- An exact linear inverse may transport the ledger, once independently
bound to the physical roots. This does not provide that source binding. -/
theorem inverse_sum (I : V →+ S) (a1 a2 a3 a4 b c1 c2 c3 d e : V) :
    I (a1 + a2 + a3 + a4 + b + c1 + c2 + c3 + d + e) =
    I a1 + I a2 + I a3 + I a4 + I b + I c1 + I c2 + I c3 + I d + I e := by
  simp only [map_add]
end Additive

/-- Numeric target only; never an estimate of a source execution. -/
theorem proposed_budget_sum :
    (1 / 1000 + 1 / 10 + 1 / 20 + 1 / 10 + 1 / 10 + 1 / 1000 + 1 / 20 + 1 / 128 : ℚ) =
      6557 / 16000 := by norm_num

theorem proposed_budget_strict : (6557 / 16000 : ℚ) < 1 / 2 := by norm_num

end Run002
