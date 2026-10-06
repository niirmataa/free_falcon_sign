import Source3.KeygenModpSet

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Source-word execution of modp_R (B1.03). The body has no calls, so the
   existing header-function stratum applies unchanged. The value law states
   that the emitted word is 2^31 mod p on the pinned 2^30 < p < 2^31 range;
   Montgomery-scale consumers use it through KeygenNttWordAlgebra. -/
namespace FT1536.Source3.KeygenModpR
open B20.C C99ValueBridge

def code : CLogic.Function where
  name := "modp_R".toList
  result := .u32
  params := [(.u32,"p".toList)]
  body := [.ret (.bin .sub (.bin .shl (.cast .u32 (.literal .i32 1)) (.literal .i32 31))
    (.var "p".toList))]

def word (p : BitVec 32) : BitVec 32 := (1#32 <<< 31)-p

theorem shift_value : (1#32 <<< 31).toNat=2^31 := by decide

theorem source_parses :
    CLogicParser.parseFunction (((Pinned.keygenLines.drop 2515).take 9).flatMap String.toList)=
      some code := by
  decide

theorem model_exact (p : BitVec 32) :
    CLogic.execute (fun _ _ => none) code [.u32 p]=some (.u32 (word p)) := by
  simp [CLogic.execute,code,word,B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,
    B20.C.Scalar.declareOne,B20.C.Scalar.assign,
    CLogic.evalBody,CLogic.eval,B20.C.update,B20.C.cast,B20.C.literalValue,
    B20.C.bin,B20.C.commonTy,B20.C.Val.ty,B20.C.bitsOp,B20.C.signedBitsOp,
    B20.C.signedSafe,B20.C.shift]

theorem checked : C99HeaderProof.checked C99HeaderProof.noSignature code=true := by decide

def SourceExec (p : BitVec 32) (value : C99IntegerReference.Value) : Prop :=
  C99ScalarReference.FunctionExec C99Frontend.noCalls (C99Frontend.headerFunction code)
    [.uint32 p] value

theorem source_exact (p : BitVec 32) (value : C99IntegerReference.Value)
    (source : SourceExec p value) : value=.uint32 (word p) := by
  have h := C99HeaderProof.function_complete _ _ _ C99HeaderProof.no_calls_ok code
    [.u32 p] value checked source
  rw [model_exact] at h
  have he := congrArg C99ValueBridge.value (Option.some.inj h)
  rw [value_encode] at he
  exact he.symm

theorem source_exists (p : BitVec 32) : SourceExec p (.uint32 (word p)) :=
  C99HeaderSound.function_sound _ _ _ C99HeaderSound.no_calls_sound code [.u32 p] _
    checked (model_exact p)

theorem word_toNat (p : BitVec 32) (upper : p.toNat<2^31) :
    (word p).toNat=2^31-p.toNat := by
  have hsum : 2^31+(2^32-p.toNat)=2^32+(2^31-p.toNat) := by omega
  have hlt : 2^31-p.toNat<2^32 := by omega
  calc
    (word p).toNat=((1#32 <<< 31)-p).toNat := rfl
    _=((1#32 <<< 31).toNat+(2^32-p.toNat))%2^32 := by rw [BitVec.toNat_sub,Nat.add_comm]
    _=(2^31+(2^32-p.toNat))%2^32 := by rw [shift_value]
    _=(2^32+(2^31-p.toNat))%2^32 := by rw [hsum]
    _=2^31-p.toNat := by
      rw [Nat.add_mod,Nat.mod_self,zero_add,Nat.mod_eq_of_lt hlt,Nat.mod_eq_of_lt hlt]

theorem value_law (p : BitVec 32) (lower : 2^30<p.toNat) (upper : p.toNat<2^31) :
    (word p).toNat=2^31%p.toNat := by
  have hsmall : 2^31-p.toNat<p.toNat := by omega
  have hsum : p.toNat+(2^31-p.toNat)=2^31 := by omega
  rw [word_toNat p upper,← hsum,Nat.add_mod,Nat.mod_self,zero_add,
    Nat.mod_eq_of_lt hsmall,Nat.mod_eq_of_lt hsmall]
  omega

end FT1536.Source3.KeygenModpR
