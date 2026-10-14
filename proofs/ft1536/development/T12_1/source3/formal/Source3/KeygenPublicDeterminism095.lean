import Source3.KeygenPublicLocal095

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicDeterminism095
open C99ArrayReference (State Name)
open C99ProcedureReference (Result)
open KeygenPublicExec
open KeygenPublicTail095 (noArrays tailArrays)
open KeygenPublicLive095 (Live)

/-- Local pointer aliases are not returned by a source function call.
    For continuations without array disposal, full Result equality below
    additionally identifies the pointer environment. -/
def Same (a b : Result) : Prop :=
  a.state.heap = b.state.heap ∧ a.state.locals = b.state.locals ∧ a.flow = b.flow

theorem of_equal (a b : Result) (equal : a = b) : Same a b := by subst b; exact ⟨rfl, rfl, rfl⟩

theorem execution (program : Program)
    (closed : ∀ name f, program name = some f → tailArrays f.body = true)
    (signed : List Name) (code : Stmt) (before : State) (a b : Result)
    (checked : tailArrays code = true) (live : Live before)
    (first : Exec program signed code before a) (second : Exec program signed code before b) :
    Same a b ∧ (noArrays code = true → a = b) := by
  revert checked live
  induction first generalizing b
  case arrayScope signed name count code before out block positive size fresh source ih =>
    intro checked live
    cases second with
    | arrayScope _ _ _ _ otherOut other positive' size' fresh' source' =>
        let rename := Equiv.swap other block
        have moved := KeygenPublicRename095.execution rename program signed code (localEntry before name other count) otherOut source'
        rw [KeygenPublicRename095.entering] at moved
        have fixed := KeygenResultantRename093.fresh_state before other block fresh' fresh live.1 live.2
        change C99BlockRename090.state rename before = before at fixed
        rw [fixed, Equiv.swap_apply_left] at moved
        have same := (ih _ moved checked (KeygenPublicLocal095.enter_live before name block count positive fresh live)).1
        have disposal := KeygenPublicLocal095.disposal program signed code before name block other count otherOut fresh fresh' source'
        refine ⟨⟨?_, ?_, same.2.2⟩, ?_⟩
        · change KeygenRngSource.disposed before.heap out.state.heap block =
            KeygenRngSource.disposed before.heap otherOut.state.heap other
          rw [same.1]
          exact disposal
        · exact congrArg (fun locals => C99ScalarReference.restore before.locals locals []) same.2.1
        · intro impossible
          cases impossible
  all_goals intro checked live; cases second
  all_goals simp only [tailArrays, noArrays, Bool.and_eq_true, Same, C99ArrayReference.restoreScope] at *
  all_goals grind only [KeygenPublicWord095.scalar, KeygenPublicWord095.scalar_body,
    KeygenPublicWord095.expression, KeygenPublicWord095.address, KeygenPublicWord095.parameters,
    KeygenSamplerTail091.store16, → KeygenPublicLive095.binding_live,
    → KeygenPublicLive095.no_arrays_live, → KeygenPublicTail095.noArrays_tail]

end FT1536.Source3.KeygenPublicDeterminism095
