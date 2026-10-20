import Source3.C99ArithmeticBridge

namespace FT1536.Source3.C99BitwiseBridge
open B20.C C99ValueBridge C99ArithmeticBridge

def operation : C99IntegerReference.Bitwise → BinOp
  | .and => .band
  | .or => .bor
  | .xor => .xor

theorem nat_of_int_mod64 (z : Int) :
    BitVec.ofNat 64 (z%18446744073709551616).toNat=BitVec.ofInt 64 z := by
  have h := BitVec.ofNat_toNat 64 (BitVec.ofInt 64 z)
  have hp : ((2^64 : Nat) : Int)=18446744073709551616 := by decide
  simpa only [BitVec.toNat_ofInt,BitVec.setWidth_eq,hp] using h

theorem nat_mod64 (z : Nat) :
    BitVec.ofNat 64 (z%18446744073709551616)=BitVec.ofNat 64 z := by
  have h := BitVec.ofNat_toNat 64 (BitVec.ofNat 64 z)
  simpa only [BitVec.toNat_ofNat,BitVec.setWidth_eq] using h

theorem source_to_interpreter (op : C99IntegerReference.Bitwise) (x y z : Val)
    (hs : C99IntegerReference.BitwiseExec op (value x) (value y) (value z)) :
    B20.C.bin (operation op) x y=some z := by
  rw [C99IntegerReference.bitwise_iff] at hs
  simp only [type_matches,usual_matches,integer_matches] at hs
  cases op <;> cases x <;> cases y <;> cases z <;>
    simp_all [operation,B20.C.bin,B20.C.commonTy,B20.C.cast,B20.C.Val.ty,B20.C.Val.integer,
      B20.C.signedBitsOp,B20.C.signedSafe,B20.C.bitsOp,
      C99ValueBridge.type,C99ValueBridge.value,
      C99IntegerReference.convert,C99IntegerReference.bitResult,
      C99IntegerReference.Value.bits,BitVec.signExtend,nat_of_int_mod64,nat_mod64]

end FT1536.Source3.C99BitwiseBridge

#print axioms FT1536.Source3.C99BitwiseBridge.source_to_interpreter
