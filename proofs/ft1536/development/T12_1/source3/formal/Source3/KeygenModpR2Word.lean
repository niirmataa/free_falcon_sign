import Source3.KeygenModpR
import Source3.KeygenNttWordAlgebra

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The word algorithm of modp_R2, with its radix explicit. The modulus need
   only be odd in the source range; primality is not needed. The source
   execution refinement is supplied separately by KeygenModpR2Exec. -/
namespace FT1536.Source3.KeygenModpR2Word

def doubled (p : BitVec 32) : BitVec 32 :=
  KeygenModpAddSub.result .add (KeygenModpR.word p) (KeygenModpR.word p) p

def squares (p p0i : BitVec 32) : Nat → BitVec 32
  | 0 => doubled p
  | n+1 => KeygenModpWord.montgomery (squares p p0i n) (squares p p0i n) p p0i

def halve (z p : BitVec 32) : BitVec 32 := (z+(p &&& -(z &&& 1#32))) >>> 1
def word (p p0i : BitVec 32) : BitVec 32 := halve (squares p p0i 5) p
def value (p z : BitVec 32) : ZMod p.toNat := z.toNat
def radix (p : BitVec 32) : ZMod p.toNat := (2^31 : Nat)

theorem low_bit (z : BitVec 32) : (z &&& 1#32).toNat=z.toNat%2 := by
  rw [BitVec.toNat_and]
  change (z.toNat &&& (2^1-1))=z.toNat%2
  rw [Nat.and_two_pow_sub_one_eq_mod]

theorem halve_toNat (z p : BitVec 32) (hp : p.toNat<2^31) (hz : z.toNat<p.toNat) :
    (halve z p).toNat=(z.toNat+(if z.toNat%2=0 then 0 else p.toNat))/2 := by
  by_cases even : z.toNat%2=0
  · have bit : z &&& 1#32=0#32 := BitVec.eq_of_toNat_eq (by rw [low_bit,even]; rfl)
    simp [halve,bit,even,BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow]
  · have bit : z &&& 1#32=1#32 := BitVec.eq_of_toNat_eq (by
      rw [low_bit]
      change z.toNat%2=1
      omega)
    have mask : -(1#32)=BitVec.allOnes 32 := by decide
    have fit : z.toNat+p.toNat<2^32 := by omega
    simp only [halve,bit,mask,BitVec.and_allOnes,BitVec.toNat_ushiftRight,
      Nat.shiftRight_eq_div_pow,BitVec.toNat_add,Nat.mod_eq_of_lt fit,even,ite_false]

theorem halve_contract (z p : BitVec 32) (hp : p.toNat<2^31)
    (odd : p.toNat%2=1) (hz : z.toNat<p.toNat) :
    (halve z p).toNat<p.toNat ∧ value p (halve z p)*2=value p z := by
  have hn := halve_toNat z p hp hz
  have exact_double : (halve z p).toNat*2=z.toNat+(if z.toNat%2=0 then 0 else p.toNat) := by
    rw [hn]
    split_ifs <;> omega
  refine ⟨by rw [hn]; split_ifs <;> omega,?_⟩
  have he := congrArg (fun n : Nat => (n : ZMod p.toNat)) exact_double
  simpa only [value,Nat.cast_mul,Nat.cast_ofNat,Nat.cast_add,Nat.cast_ite,
    Nat.cast_zero,ZMod.natCast_self,ite_self,add_zero] using he

theorem radix_inverse (p : BitVec 32) (odd : p.toNat%2=1) :
    radix p*(radix p)⁻¹=1 := by
  exact ZMod.coe_mul_inv_eq_one (2^31)
    ((Nat.coprime_two_left.mpr (Nat.odd_iff.mpr odd)).pow_left 31)

theorem doubled_contract (p : BitVec 32) (lower : 2^30<p.toNat) (upper : p.toNat<2^31) :
    (doubled p).toNat<p.toNat ∧ value p (doubled p)=radix p*2 := by
  have hr : (KeygenModpR.word p).toNat<p.toNat := by
    rw [KeygenModpR.word_toNat p upper]; omega
  have hv : value p (KeygenModpR.word p)=radix p := by
    unfold value radix
    rw [KeygenModpR.value_law p lower upper,ZMod.natCast_mod]
  have hc := KeygenNttWordAlgebra.add_congruence (KeygenModpR.word p) (KeygenModpR.word p) p upper hr hr
  have he := (ZMod.natCast_eq_natCast_iff' _ _ p.toNat).mpr hc
  have sum : value p (doubled p)=value p (KeygenModpR.word p)+value p (KeygenModpR.word p) := by
    simpa only [value,doubled,Nat.cast_add] using he
  refine ⟨KeygenModpAddSub.add_range _ _ p upper hr hr,?_⟩
  rw [sum,hv]
  ring

theorem square_scaled (z p p0i : BitVec 32) (x : ZMod p.toNat)
    (positive : 0<p.toNat) (upper : p.toNat<2^31) (odd : p.toNat%2=1)
    (inverse : 2^31∣p.toNat*p0i.toNat+1) (hz : z.toNat<p.toNat)
    (scaled : value p z=radix p*x) :
    (KeygenModpWord.montgomery z z p p0i).toNat<p.toNat ∧
      value p (KeygenModpWord.montgomery z z p p0i)=radix p*(x*x) := by
  have hn := KeygenMontgomery.word_to_arithmetic z z p p0i positive upper hz hz
  have hc := MontgomeryArithmetic.reduction_contract z.toNat z.toNat p.toNat p0i.toNat
    (2^31) positive upper hz hz inverse
  rw [← hn] at hc
  have he : value p (KeygenModpWord.montgomery z z p p0i)*radix p=value p z*value p z := by
    simpa only [value,radix,Nat.cast_mul] using
      (ZMod.natCast_eq_natCast_iff' _ _ p.toNat).mpr hc.2
  refine ⟨hc.1,?_⟩
  calc
    _ = (value p (KeygenModpWord.montgomery z z p p0i)*radix p)*(radix p)⁻¹ := by
      rw [mul_assoc,radix_inverse p odd,mul_one]
    _ = ((radix p*x)*(radix p*x))*(radix p)⁻¹ := by rw [he,scaled]
    _ = (radix p*(x*x))*(radix p*(radix p)⁻¹) := by ring
    _ = radix p*(x*x) := by rw [radix_inverse p odd,mul_one]

theorem squares_contract (p p0i : BitVec 32) (lower : 2^30<p.toNat)
    (upper : p.toNat<2^31) (odd : p.toNat%2=1)
    (inverse : 2^31∣p.toNat*p0i.toNat+1) (n : Nat) :
    (squares p p0i n).toNat<p.toNat ∧
      value p (squares p p0i n)=radix p*(2 : ZMod p.toNat)^(2^n) := by
  induction n with
  | zero => simpa only [squares,pow_zero,pow_one] using doubled_contract p lower upper
  | succ n ih =>
      have step := square_scaled (squares p p0i n) p p0i _ (by omega) upper odd inverse ih.1 ih.2
      simpa only [squares,Nat.pow_succ,pow_mul,pow_two] using step

theorem word_contract (p p0i : BitVec 32) (lower : 2^30<p.toNat)
    (upper : p.toNat<2^31) (odd : p.toNat%2=1)
    (inverse : 2^31∣p.toNat*p0i.toNat+1) :
    (word p p0i).toNat<p.toNat ∧ value p (word p p0i)=radix p*radix p := by
  obtain ⟨hr,he⟩ := squares_contract p p0i lower upper odd inverse 5
  obtain ⟨range,half⟩ := halve_contract (squares p p0i 5) p upper odd hr
  have square_value : value p (squares p p0i 5)=(2 : ZMod p.toNat)^63 := by
    rw [he]
    simp only [radix,Nat.cast_pow,Nat.cast_ofNat]
    change (2 : ZMod p.toNat)^31*2^32=2^63
    rw [← pow_add]
  have inv2 : (2 : ZMod p.toNat)*2⁻¹=1 :=
    ZMod.coe_mul_inv_eq_one 2 (Nat.coprime_two_left.mpr (Nat.odd_iff.mpr odd))
  have final : value p (word p p0i)=(2 : ZMod p.toNat)^62 := by
    calc
      _ = (value p (word p p0i)*2)*2⁻¹ := by rw [mul_assoc,inv2,mul_one]
      _ = (2 : ZMod p.toNat)^63*2⁻¹ := by rw [word,half,square_value]
      _ = (2 : ZMod p.toNat)^62 := by
        rw [show (63 : Nat)=62+1 by decide,pow_succ,mul_assoc,inv2,mul_one]
  refine ⟨range,?_⟩
  rw [final]
  simp only [radix,Nat.cast_pow,Nat.cast_ofNat,← pow_add]

theorem value_law (p p0i : BitVec 32) (lower : 2^30<p.toNat)
    (upper : p.toNat<2^31) (odd : p.toNat%2=1)
    (inverse : 2^31∣p.toNat*p0i.toNat+1) : (word p p0i).toNat=2^62%p.toNat := by
  obtain ⟨range,he⟩ := word_contract p p0i lower upper odd inverse
  have cast_eq : ((word p p0i).toNat : ZMod p.toNat)=((2^62 : Nat) : ZMod p.toNat) := by
    change value p (word p p0i)=_
    rw [he]
    simp only [radix,Nat.cast_pow,Nat.cast_ofNat,← pow_add]
  have hc := (ZMod.natCast_eq_natCast_iff' _ _ p.toNat).mp cast_eq
  rwa [Nat.mod_eq_of_lt range] at hc

end FT1536.Source3.KeygenModpR2Word
