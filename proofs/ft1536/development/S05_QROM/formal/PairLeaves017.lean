import PairDensity017
import PairNormalizer017

set_option maxRecDepth 8192
set_option exponentiation.threshold 100000
namespace FT1536.S05.PairLeaves017
open FT1536.Run2 RawProductLaw
open GaussianLiterals017 CDFProbability017 PairBudget017 PairDensity017

theorem acceptance_lower (rows : Rows) : (9/16 : ℝ)≤alpha := by
  have hA := pow_le_pow_left₀ (by norm_num : (0 : ℝ)≤1/2723) scale_bounds.1 2
  have hcoeff := mul_le_mul_of_nonneg_right
    (mul_le_mul_of_nonneg_left hA signs.1.le) signs.2.2.le
  have hm := mul_le_mul hcoeff PairTail017.block_normalizer_lower (by norm_num : (0 : ℝ)≤4200000)
    (mul_nonneg (mul_nonneg signs.1.le (sq_nonneg A)) signs.2.2.le)
  calc
    _ ≤ lowerFactor*(1-tau)*4200000/2723^2 := acceptance_budget
    _ = lowerFactor*(1/2723)^2*(1-tau)*4200000 := by ring
    _ ≤ lowerFactor*A^2*(1-tau)*blockNormalizer := hm
    _ ≤ _ := accepted_mass_lower rows

theorem rejection (rows : Rows) : actualTrial.mass none≤(7/16 : ℝ) := by
  have hh := acceptance_lower rows
  unfold alpha at hh
  linarith

theorem raw (rows : Rows) (b : SamplerCode016.Block) :
    actualTrial.mass (some b)≤(1-actualTrial.mass none)*(1+1/(2 : ℝ)^100)*blockLaw.mass b := by
  have hpos := blockNormalizer_pos
  have hratio : upperFactor*A^2*blockNormalizer≤alpha*(1+1/(2 : ℝ)^100) := by
    calc
      _ ≤ ((1+1/(2 : ℝ)^100)*lowerFactor*(1-tau))*(A^2*blockNormalizer) := by
        simpa only [mul_assoc] using mul_le_mul_of_nonneg_right density_budget
          (mul_nonneg (sq_nonneg A) hpos.le)
      _ = (lowerFactor*A^2*(1-tau)*blockNormalizer)*(1+1/(2 : ℝ)^100) := by ring
      _ ≤ _ := mul_le_mul_of_nonneg_right (accepted_mass_lower rows) (by positivity)
  have hd : upperFactor*A^2≤alpha*(1+1/(2 : ℝ)^100)/blockNormalizer := (le_div_iff₀ hpos).mpr hratio
  have hm := mul_le_mul_of_nonneg_right hd (Real.exp_pos (-(blockEnergy b : ℝ)/1179648)).le
  change _≤alpha*(1+1/(2 : ℝ)^100)*(blockWeight b/blockNormalizer)
  calc
    _ ≤ upperFactor*A^2*blockWeight b := pointwise_upper rows b
    _ ≤ (alpha*(1+1/(2 : ℝ)^100)/blockNormalizer)*blockWeight b := hm
    _ = _ := by ring

/-- `rows` will be supplied by the complete finite kernel witness, not assumed. -/
theorem pair_leaves_of_rows (rows : Rows) : ImplementationBridge016.PairLeaves ActualTables016.tables :=
  ⟨rejection rows,raw rows,PairNormalizer017.zero_mass_instance⟩

#print axioms acceptance_lower
#print axioms rejection
#print axioms raw
#print axioms pair_leaves_of_rows
end FT1536.S05.PairLeaves017
