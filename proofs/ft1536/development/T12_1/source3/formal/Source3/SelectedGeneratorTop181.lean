import Source3.GeneratorTopMetadata181
import Source3.GeneratorTopInitialized181

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorTop181
open C99ArrayReference (State)
open C99ModularReference (Exec chainOf)
open SelectedTopLayout177 (gm igm)
open SelectedTopInit178 (p p0i r2)
open SelectedGeneratorScalar178 (r)

noncomputable def before := SelectedGeneratorSquare181.after

theorem exists_execution : ∃ out, Exec (chainOf KeygenMkgm3Program.topElements) before ⟨out,.normal⟩ ∧
    GeneratorSquareDomains181.From out.heap gm igm 0 := by
  obtain ⟨w,read⟩ := Word32Initialized180.load before.heap (KeygenSmallOutput.element gm 1)
    (SelectedGeneratorSquare181.fixed.gAllocated 1 (by decide)) SelectedGeneratorSquare181.fixed.gWidth
    (SelectedGeneratorSquare181.initialized 1 (by decide) (by decide)).1
  obtain ⟨old,declared⟩ := GeneratorTopMetadata181.w_declared
  exact ⟨GeneratorTopSource181.after before gm igm w p p0i r r2,
    GeneratorTopSource181.source before gm igm w p p0i r r2 SelectedGeneratorSquare181.fixed
      GeneratorTopMetadata181.r_cell GeneratorTopMetadata181.r2_cell old declared read,
    GeneratorTopInitialized181.initialized before gm igm w p p0i r r2 SelectedGeneratorSquare181.initialized⟩

noncomputable def after : State := Classical.choose exists_execution

theorem source : Exec (chainOf KeygenMkgm3Program.topElements) before ⟨after,.normal⟩ := (Classical.choose_spec exists_execution).1
theorem initialized : GeneratorSquareDomains181.From after.heap gm igm 0 := (Classical.choose_spec exists_execution).2

theorem fixed : GeneratorCubeFixed180.Fixed after gm igm p p0i :=
  GeneratorSquareDomains181.transported _ before ⟨after,.normal⟩ gm igm p p0i SelectedGeneratorSquare181.fixed
    (by decide) (by decide) source

theorem body_source : Exec KeygenMkgm3Program.code SelectedGeneratorEntry178.entry ⟨after,.normal⟩ :=
  SelectedGeneratorSquare181.continue_generator ⟨after,.normal⟩ source

end FT1536.Source3.SelectedGeneratorTop181
