import Source3.KeygenCodecStaticRoundtrip
import Source3.KeygenDecodeStaticDispatchFacts
import Source3.KeygenCodecStaticCallMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual STATIC dispatcher-to-dispatcher round-trip, retaining all real
   argument identities and observed unrestricted return indices. -/
namespace FT1536.Source3.KeygenCodecStaticCallRoundtrip
open C99MemoryReference KeygenDecodeNoneMemory
open KeygenCodecStaticRoundtrip

def CallOutcome (before after : Memory) (encoderRet decoderRet : BitVec 64)
    (dst : ArrayPointer) (inputs : List (BitVec 16)) : Prop :=
  decoderRet=encoderRet ∧ Decoded after dst inputs ∧ KeygenDecodeNoneExactFrame.Window dst 0 inputs.length before after

theorem decoder_args_same (args called : EncoderArgs) (out dst : ArrayPointer) (suppliedLen : BitVec 64)
    (q : called.q=args.q) (logn : called.logn=args.logn) :
    decoderArgs called out dst suppliedLen=decoderArgs args out dst suppliedLen := by
  simp only [decoderArgs,q,logn]

theorem source_call_roundtrip (args : EncoderArgs) (before encoded after : Memory) (encoderRet suppliedLen decoderRet : BitVec 64)
    (out original dst : ArrayPointer) (comp : args.comp=1) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (inputs : List (BitVec 16)) (capacity : KeygenCodecStaticWire.Capacity args inputs)
    (input : args.x=some original) (inputSeparate : original.block≠out.block) (outputSeparate : out.block≠dst.block)
    (count : inputs.length=1536) (words : KeygenCodecStaticMaterial.Words before original inputs)
    (legal : WritableArray before dst 1536) (available : encoderRet.toNat≤suppliedLen.toNat)
    (encoder : KeygenCodecExecution.Call args before encoded encoderRet)
    (decoder : KeygenDecodeStaticDispatchExecution.Call (decoderArgs args out dst suppliedLen) encoded after decoderRet) :
    CallOutcome encoded after encoderRet decoderRet dst inputs := by
  obtain ⟨called,encodedState,outSame,capSame,qSame,lognSame,xSame,encExec,encodedHeap⟩ :=
    KeygenCodecStaticCallMaterial.call_split args before encoded encoderRet comp encoder
  obtain ⟨decodedState,decExec,decodedHeap⟩ := KeygenDecodeStaticDispatchFacts.call_split
    (decoderArgs args out dst suppliedLen) encoded after decoderRet rfl decoder
  have sameArgs := decoder_args_same args called out dst suppliedLen qSame lognSame
  rw [←sameArgs,←encodedHeap] at decExec
  have cap : KeygenCodecStaticWire.Capacity called inputs := by
    unfold KeygenCodecStaticWire.Capacity
    rw [capSame]
    exact capacity
  have actual := source_roundtrip called before encodedState encoderRet suppliedLen out original dst
    (qSame.trans qM0) (lognSame.trans lognM0) (outSame.trans output) inputs cap (xSame.trans input)
    inputSeparate outputSeparate count words legal available encExec decodedState (.returned decoderRet) decExec
  refine ⟨KeygenDecodeStaticExecution.Flow.returned.inj actual.1,?_,?_⟩
  · simpa only [decodedHeap] using actual.2.2.1
  · simpa only [encodedHeap,decodedHeap] using actual.2.2.2

theorem call_roundtrip_exists (args : EncoderArgs) (before encoded : Memory) (encoderRet suppliedLen : BitVec 64)
    (out original dst : ArrayPointer) (comp : args.comp=1) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (inputs : List (BitVec 16)) (capacity : KeygenCodecStaticWire.Capacity args inputs)
    (input : args.x=some original) (inputSeparate : original.block≠out.block) (outputSeparate : out.block≠dst.block)
    (count : inputs.length=1536) (words : KeygenCodecStaticMaterial.Words before original inputs)
    (legal : WritableArray before dst 1536) (available : encoderRet.toNat≤suppliedLen.toNat)
    (encoder : KeygenCodecExecution.Call args before encoded encoderRet) :
    ∃ after, KeygenDecodeStaticDispatchExecution.Call (decoderArgs args out dst suppliedLen) encoded after encoderRet ∧
      CallOutcome encoded after encoderRet encoderRet dst inputs := by
  obtain ⟨called,encodedState,outSame,capSame,qSame,lognSame,xSame,encExec,encodedHeap⟩ :=
    KeygenCodecStaticCallMaterial.call_split args before encoded encoderRet comp encoder
  have cap : KeygenCodecStaticWire.Capacity called inputs := by
    unfold KeygenCodecStaticWire.Capacity
    rw [capSame]
    exact capacity
  obtain ⟨decodedState,decExec,actual⟩ := roundtrip_exists called before encodedState encoderRet suppliedLen out original dst
    (qSame.trans qM0) (lognSame.trans lognM0) (outSame.trans output) inputs cap (xSame.trans input)
    inputSeparate outputSeparate count words legal available encExec
  have sameArgs := decoder_args_same args called out dst suppliedLen qSame lognSame
  rw [sameArgs,encodedHeap] at decExec
  have calledDecoder := KeygenDecodeStaticDispatchFacts.call_exists (decoderArgs args out dst suppliedLen) encoded decodedState encoderRet rfl decExec
  exact ⟨decodedState.heap,calledDecoder,rfl,actual.2.2.1,by simpa only [encodedHeap] using actual.2.2.2⟩

end FT1536.Source3.KeygenCodecStaticCallRoundtrip
