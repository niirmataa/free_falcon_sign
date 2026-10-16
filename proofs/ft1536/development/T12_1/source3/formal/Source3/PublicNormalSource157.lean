import Source3.PublicLinearSource157

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicNormalSource157
open C99ArrayReference (State)
open C99ModularReference (Stmt GenExec CallRelation)

def prepend : List CLogic.Stmt → Stmt → Stmt
  | [],tail => tail
  | code::rest,tail => .seq (KeygenPublicLinear.atom code) (prepend rest tail)

theorem source (calls : CallRelation) (code : List CLogic.Stmt) (before : State) (env : C99ScalarReference.Env)
    (normal : C99ScalarReference.Exec FprPrefixCalls.calls before.locals (C99Frontend.scalars code) (.normal env))
    (tail : Stmt) (out : C99ProcedureReference.Result)
    (last : GenExec calls tail {before with locals := env} out) : GenExec calls (prepend code tail) before out := by
  induction code generalizing before with
  | nil => cases normal; exact last
  | cons head rest ih =>
    cases normal with
    | seqNormal _ middle _ _ _ first remaining =>
      exact .seqNormal _ _ _ _ _ (PublicLinearSource157.atom_normal calls head before middle first)
        (ih {before with locals := middle} remaining last)

theorem body_shape (code : List CLogic.Stmt) : prepend code (.base .skip)=KeygenPublicLinear.body code := by
  induction code with
  | nil => rfl
  | cons head rest ih => simpa only [prepend,KeygenPublicLinear.body,List.map_cons,C99ModularReference.chainOf] using congrArg (Stmt.seq (KeygenPublicLinear.atom head)) ih

theorem body (calls : CallRelation) (code : List CLogic.Stmt) (before : State) (env : C99ScalarReference.Env)
    (normal : C99ScalarReference.Exec FprPrefixCalls.calls before.locals (C99Frontend.scalars code) (.normal env)) :
    GenExec calls (KeygenPublicLinear.body code) before ⟨{before with locals := env},.normal⟩ := by
  rw [← body_shape]
  exact source calls code before env normal _ _ (.base _ _ _ (.skip _))

theorem regroup (calls : CallRelation) (a b c : Stmt) (before : State) (out : C99ProcedureReference.Result)
    (source : GenExec calls (.seq a (.seq b c)) before out) : GenExec calls (.seq (.seq a b) c) before out := by
  cases source with
  | seqNormal _ _ _ middle _ first rest =>
    cases rest with
    | seqNormal _ _ _ next _ second last => exact .seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ first second) last
    | seqExit _ _ _ _ second exit => exact .seqExit _ _ _ _ (.seqNormal _ _ _ _ _ first second) exit
  | seqExit _ _ _ _ first exit => exact .seqExit _ _ _ _ (.seqExit _ _ _ _ first exit) exit

theorem regroup_after (calls : CallRelation) (prefixCode : List CLogic.Stmt) (a b c : Stmt) (before : State) (out : C99ProcedureReference.Result)
    (source : GenExec calls (prepend prefixCode (.seq a (.seq b c))) before out) :
    GenExec calls (prepend prefixCode (.seq (.seq a b) c)) before out := by
  induction prefixCode generalizing before with
  | nil => exact regroup calls a b c before out source
  | cons head rest ih =>
    cases source with
    | seqNormal _ _ _ middle _ first tail => exact .seqNormal _ _ _ _ _ first (ih middle tail)
    | seqExit _ _ _ _ first exit => exact .seqExit _ _ _ _ first exit

end FT1536.Source3.PublicNormalSource157
