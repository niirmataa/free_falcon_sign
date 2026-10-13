import Source3.KeygenDecodeNoneExactFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual compress_none -> uncompress_none physical-memory round-trip.
   Observed encoder return supplies the decoder's available prefix length;
   no encoded bytes, successful result, length3072 or codec frame is assumed.
   Dispatcher/caller composition remains a separate source interface. -/
namespace FT1536.Source3.KeygenCodecNoneRoundtrip
open C99MemoryReference
open KeygenDecodeNoneMemory KeygenDecodeNoneImages
open KeygenDecodeNonePairs (CarrierList)

abbrev EncoderArgs := KeygenCodecValues.Args
abbrev EncoderState := KeygenCodecValues.State
abbrev DecoderArgs := KeygenDecodeValues.Args
abbrev DecoderState := KeygenDecodeValues.State
abbrev DecoderFlow := KeygenDecodeExecution.Flow

def decoderArgs (args : EncoderArgs) (out dst : ArrayPointer) (suppliedLen : BitVec 64) : DecoderArgs :=
  ⟨some (KeygenCodecExecution.byteOff out 0),suppliedLen,0,args.q,some dst,args.logn⟩

def Decoded (heap : Memory) (dst : ArrayPointer) (inputs : List (BitVec 16)) : Prop :=
  ∀ i : Fin inputs.length, KeygenDecodeValues.Load16 heap (element dst i.val) inputs[i]

def Outcome (before : Memory) (after : DecoderState) (flow : DecoderFlow)
    (dst : ArrayPointer) (inputs : List (BitVec 16)) : Prop :=
  flow=.returned 3072 ∧ Trace dst before after.heap 0 inputs ∧ Decoded after.heap dst inputs ∧
    KeygenDecodeNoneExactFrame.Window dst 0 inputs.length before after.heap

theorem byte_trace_writable (a b : Memory) (writes : List KeygenCodecByteHistory.Write)
    (trace : KeygenCodecByteHistory.Trace a b writes) : b.writable=a.writable := by
  induction trace with
  | nil => rfl
  | step a b c ptr word rest store tail ih => exact ih.trans store.2.2.2.2.1

/-- Honest physical byte images and legal output metadata are derived from
    the actual complete encoder execution, not independent codec agreement. -/
theorem encoder_images (args : EncoderArgs) (before : Memory) (encoded : EncoderState) (ret : BitVec 64)
    (out original dst : ArrayPointer) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (capacity : 3072≤args.capacity.toNat) (input : args.x=some original)
    (inputSeparate : original.block≠out.block) (inputs : List (BitVec 16)) (count : inputs.length=1536)
    (words : KeygenCodecStaticMaterial.Words before original inputs) (legal : WritableArray before dst 1536)
    (source : KeygenCodecExecution.Exec args KeygenCodecNoneBinding.code (KeygenCodecValues.initial args before) encoded (.returned ret)) :
    ret=3072 ∧ ImagesAt encoded.heap (KeygenCodecExecution.byteOff out 0) 0 inputs ∧
      WritableArray encoded.heap dst 1536 := by
  obtain ⟨returned,trace⟩ := KeygenCodecNoneOriginal.source_bytes args before encoded (.returned ret) out original
    qM0 lognM0 output capacity input inputSeparate inputs count words source
  have retValue := KeygenCodecExecution.Flow.returned.inj returned
  have readable := (KeygenCodecNoneWire.source_readable args before encoded (.returned ret) out original
    qM0 lognM0 output capacity input inputSeparate inputs count words source).2
  have images := from_wire_reads encoded.heap out inputs readable
  have sizes := KeygenCodecStaticMaterial.trace_sizes _ _ _ trace
  have permissions := byte_trace_writable _ _ _ trace
  have legalAfter : WritableArray encoded.heap dst 1536 :=
    ⟨legal.1,by rw [permissions]; exact legal.2.1,
      fun i bound => by simpa only [Allocated,sizes] using legal.2.2 i bound⟩
  exact ⟨retValue,images,legalAfter⟩

/-- Every actual complete decoder execution recovers all SAME physical
    original words and consumes3072 bytes. Any additional supplied bytes
    are unrestricted; the exact output frame is derived from actual stores. -/
theorem source_roundtrip (args : EncoderArgs) (before : Memory) (encoded : EncoderState) (ret suppliedLen : BitVec 64)
    (out original dst : ArrayPointer) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (capacity : 3072≤args.capacity.toNat) (input : args.x=some original)
    (inputSeparate : original.block≠out.block) (outputSeparate : out.block≠dst.block)
    (inputs : List (BitVec 16)) (count : inputs.length=1536) (carrier : CarrierList inputs)
    (words : KeygenCodecStaticMaterial.Words before original inputs) (legal : WritableArray before dst 1536)
    (available : ret.toNat≤suppliedLen.toNat)
    (encoder : KeygenCodecExecution.Exec args KeygenCodecNoneBinding.code (KeygenCodecValues.initial args before) encoded (.returned ret))
    (after : DecoderState) (flow : DecoderFlow)
    (decoder : KeygenDecodeExecution.Exec (decoderArgs args out dst suppliedLen) KeygenDecodeNoneBinding.code
      (KeygenDecodeValues.initial (decoderArgs args out dst suppliedLen) encoded.heap) after flow) :
    Outcome encoded.heap after flow dst inputs := by
  obtain ⟨retValue,images,legalAfter⟩ := encoder_images args before encoded ret out original dst qM0 lognM0
    output capacity input inputSeparate inputs count words legal encoder
  have enough : 3072≤suppliedLen.toNat := by rw [retValue] at available; exact available
  have actual := KeygenDecodeNoneComplete.source_outcome (decoderArgs args out dst suppliedLen) encoded.heap after flow
    (KeygenCodecExecution.byteOff out 0) dst qM0 lognM0 rfl rfl enough inputs count carrier images legalAfter outputSeparate decoder
  exact ⟨actual.1,actual.2.1,actual.2.2.1,KeygenDecodeNoneExactFrame.trace_frame dst encoded.heap after.heap 0 inputs
    legalAfter.1 actual.2.1⟩

/-- A full honest decoder execution exists for the actual encoder-produced
    bytes. The destination may be uninitialized, and supplied tail contents
    need no assumptions. No desired decoder result/length/frame is a premise. -/
theorem roundtrip_exists (args : EncoderArgs) (before : Memory) (encoded : EncoderState) (ret suppliedLen : BitVec 64)
    (out original dst : ArrayPointer) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (capacity : 3072≤args.capacity.toNat) (input : args.x=some original)
    (inputSeparate : original.block≠out.block) (outputSeparate : out.block≠dst.block)
    (inputs : List (BitVec 16)) (count : inputs.length=1536) (carrier : CarrierList inputs)
    (words : KeygenCodecStaticMaterial.Words before original inputs) (legal : WritableArray before dst 1536)
    (available : ret.toNat≤suppliedLen.toNat)
    (encoder : KeygenCodecExecution.Exec args KeygenCodecNoneBinding.code (KeygenCodecValues.initial args before) encoded (.returned ret)) :
    ∃ after, KeygenDecodeExecution.Exec (decoderArgs args out dst suppliedLen) KeygenDecodeNoneBinding.code
      (KeygenDecodeValues.initial (decoderArgs args out dst suppliedLen) encoded.heap) after (.returned 3072) ∧
      Outcome encoded.heap after (.returned 3072) dst inputs := by
  obtain ⟨retValue,images,legalAfter⟩ := encoder_images args before encoded ret out original dst qM0 lognM0
    output capacity input inputSeparate inputs count words legal encoder
  have enough : 3072≤suppliedLen.toNat := by rw [retValue] at available; exact available
  obtain ⟨after,decoder,trace,decoded,frame⟩ := KeygenDecodeNoneComplete.decoder_exists
    (decoderArgs args out dst suppliedLen) encoded.heap (KeygenCodecExecution.byteOff out 0) dst
    qM0 lognM0 rfl rfl enough inputs count carrier images legalAfter outputSeparate
  exact ⟨after,decoder,rfl,trace,decoded,KeygenDecodeNoneExactFrame.trace_frame dst encoded.heap after.heap 0 inputs legalAfter.1 trace⟩

end FT1536.Source3.KeygenCodecNoneRoundtrip
