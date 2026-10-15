import Source3.SelectedFftGEntry150
import Source3.FftFirstInduction149

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftGFirst150
open C99ArrayReference (State Name)
open C99WordBuffer140 (Represents)
open C99LoopScalar141 (Cell)
open SelectedFftGInput148 (base)
open SelectedFftGEntry150 (wr wi)

noncomputable def before := SelectedFftGBinding148.bound
noncomputable def initial := FftSetup150.initial before

theorem outside (name : Name) (absent : name∉FftSetup150.names) : initial.locals name=before.locals name :=
  (FftSetup150.frame before).locals name absent

theorem fixed : FftFirstInvariant149.Fixed initial base 1536 768 wr wi :=
  ⟨by decide,by decide,by decide,by decide,SelectedFftGBinding148.array_binding,FftSetup150.hn_cell before,
    (outside _ (by decide)).trans SelectedFftGEntry150.w1r,
    (outside _ (by decide)).trans SelectedFftGEntry150.w1i,SelectedFftGInput148.writable⟩

def finalValues := FftFirstInduction149.values 1536 768 (by decide) wr wi 768 0 SelectedFftGInput148.values

theorem exists_source : ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.firstLoop initial ⟨after,.normal⟩ ∧
    FftFirstInvariant149.Fixed after base 1536 768 wr wi ∧ Cell after "u".toList 768 ∧
    Represents after.heap base finalValues ∧ FftFirstFrame149.Frame base 1536 initial after :=
  FftFirstInduction149.source initial base 1536 768 0 wr wi SelectedFftGInput148.values fixed
    (FftSetup150.u_cell before) SelectedFftGBinding148.image (by decide)

noncomputable def after : State := Classical.choose exists_source
theorem source : C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.firstLoop initial ⟨after,.normal⟩ :=
  (Classical.choose_spec exists_source).1
theorem after_fixed : FftFirstInvariant149.Fixed after base 1536 768 wr wi := (Classical.choose_spec exists_source).2.1
theorem u : Cell after "u".toList 768 := (Classical.choose_spec exists_source).2.2.1
theorem image : Represents after.heap base finalValues := (Classical.choose_spec exists_source).2.2.2.1
theorem frame : FftFirstFrame149.Frame base 1536 initial after := (Classical.choose_spec exists_source).2.2.2.2

theorem pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment after.heap :=
  FftPinned139.procedure _ _ _ _ source SelectedFftGBinding148.pinned

theorem local_cell (name : Name) (notU : name≠"u".toList) (absent : name∉FftSetup150.names) :
    after.locals name=before.locals name := (frame.locals name notU).trans (outside name absent)

/-- Source prefix through all768 iterations of the actual second FFT first pass. -/
theorem continue_body (out : C99ProcedureReference.Result)
    (continuation : C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.afterFirst after out) :
    C99ProcedureReference.Exec KeygenSearchFft.program GeneratedFft138Syntax.function.body before out := by
  rw [FftShape138.body_shape]
  exact .seqNormal _ _ before (FftSetup150.declared before) _ (FftSetup150.declaration before)
    (.seqNormal _ _ _ (FftSetup150.sized before) _ (FftSetup150.size before SelectedFftGEntry150.full SelectedFftGEntry150.logn)
      (.seqNormal _ _ _ (FftSetup150.halfSized before) _ (FftSetup150.half_size before)
        (.seqNormal _ _ _ after _ (.seqNormal _ _ _ initial _ (FftSetup150.initialization before) source) continuation)))

end FT1536.Source3.SelectedFftGFirst150
