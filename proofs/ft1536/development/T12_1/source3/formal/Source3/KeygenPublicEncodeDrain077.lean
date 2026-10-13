import Source3.KeygenPublicEncodeDrainStep077
import Source3.KeygenCodecStaticMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEncodeDrain077
open KeygenCodecSyntax KeygenPublicEncodeValues077 KeygenPublicEncodeExecution077 C99MemoryReference
open KeygenPublicEncodeDynamic077 KeygenPublicEncodeCertified077 KeygenPublicEncodeReady077

theorem guard (s : State) (p : Nat) (small : p<32)
    (pending : Cell "acc_len" .int32 (.int32 (BitVec.ofNat 32 p)) s.locals) :
    KeygenPublicEncodePure077.Computes s.locals KeygenPublicEncodeBinding077.guard032
      (C99ScalarReference.boolean (decide (8≤p))) := by
  have compare := KeygenPublicInteger077.compare_i32 .ge p 8 (by omega) (by decide +kernel)
  have same : C99IntegerReference.compare .ge (p : Int) ((8 : Nat) : Int)=decide (8≤p) := by
    simp only [C99IntegerReference.compare,Int.ofNat_le]
  rw [same] at compare
  exact .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold KeygenCodecScalarCalculation.Ordinary; decide +kernel) pending)
    (.number _ _ _ (by decide +kernel)) (.ge _ _ _ compare)

theorem drain (count : Nat) (args : Args) (s : State) (out ptr : ArrayPointer) (n u p : Nat) (acc : BitVec 32)
    (fits : 8*count≤p) (last : p-8*count<8) (small : p<32) (budget : u+count≤2880)
    (enough : 2880≤args.capacity.toNat) (ready : Ready args out ptr n u p acc s)
    (legal : WritableBytes s.heap out 2880) :
    ∃ t, Checked args KeygenPublicEncodeBinding077.node032 s t .normal ∧
      Ready args out ptr n (u+count) (p-8*count) (KeygenPublicBits077.drainWord count p acc) t ∧
      KeygenCodecByteHistory.Trace s.heap t.heap
        (KeygenCodecStaticHistory.positions (some out) u (KeygenPublicBits077.drainBytes count p acc)) ∧
      WritableBytes t.heap out 2880 := by
  induction count generalizing s u p acc with
  | zero =>
    have size : p<8 := by simpa only [Nat.mul_zero,Nat.sub_zero] using last
    have same : withLocals s s.locals=s := by cases s; rfl
    have result := KeygenPublicEncodeCertifiedLoop077.done args KeygenPublicEncodeBinding077.guard032 KeygenPublicEncodeBinding077.node031 s _ s.locals
      (.pure _ _ _ (guard s p small ready.pending))
      (by simp [size.not_ge,KeygenCodecValues.truth,C99ScalarReference.boolean,C99IntegerReference.Value.integer])
    rw [same] at result
    exact ⟨s,result,by simpa only [Nat.add_zero,Nat.mul_zero,Nat.sub_zero,KeygenPublicBits077.drainWord] using ready,.nil _,legal⟩
  | succ count ih =>
    have positive : 8≤p := by omega
    obtain ⟨iteration,middleReady,store⟩ := KeygenPublicEncodeDrainStep077.step args s out ptr n u p acc positive small
      (by omega) enough ready legal
    let middle := KeygenPublicEncodeDrainStep077.after s out u p acc
    have middleLegal := writable_preserved s.heap middle.heap out (byteOff out u) 2880 _ legal store
    obtain ⟨t,rest,lastReady,trace,lastLegal⟩ := ih middle (u+1) (p-8) (KeygenPublicBits077.masked (p-8) acc)
      (by omega) (by omega) (by omega) (by omega) middleReady middleLegal
    have same : withLocals s s.locals=s := by cases s; rfl
    have full := KeygenPublicEncodeCertifiedLoop077.next args KeygenPublicEncodeBinding077.guard032 KeygenPublicEncodeBinding077.node031 s middle t .normal _ s.locals
      (.pure _ _ _ (guard s p small ready.pending))
      (by simp [positive,KeygenCodecValues.truth,C99ScalarReference.boolean,C99IntegerReference.Value.integer])
      (by rw [same]; exact iteration) rest
    refine ⟨t,full,?_,?_,lastLegal⟩
    · simpa only [show u+1+count=u+(count+1) by omega,
        show p-8-8*count=p-8*(count+1) by omega,KeygenPublicBits077.drainWord] using lastReady
    · change KeygenCodecByteHistory.Trace s.heap t.heap
        ((byteOff out u,KeygenPublicEncodeEmit077.byte acc (p-8))::
          KeygenCodecStaticHistory.positions (some out) (u+1)
            (KeygenPublicBits077.drainBytes count (p-8) (KeygenPublicBits077.masked (p-8) acc)))
      exact .step s.heap middle.heap t.heap _ _ _ store trace

end FT1536.Source3.KeygenPublicEncodeDrain077
