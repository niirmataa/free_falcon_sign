import Source3.ActualDraw126

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ActualRefill126
open C99CompactState115 (State reference)
open ActualExtractPrep126 (ctx)

theorem native_word : ActualDraw126.word=ShakeBlockFixture116.afterWords[0]! := by decide +kernel

def assigned := C99CompactState115.bindValue ActualDraw126.after "rb".toList .u64 (.u64 ActualDraw126.word)
def result := KeygenScalarCompute121.run 16 KeygenSamplerSource.assignBits assigned
theorem defined : result.isSome=true := by decide +kernel
def refilled : State := result.get defined
theorem computed : KeygenScalarCompute121.run 16 KeygenSamplerSource.assignBits assigned=some refilled :=
  SelectedInput124.option_get result defined

theorem source : KeygenSamplerSource.Refill ctx (reference SelectedSamplerStart126.firstRead) (reference refilled) := by
  refine .fill (reference SelectedSamplerStart126.firstRead) (reference ActualDraw126.after) (reference refilled)
    (.int32 1) ActualDraw126.word .uint64 (some (.uint64 0)) SelectedSamplerStart126.refill_guard
    (by decide +kernel) ?_ ActualDraw126.source ?_
  · change (C99NameMap115.lookup SelectedSamplerStart126.firstRead.locals "rb".toList).map C99CompactCells115.Cell.reference = _
    decide +kernel
  · have body := KeygenScalarCompute121.run_sound 16 KeygenSamplerSource.assignBits assigned refilled computed
    unfold assigned at body
    rw [C99CompactState115.reference_bindValue] at body
    exact body

end FT1536.Source3.ActualRefill126
