import Source3.FftTriplingSetupFixed148
import Source3.SelectedFftMiddleContext144

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedTriplingConstants148
open C99CompactState115 (reference)
open SelectedFftMiddle144 (after)

 def values : FftTripleBody147.Constants := ⟨0xbfe0000000000000,0x3febb67ae8584caa,0xbfe0000000000000,0xbfebb67ae8584caa⟩

theorem source_cell (name : C99ArrayReference.Name)
    (outer : name∉FftMiddleShape139.scopeLocals FftMiddleShape139.outerBody)
    (group : name∉FftMiddleShape139.scopeLocals FftMiddleShape139.groupBody)
    (notM : name≠"m".toList) (notT : name≠"t".toList) (notV1 : name≠"v1".toList)
    (notU1 : name≠"u1".toList) (notV : name≠"v".toList) :
    after.locals name=(reference SelectedFftBuffer141.before).locals name :=
  (SelectedFftMiddle144.frame.locals name notT notM).trans
    (SelectedFftOuterContext142.local_cell name outer group notM notT notV1 notU1 notV)

theorem w2r : after.locals "fpr_W2R".toList=some (.uint64,some (.uint64 values.w2r)) := by
  rw [source_cell _ (by decide +kernel) (by decide +kernel) (by decide) (by decide) (by decide) (by decide) (by decide)]
  decide +kernel

theorem w2i : after.locals "fpr_W2I".toList=some (.uint64,some (.uint64 values.w2i)) := by
  rw [source_cell _ (by decide +kernel) (by decide +kernel) (by decide) (by decide) (by decide) (by decide) (by decide)]
  decide +kernel

theorem w4r : after.locals "fpr_W4R".toList=some (.uint64,some (.uint64 values.w4r)) := by
  rw [source_cell _ (by decide +kernel) (by decide +kernel) (by decide) (by decide) (by decide) (by decide) (by decide)]
  decide +kernel

theorem w4i : after.locals "fpr_W4I".toList=some (.uint64,some (.uint64 values.w4i)) := by
  rw [source_cell _ (by decide +kernel) (by decide +kernel) (by decide) (by decide) (by decide) (by decide) (by decide)]
  decide +kernel

theorem fixed : FftTriplingInvariant148.Fixed after SelectedFftBuffer141.base values :=
  ⟨SelectedFftMiddle144.after_context.width,SelectedFftMiddle144.after_context.capacity,
    SelectedFftMiddle144.after_context.writable,SelectedFftMiddle144.after_context.binding,
    SelectedFftMiddle144.after_context.hnCell,SelectedFftMiddleContext144.cubic_binding,
    SelectedFftMiddle144.after_context.pinned,w2r,w2i,w4r,w4i⟩

theorem u : C99LoopScalar141.Cell after "u".toList 768 := by
  unfold C99LoopScalar141.Cell
  rw [source_cell _ (by decide +kernel) (by decide +kernel) (by decide) (by decide) (by decide) (by decide) (by decide)]
  decide +kernel

end FT1536.Source3.SelectedTriplingConstants148
