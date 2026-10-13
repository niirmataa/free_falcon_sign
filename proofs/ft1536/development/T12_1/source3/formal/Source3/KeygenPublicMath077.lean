import Source3.KeygenPublicMaterial077
import Source3.KeygenMakeMaterialWitness

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicMath077
open C99MemoryReference KeygenPublicRoundtrip077

/-- Only actual argument identity, M0 profile and legal memory capacity.
    The canonical words and SAME h are derived from the source material. -/
structure Legal (args : EncoderArgs) (before : Memory) (out original dst : ArrayPointer) : Prop where
  logn : args.logn=10
  output : args.out=some out
  input : args.x=some original
  capacity : 2880≤args.capacity.toNat
  outputLegal : KeygenPublicEncodeReady077.WritableBytes before out 2880
  destinationLegal : KeygenDecodeNoneMemory.WritableArray before dst 1536
  inputSeparate : original.block≠out.block
  destinationSeparate : out.block≠dst.block

theorem source_roundtrip (args : EncoderArgs) (before encoded after : Memory)
    (encoderRet suppliedLen decoderRet : BitVec 64) (out original dst : ArrayPointer) (h : Relation.Rq)
    (legal : Legal args before out original dst)
    (represented : KeygenPublicNormalizePolynomial.Represents before original h)
    (available : encoderRet.toNat≤suppliedLen.toNat)
    (encoder : KeygenPublicEncodeExecution077.Call args before encoded encoderRet)
    (decoder : KeygenPublicDecodeExecution077.Call (decoderArgs args out dst suppliedLen) encoded after decoderRet) :
    encoderRet=2880 ∧ decoderRet=suppliedLen ∧ KeygenPublicNormalizePolynomial.Represents after dst h ∧
      KeygenDecodeNoneExactFrame.Window dst 0 1536 encoded after := by
  obtain ⟨inputs,count,canonical,words,realizes⟩ := KeygenPublicMaterial077.represented_words before original h represented
  have entry : Entry args before out original dst inputs :=
    ⟨legal.logn,legal.output,legal.input,count,canonical,legal.capacity,words,legal.outputLegal,
      legal.destinationLegal,legal.inputSeparate,legal.destinationSeparate⟩
  obtain ⟨returned,value,_,reads,frame⟩ := KeygenPublicRoundtrip077.source_roundtrip args before encoded after
    encoderRet suppliedLen decoderRet out original dst inputs entry available encoder decoder
  rw [count] at frame
  exact ⟨returned,value,KeygenPublicMaterial077.decoded_represents after dst h inputs canonical realizes reads,frame⟩

theorem honest_roundtrip_exists (args : EncoderArgs) (before : Memory) (out original dst : ArrayPointer) (h : Relation.Rq)
    (legal : Legal args before out original dst) (represented : KeygenPublicNormalizePolynomial.Represents before original h) :
    ∃ encoded after encoderRet decoderRet, KeygenPublicEncodeExecution077.Call args before encoded encoderRet ∧
      KeygenPublicDecodeExecution077.Call (decoderArgs args out dst encoderRet) encoded after decoderRet ∧
      encoderRet=2880 ∧ decoderRet=encoderRet ∧ KeygenPublicNormalizePolynomial.Represents after dst h := by
  obtain ⟨inputs,count,canonical,words,_⟩ := KeygenPublicMaterial077.represented_words before original h represented
  have entry : Entry args before out original dst inputs :=
    ⟨legal.logn,legal.output,legal.input,count,canonical,legal.capacity,words,legal.outputLegal,
      legal.destinationLegal,legal.inputSeparate,legal.destinationSeparate⟩
  obtain ⟨encoded,after,encoderRet,decoderRet,encoder,decoder,value,returned,_⟩ :=
    KeygenPublicRoundtrip077.honest_roundtrip_exists args before out original dst inputs entry
  have result := source_roundtrip args before encoded after encoderRet encoderRet decoderRet out original dst h legal represented
    (Nat.le_refl _) encoder decoder
  exact ⟨encoded,after,encoderRet,decoderRet,encoder,decoder,value,returned,result.2.2.1⟩

theorem from_witness (args : EncoderArgs) (before encoded after : Memory)
    (encoderRet suppliedLen decoderRet : BitVec 64) (out pub dst : ArrayPointer) (input : Fin 4 → ArrayPointer)
    (legal : Legal args before out pub dst) (witness : KeygenMakeMaterialWitness.Witness before input pub)
    (available : encoderRet.toNat≤suppliedLen.toNat)
    (encoder : KeygenPublicEncodeExecution077.Call args before encoded encoderRet)
    (decoder : KeygenPublicDecodeExecution077.Call (decoderArgs args out dst suppliedLen) encoded after decoderRet) :
    encoderRet=2880 ∧ decoderRet=suppliedLen ∧
    ∃ (fv gv F G : Geometry.Vec) (h fInv : Relation.Rq),
      KeygenMaterial.Represents before (input 0) fv ∧ KeygenMaterial.Represents before (input 1) gv ∧
      KeygenMaterial.Represents before (input 2) F ∧ KeygenMaterial.Represents before (input 3) G ∧
      KeygenPublicNormalizePolynomial.Represents before pub h ∧ KeygenPublicNormalizePolynomial.Represents after dst h ∧
      KeygenSolverEquation.Bounds (KeygenOutputGateValidation.material fv gv F G) ∧
      KeygenSolverEquation.Equation (KeygenOutputGateValidation.material fv gv F G) ∧
      Relation.mulRq h (Relation.reduceVec fv)=Relation.reduceVec gv ∧
      Relation.mulRq fInv (Relation.reduceVec fv)=FT1536.Run2.CoefficientQuotient.constantCoeffs (1 : KeygenPublicAlgebra.R) := by
  obtain ⟨fv,gv,F,G,h,fInv,fRep,gRep,FRep,GRep,hRep,bounds,ntru,publicEq,inverse⟩ := witness
  have result := source_roundtrip args before encoded after encoderRet suppliedLen decoderRet out pub dst h legal hRep available encoder decoder
  exact ⟨result.1,result.2.1,fv,gv,F,G,h,fInv,fRep,gRep,FRep,GRep,hRep,result.2.2.1,bounds,ntru,publicEq,inverse⟩

end FT1536.Source3.KeygenPublicMath077
