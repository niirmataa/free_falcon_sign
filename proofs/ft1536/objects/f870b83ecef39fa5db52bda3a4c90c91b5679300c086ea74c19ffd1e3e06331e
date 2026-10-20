import Source3.KeygenPublicMontgomery
import Mathlib.Algebra.Field.ZMod
import Mathlib.Tactic.NormNum.Prime

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Scalar field contracts consume the SAME fixed mq Call relation already
   used by KeygenPublicWord. Neither an arithmetic oracle nor a transform
   fact from the solver/B3 is an input. -/
namespace FT1536.Source3.KeygenPublicAlgebra
open C99IntegerReference (Value)
open KeygenPublicScalar (Kind name Body Call)
open KeygenPublicMontgomery (modulus inverse)

abbrev R := ZMod 18433
instance modulusPrime : Fact (Nat.Prime 18433) := ⟨by norm_num⟩
def value (w : BitVec 32) : R := w.toNat
def radix : R := (2^16 : Nat)
def Canonical (w : BitVec 32) : Prop := w.toNat<18433

theorem name_injective : Function.Injective name := by
  intro a b h
  cases a <;> cases b <;> simp_all [name]

theorem leaf_body (kind : Kind) (args : List Value) (v : Value)
    (source : KeygenPublicScalar.Leaf (name kind) args v) : Body (fun _ _ _ => False) kind args v := by
  generalize hn : name kind=n at source
  cases source with
  | run actual _ _ leaf execution =>
      have equal := name_injective hn
      subst actual
      exact execution

theorem call_leaf (kind : Kind) (supported : KeygenPublicLeafWords.Supported kind)
    (args : List Value) (v : Value) (source : Call (name kind) args v) :
    Body (fun _ _ _ => False) kind args v := by
  generalize hn : name kind=n at source
  cases source with
  | square _ _ _ square =>
      cases square with
      | leaf _ _ _ leaf =>
          apply leaf_body kind args v
          rw [hn]
          exact leaf
      | square _ _ execution =>
          cases kind <;> simp_all [name,KeygenPublicLeafWords.Supported]
  | binary _ _ execution => cases kind <;> simp_all [name,KeygenPublicLeafWords.Supported]
  | ternary _ _ execution => cases kind <;> simp_all [name,KeygenPublicLeafWords.Supported]

theorem radix_inverse : radix*radix⁻¹=1 :=
  ZMod.coe_mul_inv_eq_one (2^16) (by decide : Nat.Coprime (2^16) 18433)
theorem radix_word : value (10237#32)=radix := by decide
theorem radix_squared_word : value (4564#32)=radix^2 := by decide

theorem source_add (x y out : BitVec 32) (hx : Canonical x) (hy : Canonical y)
    (source : Call (name .add) [.uint32 x,.uint32 y,.uint32 modulus] (.uint32 out)) :
    Canonical out ∧ value out=value x+value y := by
  have he := KeygenPublicLeafWords.source_add _ x y modulus (.uint32 out) (call_leaf .add (by decide) _ _ source)
  have equal := Value.uint32.inj he
  subst out
  refine ⟨KeygenModpAddSub.add_range x y modulus (by decide) hx hy,?_⟩
  have hc := KeygenNttWordAlgebra.add_congruence x y modulus (by decide) hx hy
  have hf := (ZMod.natCast_eq_natCast_iff' _ _ 18433).mpr hc
  simpa only [value,Nat.cast_add] using hf

theorem source_sub (x y out : BitVec 32) (hx : Canonical x) (hy : Canonical y)
    (source : Call (name .sub) [.uint32 x,.uint32 y,.uint32 modulus] (.uint32 out)) :
    Canonical out ∧ value out=value x-value y := by
  have he := KeygenPublicLeafWords.source_sub _ x y modulus (.uint32 out) (call_leaf .sub (by decide) _ _ source)
  have equal := Value.uint32.inj he
  subst out
  refine ⟨KeygenModpAddSub.sub_range x y modulus (by decide) hx hy,?_⟩
  have hc := KeygenModpAddSub.sub_congruence x y modulus (by decide) hx hy
  have hf := (ZMod.natCast_eq_natCast_iff' _ _ 18433).mpr hc
  have sum : value (KeygenModpAddSub.result .sub x y modulus)+value y=value x := by
    simpa only [value,Nat.cast_add] using hf
  exact eq_sub_of_add_eq sum

theorem source_mul (x y out : BitVec 32) (hx : Canonical x) (hy : Canonical y)
    (source : Call (name .mul) [.uint32 x,.uint32 y,.uint32 modulus,.uint32 inverse] (.uint32 out)) :
    Canonical out ∧ value out*radix=value x*value y := by
  have he := KeygenPublicLeafWords.source_mul _ x y modulus inverse (.uint32 out)
    (call_leaf .mul (by decide) _ _ source)
  have equal := Value.uint32.inj he
  subst out
  have contract := KeygenPublicMontgomery.word_contract x y hx hy
  refine ⟨contract.1,?_⟩
  have hf := (ZMod.natCast_eq_natCast_iff' _ _ 18433).mpr contract.2
  simpa only [value,radix,KeygenPublicMontgomery.radix,Nat.cast_mul] using hf

theorem source_twiddle (x scaled out : BitVec 32) (twiddle : R)
    (hx : Canonical x) (hs : Canonical scaled) (tableWord : value scaled=radix*twiddle)
    (source : Call (name .mul) [.uint32 x,.uint32 scaled,.uint32 modulus,.uint32 inverse] (.uint32 out)) :
    Canonical out ∧ value out=value x*twiddle := by
  obtain ⟨range,equation⟩ := source_mul x scaled out hx hs source
  refine ⟨range,?_⟩
  calc
    value out = (value out*radix)*radix⁻¹ := by rw [mul_assoc,radix_inverse,mul_one]
    _ = (value x*(radix*twiddle))*radix⁻¹ := by rw [equation,tableWord]
    _ = (value x*twiddle)*(radix*radix⁻¹) := by ring
    _ = value x*twiddle := by rw [radix_inverse,mul_one]

theorem source_scaled_product (x y out : BitVec 32) (a b : R)
    (hx : Canonical x) (hy : Canonical y) (left : value x=radix*a) (right : value y=radix*b)
    (source : Call (name .mul) [.uint32 x,.uint32 y,.uint32 modulus,.uint32 inverse] (.uint32 out)) :
    Canonical out ∧ value out=radix*(a*b) := by
  obtain ⟨range,equation⟩ := source_twiddle x y out b hx hy right source
  rw [left,mul_assoc] at equation
  exact ⟨range,equation⟩

theorem source_conv (x out : BitVec 32) (lower : -(18433 : Int)<x.toInt) (upper : x.toInt<18433)
    (source : Call (name .conv) [.int32 x,.uint32 modulus] (.uint32 out)) :
    Canonical out ∧ value out=(x.toInt : R) := by
  have he := KeygenPublicLeafWords.source_conv _ x modulus (.uint32 out) (call_leaf .conv (by decide) _ _ source)
  have equal := Value.uint32.inj he
  subst out
  refine ⟨KeygenModpSet.range x modulus (by decide) lower upper,?_⟩
  have hc := KeygenModpSet.congruence x modulus (by decide) lower upper
  have hf := (ZMod.intCast_eq_intCast_iff _ _ 18433).mpr hc
  simpa only [value,Int.cast_natCast] using hf

def halfNumerator (x : BitVec 32) : Nat := x.toNat+if x.toNat%2=0 then 0 else 18433
theorem half_exact (x : BitVec 32) (hx : Canonical x) :
    (KeygenPublicLeafWords.half x modulus).toNat=halfNumerator x/2 := by
  have low : (x &&& 1#32).toNat=x.toNat%2 := by
    rw [BitVec.toNat_and]
    change (x.toNat &&& (2^1-1))=_
    rw [Nat.and_two_pow_sub_one_eq_mod]
  by_cases even : x.toNat%2=0
  · have mask : x &&& 1#32=0#32 := BitVec.eq_of_toNat_eq (low.trans even)
    simp only [KeygenPublicLeafWords.half,mask,BitVec.neg_zero,BitVec.and_zero,BitVec.add_zero,
      BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow,halfNumerator,even,ite_true,Nat.add_zero]
  · have mask : x &&& 1#32=1#32 := by
      apply BitVec.eq_of_toNat_eq
      rw [low]
      change x.toNat%2=1
      omega
    have negative : -(1#32)=BitVec.allOnes 32 := by decide
    simp only [KeygenPublicLeafWords.half,mask,negative,BitVec.and_allOnes,
      BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow,BitVec.toNat_add,
      halfNumerator,even,ite_false]
    rw [Nat.mod_eq_of_lt (show x.toNat+modulus.toNat<2^32 from by
      change x.toNat+18433<4294967296
      unfold Canonical at hx
      omega)]
    rfl

theorem half_contract (x : BitVec 32) (hx : Canonical x) :
    Canonical (KeygenPublicLeafWords.half x modulus) ∧
      value (KeygenPublicLeafWords.half x modulus)*2=value x := by
  have exactValue := half_exact x hx
  have even : halfNumerator x%2=0 := by unfold halfNumerator; split_ifs <;> omega
  have twice : halfNumerator x/2*2=halfNumerator x := Nat.div_mul_cancel (Nat.dvd_of_mod_eq_zero even)
  refine ⟨?_,?_⟩
  · unfold Canonical
    rw [exactValue]
    unfold halfNumerator Canonical at *
    split_ifs <;> omega
  · have hf := congrArg (fun n : Nat => (n : R)) twice
    rw [Nat.cast_mul] at hf
    change ((halfNumerator x/2 : Nat) : R)*2=(halfNumerator x : R) at hf
    rw [value,exactValue,hf]
    unfold halfNumerator
    split_ifs <;> simp [value,show (18433 : R)=0 from by decide]

theorem source_half (x out : BitVec 32) (hx : Canonical x)
    (source : Call (name .half) [.uint32 x,.uint32 modulus] (.uint32 out)) :
    Canonical out ∧ value out*2=value x := by
  have he := KeygenPublicLeafWords.source_half _ x modulus (.uint32 out) (call_leaf .half (by decide) _ _ source)
  have equal := Value.uint32.inj he
  subst out
  exact half_contract x hx

end FT1536.Source3.KeygenPublicAlgebra
