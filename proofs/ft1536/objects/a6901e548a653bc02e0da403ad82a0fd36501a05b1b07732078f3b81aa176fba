import Source3.KeygenModpWord
import Source3.MontgomeryArithmetic

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenMontgomery
open MontgomeryArithmetic

def conditionalSubtract (t p : BitVec 32) : BitVec 32 :=
  let d := t-p
  d+(p &&& -(d >>> 31))

theorem subtract_exact (t p : BitVec 32) (hp : p.toNat<2^31) (ht : t.toNat<2*p.toNat) :
    (conditionalSubtract t p).toNat=reduce t.toNat p.toNat := by
  by_cases hlt : t.toNat<p.toNat
  · have hn : (t-p).toNat=2^32-p.toNat+t.toNat := by
      rw [BitVec.toNat_sub,Nat.mod_eq_of_lt]
      have := p.isLt
      omega
    have hshift : (t-p) >>> 31=1#32 := by
      apply BitVec.eq_of_toNat_eq
      rw [BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow,hn]
      have := p.isLt
      norm_num
      omega
    have hmask : -(1#32)=BitVec.allOnes 32 := by decide
    simp only [conditionalSubtract,hshift,hmask,BitVec.and_allOnes,BitVec.sub_add_cancel]
    exact (ite_eq_left hlt).symm
  · have hn : (t-p).toNat=t.toNat-p.toNat :=
      BitVec.toNat_sub_of_not_usubOverflow (by simp only [BitVec.usubOverflow,decide_eq_true_eq]; omega)
    have hshift : (t-p) >>> 31=0#32 := by
      apply BitVec.eq_of_toNat_eq
      rw [BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow,hn]
      norm_num
      omega
    simpa [conditionalSubtract,hshift,reduce,hlt] using hn

theorem wide_product (a b : BitVec 32) :
    (a.setWidth 64*b.setWidth 64).toNat=a.toNat*b.toNat := by
  have ha := a.isLt
  have hb := b.isLt
  have hmul : a.toNat*b.toNat<2^64 := by
    have h := Nat.mul_le_mul (show a.toNat≤2^32-1 by omega) (show b.toNat≤2^32-1 by omega)
    norm_num at h ⊢
    omega
  rw [BitVec.toNat_mul,BitVec.toNat_setWidth_of_le (by decide : 32≤64),
    BitVec.toNat_setWidth_of_le (by decide : 32≤64),Nat.mod_eq_of_lt hmul]

theorem low_product (a b p0i : BitVec 32) :
    (((a.setWidth 64*b.setWidth 64)*p0i.setWidth 64) &&& 0x7fffffff#64).toNat=
      multiplier a.toNat b.toNat p0i.toNat (2^31) := by
  rw [BitVec.toNat_and]
  change (((a.setWidth 64*b.setWidth 64)*p0i.setWidth 64).toNat &&& (2^31-1))=_
  rw [Nat.and_two_pow_sub_one_eq_mod,BitVec.toNat_mul,wide_product,
    BitVec.toNat_setWidth_of_le (by decide : 32≤64),
    Nat.mod_mod_of_dvd _ (by norm_num : 2^31∣2^64)]
  rfl

theorem correction_product (a b p p0i : BitVec 32) (hp : p.toNat<2^31) :
    ((((a.setWidth 64*b.setWidth 64)*p0i.setWidth 64) &&& 0x7fffffff#64)*p.setWidth 64).toNat=
      multiplier a.toNat b.toNat p0i.toNat (2^31)*p.toNat := by
  have hm : multiplier a.toNat b.toNat p0i.toNat (2^31)<2^31 := Nat.mod_lt _ (by decide)
  have hmul : multiplier a.toNat b.toNat p0i.toNat (2^31)*p.toNat<2^64 := by
    have h := Nat.mul_le_mul hm.le hp.le
    norm_num at h ⊢
    omega
  rw [BitVec.toNat_mul,low_product,BitVec.toNat_setWidth_of_le (by decide : 32≤64),Nat.mod_eq_of_lt hmul]

theorem quotient_word (a b p p0i : BitVec 32) (hp : 0<p.toNat) (hpr : p.toNat<2^31)
    (ha : a.toNat<p.toNat) (hb : b.toNat<p.toNat) :
    (((a.setWidth 64*b.setWidth 64+
      (((a.setWidth 64*b.setWidth 64)*p0i.setWidth 64) &&& 0x7fffffff#64)*p.setWidth 64) >>> 31).setWidth 32).toNat=
      quotient a.toNat b.toNat p.toNat p0i.toNat (2^31) := by
  have hn := numerator_bound a.toNat b.toNat p.toNat p0i.toNat (2^31) hp hpr ha hb
  have hs : a.toNat*b.toNat+multiplier a.toNat b.toNat p0i.toNat (2^31)*p.toNat<2^64 := by
    norm_num at hn hpr ⊢
    omega
  have ht : quotient a.toNat b.toNat p.toNat p0i.toNat (2^31)<2^32 := by
    have hq := quotient_bound a.toNat b.toNat p.toNat p0i.toNat (2^31) hp hpr ha hb
    norm_num at hpr hq ⊢
    omega
  simp only [BitVec.toNat_setWidth,BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow,
    BitVec.toNat_add,wide_product,correction_product a b p p0i hpr,Nat.mod_eq_of_lt hs]
  exact Nat.mod_eq_of_lt ht

theorem word_to_arithmetic (a b p p0i : BitVec 32) (hp : 0<p.toNat) (hpr : p.toNat<2^31)
    (ha : a.toNat<p.toNat) (hb : b.toNat<p.toNat) :
    (KeygenModpWord.montgomery a b p p0i).toNat=
      reduce (quotient a.toNat b.toNat p.toNat p0i.toNat (2^31)) p.toNat := by
  let t : BitVec 32 := ((a.setWidth 64*b.setWidth 64+
      (((a.setWidth 64*b.setWidth 64)*p0i.setWidth 64) &&& 0x7fffffff#64)*p.setWidth 64) >>> 31).setWidth 32
  have hq : t.toNat=quotient a.toNat b.toNat p.toNat p0i.toNat (2^31) := quotient_word a b p p0i hp hpr ha hb
  have ht : t.toNat<2*p.toNat := by rw [hq]; exact quotient_bound _ _ _ _ _ hp hpr ha hb
  change (conditionalSubtract t p).toNat=_
  rw [subtract_exact t p hpr ht,hq]

theorem source_reduction_contract (a b p p0i : BitVec 32) (z : C99IntegerReference.Value)
    (hp : 0<p.toNat) (hpr : p.toNat<2^31) (ha : a.toNat<p.toNat) (hb : b.toNat<p.toNat)
    (inverse : 2^31∣p.toNat*p0i.toNat+1) (source : KeygenModpWord.SourceExec a b p p0i z) :
    ∃ w : BitVec 32, z=.uint32 w ∧ w.toNat<p.toNat ∧
      (w.toNat*2^31)%p.toNat=(a.toNat*b.toNat)%p.toNat := by
  have hz := KeygenModpWord.source_exact a b p p0i z source
  refine ⟨KeygenModpWord.montgomery a b p p0i,hz,?_⟩
  rw [word_to_arithmetic a b p p0i hp hpr ha hb]
  exact reduction_contract a.toNat b.toNat p.toNat p0i.toNat (2^31) hp hpr ha hb inverse

end FT1536.Source3.KeygenMontgomery
