import Run2.BlockMinima

namespace FT1536.Run2.CenteringTriangle
open Geometry

def triangle (a b : ℤ) : Prop :=
  9217≤a ∧ a≤13824 ∧ -9216≤b ∧ b≤18432-2*a

theorem centered_range (x : ℤ) : -9216≤center x ∧ center x≤9216 := by
  have h0 := Int.emod_nonneg (x+9216) (by norm_num : (18433 : ℤ)≠0)
  have h1 := Int.emod_lt_of_pos (x+9216) (by norm_num : (0 : ℤ)<18433)
  unfold center
  omega

theorem centered_block_upper (x y : ℤ) : block (center x) (center y) ≤ 3*9216^2 := by
  obtain ⟨hx0,hx1⟩ := centered_range x
  obtain ⟨hy0,hy1⟩ := centered_range y
  have hxx : (center x)^2≤9216^2 := by nlinarith
  have hyy : (center y)^2≤9216^2 := by nlinarith
  unfold block
  nlinarith [sq_nonneg (center x-center y)]

theorem three_square (x y : ℤ) : 3*x^2 ≤ 4*block x y := by
  unfold block
  nlinarith [sq_nonneg (x+2*y)]

theorem increasing_range (x y : ℤ) (h : block x y < block (center x) (center y)) :
    -18432≤x ∧ x≤18432 ∧ -18432≤y ∧ y≤18432 := by
  have hb := centered_block_upper x y
  have hx := three_square x y
  have hy : 3*y^2 ≤ 4*block x y := by
    have hh := three_square y x
    simpa [block,mul_comm,add_comm,add_left_comm,add_assoc] using hh
  constructor
  · nlinarith [sq_nonneg (x+18433)]
  constructor
  · nlinarith [sq_nonneg (x-18433)]
  constructor
  · nlinarith [sq_nonneg (y+18433)]
  · nlinarith [sq_nonneg (y-18433)]

theorem center_local (x : ℤ) (h0 : -18432≤x) (h1 : x≤18432) :
    center x = if x < -9216 then x+18433 else if 9216<x then x-18433 else x := by
  unfold center
  split_ifs <;> omega

theorem triangle_increases (x y : ℤ) (h : triangle x y) :
    block x y < block (center x) (center y) := by
  obtain ⟨hx0,hx1,hy0,hy1⟩ := h
  rw [center_local x (by omega) (by omega),center_local y (by omega) (by omega)]
  simp only [show ¬x < -9216 by omega,ite_false,show 9216<x by omega,ite_true,
    show ¬y < -9216 by omega,show ¬9216<y by omega]
  unfold block
  nlinarith

theorem center_neg (x : ℤ) : center (-x) = -center x := by
  unfold center
  omega

theorem block_swap (x y : ℤ) : block y x=block x y := by unfold block; ring
theorem block_neg (x y : ℤ) : block (-x) (-y)=block x y := by unfold block; ring

theorem exact_increase_region (x y : ℤ) :
    block x y < block (center x) (center y) ↔
      triangle x y ∨ triangle (-x) (-y) ∨ triangle y x ∨ triangle (-y) (-x) := by
  constructor
  · intro h
    obtain ⟨hx0,hx1,hy0,hy1⟩ := increasing_range x y h
    rw [center_local x hx0 hx1,center_local y hy0 hy1] at h
    unfold block at h
    unfold triangle
    split_ifs at h <;> ring_nf at h <;> omega
  · intro h
    rcases h with h | h | h | h
    · exact triangle_increases x y h
    · have hh := triangle_increases (-x) (-y) h
      simpa only [center_neg,block_neg] using hh
    · have hh := triangle_increases y x h
      simpa only [block_swap] using hh
    · have hh := triangle_increases (-y) (-x) h
      simpa only [center_neg,block_neg,block_swap] using hh

theorem row_width (k : ℤ) (hk0 : 0≤k) (hk1 : k<4608) :
    (18432-2*(9217+k))-(-9216)+1 = 9215-2*k ∧ 0<9215-2*k := by omega

end FT1536.Run2.CenteringTriangle
