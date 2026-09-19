import Std
set_option maxRecDepth 8192
set_option maxHeartbeats 3000000
namespace H3Range
def u64diff (x y : Nat) : Nat := ((x:Int)-(y:Int))%18446744073709551616 |>.toNat
def lt64 (x y : Nat) : Nat :=
  (x ^^^ ((x ^^^ y) ||| (u64diff x y ^^^ y))) >>> 63
theorem lt64_correct (x y : Nat) (hx : x<18446744073709551616) (hy : y<18446744073709551616) :
    lt64 x y=if x<y then 1 else 0 := by
  unfold lt64
  simp only [Nat.shiftRight_xor_distrib,Nat.shiftRight_or_distrib,Nat.shiftRight_eq_div_pow]
  change (x/9223372036854775808 ^^^ ((x/9223372036854775808 ^^^ y/9223372036854775808) |||
    (u64diff x y/9223372036854775808 ^^^ y/9223372036854775808)))=if x<y then 1 else 0
  have hd : u64diff x y<18446744073709551616 := by unfold u64diff;omega
  have xa : x/9223372036854775808=0 ∨ x/9223372036854775808=1 := by omega
  have ya : y/9223372036854775808=0 ∨ y/9223372036854775808=1 := by omega
  have da : u64diff x y/9223372036854775808=0 ∨ u64diff x y/9223372036854775808=1 := by omega
  rcases xa with xa|xa <;> rcases ya with ya|ya <;> rcases da with da|da
  all_goals
    simp only [xa,ya,da]
    unfold u64diff at da
    split <;> omega

#check @lt64_correct
#print axioms lt64_correct
end H3Range
