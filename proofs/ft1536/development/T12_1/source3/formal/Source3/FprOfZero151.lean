import Source3.FprOfEight132

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprOfZero151

theorem computed : FprPrimitives.execute FprScaledAST.scaledCode [.i64 0,.i32 0]=some (.u64 0) := by decide +kernel

theorem scaled : C99ScalarReference.FunctionExec C99Frontend.headerCalls FprScaledBinding.refFunction
    [.int64 0,.int32 0] (.uint64 0) := FprScaledBridge.sound [.i64 0,.i32 0] (.u64 0) computed

def locals : C99ScalarReference.Env := C99ScalarReference.set (fun _ => none) ['i'] (.int64,some (.int64 0))

theorem source : KeygenSearchExec.ScalarCall "fpr_of".toList [.int32 0] (.uint64 0) := by
  change FprPrefixCalls.ValueCall FprPrefixCalls.baseCalls FprScaledAST.ofCode _ _
  refine .call _ locals (.uint64 0) ?_ ?_
  · exact .cons _ _ _ _ _ _ .nil
  · refine .seqReturn _ _ _ _ (.ret _ _ _ ?_)
    exact .call2 _ _ _ (.int64 0) (.int32 0) (.uint64 0)
      (.variable ['i'] .int64 (.int64 0) rfl) (.literal .int32 0) scaled

end FT1536.Source3.FprOfZero151
