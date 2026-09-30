import Source3.StableBinary003Outcome
import Source3.C99CompletenessObligations

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinary003Audit
open B20.C

def shortMul (x y : BitVec 64) : Option (B20.C.Scalar.State × Option Val) :=
  FprPrimitives.execBlock 3 .u64 FprAST.mulCode.body (FprUnsignedPrefixes.initial x y)

theorem detects_insufficient_fuel (x y : BitVec 64) :
    shortMul x y=none ∧ (FprPrimitives.mul x y).isSome := by
  constructor
  · simp [shortMul,FprAST.mulCode,FprPrimitives.execBlock,FprPrimitives.execScalar,
      CLogic.step,B20.C.Scalar.declareMany,B20.C.Scalar.declareOne,
      FprUnsignedPrefixes.initial,FprUnsignedPrefixes.xyTypes,UnsignedState.setType]
  · exact FprMulTotal.mul_total x y

def filteredMul (x y : BitVec 64) : Option (BitVec 64) :=
  if x=0#64 then none else FprPrimitives.mul x y

theorem detects_additional_none_filter (y : BitVec 64) :
    filteredMul 0#64 y=none ∧ (FprPrimitives.mul 0#64 y).isSome :=
  ⟨by simp [filteredMul],FprMulTotal.mul_total 0#64 y⟩

theorem signed_overflow_still_undefined :
    B20.C.bin .add (.i32 0x7fffffff#32) (.i32 1#32)=none := by decide

theorem reference_signed_overflow_no_execution :
    ¬∃ z, C99IntegerReference.ArithmeticExec .plus (.int32 0x7fffffff#32) (.int32 1#32) z := by
  simp [C99IntegerReference.arithmetic_iff,C99IntegerReference.usual,C99IntegerReference.promote,
    C99IntegerReference.Value.type,C99IntegerReference.Value.integer,C99IntegerReference.convert,
    C99IntegerReference.signed,C99IntegerReference.width,C99IntegerReference.fits,C99IntegerReference.exact]

theorem detects_unsigned_cast_mutation :
    C99IntegerReference.convert .uint64 (-1)=.uint64 0xffffffffffffffff#64 ∧
    C99IntegerReference.convert .uint64 (-1)≠.uint64 0x00000000ffffffff#64 := by decide

theorem negative_right_reference :
    C99IntegerReference.ShiftExec .right (.int32 0xffffffff#32) (.int32 1#32) (.int32 0xffffffff#32) := by
  exact C99IntegerReference.ShiftExec.right _ _ 1 (by decide) (by decide)

theorem detects_logical_for_signed_shift :
    B20.C.bin .shr (.i32 0xffffffff#32) (.i32 1#32)=some (.i32 0xffffffff#32) ∧
    (0xffffffff#32 >>> 1)≠0xffffffff#32 := by decide

end FT1536.Source3.StableBinary003Audit

#check @FT1536.Source3.StableBinary003Audit.detects_insufficient_fuel
#print axioms FT1536.Source3.StableBinary003Audit.detects_insufficient_fuel
#print axioms FT1536.Source3.StableBinary003Audit.detects_additional_none_filter
#print axioms FT1536.Source3.StableBinary003Audit.signed_overflow_still_undefined
#print axioms FT1536.Source3.StableBinary003Audit.reference_signed_overflow_no_execution
#print axioms FT1536.Source3.StableBinary003Audit.detects_unsigned_cast_mutation
#print axioms FT1536.Source3.StableBinary003Audit.negative_right_reference
#print axioms FT1536.Source3.StableBinary003Audit.detects_logical_for_signed_shift
