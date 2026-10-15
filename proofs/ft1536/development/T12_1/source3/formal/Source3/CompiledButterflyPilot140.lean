import Source3.CompiledButterfly140
import Source3.C99CompiledCapture140
import Source3.GeneratedFft139MiddlePilot

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CompiledButterflyPilot140
open C99CompactState115 (State reference)
open FftMiddleShape139

def before : State := FftMiddleLoad139.initial
def result := CompiledButterfly140.run FprFastCalls137.calls 4 before

theorem checked : C99ProcedureCapture138.capture result 31=
    some (GeneratedFft139MiddlePilot.dataBlock,GeneratedFft139MiddlePilot.localSnapshot) := by decide +kernel

theorem source : C99ProcedureSegments136.Prefix KeygenSearchFft.program butterflyCondition butterflyBody
    butterflyIncrement 4 (reference before) (reference GeneratedFft139MiddlePilot.after) :=
  C99CompiledCapture140.source KeygenSearchFft.program butterflyCondition butterflyBody butterflyIncrement 4 before result
    (fun after computed => CompiledButterfly140.source FprFastCalls137.calls FprFastCalls137.sound 4 before after computed)
    "a".toList GeneratedFft139MiddlePilot.pointer GeneratedFft139MiddlePilot.dataBlock GeneratedFft139MiddlePilot.localSnapshot
    butterfly_writes butterfly_increment_writes butterfly_arrays butterfly_increment_arrays
    FftMiddleLoad139.pointer_binding checked

end FT1536.Source3.CompiledButterflyPilot140
