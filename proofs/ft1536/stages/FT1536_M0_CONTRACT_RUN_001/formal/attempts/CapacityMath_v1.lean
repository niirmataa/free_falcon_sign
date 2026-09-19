import Norm64
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536M0
open FT1536Global FT1536Forward FT1536Bridge

def absI (x : Int) : Int := x.natAbs
def sqSum (a : Vec) : Int := sumN 1536 (fun i => fromVec a i*fromVec a i)
def l1Sum (a : Vec) : Int := sumN 1536 (fun i => absI (fromVec a i))
def quotSum (a : Vec) : Int := sumN 1536 (fun i => absI (fromVec a i)/256)
def staticBits (a : Vec) : Int := 10*1536+quotSum a
def payloadLength (a : Vec) : Int := 1+(staticBits a+7)/8

theorem sum_le (n : Nat) (f g : Nat → Int) (h : ∀ i, i<n → f i≤g i) : sumN n f≤sumN n g := by
  induction n with
  | zero => rfl
  | succ n ih =>
    have hi:=ih (fun i hi => h i (by omega))
    have ht:=h n (by omega)
    simp only [sumN]
    omega
theorem sum_nonneg (n : Nat) (f : Nat → Int) (h : ∀ i, i<n → 0≤f i) : 0≤sumN n f := by
  have hs:=sum_le n (fun _ => 0) f h
  rw [sum_zero] at hs
  exact hs
theorem sum_const (n : Nat) (c : Int) : sumN n (fun _ => c)=(n:Int)*c := by
  induction n <;> simp_all [sumN,Int.add_mul]

theorem a2_square_bound (x y : Int) : x*x+y*y≤2*A2 x y := by
  have h:=Int.mul_self_nonneg (x+y)
  have he : (x+y)*(x+y)=x*x+2*(x*y)+y*y := by
    simp only [Int.add_mul,Int.mul_add]
    rw [Int.mul_comm y x]
    omega
  rw [he] at h
  unfold A2
  omega
theorem a2_nonnegative (x y : Int) : 0≤A2 x y := by
  have h:=a2_square_bound x y
  have hx:=Int.mul_self_nonneg x
  have hy:=Int.mul_self_nonneg y
  omega
theorem Q0_nonnegative (a : Vec) : 0≤Q0 a := by
  exact sum_nonneg 768 _ (fun _ _ => a2_nonnegative _ _)

attribute [local irreducible] FT1536Forward.sumN

theorem square_sum_bound (a : Vec) : sqSum a≤2*Q0 a := by
  have hsplit:=sum_split 768 768 (fun i => fromVec a i*fromVec a i)
  have hs:=sum_le 768 (fun i => fromVec a i*fromVec a i+fromVec a (i+768)*fromVec a (i+768))
    (fun i => 2*A2 (fromVec a i) (fromVec a (i+768))) (fun _ _ => a2_square_bound _ _)
  rw [sum_add,sum_scale] at hs
  have hsum : sqSum a=sumN 768 (fun i => fromVec a i*fromVec a i)+
      sumN 768 (fun i => fromVec a (i+768)*fromVec a (i+768)) := by
    simpa only [sqSum,Nat.add_comm] using hsplit
  rw [hsum]
  exact hs

-- Integer tangent majorant: no Real/sqrt library and no numerical assumption.
theorem abs_majorant (x : Int) : 3302*absI x≤x*x+2725801 := by
  have h:=Int.mul_self_nonneg (absI x-1651)
  have hs : absI x*absI x=x*x := Int.natAbs_mul_self' x
  simp only [Int.sub_mul,Int.mul_sub] at h
  rw [hs] at h
  omega

theorem l1_bound (a b : Vec) (short : Q a b<2093922385) : l1Sum b≤2536243 := by
  have ha:=Q0_nonnegative a
  have hsq:=square_sum_bound b
  have hl:=sum_le 1536 (fun i => 3302*absI (fromVec b i))
    (fun i => fromVec b i*fromVec b i+2725801) (fun _ _ => abs_majorant _)
  rw [sum_scale,sum_add,sum_const] at hl
  change 3302*l1Sum b≤sqSum b+1536*2725801 at hl
  unfold Q at short
  omega

theorem quotient_bound (a b : Vec) (short : Q a b<2093922385) : 0≤quotSum b ∧ quotSum b≤9907 := by
  have habs (x : Int) : 0≤absI x := Int.natCast_nonneg _
  have hn : 0≤quotSum b := sum_nonneg 1536 _ (fun i _ => by have h:=habs (fromVec b i);omega)
  have hl:=l1_bound a b short
  have hsum:=sum_le 1536 (fun i => 256*(absI (fromVec b i)/256)) (fun i => absI (fromVec b i)) (fun _ _ => by omega)
  rw [sum_scale] at hsum
  change 256*quotSum b≤l1Sum b at hsum
  exact ⟨hn,by omega⟩

theorem CAPACITY_3160 (a b : Vec) (short : Q a b<2093922385) :
    staticBits b≤25267 ∧ payloadLength b≤3160 ∧ payloadLength b<4096 := by
  have h:=quotient_bound a b short
  unfold staticBits payloadLength
  omega
theorem capacity_after_source_norm (a b : Vec) (ha : SignedVec a) (hb : SignedVec b) (accept : isShort a b=true) :
    staticBits b≤25267 ∧ payloadLength b≤3160 ∧ payloadLength b<4096 :=
  CAPACITY_3160 a b ((STRICT_B a b ha hb).mp accept)

theorem integer_endpoint_checks :
    (2536243:Nat)^2≤2*1536*(2093922385-1) ∧
    2*1536*(2093922385-1)<(2536244:Nat)^2 ∧
    2536243/256=9907 ∧ 1+(25267+7)/8=3160 ∧ 3160<4096 := by decide

#check @CAPACITY_3160
#check @capacity_after_source_norm
#print axioms sum_le
#print axioms sum_nonneg
#print axioms sum_const
#print axioms a2_square_bound
#print axioms a2_nonnegative
#print axioms Q0_nonnegative
#print axioms square_sum_bound
#print axioms abs_majorant
#print axioms l1_bound
#print axioms quotient_bound
#print axioms CAPACITY_3160
#print axioms capacity_after_source_norm
#print axioms integer_endpoint_checks
end FT1536M0
