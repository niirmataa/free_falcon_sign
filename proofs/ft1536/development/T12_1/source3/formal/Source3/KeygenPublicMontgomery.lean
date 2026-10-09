import Source3.KeygenPublicLeafWords

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Public Montgomery reduction uses UINT32 throughout, a 16-bit radix and
   a deliberately wrapping z*q0i. Only its LOW16 bits matter. The solver's
   uint64/radix2^31 implementation is not substituted for this source. -/
namespace FT1536.Source3.KeygenPublicMontgomery
open MontgomeryArithmetic

def radix : Nat := 2^16
def modulus : BitVec 32 := 18433#32
def inverse : BitVec 32 := 18431#32

theorem inverse_source : modulus.toNat=18433 ∧ inverse.toNat=18431 ∧
    radix∣modulus.toNat*inverse.toNat+1 := by decide

theorem product (x y q : BitVec 32) (hq : q.toNat<2^15)
    (hx : x.toNat<q.toNat) (hy : y.toNat<q.toNat) : (x*y).toNat=x.toNat*y.toNat := by
  have hb := Nat.mul_le_mul hx.le hy.le
  have hqq := Nat.mul_le_mul hq.le hq.le
  rw [BitVec.toNat_mul,Nat.mod_eq_of_lt]
  norm_num at hb hqq hq ⊢
  omega

theorem low_product (x y q q0i : BitVec 32) (hq : q.toNat<2^15)
    (hx : x.toNat<q.toNat) (hy : y.toNat<q.toNat) :
    (((x*y*q0i) &&& 65535#32).toNat)=multiplier x.toNat y.toNat q0i.toNat radix := by
  rw [BitVec.toNat_and]
  change ((x*y*q0i).toNat &&& (2^16-1))=_
  rw [Nat.and_two_pow_sub_one_eq_mod,BitVec.toNat_mul,product x y q hq hx hy,
    Nat.mod_mod_of_dvd _ (by norm_num : 2^16∣2^32)]
  rfl

theorem correction_product (x y q q0i : BitVec 32) (hq : q.toNat<2^15)
    (hx : x.toNat<q.toNat) (hy : y.toNat<q.toNat) :
    ((((x*y*q0i) &&& 65535#32)*q).toNat)=multiplier x.toNat y.toNat q0i.toNat radix*q.toNat := by
  have hm : multiplier x.toNat y.toNat q0i.toNat radix<2^16 := Nat.mod_lt _ (by decide)
  have hb := Nat.mul_le_mul hm.le hq.le
  rw [BitVec.toNat_mul,low_product x y q q0i hq hx hy,Nat.mod_eq_of_lt]
  norm_num at hb ⊢
  omega

theorem quotient_word (x y q q0i : BitVec 32) (positive : 0<q.toNat) (hq : q.toNat<2^15)
    (hx : x.toNat<q.toNat) (hy : y.toNat<q.toNat) :
    ((x*y+((x*y*q0i) &&& 65535#32)*q) >>> 16).toNat=
      quotient x.toNat y.toNat q.toNat q0i.toNat radix := by
  have hqr : q.toNat<radix := by change q.toNat<65536; norm_num at hq; omega
  have hn := numerator_bound x.toNat y.toNat q.toNat q0i.toNat radix positive hqr hx hy
  have hsum : x.toNat*y.toNat+multiplier x.toNat y.toNat q0i.toNat radix*q.toNat<2^32 := by
    norm_num [radix] at hn hq ⊢
    omega
  rw [BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow,BitVec.toNat_add,
    product x y q hq hx hy,correction_product x y q q0i hq hx hy,Nat.mod_eq_of_lt hsum]
  rfl

theorem word_to_arithmetic (x y q q0i : BitVec 32) (positive : 0<q.toNat) (hq : q.toNat<2^15)
    (hx : x.toNat<q.toNat) (hy : y.toNat<q.toNat) :
    (KeygenPublicLeafWords.montgomery x y q q0i).toNat=
      reduce (quotient x.toNat y.toNat q.toNat q0i.toNat radix) q.toNat := by
  let t := (x*y+((x*y*q0i) &&& 65535#32)*q) >>> 16
  have ht : t.toNat=quotient x.toNat y.toNat q.toNat q0i.toNat radix := quotient_word x y q q0i positive hq hx hy
  have bound : t.toNat<2*q.toNat := by
    rw [ht]
    exact quotient_bound _ _ _ _ _ positive (by norm_num [radix] at hq ⊢; omega) hx hy
  change (KeygenMontgomery.conditionalSubtract t q).toNat=_
  rw [KeygenMontgomery.subtract_exact t q (by norm_num at hq ⊢; omega) bound,ht]

theorem word_contract (x y : BitVec 32)
    (hx : x.toNat<18433) (hy : y.toNat<18433) :
    (KeygenPublicLeafWords.montgomery x y modulus inverse).toNat<18433 ∧
      ((KeygenPublicLeafWords.montgomery x y modulus inverse).toNat*radix)%18433=
        (x.toNat*y.toNat)%18433 := by
  rw [word_to_arithmetic x y modulus inverse (by decide) (by decide) hx hy]
  exact reduction_contract _ _ _ _ _ (by decide) (by decide) hx hy inverse_source.2.2

end FT1536.Source3.KeygenPublicMontgomery
