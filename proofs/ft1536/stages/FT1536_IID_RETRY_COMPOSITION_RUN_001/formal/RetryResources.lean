import RetryCoupling
namespace RetryIID
structure Chunk where
  proposals : Nat
  extra : Nat
  drops : Nat
  finalPtr : Nat
def Chunk.Valid (c : Chunk) := 8≤c.finalPtr ∧ c.finalPtr≤4094 ∧ c.drops≤9*c.extra ∧ 33*c.proposals+c.drops=4096*c.extra+c.finalPtr
theorem chunk_generated (c : Chunk) (h : c.Valid) :
    4096*(1+c.extra)=33*c.proposals+c.drops+(4096-c.finalPtr) := by unfold Chunk.Valid at h;omega
theorem fresh_pointer_refill_bound (c : Chunk) (h : c.Valid) :
    4087*c.extra+8≤33*c.proposals := by unfold Chunk.Valid at h;omega
theorem abandoned_root_tail (c : Chunk) (h : c.Valid) : 2≤4096-c.finalPtr ∧ 4096-c.finalPtr≤4088 := by unfold Chunk.Valid at h;omega
theorem initial_block_not_optional (c : Chunk) (h : c.Valid) :
    4096*c.extra<33*c.proposals+c.drops+(4096-c.finalPtr) := by have hh:=chunk_generated c h;omega
theorem chunk_sum (xs : List Chunk) (h : ∀c∈xs,c.Valid) :
    4096*(xs.length+(xs.map Chunk.extra).sum)=
      33*(xs.map Chunk.proposals).sum+(xs.map Chunk.drops).sum+(xs.map fun c=>4096-c.finalPtr).sum := by
  induction xs with
  | nil => simp
  | cons c cs ih =>
    have hc:=chunk_generated c (h c (by simp))
    have hs : ∀d∈cs,d.Valid := by intro d hd;exact h d (by simp [hd])
    have hh:=ih hs
    simp only [List.length_cons,List.map_cons,List.sum_cons,Nat.mul_add] at *
    omega
theorem block_bound_numbers : (33*49152-8)/4087=396 ∧ (16*(396+1):Nat)=6352 ∧ 6352*4096=26017792 := by decide
theorem root_request_budget : (56*16:Nat)=896 ∧ 40+56*16=936 ∧ 15*4088=61320 := by decide
theorem counter_projection (c blocks : Nat) : (c+64*(blocks+1))%18446744073709551616=((c+64*blocks)%18446744073709551616+64)%18446744073709551616 := by omega
end RetryIID
