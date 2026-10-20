import Source3.C99ProcedureScalars
import Source3.CertificateAfterConversion

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Declarations, MKN and the real profile guard at7695--7702. The M0
   parameter values are input profile facts; n/hn and passage through the
   guard are execution results. The bad assignment is the following source
   instruction and is handled by the automatic-object memory layer. -/
namespace FT1536.Source3.CertificatePrologue
open C99ArrayReference (State)
open C99ProcedureReference (Stmt Exec Result Program)
open C99ProcedureScalars

def emptyCalls : B20.C.Scalar.Calls := fun _ _ => none
def noSignatures : C99Typing.Types := fun _ => none
def params : List (B20.C.Ty×B20.C.Name) := [(.u32,"logn".toList),(.u32,"ter".toList)]
def values : List B20.C.Val := [.u32 10,.u32 1]
def initial : B20.C.Scalar.State := (B20.C.Scalar.bindArgs params values).getD B20.C.Scalar.emptyState

def prelude : List CLogic.Stmt := [
  .declare .u64 ["n".toList,"hn".toList,"u".toList],
  .declare .u32 ["bad".toList], .declare .u64 ["q_squared".toList],
  .assign "n".toList (C99ArrayParser.mkn (.var "logn".toList) (.var "ter".toList)),
  .assign "hn".toList (.bin .shr (.var "n".toList) (.literal .i32 1))]
def guard : CLogic.Expr :=
  .lor (.lor (.lor (.cmp .ne (.var "logn".toList) (.literal .i32 10))
    (.cmp .ne (.var "n".toList) (.literal .i32 1536)))
    (.cmp .ne (.var "hn".toList) (.literal .i32 768)))
    (.cmp .ne (.var "ter".toList) (.literal .i32 1))
def skip : Stmt := .base .skip
def rejected : Stmt := .scope [] [] (.seq (.ret (some (.scalar (.literal .i32 0)))) skip)
def tail : Stmt := .seq (.branch guard rejected skip) skip
def code : Stmt := thenCode prelude tail
def completed : B20.C.Scalar.State := (UnsignedState.exec emptyCalls initial prelude).getD B20.C.Scalar.emptyState

theorem source_bound : CertificateAfterConversion.parseRegion 7695 8=some code := by decide
theorem parameters : B20.C.Scalar.bindArgs params values=some initial := by rfl
theorem prelude_run : UnsignedState.exec emptyCalls initial prelude=some completed := by rfl
theorem prelude_checked : C99StateBridge.checkBody noSignatures initial.types prelude=some completed.types := by rfl
theorem guard_checked : C99Typing.infer noSignatures completed.types guard=some .i32 := by decide
theorem guard_run : ExpressionFuel.unbounded emptyCalls completed.values guard=some (.i32 0) := by decide

theorem pure_calls_sound : C99ExpressionSound.CallsSound FprPrefixCalls.calls emptyCalls := by
  intro name args value h
  cases h
theorem pure_calls_complete : C99ExpressionBridge.CallsOK noSignatures FprPrefixCalls.calls emptyCalls := by
  intro name args value ty h
  cases h
theorem initial_typed : C99Typing.WellTyped initial := (C99HeaderSound.bind_sound params values initial parameters).2
theorem completed_typed : C99Typing.WellTyped completed :=
  (C99BodySound.normal_sound noSignatures FprPrefixCalls.calls emptyCalls pure_calls_sound
    prelude initial completed completed.types initial_typed prelude_checked prelude_run).2.1
theorem prelude_normal : ∀ statement∈prelude, ∀ e, statement≠.ret e := by
  intro statement h e he
  subst statement
  simp [prelude] at h

theorem guard_zero (before : State) (v : C99IntegerReference.Value)
    (locals : before.locals=C99Typing.environment completed)
    (source : C99ArrayReference.scalar before guard v) : v.integer=0 := by
  change C99ScalarReference.Eval _ before.locals (C99Frontend.expression guard) v at source
  rw [locals] at source
  have he := (C99ExpressionBridge.expression_complete noSignatures FprPrefixCalls.calls emptyCalls
    pure_calls_complete completed completed_typed guard .i32 v guard_checked source).1
  rw [guard_run] at he
  have hv := congrArg C99ValueBridge.value (Option.some.inj he)
  rw [C99ValueBridge.value_encode] at hv
  rw [← hv]
  rfl

theorem branch_result (program : Program) (before : State) (result : Result)
    (locals : before.locals=C99Typing.environment completed)
    (source : Exec program (.branch guard rejected skip) before result) : result=⟨before,.normal⟩ := by
  cases source with
  | branchTrue condition yes no before result v checked nonzero body =>
      exact False.elim (nonzero (guard_zero before v locals checked))
  | branchFalse condition yes no before result v checked zero body => exact skip_result program before result body

theorem tail_result (program : Program) (before : State) (result : Result)
    (locals : before.locals=C99Typing.environment completed)
    (source : Exec program tail before result) : result=⟨before,.normal⟩ := by
  cases source with
  | seqNormal a b before middle result first second =>
      have he := branch_result program before ⟨middle,.normal⟩ locals first
      have hm : middle=before := congrArg Result.state he
      subst middle
      exact skip_result program before result second
  | seqExit a b before result first exit =>
      have he := branch_result program before result locals first
      exact False.elim (exit (congrArg Result.flow he))

theorem source_result (program : Program) (before : State) (result : Result)
    (locals : before.locals=C99Typing.environment initial)
    (source : Exec program code before result) :
    result=⟨{before with locals := C99Typing.environment completed},.normal⟩ := by
  obtain ⟨out,hr,_,_,ht⟩ := sequence_complete noSignatures emptyCalls pure_calls_complete
    program prelude tail before result initial completed.types locals initial_typed prelude_checked prelude_normal source
  rw [prelude_run] at hr
  have he : completed=out := Option.some.inj hr
  subst out
  exact tail_result program _ result rfl ht

theorem source_exists (program : Program) (before : State)
    (locals : before.locals=C99Typing.environment initial) :
    Exec program code before ⟨{before with locals := C99Typing.environment completed},.normal⟩ := by
  let after : State := {before with locals := C99Typing.environment completed}
  have hg : C99ArrayReference.scalar after guard (.int32 0) :=
    C99ExpressionSound.expression_sound FprPrefixCalls.calls emptyCalls pure_calls_sound
      completed completed_typed guard (.i32 0) guard_run
  have hs : Exec program skip after ⟨after,.normal⟩ := .base .skip after after (.skip after)
  have hb : Exec program (.branch guard rejected skip) after ⟨after,.normal⟩ :=
    .branchFalse guard rejected skip after ⟨after,.normal⟩ (.int32 0) hg rfl hs
  exact sequence_sound noSignatures emptyCalls pure_calls_sound program prelude tail before ⟨after,.normal⟩
    initial completed completed.types locals initial_typed prelude_checked prelude_run
    (.seqNormal _ _ after after ⟨after,.normal⟩ hb hs)

theorem completed_n : (C99Typing.environment completed) "n".toList=some (.uint64,some (.uint64 1536)) := by decide
theorem completed_hn : (C99Typing.environment completed) "hn".toList=some (.uint64,some (.uint64 768)) := by decide
theorem completed_logn : (C99Typing.environment completed) "logn".toList=some (.uint32,some (.uint32 10)) := by decide
theorem completed_ter : (C99Typing.environment completed) "ter".toList=some (.uint32,some (.uint32 1)) := by decide

end FT1536.Source3.CertificatePrologue
