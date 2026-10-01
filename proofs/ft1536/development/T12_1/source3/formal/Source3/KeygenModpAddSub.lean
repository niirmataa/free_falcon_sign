import Source3.KeygenMontgomery

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenModpAddSub
open B20.C C99ValueBridge

inductive Operation where | add | sub
  deriving DecidableEq, Repr
def code (operation : Operation) : CLogic.Function where
  name := if operation=.add then "modp_add".toList else "modp_sub".toList
  result := .u32
  params := [(.u32,"a".toList),(.u32,"b".toList),(.u32,"p".toList)]
  body := [
    .declare .u32 ["d".toList],
    .assign "d".toList (if operation=.add then
      .bin .sub (.bin .add (.var "a".toList) (.var "b".toList)) (.var "p".toList)
      else .bin .sub (.var "a".toList) (.var "b".toList)),
    .update "d".toList .add (.bin .band (.var "p".toList) (.neg (.bin .shr (.var "d".toList) (.literal .i32 31)))),
    .ret (.var "d".toList)]
def result (operation : Operation) (a b p : BitVec 32) : BitVec 32 :=
  let d := if operation=.add then a+b-p else a-b
  d+(p &&& -(d >>> 31))

theorem add_source : CLogicParser.parseFunction (((Pinned.keygenLines.drop 2528).take 9).flatMap String.toList)=some (code .add) := by decide
theorem sub_source : CLogicParser.parseFunction (((Pinned.keygenLines.drop 2541).take 9).flatMap String.toList)=some (code .sub) := by decide
theorem checked (operation : Operation) : C99HeaderProof.checked C99HeaderProof.noSignature (code operation)=true := by cases operation <;> decide

theorem model_exact (operation : Operation) (a b p : BitVec 32) :
    CLogic.execute (fun _ _ => none) (code operation) [.u32 a,.u32 b,.u32 p]=some (.u32 (result operation a b p)) := by
  cases operation <;>
    simp [CLogic.execute,code,result,B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,
      B20.C.Scalar.declareOne,B20.C.Scalar.declareMany,B20.C.Scalar.assign,
      CLogic.evalBody,CLogic.step,CLogic.eval,B20.C.update,B20.C.cast,B20.C.literalValue,
      B20.C.bin,B20.C.commonTy,B20.C.Val.ty,B20.C.bitsOp,B20.C.signedBitsOp,
      B20.C.signedSafe,B20.C.shift,B20.C.neg]

def SourceExec (operation : Operation) (a b p : BitVec 32) (value : C99IntegerReference.Value) : Prop :=
  C99ScalarReference.FunctionExec C99Frontend.noCalls (C99Frontend.headerFunction (code operation))
    [.uint32 a,.uint32 b,.uint32 p] value

theorem source_exact (operation : Operation) (a b p : BitVec 32) (value : C99IntegerReference.Value)
    (source : SourceExec operation a b p value) : value=.uint32 (result operation a b p) := by
  have h := C99HeaderProof.function_complete _ _ _ C99HeaderProof.no_calls_ok (code operation)
    [.u32 a,.u32 b,.u32 p] value (checked operation) source
  rw [model_exact] at h
  have he := congrArg C99ValueBridge.value (Option.some.inj h)
  rw [value_encode] at he
  exact he.symm

theorem source_exists (operation : Operation) (a b p : BitVec 32) : SourceExec operation a b p (.uint32 (result operation a b p)) :=
  C99HeaderSound.function_sound _ _ _ C99HeaderSound.no_calls_sound (code operation)
    [.u32 a,.u32 b,.u32 p] _ (checked operation) (model_exact operation a b p)

theorem add_exact (a b p : BitVec 32) (hp : p.toNat<2^31) (ha : a.toNat<p.toNat) (hb : b.toNat<p.toNat) :
    (result .add a b p).toNat=MontgomeryArithmetic.reduce (a.toNat+b.toNat) p.toNat := by
  have hs : (a+b).toNat=a.toNat+b.toNat := by
    rw [BitVec.toNat_add,Nat.mod_eq_of_lt]
    omega
  change (KeygenMontgomery.conditionalSubtract (a+b) p).toNat=_
  rw [KeygenMontgomery.subtract_exact (a+b) p hp (by rw [hs]; omega),hs]

theorem sub_exact (a b p : BitVec 32) (hp : p.toNat<2^31) (ha : a.toNat<p.toNat) (hb : b.toNat<p.toNat) :
    (result .sub a b p).toNat=if a.toNat<b.toNat then a.toNat+p.toNat-b.toNat else a.toNat-b.toNat := by
  by_cases hlt : a.toNat<b.toNat
  · have hd : (a-b).toNat=2^32-b.toNat+a.toNat := by
      rw [BitVec.toNat_sub,Nat.mod_eq_of_lt]
      have := b.isLt
      omega
    have hshift : (a-b) >>> 31=1#32 := by
      apply BitVec.eq_of_toNat_eq
      rw [BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow,hd]
      norm_num
      omega
    have hmask : -(1#32)=BitVec.allOnes 32 := by decide
    simp only [result,show Operation.sub≠Operation.add by decide,ite_false,hshift,hmask,BitVec.and_allOnes,ite_eq_left hlt]
    rw [BitVec.toNat_add,hd]
    have he : 2^32-b.toNat+a.toNat+p.toNat=2^32+(a.toNat+p.toNat-b.toNat) := by omega
    rw [he,Nat.add_mod,Nat.mod_self,Nat.zero_add,Nat.mod_mod,Nat.mod_eq_of_lt]
    omega
  · have hd : (a-b).toNat=a.toNat-b.toNat :=
      BitVec.toNat_sub_of_not_usubOverflow (by simp only [BitVec.usubOverflow,decide_eq_true_eq]; omega)
    have hshift : (a-b) >>> 31=0#32 := by
      apply BitVec.eq_of_toNat_eq
      rw [BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow,hd]
      norm_num
      omega
    simpa [result,hshift,hlt] using hd

theorem add_range (a b p : BitVec 32) (hp : p.toNat<2^31) (ha : a.toNat<p.toNat) (hb : b.toNat<p.toNat) :
    (result .add a b p).toNat<p.toNat := by
  rw [add_exact a b p hp ha hb]
  exact MontgomeryArithmetic.reduced_range _ _ (by omega)
theorem sub_range (a b p : BitVec 32) (hp : p.toNat<2^31) (ha : a.toNat<p.toNat) (hb : b.toNat<p.toNat) :
    (result .sub a b p).toNat<p.toNat := by
  rw [sub_exact a b p hp ha hb]
  split <;> omega

theorem sub_congruence (a b p : BitVec 32) (hp : p.toNat<2^31) (ha : a.toNat<p.toNat) (hb : b.toNat<p.toNat) :
    ((result .sub a b p).toNat+b.toNat)%p.toNat=a.toNat%p.toNat := by
  rw [sub_exact a b p hp ha hb]
  split
  · have he : a.toNat+p.toNat-b.toNat+b.toNat=a.toNat+p.toNat := by omega
    rw [he]
    simp
  · rw [Nat.sub_add_cancel (by omega)]

end FT1536.Source3.KeygenModpAddSub
