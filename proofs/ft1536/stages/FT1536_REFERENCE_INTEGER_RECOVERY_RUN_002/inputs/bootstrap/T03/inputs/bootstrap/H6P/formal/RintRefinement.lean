import RintBits
namespace Postprocess
def nearestQuotient (m d : Nat) := m/d +
  if d<2*(m%d) ∨ (d=2*(m%d) ∧ (m/d)%2=1) then 1 else 0
def sourceMagnitude (m e : Nat) := m/2^e + increment ((m*2^(63-e))%18446744073709551616)
theorem magnitude_is_nearest (m e : Nat) (he : e≤63) :
    sourceMagnitude m e=nearestQuotient m (2^e) := by
  have hd:=shift_product e he
  have hs : 0<2^(63-e) := Nat.two_pow_pos _
  have hp : 0<2^e := Nat.two_pow_pos _
  have hr:=Nat.mod_lt m hp
  have hm : m=(m/2^e)*2^e+m%2^e := by simpa only [Nat.add_comm,Nat.mul_comm] using (Nat.mod_add_div m (2^e)).symm
  have hw:=discarded_word m (m/2^e) (m%2^e) (2^(63-e)) (2^e) hs hd hm hr
  have hh:=scaled_half_comparison (m%2^e) (2^(63-e)) (2^e) hs hd
  have hb:=Nat.mul_lt_mul_of_pos_right hr hs
  rw [hd] at hb
  have hi:=increment_rule ((m*2^(63-e))%18446744073709551616) (Nat.mod_lt _ (by decide))
  rw [hw] at hi
  have hmod : ((m/2^e)%2*9223372036854775808+(m%2^e)*2^(63-e))%9223372036854775808=(m%2^e)*2^(63-e) := by omega
  have hdiv : ((m/2^e)%2*9223372036854775808+(m%2^e)*2^(63-e))/9223372036854775808=(m/2^e)%2 := by omega
  simp only [hmod,hdiv,←hh.1,←hh.2] at hi
  unfold sourceMagnitude nearestQuotient
  rw [hw]
  exact congrArg (fun n=>m/2^e+n) hi
theorem nearest_error (q r d : Int) (hd : 0<d) (hr : 0≤r ∧ r<d) :
    let inc : Int := if d<2*r ∨ (d=2*r ∧ q%2=1) then 1 else 0;
    -d≤2*(d*(q+inc)-(d*q+r)) ∧ 2*(d*(q+inc)-(d*q+r))≤d := by
  dsimp
  split <;> simp only [Int.mul_add,Int.mul_one,Int.add_zero] <;> omega
theorem nearest_tie_even (q : Int) :
    (q+(if q%2=1 then 1 else 0))%2=0 := by split <;> omega
theorem negative_error (x w d : Int)
    (h : -d≤2*(d*w-x) ∧ 2*(d*w-x)≤d) :
    -d≤2*(d*(-w)-(-x)) ∧ 2*(d*(-w)-(-x))≤d := by
  simp only [Int.mul_neg];omega
end Postprocess
