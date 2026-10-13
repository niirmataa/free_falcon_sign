import Source3.KeygenPublicDecodePrologue077
import Source3.KeygenDecodeNoneExactFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicDecodeComplete077
open KeygenDecodeSyntax KeygenDecodeValues KeygenPublicDecodeExecution077 C99MemoryReference
open KeygenDecodeDynamicCalculation KeygenPublicDecodeCertified077 KeygenPublicDecodeReady077
open KeygenDecodeNoneMemory (WritableArray Trace)

theorem suffix (args : Args) (s : State) (word : Cell "acc" .uint32 (.uint32 0) s.locals)
    (length : Cell "len" .uint64 (.uint64 args.len) s.locals) :
    Checked args KeygenPublicDecodeBinding077.node052 s s (.returned args.len) := by
  have same : withLocals s s.locals=s := by cases s; rfl
  have compare : C99IntegerReference.CompareExec .ne (.uint32 0) (.int32 0) (.int32 0) := by
    have primitive := C99IntegerReference.CompareExec.step .ne (.uint32 0) (.int32 0) .uint32 rfl (.uint32 0) (.uint32 0) rfl rfl
    convert primitive using 1; decide +kernel
  have calculation : KeygenDecodeCalculation.Computes args s.heap s.buf s.locals KeygenPublicDecodeBinding077.guard048 (.int32 0) :=
    .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) word)
      (.number _ _ _ (by decide +kernel)) (.ne _ _ _ compare)
  have padding : Checked args KeygenPublicDecodeBinding077.node048 s s .normal :=
    branch_false args KeygenPublicDecodeBinding077.guard048 KeygenPublicDecodeBinding077.node047 .skip s s .normal
      (.int32 0) s.locals (.pure _ _ _ calculation) (by decide +kernel) (by rw [same]; exact skip args s)
  have returned : Checked args KeygenPublicDecodeBinding077.node049 s s (.returned args.len) := by
    have source := ret args s (.variable "len".toList) (.uint64 args.len) s.locals
      (.pure _ _ _ (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) length))
    rw [same] at source
    simpa only [KeygenPublicDecodeBinding077.node049,C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq] using source
  exact seq args _ _ s s s (.returned args.len) padding (seq_return args _ _ s s args.len returned)

theorem decoder_checked (args : Args) (before : Memory) (src dst : ArrayPointer) (inputs : List (BitVec 16))
    (lognM0 : args.logn=10) (data : args.data=some src) (destination : args.x=some dst)
    (count : inputs.length=1536) (canonical : KeygenPublicBits077.Canonical inputs)
    (reads : Reads before src 0 (KeygenPublicBits077.encoded inputs))
    (extent : (KeygenPublicBits077.encoded inputs).length≤args.len.toNat)
    (legal : WritableArray before dst 1536) (separate : src.block≠dst.block) :
    ∃ final, Checked args KeygenPublicDecodeBinding077.code (initial args before) final (.returned args.len) ∧
      Trace dst before final.heap 0 inputs := by
  obtain ⟨prologue,ready,heap⟩ := KeygenPublicDecodePrologue077.prologue args before src dst lognM0 data destination
  let start := KeygenPublicDecodePrologue077.initialized args before
  have wire : Wire args src (KeygenDecodeNoneMemory.element dst 0) inputs.length 0 0 0 (KeygenPublicBits077.encoded inputs) start := by
    refine ⟨?_,?_,?_,by decide +kernel⟩
    · rw [count]
      exact ready
    · rw [heap]
      exact reads
    · simpa only [Nat.zero_add] using extent
  have held : remaining 0 0 (KeygenPublicBits077.encoded inputs)=KeygenPublicBits077.bits inputs := by
    simpa only [KeygenDecodeStaticWire.remaining,KeygenCodecStaticBitBuffer.buffer,KeygenCodecStaticBits.digits,List.nil_append] using
      KeygenPublicStream077.encoded_bits inputs count canonical
  obtain ⟨t,loop,lastReady,trace⟩ := KeygenPublicDecodeLoop077.loop (KeygenPublicBits077.encoded inputs) inputs args start src dst 0 0 0 0
    (by omega) (by decide +kernel) canonical wire held (by rw [heap]; exact legal) separate
  have ending := suffix args t lastReady.accumulator lastReady.context.length
  have body : Checked args KeygenPublicDecodeBinding077.node053 start t (.returned args.len) :=
    seq args _ _ start t t (.returned args.len) loop ending
  have inside : Checked args KeygenPublicDecodeBinding077.node062 (initial args before) t (.returned args.len) :=
    KeygenPublicDecodeSequence077.append_checked KeygenPublicDecodePrologue077.pieces args _ start t
      KeygenPublicDecodeBinding077.node053 (.returned args.len) prologue body
  have full := scope args KeygenPublicDecodeBinding077.node062 (initial args before) t (.returned args.len) (by intro _; rfl) inside
  rw [heap] at trace
  exact ⟨scopeExit KeygenPublicDecodeBinding077.node062 (initial args before) t,full,trace⟩

theorem source_outcome (args : Args) (before after : Memory) (ret : BitVec 64) (src dst : ArrayPointer)
    (inputs : List (BitVec 16)) (lognM0 : args.logn=10) (data : args.data=some src) (destination : args.x=some dst)
    (count : inputs.length=1536) (canonical : KeygenPublicBits077.Canonical inputs)
    (reads : Reads before src 0 (KeygenPublicBits077.encoded inputs))
    (extent : (KeygenPublicBits077.encoded inputs).length≤args.len.toNat)
    (legal : WritableArray before dst 1536) (separate : src.block≠dst.block) (source : Call args before after ret) :
    ret=args.len ∧ Trace dst before after 0 inputs ∧
      (∀ i : Fin inputs.length, Load16 after (KeygenDecodeNoneMemory.element dst i.val) inputs[i]) ∧
      KeygenDecodeNoneExactFrame.Window dst 0 inputs.length before after := by
  obtain ⟨final,checked,trace⟩ := decoder_checked args before src dst inputs lognM0 data destination count canonical reads extent legal separate
  obtain ⟨actual,run,heap⟩ := source
  obtain ⟨same,value⟩ := checked.unique actual (.returned ret) run
  subst actual
  cases value
  rw [heap] at trace
  refine ⟨rfl,trace,?_,KeygenDecodeNoneExactFrame.trace_frame dst before after 0 inputs legal.1 trace⟩
  simpa only [Nat.zero_add] using KeygenDecodeNoneMemory.trace_readback dst before after 0 inputs legal.1 trace

theorem decoder_exists (args : Args) (before : Memory) (src dst : ArrayPointer) (inputs : List (BitVec 16))
    (lognM0 : args.logn=10) (data : args.data=some src) (destination : args.x=some dst)
    (count : inputs.length=1536) (canonical : KeygenPublicBits077.Canonical inputs)
    (reads : Reads before src 0 (KeygenPublicBits077.encoded inputs))
    (extent : (KeygenPublicBits077.encoded inputs).length≤args.len.toNat)
    (legal : WritableArray before dst 1536) (separate : src.block≠dst.block) :
    ∃ after ret, Call args before after ret ∧ ret=args.len ∧ Trace dst before after 0 inputs := by
  obtain ⟨final,checked,trace⟩ := decoder_checked args before src dst inputs lognM0 data destination count canonical reads extent legal separate
  exact ⟨final.heap,args.len,⟨final,checked.run,rfl⟩,rfl,trace⟩

end FT1536.Source3.KeygenPublicDecodeComplete077
