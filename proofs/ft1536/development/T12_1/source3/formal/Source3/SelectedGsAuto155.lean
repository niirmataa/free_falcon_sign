import Source3.GsAutoCall155
import Source3.SelectedGsScale155

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGsAuto155
open C99ArrayReference (State)
open C99WordBuffer140 (Represents)
open SelectedGsStart155 (p q r)

noncomputable def before := SelectedGsScale155.after
def fValues := GsAutoCall155.image SelectedGsInvNorm154.values SelectedGsScale155.fValues
def gValues := GsAutoCall155.image SelectedGsInvNorm154.values SelectedGsScale155.gValues

theorem before_locals : before.locals=SelectedGsStart155.before.locals := SelectedGsScale155.locals.trans SelectedGsAdjoint155.locals
theorem before_arrays : before.arrays=SelectedGsStart155.before.arrays := SelectedGsScale155.arrays.trans SelectedGsAdjoint155.arrays
theorem before_permissions : before.heap.writable=SelectedGsStart155.before.heap.writable := SelectedGsScale155.permissions.trans SelectedGsAdjoint155.permissions
theorem logn : before.locals "logn".toList=some (.uint32,some (.uint32 10)) := (congrFun before_locals _).trans SelectedGsStart155.logn
theorem p_binding : before.arrays "rt1".toList=some p := (congrFun before_arrays _).trans SelectedGsStart155.p_binding
theorem q_binding : before.arrays "rt2".toList=some q := (congrFun before_arrays _).trans SelectedGsStart155.q_binding
theorem r_binding : before.arrays "rt3".toList=some r := (congrFun before_arrays _).trans SelectedGsStart155.r_binding
theorem writable : before.heap.writable 31=true := (congrFun before_permissions _).trans SelectedGsStart155.writable

theorem exists_first : ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program
    (.call "falcon_poly_mul_autoadj_fft3".toList (GsAutoCall155.arguments "rt1") .discard) before ⟨after,.normal⟩ ∧
    Represents after.heap p fValues ∧ Represents after.heap r SelectedGsInvNorm154.values ∧ FftGroupFrame143.Frame p 1536 before after :=
  GsAutoCall155.source before "rt1" p r SelectedGsScale155.fValues SelectedGsInvNorm154.values p_binding r_binding
    (by decide) (by decide) logn rfl writable SelectedGsScale155.f_image SelectedGsScale155.r_image
    (fun i j => GsAutoCall155.separate_symm _ _ (SelectedGsEntry154.separate_a j i))
noncomputable def firstAfter := Classical.choose exists_first
theorem first_source : C99ProcedureReference.Exec KeygenSearchFft.program
    (.call "falcon_poly_mul_autoadj_fft3".toList (GsAutoCall155.arguments "rt1") .discard) before ⟨firstAfter,.normal⟩ :=
  (Classical.choose_spec exists_first).1
theorem first_image : Represents firstAfter.heap p fValues := (Classical.choose_spec exists_first).2.1
theorem r_after_first : Represents firstAfter.heap r SelectedGsInvNorm154.values := (Classical.choose_spec exists_first).2.2.1
theorem first_frame : FftGroupFrame143.Frame p 1536 before firstAfter := (Classical.choose_spec exists_first).2.2.2
theorem g_after_first : Represents firstAfter.heap q SelectedGsScale155.gValues :=
  GsMapCall155.preserve_image before firstAfter p q _ first_frame SelectedGsStart155.q_outside_p SelectedGsScale155.g_image

theorem exists_second : ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program
    (.call "falcon_poly_mul_autoadj_fft3".toList (GsAutoCall155.arguments "rt2") .discard) firstAfter ⟨after,.normal⟩ ∧
    Represents after.heap q gValues ∧ Represents after.heap r SelectedGsInvNorm154.values ∧ FftGroupFrame143.Frame q 1536 firstAfter after :=
  GsAutoCall155.source firstAfter "rt2" q r SelectedGsScale155.gValues SelectedGsInvNorm154.values
    ((congrFun first_frame.arrays _).trans q_binding) ((congrFun first_frame.arrays _).trans r_binding)
    (by decide) (by decide) ((congrFun first_frame.locals _).trans logn) rfl
    ((congrFun first_frame.writable _).trans writable) g_after_first r_after_first
    (fun i j => GsAutoCall155.separate_symm _ _ (SelectedGsEntry154.separate_b j i))
noncomputable def after := Classical.choose exists_second
theorem second_source : C99ProcedureReference.Exec KeygenSearchFft.program
    (.call "falcon_poly_mul_autoadj_fft3".toList (GsAutoCall155.arguments "rt2") .discard) firstAfter ⟨after,.normal⟩ :=
  (Classical.choose_spec exists_second).1
theorem second_frame : FftGroupFrame143.Frame q 1536 firstAfter after := (Classical.choose_spec exists_second).2.2.2
theorem f_image : Represents after.heap p fValues :=
  GsMapCall155.preserve_image firstAfter after q p _ second_frame SelectedGsStart155.p_outside_q first_image
theorem g_image : Represents after.heap q gValues := (Classical.choose_spec exists_second).2.1
theorem r_image : Represents after.heap r SelectedGsInvNorm154.values := (Classical.choose_spec exists_second).2.2.1
theorem locals : after.locals=before.locals := second_frame.locals.trans first_frame.locals
theorem arrays : after.arrays=before.arrays := second_frame.arrays.trans first_frame.arrays

def remaining : KeygenSearchExec.Stmt := match KeygenAttemptNorm.tailCode with
  | .seq (.procedure _) (.seq (.procedure _) tail) => tail
  | _ => KeygenSearchExec.skip

theorem shape : KeygenAttemptNorm.tailCode=
    .seq (.procedure (.call "falcon_poly_mul_autoadj_fft3".toList (GsAutoCall155.arguments "rt1") .discard))
      (.seq (.procedure (.call "falcon_poly_mul_autoadj_fft3".toList (GsAutoCall155.arguments "rt2") .discard)) remaining) := by decide +kernel
theorem remaining_norm : remaining=FftShape138.remaining := by decide +kernel

theorem source (out : C99ProcedureReference.Result)
    (tail : KeygenSearchExec.Exec KeygenFullData127.env.ctx FftShape138.remaining after out) :
    KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenAttemptNorm.tailCode before out := by
  rw [shape,remaining_norm]
  exact .seqNormal _ _ _ firstAfter _ (.procedure _ _ _ first_source)
    (.seqNormal _ _ _ after _ (.procedure _ _ _ second_source) tail)

end FT1536.Source3.SelectedGsAuto155
