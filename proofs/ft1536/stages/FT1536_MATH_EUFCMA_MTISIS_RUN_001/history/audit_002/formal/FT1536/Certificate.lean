import FT1536.Geometry
namespace FT1536.Certificate
theorem centering_values :
  Geometry.block 9217 (-5000) + Geometry.block 32767 18000 = 2051350378 ∧
  Geometry.block (-9216) (-5000) + Geometry.block 32767 18000 = 2143496945 := by
  norm_num [Geometry.block]
theorem nontrivial_directional_chi2 :
  ((1/2 : ℝ)^2/(1/3)+(1/2)^2/(2/3)-1) = 1/8 ∧
  ((1/3 : ℝ)^2/(1/2)+(2/3)^2/(1/2)-1) = 1/9 := by norm_num
theorem adaptive_exact_value :
  ((1/4 : ℝ)^2/(1/12)+(1/4)^2/(1/4)+(3/8)^2/(4/9)+(1/8)^2/(2/9)-1)
    = (99/256) := by norm_num
end FT1536.Certificate
