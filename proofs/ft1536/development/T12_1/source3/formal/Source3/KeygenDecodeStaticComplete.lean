import Source3.KeygenDecodeStaticPrologue
import Source3.KeygenDecodeNoneExactFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- COMPLETE pinned uncompress_static body. Actual prologue,1536-store loop,
   padding and return compose constructively. The physical encoder-byte
   wire is an internal seam, to be discharged by the SAME source encoder. -/
namespace FT1536.Source3.KeygenDecodeStaticComplete
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified KeygenDecodeStaticWire
open KeygenDecodeNoneMemory (WritableArray Trace)

def paddingCount (inputs : List (BitVec 16)) : Nat :=
  (8-(KeygenCodecStaticOuterState.fold inputs 0 0).1)%8

theorem decoder_checked (args : Args) (before : Memory) (src dst : ArrayPointer)
    (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (data : args.data=some src) (destination : args.x=some dst)
    (inputs : List (BitVec 16)) (length : inputs.length=1536)
    (reads : Reads before src 0 (KeygenCodecStaticComplete.encoded inputs))
    (extent : (KeygenCodecStaticComplete.encoded inputs).length≤args.len.toNat)
    (legal : WritableArray before dst 1536) (separated : src.block≠dst.block) :
    ∃ after, Checked args KeygenDecodeStaticBinding.code (initial args before) after
        (.returned (BitVec.ofNat 64 (KeygenCodecStaticComplete.encoded inputs).length)) ∧
      Trace dst before after.heap 0 inputs := by
  obtain ⟨prepared,prologue,ready,cursor,heap⟩ :=
    KeygenDecodeStaticPrologue.complete args before src dst qM0 lognM0 data destination
  have wire : Wire args src dst 0 0 0 (KeygenCodecStaticComplete.encoded inputs) prepared := by
    refine ⟨ready,?_,by simpa only [Nat.zero_add] using extent⟩
    rw [heap]
    exact reads
  have bits : remaining 0 0 (KeygenCodecStaticComplete.encoded inputs)=
      KeygenCodecStaticBitStream.stream inputs++List.replicate (paddingCount inputs) false := by
    simpa only [remaining,KeygenCodecStaticBitBuffer.buffer,KeygenCodecStaticBits.digits,List.nil_append,paddingCount] using
      KeygenCodecStaticBitStream.encoded_bits inputs
  have allocation : WritableArray prepared.heap dst 1536 := by rw [heap]; exact legal
  obtain ⟨final,loop,trace⟩ := KeygenDecodeStaticLoop.for_loop inputs args src dst 0 (paddingCount inputs)
    (KeygenCodecStaticComplete.encoded inputs) prepared length (Nat.mod_lt _ (by decide +kernel)) wire cursor bits allocation separated
  simp only [Nat.zero_add] at loop
  have tailRun : Checked args KeygenDecodeStaticBinding.node113 prepared final
      (.returned (BitVec.ofNat 64 (KeygenCodecStaticComplete.encoded inputs).length)) :=
    seq_return args KeygenDecodeStaticBinding.node111 KeygenDecodeStaticBinding.node112 prepared final _ loop
  have body : Checked args KeygenDecodeStaticBinding.node124 (initial args before) final
      (.returned (BitVec.ofNat 64 (KeygenCodecStaticComplete.encoded inputs).length)) :=
    KeygenDecodeStaticSequence.append_checked KeygenDecodeStaticPrologue.pieces args (initial args before) prepared final _ _ prologue tailRun
  have complete := scope args KeygenDecodeStaticBinding.node124 (initial args before) final _ (by intro _; rfl) body
  rw [heap] at trace
  exact ⟨scopeExit KeygenDecodeStaticBinding.node124 (initial args before) final,complete,trace⟩

theorem source_outcome (args : Args) (before : Memory) (after : State) (flow : Flow)
    (src dst : ArrayPointer) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (data : args.data=some src) (destination : args.x=some dst)
    (inputs : List (BitVec 16)) (length : inputs.length=1536)
    (reads : Reads before src 0 (KeygenCodecStaticComplete.encoded inputs))
    (extent : (KeygenCodecStaticComplete.encoded inputs).length≤args.len.toNat)
    (legal : WritableArray before dst 1536) (separated : src.block≠dst.block)
    (source : Exec args KeygenDecodeStaticBinding.code (initial args before) after flow) :
    flow=.returned (BitVec.ofNat 64 (KeygenCodecStaticComplete.encoded inputs).length) ∧
      Trace dst before after.heap 0 inputs ∧
      (∀ i : Fin inputs.length, Load16 after.heap (KeygenDecodeNoneMemory.element dst i.val) inputs[i]) ∧
      KeygenDecodeNoneExactFrame.Window dst 0 inputs.length before after.heap := by
  obtain ⟨actual,checked,trace⟩ := decoder_checked args before src dst qM0 lognM0 data destination inputs length reads extent legal separated
  obtain ⟨same,result⟩ := checked.unique after flow source
  subst after
  refine ⟨result,trace,?_,KeygenDecodeNoneExactFrame.trace_frame dst before actual.heap 0 inputs legal.1 trace⟩
  simpa only [Nat.zero_add] using KeygenDecodeNoneMemory.trace_readback dst before actual.heap 0 inputs legal.1 trace

theorem decoder_exists (args : Args) (before : Memory) (src dst : ArrayPointer)
    (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (data : args.data=some src) (destination : args.x=some dst)
    (inputs : List (BitVec 16)) (length : inputs.length=1536)
    (reads : Reads before src 0 (KeygenCodecStaticComplete.encoded inputs))
    (extent : (KeygenCodecStaticComplete.encoded inputs).length≤args.len.toNat)
    (legal : WritableArray before dst 1536) (separated : src.block≠dst.block) :
    ∃ after, Exec args KeygenDecodeStaticBinding.code (initial args before) after
        (.returned (BitVec.ofNat 64 (KeygenCodecStaticComplete.encoded inputs).length)) ∧
      Trace dst before after.heap 0 inputs := by
  obtain ⟨after,checked,trace⟩ := decoder_checked args before src dst qM0 lognM0 data destination inputs length reads extent legal separated
  exact ⟨after,checked.run,trace⟩

end FT1536.Source3.KeygenDecodeStaticComplete
