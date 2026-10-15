import Source3.SelectedFftMiddle144
import Source3.C99ChainSplit144

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftMiddleContinuation144
open C99ProcedureReference (Exec Result)
open C99CompactState115 (reference)
open FftMiddleShape139

/-- Remaining obligation is the original tripling branch and function tail. -/
theorem after_first (out : Result)
    (continuation : Exec KeygenSearchFft.program (.seq tripling (.base .skip)) SelectedFftMiddle144.after out) :
    Exec KeygenSearchFft.program FftShape138.afterFirst (reference NormalizedFftFirst138.after) out := by
  obtain ⟨first,second,tSource,minimumSource,initialSource⟩ := C99ChainSplit144.three
    KeygenSearchFft.program setT setMinimum outerInitial _ _ SelectedFftMiddleStart139.setup_source
  rw [remaining_shape]
  exact .seqNormal _ _ _ first _ tSource (.seqNormal _ _ _ second _ minimumSource
    (.seqNormal _ _ _ SelectedFftMiddle144.after _
      (.seqNormal _ _ _ _ _ initialSource SelectedFftMiddle144.complete_loop_source) continuation))

theorem body (out : Result)
    (continuation : Exec KeygenSearchFft.program (.seq tripling (.base .skip)) SelectedFftMiddle144.after out) :
    Exec KeygenSearchFft.program GeneratedFft138Syntax.function.body (reference SelectedFftFStart138.bound) out :=
  NormalizedFftFirst138.continue_body out (after_first out continuation)

end FT1536.Source3.FftMiddleContinuation144
