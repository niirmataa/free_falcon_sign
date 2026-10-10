import GaussianCheck017

set_option maxRecDepth 8192
namespace FT1536.S05.GaussianChunks017

def small (j : ℕ) : Bool := (List.range 8).all (fun off =>
  if 8*j+off<61441 then GaussianCheck017.row (8*j+off) else true)

def All (f : ℕ → Bool) (base count : ℕ) : Prop := ∀ i,i < count → f (base+i)=true

theorem single (f : ℕ → Bool) (base : ℕ) (h : f base=true) : All f base 1 := by
  intro i hi
  have : i=0 := by omega
  simpa only [this,Nat.add_zero] using h

theorem append (f : ℕ → Bool) (base a b : ℕ) (ha : All f base a) (hb : All f (base+a) b) :
    All f base (a+b) := by
  intro i hi
  by_cases hia : i<a
  · exact ha i hia
  · have h := hb (i-a) (by omega)
    have he : base+a+(i-a)=base+i := by omega
    rwa [he] at h

theorem rows_of_small (all : All small 0 7681) (i : ℕ) (hi : i<61441) : GaussianCheck017.row i=true := by
  have hj : i/8<7681 := by omega
  have hh := all (i/8) hj
  simp only [Nat.zero_add,small,List.all_eq_true,List.mem_range] at hh
  have hOff : i%8<8 := Nat.mod_lt i (by norm_num)
  have he : 8*(i/8)+i%8=i := Nat.div_add_mod i 8
  have ht := hh (i%8) hOff
  rw [he,ite_eq_left hi] at ht
  exact ht

#print axioms single
#print axioms append
#print axioms rows_of_small
end FT1536.S05.GaussianChunks017
