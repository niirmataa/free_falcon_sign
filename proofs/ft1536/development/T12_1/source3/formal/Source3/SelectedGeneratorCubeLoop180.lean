import Source3.SelectedGeneratorCubeSetup180

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorCubeLoop180
open C99ArrayReference (State)
open C99ModularReference (Exec)
open SelectedTopLayout177 (gm igm)
open SelectedTopInit178 (p p0i)

noncomputable def before := SelectedGeneratorCubeSetup180.after

theorem exists_execution : ∃ out, Exec KeygenMkgm3Program.cubeLoop before ⟨out,.normal⟩ ∧
    GeneratorCubeFixed180.Fixed out gm igm p p0i ∧ KeygenNttLoopSupport.USlot out "u" 512 ∧
    GeneratorCubeInitialized180.Lower out.heap gm igm 512 :=
  GeneratorCubeLoop180.full before gm igm p p0i SelectedGeneratorCubeSetup180.fixed
    (some (.uint64 512)) SelectedGeneratorCubeSetup180.u_cell

noncomputable def after : State := Classical.choose exists_execution

theorem source : Exec KeygenMkgm3Program.cubeLoop before ⟨after,.normal⟩ := (Classical.choose_spec exists_execution).1
theorem fixed : GeneratorCubeFixed180.Fixed after gm igm p p0i := (Classical.choose_spec exists_execution).2.1
theorem u_cell : KeygenNttLoopSupport.USlot after "u" 512 := (Classical.choose_spec exists_execution).2.2.1
theorem initialized : GeneratorCubeInitialized180.Lower after.heap gm igm 512 := (Classical.choose_spec exists_execution).2.2.2

end FT1536.Source3.SelectedGeneratorCubeLoop180
