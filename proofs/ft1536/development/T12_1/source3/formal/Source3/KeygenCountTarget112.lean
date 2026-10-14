import Source3.KeygenFirstMass112

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCountTarget112
open Finset
open KeygenSeedEntry089 (Seed)
open KeygenInputLaw110 (seedLaw)

/-- The exact missing counting statement for a quarter lower bound on any
    event of the actual 32-byte input law. This is an equivalence, not its
    right-hand-side proof. -/
theorem quarter_iff_count (event : Seed → Prop) [DecidablePred event] :
    (1 / 4 : ℝ) ≤ seedLaw.event event ↔ 2^254 ≤ (univ.filter event).card := by
  classical
  rw [KeygenSuccessCount110.uniform_event, le_div_iff₀ (by positivity)]
  have arithmetic : (1 / 4 : ℝ) * 2^256 = ((2^254 : ℕ) : ℝ) := by norm_num
  rw [arithmetic]
  exact_mod_cast (Iff.rfl : 2^254 ≤ (univ.filter event).card ↔ 2^254 ≤ (univ.filter event).card)

/-- Exact arithmetic about the measured S1 counters ONLY. -/
theorem measured_primary : (1/4 : ℚ) < 8192/23628 ∧ (8192/23628 : ℚ) < 1/2 := by norm_num

theorem measured_control : (1/4 : ℚ) < 256/739 ∧ (256/739 : ℚ) < 1/2 := by norm_num

theorem measured_accounting : 376+392+0+12303+814+1551+8192 = (23628 : ℕ) := by decide

/-- Even kernel certification of all 8192 distinct probe seeds would yield
    only their finite-subset bound, not the quarter lower bound. -/
theorem probe_subset_below_quarter : (8192 : ℝ) / 2^256 < 1/4 := by norm_num

end FT1536.Source3.KeygenCountTarget112
