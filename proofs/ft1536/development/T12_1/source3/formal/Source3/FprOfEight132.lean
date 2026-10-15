import Source3.FprScalarClosure132

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprOfEight132
open C99IntegerReference (Value)

theorem computed : FprPrimitives.execute FprScaledAST.scaledCode [.i64 8,.i32 0]=
    some (.u64 FprSqrtEight132.input) := by decide +kernel

theorem scaled : C99ScalarReference.FunctionExec C99Frontend.headerCalls FprScaledBinding.refFunction
    [.int64 8,.int32 0] (.uint64 FprSqrtEight132.input) :=
  FprScaledBridge.sound [.i64 8,.i32 0] (.u64 FprSqrtEight132.input) computed

def locals : C99ScalarReference.Env :=
  C99ScalarReference.set (fun _ => none) ['i'] (.int64,some (.int64 8))

theorem source : KeygenSearchExec.ScalarCall "fpr_of".toList [.int32 8] (.uint64 FprSqrtEight132.input) := by
  change FprPrefixCalls.ValueCall FprPrefixCalls.baseCalls FprScaledAST.ofCode _ _
  refine .call _ locals (.uint64 FprSqrtEight132.input) ?_ ?_
  · exact .cons _ _ _ _ _ _ .nil
  · refine .seqReturn _ _ _ _ (.ret _ _ _ ?_)
    exact .call2 _ _ _ (.int64 8) (.int32 0) (.uint64 FprSqrtEight132.input)
      (.variable ['i'] .int64 (.int64 8) (by rfl)) (.literal .int32 0) scaled

theorem extended : FprScalarClosure132.calls "fpr_of".toList [.int32 8] (.uint64 FprSqrtEight132.input) :=
  FprScalarClosure132.previous _ _ _ source

end FT1536.Source3.FprOfEight132
