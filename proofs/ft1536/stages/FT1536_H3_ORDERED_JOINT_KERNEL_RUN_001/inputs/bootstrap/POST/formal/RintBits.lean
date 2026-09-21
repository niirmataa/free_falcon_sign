import SourceFloor
set_option maxRecDepth 16384
set_option maxHeartbeats 5000000
namespace Postprocess
def dd (d : Nat) := (d%4294967296) ||| ((d/4294967296) &&& 536870911)
theorem dd_zero (d : Nat) : dd d=0 ↔ d%2305843009213693952=0 := by
  unfold dd
  rw [Nat.or_eq_zero_iff,Nat.and_two_pow_sub_one_eq_mod (n:=29)]
  omega
def increment (d : Nat) := 200/2^((d/2305843009213693952) ||| (if dd d=0 then 0 else 1))%2
theorem increment_rule (d : Nat) (hd : d<18446744073709551616) :
    increment d=if 4611686018427387904<d%9223372036854775808 ∨
      (d%9223372036854775808=4611686018427387904 ∧ d/9223372036854775808=1) then 1 else 0 := by
  have cases : d/2305843009213693952=0 ∨ d/2305843009213693952=1 ∨
    d/2305843009213693952=2 ∨ d/2305843009213693952=3 ∨
    d/2305843009213693952=4 ∨ d/2305843009213693952=5 ∨
    d/2305843009213693952=6 ∨ d/2305843009213693952=7 := by omega
  rcases cases with h|h|h|h|h|h|h|h
  all_goals
    by_cases hz : d%2305843009213693952=0
    · have he : dd d=0 := (dd_zero d).mpr hz
      simp only [increment,h,ite_eq_left he]
      split <;> simp_all <;> omega
    · have he : dd d≠0 := fun e=>hz ((dd_zero d).mp e)
      simp only [increment,h,ite_eq_right he]
      split <;> simp_all <;> omega
theorem shift_product (e : Nat) (he : e≤63) : 2^e*2^(63-e)=9223372036854775808 := by
  rw [←Nat.pow_add,show e+(63-e)=63 by omega]
theorem discarded_word (m q r scale denom : Nat)
    (hs : 0<scale) (hd : denom*scale=9223372036854775808)
    (hm : m=q*denom+r) (hr : r<denom) :
    (m*scale)%18446744073709551616=(q%2)*9223372036854775808+r*scale := by
  have hlt:=Nat.mul_lt_mul_of_pos_right hr hs
  have he : m*scale=q*9223372036854775808+r*scale := by rw [hm,Nat.add_mul,Nat.mul_assoc,hd]
  rw [hd] at hlt
  rw [he]
  omega
theorem scaled_half_comparison (r scale denom : Nat) (hs : 0<scale)
    (hd : denom*scale=9223372036854775808) :
    (denom<2*r ↔ 4611686018427387904<r*scale) ∧
    (denom=2*r ↔ r*scale=4611686018427387904) := by
  have hlt : denom<2*r ↔ denom*scale<(2*r)*scale := (Nat.mul_lt_mul_right hs).symm
  have heq : denom*scale=(2*r)*scale ↔ denom=2*r := Nat.mul_right_cancel_iff hs
  rw [hd] at hlt heq
  have hh : (2*r)*scale=2*(r*scale) := by rw [Nat.mul_assoc]
  rw [hh] at hlt heq
  omega
theorem source_shift_range (ex : Nat) (he : ex≤1072) :
    13≤1085-ex ∧ 1085-ex≤1085 ∧ (1085-ex)%64<64 ∧ 63-(1085-ex)%64<64 := by omega
theorem below_half_mask (ex : Nat) (he : ex<1022) : 64≤1085-ex := by omega
theorem normal_round_count (ex : Nat) (he : 1022≤ex ∧ ex≤1072) :
    13≤1085-ex ∧ 1085-ex≤63 ∧ (1085-ex)%64=1085-ex := by omega
theorem signed_reconstruction_range (q : Int) (hq : 0≤q ∧ q≤1125899906842624) :
    -9223372036854775808< -q-1 ∧ -9223372036854775808< -q ∧ q<9223372036854775807 := by omega
end Postprocess
