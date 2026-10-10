import GaussianChunks017

namespace FT1536.S05.GaussianPrefix017
open GaussianChunks017

theorem rows_of_prefix (n : ℕ) (bound : 8*n≤61441) (all : All small 0 n) :
    All GaussianCheck017.row 0 (8*n) := by
  intro i hi
  have hj : i/8 < n := by omega
  have hh := all (i/8) hj
  simp only [Nat.zero_add,small,List.all_eq_true,List.mem_range] at hh
  have hOff : i%8 < 8 := Nat.mod_lt i (by norm_num)
  have he : 8*(i/8)+i%8=i := Nat.div_add_mod i 8
  have ht := hh (i%8) hOff
  rw [he,ite_eq_left (by omega : i < 61441)] at ht
  simpa only [Nat.zero_add] using ht

#print axioms rows_of_prefix
end FT1536.S05.GaussianPrefix017
