import Source3.KeygenPublicLinear

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicLinearSource157
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ModularReference (GenExec CallRelation)

theorem declarations_no_return (env : C99ScalarReference.Env) (ty : C99IntegerReference.Ty)
    (names : List C99ArrayReference.Name) (v : Value)
    (source : C99ScalarReference.Exec FprPrefixCalls.calls env (C99Frontend.declarations ty names) (.returned v)) : False := by
  induction names generalizing env with
  | nil => cases source
  | cons name rest ih =>
    cases source with
    | seqNormal _ middle _ _ _ first tail =>
      cases first
      exact ih _ tail
    | seqReturn _ _ _ _ first => cases first

theorem atom_normal (calls : CallRelation) (code : CLogic.Stmt) (before : State) (env : C99ScalarReference.Env)
    (source : C99ScalarReference.Exec FprPrefixCalls.calls before.locals (C99Frontend.scalar code) (.normal env)) :
    GenExec calls (KeygenPublicLinear.atom code) before ⟨{before with locals := env},.normal⟩ := by
  cases code with
  | declare ty names => exact .base _ _ _ (.scalar _ _ _ source)
  | update name op expr => exact .base _ _ _ (.scalar _ _ _ source)
  | assign name expr =>
    cases source with
    | assign _ _ _ ty old v declared evaluated => exact .assign _ _ _ ty old v declared (.scalar _ _ evaluated)
  | ret expr => cases source

theorem atom_return (calls : CallRelation) (code : CLogic.Stmt) (before : State) (v : Value)
    (source : C99ScalarReference.Exec FprPrefixCalls.calls before.locals (C99Frontend.scalar code) (.returned v)) :
    ∃ after, GenExec calls (KeygenPublicLinear.atom code) before ⟨after,.returned (some v)⟩ := by
  cases code with
  | declare ty names => exact (declarations_no_return before.locals _ names v source).elim
  | assign name expr => cases source
  | update name op expr => cases source
  | ret expr =>
    cases source with
    | ret _ _ _ evaluated => exact ⟨before,.ret _ _ _ (.scalar _ _ evaluated)⟩

/-- Forward lifting of the existing scalar execution into the original public modular body. -/
theorem source (calls : CallRelation) (code : List CLogic.Stmt) (before : State) (v : Value)
    (executed : C99ScalarReference.Exec FprPrefixCalls.calls before.locals (C99Frontend.scalars code) (.returned v)) :
    ∃ after, GenExec calls (KeygenPublicLinear.body code) before ⟨after,.returned (some v)⟩ := by
  induction code generalizing before with
  | nil => cases executed
  | cons head tail ih =>
    cases executed with
    | seqNormal _ middle _ _ _ first rest =>
      obtain ⟨after,source⟩ := ih {before with locals := middle} rest
      exact ⟨after,.seqNormal _ _ _ _ _ (atom_normal calls head before middle first) source⟩
    | seqReturn _ _ _ _ first =>
      obtain ⟨after,source⟩ := atom_return calls head before v first
      exact ⟨after,.seqExit _ _ _ _ source (by intro impossible; cases impossible)⟩

end FT1536.Source3.PublicLinearSource157
