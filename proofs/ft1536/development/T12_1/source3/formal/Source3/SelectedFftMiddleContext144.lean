import Source3.SelectedFftMiddle144

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftMiddleContext144
open C99CompactState115 (reference)
open C99LoopScalar141 (Cell)
open SelectedFftMiddle144 (after)

theorem n : Cell after "n".toList 1536 :=
  (SelectedFftMiddle144.frame.locals "n".toList (by decide) (by decide)).trans SelectedFftOuterContext142.n

theorem minimum : Cell after "tmin".toList 3 :=
  (SelectedFftMiddle144.frame.locals "tmin".toList (by decide) (by decide)).trans SelectedFftOuterContext142.minimum

theorem full : after.locals "full".toList=some (.uint32,some (.uint32 1)) := by
  rw [SelectedFftMiddle144.frame.locals "full".toList (by decide) (by decide)]
  change SelectedFftOuterControl142.after.locals "full".toList=_
  rw [SelectedFftOuterContext142.local_cell "full".toList (by decide +kernel) (by decide +kernel)
    (by decide) (by decide) (by decide) (by decide) (by decide)]
  decide +kernel

theorem logn : after.locals "logn".toList=some (.uint32,some (.uint32 10)) := by
  rw [SelectedFftMiddle144.frame.locals "logn".toList (by decide) (by decide)]
  change SelectedFftOuterControl142.after.locals "logn".toList=_
  rw [SelectedFftOuterContext142.local_cell "logn".toList (by decide +kernel) (by decide +kernel)
    (by decide) (by decide) (by decide) (by decide) (by decide)]
  decide +kernel

theorem cubic_binding : after.arrays "fpr_gm3_cubic".toList=some (FftGlobalMemory.pointer .cubic) := by
  rw [SelectedFftMiddle144.frame.arrays]
  change SelectedFftOuterControl142.after.arrays "fpr_gm3_cubic".toList=_
  rw [SelectedFftOuterContext142.arrays]
  decide +kernel

theorem arrays : after.arrays=(reference SelectedFftBuffer141.before).arrays :=
  SelectedFftMiddle144.frame.arrays.trans SelectedFftOuterContext142.arrays

theorem globals : after.globals=(reference SelectedFftBuffer141.before).globals :=
  SelectedFftMiddle144.frame.globals.trans SelectedFftOuterContext142.globals

theorem tables : after.tables=(reference SelectedFftBuffer141.before).tables :=
  SelectedFftMiddle144.frame.tables.trans SelectedFftOuterContext142.tables

theorem sizes : after.heap.size=(reference SelectedFftBuffer141.before).heap.size :=
  SelectedFftMiddle144.frame.sizes.trans SelectedFftOuterContext142.sizes

theorem permissions : after.heap.writable=(reference SelectedFftBuffer141.before).heap.writable :=
  SelectedFftMiddle144.frame.writable.trans SelectedFftOuterContext142.permissions

theorem outside_byte (block offset : Nat) (outside : FftLoopFrame141.Outside SelectedFftBuffer141.base 1536 block offset) :
    after.heap.bytes block offset=(reference SelectedFftBuffer141.before).heap.bytes block offset :=
  (SelectedFftMiddle144.frame.bytes block offset outside).trans (SelectedFftOuterContext142.outside_byte block offset outside)

end FT1536.Source3.SelectedFftMiddleContext144
