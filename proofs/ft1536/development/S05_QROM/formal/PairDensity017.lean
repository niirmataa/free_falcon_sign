import PairGeometry017
import PairBudget017

set_option maxRecDepth 8192
set_option exponentiation.threshold 100000
namespace FT1536.S05.PairDensity017
open Finset FT1536.Run2 RawProductLaw SamplerCode016 CapExecution016
open PairProbability017 PairGeometry017 GaussianLiterals017 GaussianSandwich017
open CDFProbability017 PairBudget017 CentralMass017

noncomputable def actualTrial : Law (Option SamplerCode016.Block) := trialLaw (pairTrial ActualTables016.tables)
noncomputable def alpha : ℝ := 1-actualTrial.mass none

theorem threshold_cap (rows : Rows) (j : PairIndex) : ActualTables016.tables.threshold j≤2^256 :=
  GaussianLiterals017.threshold_cap rows j.val j.isLt

theorem embedded_upper (rows : Rows) (x y : CoordIndex) :
    actualTrial.mass (some (pairEmbed (x,y)))≤upperFactor*A^2*blockWeight (pairEmbed (x,y)) := by
  have hx := (actual_coord_bounds rows x).2
  have hy := (actual_coord_bounds rows y).2
  have ht := threshold_upper rows (thresholdIndex x y).val (thresholdIndex x y).isLt
  have hz : ∀ z : CoordIndex, 0≤(1+beta)*(1+delta)*A*gaussian ((z.val : ℤ)-15360).natAbs := by
    intro z
    exact mul_nonneg (mul_nonneg (mul_nonneg (by norm_num [beta]) (by norm_num [delta])) scale_bounds.2.le) (Real.exp_pos _).le
  have hxy := mul_le_mul hx hy ((coordLaw ActualTables016.tables).nonneg y) (hz x)
  have hzz : 0≤((1+beta)*(1+delta)*A*gaussian ((x.val : ℤ)-15360).natAbs)*
      ((1+beta)*(1+delta)*A*gaussian ((y.val : ℤ)-15360).natAbs) := by
    apply mul_nonneg _ (hz y)
    exact mul_nonneg (mul_nonneg (mul_nonneg (by norm_num [beta]) (by norm_num [delta])) scale_bounds.2.le) (Real.exp_pos _).le
  have hm := mul_le_mul hxy ht (by positivity : 0≤(TableData016.threshold (thresholdIndex x y).val : ℝ)/2^256) hzz
  rw [actualTrial,trial_some_embedded _ (threshold_cap rows),←gaussian_product]
  convert hm using 1 <;> simp only [ActualTables016.tables,upperFactor,value] <;> ring

theorem embedded_lower (rows : Rows) (x y : CoordIndex)
    (hc : central (blockDecode (pairEmbed (x,y)))) :
    lowerFactor*A^2*blockWeight (pairEmbed (x,y))≤actualTrial.mass (some (pairEmbed (x,y))) := by
  have hx := (actual_coord_bounds rows x).1
  have hy := (actual_coord_bounds rows y).1
  have hs : ((thresholdIndex x y).val : ℤ)-30720=value x+value y := by
    simp only [thresholdIndex,value,Nat.cast_add]
    ring
  have hsum : |value x+value y|≤15360 := by rw [embed_decode] at hc; exact hc.2.2
  have hk : (((thresholdIndex x y).val : ℤ)-30720).natAbs≤15360 := by
    rw [hs]
    have hh : ((value x+value y).natAbs : ℤ)≤15360 := by simpa only [Int.natCast_natAbs] using hsum
    exact_mod_cast hh
  have ht := threshold_lower rows (thresholdIndex x y).val (thresholdIndex x y).isLt hk
  have hy0 : 0≤(1-beta)*(1-delta)*A*gaussian ((y.val : ℤ)-15360).natAbs := by
    exact mul_nonneg (mul_nonneg (mul_nonneg (by norm_num [beta]) (by norm_num [delta])) scale_bounds.2.le) (Real.exp_pos _).le
  have hxy := mul_le_mul hx hy hy0 ((coordLaw ActualTables016.tables).nonneg x)
  have ht0 : 0≤(1-1/(2 : ℝ)^108)*gaussian (((thresholdIndex x y).val : ℤ)-30720).natAbs := by
    exact mul_nonneg (by norm_num) (Real.exp_pos _).le
  have hm := mul_le_mul hxy ht ht0
    (mul_nonneg ((coordLaw ActualTables016.tables).nonneg x) ((coordLaw ActualTables016.tables).nonneg y))
  rw [actualTrial,trial_some_embedded _ (threshold_cap rows),←gaussian_product]
  convert hm using 1 <;> simp only [ActualTables016.tables,lowerFactor,delta,value] <;> ring

theorem pointwise_upper (rows : Rows) (b : SamplerCode016.Block) :
    actualTrial.mass (some b)≤upperFactor*A^2*blockWeight b := by
  by_cases hp : ∃ p,pairEmbed p=b
  · obtain ⟨⟨x,y⟩,rfl⟩ := hp
    exact embedded_upper rows x y
  · have hz := trial_some_outside ActualTables016.tables b (by simpa only [not_exists] using hp)
    change actualTrial.mass (some b)=0 at hz
    rw [hz]
    exact mul_nonneg (mul_nonneg signs.2.1.le (sq_nonneg _)) (Real.exp_pos _).le

theorem central_lower (rows : Rows) (b : SamplerCode016.Block) (hb : central (blockDecode b)) :
    lowerFactor*A^2*blockWeight b≤actualTrial.mass (some b) := by
  obtain ⟨⟨x,y⟩,hp⟩ := central_cover b hb
  subst b
  exact embedded_lower rows x y hb

theorem accepted_mass_sum : (∑ b : SamplerCode016.Block,actualTrial.mass (some b))=alpha := by
  have hh := actualTrial.total
  rw [Fintype.sum_option] at hh
  unfold alpha
  linarith

theorem accepted_mass_lower (rows : Rows) : lowerFactor*A^2*(1-tau)*blockNormalizer≤alpha := by
  have hh : lowerFactor*A^2*(∑ b : SamplerCode016.Block,if central (blockDecode b) then blockWeight b else 0)≤
      ∑ b : SamplerCode016.Block,actualTrial.mass (some b) := by
    rw [mul_sum]
    apply sum_le_sum
    intro b _
    by_cases hb : central (blockDecode b)
    · simpa only [ite_eq_left hb] using central_lower rows b hb
    · simp only [ite_eq_right hb,mul_zero]
      exact actualTrial.nonneg _
  have hm := mul_le_mul_of_nonneg_left central_box_mass (mul_nonneg signs.1.le (sq_nonneg A))
  rw [accepted_mass_sum] at hh
  calc
    _ ≤ lowerFactor*A^2*(∑ b : SamplerCode016.Block,if central (blockDecode b) then blockWeight b else 0) := by
      simpa only [mul_assoc,tau] using hm
    _ ≤ _ := hh

#print axioms threshold_cap
#print axioms embedded_upper
#print axioms embedded_lower
#print axioms pointwise_upper
#print axioms central_lower
#print axioms accepted_mass_sum
#print axioms accepted_mass_lower
end FT1536.S05.PairDensity017
