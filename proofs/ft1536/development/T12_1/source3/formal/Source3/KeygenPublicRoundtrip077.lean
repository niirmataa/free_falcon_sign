import Source3.KeygenPublicDecodeComplete077
import Source3.KeygenCodecStaticWire
import Source3.KeygenCodecNoneMemoryIdentity

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicRoundtrip077
open C99MemoryReference
abbrev EncoderArgs := KeygenCodecValues.Args
abbrev DecoderArgs := KeygenDecodeValues.Args
def decoderArgs (args : EncoderArgs) (out dst : ArrayPointer) (length : BitVec 64) : DecoderArgs :=
  { data := some (KeygenCodecExecution.byteOff out 0), len := length, comp := 0, q := 0, x := some dst, logn := args.logn }

/-- Source input and legal-memory domain only. No codec result, output bytes,
    encoded length, successful return or memory frame is supplied. -/
structure Entry (args : EncoderArgs) (before : Memory) (out original dst : ArrayPointer) (inputs : List (BitVec 16)) : Prop where
  logn : args.logn=10
  output : args.out=some out
  input : args.x=some original
  count : inputs.length=1536
  canonical : KeygenPublicBits077.Canonical inputs
  capacity : 2880≤args.capacity.toNat
  words : KeygenCodecStaticMaterial.Words before original inputs
  outputLegal : KeygenPublicEncodeReady077.WritableBytes before out 2880
  destinationLegal : KeygenDecodeNoneMemory.WritableArray before dst 1536
  inputSeparate : original.block≠out.block
  destinationSeparate : out.block≠dst.block

theorem encoded_facts (args : EncoderArgs) (before encoded : Memory) (ret : BitVec 64)
    (out original dst : ArrayPointer) (inputs : List (BitVec 16))
    (entry : Entry args before out original dst inputs) (source : KeygenPublicEncodeExecution077.Call args before encoded ret) :
    ret=2880 ∧ KeygenDecodeStaticWire.Reads encoded (KeygenCodecExecution.byteOff out 0) 0 (KeygenPublicBits077.encoded inputs) ∧
      KeygenDecodeNoneMemory.WritableArray encoded dst 1536 ∧ KeygenCodecStaticMaterial.Preserved original.block before encoded := by
  obtain ⟨value,trace⟩ := KeygenPublicEncodeComplete077.source_outcome args before encoded ret out original inputs
    entry.logn entry.output entry.input entry.count entry.capacity entry.words entry.outputLegal entry.inputSeparate source
  have sizes := KeygenCodecStaticMaterial.trace_sizes _ _ _ trace
  have writable := KeygenCodecStaticWire.trace_writable _ _ _ trace
  exact ⟨value,KeygenCodecStaticWire.physical_reads out _ before encoded trace,
    ⟨entry.destinationLegal.1,by rw [writable]; exact entry.destinationLegal.2.1,
      fun i bound => by simpa only [Allocated,sizes] using entry.destinationLegal.2.2 i bound⟩,
    KeygenPublicEncodeLoop077.input_frame before encoded out original 0 _ entry.inputSeparate trace⟩

theorem source_roundtrip (args : EncoderArgs) (before encoded after : Memory)
    (encoderRet suppliedLen decoderRet : BitVec 64) (out original dst : ArrayPointer) (inputs : List (BitVec 16))
    (entry : Entry args before out original dst inputs) (available : encoderRet.toNat≤suppliedLen.toNat)
    (encoder : KeygenPublicEncodeExecution077.Call args before encoded encoderRet)
    (decoder : KeygenPublicDecodeExecution077.Call (decoderArgs args out dst suppliedLen) encoded after decoderRet) :
    encoderRet=2880 ∧ decoderRet=suppliedLen ∧ KeygenDecodeNoneMemory.Trace dst encoded after 0 inputs ∧
      (∀ i : Fin inputs.length, KeygenDecodeValues.Load16 after (KeygenDecodeNoneMemory.element dst i.val) inputs[i]) ∧
      KeygenDecodeNoneExactFrame.Window dst 0 inputs.length encoded after := by
  obtain ⟨returned,reads,legal,_⟩ := encoded_facts args before encoded encoderRet out original dst inputs entry encoder
  have extent : (KeygenPublicBits077.encoded inputs).length≤suppliedLen.toNat := by
    rw [(KeygenPublicBits077.source_profile_lengths inputs entry.count).1]
    rw [returned] at available
    exact available
  have result := KeygenPublicDecodeComplete077.source_outcome (decoderArgs args out dst suppliedLen) encoded after decoderRet
    (KeygenCodecExecution.byteOff out 0) dst inputs entry.logn rfl rfl entry.count entry.canonical reads extent legal entry.destinationSeparate decoder
  exact ⟨returned,result⟩

theorem roundtrip_exists (args : EncoderArgs) (before encoded : Memory) (encoderRet suppliedLen : BitVec 64)
    (out original dst : ArrayPointer) (inputs : List (BitVec 16)) (entry : Entry args before out original dst inputs)
    (available : encoderRet.toNat≤suppliedLen.toNat) (encoder : KeygenPublicEncodeExecution077.Call args before encoded encoderRet) :
    ∃ after decoderRet, KeygenPublicDecodeExecution077.Call (decoderArgs args out dst suppliedLen) encoded after decoderRet ∧
      encoderRet=2880 ∧ decoderRet=suppliedLen ∧ KeygenDecodeNoneMemory.Trace dst encoded after 0 inputs := by
  obtain ⟨returned,reads,legal,_⟩ := encoded_facts args before encoded encoderRet out original dst inputs entry encoder
  have extent : (KeygenPublicBits077.encoded inputs).length≤suppliedLen.toNat := by
    rw [(KeygenPublicBits077.source_profile_lengths inputs entry.count).1]
    rw [returned] at available
    exact available
  obtain ⟨after,ret,source,value,trace⟩ := KeygenPublicDecodeComplete077.decoder_exists (decoderArgs args out dst suppliedLen) encoded
    (KeygenCodecExecution.byteOff out 0) dst inputs entry.logn rfl rfl entry.count entry.canonical reads extent legal entry.destinationSeparate
  exact ⟨after,ret,source,returned,value,trace⟩

theorem honest_roundtrip_exists (args : EncoderArgs) (before : Memory) (out original dst : ArrayPointer)
    (inputs : List (BitVec 16)) (entry : Entry args before out original dst inputs) :
    ∃ encoded after encoderRet decoderRet,
      KeygenPublicEncodeExecution077.Call args before encoded encoderRet ∧
      KeygenPublicDecodeExecution077.Call (decoderArgs args out dst encoderRet) encoded after decoderRet ∧
      encoderRet=2880 ∧ decoderRet=encoderRet ∧ KeygenDecodeNoneMemory.Trace dst encoded after 0 inputs := by
  obtain ⟨encoded,encoderRet,encoder,_,_⟩ := KeygenPublicEncodeComplete077.encoder_exists args before out original inputs
    entry.logn entry.output entry.input entry.count entry.capacity entry.words entry.outputLegal entry.inputSeparate
  obtain ⟨after,decoderRet,decoder,returned,value,trace⟩ := roundtrip_exists args before encoded encoderRet encoderRet out original dst inputs
    entry (Nat.le_refl _) encoder
  exact ⟨encoded,after,encoderRet,decoderRet,encoder,decoder,returned,value,trace⟩

theorem in_place_identity (args : EncoderArgs) (before encoded after : Memory)
    (encoderRet suppliedLen decoderRet : BitVec 64) (out original : ArrayPointer) (inputs : List (BitVec 16))
    (entry : Entry args before out original original inputs) (available : encoderRet.toNat≤suppliedLen.toNat)
    (encoder : KeygenPublicEncodeExecution077.Call args before encoded encoderRet)
    (decoder : KeygenPublicDecodeExecution077.Call (decoderArgs args out original suppliedLen) encoded after decoderRet) :
    after=encoded ∧ ∀ offset, after.bytes original.block offset=before.bytes original.block offset := by
  have result := source_roundtrip args before encoded after encoderRet suppliedLen decoderRet out original original inputs entry available encoder decoder
  have preserved := (encoded_facts args before encoded encoderRet out original original inputs entry encoder).2.2.2
  have words := KeygenCodecStaticMaterial.words_preserved original.block before encoded preserved original rfl inputs entry.words
  have reads := KeygenCodecNoneMemoryIdentity.words_readback encoded original inputs words
  have identity := KeygenCodecNoneMemoryIdentity.trace_identity original encoded after 0 inputs result.2.2.1
    (by simpa only [Nat.zero_add] using reads)
  exact ⟨identity,fun offset => by rw [identity]; exact preserved.bytes offset⟩

end FT1536.Source3.KeygenPublicRoundtrip077
