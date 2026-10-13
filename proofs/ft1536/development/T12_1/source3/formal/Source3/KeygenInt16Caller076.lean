import Source3.KeygenInt16FourMaterial076
import Source3.KeygenCodecChainLengths

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Discharge the old mathematical-vector -> physical-word seam at ALL FOUR
   actual source call boundaries. Normal caller completion DERIVES nonzero
   codec returns; encoded bytes/length/frame are never supplied as premises. -/
namespace FT1536.Source3.KeygenInt16Caller076
open C99MemoryReference
open KeygenMakeInvocation (Env inputOf)
open KeygenCodecTypedSegments (Site arguments)
open KeygenInt16FourMaterial076 (Vectors Legal Represented)
open KeygenInt16Representation076 (wordList)

theorem chain_transport (env : Env) (s : C99ArrayReference.State)
    (headOut out : C99ProcedureReference.Result) (calls : List (Site env))
    (cells : KeygenMakeInvocation.TailCells env s)
    (chain : KeygenMakeInvocation.Encoding env KeygenMakeSkeChain.chain s headOut)
    (headNormal : headOut.flow=.normal)
    (source : KeygenCodecTypedSegments.Segments env 0 (KeygenMakeInvocation.initCounter headOut.state) out calls)
    (normal : out.flow=.normal) (comp : env.args.comp=1)
    (separate : KeygenCodecStaticCalls.Separate env) (skeSeparate : env.args.privkey.block≠env.blocks 5)
    (virtualLegal : ∀ c, c∈calls → KeygenMakeInvocation.VirtualLegal (c.site.src.block::env.live) env.vb)
    (v : Vectors) (legal : Legal headOut.state.heap (inputOf env))
    (material : Represented headOut.state.heap (inputOf env) v) :
    calls.length=4 ∧ KeygenCodecInvocation.Consecutive 0 calls ∧
    ∀ c, c∈calls →
      c.site.src=inputOf env c.index ∧
      KeygenCodecStaticMaterial.Words c.before.heap (inputOf env c.index) (wordList (v c.index)) ∧
      KeygenMaterial.Represents c.before.heap (inputOf env c.index) (v c.index) ∧
      c.ret=BitVec.ofNat 64 (KeygenCodecStaticComplete.encoded (wordList (v c.index))).length ∧
      KeygenCodecByteHistory.Trace c.before.heap c.after
        (KeygenCodecStaticHistory.positions (arguments env c.before c.index c.after c.ret c.site).out 0
          (KeygenCodecStaticComplete.encoded (wordList (v c.index)))) := by
  have physical := KeygenInt16FourMaterial076.represented_physical headOut.state.heap (inputOf env) v legal material
  have pointers := KeygenCodecTypedSegments.chain_call_material env s headOut out calls cells chain headNormal source skeSeparate virtualLegal
  have originals := KeygenCodecStaticCalls.segment_originals env 0 _ out calls source comp separate
    (fun slot => wordList (v slot)) physical
  have outcomes := KeygenCodecStaticCalls.chain_static env s headOut out calls cells chain headNormal source comp
    separate skeSeparate virtualLegal (fun slot => wordList (v slot)) (fun slot => KeygenInt16Representation076.wordList_length (v slot)) physical
  have nonzero := KeygenCodecNoneDispatch.segments_nonzero env 0 _ out calls source normal
  have count := KeygenCodecInvocation.segment_count env 0 _ out calls source normal (by decide +kernel)
  refine ⟨by simpa only [Nat.add_zero] using count,KeygenCodecInvocation.segment_order env 0 _ out calls source,?_⟩
  intro c member
  have words := originals c member c.index
  have represented := KeygenInt16Representation076.words_represents c.before.heap (inputOf env c.index) (v c.index) words
  obtain ⟨k,_,trace,ending⟩ := outcomes c member
  rcases ending with ⟨returned,complete⟩ | ⟨returned,_⟩
  · subst k
    rw [List.take_length] at trace
    exact ⟨pointers c member,words,represented,KeygenCodecExecution.Flow.returned.inj returned,trace⟩
  · exact (nonzero c member (KeygenCodecExecution.Flow.returned.inj returned)).elim

theorem witness_transport (env : Env) (s : C99ArrayReference.State)
    (headOut out : C99ProcedureReference.Result) (calls : List (Site env)) (pub : ArrayPointer)
    (cells : KeygenMakeInvocation.TailCells env s)
    (chain : KeygenMakeInvocation.Encoding env KeygenMakeSkeChain.chain s headOut)
    (headNormal : headOut.flow=.normal)
    (source : KeygenCodecTypedSegments.Segments env 0 (KeygenMakeInvocation.initCounter headOut.state) out calls)
    (normal : out.flow=.normal) (comp : env.args.comp=1)
    (separate : KeygenCodecStaticCalls.Separate env) (skeSeparate : env.args.privkey.block≠env.blocks 5)
    (virtualLegal : ∀ c, c∈calls → KeygenMakeInvocation.VirtualLegal (c.site.src.block::env.live) env.vb)
    (legal : Legal headOut.state.heap (inputOf env))
    (sourceMaterial : KeygenMakeMaterialWitness.Witness headOut.state.heap (inputOf env) pub) :
    ∃ (v : Vectors) (h fInv : Relation.Rq),
      KeygenSolverEquation.Bounds v ∧ KeygenSolverEquation.Equation v ∧
      KeygenPublicNormalizePolynomial.Represents headOut.state.heap pub h ∧
      Relation.mulRq h (Relation.reduceVec (v 0))=Relation.reduceVec (v 1) ∧
      Relation.mulRq fInv (Relation.reduceVec (v 0))=
        FT1536.Run2.CoefficientQuotient.constantCoeffs (1 : KeygenPublicAlgebra.R) ∧
      calls.length=4 ∧ KeygenCodecInvocation.Consecutive 0 calls ∧
      ∀ c, c∈calls → KeygenMaterial.Represents c.before.heap (inputOf env c.index) (v c.index) ∧
        c.ret=BitVec.ofNat 64 (KeygenCodecStaticComplete.encoded (wordList (v c.index))).length ∧
        KeygenCodecByteHistory.Trace c.before.heap c.after
          (KeygenCodecStaticHistory.positions (arguments env c.before c.index c.after c.ret c.site).out 0
            (KeygenCodecStaticComplete.encoded (wordList (v c.index)))) := by
  obtain ⟨v,h,fInv,represented,physical,signed,carrier,bounds,equation,hh,publicEq,inverseEq⟩ :=
    KeygenInt16FourMaterial076.from_witness headOut.state.heap (inputOf env) pub legal sourceMaterial
  obtain ⟨count,order,callsTransport⟩ := chain_transport env s headOut out calls cells chain headNormal source normal comp
    separate skeSeparate virtualLegal v legal represented
  exact ⟨v,h,fInv,bounds,equation,hh,publicEq,inverseEq,count,order,fun c member =>
    ⟨(callsTransport c member).2.2.1,(callsTransport c member).2.2.2.1,(callsTransport c member).2.2.2.2⟩⟩

end FT1536.Source3.KeygenInt16Caller076
