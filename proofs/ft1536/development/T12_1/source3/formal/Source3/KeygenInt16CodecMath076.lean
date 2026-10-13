import Source3.KeygenInt16Bounds076

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Link the SAME existing mathematical material to BOTH complete source
   codec round-trips. Decoded mathematical equality is a consequence of
   actual physical reads, not an assumed agreement/codec correctness flag. -/
namespace FT1536.Source3.KeygenInt16CodecMath076
open C99MemoryReference
open KeygenInt16Vector076 KeygenInt16Representation076
open KeygenDecodeNoneMemory (WritableArray element)

def IntegerReads (heap : Memory) (ptr : ArrayPointer) (v : Geometry.Vec) : Prop :=
  ∀ i : Fin 1536, ∃ word : BitVec 16, KeygenCodecValues.Load16 heap (element ptr i.val) word ∧
    word.toInt=coefficient v i

theorem decoded_material (heap : Memory) (ptr : ArrayPointer) (v : Geometry.Vec) (signed : Signed16 v)
    (decoded : ∀ i : Fin (wordList v).length,
      KeygenDecodeValues.Load16 heap (element ptr i.val) (wordList v)[i]) :
    KeygenMaterial.Represents heap ptr v ∧ IntegerReads heap ptr v := by
  have input : KeygenCodecStaticMaterial.Words heap ptr (wordList v) := by
    apply KeygenInt16Words076.from_reads
    intro i
    exact KeygenInt16Reads076.decoder_read heap _ _ (decoded i)
  have indexed := words_indexed heap ptr v input
  exact ⟨words_represents heap ptr v input,fun i => ⟨words v i,indexed i,word_integer v signed i⟩⟩

theorem static_roundtrip (args : KeygenCodecValues.Args) (before encoded after : Memory)
    (encoderRet suppliedLen decoderRet : BitVec 64) (out original dst : ArrayPointer) (v : Geometry.Vec)
    (comp : args.comp=1) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (input : args.x=some original)
    (inputSeparate : original.block≠out.block) (outputSeparate : out.block≠dst.block)
    (signed : Signed16 v) (material : KeygenMaterial.Represents before original v)
    (legalInput : KeygenPublicInputMaterial.Legal before original) (legal : WritableArray before dst 1536)
    (capacity : KeygenCodecStaticWire.Capacity args (wordList v)) (available : encoderRet.toNat≤suppliedLen.toNat)
    (encoder : KeygenCodecExecution.Call args before encoded encoderRet)
    (decoder : KeygenDecodeStaticDispatchExecution.Call (KeygenCodecStaticRoundtrip.decoderArgs args out dst suppliedLen) encoded after decoderRet) :
    decoderRet=encoderRet ∧ KeygenMaterial.Represents after dst v ∧ IntegerReads after dst v ∧
      KeygenDecodeNoneExactFrame.Window dst 0 1536 encoded after := by
  have words := represents_words before original v legalInput material
  have actual := KeygenCodecStaticCallRoundtrip.source_call_roundtrip args before encoded after encoderRet suppliedLen decoderRet
    out original dst comp qM0 lognM0 output (wordList v) capacity input inputSeparate outputSeparate
    (wordList_length v) words legal available encoder decoder
  have same := decoded_material after dst v signed actual.2.1
  exact ⟨actual.1,same.1,same.2,by simpa only [wordList_length] using actual.2.2⟩

theorem static_exists (args : KeygenCodecValues.Args) (before encoded : Memory)
    (encoderRet suppliedLen : BitVec 64) (out original dst : ArrayPointer) (v : Geometry.Vec)
    (comp : args.comp=1) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (input : args.x=some original)
    (inputSeparate : original.block≠out.block) (outputSeparate : out.block≠dst.block)
    (signed : Signed16 v) (material : KeygenMaterial.Represents before original v)
    (legalInput : KeygenPublicInputMaterial.Legal before original) (legal : WritableArray before dst 1536)
    (capacity : KeygenCodecStaticWire.Capacity args (wordList v)) (available : encoderRet.toNat≤suppliedLen.toNat)
    (encoder : KeygenCodecExecution.Call args before encoded encoderRet) :
    ∃ after, KeygenDecodeStaticDispatchExecution.Call (KeygenCodecStaticRoundtrip.decoderArgs args out dst suppliedLen) encoded after encoderRet ∧
      KeygenMaterial.Represents after dst v ∧ IntegerReads after dst v := by
  obtain ⟨after,decoder,actual⟩ := KeygenCodecStaticCallRoundtrip.call_roundtrip_exists args before encoded encoderRet suppliedLen
    out original dst comp qM0 lognM0 output (wordList v) capacity input inputSeparate outputSeparate
    (wordList_length v) (represents_words before original v legalInput material) legal available encoder
  have same := decoded_material after dst v signed actual.2.1
  exact ⟨after,decoder,same⟩

theorem none_roundtrip (args : KeygenCodecValues.Args) (before encoded after : Memory)
    (encoderRet suppliedLen decoderRet : BitVec 64) (out original dst : ArrayPointer) (v : Geometry.Vec)
    (B : Int) (nonnegative : 0≤B) (boundB : B≤9216) (bound : KeygenIntegerLift.Bound v B)
    (comp : args.comp=0) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (input : args.x=some original)
    (inputSeparate : original.block≠out.block) (outputSeparate : out.block≠dst.block)
    (material : KeygenMaterial.Represents before original v)
    (legalInput : KeygenPublicInputMaterial.Legal before original) (legal : WritableArray before dst 1536)
    (capacity : 3072≤args.capacity.toNat) (available : encoderRet.toNat≤suppliedLen.toNat)
    (encoder : KeygenCodecExecution.Call args before encoded encoderRet)
    (decoder : KeygenDecodeNoneDispatchExecution.Call (KeygenCodecNoneRoundtrip.decoderArgs args out dst suppliedLen) encoded after decoderRet) :
    decoderRet=3072 ∧ KeygenMaterial.Represents after dst v ∧ IntegerReads after dst v ∧
      KeygenDecodeNoneExactFrame.Window dst 0 1536 encoded after := by
  have actual := KeygenCodecNoneCallRoundtrip.source_call_roundtrip args before encoded after encoderRet suppliedLen decoderRet
    out original dst comp qM0 lognM0 output capacity input inputSeparate outputSeparate
    (wordList v) (wordList_length v) (KeygenInt16Bounds076.none_carrier v B nonnegative boundB bound)
    (represents_words before original v legalInput material) legal available encoder decoder
  have same := decoded_material after dst v (bound_signed v B nonnegative (by omega) bound) actual.2.1
  exact ⟨actual.1,same.1,same.2,by simpa only [wordList_length] using actual.2.2⟩

theorem none_exists (args : KeygenCodecValues.Args) (before encoded : Memory)
    (encoderRet suppliedLen : BitVec 64) (out original dst : ArrayPointer) (v : Geometry.Vec)
    (B : Int) (nonnegative : 0≤B) (boundB : B≤9216) (bound : KeygenIntegerLift.Bound v B)
    (comp : args.comp=0) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (input : args.x=some original)
    (inputSeparate : original.block≠out.block) (outputSeparate : out.block≠dst.block)
    (material : KeygenMaterial.Represents before original v)
    (legalInput : KeygenPublicInputMaterial.Legal before original) (legal : WritableArray before dst 1536)
    (capacity : 3072≤args.capacity.toNat) (available : encoderRet.toNat≤suppliedLen.toNat)
    (encoder : KeygenCodecExecution.Call args before encoded encoderRet) :
    ∃ after, KeygenDecodeNoneDispatchExecution.Call (KeygenCodecNoneRoundtrip.decoderArgs args out dst suppliedLen) encoded after 3072 ∧
      KeygenMaterial.Represents after dst v ∧ IntegerReads after dst v := by
  obtain ⟨after,decoder,actual⟩ := KeygenCodecNoneCallRoundtrip.call_roundtrip_exists args before encoded encoderRet suppliedLen
    out original dst comp qM0 lognM0 output capacity input inputSeparate outputSeparate
    (wordList v) (wordList_length v) (KeygenInt16Bounds076.none_carrier v B nonnegative boundB bound)
    (represents_words before original v legalInput material) legal available encoder
  have same := decoded_material after dst v (bound_signed v B nonnegative (by omega) bound) actual.2.1
  exact ⟨after,decoder,same⟩

end FT1536.Source3.KeygenInt16CodecMath076
