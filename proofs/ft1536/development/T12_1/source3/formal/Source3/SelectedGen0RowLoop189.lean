import Source3.SelectedGen0RowFixed189

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGen0RowLoop189
open C99ArrayReference (State)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)
open SelectedStepLayout187 (gm igm)
open KeygenFullData127 (rev)
open SelectedTopInit178 (p p0i)
open StepGeneratorSquare188 (g1)
open StepGeneratorInverseCall188 (ig)
open SelectedGen0RowFixed189 (g2 g4 ig2 ig4)

noncomputable def before := SelectedGen0Prelude189.after

theorem exists_execution : ∃ out x' ix', Exec KeygenMkgm3Program.lastRowLoop before ⟨out,.normal⟩ ∧
    Gen0RowFixed189.Fixed out gm igm rev p p0i g2 g4 ig2 ig4 ∧
    Slot out "x" x' ∧ Slot out "ix" ix' ∧ USlot out "u" 256 :=
  Gen0RowLoop189.full before gm igm rev p p0i g2 g4 ig2 ig4 g1 ig SelectedGen0RowFixed189.fixed
    (Gen0RowPreludeFacts189.x_cell SelectedGen0Prelude189.before g1 ig p p0i)
    (Gen0RowPreludeFacts189.ix_cell SelectedGen0Prelude189.before g1 ig p p0i)
    none SelectedGen0Prelude189.u_declared

noncomputable def after : State := Classical.choose exists_execution

theorem source : Exec KeygenMkgm3Program.lastRowLoop before ⟨after,.normal⟩ := by
  obtain ⟨x',ix',run,_⟩ := Classical.choose_spec exists_execution
  exact run

theorem fixed : Gen0RowFixed189.Fixed after gm igm rev p p0i g2 g4 ig2 ig4 := by
  obtain ⟨x',ix',_,fx,_⟩ := Classical.choose_spec exists_execution
  exact fx

theorem end_counter : USlot after "u" 256 := by
  obtain ⟨x',ix',_,_,_,_,hu⟩ := Classical.choose_spec exists_execution
  exact hu

end FT1536.Source3.SelectedGen0RowLoop189
