import Source3.C99ValueBridge

namespace FT1536.Source3.C99ArithmeticBridge
open B20.C C99ValueBridge

theorem ofInt_sub {w : Nat} (a b : Int) :
    BitVec.ofInt w (a-b)=BitVec.ofInt w a-BitVec.ofInt w b := by
  rw [Int.sub_eq_add_neg,BitVec.ofInt_add,BitVec.ofInt_neg]
  simp [BitVec.sub_eq_add_neg]

theorem ofInt_bmod (w : Nat) (z : Int) :
    BitVec.ofInt w (z.bmod (2^w))=BitVec.ofInt w z := by
  have h := BitVec.ofInt_toInt (x:=BitVec.ofInt w z)
  simpa only [BitVec.toInt_ofInt] using h

theorem ofInt_emod (w : Nat) (z : Int) :
    BitVec.ofInt w (z % (2^w))=BitVec.ofInt w z := by
  apply BitVec.eq_of_toNat_eq
  simp [BitVec.toNat_ofInt]

theorem ofInt64_maxmod (z : Int) :
    BitVec.ofInt 64 (max (z%18446744073709551616) 0)=BitVec.ofInt 64 z := by
  have hn : 0≤z%18446744073709551616 := Int.emod_nonneg _ (by decide)
  rw [Int.max_eq_left hn]
  exact ofInt_emod 64 z

theorem ofInt64_mod (z : Int) : BitVec.ofInt 64 (z%18446744073709551616)=BitVec.ofInt 64 z :=
  ofInt_emod 64 z
theorem ofInt64_bmod (z : Int) : BitVec.ofInt 64 (z.bmod 18446744073709551616)=BitVec.ofInt 64 z :=
  ofInt_bmod 64 z

theorem add_source_to_interpreter (x y z : Val)
    (hs : C99IntegerReference.ArithmeticExec .plus (value x) (value y) (value z)) :
    B20.C.bin .add x y=some z := by
  rw [C99IntegerReference.arithmetic_iff] at hs
  simp only [type_matches,usual_matches,integer_matches,
    C99IntegerReference.exact] at hs
  cases x <;> cases y <;> cases z <;>
    simp_all [B20.C.bin,B20.C.commonTy,B20.C.cast,B20.C.Val.ty,B20.C.Val.integer,
      B20.C.signedBitsOp,B20.C.signedSafe,B20.C.bitsOp,
      C99ValueBridge.type,C99ValueBridge.value,
      C99IntegerReference.convert,C99IntegerReference.signed,
      C99IntegerReference.fits,C99IntegerReference.width,C99IntegerReference.Value.integer,
      BitVec.ofInt_add,BitVec.signExtend,ofInt64_maxmod,ofInt64_mod,ofInt64_bmod]

def operation : C99IntegerReference.Arithmetic → BinOp
  | .plus => .add
  | .minus => .sub
  | .times => .mul

theorem arithmetic_source_to_interpreter (op : C99IntegerReference.Arithmetic) (x y z : Val)
    (hs : C99IntegerReference.ArithmeticExec op (value x) (value y) (value z)) :
    B20.C.bin (operation op) x y=some z := by
  rw [C99IntegerReference.arithmetic_iff] at hs
  simp only [type_matches,usual_matches,integer_matches] at hs
  cases op <;> cases x <;> cases y <;> cases z <;>
    simp_all [operation,B20.C.bin,B20.C.commonTy,B20.C.cast,B20.C.Val.ty,B20.C.Val.integer,
      B20.C.signedBitsOp,B20.C.signedSafe,B20.C.bitsOp,
      C99ValueBridge.type,C99ValueBridge.value,
      C99IntegerReference.convert,C99IntegerReference.signed,C99IntegerReference.exact,
      C99IntegerReference.fits,C99IntegerReference.width,C99IntegerReference.Value.integer,
      BitVec.ofInt_add,ofInt_sub,BitVec.ofInt_mul,BitVec.signExtend,
      ofInt64_maxmod,ofInt64_mod,ofInt64_bmod]

end FT1536.Source3.C99ArithmeticBridge

#print axioms FT1536.Source3.C99ArithmeticBridge.add_source_to_interpreter
#print axioms FT1536.Source3.C99ArithmeticBridge.arithmetic_source_to_interpreter
