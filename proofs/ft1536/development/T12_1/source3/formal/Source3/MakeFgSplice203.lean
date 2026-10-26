import Source3.MakeFgSequence187

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MakeFgSplice203
open C99ArrayReference (State)
open KeygenMakeFgSource (Stmt Exec skip)

theorem skip_inv (s out : State) (run : Exec skip s ⟨out,.normal⟩) : out=s := by
  cases run with
  | level _ _ _ source =>
    cases source with
    | modular _ _ _ source =>
      cases source with
      | base _ _ _ source => cases source; rfl

theorem append (steps : List Stmt) (tail : Stmt) (before middle : State) (out : C99ProcedureReference.Result)
    (run : Exec (MakeFgSequence187.append steps skip) before ⟨middle,.normal⟩)
    (rest : Exec tail middle out) : Exec (MakeFgSequence187.append steps tail) before out := by
  induction steps generalizing before with
  | nil =>
    have equal:=skip_inv before middle run
    subst middle
    exact rest
  | cons code codes ih =>
    cases run with
    | seqNormal _ _ _ next _ head tailRun => exact .seqNormal _ _ _ next _ head (ih next tailRun)
    | seqExit _ _ _ _ _ exit => exact False.elim (exit rfl)

end FT1536.Source3.MakeFgSplice203
