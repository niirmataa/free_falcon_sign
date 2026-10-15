import Source3.FprHeaderCells137
import Source3.FprArithmeticCalls137

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprHeadersFast137
open FprHeaderEval137
open FprArithmeticCalls137 (calls)

def neg (x : BitVec 64) := x ^^^ (1#64 <<< 63)

def half (x : BitVec 64) : BitVec 64 :=
  let decreased := x-(1#64 <<< 52)
  let flag := (((decreased >>> 52).setWidth 32 &&& 0x7ff#32)+1) >>> 11
  decreased &&& (flag.setWidth 64-1)

def double (x : BitVec 64) : BitVec 64 :=
  x + (((((x >>> 52).setWidth 32 &&& 0x7ff#32)+0x7ff#32) >>> 11).setWidth 64 <<< 52)

def sub (x y : BitVec 64) := FprAddFast137.word x (neg y)
def sqr (x : BitVec 64) := FprMulFast137.word x x

theorem neg_computed (x : BitVec 64) : returning calls FprPrefixCalls.negCode.body (unaryLocals x)=some (.u64 (neg x)) := by
  simp [ returning,
    C99CompactScalar115.step,
    C99CompactScalar115.assign,
    C99CompactScalar115.evaluate,
    ExpressionFuel.unbounded,
    C99CompactCells115.model,
    C99NameMap115.lookup_put,
    C99NameMap115.lookup,
    FprHeaderCells137.u64,
    C99CompactCells115.Cell.value,
    C99CompactCells115.Cell.ty,
    B20.C.literalValue,
    B20.C.cast,
    B20.C.bin,
    B20.C.commonTy,
    B20.C.Val.ty,
    B20.C.bitsOp,
    B20.C.shift,
    FprPrefixCalls.negCode,
    unaryLocals,
    neg]

theorem half_computed (x : BitVec 64) : returning calls StableBinary.halfProgram.body (unaryLocals x)=some (.u64 (half x)) := by
  simp [ returning,
    C99CompactScalar115.step,
    C99CompactScalar115.assign,
    C99CompactScalar115.evaluate,
    ExpressionFuel.unbounded,
    C99CompactCells115.model,
    C99NameMap115.lookup_put,
    C99NameMap115.lookup,
    FprHeaderCells137.u64,
    C99CompactCells115.Cell.value,
    C99CompactCells115.Cell.ty,
    B20.C.literalValue,
    B20.C.cast,
    B20.C.bin,
    B20.C.commonTy,
    B20.C.Val.ty,
    B20.C.bitsOp,
    B20.C.shift,
    StableBinary.halfProgram,
    unaryLocals,
    half,
    C99CompactScalar115.declareMany,
    C99CompactScalar115.declareOne,
    C99CompactCells115.Cell.uninitialized,
    FprHeaderCells137.u32]

theorem double_computed (x : BitVec 64) : returning calls StableBinary.doubleProgram.body (unaryLocals x)=some (.u64 (double x)) := by
  simp [ returning,
    C99CompactScalar115.step,
    C99CompactScalar115.assign,
    C99CompactScalar115.evaluate,
    ExpressionFuel.unbounded,
    C99CompactCells115.model,
    C99NameMap115.lookup_put,
    C99NameMap115.lookup,
    FprHeaderCells137.u64,
    C99CompactCells115.Cell.value,
    C99CompactCells115.Cell.ty,
    B20.C.literalValue,
    B20.C.cast,
    B20.C.bin,
    B20.C.commonTy,
    B20.C.Val.ty,
    B20.C.bitsOp,
    B20.C.shift,
    StableBinary.doubleProgram,
    unaryLocals,
    double]

theorem sub_generic (mc : B20.C.Scalar.Calls) (x y : BitVec 64) (out : B20.C.Val)
    (called : mc "fpr_add".toList [.u64 x,.u64 (neg y)]=some out) :
    returning mc FprPrefixCalls.subCode.body (binaryLocals x y)=some out := by
  simp [ returning,
    C99CompactScalar115.step,
    C99CompactScalar115.assign,
    C99CompactScalar115.evaluate,
    ExpressionFuel.unbounded,
    C99CompactCells115.model,
    C99NameMap115.lookup_put,
    C99NameMap115.lookup,
    FprHeaderCells137.u64,
    C99CompactCells115.Cell.value,
    C99CompactCells115.Cell.ty,
    B20.C.literalValue,
    B20.C.cast,
    B20.C.bin,
    B20.C.commonTy,
    B20.C.Val.ty,
    B20.C.bitsOp,
    B20.C.shift,
    FprPrefixCalls.subCode,
    binaryLocals]
  exact called

theorem sub_computed (x y : BitVec 64) : returning calls FprPrefixCalls.subCode.body (binaryLocals x y)=some (.u64 (sub x y)) :=
  sub_generic calls x y (.u64 (sub x y)) (by rfl)

theorem sqr_computed (x : BitVec 64) : returning calls FprPrefixCalls.sqrCode.body (unaryLocals x)=some (.u64 (sqr x)) := by
  simp [ returning,
    FprPrefixCalls.sqrCode,
    unaryLocals,
    sqr,
    FprArithmeticCalls137.calls,
    C99CompactScalar115.evaluate,
    ExpressionFuel.unbounded,
    C99CompactCells115.model,
    C99NameMap115.lookup,
    C99CompactCells115.Cell.value]

theorem neg_source (x : BitVec 64) : FprPrefixCalls.calls "fpr_neg".toList [.uint64 x] (.uint64 (neg x)) := by
  unfold FprPrefixCalls.calls
  rw [show FprPrefixCalls.lookup "fpr_neg".toList=some FprPrefixCalls.negCode by exact FprPrefixCalls.neg_source]
  exact unary _ calls FprArithmeticCalls137.sound _ rfl rfl x (neg x) (neg_computed x)

theorem half_source (x : BitVec 64) : FprPrefixCalls.calls "fpr_half".toList [.uint64 x] (.uint64 (half x)) := by
  change FprPrefixCalls.ValueCall FprPrefixCalls.ofCalls StableBinary.halfProgram _ _
  exact unary _ calls FprArithmeticCalls137.sound _ rfl rfl x (half x) (half_computed x)

theorem double_source (x : BitVec 64) : FprPrefixCalls.calls "fpr_double".toList [.uint64 x] (.uint64 (double x)) := by
  change FprPrefixCalls.ValueCall FprPrefixCalls.ofCalls StableBinary.doubleProgram _ _
  exact unary _ calls FprArithmeticCalls137.sound _ rfl rfl x (double x) (double_computed x)

theorem sub_source (x y : BitVec 64) : FprPrefixCalls.calls "fpr_sub".toList [.uint64 x,.uint64 y] (.uint64 (sub x y)) := by
  unfold FprPrefixCalls.calls
  rw [show FprPrefixCalls.lookup "fpr_sub".toList=some FprPrefixCalls.subCode by exact FprPrefixCalls.sub_source]
  exact binary _ calls FprArithmeticCalls137.sound _ rfl rfl x y (sub x y) (sub_computed x y)

theorem sqr_source (x : BitVec 64) : FprPrefixCalls.calls "fpr_sqr".toList [.uint64 x] (.uint64 (sqr x)) := by
  unfold FprPrefixCalls.calls
  rw [show FprPrefixCalls.lookup "fpr_sqr".toList=some FprPrefixCalls.sqrCode by exact FprPrefixCalls.sqr_source]
  exact unary _ calls FprArithmeticCalls137.sound _ rfl rfl x (sqr x) (sqr_computed x)

end FT1536.Source3.FprHeadersFast137
