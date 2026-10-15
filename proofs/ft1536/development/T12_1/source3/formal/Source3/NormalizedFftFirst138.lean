import Source3.SelectedFftFirstF138

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NormalizedFftFirst138
open C99CompactState115 (State reference)

def after : State := C99ProcedureNormalize138.normalize SelectedFftFStart138.initial 31
  GeneratedFft138FirstF24.dataBlock GeneratedFft138FirstF24.localSnapshot

theorem block_found : C99FiniteMap114.lookup SelectedFftFirstF138.after.heap.blocks 31=some GeneratedFft138FirstF24.dataBlock := by
  change C99FiniteMap114.lookup (C99LazyBlock129.putBlock GeneratedFft138FirstF24.before.heap
    GeneratedFft138FirstF24.pointer.block GeneratedFft138FirstF24.dataBlock).blocks 31=_
  rw [C99LazyBlock129.lookup_put]
  rfl

theorem reference_equal : reference SelectedFftFirstF138.after=reference after :=
  C99ProcedureNormalize138.reference_equal KeygenSearchFft.program FftShape138.firstCondition
    FftShape138.firstBody FftShape138.firstIncrement 768 SelectedFftFStart138.initial SelectedFftFirstF138.after
    "a".toList GeneratedFft138FirstF00.pointer GeneratedFft138FirstF24.dataBlock GeneratedFft138FirstF24.localSnapshot
    FftFirstPrefix138.through25 FftShape138.first_writes FftShape138.first_increment_writes
    FftShape138.first_arrays FftShape138.first_increment_arrays GeneratedFft138FirstF00.pointer_binding block_found rfl

theorem loop_source : C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.firstLoop
    (reference SelectedFftFStart138.initial) ⟨reference after,.normal⟩ := by
  rw [← reference_equal]
  exact SelectedFftFirstF138.loop_source

theorem continue_body (out : C99ProcedureReference.Result)
    (continuation : C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.afterFirst (reference after) out) :
    C99ProcedureReference.Exec KeygenSearchFft.program GeneratedFft138Syntax.function.body
      (reference SelectedFftFStart138.bound) out := by
  apply SelectedFftFirstF138.continue_body out
  rw [reference_equal]
  exact continuation

end FT1536.Source3.NormalizedFftFirst138
