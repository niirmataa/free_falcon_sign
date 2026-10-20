import Source3.KeygenPublicScalar

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Project the actual modular reference's scalar straight-line executions
   to the existing scalar reference. This is a proved lowering, not another
   public execution relation or an assumed callee contract. -/
namespace FT1536.Source3.KeygenPublicLinear
open C99ArrayReference (State)
open C99ProcedureReference (Result Flow)
open C99ModularReference (Stmt GenExec)

def atom : CLogic.Stmt → Stmt
  | .assign n e => .assign n (.scalar e)
  | .ret e => .ret (.scalar e)
  | s => .base (.scalar s)
def body (code : List CLogic.Stmt) : Stmt := C99ModularReference.chainOf (code.map atom)
def observation (out : Result) : C99ScalarReference.Result :=
  match out.flow with
  | .returned (some v) => .returned v
  | _ => .normal out.state.locals
def ScalarFlow (out : Result) : Prop := out.flow=.normal ∨ ∃ v, out.flow=.returned (some v)

theorem atom_projection (calls : C99ModularReference.CallRelation)
    (code : CLogic.Stmt) (before : State) (out : Result)
    (source : GenExec calls (atom code) before out) :
    ScalarFlow out ∧ C99ScalarReference.Exec FprPrefixCalls.calls before.locals
      (C99Frontend.scalar code) (observation out) := by
  cases code with
  | declare t names =>
      cases source
      cases ‹C99ArrayReference.Exec _ _ _ _›
      exact ⟨Or.inl rfl,‹_›⟩
  | update n op e =>
      cases source
      cases ‹C99ArrayReference.Exec _ _ _ _›
      exact ⟨Or.inl rfl,‹_›⟩
  | assign n e =>
      cases source with
      | assign _ _ _ t old v declared evaluated =>
          cases evaluated
          exact ⟨Or.inl rfl,.assign _ _ _ _ _ _ declared ‹_›⟩
  | ret e =>
      cases source with
      | ret _ _ v evaluated =>
          cases evaluated
          exact ⟨Or.inr ⟨v,rfl⟩,.ret _ _ _ ‹_›⟩

theorem body_projection (calls : C99ModularReference.CallRelation)
    (code : List CLogic.Stmt) (before : State) (out : Result)
    (source : GenExec calls (body code) before out) :
    ScalarFlow out ∧ C99ScalarReference.Exec FprPrefixCalls.calls before.locals
      (C99Frontend.scalars code) (observation out) := by
  induction code generalizing before out with
  | nil =>
      cases source
      cases ‹C99ArrayReference.Exec _ _ _ _›
      exact ⟨Or.inl rfl,.skip _⟩
  | cons head tail ih =>
      cases source with
      | seqNormal _ _ _ middle _ first rest =>
          have hp := atom_projection calls head before ⟨middle,.normal⟩ first
          have ht := ih middle out rest
          exact ⟨ht.1,.seqNormal _ _ _ _ _ hp.2 ht.2⟩
      | seqExit _ _ _ _ first exit =>
          obtain ⟨flow,execution⟩ := atom_projection calls head before out first
          rcases flow with normal | ⟨v,returned⟩
          · exact False.elim (exit normal)
          · refine ⟨Or.inr ⟨v,returned⟩,?_⟩
            rw [observation,returned] at execution ⊢
            exact .seqReturn _ _ _ _ execution

theorem scope_return (calls : C99ModularReference.CallRelation)
    (code : List CLogic.Stmt) (names : List C99ArrayReference.Name)
    (before : State) (out : Result) (v : C99IntegerReference.Value)
    (source : GenExec calls (.scope names (body code)) before out)
    (returned : out.flow=.returned (some v)) :
    C99ScalarReference.Exec FprPrefixCalls.calls before.locals
      (C99Frontend.scalars code) (.returned v) := by
  cases source with
  | scope _ _ _ inner execution =>
      have h := (body_projection calls code before inner execution).2
      change inner.flow=.returned (some v) at returned
      simpa only [observation,returned] using h

theorem return_value (flow : Flow) (v : C99IntegerReference.Value)
    (source : C99ProcedureReference.ReturnValue (some .uint32) flow (some v)) :
    ∃ raw, flow=.returned (some raw) ∧ v=C99IntegerReference.convert .uint32 raw.integer := by
  cases source
  exact ⟨_,rfl,rfl⟩

end FT1536.Source3.KeygenPublicLinear
