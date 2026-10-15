import Source3.SelectedFftOuterControl142
import Source3.FftPinned139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftOuterContext142
open C99CompactState115 (reference)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open FftMiddleShape139
open SelectedFftOuterControl142 (after bodyAfter assigned)

theorem local_cell (name : C99ArrayReference.Name)
    (outer : name∉scopeLocals outerBody) (group : name∉scopeLocals groupBody)
    (notM : name≠"m".toList) (notT : name≠"t".toList)
    (notV1 : name≠"v1".toList) (notU1 : name≠"u1".toList) (notV : name≠"v".toList) :
    after.locals name=(reference SelectedFftBuffer141.before).locals name := calc
  after.locals name=bodyAfter.locals name := FftLocalCells140.outside _ _ _ _ notM
  _=assigned.locals name := SelectedFftOuterControl142.body_local name outer
  _=SelectedFftGroupControl142.after.locals name := FftLocalCells140.outside _ _ _ _ notT
  _=SelectedFftGroupControl142.one.locals name := FftLocalCells140.outside _ _ _ _ notV1
  _=SelectedFftGroup141.after.locals name := FftLocalCells140.outside _ _ _ _ notU1
  _=(reference SelectedFftBuffer141.before).locals name := SelectedFftGroupFacts142.local_cell name group notV

theorem hn : Cell after "hn".toList 768 := by
  unfold Cell
  rw [local_cell _ (by decide +kernel) (by decide +kernel) (by decide) (by decide) (by decide) (by decide) (by decide)]
  decide +kernel

theorem n : Cell after "n".toList 1536 := by
  unfold Cell
  rw [local_cell _ (by decide +kernel) (by decide +kernel) (by decide) (by decide) (by decide) (by decide) (by decide)]
  decide +kernel

theorem minimum : Cell after "tmin".toList 3 := by
  unfold Cell
  rw [local_cell _ (by decide +kernel) (by decide +kernel) (by decide) (by decide) (by decide) (by decide) (by decide)]
  decide +kernel

theorem arrays : after.arrays=(reference SelectedFftBuffer141.before).arrays := by
  change SelectedFftLoop141.after.arrays=_
  exact SelectedFftLoop141.frame.arrays

theorem globals : after.globals=(reference SelectedFftBuffer141.before).globals := SelectedFftLoop141.frame.globals
theorem tables : after.tables=(reference SelectedFftBuffer141.before).tables := SelectedFftLoop141.frame.tables
theorem sizes : after.heap.size=(reference SelectedFftBuffer141.before).heap.size := SelectedFftLoop141.frame.sizes
theorem permissions : after.heap.writable=(reference SelectedFftBuffer141.before).heap.writable := SelectedFftLoop141.frame.writable

theorem outside_byte (block offset : Nat) (outside : FftLoopFrame141.Outside SelectedFftBuffer141.base 1536 block offset) :
    after.heap.bytes block offset=(reference SelectedFftBuffer141.before).heap.bytes block offset :=
  SelectedFftLoop141.frame.bytes block offset outside

theorem binding : after.arrays "a".toList=some SelectedFftBuffer141.base := by
  rw [arrays]
  exact SelectedFftLoop141.fixed.binding

theorem pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment after.heap :=
  FftPinned139.procedure _ _ _ _ SelectedFftOuterControl142.increment_source
    (FftPinned139.procedure _ _ _ _ SelectedFftOuterControl142.body_source
      (FftPinned139.procedure _ _ _ _ SelectedFftMiddleStart139.setup_source FftPinned139.first_pass))

end FT1536.Source3.SelectedFftOuterContext142
