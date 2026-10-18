import Source3.SelectedGeneratorRowFixed179

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorRowLoop179
open C99ArrayReference (State)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)
open SelectedTopLayout177 (gm igm)
open KeygenFullData127 (rev)
open SelectedTopInit178 (p p0i)
open SelectedGeneratorSquare178 (g1)
open SelectedGeneratorInverseCall178 (ig)
open SelectedGeneratorRowFixed179 (g2 g4 ig2 ig4)

noncomputable def before := SelectedGeneratorRowPrelude179.after

theorem exists_execution : ∃ out x' ix', Exec KeygenMkgm3Program.lastRowLoop before ⟨out,.normal⟩ ∧
    GeneratorRowFixed179.Fixed out gm igm rev p p0i g2 g4 ig2 ig4 ∧
    Slot out "x" x' ∧ Slot out "ix" ix' ∧ USlot out "u" 512 :=
  GeneratorRowLoop179.full before gm igm rev p p0i g2 g4 ig2 ig4 g1 ig SelectedGeneratorRowFixed179.fixed
    (GeneratorRowPreludeFacts179.x_cell SelectedGeneratorRowPrelude179.before g1 ig p p0i)
    (GeneratorRowPreludeFacts179.ix_cell SelectedGeneratorRowPrelude179.before g1 ig p p0i)
    none SelectedGeneratorRowPrelude179.u_declared

noncomputable def after : State := Classical.choose exists_execution

theorem source : Exec KeygenMkgm3Program.lastRowLoop before ⟨after,.normal⟩ := by
  obtain ⟨x',ix',run,_⟩ := Classical.choose_spec exists_execution
  exact run

theorem fixed : GeneratorRowFixed179.Fixed after gm igm rev p p0i g2 g4 ig2 ig4 := by
  obtain ⟨x',ix',_,fx,_⟩ := Classical.choose_spec exists_execution
  exact fx

theorem end_counter : USlot after "u" 512 := by
  obtain ⟨x',ix',_,_,_,_,hu⟩ := Classical.choose_spec exists_execution
  exact hu

end FT1536.Source3.SelectedGeneratorRowLoop179
