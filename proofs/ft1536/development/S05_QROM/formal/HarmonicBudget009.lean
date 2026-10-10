import Mathlib.Basic.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum

/- Scalar budget layer. Source FFT/root and relative-operation hypotheses
   are not proved here; neither is the full spectral/Schur bridge. -/
namespace FT1536.S05.HarmonicBudget009

theorem reciprocal_harmonic_two (a b : ℝ) (ha : 0<a) (hb : 0<b) :
    1/(2*a*b/(a+b))=(1/a+1/b)/2 := by
  have hab : a+b≠0 := ne_of_gt (add_pos ha hb)
  field_simp
  ring

theorem reciprocal_harmonic_three (a b c : ℝ)
    (ha : 0<a) (hb : 0<b) (hc : 0<c) :
    1/(3*a*b*c/(a*b+a*c+b*c))=(1/a+1/b+1/c)/3 := by
  have hs : a*b+a*c+b*c≠0 := ne_of_gt (by positivity)
  field_simp
  ring

theorem source_root_relative (s a : ℝ) (hs : 1/2≤s)
    (herr : |s-a|≤1/128) : 0<a ∧ s≤(64/63)*a := by
  obtain ⟨hlo,hhi⟩ := abs_le.mp herr
  constructor <;> linarith

theorem primal_ternary_budget : (4608 : ℝ)<18433^2/991 := by norm_num

noncomputable def relativeOp : ℝ := 1/2^53
noncomputable def envelope : ℝ :=
    (64/63)*((1+relativeOp)^20/(1-relativeOp)^11)

theorem envelope_budget : envelope < (1024/1000 : ℝ) := by
  norm_num [envelope,relativeOp]

theorem accepted_leaf_harmonic_floor (stored harmonic : ℝ)
    (hs : 1024≤stored) (hh : 0≤harmonic)
    (hlink : stored≤envelope*harmonic) : 991<harmonic := by
  have hb := envelope_budget
  have hm : envelope*harmonic≤(1024/1000)*harmonic :=
    mul_le_mul_of_nonneg_right hb.le hh
  linarith

#print axioms reciprocal_harmonic_two
#print axioms reciprocal_harmonic_three
#print axioms source_root_relative
#print axioms primal_ternary_budget
#print axioms envelope_budget
#print axioms accepted_leaf_harmonic_floor
end FT1536.S05.HarmonicBudget009
