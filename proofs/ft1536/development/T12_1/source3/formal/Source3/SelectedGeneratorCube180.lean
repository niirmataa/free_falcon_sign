import Source3.SelectedGeneratorCubeLoop180

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorCube180
open C99ModularReference (Exec chainOf)
open KeygenMkgm3Program
open SelectedGeneratorCubeSetup180 (logged)
open SelectedGeneratorCubeLoop180 (after)

def remaining := squareLoop::topElements

theorem branch_source : Exec (.scope [] (chainOf [dec "k",cubeLoop])) logged ⟨after,.normal⟩ := by
  have inner : Exec (chainOf [dec "k",cubeLoop]) logged ⟨after,.normal⟩ :=
    .seqNormal _ _ logged SelectedGeneratorCubeSetup180.after ⟨after,.normal⟩ SelectedGeneratorCubeSetup180.decrement
      (.seqNormal _ _ SelectedGeneratorCubeLoop180.before after ⟨after,.normal⟩ SelectedGeneratorCubeLoop180.source
        (.base .skip after after (.skip after)))
  have scopedRun := C99ModularReference.GenExec.scope [] _ logged ⟨after,.normal⟩ inner
  simpa only [KeygenPublicForwardCall.restore_empty] using scopedRun

theorem source : Exec ifFull logged ⟨after,.normal⟩ :=
  .branchTrue _ _ _ logged ⟨after,.normal⟩ (.uint32 1)
    (.variable _ _ _ SelectedGeneratorCubeSetup180.full_cell) (by decide) branch_source

theorem continue_generator (out : C99ProcedureReference.Result) (rest : Exec (chainOf remaining) after out) :
    Exec code SelectedGeneratorEntry178.entry out :=
  SelectedGeneratorRow179.continue_generator out
    (.seqNormal _ _ SelectedGeneratorCubeSetup180.before logged out SelectedGeneratorCubeSetup180.source
      (.seqNormal _ _ logged after out source rest))

end FT1536.Source3.SelectedGeneratorCube180
