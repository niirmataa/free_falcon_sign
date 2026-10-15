import Source3.FftFirstPrefix138

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftFirstF138
open C99CompactState115 (State reference)

def after : State := GeneratedFft138FirstF24.after

theorem guard_value : C99ScalarCompute130.evaluate after.locals FftShape138.firstCondition=some (.i32 0) := by decide +kernel

theorem loop_source : C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.firstLoop
    (reference SelectedFftFStart138.initial) ⟨reference after,.normal⟩ := by
  rw [FftShape138.first_loop_shape]
  exact C99ProcedureSegments136.finish KeygenSearchFft.program FftShape138.firstCondition FftShape138.firstBody
    FftShape138.firstIncrement 768 _ _ _ FftFirstPrefix138.through25
    (.loopFalse _ _ _ _ (.int32 0)
      (C99ScalarCompute130.evaluate_sound FprPrefixCalls.calls after.locals FftShape138.firstCondition (.i32 0) guard_value)
      (by decide +kernel))

/-- Continuation after the complete first source loop, not a whole FFT call. -/
theorem continue_body (out : C99ProcedureReference.Result)
    (continuation : C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.afterFirst (reference after) out) :
    C99ProcedureReference.Exec KeygenSearchFft.program GeneratedFft138Syntax.function.body
      (reference SelectedFftFStart138.bound) out := by
  rw [FftShape138.body_shape]
  exact .seqNormal _ _ _ _ _ SelectedFftFStart138.declaration
    (.seqNormal _ _ _ _ _ SelectedFftFStart138.size
      (.seqNormal _ _ _ _ _ SelectedFftFStart138.halfSize
        (.seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ SelectedFftFStart138.initialization loop_source) continuation)))

end FT1536.Source3.SelectedFftFirstF138
