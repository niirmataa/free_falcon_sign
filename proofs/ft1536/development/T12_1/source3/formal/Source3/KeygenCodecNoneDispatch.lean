import Source3.KeygenCodecNoneReturn
import Source3.KeygenCodecInvocation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecNoneDispatch
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecGuardedWrite (Window)

theorem comp_eval (args : Args) (s : State) (l : Locals) (v : C99IntegerReference.Value)
    (cell : s.locals.scalars "comp".toList=some (.int32,some (.int32 0)))
    (source : Eval args s.heap s.buf (.variable "comp".toList) s.locals (.integer v) l) :
    v=.int32 0 ∧ l=s.locals := by
  cases source
  simp_all

theorem switch_call (args : Args) (s t : State) (flow : Flow)
    (cell : s.locals.scalars "comp".toList=some (.int32,some (.int32 0)))
    (source : Exec args KeygenCodecDispatchBinding.node000 s t flow) :
    ∃ called ret, CallArgs args s called ∧ flow=.returned ret ∧
      Exec called KeygenCodecNoneBinding.code (initial called s.heap) t (.returned ret) := by
  cases source with
  | switchStatic args test a b c s t flow value locals evaluated one selected =>
    obtain ⟨same,_⟩ := comp_eval args s locals value cell evaluated
    subst value
    simp [C99IntegerReference.Value.integer] at one
  | switchOther args test a b c s t flow value locals evaluated notZero notOne selected =>
    obtain ⟨same,_⟩ := comp_eval args s locals value cell evaluated
    subst value
    exact (notZero rfl).elim
  | switchNone args test a b c s t flow value locals evaluated zero selected =>
    obtain ⟨same,last⟩ := comp_eval args s locals value cell evaluated
    subst locals
    cases selected with
    | ret args s e value locals evaluated => cases evaluated
    | call args called destination s t ret arguments execution => exact ⟨called,ret,arguments,rfl,execution⟩

theorem call_split (args : Args) (before after : Memory) (ret : BitVec 64)
    (comp : args.comp=0) (source : Call args before after ret) :
    ∃ called final, called.out=args.out ∧ called.capacity=args.capacity ∧
      called.q=args.q ∧ called.logn=args.logn ∧
      Exec called KeygenCodecNoneBinding.code (initial called before) final (.returned ret) ∧ final.heap=after := by
  obtain ⟨final,source,sameHeap⟩ := source
  have cell : (initial args before).locals.scalars "comp".toList=some (.int32,some (.int32 0)) := by simp [initial,initialLocals,comp]
  cases source with
  | scope args a s t flow noBufShadow inside =>
    cases inside with
    | seq args a b s middle t flow first second =>
      obtain ⟨called,observed,arguments,impossible,execution⟩ := switch_call args _ middle .normal cell first
      cases impossible
    | seqReturn args a b s t value first =>
      obtain ⟨called,observed,arguments,flow,execution⟩ := switch_call args _ t (.returned ret) cell first
      have sameRet : ret=observed := Flow.returned.inj flow
      subst observed
      refine ⟨called,t,arguments.out,?_,?_,?_,execution,sameHeap⟩
      · simpa [initial,initialLocals] using arguments.capacity.symm
      · simpa [initial,initialLocals] using arguments.q.symm
      · simpa [initial,initialLocals] using arguments.logn.symm

theorem dispatch_result (args : Args) (before after : Memory) (ret : BitVec 64)
    (comp : args.comp=0) (q : args.q=18433) (logn : args.logn=10)
    (source : Call args before after ret) : ret=KeygenCodecNoneReturn.result args := by
  obtain ⟨called,final,out,capacity,qSame,lognSame,execution,_⟩ := call_split args before after ret comp source
  have flow := KeygenCodecNoneReturn.none_return called before final (.returned ret) (qSame.trans q) (lognSame.trans logn) execution
  have equal := Flow.returned.inj flow
  simpa only [KeygenCodecNoneReturn.result,out,capacity] using equal

theorem dispatch_window (args : Args) (before after : Memory) (ret : BitVec 64) (dst : ArrayPointer)
    (comp : args.comp=0) (q : args.q=18433) (logn : args.logn=10) (out : args.out=some dst)
    (source : Call args before after ret) : Window dst args.capacity.toNat before after := by
  obtain ⟨called,final,outSame,capacity,qSame,lognSame,execution,sameHeap⟩ := call_split args before after ret comp source
  have window := KeygenCodecNoneWhole.none_window called before final (.returned ret) dst (qSame.trans q) (lognSame.trans logn) (outSame.trans out) execution
  simpa only [capacity,sameHeap] using window

theorem segments_nonzero (env : KeygenMakeInvocation.Env) (i : Nat) (s : C99ArrayReference.State)
    (out : C99ProcedureReference.Result) (calls : List (KeygenCodecTypedSegments.Site env))
    (source : KeygenCodecTypedSegments.Segments env i s out calls) (normal : out.flow=.normal) :
    ∀ c, c∈calls → c.ret≠0 := by
  induction source with
  | done => intro c member; cases member
  | capacity => cases normal
  | next c counter nonzero skoff skoffCell rest ih =>
    intro site member
    rcases List.mem_cons.mp member with same | later
    · subst site; exact nonzero
    · exact ih normal site later

/-- The same successful invocation supplies all four NONE results, actual
    capacities and windows. Array POINTER identity remains distinct from
    the still-open coefficient-word/decoded-byte identity. -/
theorem invocation_none (env : KeygenMakeInvocation.Env) (caller : C99ArrayReference.State)
    (events : List KeygenEntropySource.Event) (out : C99ProcedureReference.Result)
    (calls : List (KeygenCodecTypedSegments.Site env))
    (source : KeygenCodecInvocation.Invocation env caller events out calls)
    (success : out.flow=.returned (some (.int32 1))) (comp : env.args.comp=0)
    (separate : env.args.privkey.block≠env.blocks 5)
    (legal : ∀ c, c∈calls → KeygenMakeInvocation.VirtualLegal (c.site.src.block::env.live) env.vb) :
    calls.length=4 ∧ KeygenCodecInvocation.Consecutive 0 calls ∧
    ∀ c, c∈calls →
      c.site.src=KeygenMakeInvocation.inputOf env c.index ∧ c.ret=3072 ∧
      3072≤(KeygenCodecTypedSegments.arguments env c.before c.index c.after c.ret c.site).capacity.toNat ∧
      Window (KeygenCodecSkeSurvival.destination env c.before c.index c.after c.ret c.site)
        (KeygenCodecTypedSegments.arguments env c.before c.index c.after c.ret c.site).capacity.toNat c.before.heap c.after := by
  have count := KeygenCodecInvocation.invocation_four_calls env caller events out calls source success
  have facts := KeygenCodecInvocation.invocation_calls env caller events out calls source success separate legal
  obtain ⟨entry,middle,final,cells,pre,segments,projection⟩ := KeygenCodecInvocation.invocation_trace env caller events out calls source success
  have nonzero := segments_nonzero env 0 _ _ calls segments rfl
  refine ⟨count.1,count.2,fun c member => ?_⟩
  have profile := facts c member
  have result := dispatch_result _ _ _ c.ret comp profile.2.1 profile.2.2 c.execution
  have nonNull : (KeygenCodecTypedSegments.arguments env c.before c.index c.after c.ret c.site).out≠none := by intro impossible; cases impossible
  have formula : c.ret=(if (KeygenCodecTypedSegments.arguments env c.before c.index c.after c.ret c.site).capacity.toNat<3072 then 0 else 3072) := by
    simpa only [KeygenCodecNoneReturn.result,nonNull,ite_false] using result
  have enough : 3072≤(KeygenCodecTypedSegments.arguments env c.before c.index c.after c.ret c.site).capacity.toNat := by
    by_cases short : (KeygenCodecTypedSegments.arguments env c.before c.index c.after c.ret c.site).capacity.toNat<3072
    · have zero : c.ret=0 := by simpa only [short,ite_true] using formula
      exact (nonzero c member zero).elim
    · omega
  have length : c.ret=3072 := by
    simpa only [show ¬(KeygenCodecTypedSegments.arguments env c.before c.index c.after c.ret c.site).capacity.toNat<3072 by omega,ite_false] using formula
  exact ⟨profile.1,length,enough,dispatch_window _ _ _ c.ret _ comp profile.2.1 profile.2.2 rfl c.execution⟩

end FT1536.Source3.KeygenCodecNoneDispatch
