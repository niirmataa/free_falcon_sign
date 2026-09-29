import RootDiv
set_option maxRecDepth 16384
set_option maxHeartbeats 5000000
namespace StableSqrt
def step (r q x : Nat) : Nat×Nat :=
  if 2*q+r≤x then (q+r,2*(x-(2*q+r))) else (q,2*x)
theorem square_shift (q r : Nat) : (q+r)^2=q^2+r*(2*q+r) := by grind [Nat.pow_two]
theorem square_twice (q r : Nat) : (q+2*r)^2=q^2+r*(4*q+4*r) := by grind [Nat.pow_two]
theorem trial_iff (N q r x : Nat) (hr : 0<r) (hi : N=q^2+r*x) :
    2*q+r≤x ↔ (q+r)^2≤N := by
  rw [square_shift,hi]
  constructor
  · intro h;exact Nat.add_le_add_left (Nat.mul_le_mul_left r h) (q^2)
  · intro h;exact Nat.le_of_mul_le_mul_left (by omega) hr
theorem step_invariant (N q r x h : Nat) (hr : r=2*h) (hi : N=q^2+r*x) :
    N=(step r q x).1^2+h*(step r q x).2 := by
  unfold step
  split
  · rename_i ht
    have hs:=Nat.sub_add_cancel ht
    simp only
    rw [square_shift]
    grind
  · simp only;grind
theorem step_bracket (N q r x h : Nat) (hr : r=2*h) (hp : 0<r)
    (hi : N=q^2+r*x) (hb : q^2≤N ∧ N<(q+2*r)^2) :
    (step r q x).1^2≤N ∧ N<((step r q x).1+2*h)^2 := by
  have ht:=trial_iff N q r x hp hi
  unfold step
  split
  · rename_i hx
    simp only
    constructor
    · exact ht.mp hx
    · have he : q+r+2*h=q+2*r := by omega
      rw [he];exact hb.2
  · rename_i hx
    simp only
    constructor
    · exact hb.1
    · have he : q+2*h=q+r := by omega
      rw [he];have hn : ¬(q+r)^2≤N := fun h=>hx (ht.mpr h);omega
theorem last_bit (N q x : Nat) (hi : N=q^2+x) (hb : q^2≤N ∧ N<(q+2)^2) :
    (step 1 q x).1^2≤N ∧ N<((step 1 q x).1+1)^2 ∧
    (step 1 q x).2=2*(N-(step 1 q x).1^2) := by
  have ht:=trial_iff N q 1 x (by decide) (by simpa using hi)
  unfold step
  split
  · rename_i hx
    simp only
    have hl:=ht.mp hx
    have hq:=square_shift q 1
    have hs:=Nat.sub_add_cancel hx
    constructor
    · exact hl
    · constructor
      · simpa [Nat.add_assoc] using hb.2
      · simp only [Nat.one_mul] at hq
        omega
  · rename_i hx
    simp only
    have hn : ¬(q+1)^2≤N := fun h=>hx (ht.mpr h)
    constructor
    · exact hb.1
    · constructor
      · omega
      · omega
def runBits : Nat → Nat → Nat → Nat×Nat
  | 0,q,x => step 1 q x
  | d+1,q,x => let z:=step (2^(d+1)) q x;runBits d z.1 z.2
theorem run_correct (d N q x : Nat) (hi : N=q^2+2^d*x)
    (hb : q^2≤N ∧ N<(q+2^(d+1))^2) :
    (runBits d q x).1^2≤N ∧ N<((runBits d q x).1+1)^2 ∧
    (runBits d q x).2=2*(N-(runBits d q x).1^2) := by
  induction d generalizing q x with
  | zero => simpa [runBits] using last_bit N q x (by simpa using hi) (by simpa using hb)
  | succ d ihd =>
    have hr : 2^(d+1)=2*2^d := by simp [Nat.pow_succ,Nat.mul_comm]
    have hbr : q^2≤N ∧ N<(q+2*2^(d+1))^2 := by simpa [Nat.pow_succ,Nat.mul_comm] using hb
    have hs:=step_invariant N q (2^(d+1)) x (2^d) hr hi
    have hk:=step_bracket N q (2^(d+1)) x (2^d) hr (Nat.two_pow_pos _) hi hbr
    simpa only [runBits,hr] using ihd (step (2^(d+1)) q x).1 (step (2^(d+1)) q x).2 hs (by simpa [hr] using hk)
theorem loop54 (a : Nat) (ha : 4503599627370496≤a ∧ a<18014398509481984) :
    (runBits 53 0 (2*a)).1^2≤18014398509481984*a ∧
    18014398509481984*a<((runBits 53 0 (2*a)).1+1)^2 ∧
    (runBits 53 0 (2*a)).2=2*(18014398509481984*a-(runBits 53 0 (2*a)).1^2) := by
  apply run_correct 53 (18014398509481984*a) 0 (2*a)
  · simp;omega
  · constructor
    · omega
    · have h:=Nat.mul_lt_mul_of_pos_left ha.2 (by decide : 0<18014398509481984)
      simpa using h
theorem state_range (N q r x : Nat) (hr : 0<r) (hi : N=q^2+r*x)
    (hb : N<(q+2*r)^2) (hc : q+2*r≤18014398509481984) :
    x<72057594037927936 ∧ 2*q+r<36028797018963968 ∧ 2*r≤36028797018963968 := by
  rw [square_twice,hi] at hb
  have hx : r*x<r*(4*q+4*r) := by omega
  have h:=Nat.lt_of_mul_lt_mul_left hx
  omega
theorem step_cap (r q x h : Nat) (hr : r=2*h) (hc : q+2*r≤18014398509481984) :
    (step r q x).1+2*h≤18014398509481984 := by unfold step;split <;> simp only <;> omega
theorem unsigned_trial_compare (x t : Nat) (hx : x<72057594037927936) (ht : t<72057594037927936) :
    ((18446744073709551616+x-t)%18446744073709551616)/9223372036854775808=if x<t then 1 else 0 := by
  split <;> omega
theorem normalized_root_range (N q : Nat)
    (hN : 2^106≤N ∧ N<2^108) (hq : q^2≤N ∧ N<(q+1)^2) :
    9007199254740992≤q ∧ q<18014398509481984 := by
  constructor
  · by_contra h
    have hb : q+1≤9007199254740992 := by omega
    have hm:=Nat.mul_self_le_mul_self hb
    have he : (q+1)^2≤2^106 := by simpa [Nat.pow_two] using hm
    omega
  · by_contra h
    have hb : 18014398509481984≤q := by omega
    have hm:=Nat.mul_self_le_mul_self hb
    have he : 2^108≤q^2 := by simpa [Nat.pow_two] using hm
    omega
theorem sqrt_initial_target_range (a : Nat)
    (ha : 4503599627370496≤a ∧ a<18014398509481984) :
    2^106≤18014398509481984*a ∧ 18014398509481984*a<2^108 := by omega
theorem guard_sticky_mantissa (q b : Nat)
    (hq : 9007199254740992≤q ∧ q<18014398509481984) (hb : b≤1) :
    18014398509481984≤2*q+b ∧ 2*q+b<36028797018963968 := by omega
theorem final_remainder_bound (N q x : Nat) (hq : q<18014398509481984)
    (hN : q^2≤N ∧ N<(q+1)^2) (hx : x=2*(N-q^2)) : x<72057594037927936 := by
  have he:=square_shift q 1
  simp only [Nat.one_mul] at he
  omega
theorem source_s_update (q r b : Nat) : 2*q+(2*r)*b=2*(q+r*b) := by grind
theorem sticky_zero_test (x : Nat) (hx : x<72057594037927936) :
    ((18446744073709551616-x)%18446744073709551616)/9223372036854775808=if x=0 then 0 else 1 := by
  split <;> omega
theorem exponent_parity (e : Int) : e=2*(e/2)+e%2 ∧ 0≤e%2 ∧ e%2<2 := by omega
theorem positive_normal_exponent_pack (ex : Nat) (he : 1≤ex ∧ ex≤2046) :
    511≤((ex:Int)-1023)/2-54+1076 ∧ ((ex:Int)-1023)/2-54+1076≤1533 ∧
    (ex+2047)/2048=1 := by omega
end StableSqrt
