import Source3.KeygenPublicEncodePrologue077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEncodeComplete077
open KeygenCodecSyntax KeygenPublicEncodeValues077 KeygenPublicEncodeExecution077 C99MemoryReference
open KeygenPublicEncodeDynamic077 KeygenPublicEncodeCertified077 KeygenPublicEncodeReady077

theorem suffix (args : Args) (s : State)
    (pending : Cell "acc_len" .int32 (.int32 0) s.locals)
    (cursor : Cell "u" .uint64 (.uint64 2880) s.locals) :
    Checked args KeygenPublicEncodeBinding077.node060 s s (.returned 2880) := by
  have same : withLocals s s.locals=s := by cases s; rfl
  have compare : C99IntegerReference.CompareExec .gt (.int32 0) (.int32 0) (.int32 0) := by
    have primitive := KeygenPublicInteger077.compare_i32 .gt 0 0 (by decide +kernel) (by decide +kernel)
    convert primitive using 1; decide +kernel
  have calculation : KeygenPublicEncodePure077.Computes s.locals KeygenPublicEncodeBinding077.guard056 (.int32 0) :=
    .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold KeygenCodecScalarCalculation.Ordinary; decide +kernel) pending)
      (.number _ _ _ (by decide +kernel)) (.gt _ _ _ compare)
  have padding : Checked args KeygenPublicEncodeBinding077.node056 s s .normal :=
    branch_false args KeygenPublicEncodeBinding077.guard056 KeygenPublicEncodeBinding077.node055 .skip s s .normal
      (.int32 0) s.locals (.pure _ _ _ calculation) (by decide +kernel) (by rw [same]; exact skip args s)
  have returned : Checked args KeygenPublicEncodeBinding077.node057 s s (.returned 2880) := by
    have source := ret args s (.variable "u".toList) (.uint64 2880) s.locals
      (.pure _ _ _ (.scalar _ _ _ (by unfold KeygenCodecScalarCalculation.Ordinary; decide +kernel) cursor))
    rw [same] at source
    exact source
  exact seq args _ _ s s s (.returned 2880) padding (seq_return args _ _ s s 2880 returned)

theorem encoder_checked (args : Args) (before : Memory) (out ptr : ArrayPointer) (inputs : List (BitVec 16))
    (lognM0 : args.logn=10) (output : args.out=some out) (input : args.x=some ptr)
    (count : inputs.length=1536) (enough : 2880≤args.capacity.toNat)
    (words : KeygenCodecStaticMaterial.Words before ptr inputs) (legal : WritableBytes before out 2880)
    (separate : ptr.block≠out.block) :
    ∃ final, Checked args KeygenPublicEncodeBinding077.code (initial args before) final (.returned 2880) ∧
      KeygenCodecByteHistory.Trace before final.heap
        (KeygenCodecStaticHistory.positions (some out) 0 (KeygenPublicBits077.encoded inputs)) := by
  obtain ⟨prologue,ready,heap⟩ := KeygenPublicEncodePrologue077.prologue args before out ptr lognM0 output input
  let start := KeygenPublicEncodePrologue077.initialized args before
  have lengths := KeygenPublicBits077.source_profile_lengths inputs count
  dsimp only [KeygenPublicBits077.encoded] at lengths
  obtain ⟨t,lastPtr,loop,lastReady,trace,lastLegal⟩ := KeygenPublicEncodeLoop077.loop inputs args start out ptr 0 0 0
    (by omega) (by decide +kernel) (by simpa only [Nat.zero_add] using Nat.le_of_eq lengths.1)
    enough (by rw [count]; exact ready) (by rw [heap]; exact legal) (by rw [heap]; exact words) separate
  have cursor : Cell "u" .uint64 (.uint64 2880) t.locals := by
    simpa only [Nat.zero_add,lengths.1,show BitVec.ofNat 64 2880=(2880 : BitVec 64) by decide +kernel] using lastReady.cursor
  have pending : Cell "acc_len" .int32 (.int32 0) t.locals := by
    simpa only [lengths.2,show BitVec.ofNat 32 0=(0 : BitVec 32) by decide +kernel] using lastReady.pending
  have ending := suffix args t pending cursor
  have body : Checked args KeygenPublicEncodeBinding077.node061 start t (.returned 2880) :=
    seq args _ _ start t t (.returned 2880) loop ending
  have inside : Checked args KeygenPublicEncodeBinding077.node070 (initial args before) t (.returned 2880) :=
    KeygenPublicEncodeSequence077.append_checked KeygenPublicEncodePrologue077.pieces args _ start t
      KeygenPublicEncodeBinding077.node061 (.returned 2880) prologue body
  have full := scope args KeygenPublicEncodeBinding077.node070 (initial args before) t (.returned 2880)
    (by intro _; rfl) inside
  rw [heap] at trace
  exact ⟨scopeExit KeygenPublicEncodeBinding077.node070 (initial args before) t,full,trace⟩

theorem source_outcome (args : Args) (before after : Memory) (ret : BitVec 64) (out ptr : ArrayPointer)
    (inputs : List (BitVec 16)) (lognM0 : args.logn=10) (output : args.out=some out) (input : args.x=some ptr)
    (count : inputs.length=1536) (enough : 2880≤args.capacity.toNat)
    (words : KeygenCodecStaticMaterial.Words before ptr inputs) (legal : WritableBytes before out 2880)
    (separate : ptr.block≠out.block) (source : Call args before after ret) :
    ret=2880 ∧ KeygenCodecByteHistory.Trace before after
      (KeygenCodecStaticHistory.positions (some out) 0 (KeygenPublicBits077.encoded inputs)) := by
  obtain ⟨final,checked,trace⟩ := encoder_checked args before out ptr inputs lognM0 output input count enough words legal separate
  obtain ⟨actual,run,heap⟩ := source
  obtain ⟨same,value⟩ := checked.unique actual (.returned ret) run
  subst actual
  cases value
  rw [heap] at trace
  exact ⟨rfl,trace⟩

theorem encoder_exists (args : Args) (before : Memory) (out ptr : ArrayPointer) (inputs : List (BitVec 16))
    (lognM0 : args.logn=10) (output : args.out=some out) (input : args.x=some ptr)
    (count : inputs.length=1536) (enough : 2880≤args.capacity.toNat)
    (words : KeygenCodecStaticMaterial.Words before ptr inputs) (legal : WritableBytes before out 2880)
    (separate : ptr.block≠out.block) :
    ∃ after ret, Call args before after ret ∧ ret=2880 ∧
      KeygenCodecByteHistory.Trace before after
        (KeygenCodecStaticHistory.positions (some out) 0 (KeygenPublicBits077.encoded inputs)) := by
  obtain ⟨final,checked,trace⟩ := encoder_checked args before out ptr inputs lognM0 output input count enough words legal separate
  exact ⟨final.heap,2880,⟨final,checked.run,rfl⟩,rfl,trace⟩

end FT1536.Source3.KeygenPublicEncodeComplete077
