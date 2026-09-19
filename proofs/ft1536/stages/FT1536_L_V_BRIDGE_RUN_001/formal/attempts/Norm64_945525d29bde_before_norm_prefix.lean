import BridgeWords
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Bridge
open FT1536Global FT1536Forward

def A2 (x y : Int) : Int := x*x+x*y+y*y
def Q0 (a : Vec) : Int := sumN 768 (fun i => A2 (fromVec a i) (fromVec a (i+768)))
def Q (a b : Vec) : Int := Q0 a+Q0 b
def B : Int := 2093922385
def negVec (a : Vec) : Vec := fun i => -a i

theorem fromVec_neg (a : Vec) (i : Nat) : fromVec (negVec a) i= -fromVec a i := by
  unfold fromVec negVec
  split <;> simp
theorem Q0_neg (a : Vec) : Q0 (negVec a)=Q0 a := by
  unfold Q0
  apply sum_congr
  intro i hi
  simp only [fromVec_neg,A2,Int.neg_mul_neg]

theorem int16_product (x y : Int) (hx : FT1536.InInt16 x) (hy : FT1536.InInt16 y) :
    -1073741824≤x*y ∧ x*y≤1073741824 := by
  have ax : x.natAbs≤32768 := by unfold FT1536.InInt16 at hx; omega
  have ay : y.natAbs≤32768 := by unfold FT1536.InInt16 at hy; omega
  have upper:=Int.mul_le_mul_of_natAbs_le ax ay
  have lower:=Int.mul_le_mul_of_natAbs_le (show (-x).natAbs≤32768 by simpa using ax) ay
  rw [Int.neg_mul] at lower
  omega

def normTerm (a b : Vec) (k : Nat) : Int :=
  if k<3072 then
    let i:=k/2
    if k%2=0 then fromVec a i*fromVec a i else fromVec b i*fromVec b i
  else
    let i:=(k-3072)/2
    if (k-3072)%2=0 then fromVec a i*fromVec a (i+768) else fromVec b i*fromVec b (i+768)
def normAcc (a b : Vec) : Nat → Int
  | 0 => 0
  | n+1 => s64 (normAcc a b n+s32 (normTerm a b n))
def isShort (a b : Vec) : Bool := decide (normAcc a b 4608<B)

theorem normTerm_bound (a b : Vec) (ha : SignedVec a) (hb : SignedVec b) (k : Nat) (hk : k<4608) :
    -1073741824≤normTerm a b k ∧ normTerm a b k≤1073741824 := by
  unfold normTerm
  split
  · rename_i h
    split
    · exact int16_product _ _ (fromVec_signed a ha _ (by omega)) (fromVec_signed a ha _ (by omega))
    · exact int16_product _ _ (fromVec_signed b hb _ (by omega)) (fromVec_signed b hb _ (by omega))
  · rename_i h
    split
    · exact int16_product _ _ (fromVec_signed a ha _ (by omega)) (fromVec_signed a ha _ (by omega))
    · exact int16_product _ _ (fromVec_signed b hb _ (by omega)) (fromVec_signed b hb _ (by omega))


end FT1536Bridge
