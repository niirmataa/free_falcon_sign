import Source3.KeygenPublicEncodeDrain077
import Source3.KeygenPublicEncodeSequence077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEncodeIteration077
open KeygenCodecSyntax KeygenPublicEncodeValues077 KeygenPublicEncodeExecution077 C99MemoryReference
open KeygenPublicEncodeDynamic077 KeygenPublicEncodeCertified077 KeygenPublicEncodeReady077

theorem iteration (args : Args) (s : State) (out ptr next : ArrayPointer) (n u p : Nat)
    (acc : BitVec 32) (input : BitVec 16) (positive : 1≤n) (small : p<8)
    (budget : u+(KeygenPublicBits077.coefficientBytes p acc input).length≤2880)
    (enough : 2880≤args.capacity.toNat) (ready : Ready args out ptr n u p acc s)
    (legal : WritableBytes s.heap out 2880) (advance : PointerAdd ptr 1 next) (load : Load16 s.heap ptr input) :
    ∃ t, Checked args KeygenPublicEncodeBinding077.node038 s t .normal ∧
      Ready args out next (n-1) (u+(KeygenPublicBits077.coefficientBytes p acc input).length)
        (KeygenPublicBits077.nextPending p) (KeygenPublicBits077.nextWord p acc input) t ∧
      KeygenCodecByteHistory.Trace s.heap t.heap
        (KeygenCodecStaticHistory.positions (some out) u (KeygenPublicBits077.coefficientBytes p acc input)) ∧
      WritableBytes t.heap out 2880 := by
  obtain ⟨prepared,middleReady,heap⟩ := KeygenPublicEncodePrepare077.prepare args s out ptr next n u p acc input
    positive small ready advance load
  let middle := KeygenPublicEncodePrepare077.after s next n p acc input
  have drainBudget : u+(p+15)/8≤2880 := by
    simpa only [KeygenPublicBits077.coefficientBytes,KeygenPublicBits077.drain_size] using budget
  obtain ⟨t,drained,lastReady,trace,lastLegal⟩ := KeygenPublicEncodeDrain077.drain ((p+15)/8) args middle out next (n-1) u (p+15)
    (KeygenPublicBits077.appended acc input) (by omega) (by omega) (by omega) drainBudget enough middleReady (by rw [heap]; exact legal)
  have suffix : Checked args KeygenPublicEncodeBinding077.node034 middle t .normal :=
    seq args _ _ middle t t .normal drained (skip args t)
  have inside : Checked args KeygenPublicEncodeBinding077.node037 s t .normal :=
    KeygenPublicEncodeSequence077.append_checked
      [KeygenPublicEncodeBinding077.node009,KeygenPublicEncodeBinding077.node010,KeygenPublicEncodeBinding077.node011]
      args s middle t KeygenPublicEncodeBinding077.node034 .normal prepared suffix
  have full : Checked args KeygenPublicEncodeBinding077.node038 s t .normal := by
    have source := scope args _ s t .normal (by intro impossible; cases impossible) inside
    rw [empty_scope _ _ _ rfl] at source
    exact source
  refine ⟨t,full,?_,?_,lastLegal⟩
  · simpa only [KeygenPublicBits077.coefficientBytes,KeygenPublicBits077.drain_size,
      KeygenPublicBits077.nextPending,KeygenPublicBits077.nextWord,
      show p+15-8*((p+15)/8)=(p+15)%8 by omega] using lastReady
  · rw [heap] at trace
    exact trace

end FT1536.Source3.KeygenPublicEncodeIteration077
