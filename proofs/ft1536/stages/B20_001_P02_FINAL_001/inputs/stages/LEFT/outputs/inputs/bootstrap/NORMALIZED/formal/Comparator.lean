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
  simp only [Nat.shiftRight_xor_distrib,Nat.shiftRight_or_distrib]
  simp only [Nat.shiftRight_eq_div_pow]
  change (x/9223372036854775808 ^^^ ((x/9223372036854775808 ^^^ y/9223372036854775808) |||
    (u64diff x y/9223372036854775808 ^^^ y/9223372036854775808)))=if x<y then 1 else 0
  have hd : u64diff x y<18446744073709551616 := by unfold u64diff;omega
  have hc : (u64diff x y : Int)=((x:Int)-(y:Int))%18446744073709551616 := by unfold u64diff;omega
  have xa : x/9223372036854775808=0 ∨ x/9223372036854775808=1 := by omega
  have ya : y/9223372036854775808=0 ∨ y/9223372036854775808=1 := by omega
  have da : u64diff x y/9223372036854775808=0 ∨ u64diff x y/9223372036854775808=1 := by omega
  rcases xa with xa|xa <;> rcases ya with ya|ya <;> rcases da with da|da
  all_goals
    simp only [xa,ya,da]
    dsimp
    split <;> omega

#check @lt64_correct
def eq64 (x y : Nat) : Nat :=
  let q:=x^^^y
  1 ^^^ ((q ||| u64diff 0 q) >>> 63)
theorem eq64_correct (x y : Nat) (hx : x<18446744073709551616) (hy : y<18446744073709551616) :
    eq64 x y=if x=y then 1 else 0 := by
  have hq : x^^^y<18446744073709551616 := Nat.xor_lt_two_pow (n:=64) hx hy
  have heq : x^^^y=0 ↔ x=y := by
    constructor
    · intro h
      have hh:=congrArg (fun z => z^^^y) h
      simpa [Nat.xor_assoc] using hh
    · intro h;subst y;simp
  unfold eq64
  simp only [Nat.shiftRight_or_distrib]
  simp only [Nat.shiftRight_eq_div_pow]
  change 1 ^^^ ((x^^^y)/9223372036854775808 ||| u64diff 0 (x^^^y)/9223372036854775808)=_
  by_cases he : x=y
  · subst y;simp [u64diff]
  · have h0 : x^^^y≠0 := fun h => he (heq.mp h)
    have hc : (u64diff 0 (x^^^y):Int)=(-(x^^^y:Int))%18446744073709551616 := by unfold u64diff;omega
    have ha : (x^^^y)/9223372036854775808=0 ∨ (x^^^y)/9223372036854775808=1 := by omega
    rw [ite_eq_right he]
    rcases ha with ha|ha
    · have hb : u64diff 0 (x^^^y)/9223372036854775808=1 := by omega
      rw [ha,hb];decide
    · have hb : u64diff 0 (x^^^y)/9223372036854775808=0 ∨ u64diff 0 (x^^^y)/9223372036854775808=1 := by omega
      rcases hb with hb|hb <;> rw [ha,hb] <;> decide

def lt128 (xh xl yh yl : Nat) : Nat := lt64 xh yh ||| (eq64 xh yh &&& lt64 xl yl)
theorem lt128_correct (xh xl yh yl : Nat)
    (hxh : xh<18446744073709551616) (hxl : xl<18446744073709551616)
    (hyh : yh<18446744073709551616) (hyl : yl<18446744073709551616) :
    lt128 xh xl yh yl=if xh*18446744073709551616+xl<yh*18446744073709551616+yl then 1 else 0 := by
  unfold lt128
  rw [lt64_correct xh yh hxh hyh,eq64_correct xh yh hxh hyh,lt64_correct xl yl hxl hyl]
  split <;> split <;> split <;> split <;> dsimp <;> omega
#print axioms lt64_correct
#print axioms eq64_correct
#print axioms lt128_correct
end H3Range
