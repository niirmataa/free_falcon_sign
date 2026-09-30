import Source3.CObjectScalar
import Source3.KeygenHelpers

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprCompare
open B20.C CLogic CObjectScalar

def source : List Char := ((Pinned.fprLines.drop 194).take 12).flatMap String.toList

def program : CObjectScalar.Function where
  name := "fpr_lt".toList
  result := .i32
  params := [(.u64,"x".toList),(.u64,"y".toList)]
  body := [
    .scalar (.declare .i64 ["sx".toList,"sy".toList]),
    .scalar (.declare .i32 ["cc0".toList,"cc1".toList]),
    .memcpy8 "sx".toList "x".toList "sx".toList,
    .memcpy8 "sy".toList "y".toList "sy".toList,
    .scalar (.assign "cc0".toList (.cmp .lt (.var "sx".toList) (.var "sy".toList))),
    .scalar (.assign "cc1".toList (.cmp .gt (.var "sx".toList) (.var "sy".toList))),
    .scalar (.ret (.bin .xor (.var "cc0".toList)
      (.bin .band (.bin .xor (.var "cc0".toList) (.var "cc1".toList))
        (.cast .i32 (.bin .shr (.bin .band (.var "x".toList) (.var "y".toList)) (.literal .i32 63))))))]

theorem source_parses : CObjectScalar.parse source=some program := by decide

def spec (x y : BitVec 64) : BitVec 32 :=
  let a:=if x.toInt<y.toInt then 1#32 else 0#32
  let b:=if y.toInt<x.toInt then 1#32 else 0#32
  a ^^^ ((a ^^^ b) &&& ((x &&& y) >>> 63).setWidth 32)

theorem compare_lt_i64 (x y : BitVec 64) :
    CLogic.compare .lt (.i64 x) (.i64 y)=boolean (decide (x.toInt<y.toInt)) := rfl
theorem compare_gt_i64 (x y : BitVec 64) :
    CLogic.compare .gt (.i64 x) (.i64 y)=boolean (decide (y.toInt<x.toInt)) := rfl

theorem execute_bits (calls : B20.C.Scalar.Calls) (x y : BitVec 64) :
    CObjectScalar.execute calls program [.u64 x,.u64 y]=some (.i32 (spec x y)) := by
  simp [CObjectScalar.execute,program,B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,
    B20.C.Scalar.declareOne,B20.C.Scalar.declareMany,B20.C.Scalar.assign,B20.C.update,
    CObjectScalar.evalBody,CObjectScalar.step,CObjectScalar.copyLocal,CObjectScalar.word64Type,
    CObjectScalar.bytesOf,CObjectScalar.fromBytes,B20.Word.LE.join_byteOf,CLogic.step,CLogic.eval,
    B20.C.bin,B20.C.shift,B20.C.commonTy,B20.C.Val.ty,B20.C.cast,B20.C.literalValue,
    B20.C.bitsOp,B20.C.signedBitsOp,B20.C.signedSafe,compare_lt_i64,compare_gt_i64,
    CLogic.boolean,spec]

theorem source_refines (calls : B20.C.Scalar.Calls) (x y : BitVec 64) :
    (CObjectScalar.parse source).bind (fun f => CObjectScalar.execute calls f [.u64 x,.u64 y])=
      some (.i32 (spec x y)) := by
  rw [source_parses,Option.bind_some,execute_bits]

/- The source comparator is not globally the order on real numbers (signed
zero is an example below). On positive sign-zero finite words it agrees with
the unsigned word order used by the KeyGen gate. -/
theorem spec_of_nonnegative_words (x y : BitVec 64)
    (hx : x.toNat<2^63) (hy : y.toNat<2^63) :
    spec x y=if x.toNat<y.toNat then 1#32 else 0#32 := by
  have hxy : (x &&& y).toNat<2^63 :=
    lt_of_le_of_lt (by simpa only [BitVec.toNat_and] using
      (Nat.and_le_left : x.toNat &&& y.toNat ≤ x.toNat)) hx
  have hsign : (x &&& y) >>> 63=0#64 := by
    apply BitVec.eq_of_toNat_eq
    rw [BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow]
    simp only [BitVec.toNat_ofNat,Nat.zero_mod]
    exact Nat.div_eq_of_lt hxy
  have hxi : x.toInt=x.toNat := BitVec.toInt_eq_toNat_of_lt (by norm_num at hx ⊢; omega)
  have hyi : y.toInt=y.toNat := BitVec.toInt_eq_toNat_of_lt (by norm_num at hy ⊢; omega)
  simp [spec,hxi,hyi,hsign]

theorem raw_negative_zero_counterexample :
    spec 0x8000000000000000#64 0#64=1#32 := by decide

end FT1536.Source3.FprCompare

#print FT1536.Source3.FprCompare.source_refines
#print axioms FT1536.Source3.FprCompare.source_parses
#print axioms FT1536.Source3.FprCompare.source_refines
#print axioms FT1536.Source3.FprCompare.spec_of_nonnegative_words
#print axioms FT1536.Source3.FprCompare.raw_negative_zero_counterexample
