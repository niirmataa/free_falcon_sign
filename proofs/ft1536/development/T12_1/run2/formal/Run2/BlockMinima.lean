import Run2.ExactCounting

namespace FT1536.Run2.BlockMinima
open Geometry

theorem integer_successive_nonneg (k : ℤ) : 0 ≤ k*(k-1) := by
  by_cases h : k≤0
  · exact mul_nonneg_of_nonpos_of_nonpos h (by omega)
  · exact mul_nonneg (by omega) (by omega)

theorem residue_block_minimum (k l : ℤ) :
    84943873 ≤ block (18433*k-9216) (18433*l-9216) := by
  by_cases h0 : k+l≤0
  · unfold block
    nlinarith [sq_nonneg (k-l),sq_nonneg (k+l)]
  · by_cases h2 : 2≤k+l
    · have hp : 0≤(k+l)*(k+l-2) := mul_nonneg (by omega) (by omega)
      unfold block
      nlinarith [sq_nonneg (k-l),hp]
    · have hs : l=1-k := by omega
      rw [hs]
      unfold block
      nlinarith [integer_successive_nonneg k]

theorem residue_minimizers (k l : ℤ)
    (h : block (18433*k-9216) (18433*l-9216) ≤ 84943874) :
    (k=0 ∧ l=1) ∨ (k=1 ∧ l=0) := by
  by_cases h0 : k+l≤0
  · unfold block at h
    nlinarith [sq_nonneg (k-l),sq_nonneg (k+l)]
  · by_cases h2 : 2≤k+l
    · have hp : 0≤(k+l)*(k+l-2) := mul_nonneg (by omega) (by omega)
      unfold block at h
      nlinarith [sq_nonneg (k-l),hp]
    · have hs : l=1-k := by omega
      rw [hs] at h
      unfold block at h
      have hk : k*(k-1)=0 := by
        have hnn := integer_successive_nonneg k
        nlinarith
      rcases mul_eq_zero.mp hk with hk | hk
      · left; omega
      · right; omega

theorem pair_identity (a b x y : ℤ) :
    2*(block a b+block x y)=block (a+x) (b+y)+block (a-x) (b-y) := by
  unfold block
  ring

theorem split_residue_minimum (a b x y k l : ℤ)
    (hx : a+x=18433*k-9216) (hy : b+y=18433*l-9216) :
    42471937 ≤ block a b+block x y := by
  have hp := pair_identity a b x y
  rw [hx,hy] at hp
  have hn := block_nonneg (a-x) (b-y)
  have hmin := residue_block_minimum k l
  omega

theorem minima_values :
    block 9217 (-9216)=84943873 ∧
    block 4608 (-4608)+block 4609 (-4608)=42471937 ∧
    (9 : ℤ)*84943873 < B ∧ B ≤ (9 : ℤ)*block (-9216) (-9216) ∧
    (9 : ℤ)*42471937 < B := by norm_num [block,B]

end FT1536.Run2.BlockMinima
