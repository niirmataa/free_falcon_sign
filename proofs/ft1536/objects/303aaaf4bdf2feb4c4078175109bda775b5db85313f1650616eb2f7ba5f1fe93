import Source3.FprHeaderTotal

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprSmallSigned
open B20.C

theorem add32 (a b : BitVec 32)
    (h : -2147483648≤a.toInt+b.toInt ∧ a.toInt+b.toInt<2147483648) :
    signedBitsOp .add a b=bitsOp .add a b ∧ (a+b).toInt=a.toInt+b.toInt := by
  have hn : ¬BitVec.saddOverflow a b := by
    intro hc
    simp only [BitVec.saddOverflow,Bool.or_eq_true,decide_eq_true_eq] at hc
    omega
  refine ⟨?_,BitVec.toInt_add_of_not_saddOverflow hn⟩
  simp [signedBitsOp,signedSafe,h]

theorem sub32 (a b : BitVec 32)
    (h : -2147483648≤a.toInt-b.toInt ∧ a.toInt-b.toInt<2147483648) :
    signedBitsOp .sub a b=bitsOp .sub a b ∧ (a-b).toInt=a.toInt-b.toInt := by
  have hn : ¬BitVec.ssubOverflow a b := by
    intro hc
    simp only [BitVec.ssubOverflow,Bool.or_eq_true,decide_eq_true_eq] at hc
    omega
  refine ⟨?_,BitVec.toInt_sub_of_not_ssubOverflow hn⟩
  simp [signedBitsOp,signedSafe,h]

def exponent (x : BitVec 64) : BitVec 32 := ((x >>> 52) &&& 2047#64).setWidth 32
def weight (x : BitVec 64) : BitVec 32 := (x >>> 55).setWidth 32

theorem exponent_bounds (x : BitVec 64) :
    0≤(exponent x).toInt ∧ (exponent x).toInt≤2047 := by
  have hle : ((x >>> 52) &&& 2047#64).toNat≤2047 := Nat.and_le_right
  have hn : (exponent x).toNat≤2047 := by
    simp only [exponent,BitVec.toNat_setWidth]
    omega
  have heq := BitVec.toInt_eq_toNat_of_lt (x:=exponent x) (by omega)
  omega

theorem weight_bounds (x : BitVec 64) :
    0≤(weight x).toInt ∧ (weight x).toInt≤511 := by
  have hx := x.isLt
  have hv : (x >>> 55).toNat=x.toNat/2^55 := by
    simp [BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow]
  have hn : (weight x).toNat≤511 := by
    simp only [weight,BitVec.toNat_setWidth]
    omega
  have heq := BitVec.toInt_eq_toNat_of_lt (x:=weight x) (by omega)
  omega

def mulExponent (x y zu : BitVec 64) : BitVec 32 :=
  exponent x+exponent y-2100#32+weight zu

theorem mul_signed_obligations (x y zu : BitVec 64) :
    signedBitsOp .add (exponent x) (exponent y)=bitsOp .add (exponent x) (exponent y) ∧
    signedBitsOp .sub (exponent x+exponent y) 2100#32=bitsOp .sub (exponent x+exponent y) 2100#32 ∧
    signedBitsOp .add (exponent x+exponent y-2100#32) (weight zu)=
      bitsOp .add (exponent x+exponent y-2100#32) (weight zu) ∧
    signedBitsOp .add (exponent x) 2047#32=bitsOp .add (exponent x) 2047#32 ∧
    signedBitsOp .add (exponent y) 2047#32=bitsOp .add (exponent y) 2047#32 ∧
    (-2147483648≤(mulExponent x y zu).toInt+1076 ∧
      (mulExponent x y zu).toInt+1076<2147483648) := by
  have hx := exponent_bounds x
  have hy := exponent_bounds y
  have hw := weight_bounds zu
  have c2100 : (2100#32).toInt=(2100 : Int) := by decide
  have c2047 : (2047#32).toInt=(2047 : Int) := by decide
  have hsum := add32 (exponent x) (exponent y) (by omega)
  have hsub := sub32 (exponent x+exponent y) 2100#32 (by rw [c2100]; omega)
  have hweight := add32 (exponent x+exponent y-2100#32) (weight zu) (by omega)
  exact ⟨hsum.1,hsub.1,hweight.1,
    (add32 (exponent x) 2047#32 (by rw [c2047]; omega)).1,
    (add32 (exponent y) 2047#32 (by rw [c2047]; omega)).1,
    by dsimp [mulExponent]; omega⟩

def divExponent (x y quotient : BitVec 64) : BitVec 32 :=
  exponent x-exponent y-55#32+weight quotient
def nonzeroExponent (x : BitVec 64) : BitVec 32 := (exponent x+2047#32).sshiftRight 11

theorem nonzero_exp_bool (x : BitVec 64) : nonzeroExponent x=0#32 ∨ nonzeroExponent x=1#32 := by
  have hx := exponent_bounds x
  have c : (2047#32).toInt=(2047 : Int) := by decide
  have hsum := add32 (exponent x) 2047#32 (by rw [c]; omega)
  have hval : (nonzeroExponent x).toInt=(exponent x+2047#32).toInt/2048 := by
    simp [nonzeroExponent,BitVec.toInt_sshiftRight,Int.shiftRight_eq_div_pow]
  have h01 : (nonzeroExponent x).toInt=0 ∨ (nonzeroExponent x).toInt=1 := by omega
  rcases h01 with hz | ho
  · left
    apply BitVec.eq_of_toInt_eq
    simpa using hz
  · right
    apply BitVec.eq_of_toInt_eq
    simpa using ho

theorem div_signed_obligations (x y quotient : BitVec 64) :
    signedBitsOp .sub (exponent x) (exponent y)=bitsOp .sub (exponent x) (exponent y) ∧
    signedBitsOp .sub (exponent x-exponent y) 55#32=bitsOp .sub (exponent x-exponent y) 55#32 ∧
    signedBitsOp .add (exponent x-exponent y-55#32) (weight quotient)=
      bitsOp .add (exponent x-exponent y-55#32) (weight quotient) ∧
    signedBitsOp .add (exponent x) 2047#32=bitsOp .add (exponent x) 2047#32 ∧
    B20.C.neg (.i32 (nonzeroExponent x))=some (.i32 (-(nonzeroExponent x))) ∧
    (-2147483648≤(divExponent x y quotient &&& -(nonzeroExponent x)).toInt+1076 ∧
      (divExponent x y quotient &&& -(nonzeroExponent x)).toInt+1076<2147483648) := by
  have hx := exponent_bounds x
  have hy := exponent_bounds y
  have hw := weight_bounds quotient
  have c55 : (55#32).toInt=(55 : Int) := by decide
  have c2047 : (2047#32).toInt=(2047 : Int) := by decide
  have hdiff := sub32 (exponent x) (exponent y) (by omega)
  have hsub := sub32 (exponent x-exponent y) 55#32 (by rw [c55]; omega)
  have hweight := add32 (exponent x-exponent y-55#32) (weight quotient) (by omega)
  have heplus := (add32 (exponent x) 2047#32 (by rw [c2047]; omega)).1
  refine ⟨hdiff.1,hsub.1,hweight.1,heplus,?_,?_⟩
  · rcases nonzero_exp_bool x with hz | ho
    · rw [hz]; decide
    · rw [ho]; decide
  · have hval : -2102≤(divExponent x y quotient).toInt ∧
        (divExponent x y quotient).toInt≤2503 := by dsimp [divExponent]; omega
    rcases nonzero_exp_bool x with hz | ho
    · simp [hz]
    · have hone : -(1#32)=BitVec.allOnes 32 := by decide
      rw [ho,hone,BitVec.and_allOnes]
      omega

end FT1536.Source3.FprSmallSigned

#print axioms FT1536.Source3.FprSmallSigned.mul_signed_obligations
