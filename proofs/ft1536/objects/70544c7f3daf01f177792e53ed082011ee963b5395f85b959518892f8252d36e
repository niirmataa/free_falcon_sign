import Source3.KeygenPublicDivisionWords
import Mathlib.FieldTheory.Finite.Basic

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicDivisionAlgebra
open C99IntegerReference (Value)
open KeygenPublicAlgebra (R value radix Canonical)
open KeygenPublicMontgomery (modulus inverse)

def multiply (x y : BitVec 32) : BitVec 32 := KeygenPublicLeafWords.montgomery x y modulus inverse
def Scaled (w : BitVec 32) (z : R) : Prop := Canonical w ∧ value w=radix*z
theorem multiply_value (x y : BitVec 32) (hx : Canonical x) (hy : Canonical y) :
    Canonical (multiply x y) ∧ value (multiply x y)=value x*value y*radix⁻¹ := by
  have contract := KeygenPublicMontgomery.word_contract x y hx hy
  have hf := (ZMod.natCast_eq_natCast_iff' _ _ 18433).mpr contract.2
  have equation : value (multiply x y)*radix=value x*value y := by
    simpa only [multiply,value,radix,KeygenPublicMontgomery.radix,Nat.cast_mul] using hf
  refine ⟨contract.1,?_⟩
  calc
    value (multiply x y) = (value (multiply x y)*radix)*radix⁻¹ := by
      rw [mul_assoc,KeygenPublicAlgebra.radix_inverse,mul_one]
    _ = value x*value y*radix⁻¹ := by rw [equation]
theorem scaled_product (x y : BitVec 32) (a b : R) (hx : Scaled x a) (hy : Scaled y b) :
    Scaled (multiply x y) (a*b) := by
  obtain ⟨range,equation⟩ := multiply_value x y hx.1 hy.1
  refine ⟨range,?_⟩
  rw [equation,hx.2,hy.2]
  calc
    radix*a*(radix*b)*radix⁻¹ = radix*(a*b)*(radix*radix⁻¹) := by ring
    _ = radix*(a*b) := by rw [KeygenPublicAlgebra.radix_inverse,mul_one]
theorem scaled_square (x : BitVec 32) (a : R) (hx : Scaled x a) : Scaled (multiply x x) (a^2) := by
  simpa only [pow_two] using scaled_product x x a a hx hx
theorem conversion (y : BitVec 32) (hy : Canonical y) : Scaled (multiply y (4564#32)) (value y) := by
  obtain ⟨range,equation⟩ := multiply_value y (4564#32) hy (by change 4564<18433; decide)
  refine ⟨range,?_⟩
  rw [equation,KeygenPublicAlgebra.radix_squared_word]
  calc
    value y*radix^2*radix⁻¹ = (radix*value y)*(radix*radix⁻¹) := by ring
    _ = radix*value y := by rw [KeygenPublicAlgebra.radix_inverse,mul_one]

/- Named source-chain nodes keep proofs and printed terms small. -/
def w0 (y : BitVec 32) := multiply y (4564#32)
def w1 (y : BitVec 32) := multiply (w0 y) (w0 y)
def w2 (y : BitVec 32) := multiply (w1 y) (w0 y)
def w3 (y : BitVec 32) := multiply (w2 y) (w2 y)
def w4 (y : BitVec 32) := multiply (w3 y) (w0 y)
def w5 (y : BitVec 32) := multiply (w4 y) (w4 y)
def w6 (y : BitVec 32) := multiply (w5 y) (w5 y)
def w7 (y : BitVec 32) := multiply (w6 y) (w4 y)
def w8 (y : BitVec 32) := multiply (w7 y) (w6 y)
def w9 (y : BitVec 32) := multiply (w8 y) (w8 y)
def w10 (y : BitVec 32) := multiply (w9 y) (w9 y)
def w11 (y : BitVec 32) := multiply (w10 y) (w7 y)
def w12 (y : BitVec 32) := multiply (w11 y) (w11 y)
def w13 (y : BitVec 32) := multiply (w12 y) (w12 y)
def w14 (y : BitVec 32) := multiply (w13 y) (w13 y)
def w15 (y : BitVec 32) := multiply (w14 y) (w14 y)
def w16 (y : BitVec 32) := multiply (w15 y) (w15 y)
def w17 (y : BitVec 32) := multiply (w16 y) (w16 y)
def w18 (y : BitVec 32) := multiply (w17 y) (w8 y)
theorem scaled0 (y : BitVec 32) (hy : Canonical y) : Scaled (w0 y) (value y^1) := by
  simpa only [w0,pow_one] using conversion y hy
theorem scaled1 (y : BitVec 32) (hy : Canonical y) : Scaled (w1 y) (value y^2) := by
  simpa only [w1,← pow_mul] using scaled_square _ _ (scaled0 y hy)
theorem scaled2 (y : BitVec 32) (hy : Canonical y) : Scaled (w2 y) (value y^3) := by
  simpa only [w2,← pow_add] using scaled_product _ _ _ _ (scaled1 y hy) (scaled0 y hy)
theorem scaled3 (y : BitVec 32) (hy : Canonical y) : Scaled (w3 y) (value y^6) := by
  simpa only [w3,← pow_mul] using scaled_square _ _ (scaled2 y hy)
theorem scaled4 (y : BitVec 32) (hy : Canonical y) : Scaled (w4 y) (value y^7) := by
  simpa only [w4,← pow_add] using scaled_product _ _ _ _ (scaled3 y hy) (scaled0 y hy)
theorem scaled5 (y : BitVec 32) (hy : Canonical y) : Scaled (w5 y) (value y^14) := by
  simpa only [w5,← pow_mul] using scaled_square _ _ (scaled4 y hy)
theorem scaled6 (y : BitVec 32) (hy : Canonical y) : Scaled (w6 y) (value y^28) := by
  simpa only [w6,← pow_mul] using scaled_square _ _ (scaled5 y hy)
theorem scaled7 (y : BitVec 32) (hy : Canonical y) : Scaled (w7 y) (value y^35) := by
  simpa only [w7,← pow_add] using scaled_product _ _ _ _ (scaled6 y hy) (scaled4 y hy)
theorem scaled8 (y : BitVec 32) (hy : Canonical y) : Scaled (w8 y) (value y^63) := by
  simpa only [w8,← pow_add] using scaled_product _ _ _ _ (scaled7 y hy) (scaled6 y hy)
theorem scaled9 (y : BitVec 32) (hy : Canonical y) : Scaled (w9 y) (value y^126) := by
  simpa only [w9,← pow_mul] using scaled_square _ _ (scaled8 y hy)
theorem scaled10 (y : BitVec 32) (hy : Canonical y) : Scaled (w10 y) (value y^252) := by
  simpa only [w10,← pow_mul] using scaled_square _ _ (scaled9 y hy)
theorem scaled11 (y : BitVec 32) (hy : Canonical y) : Scaled (w11 y) (value y^287) := by
  simpa only [w11,← pow_add] using scaled_product _ _ _ _ (scaled10 y hy) (scaled7 y hy)
theorem scaled12 (y : BitVec 32) (hy : Canonical y) : Scaled (w12 y) (value y^574) := by
  simpa only [w12,← pow_mul] using scaled_square _ _ (scaled11 y hy)
theorem scaled13 (y : BitVec 32) (hy : Canonical y) : Scaled (w13 y) (value y^1148) := by
  simpa only [w13,← pow_mul] using scaled_square _ _ (scaled12 y hy)
theorem scaled14 (y : BitVec 32) (hy : Canonical y) : Scaled (w14 y) (value y^2296) := by
  simpa only [w14,← pow_mul] using scaled_square _ _ (scaled13 y hy)
theorem scaled15 (y : BitVec 32) (hy : Canonical y) : Scaled (w15 y) (value y^4592) := by
  simpa only [w15,← pow_mul] using scaled_square _ _ (scaled14 y hy)
theorem scaled16 (y : BitVec 32) (hy : Canonical y) : Scaled (w16 y) (value y^9184) := by
  simpa only [w16,← pow_mul] using scaled_square _ _ (scaled15 y hy)
theorem scaled17 (y : BitVec 32) (hy : Canonical y) : Scaled (w17 y) (value y^18368) := by
  simpa only [w17,← pow_mul] using scaled_square _ _ (scaled16 y hy)
theorem scaled18 (y : BitVec 32) (hy : Canonical y) : Scaled (w18 y) (value y^18431) := by
  simpa only [w18,← pow_add] using scaled_product _ _ _ _ (scaled17 y hy) (scaled8 y hy)

theorem source_word_formula (x y : BitVec 32) : KeygenPublicDivisionWords.division x y=multiply (w18 y) x := by rfl
theorem division_power (x y : BitVec 32) (hx : Canonical x) (hy : Canonical y) :
    Canonical (KeygenPublicDivisionWords.division x y) ∧
      value (KeygenPublicDivisionWords.division x y)=value x*value y^18431 := by
  rw [source_word_formula]
  have final := scaled18 y hy
  obtain ⟨range,equation⟩ := multiply_value (w18 y) x final.1 hx
  refine ⟨range,?_⟩
  rw [equation,final.2]
  calc
    radix*value y^18431*value x*radix⁻¹ = (value x*value y^18431)*(radix*radix⁻¹) := by ring
    _ = value x*value y^18431 := by rw [KeygenPublicAlgebra.radix_inverse,mul_one]
theorem nonzero_value (y : BitVec 32) (hy : Canonical y) (nonzero : y.toNat≠0) : value y≠0 := by
  intro zero
  have he := (ZMod.natCast_eq_natCast_iff' y.toNat 0 18433).mp zero
  rw [Nat.mod_eq_of_lt hy,Nat.zero_mod] at he
  exact nonzero he
theorem source_power (x y out : BitVec 32) (hx : Canonical x) (hy : Canonical y)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .divT) [.uint32 x,.uint32 y] (.uint32 out)) :
    Canonical out ∧ value out=value x*value y^18431 := by
  have equal := Value.uint32.inj (KeygenPublicDivisionWords.source_exact x y (.uint32 out) source)
  subst out
  exact division_power x y hx hy
theorem source_division (x y out : BitVec 32) (hx : Canonical x) (hy : Canonical y) (nonzero : y.toNat≠0)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .divT) [.uint32 x,.uint32 y] (.uint32 out)) :
    Canonical out ∧ value out*value y=value x ∧ value out=value x*(value y)⁻¹ := by
  obtain ⟨range,equation⟩ := source_power x y out hx hy source
  have nz := nonzero_value y hy nonzero
  have fermat : value y^18432=1 := ZMod.pow_card_sub_one_eq_one nz
  have product : value out*value y=value x := by
    rw [equation,mul_assoc,← pow_succ,fermat,mul_one]
  refine ⟨range,product,?_⟩
  calc
    value out = (value out*value y)*(value y)⁻¹ := by rw [mul_assoc,mul_inv_cancel₀ nz,mul_one]
    _ = value x*(value y)⁻¹ := by rw [product]

theorem normalize_call (x y : BitVec 32) (a b v : Value)
    (ax : KeygenPublicArguments.U32 a x) (by_ : KeygenPublicArguments.U32 b y)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .divT) [a,b] v) :
    KeygenPublicScalar.Call (KeygenPublicScalar.name .divT) [.uint32 x,.uint32 y] v := by
  have conversion : KeygenPublicArguments.Conversion (KeygenPublicScalar.params .divT)
      [a,b] [.uint32 x,.uint32 y] :=
    .cons _ _ _ _ _ _ _ (ax.trans (KeygenPublicArguments.u32_self x).symm)
      (.cons _ _ _ _ _ _ _ (by_.trans (KeygenPublicArguments.u32_self y).symm) .nil)
  exact .ternary _ _ (KeygenPublicArguments.body_conversion _ .divT _ _ v conversion
    (KeygenPublicDivisionWords.ternary_body _ v source))
theorem source_division_arguments (x y out : BitVec 32) (a b : Value)
    (hx : Canonical x) (hy : Canonical y) (nonzero : y.toNat≠0)
    (ax : KeygenPublicArguments.U32 a x) (by_ : KeygenPublicArguments.U32 b y)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .divT) [a,b] (.uint32 out)) :
    Canonical out ∧ value out*value y=value x ∧ value out=value x*(value y)⁻¹ :=
  source_division x y out hx hy nonzero (normalize_call x y a b (.uint32 out) ax by_ source)

end FT1536.Source3.KeygenPublicDivisionAlgebra
