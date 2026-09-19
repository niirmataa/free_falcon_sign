import BitErrors
set_option maxRecDepth 16384
set_option maxHeartbeats 5000000
set_option exponentiation.threshold 4096
namespace ZeroScalar
open H3Range (p2 signed mant)
def packNormal (s : Bool) (e q : Nat) : Word :=
  ⟨((if s then 9223372036854775808 else 0)+e*4503599627370496+q)%18446744073709551616,by omega⟩

theorem pack_normal_value (s : Bool) (e q : Nat) (he : e≤1054)
    (hq : 4503599627370496≤q ∧ q≤9007199254740992) :
    valueNum (packNormal s e q)=signed s ((q:Int)*p2 e) := by
  have hbits : (packNormal s e q).val=(if s then 9223372036854775808 else 0)+e*4503599627370496+q := by
    unfold packNormal
    cases s <;> dsimp <;> omega
  have hex : ex (packNormal s e q)=e+q/4503599627370496 := by
    unfold ex
    rw [hbits]
    cases s <;> dsimp <;> omega
  have hfrac : frac (packNormal s e q)=q%4503599627370496 := by
    unfold frac
    rw [hbits]
    cases s <;> dsimp <;> omega
  have hsg : sg (packNormal s e q)=s := by
    unfold sg
    rw [hbits]
    cases s <;> dsimp <;> simp only [decide_eq_true_eq,decide_eq_false_iff_not] <;> omega
  unfold valueNum magNum
  rw [hex,hfrac,hsg,ite_eq_right (show e+q/4503599627370496≠0 by omega)]
  congr 1
  by_cases hq2 : q<9007199254740992
  · have hd : q/4503599627370496=1 := by omega
    rw [hd]
    have hm : mant (q%4503599627370496)=(q:Int) := by unfold mant;omega
    rw [hm,Nat.add_sub_cancel]
  · have heq : q=9007199254740992 := by omega
    subst q
    change 4503599627370496*p2 (e+1)=9007199254740992*p2 e
    rw [p2_add]
    change 4503599627370496*(p2 e*2)=9007199254740992*p2 e
    omega

theorem round_normal_range (m : Nat) (hm : 18014398509481984≤m ∧ m<36028797018963968) :
    4503599627370496≤roundMant m ∧ roundMant m≤9007199254740992 := by
  have h:=round_error m
  omega

theorem norm_small_shift (n : Nat) (hn : 0<n ∧ n≤2147483648) : 32≤(norm64 n).2 := by
  have h:=normalizer_bounds n (by omega)
  by_cases hs : 32≤(norm64 n).2
  · exact hs
  · have hp : 2^(norm64 n).2≤2147483648 := Nat.pow_le_pow_right (by decide : 0<2) (show (norm64 n).2≤31 by omega)
    have hm:=Nat.mul_le_mul hn.2 hp
    omega

theorem sticky_multiple (n s k : Nat) (h : k≤s) : sticky (n*2^s) k=n*2^(s-k) := by
  have he : n*2^s=(n*2^(s-k))*2^k := by
    rw [Nat.mul_assoc,←Nat.pow_add,Nat.sub_add_cancel h]
  rw [he,sticky_cases]
  have hm : (n*2^(s-k)*2^k)%2^k=0 := by simp
  rw [ite_eq_left hm,Nat.mul_div_cancel _ (Nat.two_pow_pos k)]

def ofC (i : Int) : Word :=
  let n:=i.natAbs
  let st:=norm64 n
  let m:=sticky st.1 9
  if n=0 then ⟨0,by decide⟩
  else packNormal (decide (i<0)) (1085-st.2) (roundMant m)

theorem OF_EXACT (i : Int) (hi : -2147483648≤i ∧ i≤2147483647) : valueNum (ofC i)=i*D := by
  have hn : i.natAbs≤2147483648 := by omega
  by_cases hz : i.natAbs=0
  · have he : i=0 := by omega
    subst i
    simp [ofC,valueNum,magNum,sg,ex,frac,H3Range.signed]
  · have hp : 0<i.natAbs := by omega
    have ns:=normalizer_bounds i.natAbs (by omega)
    have lo:=norm_small_shift i.natAbs ⟨hp,hn⟩
    have sm : sticky (norm64 i.natAbs).1 9=i.natAbs*2^((norm64 i.natAbs).2-9) := by
      rw [ns.2.1,sticky_multiple _ _ _ (by omega)]
    have rm : roundMant (sticky (norm64 i.natAbs).1 9)=i.natAbs*2^((norm64 i.natAbs).2-11) := by
      rw [sm]
      have hex : (norm64 i.natAbs).2-9=((norm64 i.natAbs).2-11)+2 := by omega
      rw [hex,Nat.pow_add]
      have h8 : (i.natAbs*(2^((norm64 i.natAbs).2-11)*2^2))%8=0 := by
        have hex2 : (norm64 i.natAbs).2-11=((norm64 i.natAbs).2-12)+1 := by omega
        rw [hex2,Nat.pow_add]
        omega
      unfold roundMant
      rw [h8]
      dsimp
      omega
    have mr : 18014398509481984≤sticky (norm64 i.natAbs).1 9 ∧ sticky (norm64 i.natAbs).1 9<36028797018963968 := by
      have h:=sticky_interval (norm64 i.natAbs).1 9
      have he : sticky (norm64 i.natAbs).1 9=(norm64 i.natAbs).1/512 := by
        rw [ns.2.1,sticky_multiple _ _ _ (by omega)]
        have hpw : (norm64 i.natAbs).2=((norm64 i.natAbs).2-9)+9 := by omega
        conv => rhs;rw [hpw,Nat.pow_add]
        omega
      rw [he]
      omega
    dsimp only [ofC]
    rw [ite_eq_right hz,pack_normal_value _ _ _ (by omega) (round_normal_range _ mr),rm]
    have hpow : p2 ((norm64 i.natAbs).2-11)*p2 (1085-(norm64 i.natAbs).2)=D := by
      rw [←p2_add]
      unfold D
      congr 1
      omega
    have he : ((i.natAbs*2^((norm64 i.natAbs).2-11):Nat):Int)*p2 (1085-(norm64 i.natAbs).2)=(i.natAbs:Int)*D := by
      rw [Int.natCast_mul,Int.mul_assoc]
      exact congrArg (fun z : Int => (i.natAbs:Int)*z) hpow
    rw [he]
    unfold signed
    split
    · rename_i hneg
      have hs : (i.natAbs:Int)= -i := by simp only [decide_eq_true_eq] at hneg;omega
      rw [hs,Int.neg_mul,Int.neg_neg]
    · have hs : (i.natAbs:Int)=i := by omega
      rw [hs]

#check @OF_EXACT
#print axioms pack_normal_value
#print axioms round_normal_range
#print axioms norm_small_shift
#print axioms sticky_multiple
#print axioms OF_EXACT
end ZeroScalar
