import Source3.SelectedGen0Prelude189

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGen0RowFixed189
open C99MemoryReference (Allocated)
open KeygenSmallOutput (element)
open SelectedStepLayout187 (gm igm)
open KeygenFullData127 (rev)
open SelectedTopInit178 (p p0i)
open StepGeneratorSquare188 (g1)
open StepGeneratorInverseCall188 (ig)
open SelectedGen0Prelude189 (before after input)

def g2 := Gen0RowPrelude189.square g1 p p0i
def g4 := Gen0RowPrelude189.fourth g1 p p0i
def ig2 := Gen0RowPrelude189.square ig p p0i
def ig4 := Gen0RowPrelude189.fourth ig p p0i

theorem table : KeygenMkgm3RevMemory.Rev after rev := by
  apply KeygenMkgm3RevMemory.from_source after rev
  · rw [SelectedGen0Prelude189.arrays]
    exact StepGeneratorReady188.rev_binding
  · rw [SelectedGen0Prelude189.heap]
    exact SelectedStepReady187.rev_source

theorem fixed : Gen0RowFixed189.Fixed after gm igm rev p p0i g2 g4 ig2 ig4 := by
  refine ⟨Gen0RowPreludeFacts189.p_cell before g1 ig p p0i input,Gen0RowPreludeFacts189.i_cell before g1 ig p p0i input,
    Gen0RowPreludeFacts189.g2_cell before g1 ig p p0i,Gen0RowPreludeFacts189.g4_cell before g1 ig p p0i,
    Gen0RowPreludeFacts189.ig2_cell before g1 ig p p0i,Gen0RowPreludeFacts189.ig4_cell before g1 ig p p0i,
    Gen0RowPreludeFacts189.k_cell before g1 ig p p0i,Gen0RowPreludeFacts189.b_cell before g1 ig p p0i,
    ?_,?_,table,by decide,by decide,?_,?_,?_,?_⟩
  · rw [SelectedGen0Prelude189.arrays]; exact StepGeneratorReady188.gm_binding
  · rw [SelectedGen0Prelude189.arrays]; exact StepGeneratorReady188.igm_binding
  · intro j hj
    rw [SelectedGen0Prelude189.heap]
    exact SelectedStepMove187.allocated (2718+j) (by omega)
  · intro j hj
    rw [SelectedGen0Prelude189.heap]
    exact SelectedStepMove187.allocated (3230+j) (by omega)
  · rw [SelectedGen0Prelude189.heap]; exact SelectedStepReady187.scratch_writable
  · rw [SelectedGen0Prelude189.heap]; exact SelectedStepReady187.scratch_writable

end FT1536.Source3.SelectedGen0RowFixed189
