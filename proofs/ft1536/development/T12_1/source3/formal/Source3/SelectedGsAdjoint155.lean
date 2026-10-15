import Source3.SelectedGsStart155

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGsAdjoint155
open C99ArrayReference (State)
open C99WordBuffer140 (Represents)
open SelectedGsStart155 (before p q r)

def fValues := GsMapLoop155.image .adjoint 0 768 GeneratedFftTree153FTriple.word
def gValues := GsMapLoop155.image .adjoint 0 768 GeneratedFftTree153GTriple.word

theorem exists_first : ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program
    (.call "falcon_poly_adj_fft3".toList (FftShape138.args "rt1") .discard) before ⟨after,.normal⟩ ∧
    Represents after.heap p fValues ∧ FftGroupFrame143.Frame p 1536 before after :=
  GsMapCall155.adjoint before "rt1" p GeneratedFftTree153FTriple.word SelectedGsStart155.p_binding
    (by decide) SelectedGsStart155.logn rfl SelectedGsStart155.writable SelectedGsInvNorm154.first_image
noncomputable def firstAfter := Classical.choose exists_first
theorem first_source : C99ProcedureReference.Exec KeygenSearchFft.program
    (.call "falcon_poly_adj_fft3".toList (FftShape138.args "rt1") .discard) before ⟨firstAfter,.normal⟩ :=
  (Classical.choose_spec exists_first).1
theorem first_image : Represents firstAfter.heap p fValues := (Classical.choose_spec exists_first).2.1
theorem first_frame : FftGroupFrame143.Frame p 1536 before firstAfter := (Classical.choose_spec exists_first).2.2

theorem g_after_first : Represents firstAfter.heap q GeneratedFftTree153GTriple.word :=
  GsMapCall155.preserve_image before firstAfter p q _ first_frame SelectedGsStart155.q_outside_p SelectedGsInvNorm154.second_image
theorem r_after_first : Represents firstAfter.heap r SelectedGsInvNorm154.values :=
  GsMapCall155.preserve_image before firstAfter p r _ first_frame SelectedGsStart155.r_outside_p SelectedGsInvNorm154.image

theorem exists_second : ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program
    (.call "falcon_poly_adj_fft3".toList (FftShape138.args "rt2") .discard) firstAfter ⟨after,.normal⟩ ∧
    Represents after.heap q gValues ∧ FftGroupFrame143.Frame q 1536 firstAfter after :=
  GsMapCall155.adjoint firstAfter "rt2" q GeneratedFftTree153GTriple.word
    ((congrFun first_frame.arrays "rt2".toList).trans SelectedGsStart155.q_binding) (by decide)
    ((congrFun first_frame.locals "logn".toList).trans SelectedGsStart155.logn) rfl
    ((congrFun first_frame.writable 31).trans SelectedGsStart155.writable) g_after_first
noncomputable def after := Classical.choose exists_second
theorem second_source : C99ProcedureReference.Exec KeygenSearchFft.program
    (.call "falcon_poly_adj_fft3".toList (FftShape138.args "rt2") .discard) firstAfter ⟨after,.normal⟩ :=
  (Classical.choose_spec exists_second).1
theorem second_frame : FftGroupFrame143.Frame q 1536 firstAfter after := (Classical.choose_spec exists_second).2.2

theorem f_image : Represents after.heap p fValues :=
  GsMapCall155.preserve_image firstAfter after q p _ second_frame SelectedGsStart155.p_outside_q first_image
theorem g_image : Represents after.heap q gValues := (Classical.choose_spec exists_second).2.1
theorem r_image : Represents after.heap r SelectedGsInvNorm154.values :=
  GsMapCall155.preserve_image firstAfter after q r _ second_frame SelectedGsStart155.r_outside_q r_after_first

theorem locals : after.locals=before.locals := second_frame.locals.trans first_frame.locals
theorem arrays : after.arrays=before.arrays := second_frame.arrays.trans first_frame.arrays
theorem permissions : after.heap.writable=before.heap.writable := second_frame.writable.trans first_frame.writable

theorem remaining_shape : SelectedGsContinuation154.remaining=
    .seq (.procedure (.call "falcon_poly_adj_fft3".toList (FftShape138.args "rt1") .discard))
      (.seq (.procedure (.call "falcon_poly_adj_fft3".toList (FftShape138.args "rt2") .discard)) KeygenSearchExec.skip) := by decide +kernel

theorem source : KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenAttemptNorm.headCode SelectedRawNorm151.after ⟨after,.normal⟩ := by
  apply SelectedGsContinuation154.source
  rw [remaining_shape]
  exact .seqNormal _ _ _ firstAfter _ (.procedure _ _ _ first_source)
    (.seqNormal _ _ _ after _ (.procedure _ _ _ second_source) (.procedure _ _ _ (.base _ _ _ (.skip _))))

end FT1536.Source3.SelectedGsAdjoint155
