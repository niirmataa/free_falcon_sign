import Source3.SelectedFftBuffer141
import Source3.FftLoopInduction141

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftLoop141
open C99CompactState115 (reference)
open SelectedFftBuffer141 (before base values)

def real : BitVec 64 := 0x3febb67ae8584cab
def imag : BitVec 64 := 0x3fdfffffffffffff

theorem fixed : FftLoopInvariant141.Fixed (reference before) base 1536 768 384 384 real imag := by
  refine ⟨by decide,by decide,by decide,by decide,by decide,?_,?_,?_,?_,?_,?_,SelectedFftBuffer141.writable⟩
  · exact GeneratedFft140Middle16.pointer_binding
  · unfold C99LoopScalar141.Cell
    decide +kernel
  · unfold C99LoopScalar141.Cell
    decide +kernel
  · unfold C99LoopScalar141.Cell
    decide +kernel
  · decide +kernel
  · decide +kernel

theorem counter : C99LoopScalar141.Cell (reference before) "v".toList 24 := by
  unfold C99LoopScalar141.Cell
  decide +kernel

def finalValues := FftLoopInduction141.values 1536 768 384 fixed.length real imag 360 24 values

/-- The remaining360 actual source iterations follow from one induction
    theorem, not from360 separate executions or proposed final snapshots. -/
theorem exists_source : ∃ after,
    C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.butterflyLoop (reference before) ⟨after,.normal⟩ ∧
    FftLoopInvariant141.Fixed after base 1536 768 384 384 real imag ∧
    C99LoopScalar141.Cell after "v".toList 384 ∧
    C99WordBuffer140.Represents after.heap base finalValues ∧
    FftLoopFrame141.Frame base 1536 (reference before) after :=
  FftLoopInduction141.source (reference before) base 1536 768 384 384 24 real imag values
    fixed counter SelectedFftBuffer141.represented (by decide)

noncomputable def after : C99ArrayReference.State := Classical.choose exists_source

theorem source : C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.butterflyLoop
    (reference before) ⟨after,.normal⟩ := (Classical.choose_spec exists_source).1

theorem after_fixed : FftLoopInvariant141.Fixed after base 1536 768 384 384 real imag :=
  (Classical.choose_spec exists_source).2.1

theorem after_counter : C99LoopScalar141.Cell after "v".toList 384 :=
  (Classical.choose_spec exists_source).2.2.1

theorem after_image : C99WordBuffer140.Represents after.heap base finalValues :=
  (Classical.choose_spec exists_source).2.2.2.1

theorem frame : FftLoopFrame141.Frame base 1536 (reference before) after :=
  (Classical.choose_spec exists_source).2.2.2.2

end FT1536.Source3.SelectedFftLoop141
