import Source3.C99ValueBridge

namespace FT1536.Source3.C99UnaryBridge
open B20.C C99ValueBridge

theorem negate_u64 (x : BitVec 64) :
    BitVec.ofInt 64 (-(x.toNat : Int))=-x := by simp [BitVec.ofInt_neg]
theorem negate_u32 (x : BitVec 32) :
    BitVec.ofInt 32 (-(x.toNat : Int))=-x := by simp [BitVec.ofInt_neg]

theorem neg_source_to_interpreter (x z : Val)
    (hs : C99IntegerReference.NegExec (value x) (value z)) :
    B20.C.neg x=some z := by
  rw [C99IntegerReference.neg_iff] at hs
  cases x <;> cases z <;>
    simp_all [value,B20.C.neg,C99IntegerReference.convert,C99IntegerReference.Value.integer,
      C99IntegerReference.Value.type,C99IntegerReference.signed,C99IntegerReference.fits,
      C99IntegerReference.width,BitVec.ofInt_neg]
  all_goals intro heq; subst_vars; simp_all

theorem complement_source_to_interpreter (x z : Val)
    (hs : C99IntegerReference.ComplementExec (value x) (value z)) :
    B20.C.notBits x=z := by
  rw [C99IntegerReference.complement_iff] at hs
  cases x <;> cases z <;>
    simp_all [value,B20.C.notBits,C99IntegerReference.convert,C99IntegerReference.Value.bits,
      C99IntegerReference.Value.type,C99IntegerReference.width]
  all_goals apply BitVec.eq_of_toNat_eq <;> simp [BitVec.toNat_not,BitVec.toNat_ofNat]
  all_goals omega

end FT1536.Source3.C99UnaryBridge

#print axioms FT1536.Source3.C99UnaryBridge.neg_source_to_interpreter
#print axioms FT1536.Source3.C99UnaryBridge.complement_source_to_interpreter
