import Source3.FprOfZero151

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprOfModulus155

def word : BitVec 64 := 4670796038414532608
theorem computed : FprPrimitives.execute FprScaledAST.scaledCode [.i64 18433,.i32 0]=some (.u64 word) := by decide +kernel
theorem scaled : C99ScalarReference.FunctionExec C99Frontend.headerCalls FprScaledBinding.refFunction
    [.int64 18433,.int32 0] (.uint64 word) := FprScaledBridge.sound [.i64 18433,.i32 0] (.u64 word) computed
def locals : C99ScalarReference.Env := C99ScalarReference.set (fun _ => none) ['i'] (.int64,some (.int64 18433))
theorem source : FprPrefixCalls.calls "fpr_of".toList [.int32 18433] (.uint64 word) := by
  change FprPrefixCalls.ValueCall FprPrefixCalls.baseCalls FprScaledAST.ofCode _ _
  refine .call _ locals (.uint64 word) ?_ ?_
  · exact .cons _ _ _ _ _ _ .nil
  · refine .seqReturn _ _ _ _ (.ret _ _ _ ?_)
    exact .call2 _ _ _ (.int64 18433) (.int32 0) (.uint64 word)
      (.variable ['i'] .int64 (.int64 18433) rfl) (.literal .int32 0) scaled

end FT1536.Source3.FprOfModulus155
