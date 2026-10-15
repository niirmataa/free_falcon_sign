import Source3.FprScalarClosure132
import Source3.C99PrimitiveExists
import Source3.C99CountedWords

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprBoundCalls135
open B20.C (Val)
open C99ValueBridge (value)
open C99IntegerReference (convert Value)

def ofModel (arg : Val) : Option Val :=
  FprPrimitives.execute FprScaledAST.scaledCode [B20.C.cast .i64 arg,.i32 0]

theorem of_source (arg : Val) (word : BitVec 64) (computed : ofModel arg=some (.u64 word)) :
    FprScalarClosure132.calls "fpr_of".toList [value arg] (.uint64 word) := by
  apply FprScalarClosure132.previous
  change FprPrefixCalls.ValueCall FprPrefixCalls.baseCalls FprScaledAST.ofCode [value arg] (.uint64 word)
  let converted := convert .int64 (value arg).integer
  let locals : C99ScalarReference.Env := C99ScalarReference.set (fun _ => none) ['i'] (.int64,some converted)
  have scaled := FprScaledBridge.sound [B20.C.cast .i64 arg,.i32 0] (.u64 word) computed
  simp only [List.map_cons,List.map_nil,C99ValueBridge.cast_matches] at scaled
  have bound : C99ScalarReference.BindArgs [(C99IntegerReference.Ty.int64,['i'])] [value arg] locals :=
    .cons _ _ _ _ _ _ .nil
  have body : C99ScalarReference.Exec FprPrefixCalls.baseCalls (FprPrefixCalls.withGlobals locals)
      (C99Frontend.scalars FprScaledAST.ofCode.body) (.returned (.uint64 word)) := by
    refine .seqReturn _ _ _ _ (.ret _ _ _ ?_)
    exact .call2 _ _ _ converted (.int32 0) (.uint64 word)
      (.variable ['i'] .int64 converted (by simp [FprPrefixCalls.withGlobals,locals,C99ScalarReference.set]))
      (.literal .int32 0) scaled
  have source := @FprPrefixCalls.ValueCall.call FprPrefixCalls.baseCalls FprScaledAST.ofCode [value arg] locals (.uint64 word) bound body
  change FprPrefixCalls.ValueCall FprPrefixCalls.baseCalls FprScaledAST.ofCode [value arg]
    (convert .uint64 (Value.uint64 word).integer) at source
  rw [show convert .uint64 (Value.uint64 word).integer=Value.uint64 word from
    C99CountedWords.convert_self (.uint64 word)] at source
  exact source

theorem mul_source (x y word : BitVec 64)
    (computed : FprPrimitives.execute FprAST.mulCode [.u64 x,.u64 y]=some (.u64 word)) :
    FprScalarClosure132.calls "fpr_mul".toList [.uint64 x,.uint64 y] (.uint64 word) := by
  apply FprScalarClosure132.previous
  change C99Frontend.primitiveCall "fpr_mul".toList _ _
  apply C99PrimitiveExists.mul_sound x y word
  simp [FprPrimitives.mul,FprAST.mul_binding,FprPrimitives.call,computed]

theorem div_source (x y word : BitVec 64)
    (computed : FprPrimitives.execute FprAST.divCode [.u64 x,.u64 y]=some (.u64 word)) :
    FprScalarClosure132.calls "fpr_div".toList [.uint64 x,.uint64 y] (.uint64 word) := by
  apply FprScalarClosure132.previous
  change C99Frontend.primitiveCall "fpr_div".toList _ _
  apply C99PrimitiveExists.div_sound x y word
  simp [FprPrimitives.div,FprAST.div_binding,FprPrimitives.call,computed]

end FT1536.Source3.FprBoundCalls135
