import Source3.StableBinaryTotality

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryInlineTotal
open B20.C
open FT1536.Source3

def halfWord (x : BitVec 64) : BitVec 64 :=
  let x1 := x - ((1 : BitVec 64) <<< 52)
  let t := ((((x1 >>> 52).setWidth 32 &&& 2047#32) + 1#32) >>> 11)
  x1 &&& (t.setWidth 64 - 1)

def doubleWord (x : BitVec 64) : BitVec 64 :=
  x + (((((x >>> 52).setWidth 32 &&& 2047#32) + 2047#32) >>> 11).setWidth 64 <<< 52)

theorem half_from_pinned_M0 (x : BitVec 64) :
    CLogic.execute (fun _ _ => none) StableBinary.halfProgram [.u64 x] =
      some (.u64 (halfWord x)) := by
  simp [CLogic.execute,StableBinary.halfProgram,B20.C.Scalar.bindArgs,
    B20.C.Scalar.emptyState,B20.C.Scalar.declareOne,B20.C.Scalar.declareMany,
    B20.C.Scalar.assign,CLogic.evalBody,CLogic.step,CLogic.eval,
    halfWord,B20.C.bin,B20.C.shift,B20.C.bitsOp,B20.C.commonTy,
    B20.C.Val.ty,B20.C.cast,B20.C.literalValue,B20.C.update]

theorem double_from_pinned_M0 (x : BitVec 64) :
    CLogic.execute (fun _ _ => none) StableBinary.doubleProgram [.u64 x] =
      some (.u64 (doubleWord x)) := by
  simp [CLogic.execute,StableBinary.doubleProgram,B20.C.Scalar.bindArgs,
    B20.C.Scalar.emptyState,B20.C.Scalar.declareOne,B20.C.Scalar.assign,
    CLogic.evalBody,CLogic.step,CLogic.eval,doubleWord,
    B20.C.bin,B20.C.shift,B20.C.bitsOp,B20.C.commonTy,
    B20.C.Val.ty,B20.C.cast,B20.C.literalValue,B20.C.update]

theorem half_total (x : BitVec 64) : StableBinary.half x=some (halfWord x) := by
  simp [StableBinary.half,half_from_pinned_M0]

theorem double_total (x : BitVec 64) : StableBinary.double x=some (doubleWord x) := by
  simp [StableBinary.double,double_from_pinned_M0]

end FT1536.Source3.StableBinaryInlineTotal

#print axioms FT1536.Source3.StableBinaryInlineTotal.half_total
#print axioms FT1536.Source3.StableBinaryInlineTotal.double_total
