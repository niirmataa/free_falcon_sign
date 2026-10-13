import Source3.KeygenCodecStaticWire

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual source compress_static -> uncompress_static physical-memory
   round-trip. No codec output/length/frame/success premise: the same actual
   encoder supplies physical bytes and its unrestricted observed return. -/
namespace FT1536.Source3.KeygenCodecStaticRoundtrip
open C99MemoryReference KeygenDecodeNoneMemory
abbrev EncoderArgs := KeygenCodecValues.Args
abbrev EncoderState := KeygenCodecValues.State
abbrev DecoderArgs := KeygenDecodeValues.Args
abbrev DecoderState := KeygenDecodeValues.State
abbrev DecoderFlow := KeygenDecodeStaticExecution.Flow

def decoderArgs (args : EncoderArgs) (out dst : ArrayPointer) (suppliedLen : BitVec 64) : DecoderArgs :=
  ⟨some (KeygenCodecExecution.byteOff out 0),suppliedLen,1,args.q,some dst,args.logn⟩
def Decoded (heap : Memory) (dst : ArrayPointer) (inputs : List (BitVec 16)) : Prop :=
  ∀ i : Fin inputs.length, KeygenDecodeValues.Load16 heap (element dst i.val) inputs[i]
def Outcome (before : Memory) (after : DecoderState) (flow : DecoderFlow)
    (ret : BitVec 64) (dst : ArrayPointer) (inputs : List (BitVec 16)) : Prop :=
  flow=.returned ret ∧ Trace dst before after.heap 0 inputs ∧ Decoded after.heap dst inputs ∧
    KeygenDecodeNoneExactFrame.Window dst 0 inputs.length before after.heap

theorem encoder_images (args : EncoderArgs) (before : Memory) (encoded : EncoderState) (ret : BitVec 64)
    (out original dst : ArrayPointer) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (inputs : List (BitVec 16)) (capacity : KeygenCodecStaticWire.Capacity args inputs)
    (input : args.x=some original) (inputSeparate : original.block≠out.block) (count : inputs.length=1536)
    (words : KeygenCodecStaticMaterial.Words before original inputs) (legal : WritableArray before dst 1536)
    (source : KeygenCodecExecution.Exec args KeygenCodecStaticBinding.code (KeygenCodecValues.initial args before) encoded (.returned ret)) :
    ret=BitVec.ofNat 64 (KeygenCodecStaticComplete.encoded inputs).length ∧
      KeygenDecodeStaticWire.Reads encoded.heap (KeygenCodecExecution.byteOff out 0) 0 (KeygenCodecStaticComplete.encoded inputs) ∧
      WritableArray encoded.heap dst 1536 := by
  obtain ⟨returned,trace⟩ := KeygenCodecStaticWire.source_bytes args before encoded (.returned ret) out original
    qM0 lognM0 output inputs capacity input inputSeparate count words source
  have readable := KeygenCodecStaticWire.physical_reads out _ before encoded.heap trace
  have sizes := KeygenCodecStaticMaterial.trace_sizes _ _ _ trace
  have permissions := KeygenCodecStaticWire.trace_writable _ _ _ trace
  have legalAfter : WritableArray encoded.heap dst 1536 :=
    ⟨legal.1,by rw [permissions]; exact legal.2.1,
      fun i bound => by simpa only [Allocated,sizes] using legal.2.2 i bound⟩
  exact ⟨KeygenCodecExecution.Flow.returned.inj returned,readable,legalAfter⟩

theorem observed_extent (inputs : List (BitVec 16)) (count : inputs.length=1536) (ret suppliedLen : BitVec 64)
    (value : ret=BitVec.ofNat 64 (KeygenCodecStaticComplete.encoded inputs).length)
    (available : ret.toNat≤suppliedLen.toNat) : (KeygenCodecStaticComplete.encoded inputs).length≤suppliedLen.toNat := by
  have size := KeygenCodecStaticLength.profile_bounds inputs count
  have fits : (KeygenCodecStaticComplete.encoded inputs).length<2^64 := by
    rw [KeygenCodecStaticLength.encoded_length]
    omega
  rw [value,BitVec.toNat_ofNat,Nat.mod_eq_of_lt fits] at available
  exact available

theorem source_roundtrip (args : EncoderArgs) (before : Memory) (encoded : EncoderState) (ret suppliedLen : BitVec 64)
    (out original dst : ArrayPointer) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (inputs : List (BitVec 16)) (capacity : KeygenCodecStaticWire.Capacity args inputs)
    (input : args.x=some original) (inputSeparate : original.block≠out.block) (outputSeparate : out.block≠dst.block)
    (count : inputs.length=1536) (words : KeygenCodecStaticMaterial.Words before original inputs)
    (legal : WritableArray before dst 1536) (available : ret.toNat≤suppliedLen.toNat)
    (encoder : KeygenCodecExecution.Exec args KeygenCodecStaticBinding.code (KeygenCodecValues.initial args before) encoded (.returned ret))
    (after : DecoderState) (flow : DecoderFlow)
    (decoder : KeygenDecodeStaticExecution.Exec (decoderArgs args out dst suppliedLen) KeygenDecodeStaticBinding.code
      (KeygenDecodeValues.initial (decoderArgs args out dst suppliedLen) encoded.heap) after flow) :
    Outcome encoded.heap after flow ret dst inputs := by
  obtain ⟨retValue,images,legalAfter⟩ := encoder_images args before encoded ret out original dst qM0 lognM0
    output inputs capacity input inputSeparate count words legal encoder
  have extent := observed_extent inputs count ret suppliedLen retValue available
  have actual := KeygenDecodeStaticComplete.source_outcome (decoderArgs args out dst suppliedLen) encoded.heap after flow
    (KeygenCodecExecution.byteOff out 0) dst qM0 lognM0 rfl rfl inputs count images extent legalAfter outputSeparate decoder
  rw [←retValue] at actual
  exact actual

theorem roundtrip_exists (args : EncoderArgs) (before : Memory) (encoded : EncoderState) (ret suppliedLen : BitVec 64)
    (out original dst : ArrayPointer) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (inputs : List (BitVec 16)) (capacity : KeygenCodecStaticWire.Capacity args inputs)
    (input : args.x=some original) (inputSeparate : original.block≠out.block) (outputSeparate : out.block≠dst.block)
    (count : inputs.length=1536) (words : KeygenCodecStaticMaterial.Words before original inputs)
    (legal : WritableArray before dst 1536) (available : ret.toNat≤suppliedLen.toNat)
    (encoder : KeygenCodecExecution.Exec args KeygenCodecStaticBinding.code (KeygenCodecValues.initial args before) encoded (.returned ret)) :
    ∃ after, KeygenDecodeStaticExecution.Exec (decoderArgs args out dst suppliedLen) KeygenDecodeStaticBinding.code
      (KeygenDecodeValues.initial (decoderArgs args out dst suppliedLen) encoded.heap) after (.returned ret) ∧
      Outcome encoded.heap after (.returned ret) ret dst inputs := by
  obtain ⟨retValue,images,legalAfter⟩ := encoder_images args before encoded ret out original dst qM0 lognM0
    output inputs capacity input inputSeparate count words legal encoder
  have extent := observed_extent inputs count ret suppliedLen retValue available
  obtain ⟨after,checked,trace⟩ := KeygenDecodeStaticComplete.decoder_checked (decoderArgs args out dst suppliedLen) encoded.heap
    (KeygenCodecExecution.byteOff out 0) dst qM0 lognM0 rfl rfl inputs count images extent legalAfter outputSeparate
  rw [←retValue] at checked
  have decoder := checked.run
  have actual := source_roundtrip args before encoded ret suppliedLen out original dst qM0 lognM0 output inputs capacity input
    inputSeparate outputSeparate count words legal available encoder after (.returned ret) decoder
  exact ⟨after,decoder,actual⟩

end FT1536.Source3.KeygenCodecStaticRoundtrip
