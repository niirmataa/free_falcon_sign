import Mathlib.Basic.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum

/- Numeric consumer of historical H3 exports, not their source refinement. -/
namespace FT1536.S05.RomReuseMargin010
noncomputable def beta : ℝ := 1/2^47
noncomputable def gain : ℝ := (1+beta)^20/(1-beta)^11
noncomputable def gateMin : ℝ := 4503601027220343/4398046511104

theorem root_relative (s a : ℝ) (hs : 1/2≤s) (he : |s-a|≤1/1024) :
    0<a ∧ s≤(512/511)*a := by
  obtain ⟨hlo,hhi⟩ := abs_le.mp he
  constructor <;> linarith

theorem factor_budget : (512/511 : ℝ)*gain < gateMin/1022 := by
  norm_num [gain,beta,gateMin]

theorem harmonic_floor (stored h : ℝ) (hh : 0≤h)
    (accepted : gateMin≤stored) (bound : stored≤(512/511)*gain*h) :
    991<h := by
  have h := mul_le_mul_of_nonneg_right factor_budget.le hh
  norm_num [gateMin] at accepted h
  linarith

#print axioms root_relative
#print axioms factor_budget
#print axioms harmonic_floor
end FT1536.S05.RomReuseMargin010
