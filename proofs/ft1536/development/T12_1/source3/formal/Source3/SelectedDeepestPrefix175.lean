import Source3.SelectedMakeFgEntry175

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedDeepestPrefix175
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenDeepestSource (Exec part)
open KeygenFullData127 (env)

def remaining := KeygenDeepestSource.chain [part 3,part 4]

theorem continue_body (made : State) (out : Result)
    (makeRun : Exec env.ctx .make SelectedDeepestWorkspace175.after ⟨made,.normal⟩)
    (tailRun : Exec env.ctx remaining made out) :
    Exec env.ctx KeygenDeepestSource.code SelectedDeepestEntry175.entry out := by
  have part2 := SelectedDeepestWorkspace175.continue_part ⟨made,.normal⟩
    (KeygenDeepestSource.Exec.seqNormal _ _ SelectedDeepestWorkspace175.after made ⟨made,.normal⟩ makeRun
      (DeepestDeclarations175.array_source env.ctx .skip made made (.skip made)))
  exact .seqNormal _ _ SelectedDeepestEntry175.entry SelectedDeepestConfig175.before out
    (DeepestDeclarations175.source env.ctx SelectedDeepestEntry175.entry)
    (.seqNormal _ _ SelectedDeepestConfig175.before SelectedDeepestConfig175.after out SelectedDeepestConfig175.source
      (.seqNormal _ _ SelectedDeepestConfig175.after made out part2 tailRun))

end FT1536.Source3.SelectedDeepestPrefix175
