import Source3.C99IntegerSound

namespace FT1536.Source3.C99UnarySound
open B20.C C99ValueBridge

theorem neg_fit32 (x : BitVec 32) (hx : x≠0x80000000#32) :
    -2147483648≤-x.toInt ∧ -x.toInt<2147483648 := by
  have hlo := x.le_toInt
  have hhi := x.toInt_lt
  have hn : x.toInt≠-2147483648 := by
    intro h
    apply hx
    apply BitVec.eq_of_toInt_eq
    exact h
  omega

theorem neg_fit64 (x : BitVec 64) (hx : x≠0x8000000000000000#64) :
    -9223372036854775808≤-x.toInt ∧ -x.toInt<9223372036854775808 := by
  have hlo := x.le_toInt
  have hhi := x.toInt_lt
  have hn : x.toInt≠-9223372036854775808 := by
    intro h
    apply hx
    apply BitVec.eq_of_toInt_eq
    exact h
  omega

theorem neg_sound (x z : Val) (h : B20.C.neg x=some z) :
    C99IntegerReference.NegExec (value x) (value z) := by
  rw [C99IntegerReference.neg_iff]
  cases x <;> cases z <;>
    simp_all [value,B20.C.neg,C99IntegerReference.convert,C99IntegerReference.Value.integer,
      C99IntegerReference.Value.type,C99IntegerReference.signed,C99IntegerReference.fits,
      C99IntegerReference.width,BitVec.ofInt_neg]
  case i64.i64 x z => have hf := neg_fit64 x h.1; omega
  case i32.i32 x z => have hf := neg_fit32 x h.1; omega

theorem complement_sound (x : Val) :
    C99IntegerReference.ComplementExec (value x) (value (B20.C.notBits x)) := by
  rw [C99IntegerReference.complement_iff]
  cases x <;> simp [value,B20.C.notBits,C99IntegerReference.convert,C99IntegerReference.Value.bits,
    C99IntegerReference.Value.type,C99IntegerReference.width]
  all_goals
    apply BitVec.eq_of_toNat_eq
    simp [BitVec.toNat_not,BitVec.toNat_ofNat]
    omega

end FT1536.Source3.C99UnarySound

#print axioms FT1536.Source3.C99UnarySound.neg_sound
#print axioms FT1536.Source3.C99UnarySound.complement_sound
