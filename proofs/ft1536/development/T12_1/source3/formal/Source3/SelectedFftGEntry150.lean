import Source3.SelectedFftGBinding148
import Source3.FftSetup150

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftGEntry150
open C99ArrayReference (State Name)
open C99CompactState115 (reference)
open SelectedFftGBinding148 (bound)

theorem full : bound.locals "full".toList=some (.uint32,some (.uint32 1)) := by rfl
theorem logn : bound.locals "logn".toList=some (.uint32,some (.uint32 10)) := by rfl

theorem global_cell (name : Name) (notFull : name≠"full".toList) (notLogn : name≠"logn".toList) :
    bound.locals name=(reference SelectedFftFStart138.before).globals name := by
  change (if name="logn".toList then _ else if name="full".toList then _ else _)=_
  rw [ite_eq_right notLogn,ite_eq_right notFull]
  rfl

def wr : BitVec 64 := 0x3fe0000000000000
def wi : BitVec 64 := 0x3febb67ae8584caa

theorem w1r : bound.locals "fpr_W1R".toList=some (.uint64,some (.uint64 wr)) := by
  rw [global_cell _ (by decide) (by decide)]
  decide +kernel
theorem w1i : bound.locals "fpr_W1I".toList=some (.uint64,some (.uint64 wi)) := by
  rw [global_cell _ (by decide) (by decide)]
  decide +kernel

theorem w2r : bound.locals "fpr_W2R".toList=some (.uint64,some (.uint64 SelectedTriplingConstants148.values.w2r)) := by
  rw [global_cell _ (by decide) (by decide)]
  decide +kernel
theorem w2i : bound.locals "fpr_W2I".toList=some (.uint64,some (.uint64 SelectedTriplingConstants148.values.w2i)) := by
  rw [global_cell _ (by decide) (by decide)]
  decide +kernel
theorem w4r : bound.locals "fpr_W4R".toList=some (.uint64,some (.uint64 SelectedTriplingConstants148.values.w4r)) := by
  rw [global_cell _ (by decide) (by decide)]
  decide +kernel
theorem w4i : bound.locals "fpr_W4I".toList=some (.uint64,some (.uint64 SelectedTriplingConstants148.values.w4i)) := by
  rw [global_cell _ (by decide) (by decide)]
  decide +kernel

theorem square : bound.arrays "fpr_gm3_square".toList=some (FftGlobalMemory.pointer .square) := by
  change (reference SelectedFftFStart138.before).tables "fpr_gm3_square".toList=_
  decide +kernel
theorem cubic : bound.arrays "fpr_gm3_cubic".toList=some (FftGlobalMemory.pointer .cubic) := by
  change (reference SelectedFftFStart138.before).tables "fpr_gm3_cubic".toList=_
  decide +kernel

end FT1536.Source3.SelectedFftGEntry150
