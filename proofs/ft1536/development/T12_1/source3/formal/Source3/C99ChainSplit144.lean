import Source3.C99Chain139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ChainSplit144
open C99ProcedureReference (Program Stmt Exec)
open C99ArrayReference (State)

theorem three (program : Program) (a b c : Stmt) (s final : State)
    (head : Exec program (C99ProcedureParser.chain [a,b,c]) s ⟨final,.normal⟩) :
    ∃ first second, Exec program a s ⟨first,.normal⟩ ∧ Exec program b first ⟨second,.normal⟩ ∧ Exec program c second ⟨final,.normal⟩ := by
  cases head with
  | seqExit _ _ _ _ _ exit => exact (exit rfl).elim
  | seqNormal _ _ _ first _ aSource rest =>
    cases rest with
    | seqExit _ _ _ _ _ exit => exact (exit rfl).elim
    | seqNormal _ _ _ second _ bSource rest =>
      cases rest with
      | seqExit _ _ _ _ _ exit => exact (exit rfl).elim
      | seqNormal _ _ _ third _ cSource rest =>
        cases rest with
        | base _ _ _ skipped =>
          cases skipped
          exact ⟨first,second,aSource,bSource,cSource⟩

end FT1536.Source3.C99ChainSplit144
