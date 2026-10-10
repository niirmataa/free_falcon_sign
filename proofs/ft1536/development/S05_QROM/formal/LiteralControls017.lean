import GaussianCheck017
import ModuloCounts017

set_option maxRecDepth 32768
set_option exponentiation.threshold 100000
namespace FT1536.S05.LiteralControls017
open GaussianData017 GaussianPolynomial017

/-- One-unit upward mutation of the first propagated lower bound is rejected. -/
theorem lower_step_mutation :
    ¬((lower 1+1)*(numerator 1*2^400+denominator)≤lower 0*denominator*2^400) := by
  decide +kernel

/-- A probability threshold above the all-accepting value is rejected. -/
theorem center_threshold_mutation : ¬((2^256+1)*2^128≤lower 0) := by decide +kernel

/-- A zero Gaussian weight at the center fails the lower enclosure. -/
theorem center_zero_weight_mutation : ¬((2^108-1)*upper 0≤0*2^236) := by decide +kernel

theorem modulo_count_control : Nat.count (ModuloCounts017.intervalMod 5 0 1) 13=3 := by decide +kernel

theorem modulo_not_uniform :
    (Nat.count (ModuloCounts017.intervalMod 5 0 1) 13 : ℚ)/13≠1/5 := by
  rw [modulo_count_control]
  norm_num

#print axioms lower_step_mutation
#print axioms center_threshold_mutation
#print axioms center_zero_weight_mutation
#print axioms modulo_count_control
#print axioms modulo_not_uniform
end FT1536.S05.LiteralControls017
