import Source3.C99HeaderSound
import Source3.KeygenHelpers

/- Exact source-word execution of the final solver check's Montgomery
   primitive. The algebraic residue/range contract is a separate obligation;
   this file does not replace it by the function name or source comments. -/
set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenModpWord
open B20.C C99ValueBridge

def montgomeryCode : CLogic.Function where
  name := "modp_montymul".toList
  result := .u32
  params := [(.u32,"a".toList),(.u32,"b".toList),(.u32,"p".toList),(.u32,"p0i".toList)]
  body := [
    .declare .u64 ["z".toList,"w".toList],
    .declare .u32 ["d".toList],
    .assign "z".toList (.bin .mul (.cast .u64 (.var "a".toList)) (.cast .u64 (.var "b".toList))),
    .assign "w".toList (.bin .mul
      (.bin .band (.bin .mul (.var "z".toList) (.var "p0i".toList)) (.cast .u64 (.literal .i32 0x7fffffff)))
      (.var "p".toList)),
    .assign "d".toList (.bin .sub
      (.cast .u32 (.bin .shr (.bin .add (.var "z".toList) (.var "w".toList)) (.literal .i32 31)))
      (.var "p".toList)),
    .update "d".toList .add (.bin .band (.var "p".toList) (.neg (.bin .shr (.var "d".toList) (.literal .i32 31)))),
    .ret (.var "d".toList)]

theorem source_parses :
    CLogicParser.parseFunction (((Pinned.keygenLines.drop 2555).take 12).flatMap String.toList)=some montgomeryCode := by
  decide

def montgomery (a b p p0i : BitVec 32) : BitVec 32 :=
  let z : BitVec 64 := a.setWidth 64*b.setWidth 64
  let w : BitVec 64 := ((z*p0i.setWidth 64) &&& 0x7fffffff#64)*p.setWidth 64
  let d : BitVec 32 := ((z+w) >>> 31).setWidth 32-p
  d+(p &&& -(d >>> 31))

theorem model_exact (a b p p0i : BitVec 32) :
    CLogic.execute (fun _ _ => none) montgomeryCode [.u32 a,.u32 b,.u32 p,.u32 p0i]=
      some (.u32 (montgomery a b p p0i)) := by
  simp [CLogic.execute,montgomeryCode,B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,
    B20.C.Scalar.declareOne,B20.C.Scalar.declareMany,B20.C.Scalar.assign,
    CLogic.evalBody,CLogic.step,CLogic.eval,B20.C.update,B20.C.cast,B20.C.literalValue,
    B20.C.bin,B20.C.commonTy,B20.C.Val.ty,B20.C.bitsOp,B20.C.signedBitsOp,
    B20.C.signedSafe,B20.C.shift,B20.C.neg,montgomery]

theorem checked : C99HeaderProof.checked C99HeaderProof.noSignature montgomeryCode=true := by decide

def SourceExec (a b p p0i : BitVec 32) (z : C99IntegerReference.Value) : Prop :=
  C99ScalarReference.FunctionExec C99Frontend.noCalls (C99Frontend.headerFunction montgomeryCode)
    [.uint32 a,.uint32 b,.uint32 p,.uint32 p0i] z

theorem source_exists (a b p p0i : BitVec 32) :
    SourceExec a b p p0i (.uint32 (montgomery a b p p0i)) :=
  C99HeaderSound.function_sound _ _ _ C99HeaderSound.no_calls_sound montgomeryCode
    [.u32 a,.u32 b,.u32 p,.u32 p0i] _ checked (model_exact a b p p0i)

theorem source_exact (a b p p0i : BitVec 32) (z : C99IntegerReference.Value)
    (source : SourceExec a b p p0i z) : z=.uint32 (montgomery a b p p0i) := by
  have hm := C99HeaderProof.function_complete _ _ _ C99HeaderProof.no_calls_ok montgomeryCode
    [.u32 a,.u32 b,.u32 p,.u32 p0i] z checked source
  rw [model_exact] at hm
  have hv := congrArg value (Option.some.inj hm)
  rw [value_encode] at hv
  exact hv.symm

end FT1536.Source3.KeygenModpWord
