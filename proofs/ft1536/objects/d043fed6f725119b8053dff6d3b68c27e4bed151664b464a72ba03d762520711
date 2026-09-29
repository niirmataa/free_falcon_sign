import B20.C.ScalarCalls
import B20.Fpr.ParsedPrograms

namespace B20.Fpr
open B20.C.Scalar
open B20.C (Val Ty BinOp)

def negSpec (x : BitVec 64) : BitVec 64 := x ^^^ ((1 : BitVec 64) <<< 63)

theorem neg_execution (x : BitVec 64) :
    execute shiftCalls Parsed.negProgram [.u64 x] = some (.u64 (negSpec x)) := by
  simp [execute, Parsed.negProgram, bindArgs, emptyState, declareOne, assign,
    evalBody, step, declareMany, evalExpr, negSpec, bin, shift, bitsOp, commonTy,
    Val.ty, cast, literalValue, update]

def doubleSpec (x : BitVec 64) : BitVec 64 :=
  x + ((((x >>> 52).setWidth 32 &&& 2047#32) + 2047#32).setWidth 64 <<< 52)

theorem double_execution (x : BitVec 64) :
    execute shiftCalls Parsed.doubleProgram [.u64 x] = some (.u64 (doubleSpec x)) := by
  simp [execute, Parsed.doubleProgram, bindArgs, emptyState, declareOne, assign,
    evalBody, step, declareMany, evalExpr, doubleSpec, bin, shift, bitsOp, commonTy,
    Val.ty, cast, literalValue, update]

end B20.Fpr
