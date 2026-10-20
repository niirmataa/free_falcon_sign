import Source3.KeygenPublicTripleProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicTripleExpr
open C99ArrayReference (State)
open KeygenPublicAlgebra (R radix value)
open KeygenPublicValueExpr (Evaluates meaning)
open KeygenPublicRangeExpr (word word_argument word_range)

theorem square_scaled (s : State) (e : KeygenWordExpr.Expr) (x : R)
    (input : Evaluates s e (radix*x)) :
    Evaluates s (KeygenPublicTripleProgram.square e) (radix*x^2) := by
  intro v source
  cases source with
  | call3 _ _ _ _ av qv iv _ first second third called =>
      obtain ⟨ar,ae⟩ := input av first
      have qm := KeygenPublicTableAtoms.literal_argument [] s 18433 qv second
      have im := KeygenPublicTableAtoms.literal_argument [] s 18431 iv third
      have eq := KeygenPublicSquare.source_square_arguments (word av) av qv iv v
        (word_argument av ar) qm im (KeygenPublicRangeExpr.square_call _ _ called)
      rw [eq]
      have contract := KeygenPublicMontgomery.word_contract (word av) (word av) (word_range av ar) (word_range av ar)
      have field := (ZMod.natCast_eq_natCast_iff' _ _ 18433).mpr contract.2
      have law : value (KeygenPublicLeafWords.montgomery (word av) (word av)
          KeygenPublicMontgomery.modulus KeygenPublicMontgomery.inverse)*radix=value (word av)^2 := by
        simpa only [value,radix,KeygenPublicMontgomery.radix,Nat.cast_mul,pow_two] using field
      rw [KeygenPublicValueExpr.word_meaning av ar,ae] at law
      refine ⟨KeygenPublicRangeExpr.uint32_range _ contract.1,?_⟩
      change value _=radix*x^2
      calc
        value _=(value _*radix)*radix⁻¹ := by rw [mul_assoc,KeygenPublicAlgebra.radix_inverse,mul_one]
        _=(radix*x)^2*radix⁻¹ := by rw [law]
        _=(radix*x^2)*(radix*radix⁻¹) := by ring
        _=radix*x^2 := by rw [KeygenPublicAlgebra.radix_inverse,mul_one]

theorem index_value (s : State) (u k : Nat) (hu : u<1536) (hk : k<3) (v : C99IntegerReference.Value)
    (slot : KeygenNttLoopSupport.USlot s "u" u)
    (source : KeygenPublicWord.scalar s (KeygenPublicTripleProgram.index k) v) : v.integer.toNat=u+k := by
  cases source with
  | arithmetic _ _ _ av bv _ first second operation =>
      have ae := KeygenPublicTableIndex.variable64 s "u" u av slot first
      have be := KeygenPublicTableIndex.literal s k bv second
      subst av; subst bv
      rw [KeygenPublicTableIndex.plus_literal u k (by omega) (by omega) v operation]
      exact KeygenNttLoopSupport.u64_toNat (u+k) (by omega)

end FT1536.Source3.KeygenPublicTripleExpr
