import ValueDomain
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace ZeroScalar
open H3Range (p2 signed mant)

def rawMant (x : Word) : Nat :=
  (((x.val*1024)%18446744073709551616) ||| 4611686018427387904) &&& 9223372036854775807
def floorC (x : Word) : Int :=
  let t:=x.val/9223372036854775808
  let m:=(rawMant x : Int)
  let xi:=if t=0 then m else -m
  let cc:=1085-(ex x : Int)
  let shifted:=xi/p2 ((cc%64).toNat)
  if (63-cc)%4294967296/2147483648=0 then shifted else -(t:Int)

theorem raw_mantissa (x : Word) : rawMant x=4611686018427387904+1024*frac x := by
  have hx:=frac_bound x
  have hm : ((x.val*1024)%18446744073709551616)%9223372036854775808=(x.val*1024)%9223372036854775808 := by omega
  have hlow : (x.val*1024)%4611686018427387904=1024*frac x := by unfold frac;omega
  have htop : (x.val*1024)%9223372036854775808/4611686018427387904=0 ∨
      (x.val*1024)%9223372036854775808/4611686018427387904=1 := by omega
  have hjoin : 4611686018427387904+1024*frac x=4611686018427387904 ||| (1024*frac x) := by
    simpa only [Nat.mul_one] using Nat.two_pow_add_eq_or_of_lt (i:=62) (show 1024*frac x<2^62 by omega) 1
  unfold rawMant
  rw [Nat.and_or_distrib_right]
  have hmask (n : Nat) : n &&& 9223372036854775807=n%9223372036854775808 := Nat.and_two_pow_sub_one_eq_mod n 63
  rw [hmask,hm]
  have hconst : 4611686018427387904 &&& 9223372036854775807=4611686018427387904 := by decide
  rw [hconst]
  rcases htop with htop|htop
  · have he : (x.val*1024)%9223372036854775808=1024*frac x := by omega
    rw [he,Nat.or_comm]
    exact hjoin.symm
  · have he : (x.val*1024)%9223372036854775808=4611686018427387904+1024*frac x := by omega
    rw [he,hjoin]
    simp only [Nat.or_assoc,Nat.or_comm,Nat.or_self]

theorem raw_mantissa_int (x : Word) : (rawMant x : Int)=1024*mant (frac x) := by
  rw [raw_mantissa]
  simp only [Int.natCast_add,Int.natCast_mul]
  unfold mant
  omega

theorem floorC_parts (x : Word) (hx : NumericCenter x) : floorC x=H3Range.floorParts (sg x) (ex x) (frac x) := by
  have he:=exponent_from_value x hx
  have hw:=x.isLt
  have ht : x.val/9223372036854775808=if sg x then 1 else 0 := by
    unfold sg
    split <;> simp_all only [decide_eq_true_eq] <;> omega
  unfold floorC H3Range.floorParts
  rw [raw_mantissa_int,ht]
  have hcc : ((1085-(ex x:Int))%64).toNat=(1085-ex x)%64 := by omega
  rw [hcc]
  by_cases hsmall : 1085-ex x≥64
  · have mask : (63-(1085-(ex x:Int)))%4294967296/2147483648≠0 := by omega
    rw [ite_eq_right mask,ite_eq_left hsmall]
    cases sg x <;> decide
  · have mask : (63-(1085-(ex x:Int)))%4294967296/2147483648=0 := by omega
    rw [ite_eq_left mask,ite_eq_right hsmall]
    have hrem : (1085-ex x)%64=1085-ex x := by omega
    rw [hrem]
    cases sg x <;> rfl

theorem FLOOR_ZERO (x : Word) (hx : NumericCenter x) : floorC x=floorVal x-eps0 x :=
  (floorC_parts x hx).trans (zero_aware_parts x hx)
theorem source_floor_range (x : Word) (hx : NumericCenter x) : -2147483283≤floorC x ∧ floorC x≤2147483281 := by
  rw [FLOOR_ZERO x hx]
  by_cases hz : x.val=9223372036854775808
  · have he:=exponent_from_value x hx
    obtain ⟨hs,he0,hf⟩:=(negzero_fields x).mp hz
    rw [floorVal_old x he,hs,he0,hf,H3Range.negative_zero_exception.2]
    simp only [eps0,ite_eq_left hz]
    decide
  · rw [eps0,ite_eq_right hz,Int.sub_zero]
    exact floorVal_range x hx
theorem C_INT_BRIDGE (x : Word) (hx : NumericCenter x) (z : Int) (hz : -365≤z ∧ z≤366) :
    -2147483648≤floorC x ∧ floorC x≤2147483647 ∧ -2147483648≤floorC x+z ∧ floorC x+z≤2147483647 :=
  H3Range.integer_safety (floorC x) z (source_floor_range x hx) hz

#check @FLOOR_ZERO
#check @C_INT_BRIDGE
#print axioms raw_mantissa
#print axioms raw_mantissa_int
#print axioms floorC_parts
#print axioms FLOOR_ZERO
#print axioms source_floor_range
#print axioms C_INT_BRIDGE
end ZeroScalar
