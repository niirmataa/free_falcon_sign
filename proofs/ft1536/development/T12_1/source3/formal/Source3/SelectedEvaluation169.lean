import Source3.SamplerVector169

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedEvaluation169
open C99ArrayReference (State)
open KeygenPublicInputLoop (Pointers Fixed Invariant Layout)
open KeygenPublicInputMaterial (coefficient)
open SelectedPublicBinding157 (f g h)
open SelectedPublicStart157 (t ready)

def fVector := SamplerVector169.vector SelectedSamplerWords158.fValues
def gVector := SamplerVector169.vector SelectedSamplerWords158.gValues
def pointers : Pointers := ⟨f,g,t,h⟩

theorem layout : Layout pointers := ⟨rfl,rfl,by decide,by decide,by decide,by decide,by decide⟩
theorem fixed : Fixed pointers ready :=
  ⟨SelectedPublicStart157.f_cell,SelectedPublicStart157.g_cell,
   SelectedPublicStart157.t_cell,SelectedPublicStart157.h_cell,
   SelectedPublicStart157.n_cell,SelectedPublicStart157.q_cell⟩

theorem converted : Invariant pointers (coefficient fVector) (coefficient gVector) 1536 SelectedPublicConvert158.after :=
  (KeygenPublicInputMaterial.source_conversion ready ⟨SelectedPublicConvert158.after,.normal⟩ pointers
    (coefficient fVector) (coefficient gVector) layout fixed
    (SamplerVector169.signed ready.heap f SelectedSamplerWords158.fValues SelectedPublicInputs158.f_image SelectedPublicBounds158.f_checked)
    (SamplerVector169.signed ready.heap g SelectedSamplerWords158.gValues SelectedPublicInputs158.g_image SelectedPublicBounds158.g_checked)
    (SelectedPublicTail158.no_tail ready.heap t (fun i _ => SelectedPublicTail158.t_before_empty (KeygenSmallOutput.element t i).offset))
    none rfl SelectedPublicConvert158.source).2

theorem h_tables : KeygenPublicFrame.Tables SelectedPublicConvert158.after h.block := by
  intro name p binding
  rw [SelectedForwardFrame168.tables] at binding
  exact of_decide_eq_true (NormProtected158.lookup_property SelectedFullSampler128.prepared.tables
    (fun p => decide (p.block≠h.block)) (by decide +kernel) name p binding)

/-- Both polynomial evaluations are now attached to the same constructed execution. -/
theorem source : KeygenPublicCommonCalls.Header pointers SelectedForwardT168.output ∧
    KeygenPublicEvaluation.Evaluations SelectedForwardT168.output.heap h gVector ∧
    KeygenPublicEvaluation.Evaluations SelectedForwardT168.output.heap t fVector :=
  KeygenPublicCommonCalls.both SelectedPublicConvert158.after SelectedForwardH168.output SelectedForwardT168.output
    pointers fVector gVector converted layout SelectedPublicNttEntry158.logn SelectedPublicNttEntry158.ternary
    SelectedForwardFrame168.t_tables h_tables SelectedForwardH168.source SelectedForwardT168.source

end FT1536.Source3.SelectedEvaluation169
