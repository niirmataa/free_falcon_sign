import Source3.ModularSequence178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MkgmSplice199
open C99ArrayReference (State)
open C99ModularReference (GenExec CallRelation chainOf)

theorem append (calls : CallRelation) (first second : List C99ModularReference.Stmt)
    (before middle : State) (out : C99ProcedureReference.Result)
    (run : GenExec calls (chainOf first) before ⟨middle,.normal⟩)
    (rest : GenExec calls (chainOf second) middle out) :
    GenExec calls (chainOf (first++second)) before out := by
  induction first generalizing before with
  | nil =>
    cases run with
    | base _ _ _ source => cases source; exact rest
  | cons code codes ih =>
    cases run with
    | seqNormal _ _ _ next _ head tail =>
      exact .seqNormal _ _ _ next _ head (ih next tail)
    | seqExit _ _ _ _ _ exit => exact False.elim (exit rfl)

end FT1536.Source3.MkgmSplice199
