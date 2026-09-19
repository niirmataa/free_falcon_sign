import Initialization
namespace FT1536Bridge

theorem logical_shift (word bits : Nat) : word>>>bits=word/2^bits := Nat.shiftRight_eq_div_pow word bits
theorem low_mask (word bits : Nat) : word &&& (2^bits-1)=word%2^bits := Nat.and_two_pow_sub_one_eq_mod word bits
theorem sign_mask (word : Nat) : word &&& 1=word%2 := by
  simpa using low_mask word 1
theorem byte_mask (word : Nat) : word &&& 255=word%256 := by
  simpa using low_mask word 8
theorem narrow_promoted_negation (x : Int) :
    -2147483648≤ -s16 x ∧ -s16 x≤2147483647 := by
  have h:=s16_range x
  unfold FT1536.InInt16 at h
  omega
theorem zero_counter_word (k ne : Nat) (hne : ne<4294967296) : zeroCount k ne<4294967296 := by
  rw [unary_wrap k ne hne]
  exact Nat.mod_lt _ (by decide)
theorem consumed_indices (d : Bytes) (c : Cursor) (legal : LegalBytes d) (read : c.pos<d.length) :
    c.pos<18446744073709551616 ∧ c.pos+1<18446744073709551616 := by
  unfold LegalBytes at legal
  omega

#print axioms logical_shift
#print axioms low_mask
#print axioms sign_mask
#print axioms byte_mask
#print axioms narrow_promoted_negation
#print axioms zero_counter_word
#print axioms consumed_indices
end FT1536Bridge
