import Source3.KeygenHelperStability

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenTables204
open C99ArrayReference (State)
open C99ProcedureReference (Result)

theorem array (program : C99ArrayReference.Program) (code : C99ArrayReference.Stmt) (before after : State)
    (source : C99ArrayReference.Exec program code before after) : after.tables=before.tables := by
  induction source <;> try rfl
  all_goals solve_by_elim [Eq.trans]

theorem modular (code : C99ModularReference.Stmt) (before : State) (out : Result)
    (source : C99ModularReference.Exec code before out) : out.state.tables=before.tables := by
  induction source <;> try rfl
  case base code before after source => exact array _ _ _ _ source
  all_goals solve_by_elim [Eq.trans]

theorem word (code : KeygenWordExec.Stmt) (before : State) (out : Result)
    (source : KeygenWordExec.Exec code before out) : out.state.tables=before.tables := by
  induction source <;> try rfl
  case modular code before out source => exact modular _ _ _ source
  all_goals solve_by_elim [Eq.trans]

theorem zint (code : KeygenZintCall.Stmt) (before : State) (out : Result)
    (source : KeygenZintCall.Exec code before out) : out.state.tables=before.tables := by
  induction source <;> try rfl
  case word code before out source => exact word _ _ _ source
  case call before kind args dst entry out v after binding source returned receive ih => cases receive <;> rfl
  all_goals solve_by_elim [Eq.trans]

theorem level (code : KeygenLevelExec.Stmt) (before : State) (out : Result)
    (source : KeygenLevelExec.Exec code before out) : out.state.tables=before.tables := by
  induction source <;> try rfl
  case modular code before out source => exact modular _ _ _ source
  case call kind args before after source => cases source; rfl
  all_goals solve_by_elim [Eq.trans]

theorem make (code : KeygenMakeFgSource.Stmt) (before : State) (out : Result)
    (source : KeygenMakeFgSource.Exec code before out) : out.state.tables=before.tables := by
  induction source <;> try rfl
  case level code before out source => exact level _ _ _ source
  case zint code before out source => exact zint _ _ _ source
  case word code before out source => exact word _ _ _ source
  case binary kind args before after source => cases source; rfl
  case top args before after source => cases source; rfl
  all_goals solve_by_elim [Eq.trans]

end FT1536.Source3.KeygenTables204
