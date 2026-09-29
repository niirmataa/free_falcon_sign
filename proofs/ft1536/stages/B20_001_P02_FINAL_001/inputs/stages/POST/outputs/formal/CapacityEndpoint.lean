import EncoderCount
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536M0
open FT1536Global FT1536Forward FT1536Bridge

theorem positive_encoder_length (a b : Vec) (short : Q a b<2093922385) : 1921≤payloadLength b := by
  have h:=quotient_bound a b short
  unfold payloadLength staticBits
  omega
theorem counter_index_bound (s : Count) (hs : CountInv s) (h : weight s≤25267) :
    0≤s.used ∧ s.used≤3158 ∧ s.used<18446744073709551616 := by
  unfold CountInv weight at *
  omega

def witness : Vec := fun i =>
  if i.val<768 then (if i.val<330 then 1792 else 1536)
  else -(if i.val-768<330 then 1792 else 1536)
def zeroVec : Vec := fun _ => 0
theorem witness_signed : SignedVec witness := by unfold SignedVec FT1536.InInt16;decide
theorem witness_norm : Q zeroVec witness=2093088768 := by decide
theorem witness_length : payloadLength witness=3156 := by decide
theorem witness_short : Q zeroVec witness<2093922385 := by rw [witness_norm];decide
theorem witness_buffers : (2049:Int)<payloadLength witness ∧ 3073<payloadLength witness ∧ payloadLength witness≤4096 := by
  rw [witness_length];decide

#check @witness_norm
#check @witness_length
#print axioms positive_encoder_length
#print axioms counter_index_bound
#print axioms witness_signed
#print axioms witness_norm
#print axioms witness_length
#print axioms witness_short
#print axioms witness_buffers
end FT1536M0
