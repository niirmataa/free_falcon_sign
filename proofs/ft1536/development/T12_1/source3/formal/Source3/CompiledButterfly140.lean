import Source3.GeneratedFftButterfly140
import Source3.C99CompiledSegments140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CompiledButterfly140
open C99CompactState115 (State reference)

def run (calls : B20.C.Scalar.Calls) (count : Nat) (before : State) : Option State :=
  C99CompiledSegments140.run calls GeneratedFftButterfly140.butterfly GeneratedFftButterfly140.increment
    FftMiddleShape139.butterflyCondition count before

theorem source (calls : B20.C.Scalar.Calls)
    (valid : C99ExpressionSound.CallsSound FprPrefixCalls.calls calls)
    (count : Nat) (before after : State) (computed : run calls count before=some after) :
    C99ProcedureSegments136.Prefix KeygenSearchFft.program FftMiddleShape139.butterflyCondition
      FftMiddleShape139.butterflyBody FftMiddleShape139.butterflyIncrement count (reference before) (reference after) := by
  have checked := C99CompiledSegments140.source KeygenSearchFft.program calls valid
    GeneratedFftButterfly140.butterfly GeneratedFftButterfly140.increment
    FftMiddleShape139.butterflyCondition count before after computed
  rw [GeneratedFftButterfly140.body_source,GeneratedFftButterfly140.increment_source] at checked
  exact checked

end FT1536.Source3.CompiledButterfly140
