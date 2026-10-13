import Source3.KeygenCodecStaticDispatch

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Extend the inherited actual encoder call split with its real x argument.
   No agreement of abstract names or unrelated physical lists is assumed. -/
namespace FT1536.Source3.KeygenCodecStaticCallMaterial
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference

theorem call_split (args : Args) (before after : Memory) (ret : BitVec 64)
    (comp : args.comp=1) (source : Call args before after ret) :
    ∃ called final, called.out=args.out ∧ called.capacity=args.capacity ∧
      called.q=args.q ∧ called.logn=args.logn ∧ called.x=args.x ∧
      Exec called KeygenCodecStaticBinding.code (initial called before) final (.returned ret) ∧ final.heap=after := by
  obtain ⟨final,source,sameHeap⟩ := source
  have cell : (initial args before).locals.scalars "comp".toList=some (.int32,some (.int32 1)) := by simp [initial,initialLocals,comp]
  cases source with
  | scope args body s t flow noBufShadow inside =>
    cases inside with
    | seq args a b s middle t flow first second =>
      obtain ⟨called,observed,arguments,impossible,execution⟩ := KeygenCodecStaticDispatch.switch_call args _ middle .normal cell first
      cases impossible
    | seqReturn args a b s t ret first =>
      obtain ⟨called,observed,arguments,flow,execution⟩ := KeygenCodecStaticDispatch.switch_call args _ t (.returned ret) cell first
      have sameRet := Flow.returned.inj flow
      subst observed
      refine ⟨called,t,arguments.out,?_,?_,?_,arguments.x,execution,sameHeap⟩
      · simpa [initial,initialLocals] using arguments.capacity.symm
      · simpa [initial,initialLocals] using arguments.q.symm
      · simpa [initial,initialLocals] using arguments.logn.symm

end FT1536.Source3.KeygenCodecStaticCallMaterial
