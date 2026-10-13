import Source3.KeygenCodecStaticComplete
import Source3.KeygenCodecStaticDispatch

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticCall
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticMaterial KeygenCodecStaticComplete

/-- Actual dispatcher, actual evaluated five callee arguments and actual
    return. The caller supplies only physical input words and separation. -/
theorem call_outcome (args : Args) (before after : Memory) (ret : BitVec 64)
    (comp : args.comp=1) (q : args.q=18433) (logn : args.logn=10)
    (ptr : ArrayPointer) (held : args.x=some ptr) (inputs : List (BitVec 16))
    (length : inputs.length=1536) (words : Words before ptr inputs)
    (separate : Separated args.out ptr.block) (source : Call args before after ret) :
    Outcome args before after (encoded inputs) (.returned ret) := by
  obtain ⟨final,source,sameHeap⟩ := source
  have cell : (initial args before).locals.scalars "comp".toList=some (.int32,some (.int32 1)) := by
    simp [initial,initialLocals,comp]
  cases source with
  | scope args a s t flow noBufShadow inside =>
    cases inside with
    | seq args a b s middle t flow first second =>
      obtain ⟨called,observed,arguments,impossible,execution⟩ :=
        KeygenCodecStaticDispatch.switch_call args _ middle .normal cell first
      cases impossible
    | seqReturn args a b s t value first =>
      obtain ⟨called,observed,arguments,flow,execution⟩ :=
        KeygenCodecStaticDispatch.switch_call args _ t (.returned ret) cell first
      have capacity : called.capacity=args.capacity := by simpa [initial,initialLocals] using arguments.capacity.symm
      have cq : called.q=args.q := by simpa [initial,initialLocals] using arguments.q.symm
      have clogn : called.logn=args.logn := by simpa [initial,initialLocals] using arguments.logn.symm
      have cx : called.x=args.x := arguments.x
      have observedEq : ret=observed := Flow.returned.inj flow
      subst observed
      have outcome := source_outcome called before t (.returned ret) (cq.trans q) (clogn.trans logn)
        ptr (cx.trans held) inputs length words (by rw [arguments.out]; exact separate) execution
      simpa only [Outcome,arguments.out,capacity,←sameHeap,scopeExit] using outcome

end FT1536.Source3.KeygenCodecStaticCall
