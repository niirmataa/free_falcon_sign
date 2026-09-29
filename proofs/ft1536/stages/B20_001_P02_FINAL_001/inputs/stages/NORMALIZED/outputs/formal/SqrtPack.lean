import Sqrt54
import StableBits
set_option maxRecDepth 16384
set_option maxHeartbeats 5000000
set_option exponentiation.threshold 4096
namespace StableNorm
open ZeroScalar
open H3Range (p2 signed mant)
-- New proof for the larger bias range; not application of old he<=1054 outside its domain.
theorem pack_value_extended (s : Bool) (e q : Nat) (he : e≤2044)
    (hq : 4503599627370496≤q ∧ q≤9007199254740992) :
    valueNum (packNormal s e q)=signed s ((q:Int)*p2 e) := by
  have hbits : (packNormal s e q).val=(if s then 9223372036854775808 else 0)+e*4503599627370496+q := by
    unfold packNormal
    cases s <;> dsimp <;> omega
  have hex : ex (packNormal s e q)=e+q/4503599627370496 := by
    unfold ex;rw [hbits];cases s <;> dsimp <;> omega
  have hf : frac (packNormal s e q)=q%4503599627370496 := by
    unfold frac;rw [hbits];cases s <;> dsimp <;> omega
  have hs : sg (packNormal s e q)=s := by
    unfold sg;rw [hbits]
    cases s <;> dsimp <;> simp only [decide_eq_true_eq,decide_eq_false_iff_not] <;> omega
  unfold valueNum magNum
  rw [hex,hf,hs,ite_eq_right (show e+q/4503599627370496≠0 by omega)]
  congr 1
  by_cases h : q<9007199254740992
  · have hd : q/4503599627370496=1 := by omega
    rw [hd]
    have hm : mant (q%4503599627370496)=(q:Int) := by unfold mant;omega
    rw [hm,Nat.add_sub_cancel]
  · have eq : q=9007199254740992 := by omega
    subst q
    change 4503599627370496*p2 (e+1)=9007199254740992*p2 e
    rw [p2_add]
    change 4503599627370496*(p2 e*2)=9007199254740992*p2 e
    omega
theorem sqrt_pack_positive_finite (b m : Nat) (hb : 511≤b ∧ b≤1533)
    (hm : 18014398509481984≤m ∧ m<36028797018963968) :
    0<(packNormal false b (roundMant m)).val ∧
    (packNormal false b (roundMant m)).val<0x7ff0000000000000 := by
  have hq:=round_normal_range m hm
  unfold packNormal
  dsimp
  omega
theorem sqrt_pack_value (b m : Nat) (hb : 511≤b ∧ b≤1533)
    (hm : 18014398509481984≤m ∧ m<36028797018963968) :
    valueNum (packNormal false b (roundMant m))=(roundMant m:Int)*p2 b := by
  exact pack_value_extended false b (roundMant m) (by omega) (round_normal_range m hm)
end StableNorm
