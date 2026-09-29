import B20.C.ScalarCalls
import B20.Fpr.ParsedPrograms

namespace B20.Fpr
open B20.C.Scalar
open B20.C (Val Ty BinOp bin shift bitsOp commonTy literalValue update neg)

theorem cast_i32_1_u64 : B20.C.cast .u64 (.i32 1) = .u64 1 := by decide
theorem cast_i32_63_u64 : B20.C.cast .u64 (.i32 63) = .u64 63 := by decide

def negSpec (x : BitVec 64) : BitVec 64 := x ^^^ ((1 : BitVec 64) <<< 63)

theorem neg_execution (x : BitVec 64) :
    B20.C.Scalar.execute shiftCalls Parsed.negProgram [.u64 x] = some (.u64 (negSpec x)) := by
  simp [B20.C.Scalar.execute, Parsed.negProgram, bindArgs, emptyState, declareOne, assign,
    evalBody, B20.C.Scalar.step, B20.C.Scalar.evalExpr, negSpec, bin, shift, bitsOp,
    commonTy, Val.ty, B20.C.cast, literalValue, update]

def doubleSpec (x : BitVec 64) : BitVec 64 :=
  x + (((((x >>> 52).setWidth 32 &&& 2047#32) + 2047#32) >>> 11).setWidth 64 <<< 52)

theorem double_execution (x : BitVec 64) :
    B20.C.Scalar.execute shiftCalls Parsed.doubleProgram [.u64 x] =
      some (.u64 (doubleSpec x)) := by
  simp [B20.C.Scalar.execute, Parsed.doubleProgram, bindArgs, emptyState, declareOne,
    assign, evalBody, B20.C.Scalar.step, B20.C.Scalar.evalExpr, doubleSpec, bin,
    shift, bitsOp, commonTy, Val.ty, B20.C.cast, literalValue, update]

def halfSpec (x : BitVec 64) : BitVec 64 :=
  let t := (((x >>> 52).setWidth 32 &&& 2047#32) + 1#32) >>> 11
  (x - ((1 : BitVec 64) <<< 52)) &&& (t.setWidth 64 - 1)

theorem half_execution (x : BitVec 64) :
    B20.C.Scalar.execute shiftCalls Parsed.halfProgram [.u64 x] =
      some (.u64 (halfSpec x)) := by
  simp [B20.C.Scalar.execute, Parsed.halfProgram, bindArgs, emptyState, declareOne,
    assign, evalBody, B20.C.Scalar.step, declareMany, B20.C.Scalar.evalExpr, halfSpec, bin,
    shift, bitsOp, commonTy, Val.ty, B20.C.cast, literalValue, update]

end B20.Fpr
