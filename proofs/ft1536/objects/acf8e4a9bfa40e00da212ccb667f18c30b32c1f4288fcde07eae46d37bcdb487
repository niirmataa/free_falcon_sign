import Source3.FftLeafPrograms
import Source3.C99OperatorBridge

/- Procedure/control extension for the size-returning LDL functions and
   KeyGen control flow. A callee must execute its actual body. Return values
   are converted at the function boundary before assignment to the caller.
   Automatic-object allocation/teardown is a separate memory obligation. -/
namespace FT1536.Source3.C99ProcedureReference
open C99ArrayReference
abbrev Value := C99IntegerReference.Value
abbrev Ty := C99IntegerReference.Ty

inductive Flow where
  | normal | returned (value : Option Value) | breakLoop | continueLoop
  deriving DecidableEq, Repr
structure Result where
  state : State
  flow : Flow

inductive Destination where
  | discard | assign (name : Name) | update (name : Name) (op : B20.C.BinOp)
  deriving DecidableEq, Repr

inductive Receive : Destination → State → Option Value → State → Prop where
  | discard (s : State) (value : Option Value) : Receive .discard s value s
  | assign (s : State) (name : Name) (v : Value) (ty : Ty) (old : Option Value)
      (declared : s.locals name=some (ty,old)) :
      Receive (.assign name) s (some v) (bindValue s name ty v)
  | update (s : State) (name : Name) (op : B20.C.BinOp) (old v result : Value) (ty : Ty)
      (declared : s.locals name=some (ty,some old))
      (operation : C99OperatorBridge.Binary op old v result) :
      Receive (.update name op) s (some v) (bindValue s name ty result)

theorem receive_heap (dst : Destination) (before after : State) (v : Option Value)
    (h : Receive dst before v after) : after.heap=before.heap := by cases h <;> rfl

inductive ReturnValue : Option Ty → Flow → Option Value → Prop where
  | voidEnd : ReturnValue none .normal none
  | voidReturn : ReturnValue none (.returned none) none
  | value (ty : Ty) (v : Value) :
      ReturnValue (some ty) (.returned (some v)) (some (C99IntegerReference.convert ty v.integer))

inductive Stmt where
  | base (code : C99ArrayReference.Stmt)
  | seq (first second : Stmt)
  | scope (locals pointers : List Name) (body : Stmt)
  | branch (condition : CLogic.Expr) (yes no : Stmt)
  | loop (condition : CLogic.Expr) (body increment : Stmt)
  | ret (value : Option Expr)
  | breakLoop | continueLoop
  | call (name : Name) (args : List Arg) (destination : Destination)
  deriving DecidableEq, Repr

structure Function where
  params : List Param
  result : Option Ty
  body : Stmt
  deriving DecidableEq, Repr
abbrev Program := Name → Option Function

inductive Exec (program : Program) : Stmt → State → Result → Prop where
  | base (code : C99ArrayReference.Stmt) (before after : State)
      (execution : C99ArrayReference.Exec FftLeafPrograms.program code before after) :
      Exec program (.base code) before ⟨after,.normal⟩
  | seqNormal (a b : Stmt) (before middle : State) (result : Result)
      (first : Exec program a before ⟨middle,.normal⟩) (second : Exec program b middle result) :
      Exec program (.seq a b) before result
  | seqExit (a b : Stmt) (before : State) (result : Result)
      (first : Exec program a before result) (exit : result.flow≠.normal) :
      Exec program (.seq a b) before result
  | scope (locals pointers : List Name) (body : Stmt) (before : State) (result : Result)
      (inner : Exec program body before result) :
      Exec program (.scope locals pointers body) before
        ⟨restoreScope before result.state locals pointers,result.flow⟩
  | branchTrue (condition : CLogic.Expr) (yes no : Stmt) (before : State) (result : Result) (v : Value)
      (guard : scalar before condition v) (nonzero : v.integer≠0)
      (body : Exec program yes before result) : Exec program (.branch condition yes no) before result
  | branchFalse (condition : CLogic.Expr) (yes no : Stmt) (before : State) (result : Result) (v : Value)
      (guard : scalar before condition v) (zero : v.integer=0)
      (body : Exec program no before result) : Exec program (.branch condition yes no) before result
  | loopFalse (condition : CLogic.Expr) (body increment : Stmt) (before : State) (v : Value)
      (guard : scalar before condition v) (zero : v.integer=0) :
      Exec program (.loop condition body increment) before ⟨before,.normal⟩
  | loopNormal (condition : CLogic.Expr) (body increment : Stmt) (before middle next : State)
      (result : Result) (v : Value)
      (guard : scalar before condition v) (nonzero : v.integer≠0)
      (iteration : Exec program body before ⟨middle,.normal⟩)
      (update : Exec program increment middle ⟨next,.normal⟩)
      (rest : Exec program (.loop condition body increment) next result) :
      Exec program (.loop condition body increment) before result
  | loopContinue (condition : CLogic.Expr) (body increment : Stmt) (before middle next : State)
      (result : Result) (v : Value)
      (guard : scalar before condition v) (nonzero : v.integer≠0)
      (iteration : Exec program body before ⟨middle,.continueLoop⟩)
      (update : Exec program increment middle ⟨next,.normal⟩)
      (rest : Exec program (.loop condition body increment) next result) :
      Exec program (.loop condition body increment) before result
  | loopBreak (condition : CLogic.Expr) (body increment : Stmt) (before after : State) (v : Value)
      (guard : scalar before condition v) (nonzero : v.integer≠0)
      (iteration : Exec program body before ⟨after,.breakLoop⟩) :
      Exec program (.loop condition body increment) before ⟨after,.normal⟩
  | loopReturn (condition : CLogic.Expr) (body increment : Stmt) (before after : State)
      (v : Value) (ret : Option Value) (guard : scalar before condition v) (nonzero : v.integer≠0)
      (iteration : Exec program body before ⟨after,.returned ret⟩) :
      Exec program (.loop condition body increment) before ⟨after,.returned ret⟩
  | returnVoid (s : State) : Exec program (.ret none) s ⟨s,.returned none⟩
  | returnValue (s : State) (e : Expr) (v : Value) (value : Eval s e v) :
      Exec program (.ret (some e)) s ⟨s,.returned (some v)⟩
  | breakLoop (s : State) : Exec program .breakLoop s ⟨s,.breakLoop⟩
  | continueLoop (s : State) : Exec program .continueLoop s ⟨s,.continueLoop⟩
  | call (name : Name) (args : List Arg) (destination : Destination) (f : Function)
      (before entry after : State) (result : Result) (returned : Option Value)
      (source : program name=some f) (parameters : C99ArrayReference.Bind before f.params args entry)
      (body : Exec program f.body entry result) (conversion : ReturnValue f.result result.flow returned)
      (receive : Receive destination {before with heap := result.state.heap} returned after) :
      Exec program (.call name args destination) before ⟨after,.normal⟩

theorem memory_steps (program : Program) (code : Stmt) (before : State) (result : Result)
    (h : Exec program code before result) : C99InitializationTrace.Steps before.heap result.state.heap := by
  induction h with
  | base code before after execution => exact C99ArrayReference.memory_steps _ _ _ _ execution
  | seqNormal a b before middle result first second ih1 ih2 =>
      exact C99InitializationTrace.steps_trans _ _ _ ih1 ih2
  | seqExit a b before result first exit ih => exact ih
  | scope locals pointers body before result inner ih => exact ih
  | branchTrue condition yes no before result v guard nonzero body ih => exact ih
  | branchFalse condition yes no before result v guard zero body ih => exact ih
  | loopFalse | returnVoid | returnValue | breakLoop | continueLoop => exact .done _
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      exact C99InitializationTrace.steps_trans _ _ _ ih1 (C99InitializationTrace.steps_trans _ _ _ ih2 ih3)
  | loopContinue condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      exact C99InitializationTrace.steps_trans _ _ _ ih1 (C99InitializationTrace.steps_trans _ _ _ ih2 ih3)
  | loopBreak condition body increment before after v guard nonzero iteration ih => exact ih
  | loopReturn condition body increment before after v ret guard nonzero iteration ih => exact ih
  | call name args destination f before entry after result returned source parameters body conversion receive ih =>
      have hh := receive_heap destination {before with heap := result.state.heap} after returned receive
      change after.heap=result.state.heap at hh
      rw [hh]
      rw [C99ArrayReference.bind_heap before f.params args entry parameters] at ih
      exact ih

theorem return_inversion (program : Program) (expression : Option Expr) (before : State) (result : Result)
    (h : Exec program (.ret expression) before result) :
    ∃ value, result.state=before ∧ result.flow=.returned value := by
  cases h <;> exact ⟨_,rfl,rfl⟩

theorem return_stops_sequence (program : Program) (expression : Option Expr) (tail : Stmt)
    (before : State) (result : Result) (h : Exec program (.seq (.ret expression) tail) before result) :
    ∃ value, result.state=before ∧ result.flow=.returned value := by
  cases h with
  | seqNormal _ _ _ middle _ first second =>
      obtain ⟨value,_,he⟩ := return_inversion program expression before ⟨middle,.normal⟩ first
      cases he
  | seqExit _ _ _ _ first exit => exact return_inversion program expression before result first

theorem converted_return_type (ty : Ty) (flow : Flow) (value : Value)
    (h : ReturnValue (some ty) flow (some value)) : value.type=ty := by
  cases h
  exact C99Typing.converted_type _ _

end FT1536.Source3.C99ProcedureReference
