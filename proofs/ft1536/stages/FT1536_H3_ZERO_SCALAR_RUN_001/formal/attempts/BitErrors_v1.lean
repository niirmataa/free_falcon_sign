import ZeroRho
set_option maxRecDepth 16384
set_option maxHeartbeats 5000000
namespace ZeroScalar

theorem or_one_bounds (q : Nat) : q≤(q|||1) ∧ (q|||1)≤q+1 := by
  have hd : (q|||1)/2=q/2 := by rw [Nat.or_div_two];simp
  have hr : (q|||1)%2=1 := (Nat.or_mod_two_eq_one).mpr (Or.inr rfl)
  omega
def sticky (x k : Nat) : Nat := (x ||| (x%2^k+(2^k-1)))/2^k
theorem sticky_cases (x k : Nat) :
    sticky x k=if x%2^k=0 then x/2^k else (x/2^k)|||1 := by
  unfold sticky
  rw [Nat.or_div_two_pow]
  have hd:=Nat.two_pow_pos k
  have hr:=Nat.mod_lt x hd
  split
  · rename_i h
    rw [h,Nat.zero_add,Nat.div_eq_of_lt (show 2^k-1<2^k by omega),Nat.or_zero]
  · rename_i h
    have he : (x%2^k+(2^k-1))/2^k=1 := by
      apply Nat.div_eq_of_lt_le <;> omega
    rw [he]

theorem sticky_interval (x k : Nat) :
    (sticky x k)*2^k≤x+2^k ∧ x≤(sticky x k)*2^k+2^k := by
  have hd:=Nat.two_pow_pos k
  have hre : x%2^k+x/2^k*2^k=x := Nat.mod_add_div x (2^k)
  have hrem:=Nat.mod_lt x hd
  rw [sticky_cases]
  split
  · omega
  · have h:=or_one_bounds (x/2^k)
    have hlo:=Nat.mul_le_mul_right (2^k) h.1
    have hhi:=Nat.mul_le_mul_right (2^k) h.2
    rw [Nat.add_mul] at hhi
    omega

def roundMant (m : Nat) : Nat := m/4+((200/2^(m%8))%2)
theorem round_error (m : Nat) :
    -2≤4*(roundMant m : Int)-(m:Int) ∧ 4*(roundMant m : Int)-(m:Int)≤2 := by
  have r : m%8=0 ∨ m%8=1 ∨ m%8=2 ∨ m%8=3 ∨ m%8=4 ∨ m%8=5 ∨ m%8=6 ∨ m%8=7 := by omega
  unfold roundMant
  rcases r with r|r|r|r|r|r|r|r <;> rw [r] <;> dsimp <;> omega

def nstep (k : Nat) (p : Nat × Nat) : Nat × Nat :=
  if p.1<2^(64-k) then (p.1*2^k,p.2+k) else p
def norm64 (m : Nat) : Nat × Nat := nstep 1 (nstep 2 (nstep 4 (nstep 8 (nstep 16 (nstep 32 (m,0))))))

theorem normalizer_bounds (m : Nat) (hm : m<18446744073709551616) :
    (norm64 m).2≤63 ∧ (norm64 m).1=m*2^(norm64 m).2 ∧
    (m=0 ∨ 9223372036854775808≤(norm64 m).1) ∧ (norm64 m).1<18446744073709551616 := by
  unfold norm64 nstep
  repeat split
  all_goals dsimp at *
  all_goals omega

#check @sticky_interval
#check @round_error
#check @normalizer_bounds
#print axioms or_one_bounds
#print axioms sticky_cases
#print axioms sticky_interval
#print axioms round_error
#print axioms normalizer_bounds
end ZeroScalar
