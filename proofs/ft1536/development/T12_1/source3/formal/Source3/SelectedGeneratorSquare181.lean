import Source3.GeneratorSquareLoop181

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorSquare181
open C99ArrayReference (State)
open C99ModularReference (Exec chainOf)
open SelectedTopLayout177 (gm igm)
open SelectedTopInit178 (p p0i)

noncomputable def before := SelectedGeneratorCubeLoop180.after

theorem input_initialized : GeneratorSquareDomains181.From before.heap gm igm 256 := fun j lo hi =>
  ⟨SelectedGeneratorCubeTable180.g_initialized j lo hi,SelectedGeneratorCubeTable180.i_initialized j lo hi⟩

theorem exists_execution : ∃ out, Exec KeygenMkgm3Program.squareLoop before ⟨out,.normal⟩ ∧
    GeneratorCubeFixed180.Fixed out gm igm p p0i ∧ KeygenNttLoopSupport.USlot out "u" 0 ∧
    GeneratorSquareDomains181.From out.heap gm igm 1 :=
  GeneratorSquareLoop181.full before gm igm p p0i SelectedGeneratorCubeLoop180.fixed input_initialized
    (some (.uint64 512)) SelectedGeneratorCubeLoop180.u_cell

noncomputable def after : State := Classical.choose exists_execution

theorem source : Exec KeygenMkgm3Program.squareLoop before ⟨after,.normal⟩ := (Classical.choose_spec exists_execution).1
theorem fixed : GeneratorCubeFixed180.Fixed after gm igm p p0i := (Classical.choose_spec exists_execution).2.1
theorem u_cell : KeygenNttLoopSupport.USlot after "u" 0 := (Classical.choose_spec exists_execution).2.2.1
theorem initialized : GeneratorSquareDomains181.From after.heap gm igm 1 := (Classical.choose_spec exists_execution).2.2.2

theorem forward_filled : KeygenMkgm3Loops.Filled after.heap gm 1 :=
  (KeygenMkgm3Assembly.square_for before ⟨after,.normal⟩ p0i gm igm
    ⟨⟨SelectedGeneratorCubeLoop180.fixed.pCell,SelectedGeneratorCubeLoop180.fixed.iCell⟩,
      ⟨SelectedGeneratorCubeLoop180.fixed.gBinding,SelectedGeneratorCubeLoop180.fixed.iBinding⟩,
      SelectedGeneratorCubeTable180.k_cell⟩
    ⟨some (.uint64 512),SelectedGeneratorCubeLoop180.u_cell⟩ SelectedGeneratorCubeTable180.forward_filled
    (by decide) (by decide) SelectedGeneratorRowTable179.separate
    (KeygenNinv31.source_exists KeygenNinv31.prime) source).1

theorem continue_generator (out : C99ProcedureReference.Result)
    (rest : Exec (chainOf KeygenMkgm3Program.topElements) after out) :
    Exec KeygenMkgm3Program.code SelectedGeneratorEntry178.entry out :=
  SelectedGeneratorCube180.continue_generator out (.seqNormal _ _ before after out source rest)

end FT1536.Source3.SelectedGeneratorSquare181
