import Source3.KeygenPublicEncodeEmit077
import Source3.KeygenPublicEncodeCertifiedLoop077
import Source3.KeygenDecodeStaticPaddingBits

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEncodeDrainStep077
open KeygenCodecSyntax KeygenPublicEncodeValues077 KeygenPublicEncodeExecution077 C99MemoryReference
open KeygenPublicEncodeDynamic077 KeygenPublicEncodeCertified077 KeygenPublicEncodeReady077

def after (s : State) (out : ArrayPointer) (u p : Nat) (acc : BitVec 32) : State :=
  set32 (set64 (KeygenPublicEncodeEmit077.after (setPending s (p-8)) out u (p-8) acc)
    "u" (BitVec.ofNat 64 (u+1))) "acc" (KeygenPublicBits077.masked (p-8) acc)

theorem step (args : Args) (s : State) (out ptr : ArrayPointer) (n u p : Nat) (acc : BitVec 32)
    (positive : 8≤p) (small : p<32) (inside : u<2880) (enough : 2880≤args.capacity.toNat)
    (ready : Ready args out ptr n u p acc s) (legal : WritableBytes s.heap out 2880) :
    Checked args KeygenPublicEncodeBinding077.node031 s (after s out u p acc) .normal ∧
      Ready args out ptr n (u+1) (p-8) (KeygenPublicBits077.masked (p-8) acc) (after s out u p acc) ∧
      StoreByte s.heap (byteOff out u) (KeygenPublicEncodeEmit077.byte acc (p-8)) (after s out u p acc).heap := by
  let s1 := setPending s (p-8)
  let s2 := KeygenPublicEncodeEmit077.after s1 out u (p-8) acc
  let s3 := set64 s2 "u" (BitVec.ofNat 64 (u+1))
  let s4 := after s out u p acc
  have drop : Checked args KeygenPublicEncodeBinding077.node012 s s1 .normal := by
    have source := compound args s "acc_len".toList .int32 (.int32 (BitVec.ofNat 32 p)) .sub .sub
      (.number .i32 8) (.int32 8) (.int32 (BitVec.ofNat 32 (p-8))) s.locals
      (by decide +kernel) (by decide +kernel) ready.pending rfl (.pure _ _ _ (.number _ _ _ (by decide +kernel)))
      (.sub _ _ _ (KeygenPublicInteger077.minus_i32 p 8 positive (by omega)))
    simpa only [KeygenPublicInteger077.self_i32,KeygenPublicEncodeBinding077.node012,setPending,s1] using source
  have context1 := context_frame args out s s1 _ .normal drop.run (by unfold Checks; decide +kernel) ready.context
  have cursor1 := (KeygenPublicEncodeCellFrame077.exec_frame "u".toList args _ s s1 .normal drop.run (by decide +kernel)).trans ready.cursor
  have word1 := (KeygenPublicEncodeCellFrame077.exec_frame "acc".toList args _ s s1 .normal drop.run (by decide +kernel)).trans ready.accumulator
  have pending1 : Cell "acc_len" .int32 (.int32 (BitVec.ofNat 32 (p-8))) s1.locals := rfl
  obtain ⟨emit,store⟩ := KeygenPublicEncodeEmit077.emit args s1 out u (p-8) acc (by omega) inside enough
    context1 legal cursor1 pending1 word1
  have cursor2 : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) s2.locals := cursor1
  have increment : ScalarUpdate "u".toList 1 s2.locals (.uint64 (BitVec.ofNat 64 u))
      (.uint64 (BitVec.ofNat 64 (u+1))) s3.locals :=
    .scalar (by unfold KeygenPublicEncodePure077.Ordinary KeygenCodecScalarCalculation.Ordinary; decide +kernel) .uint64 cursor2 _
      (KeygenDecodeNoneRead.plus64 u 1 (by omega) (by decide +kernel)) (KeygenDecodeStaticOuterCounter.self64 _).symm rfl
  have inc : Checked args KeygenPublicEncodeBinding077.node024 s2 s3 .normal :=
    evaluate args s2 _ _ _ (.postInc _ _ _ _ _ increment)
  have pending3 := (KeygenPublicEncodeCellFrame077.exec_frame "acc_len".toList args _ s2 s3 .normal inc.run (by decide +kernel)).trans pending1
  have word3 := (KeygenPublicEncodeCellFrame077.exec_frame "acc".toList args _ s2 s3 .normal inc.run (by decide +kernel)).trans word1
  have maskCalc := KeygenPublicEncodeByteCalc077.mask_calculation s3 (p-8) (by omega) pending3
  have maskEq : (((1 : BitVec 32) <<< (p-8))-1)=BitVec.ofNat 32 (2^(p-8)-1) :=
    KeygenDecodeStaticPaddingBits.mask_word (p-8)
  rw [maskEq] at maskCalc
  have mask : Checked args KeygenPublicEncodeBinding077.node025 s3 s4 .normal := by
    have source := compound args s3 "acc".toList .uint32 (.uint32 acc) .band .band
      KeygenPublicEncodeByteCalc077.maskRhs (.uint32 (BitVec.ofNat 32 (2^(p-8)-1)))
      (.uint32 (KeygenPublicBits077.masked (p-8) acc)) s3.locals
      (by decide +kernel) (by decide +kernel) word3 rfl (.pure _ _ _ maskCalc)
      (.band _ _ _ (KeygenDecodeWordOps.and32 _ _))
    simpa only [KeygenDecodeWordOps.self32,KeygenPublicEncodeByteCalc077.source_mask,set32,after,s4,s3,s2,s1] using source
  have body : Checked args KeygenPublicEncodeBinding077.node030 s s4 .normal :=
    seq args _ _ s s1 s4 .normal drop (seq args _ _ s1 s2 s4 .normal emit
      (seq args _ _ s2 s3 s4 .normal inc (seq args _ _ s3 s4 s4 .normal mask (skip args s4))))
  have full : Checked args KeygenPublicEncodeBinding077.node031 s s4 .normal := by
    have source := scope args _ s s4 .normal (by intro impossible; cases impossible) body
    rw [empty_scope _ _ _ rfl] at source
    exact source
  have context4 := context_frame args out s s4 _ .normal full.run (by unfold Checks; decide +kernel) ready.context
  have remaining4 := (KeygenPublicEncodeCellFrame077.exec_frame "n".toList args _ s s4 .normal full.run (by decide +kernel)).trans ready.remaining
  refine ⟨full,⟨context4,ready.pointer,remaining4,?_,?_,?_⟩,store⟩
  · rfl
  · exact (KeygenPublicEncodeCellFrame077.exec_frame "acc_len".toList args _ s3 s4 .normal mask.run (by decide +kernel)).trans pending3
  · rfl

end FT1536.Source3.KeygenPublicEncodeDrainStep077
