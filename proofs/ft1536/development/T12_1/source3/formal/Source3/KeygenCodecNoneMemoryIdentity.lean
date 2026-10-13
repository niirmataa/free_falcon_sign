import Source3.KeygenCodecNoneCallRoundtrip

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact physical memory identity when decoding back into the original
   coefficient array. The encoded output remains encoded; identity concerns
   the original array/block, with the decoder's whole heap effect also explicit. -/
namespace FT1536.Source3.KeygenCodecNoneMemoryIdentity
open C99MemoryReference KeygenDecodeNoneMemory
open KeygenCodecNoneRoundtrip KeygenCodecNoneCallRoundtrip
open KeygenDecodeNonePairs (CarrierList)

theorem original_read (heap : Memory) (ptr : ArrayPointer) (word : BitVec 16)
    (source : KeygenCodecValues.Load16 heap ptr word) : KeygenDecodeValues.Load16 heap ptr word := by
  cases source with
  | load lo hi allocated width low high => exact .load heap ptr lo hi allocated width low high

theorem element_zero (ptr : ArrayPointer) : element ptr 0=ptr := by cases ptr; rfl

theorem words_readback (heap : Memory) (ptr : ArrayPointer) (inputs : List (BitVec 16))
    (words : KeygenCodecStaticMaterial.Words heap ptr inputs) :
    ∀ i : Fin inputs.length, KeygenDecodeValues.Load16 heap (element ptr i.val) inputs[i] := by
  induction words with
  | nil ptr => intro i; exact Fin.elim0 i
  | cons ptr next input rest load advance tail ih =>
    intro i
    refine Fin.cases ?_ (fun j => ?_) i
    · change KeygenDecodeValues.Load16 heap (element ptr 0) input
      rw [element_zero]
      exact original_read heap ptr input load
    · cases advance
      change KeygenDecodeValues.Load16 heap (element ptr (j.val+1)) rest[j]
      simpa only [element,show ptr.index+1+j.val=ptr.index+(j.val+1) by omega] using ih j

/-- Real stores of already represented original words have exactly the
    identity heap effect; this is derived from the trace, never assumed. -/
theorem trace_identity (dst : ArrayPointer) (a b : Memory) (n : Nat) (inputs : List (BitVec 16))
    (trace : Trace dst a b n inputs)
    (reads : ∀ i : Fin inputs.length, KeygenDecodeValues.Load16 a (element dst (n+i.val)) inputs[i]) : b=a := by
  induction trace with
  | nil => rfl
  | cons a middle b n input rest store tail ih =>
    have first : KeygenDecodeValues.Load16 a (element dst n) input := by
      have value := reads ⟨0,by simp⟩
      change KeygenDecodeValues.Load16 a (element dst (n+0)) input at value
      simpa only [Nat.add_zero] using value
    have same := KeygenDecodeMemory.store_same_memory (element dst n) input a middle first store
    subst middle
    apply ih
    intro i
    have read := reads i.succ
    change KeygenDecodeValues.Load16 a (element dst (n+(i.val+1))) rest[i] at read
    simpa only [show n+(i.val+1)=n+1+i.val by omega] using read

/-- Full NONE dispatcher round-trip is the identity on the original
    physical coefficient memory. It additionally derives return3072 and
    the decoder's exact identity heap effect after encoding. -/
theorem source_in_place_identity (args : EncoderArgs) (before encoded after : Memory) (encoderRet suppliedLen decoderRet : BitVec 64)
    (out original : ArrayPointer) (comp : args.comp=0) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (capacity : 3072≤args.capacity.toNat) (input : args.x=some original)
    (separate : original.block≠out.block) (inputs : List (BitVec 16)) (count : inputs.length=1536) (carrier : CarrierList inputs)
    (words : KeygenCodecStaticMaterial.Words before original inputs) (legal : WritableArray before original 1536)
    (available : encoderRet.toNat≤suppliedLen.toNat)
    (encoder : KeygenCodecExecution.Call args before encoded encoderRet)
    (decoder : KeygenDecodeNoneDispatchExecution.Call (decoderArgs args out original suppliedLen) encoded after decoderRet) :
    decoderRet=3072 ∧ after=encoded ∧ ∀ offset, after.bytes original.block offset=before.bytes original.block offset := by
  obtain ⟨called,encodedState,outSame,capSame,qSame,lognSame,xSame,encExec,encodedHeap⟩ :=
    KeygenCodecNoneCallMaterial.call_split args before encoded encoderRet comp encoder
  obtain ⟨decodedState,decExec,decodedHeap⟩ := KeygenDecodeNoneDispatchFacts.call_split
    (decoderArgs args out original suppliedLen) encoded after decoderRet rfl decoder
  have sameArgs := decoder_args_same args called out original suppliedLen qSame lognSame
  rw [←sameArgs,←encodedHeap] at decExec
  have cap : 3072≤called.capacity.toNat := by rw [capSame]; exact capacity
  have actual := source_roundtrip called before encodedState encoderRet suppliedLen out original original
    (qSame.trans qM0) (lognSame.trans lognM0) (outSame.trans output) cap (xSame.trans input)
    separate (Ne.symm separate) inputs count carrier words legal available encExec decodedState (.returned decoderRet) decExec
  have originalWords := KeygenCodecNoneWire.source_original_preserved called before encodedState (.returned encoderRet) out original
    (qSame.trans qM0) (lognSame.trans lognM0) (outSame.trans output) cap (xSame.trans input) separate inputs count words encExec
  have reads := words_readback encodedState.heap original inputs originalWords
  have sameHeap := trace_identity original encodedState.heap decodedState.heap 0 inputs actual.2.1
    (by simpa only [Nat.zero_add] using reads)
  have identity : after=encoded := by simpa only [encodedHeap,decodedHeap] using sameHeap
  have writes := (KeygenCodecNoneOriginal.source_bytes called before encodedState (.returned encoderRet) out original
    (qSame.trans qM0) (lognSame.trans lognM0) (outSame.trans output) cap (xSame.trans input) separate inputs count words encExec).2
  refine ⟨KeygenDecodeExecution.Flow.returned.inj actual.1,identity,?_⟩
  intro offset
  have unchanged := KeygenCodecByteHistory.outside _ _ _ writes original.block offset
    (fun write member => Or.inl (KeygenCodecStaticMaterial.positions_away (some out) original.block 0 _
      (by intro destination same; cases same; exact separate) write member))
  simpa only [identity,encodedHeap] using unchanged

/-- The identity conclusion is inhabited by an honest complete decoder
    dispatcher execution, rather than conditional on decoder success. -/
theorem in_place_exists (args : EncoderArgs) (before encoded : Memory) (encoderRet suppliedLen : BitVec 64)
    (out original : ArrayPointer) (comp : args.comp=0) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (output : args.out=some out) (capacity : 3072≤args.capacity.toNat) (input : args.x=some original)
    (separate : original.block≠out.block) (inputs : List (BitVec 16)) (count : inputs.length=1536) (carrier : CarrierList inputs)
    (words : KeygenCodecStaticMaterial.Words before original inputs) (legal : WritableArray before original 1536)
    (available : encoderRet.toNat≤suppliedLen.toNat)
    (encoder : KeygenCodecExecution.Call args before encoded encoderRet) :
    ∃ after, KeygenDecodeNoneDispatchExecution.Call (decoderArgs args out original suppliedLen) encoded after 3072 ∧
      after=encoded ∧ ∀ offset, after.bytes original.block offset=before.bytes original.block offset := by
  obtain ⟨after,decoder,actual⟩ := call_roundtrip_exists args before encoded encoderRet suppliedLen out original original comp qM0 lognM0
    output capacity input separate (Ne.symm separate) inputs count carrier words legal available encoder
  have identity := source_in_place_identity args before encoded after encoderRet suppliedLen 3072 out original comp qM0 lognM0
    output capacity input separate inputs count carrier words legal available encoder decoder
  exact ⟨after,decoder,identity.2⟩

end FT1536.Source3.KeygenCodecNoneMemoryIdentity
