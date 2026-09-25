import FT1536.Geometry
import FT1536.GameByte
namespace FT1536.GameCertificate
theorem byte_frame_identity :
  (256:ℕ) ^ 40 = 2 ^ 320 ∧ (256:ℕ) ^ 2 = 2 ^ 16 := by
  refine ⟨?_, ?_⟩
  · exact FT1536.GameByte.pow256_40
  · rw [show (256:ℕ) = 2^8 by norm_num, ← pow_mul, show (8*2:ℕ) = 16 by norm_num]
theorem paid_counter_exact :
  ((1 + (1/4:ℝ)) ^ 2) = 25/16 ∧
  ((1 + (1/4:ℝ)) ^ 4) = 625/256 ∧
  (1 + (1/4:ℝ)) ^ 2 < (1 + (1/4:ℝ)) ^ 4 := by norm_num
theorem conflict_sum_exact :
  ((3:ℕ) * 2 + 3 * (3-1) / 2) = 9 ∧
  ((2:ℕ) * 2 + 2 * (2-1) / 2) = 5 := by norm_num
theorem shared_step_identity :
  (((1/2:ℝ)^2/(1/2)) + ((1/2)^2/(1/2))) = 1 ∧
  ((1/3:ℝ)^2/(1/3) + (2/3)^2/(2/3)) = 1 := by norm_num
theorem lazy_uniform_three :
  ((1/3:ℝ) * (1/3)) = 1/9 ∧ ((2/3:ℝ) * (1/3)) = 2/9 := by norm_num
theorem centering_values_game :
  Geometry.block 9217 (-5000) + Geometry.block 32767 18000 = 2051350378 ∧
  Geometry.block (-9216) (-5000) + Geometry.block 32767 18000 = 2143496945 := by
  norm_num [Geometry.block]
end FT1536.GameCertificate
