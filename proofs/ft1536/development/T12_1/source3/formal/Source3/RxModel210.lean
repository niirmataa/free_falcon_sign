import Source3.RxControl210

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.RxModel210

def mont (a b p pi : BitVec 32) := KeygenModpWord.montgomery a b p pi
 def chosen (x : BitVec 32) (i : Nat) (z r p pi : BitVec 32) :=
  if (x &&& RxControl210.bit i).toNat=0 then z else mont z r p pi
 def loopWord : Nat → Nat → BitVec 32 → BitVec 32 → BitVec 32 → BitVec 32 → BitVec 32 → BitVec 32
  | 0,_,_,z,_,_,_ => z
  | fuel+1,i,x,z,r,p,pi => if (RxControl210.bit i).toNat ≤ x.toNat then
      loopWord fuel (i+1) x (chosen x i z r p pi) (mont r r p pi) p pi else z
 def resultWord (n : Nat) (p pi r2 : BitVec 32) :=
  loopWord 10 0 (RxControl210.word (n-1)) (KeygenModpR.word p) r2 p pi

end FT1536.Source3.RxModel210
