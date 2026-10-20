import Source3.KeygenModpR2
import Source3.KeygenFirstPrime
import Source3.KeygenGeneratorOrder
import Mathlib.GroupTheory.OrderOfElement

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option exponentiation.threshold 32768

/- The representation invariant for the M0 gm rows. Exponents refer to
   the once-squared source generator. All products consume source calls;
   inverse-table values are immaterial to this forward-table invariant. -/
namespace FT1536.Source3.KeygenMkgm3Rows
open KeygenNttWordAlgebra (R value radix)

def generator : R := value KeygenFirstPrime.generator
def root : R := generator^2
def exponent (u : Nat) : Nat := 3*u+1+u%2
def Scaled (e : Nat) (w : BitVec 32) : Prop :=
  w.toNat<KeygenNinv31.prime.toNat ∧ value w=radix*root^e

theorem generator_pow (n : Nat) :
    generator^n=((KeygenGeneratorOrder.g^n%KeygenGeneratorOrder.p : Nat) : R) := by
  change generator^n=((KeygenGeneratorOrder.g^n%2147355649 : Nat) : R)
  rw [ZMod.natCast_mod]
  rw [Nat.cast_pow]
  rfl

theorem generator_order : orderOf generator=9216 := by
  apply orderOf_eq_of_pow_and_pow_div_prime (by decide)
  · rw [generator_pow,KeygenGeneratorOrder.order_power,Nat.cast_one]
  · intro q hq hd
    have hf : q∣2^10*3^2 := by simpa only [KeygenGeneratorOrder.order_divides] using hd
    have cases23 : q=2 ∨ q=3 := by
      rcases hq.dvd_mul.mp hf with h | h
      · exact Or.inl ((Nat.prime_dvd_prime_iff_eq hq (by decide)).mp (hq.dvd_of_dvd_pow h))
      · exact Or.inr ((Nat.prime_dvd_prime_iff_eq hq (by decide)).mp (hq.dvd_of_dvd_pow h))
    rcases cases23 with rfl | rfl
    · intro h
      change (KeygenGeneratorOrder.g : R)^4608=1 at h
      rw [← Nat.cast_pow] at h
      have hc := (ZMod.natCast_eq_natCast_iff' (KeygenGeneratorOrder.g^4608) 1 2147355649).mp
        h
      rw [show 1%2147355649=1 from rfl] at hc
      exact KeygenGeneratorOrder.order_exact_half hc
    · intro h
      change (KeygenGeneratorOrder.g : R)^3072=1 at h
      rw [← Nat.cast_pow] at h
      have hc := (ZMod.natCast_eq_natCast_iff' (KeygenGeneratorOrder.g^3072) 1 2147355649).mp
        h
      rw [show 1%2147355649=1 from rfl] at hc
      exact KeygenGeneratorOrder.order_exact_third hc

theorem root_order : orderOf root=4608 := by
  rw [root,orderOf_pow' generator (by decide : 2≠0),generator_order]
  decide

theorem root_power : root^4608=1 := by
  rw [← root_order]
  exact pow_orderOf_eq_one root

theorem scaled_product (a b out p0i : BitVec 32) (e f : Nat)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (ha : Scaled e a) (hb : Scaled f b)
    (source : KeygenModpWord.SourceExec a b KeygenNinv31.prime p0i (.uint32 out)) :
    Scaled (e+f) out := by
  obtain ⟨range,law⟩ := KeygenNttWordAlgebra.source_scaled_product a b p0i out
    (root^e) (root^f) ha.1 hb.1 initialization ha.2 hb.2 source
  exact ⟨range,by simpa only [pow_add] using law⟩

theorem scaled_square (a out p0i : BitVec 32) (e : Nat)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (ha : Scaled e a)
    (source : KeygenModpWord.SourceExec a a KeygenNinv31.prime p0i (.uint32 out)) :
    Scaled (2*e) out := by
  simpa only [two_mul] using scaled_product a a out p0i e e initialization ha ha source

theorem scaled_cube (a square out p0i : BitVec 32) (e : Nat)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (ha : Scaled e a)
    (first : KeygenModpWord.SourceExec a a KeygenNinv31.prime p0i (.uint32 square))
    (second : KeygenModpWord.SourceExec a square KeygenNinv31.prime p0i (.uint32 out)) :
    Scaled (3*e) out := by
  have hs := scaled_square a square p0i e initialization ha first
  have hp := scaled_product a square out p0i e (2*e) initialization ha hs second
  convert hp using 1
  omega

theorem initialized_root (p0i r2 converted squared : BitVec 32)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (r2Call : C99ModularReference.ModCall "modp_R2".toList
      [.uint32 KeygenNinv31.prime,.uint32 p0i] (.uint32 r2))
    (conversion : KeygenModpWord.SourceExec KeygenFirstPrime.generator r2
      KeygenNinv31.prime p0i (.uint32 converted))
    (squaring : KeygenModpWord.SourceExec converted converted
      KeygenNinv31.prime p0i (.uint32 squared)) : Scaled 1 squared := by
  obtain ⟨range,law⟩ := KeygenModpR2.initialized_to_montgomery KeygenFirstPrime.generator
    r2 p0i converted (by decide) initialization r2Call conversion
  obtain ⟨range2,law2⟩ := KeygenNttWordAlgebra.source_scaled_product converted converted
    p0i squared generator generator range range initialization law law squaring
  exact ⟨range2,by simpa only [root,pow_one,pow_two] using law2⟩

theorem exponent_even (j : Nat) : exponent (2*j)=6*j+1 := by
  simp only [exponent,Nat.mul_mod_right,Nat.add_zero]
  omega

theorem exponent_odd (j : Nat) : exponent (2*j+1)=6*j+5 := by
  have h : (2*j+1)%2=1 := by omega
  rw [exponent,h]
  omega

theorem last_pair (x g2 g4 odd next p0i : BitVec 32) (j : Nat)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (hx : Scaled (exponent (2*j)) x) (h2 : Scaled 2 g2) (h4 : Scaled 4 g4)
    (first : KeygenModpWord.SourceExec x g4 KeygenNinv31.prime p0i (.uint32 odd))
    (second : KeygenModpWord.SourceExec odd g2 KeygenNinv31.prime p0i (.uint32 next)) :
    Scaled (exponent (2*j+1)) odd ∧ Scaled (exponent (2*(j+1))) next := by
  have hodd := scaled_product x g4 odd p0i (exponent (2*j)) 4 initialization hx h4 first
  have hn := scaled_product odd g2 next p0i (exponent (2*j)+4) 2 initialization hodd h2 second
  constructor
  · convert hodd using 1
    rw [exponent_even,exponent_odd]
  · convert hn using 1
    rw [exponent_even,exponent_even]
    omega

end FT1536.Source3.KeygenMkgm3Rows
