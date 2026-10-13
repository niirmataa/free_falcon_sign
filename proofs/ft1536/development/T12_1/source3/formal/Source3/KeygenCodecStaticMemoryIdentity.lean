import Source3.KeygenCodecStaticCallRoundtrip
import Source3.KeygenCodecNoneMemoryIdentity

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Decode back into the original physical coefficient array. The decoder's
   heap effect is identity on the encoded heap; encoder output stays encoded. -/
namespace FT1536.Source3.KeygenCodecStaticMemoryIdentity
open C99MemoryReference KeygenDecodeNoneMemory
open KeygenCodecStaticRoundtrip KeygenCodecStaticCallRoundtrip

theorem source_in_place_identity (args : EncoderArgs) (before encoded after : Memory) (encoderRet suppliedLen decoderRet : BitVec 64)
    (out original : ArrayPointer) (comp : args.comp=1) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (inputs : List (BitVec 16)) (capacity : KeygenCodecStaticWire.Capacity args inputs)
    (input : args.x=some original) (separate : original.block≠out.block)
    (count : inputs.length=1536) (words : KeygenCodecStaticMaterial.Words before original inputs)
    (legal : WritableArray before original 1536) (available : encoderRet.toNat≤suppliedLen.toNat)
    (encoder : KeygenCodecExecution.Call args before encoded encoderRet)
    (decoder : KeygenDecodeStaticDispatchExecution.Call (decoderArgs args out original suppliedLen) encoded after decoderRet) :
    decoderRet=encoderRet ∧ after=encoded ∧ ∀ offset, after.bytes original.block offset=before.bytes original.block offset := by
  obtain ⟨called,encodedState,outSame,capSame,qSame,lognSame,xSame,encExec,encodedHeap⟩ :=
    KeygenCodecStaticCallMaterial.call_split args before encoded encoderRet comp encoder
  obtain ⟨decodedState,decExec,decodedHeap⟩ := KeygenDecodeStaticDispatchFacts.call_split
    (decoderArgs args out original suppliedLen) encoded after decoderRet rfl decoder
  have sameArgs := decoder_args_same args called out original suppliedLen qSame lognSame
  rw [←sameArgs,←encodedHeap] at decExec
  have cap : KeygenCodecStaticWire.Capacity called inputs := by
    unfold KeygenCodecStaticWire.Capacity
    rw [capSame]
    exact capacity
  have actual := source_roundtrip called before encodedState encoderRet suppliedLen out original original
    (qSame.trans qM0) (lognSame.trans lognM0) (outSame.trans output) inputs cap (xSame.trans input)
    separate (Ne.symm separate) count words legal available encExec decodedState (.returned decoderRet) decExec
  have originalWords := KeygenCodecStaticWire.original_preserved called before encodedState (.returned encoderRet) out original
    (qSame.trans qM0) (lognSame.trans lognM0) (outSame.trans output) inputs cap (xSame.trans input) separate count words encExec
  have reads := KeygenCodecNoneMemoryIdentity.words_readback encodedState.heap original inputs originalWords
  have sameHeap := KeygenCodecNoneMemoryIdentity.trace_identity original encodedState.heap decodedState.heap 0 inputs actual.2.1
    (by simpa only [Nat.zero_add] using reads)
  have identity : after=encoded := by simpa only [encodedHeap,decodedHeap] using sameHeap
  have writes := (KeygenCodecStaticWire.source_bytes called before encodedState (.returned encoderRet) out original
    (qSame.trans qM0) (lognSame.trans lognM0) (outSame.trans output) inputs cap (xSame.trans input) separate count words encExec).2
  refine ⟨KeygenDecodeStaticExecution.Flow.returned.inj actual.1,identity,?_⟩
  intro offset
  have unchanged := KeygenCodecByteHistory.outside _ _ _ writes original.block offset
    (fun write member => Or.inl (KeygenCodecStaticMaterial.positions_away (some out) original.block 0 _
      (by intro destination same; cases same; exact separate) write member))
  simpa only [identity,encodedHeap] using unchanged

theorem in_place_exists (args : EncoderArgs) (before encoded : Memory) (encoderRet suppliedLen : BitVec 64)
    (out original : ArrayPointer) (comp : args.comp=1) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (inputs : List (BitVec 16)) (capacity : KeygenCodecStaticWire.Capacity args inputs)
    (input : args.x=some original) (separate : original.block≠out.block)
    (count : inputs.length=1536) (words : KeygenCodecStaticMaterial.Words before original inputs)
    (legal : WritableArray before original 1536) (available : encoderRet.toNat≤suppliedLen.toNat)
    (encoder : KeygenCodecExecution.Call args before encoded encoderRet) :
    ∃ after, KeygenDecodeStaticDispatchExecution.Call (decoderArgs args out original suppliedLen) encoded after encoderRet ∧
      after=encoded ∧ ∀ offset, after.bytes original.block offset=before.bytes original.block offset := by
  obtain ⟨after,decoder,actual⟩ := call_roundtrip_exists args before encoded encoderRet suppliedLen out original original comp qM0 lognM0
    output inputs capacity input separate (Ne.symm separate) count words legal available encoder
  have identity := source_in_place_identity args before encoded after encoderRet suppliedLen encoderRet out original comp qM0 lognM0
    output inputs capacity input separate count words legal available encoder decoder
  exact ⟨after,decoder,identity.2⟩

end FT1536.Source3.KeygenCodecStaticMemoryIdentity
