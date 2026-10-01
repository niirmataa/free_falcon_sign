import Source3.KeygenModpAddSub

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenModpSet
open B20.C C99ValueBridge

def code : CLogic.Function where
  name := "modp_set".toList
  result := .u32
  params := [(.i32,"x".toList),(.u32,"p".toList)]
  body := [
    .declare .u32 ["w".toList],
    .assign "w".toList (.cast .u32 (.var "x".toList)),
    .update "w".toList .add (.bin .band (.var "p".toList) (.neg (.bin .shr (.var "w".toList) (.literal .i32 31)))),
    .ret (.var "w".toList)]
def word (x p : BitVec 32) : BitVec 32 := x+(p &&& -(x >>> 31))

/- The inherited scalar grammar spells the LP64 signed32 type as int.
   Normalize only the int32_t typedef token, retaining all source operators. -/
def source : Option CLogic.Function := do
  let chars := ((Pinned.keygenLines.drop 2476).take 9).flatMap String.toList
  let tokens ← CLogicParser.tokenize (chars.length+1) chars
  CLogicParser.parseFunctionTokens (tokens.map (fun token => if token="int32_t".toList then "int".toList else token))
theorem source_header : Pinned.keygenLines[2477]?=some "modp_set(int32_t x, uint32_t p)\n" := by decide
theorem source_bound : source=some code := by decide
theorem checked : C99HeaderProof.checked C99HeaderProof.noSignature code=true := by decide
theorem model_exact (x p : BitVec 32) :
    CLogic.execute (fun _ _ => none) code [.i32 x,.u32 p]=some (.u32 (word x p)) := by
  simp [CLogic.execute,code,word,B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,
    B20.C.Scalar.declareOne,B20.C.Scalar.declareMany,B20.C.Scalar.assign,
    CLogic.evalBody,CLogic.step,CLogic.eval,B20.C.update,B20.C.cast,B20.C.literalValue,
    B20.C.bin,B20.C.commonTy,B20.C.Val.ty,B20.C.bitsOp,B20.C.signedBitsOp,
    B20.C.signedSafe,B20.C.shift,B20.C.neg]

def SourceExec (x p : BitVec 32) (value : C99IntegerReference.Value) : Prop :=
  C99ScalarReference.FunctionExec C99Frontend.noCalls (C99Frontend.headerFunction code) [.int32 x,.uint32 p] value

theorem source_exact (x p : BitVec 32) (value : C99IntegerReference.Value) (source : SourceExec x p value) :
    value=.uint32 (word x p) := by
  have h := C99HeaderProof.function_complete _ _ _ C99HeaderProof.no_calls_ok code [.i32 x,.u32 p] value checked source
  rw [model_exact] at h
  have he := congrArg C99ValueBridge.value (Option.some.inj h)
  rw [value_encode] at he
  exact he.symm

theorem source_exists (x p : BitVec 32) : SourceExec x p (.uint32 (word x p)) :=
  C99HeaderSound.function_sound _ _ _ C99HeaderSound.no_calls_sound code [.i32 x,.u32 p] _ checked (model_exact x p)

theorem exact_integer (x p : BitVec 32) (hp : p.toNat<2^31)
    (lower : -(p.toNat : Int)<x.toInt) (upper : x.toInt<(p.toNat : Int)) :
    ((word x p).toNat : Int)=if 0≤x.toInt then x.toInt else x.toInt+p.toNat := by
  by_cases small : x.toNat<2^31
  · have signed : x.toInt=(x.toNat : Int) := BitVec.toInt_eq_toNat_of_lt (by omega)
    have shifted : x >>> 31=0#32 := by
      apply BitVec.eq_of_toNat_eq
      rw [BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow]
      change x.toNat/2147483648=0
      exact Nat.div_eq_of_lt small
    simp [word,shifted,signed]
  · have signed : x.toInt=(x.toNat : Int)-4294967296 := by
      rw [BitVec.toInt_eq_toNat_cond,ite_eq_right (by omega)]
      rfl
    have negative : x.toInt<0 := by have := x.isLt; omega
    have shifted : x >>> 31=1#32 := by
      apply BitVec.eq_of_toNat_eq
      rw [BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow]
      have := x.isLt
      change x.toNat/2147483648=1
      omega
    have mask : -(1#32)=BitVec.allOnes 32 := by decide
    rw [word,shifted,mask,BitVec.and_allOnes,ite_eq_right (by omega),BitVec.toNat_add]
    have hsum : 2^32≤x.toNat+p.toNat := by omega
    have hrem : x.toNat+p.toNat-2^32<2^32 := by have := x.isLt; omega
    rw [Nat.mod_eq_sub_mod hsum,Nat.mod_eq_of_lt hrem]
    omega

theorem range (x p : BitVec 32) (hp : p.toNat<2^31)
    (lower : -(p.toNat : Int)<x.toInt) (upper : x.toInt<(p.toNat : Int)) : (word x p).toNat<p.toNat := by
  have he := exact_integer x p hp lower upper
  split at he <;> omega

theorem congruence (x p : BitVec 32) (hp : p.toNat<2^31)
    (lower : -(p.toNat : Int)<x.toInt) (upper : x.toInt<(p.toNat : Int)) :
    ((word x p).toNat : Int)%(p.toNat : Int)=x.toInt%(p.toNat : Int) := by
  rw [exact_integer x p hp lower upper]
  split
  · rfl
  · simp

theorem source_contract (x p : BitVec 32) (value : C99IntegerReference.Value)
    (hp : p.toNat<2^31) (lower : -(p.toNat : Int)<x.toInt) (upper : x.toInt<(p.toNat : Int))
    (source : SourceExec x p value) :
    ∃ out, value=.uint32 out ∧ out.toNat<p.toNat ∧
      (out.toNat : Int)%(p.toNat : Int)=x.toInt%(p.toNat : Int) :=
  ⟨word x p,source_exact x p value source,range x p hp lower upper,congruence x p hp lower upper⟩

end FT1536.Source3.KeygenModpSet
