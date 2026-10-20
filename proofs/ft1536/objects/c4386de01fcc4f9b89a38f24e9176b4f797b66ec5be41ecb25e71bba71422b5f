import Source3.KeygenFinalCheckAlgebra
import Mathlib.Data.ZMod.Basic

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Source-derived word operations in the NTT residue ring. The radix factor
   is explicit: ordinary coefficients and Montgomery table words are not
   interchangeable representations. No NTT correctness is assumed here. -/
namespace FT1536.Source3.KeygenNttWordAlgebra

abbrev R := ZMod 2147355649
def value (w : BitVec 32) : R := w.toNat
def radix : R := (2^31 : Nat)

theorem radix_inverse : radix*radix⁻¹=1 :=
  ZMod.coe_mul_inv_eq_one (2^31) (by decide : Nat.Coprime (2^31) 2147355649)

theorem add_congruence (a b p : BitVec 32) (hp : p.toNat<2^31)
    (ha : a.toNat<p.toNat) (hb : b.toNat<p.toNat) :
    (KeygenModpAddSub.result .add a b p).toNat%p.toNat=(a.toNat+b.toNat)%p.toNat := by
  rw [KeygenModpAddSub.add_exact a b p hp ha hb]
  unfold MontgomeryArithmetic.reduce
  split
  · rfl
  · exact (Nat.mod_eq_sub_mod (by omega : p.toNat≤a.toNat+b.toNat)).symm

theorem source_add (a b out : BitVec 32)
    (ha : a.toNat<KeygenNinv31.prime.toNat) (hb : b.toNat<KeygenNinv31.prime.toNat)
    (source : KeygenModpAddSub.SourceExec .add a b KeygenNinv31.prime (.uint32 out)) :
    out.toNat<KeygenNinv31.prime.toNat ∧ value out=value a+value b := by
  have he : out=KeygenModpAddSub.result .add a b KeygenNinv31.prime :=
    C99IntegerReference.Value.uint32.inj (KeygenModpAddSub.source_exact .add a b KeygenNinv31.prime _ source)
  subst out
  refine ⟨KeygenModpAddSub.add_range a b KeygenNinv31.prime (by decide) ha hb,?_⟩
  have hc := add_congruence a b KeygenNinv31.prime (by decide) ha hb
  have hf := (ZMod.natCast_eq_natCast_iff' _ _ 2147355649).mpr hc
  simpa only [value,Nat.cast_add] using hf

theorem source_sub (a b out : BitVec 32)
    (ha : a.toNat<KeygenNinv31.prime.toNat) (hb : b.toNat<KeygenNinv31.prime.toNat)
    (source : KeygenModpAddSub.SourceExec .sub a b KeygenNinv31.prime (.uint32 out)) :
    out.toNat<KeygenNinv31.prime.toNat ∧ value out=value a-value b := by
  have he : out=KeygenModpAddSub.result .sub a b KeygenNinv31.prime :=
    C99IntegerReference.Value.uint32.inj (KeygenModpAddSub.source_exact .sub a b KeygenNinv31.prime _ source)
  subst out
  refine ⟨KeygenModpAddSub.sub_range a b KeygenNinv31.prime (by decide) ha hb,?_⟩
  have hc := KeygenModpAddSub.sub_congruence a b KeygenNinv31.prime (by decide) ha hb
  have hf := (ZMod.natCast_eq_natCast_iff' _ _ 2147355649).mpr hc
  have sum : value (KeygenModpAddSub.result .sub a b KeygenNinv31.prime)+value b=value a := by
    simpa only [value,Nat.cast_add] using hf
  exact eq_sub_of_add_eq sum

theorem source_montgomery (a b p0i out : BitVec 32)
    (ha : a.toNat<KeygenNinv31.prime.toNat) (hb : b.toNat<KeygenNinv31.prime.toNat)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : KeygenModpWord.SourceExec a b KeygenNinv31.prime p0i (.uint32 out)) :
    out.toNat<KeygenNinv31.prime.toNat ∧ value out*radix=value a*value b := by
  obtain ⟨actual,he,range,congruence⟩ := KeygenNinv31.initialized_montgomery_contract a b p0i (.uint32 out)
    ha hb initialization source
  have equal : out=actual := C99IntegerReference.Value.uint32.inj he
  subst actual
  have hf := (ZMod.natCast_eq_natCast_iff' _ _ 2147355649).mpr congruence
  refine ⟨range,?_⟩
  simpa only [value,radix,Nat.cast_mul] using hf

theorem source_twiddle (a scaled p0i out : BitVec 32) (twiddle : R)
    (ha : a.toNat<KeygenNinv31.prime.toNat) (hs : scaled.toNat<KeygenNinv31.prime.toNat)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (tableWord : value scaled=radix*twiddle)
    (source : KeygenModpWord.SourceExec a scaled KeygenNinv31.prime p0i (.uint32 out)) :
    out.toNat<KeygenNinv31.prime.toNat ∧ value out=value a*twiddle := by
  obtain ⟨range,equation⟩ := source_montgomery a scaled p0i out ha hs initialization source
  refine ⟨range,?_⟩
  calc
    value out = (value out*radix)*radix⁻¹ := by rw [mul_assoc,radix_inverse,mul_one]
    _ = (value a*(radix*twiddle))*radix⁻¹ := by rw [equation,tableWord]
    _ = (value a*twiddle)*(radix*radix⁻¹) := by ring
    _ = value a*twiddle := by rw [radix_inverse,mul_one]

theorem source_scaled_product (a b p0i out : BitVec 32) (x y : R)
    (ha : a.toNat<KeygenNinv31.prime.toNat) (hb : b.toNat<KeygenNinv31.prime.toNat)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (leftWord : value a=radix*x) (rightWord : value b=radix*y)
    (source : KeygenModpWord.SourceExec a b KeygenNinv31.prime p0i (.uint32 out)) :
    out.toNat<KeygenNinv31.prime.toNat ∧ value out=radix*(x*y) := by
  obtain ⟨range,equation⟩ := source_twiddle a b p0i out y ha hb initialization rightWord source
  rw [leftWord,mul_assoc] at equation
  exact ⟨range,equation⟩

end FT1536.Source3.KeygenNttWordAlgebra
