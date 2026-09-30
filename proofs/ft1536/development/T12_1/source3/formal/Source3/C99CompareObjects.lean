import Source3.C99CheckCalls
import Source3.FprCompare

/- fpr_lt after its two private-object memcpy operations. The copied word
   representations are independently witnessed before signed interpretation.
   core is the scalar continuation, not a new C callee with four parameters. -/
set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99CompareObjects
open B20.C

def tail : List CLogic.Stmt := [
  .assign "cc0".toList (.cmp .lt (.var "sx".toList) (.var "sy".toList)),
  .assign "cc1".toList (.cmp .gt (.var "sx".toList) (.var "sy".toList)),
  .ret (.bin .xor (.var "cc0".toList)
    (.bin .band (.bin .xor (.var "cc0".toList) (.var "cc1".toList))
      (.cast .i32 (.bin .shr (.bin .band (.var "x".toList) (.var "y".toList)) (.literal .i32 63)))))]

def core : CLogic.Function where
  name := "fpr_lt_after_memcpy".toList
  result := .i32
  params := [(.u64,"x".toList),(.u64,"y".toList),(.i64,"sx".toList),(.i64,"sy".toList)]
  body := .declare .i32 ["cc0".toList,"cc1".toList]::tail

theorem source_decomposition : FprCompare.program.body =
    [.scalar (.declare .i64 ["sx".toList,"sy".toList]),
     .scalar (.declare .i32 ["cc0".toList,"cc1".toList]),
     .memcpy8 "sx".toList "x".toList "sx".toList,
     .memcpy8 "sy".toList "y".toList "sy".toList] ++ tail.map CObjectScalar.Stmt.scalar := rfl

theorem checked : C99HeaderProof.checked C99HeaderProof.noSignature core=true := by decide

theorem model (x y : BitVec 64) :
    CLogic.execute (fun _ _ => none) core [.u64 x,.u64 y,.i64 x,.i64 y]=some (.i32 (FprCompare.spec x y)) := by
  simp [CLogic.execute,core,tail,B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,
    CLogic.evalBody,CLogic.step,CLogic.eval,B20.C.Scalar.declareOne,B20.C.Scalar.declareMany,
    B20.C.Scalar.assign,B20.C.update,B20.C.bin,B20.C.shift,B20.C.commonTy,B20.C.Val.ty,
    B20.C.cast,B20.C.literalValue,B20.C.bitsOp,B20.C.signedBitsOp,B20.C.signedSafe,
    FprCompare.compare_lt_i64,FprCompare.compare_gt_i64,CLogic.boolean,FprCompare.spec]

def Exec (x y : BitVec 64) (v : C99IntegerReference.Value) : Prop :=
  ∃ sx sy, C99BitcastReference.Exec x sx ∧ C99BitcastReference.Exec y sy ∧
    C99ScalarReference.FunctionExec C99Frontend.noCalls (C99Frontend.headerFunction core)
      [.uint64 x,.uint64 y,.int64 sx,.int64 sy] v

theorem exact_result (x y : BitVec 64) (v : C99IntegerReference.Value) (h : Exec x y v) :
    v=.int32 (FprCompare.spec x y) := by
  obtain ⟨sx,sy,hx,hy,hcore⟩ := h
  have hxe := C99BitcastReference.result_exact x sx hx
  have hye := C99BitcastReference.result_exact y sy hy
  subst sx; subst sy
  have hm := C99HeaderProof.function_complete _ _ _ C99HeaderProof.no_calls_ok core
    [.u64 x,.u64 y,.i64 x,.i64 y] v checked hcore
  rw [model] at hm
  have he := congrArg C99ValueBridge.value (Option.some.inj hm)
  rw [C99ValueBridge.value_encode] at he
  exact he.symm

theorem exists_execution (x y : BitVec 64) : Exec x y (.int32 (FprCompare.spec x y)) := by
  refine ⟨x,y,C99BitcastReference.inhabited x,C99BitcastReference.inhabited y,?_⟩
  exact C99HeaderSound.function_sound _ _ _ C99HeaderSound.no_calls_sound core
    [.u64 x,.u64 y,.i64 x,.i64 y] _ checked (model x y)

end FT1536.Source3.C99CompareObjects
