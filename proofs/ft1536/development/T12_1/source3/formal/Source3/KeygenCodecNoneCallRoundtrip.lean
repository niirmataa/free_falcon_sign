import Source3.KeygenCodecNoneRoundtrip
import Source3.KeygenDecodeNoneDispatchFacts
import Source3.KeygenCodecNoneCallMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- NONE source dispatcher-to-dispatcher memory round-trip, with actual
   five-argument identity, observed unrestricted returns and honest decoder
   call existence. STATIC remains outside this mode-specific contract. -/
namespace FT1536.Source3.KeygenCodecNoneCallRoundtrip
open C99MemoryReference
open KeygenCodecNoneRoundtrip KeygenDecodeNoneMemory
open KeygenDecodeNonePairs (CarrierList)

def CallOutcome (before after : Memory) (ret : BitVec 64) (dst : ArrayPointer) (inputs : List (BitVec 16)) : Prop :=
  ret=3072 ∧ Decoded after dst inputs ∧ KeygenDecodeNoneExactFrame.Window dst 0 inputs.length before after

theorem decoder_args_same (args called : EncoderArgs) (out dst : ArrayPointer) (suppliedLen : BitVec 64)
    (q : called.q=args.q) (logn : called.logn=args.logn) :
    decoderArgs called out dst suppliedLen=decoderArgs args out dst suppliedLen := by
  simp only [decoderArgs,q,logn]

/-- Complete actual encoder/decoder dispatcher calls recover the SAME
    original physical words. Both codec returns are observed indices;
    no desired result, encoded length, output bytes or frame is assumed. -/
theorem source_call_roundtrip (args : EncoderArgs) (before encoded after : Memory) (encoderRet suppliedLen decoderRet : BitVec 64)
    (out original dst : ArrayPointer) (comp : args.comp=0) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (capacity : 3072≤args.capacity.toNat) (input : args.x=some original)
    (inputSeparate : original.block≠out.block) (outputSeparate : out.block≠dst.block)
    (inputs : List (BitVec 16)) (count : inputs.length=1536) (carrier : CarrierList inputs)
    (words : KeygenCodecStaticMaterial.Words before original inputs) (legal : WritableArray before dst 1536)
    (available : encoderRet.toNat≤suppliedLen.toNat)
    (encoder : KeygenCodecExecution.Call args before encoded encoderRet)
    (decoder : KeygenDecodeNoneDispatchExecution.Call (decoderArgs args out dst suppliedLen) encoded after decoderRet) :
    CallOutcome encoded after decoderRet dst inputs := by
  obtain ⟨called,encodedState,outSame,capSame,qSame,lognSame,xSame,encExec,encodedHeap⟩ :=
    KeygenCodecNoneCallMaterial.call_split args before encoded encoderRet comp encoder
  obtain ⟨decodedState,decExec,decodedHeap⟩ := KeygenDecodeNoneDispatchFacts.call_split
    (decoderArgs args out dst suppliedLen) encoded after decoderRet rfl decoder
  have sameArgs := decoder_args_same args called out dst suppliedLen qSame lognSame
  rw [←sameArgs,←encodedHeap] at decExec
  have cap : 3072≤called.capacity.toNat := by rw [capSame]; exact capacity
  have actual := source_roundtrip called before encodedState encoderRet suppliedLen out original dst
    (qSame.trans qM0) (lognSame.trans lognM0) (outSame.trans output) cap (xSame.trans input)
    inputSeparate outputSeparate inputs count carrier words legal available encExec decodedState (.returned decoderRet) decExec
  refine ⟨KeygenDecodeExecution.Flow.returned.inj actual.1,?_,?_⟩
  · simpa only [decodedHeap] using actual.2.2.1
  · simpa only [encodedHeap,decodedHeap] using actual.2.2.2

/-- The actual encoder dispatcher output admits an honest complete NONE
    decoder dispatcher call, even with arbitrary old destination contents.
    Additional supplied tail bytes have no restrictions on their values. -/
theorem call_roundtrip_exists (args : EncoderArgs) (before encoded : Memory) (encoderRet suppliedLen : BitVec 64)
    (out original dst : ArrayPointer) (comp : args.comp=0) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (capacity : 3072≤args.capacity.toNat) (input : args.x=some original)
    (inputSeparate : original.block≠out.block) (outputSeparate : out.block≠dst.block)
    (inputs : List (BitVec 16)) (count : inputs.length=1536) (carrier : CarrierList inputs)
    (words : KeygenCodecStaticMaterial.Words before original inputs) (legal : WritableArray before dst 1536)
    (available : encoderRet.toNat≤suppliedLen.toNat)
    (encoder : KeygenCodecExecution.Call args before encoded encoderRet) :
    ∃ after, KeygenDecodeNoneDispatchExecution.Call (decoderArgs args out dst suppliedLen) encoded after 3072 ∧
      CallOutcome encoded after 3072 dst inputs := by
  obtain ⟨called,encodedState,outSame,capSame,qSame,lognSame,xSame,encExec,encodedHeap⟩ :=
    KeygenCodecNoneCallMaterial.call_split args before encoded encoderRet comp encoder
  have cap : 3072≤called.capacity.toNat := by rw [capSame]; exact capacity
  obtain ⟨decodedState,decExec,actual⟩ := roundtrip_exists called before encodedState encoderRet suppliedLen out original dst
    (qSame.trans qM0) (lognSame.trans lognM0) (outSame.trans output) cap (xSame.trans input)
    inputSeparate outputSeparate inputs count carrier words legal available encExec
  have sameArgs := decoder_args_same args called out dst suppliedLen qSame lognSame
  rw [sameArgs,encodedHeap] at decExec
  have calledDecoder := KeygenDecodeNoneDispatchFacts.call_exists (decoderArgs args out dst suppliedLen) encoded decodedState 3072 rfl decExec
  exact ⟨decodedState.heap,calledDecoder,rfl,actual.2.2.1,by simpa only [encodedHeap] using actual.2.2.2⟩

end FT1536.Source3.KeygenCodecNoneCallRoundtrip
