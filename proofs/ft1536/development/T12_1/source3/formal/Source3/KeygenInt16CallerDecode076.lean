import Source3.KeygenInt16Caller076

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Every actual normally completed source call produces its SAME mathematical
   vector on honest full decoding. The source caller derives success, bytes
   and length, so this export needs no codec-capacity/outcome premise. -/
namespace FT1536.Source3.KeygenInt16CallerDecode076
open C99MemoryReference
open KeygenInt16Vector076 KeygenInt16Representation076
open KeygenMakeInvocation (Env inputOf)
open KeygenCodecTypedSegments (Site arguments)
open KeygenInt16FourMaterial076 (Vectors Legal Represented)

theorem decoded_trace (args : KeygenCodecValues.Args) (before encoded : Memory)
    (ret suppliedLen : BitVec 64) (out dst : ArrayPointer) (v : Geometry.Vec)
    (qM0 : args.q=18433) (lognM0 : args.logn=10) (signed : Signed16 v)
    (returnValue : ret=BitVec.ofNat 64 (KeygenCodecStaticComplete.encoded (wordList v)).length)
    (trace : KeygenCodecByteHistory.Trace before encoded
      (KeygenCodecStaticHistory.positions (some out) 0 (KeygenCodecStaticComplete.encoded (wordList v))))
    (legal : KeygenDecodeNoneMemory.WritableArray encoded dst 1536) (separated : out.block≠dst.block)
    (available : ret.toNat≤suppliedLen.toNat) :
    ∃ after, KeygenDecodeStaticDispatchExecution.Call (KeygenCodecStaticRoundtrip.decoderArgs args out dst suppliedLen)
      encoded after ret ∧ KeygenMaterial.Represents after dst v ∧ KeygenInt16CodecMath076.IntegerReads after dst v ∧
      KeygenDecodeNoneExactFrame.Window dst 0 1536 encoded after := by
  have reads := KeygenCodecStaticWire.physical_reads out _ before encoded trace
  have extent := KeygenCodecStaticRoundtrip.observed_extent (wordList v) (wordList_length v) ret suppliedLen returnValue available
  obtain ⟨decoded,checked,writes⟩ := KeygenDecodeStaticComplete.decoder_checked
    (KeygenCodecStaticRoundtrip.decoderArgs args out dst suppliedLen) encoded (KeygenCodecExecution.byteOff out 0) dst
    qM0 lognM0 rfl rfl (wordList v) (wordList_length v) reads extent legal separated
  rw [←returnValue] at checked
  have call := KeygenDecodeStaticDispatchFacts.call_exists (KeygenCodecStaticRoundtrip.decoderArgs args out dst suppliedLen)
    encoded decoded ret rfl checked.run
  have readable := KeygenDecodeNoneMemory.trace_readback dst encoded decoded.heap 0 (wordList v) legal.1 writes
  have material := KeygenInt16CodecMath076.decoded_material decoded.heap dst v signed (by simpa only [Nat.zero_add] using readable)
  have frame := KeygenDecodeNoneExactFrame.trace_frame dst encoded decoded.heap 0 (wordList v) legal.1 writes
  rw [wordList_length] at frame
  exact ⟨decoded.heap,call,material.1,material.2,frame⟩

theorem chain_decoders (env : Env) (s : C99ArrayReference.State)
    (headOut out : C99ProcedureReference.Result) (calls : List (Site env))
    (cells : KeygenMakeInvocation.TailCells env s)
    (chain : KeygenMakeInvocation.Encoding env KeygenMakeSkeChain.chain s headOut)
    (headNormal : headOut.flow=.normal)
    (source : KeygenCodecTypedSegments.Segments env 0 (KeygenMakeInvocation.initCounter headOut.state) out calls)
    (normal : out.flow=.normal) (comp : env.args.comp=1)
    (separate : KeygenCodecStaticCalls.Separate env) (skeSeparate : env.args.privkey.block≠env.blocks 5)
    (virtualLegal : ∀ c, c∈calls → KeygenMakeInvocation.VirtualLegal (c.site.src.block::env.live) env.vb)
    (v : Vectors) (legalInput : Legal headOut.state.heap (inputOf env))
    (material : Represented headOut.state.heap (inputOf env) v) (signed : ∀ slot, Signed16 (v slot)) :
    ∀ c, c∈calls → ∀ (dst : ArrayPointer) (suppliedLen : BitVec 64),
      KeygenDecodeNoneMemory.WritableArray c.after dst 1536 → env.args.privkey.block≠dst.block →
      c.ret.toNat≤suppliedLen.toNat →
      ∃ after, KeygenDecodeStaticDispatchExecution.Call
          (KeygenCodecStaticRoundtrip.decoderArgs (arguments env c.before c.index c.after c.ret c.site)
            (KeygenMakeInvocation.byteOff env.args.privkey c.site.skoff.toNat) dst suppliedLen) c.after after c.ret ∧
        KeygenMaterial.Represents after dst (v c.index) ∧ KeygenInt16CodecMath076.IntegerReads after dst (v c.index) ∧
        KeygenDecodeNoneExactFrame.Window dst 0 1536 c.after after := by
  have sourceCalls := (KeygenInt16Caller076.chain_transport env s headOut out calls cells chain headNormal source normal comp
    separate skeSeparate virtualLegal v legalInput material).2.2
  have profiles := KeygenCodecProfile.chain_profiles env s headOut out calls cells chain source
  intro c member dst suppliedLen legalDst away available
  have profile := KeygenCodecProfile.arguments_profile env c (profiles c member)
  have values := sourceCalls c member
  have trace := values.2.2.2.2
  change KeygenCodecByteHistory.Trace c.before.heap c.after
    (KeygenCodecStaticHistory.positions (some (KeygenMakeInvocation.byteOff env.args.privkey c.site.skoff.toNat)) 0
      (KeygenCodecStaticComplete.encoded (wordList (v c.index)))) at trace
  exact decoded_trace (arguments env c.before c.index c.after c.ret c.site) c.before.heap c.after c.ret suppliedLen
    (KeygenMakeInvocation.byteOff env.args.privkey c.site.skoff.toNat) dst (v c.index) profile.1 profile.2
    (signed c.index) values.2.2.2.1 trace legalDst away available

/-- One existing source-produced witness supplies the SAME four decoded
    mathematical vectors and both public equations. Root-entry and
    accepted-attempt/encoding-tail assembly retain their prior scope. -/
theorem witness_decoders (env : Env) (s : C99ArrayReference.State)
    (headOut out : C99ProcedureReference.Result) (calls : List (Site env)) (pub : ArrayPointer)
    (cells : KeygenMakeInvocation.TailCells env s)
    (chain : KeygenMakeInvocation.Encoding env KeygenMakeSkeChain.chain s headOut)
    (headNormal : headOut.flow=.normal)
    (source : KeygenCodecTypedSegments.Segments env 0 (KeygenMakeInvocation.initCounter headOut.state) out calls)
    (normal : out.flow=.normal) (comp : env.args.comp=1)
    (separate : KeygenCodecStaticCalls.Separate env) (skeSeparate : env.args.privkey.block≠env.blocks 5)
    (virtualLegal : ∀ c, c∈calls → KeygenMakeInvocation.VirtualLegal (c.site.src.block::env.live) env.vb)
    (legalInput : Legal headOut.state.heap (inputOf env))
    (sourceMaterial : KeygenMakeMaterialWitness.Witness headOut.state.heap (inputOf env) pub) :
    ∃ (v : Vectors) (h fInv : Relation.Rq),
      KeygenSolverEquation.Bounds v ∧ KeygenSolverEquation.Equation v ∧
      KeygenPublicNormalizePolynomial.Represents headOut.state.heap pub h ∧
      Relation.mulRq h (Relation.reduceVec (v 0))=Relation.reduceVec (v 1) ∧
      Relation.mulRq fInv (Relation.reduceVec (v 0))=
        FT1536.Run2.CoefficientQuotient.constantCoeffs (1 : KeygenPublicAlgebra.R) ∧
      ∀ c, c∈calls → ∀ (dst : ArrayPointer) (suppliedLen : BitVec 64),
        KeygenDecodeNoneMemory.WritableArray c.after dst 1536 → env.args.privkey.block≠dst.block →
        c.ret.toNat≤suppliedLen.toNat →
        ∃ after, KeygenDecodeStaticDispatchExecution.Call
            (KeygenCodecStaticRoundtrip.decoderArgs (arguments env c.before c.index c.after c.ret c.site)
              (KeygenMakeInvocation.byteOff env.args.privkey c.site.skoff.toNat) dst suppliedLen) c.after after c.ret ∧
          KeygenMaterial.Represents after dst (v c.index) ∧ KeygenInt16CodecMath076.IntegerReads after dst (v c.index) ∧
          KeygenDecodeNoneExactFrame.Window dst 0 1536 c.after after := by
  obtain ⟨v,h,fInv,represented,physical,signed,carrier,bounds,equation,hh,publicEq,inverseEq⟩ :=
    KeygenInt16FourMaterial076.from_witness headOut.state.heap (inputOf env) pub legalInput sourceMaterial
  exact ⟨v,h,fInv,bounds,equation,hh,publicEq,inverseEq,
    chain_decoders env s headOut out calls cells chain headNormal source normal comp separate skeSeparate
      virtualLegal v legalInput represented signed⟩

end FT1536.Source3.KeygenInt16CallerDecode076
