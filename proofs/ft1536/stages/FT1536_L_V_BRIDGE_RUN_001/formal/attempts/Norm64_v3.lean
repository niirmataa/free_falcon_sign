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

theorem norm_prefix (a b : Vec) (ha : SignedVec a) (hb : SignedVec b) (n : Nat) (hn : n≤4608) :
    normAcc a b n=sumN n (normTerm a b) ∧
    -(n:Int)*1073741824≤normAcc a b n ∧ normAcc a b n≤(n:Int)*1073741824 := by
  induction n with
  | zero => simp [normAcc,sumN]
  | succ n ih =>
    obtain ⟨he,lo,hi⟩:=ih (by omega)
    have ht:=normTerm_bound a b ha hb n (by omega)
    have prod : s32 (normTerm a b n)=normTerm a b n := s32_exact _ (by omega)
    have hadd : -9223372036854775808≤normAcc a b n+normTerm a b n ∧
        normAcc a b n+normTerm a b n≤9223372036854775807 := by omega
    rw [normAcc,prod,s64_exact _ hadd]
    constructor
    · rw [sumN,he]
    · omega

theorem norm_no_overflow (a b : Vec) (ha : SignedVec a) (hb : SignedVec b) (n : Nat) (hn : n<4608) :
    -2147483648≤normTerm a b n ∧ normTerm a b n≤2147483647 ∧
    -4947802324992≤normAcc a b n+normTerm a b n ∧
    normAcc a b n+normTerm a b n≤4947802324992 ∧
    -9223372036854775808<normAcc a b n+normTerm a b n ∧
    normAcc a b n+normTerm a b n<9223372036854775807 := by
  have ht:=normTerm_bound a b ha hb n hn
  have hs:=norm_prefix a b ha hb n (by omega)
  omega

theorem interleave_sum (n : Nat) (f g : Nat → Int) :
    sumN (2*n) (fun k => if k%2=0 then f (k/2) else g (k/2))=sumN n f+sumN n g := by
  induction n with
  | zero => rfl
  | succ n ih =>
    have he : 2*(n+1)=(2*n+1)+1 := by omega
    rw [he,sumN,sumN,ih]
    have heven : (2*n)%2=0 ∧ (2*n)/2=n := by omega
    have hodd : (2*n+1)%2=1 ∧ (2*n+1)/2=n := by omega
    simp only [heven.1,heven.2,hodd.1,hodd.2,↓reduceIte,sumN]
    omega

-- Prevent proof-search delta expansion of thousands of known summands;
-- this local reducibility hint does not change the imported definition.
attribute [local irreducible] FT1536Forward.sumN

theorem norm_sum (a b : Vec) : sumN 4608 (normTerm a b)=Q a b := by
  have hfirst : sumN 3072 (normTerm a b)=
      sumN 1536 (fun i => fromVec a i*fromVec a i)+sumN 1536 (fun i => fromVec b i*fromVec b i) := by
    calc
      _ = sumN 3072 (fun k => if k%2=0 then fromVec a (k/2)*fromVec a (k/2) else fromVec b (k/2)*fromVec b (k/2)) := by
        apply sum_congr;intro k hk;simp only [normTerm,ite_eq_left hk]
      _ = _ := interleave_sum 1536 _ _
  have hlast : sumN 1536 (fun k => normTerm a b (3072+k))=
      sumN 768 (fun i => fromVec a i*fromVec a (i+768))+sumN 768 (fun i => fromVec b i*fromVec b (i+768)) := by
    calc
      _ = sumN 1536 (fun k => if k%2=0 then fromVec a (k/2)*fromVec a (k/2+768) else fromVec b (k/2)*fromVec b (k/2+768)) := by
        apply sum_congr;intro k hk
        simp only [normTerm,show ¬3072+k<3072 by omega,↓reduceIte,Nat.add_sub_cancel_left]
      _ = _ := interleave_sum 768 _ _
  have hsplit:=sum_split 3072 1536 (normTerm a b)
  conv at hsplit => rhs; lhs; rw [hfirst]
  conv at hsplit => rhs; rhs; rw [hlast]
  rw [hsplit]
  unfold Q Q0 A2
  conv => lhs; lhs; lhs; rw [sum_split 768 768 (fun i => fromVec a i*fromVec a i)]
  conv => lhs; lhs; rhs; rw [sum_split 768 768 (fun i => fromVec b i*fromVec b i)]
  simp only [sum_add,Nat.add_comm]
  ac_rfl

theorem NORM64_EXACT (a b : Vec) (ha : SignedVec a) (hb : SignedVec b) : normAcc a b 4608=Q a b :=
  (norm_prefix a b ha hb 4608 (by omega)).1.trans (norm_sum a b)
theorem STRICT_B (a b : Vec) (ha : SignedVec a) (hb : SignedVec b) : isShort a b=true ↔ Q a b<2093922385 := by
  unfold isShort B
  rw [NORM64_EXACT a b ha hb,decide_eq_true_eq]

#check @norm_no_overflow
#check @NORM64_EXACT
#check @STRICT_B
#print axioms Q0_neg
#print axioms int16_product
#print axioms normTerm_bound
#print axioms norm_prefix
#print axioms norm_no_overflow
#print axioms interleave_sum
#print axioms norm_sum
#print axioms NORM64_EXACT
#print axioms STRICT_B
end FT1536Bridge
