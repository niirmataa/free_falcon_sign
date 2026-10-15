import Source3.FftMiddlePrefix139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NormalizedFftMiddle139
open C99CompactState115 (State reference)
open FftMiddleShape139

def after : State := C99ProcedureNormalize138.normalize FftMiddleLoad139.initial 31
  GeneratedFft139MiddleNext.dataBlock GeneratedFft139MiddleNext.localSnapshot

theorem block_found : C99FiniteMap114.lookup GeneratedFft139MiddleNext.after.heap.blocks 31=
    some GeneratedFft139MiddleNext.dataBlock := by
  change C99FiniteMap114.lookup (C99LazyBlock129.putBlock GeneratedFft139MiddleNext.before.heap
    GeneratedFft139MiddleNext.pointer.block GeneratedFft139MiddleNext.dataBlock).blocks 31=_
  rw [C99LazyBlock129.lookup_put]
  rfl

theorem reference_equal : reference GeneratedFft139MiddleNext.after=reference after :=
  C99ProcedureNormalize138.reference_equal KeygenSearchFft.program butterflyCondition butterflyBody butterflyIncrement
    8 FftMiddleLoad139.initial GeneratedFft139MiddleNext.after "a".toList GeneratedFft139MiddlePilot.pointer
    GeneratedFft139MiddleNext.dataBlock GeneratedFft139MiddleNext.localSnapshot FftMiddlePrefix139.through_eight
    butterfly_writes butterfly_increment_writes butterfly_arrays butterfly_increment_arrays
    FftMiddleLoad139.pointer_binding block_found rfl

theorem source : C99ProcedureSegments136.Prefix KeygenSearchFft.program
    butterflyCondition butterflyBody butterflyIncrement 8 (reference FftMiddleLoad139.initial) (reference after) := by
  rw [← reference_equal]
  exact FftMiddlePrefix139.through_eight

theorem continue_loop (out : C99ProcedureReference.Result)
    (continuation : C99ProcedureReference.Exec KeygenSearchFft.program butterflyLoop (reference after) out) :
    C99ProcedureReference.Exec KeygenSearchFft.program butterflyLoop (reference FftMiddleLoad139.initial) out := by
  rw [butterfly_shape] at continuation ⊢
  exact C99ProcedureSegments136.finish _ _ _ _ 8 _ _ _ source continuation

theorem next_counter : C99NameMap115.lookup after.locals "v".toList=some (.u64 (some 8)) := by decide +kernel

theorem remaining_guard : C99ScalarCompute130.evaluate after.locals butterflyCondition=some (.i32 1) := by decide +kernel

end FT1536.Source3.NormalizedFftMiddle139
