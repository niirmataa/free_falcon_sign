import IidBytes
namespace ScalarIID
theorem unsigned_low55_comparison (w z : Nat) (hw : w<36028797018963968) (hz : z<72057594037927936) :
    ((18446744073709551616+w-z)%18446744073709551616)/9223372036854775808=if w<z then 1 else 0 := by
  split <;> omega
def countLT : Nat → Nat → Nat
  | 0,_=>0
  | n+1,z=>countLT n z+(if n<z then 1 else 0)
theorem saturated_count (n z : Nat) : countLT n z=min n z := by
  induction n with
  | zero => simp [countLT]
  | succ n ih => simp only [countLT,ih];split <;> omega
theorem zero_low_bits (u d : Nat) : u%d=0 ↔ u=(u/d)*d := by
  have h:=Nat.mod_add_div u d
  simp only [Nat.mul_comm d] at h
  omega
theorem high_half_bound (z y : Nat) (hz : z≤9223372036854775808) :
    z*y/18446744073709551616≤y/2 := by
  have h:=Nat.mul_le_mul_right y hz
  omega
theorem horner_interval (z y prev c : Nat) (hz : z≤9223372036854775808)
    (hy : y≤prev) (hc : prev≤c) :
    z*y/18446744073709551616≤c ∧ c-prev/2≤c-z*y/18446744073709551616 ∧
    c-z*y/18446744073709551616≤c := by
  have h:=high_half_bound z y hz;omega
theorem final_positive_threshold (y z : Nat) (hy : y≤9223372036854728704)
    (hz : z≤9223372036854775808) :
    18014398509482076≤(9223372036854775808-z*y/18446744073709551616)/256 := by
  have h:=high_half_bound z y hz;omega
theorem cutoff_integer (s : Nat) (h : s<1048576) :
    ((4294967296+63-s)%4294967296)/2147483648=if s≥64 then 1 else 0 := by
  split <;> omega
theorem small_trunc_shift (ex : Nat) (h : 1023≤ex ∧ ex≤1084) :
    1≤1085-ex ∧ 1085-ex≤62 ∧ (1085-ex)%64=1085-ex := by omega
theorem raw_trunc_counts (ex : Int) (h : 0≤ex ∧ ex≤2047) :
    -962≤1085-ex ∧ 1085-ex≤1085 ∧ 0≤(1085-ex)%64 ∧ (1085-ex)%64<64 := by omega
end ScalarIID
