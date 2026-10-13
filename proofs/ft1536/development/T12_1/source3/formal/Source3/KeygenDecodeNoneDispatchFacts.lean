import Source3.KeygenDecodeNoneDispatchExecution

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual NONE dispatcher branch, argument identity and fixed-body call.
   The STATIC mode is outside this mode-specific contract. -/
namespace FT1536.Source3.KeygenDecodeNoneDispatchFacts
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeNoneDispatchExecution

theorem comp_eval (args : Args) (s : State) (l : Locals) (v : C99IntegerReference.Value)
    (cell : s.locals.scalars "comp".toList=some (.int32,some (.int32 0)))
    (source : Eval args s.heap s.buf (.variable "comp".toList) s.locals (.integer v) l) :
    v=.int32 0 ∧ l=s.locals := by cases source; simp_all

theorem arguments_initial (args called : Args) (before : Memory)
    (arguments : CallArgs args (initial args before) called) : called=args := by
  have q : called.q=args.q := by simpa [initial,initialLocals] using arguments.q.symm
  have logn : called.logn=args.logn := by simpa [initial,initialLocals] using arguments.logn.symm
  have len : called.len=args.len := by simpa [initial,initialLocals] using arguments.len.symm
  have x : called.x=args.x := arguments.x
  have data := arguments.data
  have comp := arguments.metadata
  cases args; cases called
  simp_all

theorem switch_call (args : Args) (s t : State) (flow : Flow)
    (cell : s.locals.scalars "comp".toList=some (.int32,some (.int32 0)))
    (source : KeygenDecodeNoneDispatchExecution.Exec args KeygenDecodeDispatchBinding.node000 s t flow) :
    ∃ called ret, CallArgs args s called ∧ flow=.returned ret ∧
      KeygenDecodeExecution.Exec called KeygenDecodeNoneBinding.code (initial called s.heap) t (.returned ret) := by
  cases source with
  | switchStatic test a b c s t flow value locals evaluated one selected =>
    obtain ⟨same,_⟩ := comp_eval args s locals value cell evaluated
    subst value
    simp [C99IntegerReference.Value.integer] at one
  | switchOther test a b c s t flow value locals evaluated notZero notOne selected =>
    obtain ⟨same,_⟩ := comp_eval args s locals value cell evaluated
    subst value
    exact (notZero rfl).elim
  | switchNone test a b c s t flow value locals evaluated zero selected =>
    obtain ⟨same,last⟩ := comp_eval args s locals value cell evaluated
    subst locals
    cases selected with
    | ret s e value locals evaluated => cases evaluated
    | callNone called s t ret arguments execution => exact ⟨called,ret,arguments,rfl,execution⟩

/-- The complete actual dispatcher execution supplies the SAME five source
    arguments to its fixed NONE body, including both data and x pointers. -/
theorem call_split (args : Args) (before after : Memory) (ret : BitVec 64)
    (comp : args.comp=0) (source : Call args before after ret) :
    ∃ final, KeygenDecodeExecution.Exec args KeygenDecodeNoneBinding.code (initial args before) final (.returned ret) ∧ final.heap=after := by
  obtain ⟨final,source,sameHeap⟩ := source
  have cell : (initial args before).locals.scalars "comp".toList=some (.int32,some (.int32 0)) := by simp [initial,initialLocals,comp]
  cases source with
  | scope body s t flow inside =>
    cases inside with
    | seq a b s middle t flow first second =>
      obtain ⟨called,observed,arguments,impossible,execution⟩ := switch_call args _ middle .normal cell first
      cases impossible
    | seqReturn a b s t ret first =>
      obtain ⟨called,observed,arguments,flow,execution⟩ := switch_call args _ t (.returned ret) cell first
      have sameRet := Flow.returned.inj flow
      subst observed
      have sameArgs := arguments_initial args called before arguments
      subst called
      exact ⟨t,execution,sameHeap⟩

/-- A checked honest body execution constructs the actual NONE dispatcher
    execution, with evaluated comp and all five fixed call arguments. -/
theorem call_exists (args : Args) (before : Memory) (final : State) (ret : BitVec 64)
    (comp : args.comp=0)
    (body : KeygenDecodeExecution.Exec args KeygenDecodeNoneBinding.code (initial args before) final (.returned ret)) :
    Call args before final.heap ret := by
  have arguments : CallArgs args (initial args before) args :=
    ⟨rfl,rfl,by simp [initial,initialLocals],by simp [initial,initialLocals],by simp [initial,initialLocals],rfl⟩
  have selected : KeygenDecodeNoneDispatchExecution.Exec args (.ret (.call .none calleeArgs))
      (initial args before) final (.returned ret) := .callNone args args _ final ret arguments body
  have evaluated : Eval args before none (.variable "comp".toList) (initialLocals args) (.integer (.int32 0)) (initialLocals args) :=
    .scalar "comp".toList (initialLocals args) .int32 (.int32 0) (by simp [initialLocals,comp])
  have switched : KeygenDecodeNoneDispatchExecution.Exec args KeygenDecodeDispatchBinding.node000
      (initial args before) final (.returned ret) :=
    .switchNone args _ _ _ _ (initial args before) final (.returned ret) (.int32 0) (initialLocals args) evaluated rfl selected
  have inside : KeygenDecodeNoneDispatchExecution.Exec args KeygenDecodeDispatchBinding.node002
      (initial args before) final (.returned ret) := .seqReturn args _ _ _ final ret switched
  exact ⟨scopeExit KeygenDecodeDispatchBinding.node002 (initial args before) final,
    .scope args _ _ final (.returned ret) inside,rfl⟩

end FT1536.Source3.KeygenDecodeNoneDispatchFacts
