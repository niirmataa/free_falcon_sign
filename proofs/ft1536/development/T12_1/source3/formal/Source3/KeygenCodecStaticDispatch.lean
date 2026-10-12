import Source3.KeygenCodecStaticWindow

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticDispatch
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecGuardedWrite (Window)

theorem comp_eval (args : Args) (s : State) (l : Locals) (v : C99IntegerReference.Value)
    (cell : s.locals.scalars "comp".toList=some (.int32,some (.int32 1)))
    (source : Eval args s.heap s.buf (.variable "comp".toList) s.locals (.integer v) l) :
    v=.int32 1 ∧ l=s.locals := by
  cases source
  simp_all

theorem switch_call (args : Args) (s t : State) (flow : Flow)
    (cell : s.locals.scalars "comp".toList=some (.int32,some (.int32 1)))
    (source : Exec args KeygenCodecDispatchBinding.node000 s t flow) :
    ∃ called ret, CallArgs args s called ∧ flow=.returned ret ∧
      Exec called KeygenCodecStaticBinding.code (initial called s.heap) t (.returned ret) := by
  cases source with
  | switchNone args test a b c s t flow value locals evaluated zero selected =>
    obtain ⟨same,_⟩ := comp_eval args s locals value cell evaluated
    subst value
    simp [C99IntegerReference.Value.integer] at zero
  | switchOther args test a b c s t flow value locals evaluated notZero notOne selected =>
    obtain ⟨same,_⟩ := comp_eval args s locals value cell evaluated
    subst value
    exact (notOne rfl).elim
  | switchStatic args test a b c s t flow value locals evaluated one selected =>
    obtain ⟨same,sameLocals⟩ := comp_eval args s locals value cell evaluated
    subst locals
    cases selected with
    | ret args s e value locals evaluated => cases evaluated
    | call args called destination s t ret arguments execution =>
      exact ⟨called,ret,arguments,rfl,execution⟩

theorem dispatch_window (args : Args) (before after : Memory) (ret : BitVec 64)
    (dst : ArrayPointer) (out : args.out=some dst) (comp : args.comp=1)
    (source : Call args before after ret) : Window dst args.capacity.toNat before after := by
  obtain ⟨final,source,sameHeap⟩ := source
  have cell : (initial args before).locals.scalars "comp".toList=some (.int32,some (.int32 1)) := by
    simp [initial,initialLocals,comp]
  cases source with
  | scope args a s t flow noBufShadow inside =>
    cases inside with
    | seq args a b s middle t flow first second =>
      obtain ⟨called,observed,arguments,impossible,execution⟩ := switch_call args _ middle .normal cell first
      cases impossible
    | seqReturn args a b s t value first =>
      obtain ⟨called,observed,arguments,flow,execution⟩ := switch_call args _ t (.returned ret) cell first
      have capacity : called.capacity=args.capacity := by
        simpa [initial,initialLocals] using arguments.capacity.symm
      have frame := KeygenCodecStaticWindow.static_window called before t (.returned observed) dst
        (arguments.out.trans out) execution
      simpa only [←sameHeap,scopeExit,capacity] using frame

end FT1536.Source3.KeygenCodecStaticDispatch
