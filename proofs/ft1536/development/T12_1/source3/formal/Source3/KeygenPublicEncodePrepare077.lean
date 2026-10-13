import Source3.KeygenPublicEncodeAppend077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEncodePrepare077
open KeygenCodecSyntax KeygenPublicEncodeValues077 KeygenPublicEncodeExecution077 C99MemoryReference
open KeygenPublicEncodeDynamic077 KeygenPublicEncodeCertified077 KeygenPublicEncodeReady077

def code : Stmt := .seq KeygenPublicEncodeBinding077.node009
  (.seq KeygenPublicEncodeBinding077.node010 (.seq KeygenPublicEncodeBinding077.node011 .skip))
def after (s : State) (next : ArrayPointer) (n p : Nat) (acc : BitVec 32) (input : BitVec 16) : State :=
  setPending (set64 (KeygenPublicEncodeAppend077.after s next acc input) "n" (BitVec.ofNat 64 (n-1))) (p+15)

theorem prepare (args : Args) (s : State) (out ptr next : ArrayPointer) (n u p : Nat)
    (acc : BitVec 32) (input : BitVec 16) (positive : 1≤n) (small : p<8)
    (ready : Ready args out ptr n u p acc s) (advance : PointerAdd ptr 1 next) (load : Load16 s.heap ptr input) :
    Checked args code s (after s next n p acc input) .normal ∧
      Ready args out next (n-1) u (p+15) (KeygenPublicBits077.appended acc input) (after s next n p acc input) ∧
      (after s next n p acc input).heap=s.heap := by
  let s1 := KeygenPublicEncodeAppend077.after s next acc input
  let s2 := set64 s1 "n" (BitVec.ofNat 64 (n-1))
  let s3 := after s next n p acc input
  have append : Checked args KeygenPublicEncodeBinding077.node009 s s1 .normal :=
    KeygenPublicEncodeAppend077.source_append args s ptr next acc input ready.pointer advance load ready.accumulator
  have n1 := (KeygenPublicEncodeCellFrame077.exec_frame "n".toList args _ s s1 .normal append.run (by decide +kernel)).trans ready.remaining
  have decrement := KeygenPublicInteger077.decrement64 (BitVec.ofNat 64 n)
  rw [show (1 : BitVec 64)=BitVec.ofNat 64 1 by decide +kernel,
    BitVec.ofNat_sub_ofNat_of_le n 1 (by decide +kernel) positive] at decrement
  have update : ScalarUpdate "n".toList (-1) s1.locals (.uint64 (BitVec.ofNat 64 n))
      (.uint64 (BitVec.ofNat 64 (n-1))) s2.locals :=
    .scalar (by unfold KeygenPublicEncodePure077.Ordinary KeygenCodecScalarCalculation.Ordinary; decide +kernel) .uint64 n1 _ decrement
      (KeygenDecodeStaticOuterCounter.self64 _).symm rfl
  have drop : Checked args KeygenPublicEncodeBinding077.node010 s1 s2 .normal :=
    evaluate args s1 _ _ _ (.postDec _ _ _ _ _ update)
  have p1 := (KeygenPublicEncodeCellFrame077.exec_frame "acc_len".toList args _ s s1 .normal append.run (by decide +kernel)).trans ready.pending
  have p2 := (KeygenPublicEncodeCellFrame077.exec_frame "acc_len".toList args _ s1 s2 .normal drop.run (by decide +kernel)).trans p1
  have count : Checked args KeygenPublicEncodeBinding077.node011 s2 s3 .normal := by
    have source := compound args s2 "acc_len".toList .int32 (.int32 (BitVec.ofNat 32 p)) .add .add
      (.number .i32 15) (.int32 15) (.int32 (BitVec.ofNat 32 (p+15))) s2.locals
      (by decide +kernel) (by decide +kernel) p2 rfl (.pure _ _ _ (.number _ _ _ (by decide +kernel)))
      (.add _ _ _ (KeygenPublicInteger077.plus_i32 p 15 (by omega)))
    simpa only [KeygenPublicInteger077.self_i32,KeygenPublicEncodeBinding077.node011,setPending,after,s3,s2,s1] using source
  have full : Checked args code s s3 .normal :=
    seq args _ _ s s1 s3 .normal append (seq args _ _ s1 s2 s3 .normal drop
      (seq args _ _ s2 s3 s3 .normal count (skip args s3)))
  have context := context_frame args out s s3 code .normal full.run (by unfold Checks; decide +kernel) ready.context
  have cursor := (KeygenPublicEncodeCellFrame077.exec_frame "u".toList args code s s3 .normal full.run (by decide +kernel)).trans ready.cursor
  refine ⟨full,⟨context,?_,?_,cursor,?_,?_⟩,rfl⟩
  · rfl
  · rfl
  · rfl
  · rfl

end FT1536.Source3.KeygenPublicEncodePrepare077
