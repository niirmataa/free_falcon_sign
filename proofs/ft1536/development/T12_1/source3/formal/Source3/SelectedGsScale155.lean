import Source3.SelectedGsAdjoint155

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGsScale155
open C99ArrayReference (State)
open C99WordBuffer140 (Represents)
open SelectedGsStart155 (p q r)

noncomputable def before := SelectedGsAdjoint155.after
def fValues := GsMapLoop155.image .scale FprOfModulus155.word 0 SelectedGsAdjoint155.fValues
def gValues := GsMapLoop155.image .scale FprOfModulus155.word 0 SelectedGsAdjoint155.gValues

theorem logn : before.locals "logn".toList=some (.uint32,some (.uint32 10)) :=
  (congrFun SelectedGsAdjoint155.locals "logn".toList).trans SelectedGsStart155.logn
theorem p_binding : before.arrays "rt1".toList=some p :=
  (congrFun SelectedGsAdjoint155.arrays "rt1".toList).trans SelectedGsStart155.p_binding
theorem q_binding : before.arrays "rt2".toList=some q :=
  (congrFun SelectedGsAdjoint155.arrays "rt2".toList).trans SelectedGsStart155.q_binding
theorem writable : before.heap.writable 31=true :=
  (congrFun SelectedGsAdjoint155.permissions 31).trans SelectedGsStart155.writable

theorem exists_first : ∃ after, KeygenAttemptFft.Call before (KeygenAttemptFft.arguments "rt1") after ∧
    Represents after.heap p fValues ∧ FftGroupFrame143.Frame p 1536 before after :=
  GsMapCall155.scale before "rt1" p SelectedGsAdjoint155.fValues p_binding (by decide) logn rfl writable SelectedGsAdjoint155.f_image
noncomputable def firstAfter := Classical.choose exists_first
theorem first_source : KeygenAttemptFft.Call before (KeygenAttemptFft.arguments "rt1") firstAfter :=
  (Classical.choose_spec exists_first).1
theorem first_image : Represents firstAfter.heap p fValues := (Classical.choose_spec exists_first).2.1
theorem first_frame : FftGroupFrame143.Frame p 1536 before firstAfter := (Classical.choose_spec exists_first).2.2

theorem g_after_first : Represents firstAfter.heap q SelectedGsAdjoint155.gValues :=
  GsMapCall155.preserve_image before firstAfter p q _ first_frame SelectedGsStart155.q_outside_p SelectedGsAdjoint155.g_image
theorem r_after_first : Represents firstAfter.heap r SelectedGsInvNorm154.values :=
  GsMapCall155.preserve_image before firstAfter p r _ first_frame SelectedGsStart155.r_outside_p SelectedGsAdjoint155.r_image

theorem exists_second : ∃ after, KeygenAttemptFft.Call firstAfter (KeygenAttemptFft.arguments "rt2") after ∧
    Represents after.heap q gValues ∧ FftGroupFrame143.Frame q 1536 firstAfter after :=
  GsMapCall155.scale firstAfter "rt2" q SelectedGsAdjoint155.gValues
    ((congrFun first_frame.arrays "rt2".toList).trans q_binding) (by decide)
    ((congrFun first_frame.locals "logn".toList).trans logn) rfl
    ((congrFun first_frame.writable 31).trans writable) g_after_first
noncomputable def after := Classical.choose exists_second
theorem second_source : KeygenAttemptFft.Call firstAfter (KeygenAttemptFft.arguments "rt2") after :=
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

/-- Original GS head and both scaling calls are discharged; the tail and its gate remain explicit. -/
theorem continue_gs (ready : State) (out : C99ProcedureReference.Result)
    (tail : KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenAttemptNorm.tailCode after ⟨ready,.normal⟩)
    (gate : KeygenNormFrame.Gate ready out) :
    KeygenAttemptNorm133.GS KeygenFullData127.env.ctx SelectedRawNorm151.after out :=
  .run SelectedGsAdjoint155.after firstAfter after ready out SelectedGsAdjoint155.source first_source second_source tail gate

end FT1536.Source3.SelectedGsScale155
