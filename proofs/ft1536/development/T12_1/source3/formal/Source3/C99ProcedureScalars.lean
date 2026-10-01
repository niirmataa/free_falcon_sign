import Source3.C99ProcedureSequence
import Source3.C99StateSound
import Source3.C99StatementBridge

namespace FT1536.Source3.C99ProcedureScalars
open C99ArrayReference (State)
open C99ProcedureReference (Stmt Exec Result Program)

def liftStmt : CLogic.Stmt → C99ArrayReference.Stmt
  | .assign name e => .assign name (.scalar e)
  | code => .scalar code

def thenCode : List CLogic.Stmt → Stmt → Stmt
  | [],tail => tail
  | code::rest,tail => .seq (.base (liftStmt code)) (thenCode rest tail)

theorem scalar_execution (code : CLogic.Stmt) (before after : State)
    (source : C99ArrayReference.Exec FftLeafPrograms.program (liftStmt code) before after) :
    after={before with locals := after.locals} ∧
      C99ScalarReference.Exec FprPrefixCalls.calls before.locals (C99Frontend.scalar code) (.normal after.locals) := by
  cases code with
  | assign name e =>
      cases source with
      | assign before name e ty old v declared value =>
          cases value with
          | scalar e v evaluated =>
              exact ⟨rfl,.assign before.locals name (C99Frontend.expression e) ty old v declared evaluated⟩
  | declare ty names => cases source with | scalar before env stmt body => exact ⟨rfl,body⟩
  | update name op e => cases source with | scalar before env stmt body => exact ⟨rfl,body⟩
  | ret e => cases source with | scalar before env stmt body => exact ⟨rfl,body⟩

theorem array_execution (code : CLogic.Stmt) (before : State) (env : C99ScalarReference.Env)
    (source : C99ScalarReference.Exec FprPrefixCalls.calls before.locals
      (C99Frontend.scalar code) (.normal env)) :
    C99ArrayReference.Exec FftLeafPrograms.program (liftStmt code) before {before with locals := env} := by
  cases code with
  | assign name e =>
      obtain ⟨ty,old,v,declared,evaluated,he⟩ := C99ControlInversion.assign_inv _ _ _ _ _ source
      have hen := C99ScalarReference.Result.normal.inj he
      rw [hen]
      exact .assign before name (.scalar e) ty old v declared (.scalar e v evaluated)
  | declare ty names => exact .scalar before env (.declare ty names) source
  | update name op e => exact .scalar before env (.update name op e) source
  | ret e => exact .scalar before env (.ret e) source

theorem step_complete (sig : C99Typing.Types) (mc : B20.C.Scalar.Calls)
    (calls : C99ExpressionBridge.CallsOK sig FprPrefixCalls.calls mc)
    (code : CLogic.Stmt) (before after : State) (s : B20.C.Scalar.State) (ctx : C99Typing.Types)
    (locals : before.locals=C99Typing.environment s) (typed : C99Typing.WellTyped s)
    (checked : C99StateBridge.check sig s.types code=some ctx) (normal : ∀ e, code≠.ret e)
    (source : C99ArrayReference.Exec FftLeafPrograms.program (liftStmt code) before after) :
    ∃ out, CLogic.step mc s code=some out ∧ after={before with locals := C99Typing.environment out} ∧
      C99Typing.WellTyped out ∧ out.types=ctx := by
  obtain ⟨frame,body⟩ := scalar_execution code before after source
  rw [locals] at body
  obtain ⟨out,hs,hr,ht,hg⟩ := C99StatementBridge.step_complete sig FprPrefixCalls.calls mc calls
    s code ctx (.normal after.locals) typed checked normal body
  have he := C99ScalarReference.Result.normal.inj hr
  exact ⟨out,hs,by simpa only [he] using frame,hg,ht⟩

theorem step_sound (sig : C99Typing.Types) (mc : B20.C.Scalar.Calls)
    (calls : C99ExpressionSound.CallsSound FprPrefixCalls.calls mc)
    (code : CLogic.Stmt) (before : State) (s out : B20.C.Scalar.State) (ctx : C99Typing.Types)
    (locals : before.locals=C99Typing.environment s) (typed : C99Typing.WellTyped s)
    (checked : C99StateBridge.check sig s.types code=some ctx) (run : CLogic.step mc s code=some out) :
    C99ArrayReference.Exec FftLeafPrograms.program (liftStmt code) before
      {before with locals := C99Typing.environment out} ∧ C99Typing.WellTyped out ∧ out.types=ctx := by
  obtain ⟨source,hg,ht⟩ := C99StateSound.step_sound sig FprPrefixCalls.calls mc calls s out code ctx typed checked run
  rw [← locals] at source
  exact ⟨array_execution code before (C99Typing.environment out) source,hg,ht⟩

theorem sequence_complete (sig : C99Typing.Types) (mc : B20.C.Scalar.Calls)
    (calls : C99ExpressionBridge.CallsOK sig FprPrefixCalls.calls mc)
    (program : Program) (codes : List CLogic.Stmt) (tail : Stmt) (before : State) (result : Result)
    (s : B20.C.Scalar.State) (ctx : C99Typing.Types)
    (locals : before.locals=C99Typing.environment s) (typed : C99Typing.WellTyped s)
    (checked : C99StateBridge.checkBody sig s.types codes=some ctx)
    (normal : ∀ code∈codes, ∀ e, code≠.ret e)
    (source : Exec program (thenCode codes tail) before result) :
    ∃ out, UnsignedState.exec mc s codes=some out ∧ C99Typing.WellTyped out ∧ out.types=ctx ∧
      Exec program tail {before with locals := C99Typing.environment out} result := by
  induction codes generalizing before s with
  | nil =>
      have ht : s.types=ctx := Option.some.inj checked
      refine ⟨s,rfl,typed,ht,?_⟩
      have he : {before with locals := C99Typing.environment s}=before := by rw [← locals]
      rw [he]
      exact source
  | cons code rest ih =>
      obtain ⟨midTypes,hc,hr⟩ := Option.bind_eq_some_iff.mp checked
      obtain ⟨middle,hs,htail⟩ := C99ProcedureSequence.base_before_tail program (liftStmt code)
        (thenCode rest tail) before result source
      obtain ⟨next,hstep,he,hg,ht⟩ := step_complete sig mc calls code before middle s midTypes
        locals typed hc (normal code (by simp)) hs
      have hl : middle.locals=C99Typing.environment next := by rw [he]
      obtain ⟨out,ho,hgo,hto,htail⟩ := ih middle next hl hg (by rw [ht]; exact hr)
        (fun c hc => normal c (by simp [hc])) htail
      refine ⟨out,?_,hgo,hto,?_⟩
      · change (CLogic.step mc s code).bind (fun next => UnsignedState.exec mc next rest)=some out
        rw [hstep]
        exact ho
      · simpa only [he] using htail

theorem sequence_sound (sig : C99Typing.Types) (mc : B20.C.Scalar.Calls)
    (calls : C99ExpressionSound.CallsSound FprPrefixCalls.calls mc)
    (program : Program) (codes : List CLogic.Stmt) (tail : Stmt) (before : State) (result : Result)
    (s out : B20.C.Scalar.State) (ctx : C99Typing.Types)
    (locals : before.locals=C99Typing.environment s) (typed : C99Typing.WellTyped s)
    (checked : C99StateBridge.checkBody sig s.types codes=some ctx)
    (run : UnsignedState.exec mc s codes=some out)
    (continuation : Exec program tail {before with locals := C99Typing.environment out} result) :
    Exec program (thenCode codes tail) before result := by
  induction codes generalizing before s with
  | nil =>
      have he := Option.some.inj run
      subst out
      have hs : {before with locals := C99Typing.environment s}=before := by rw [← locals]
      rw [hs] at continuation
      exact continuation
  | cons code rest ih =>
      obtain ⟨midTypes,hc,hr⟩ := Option.bind_eq_some_iff.mp checked
      obtain ⟨next,hn,ht⟩ := Option.bind_eq_some_iff.mp run
      obtain ⟨hs,hg,htypes⟩ := step_sound sig mc calls code before s next midTypes locals typed hc hn
      have htail := ih {before with locals := C99Typing.environment next} next rfl hg
        (by rw [htypes]; exact hr) ht (by exact continuation)
      exact .seqNormal (.base (liftStmt code)) (thenCode rest tail) before
        {before with locals := C99Typing.environment next} result (.base _ _ _ hs) htail

theorem skip_result (program : Program) (before : State) (result : Result)
    (source : Exec program (.base .skip) before result) : result=⟨before,.normal⟩ := by
  cases source with
  | base _ _ _ execution => cases execution; rfl

end FT1536.Source3.C99ProcedureScalars
