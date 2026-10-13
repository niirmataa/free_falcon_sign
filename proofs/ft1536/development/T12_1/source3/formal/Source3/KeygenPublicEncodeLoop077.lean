import Source3.KeygenPublicEncodeIteration077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEncodeLoop077
open KeygenCodecSyntax KeygenPublicEncodeValues077 KeygenPublicEncodeExecution077 C99MemoryReference
open KeygenPublicEncodeDynamic077 KeygenPublicEncodeCertified077 KeygenPublicEncodeReady077

theorem guard (s : State) (n : Nat) (small : n≤1536)
    (remaining : Cell "n" .uint64 (.uint64 (BitVec.ofNat 64 n)) s.locals) :
    KeygenPublicEncodePure077.Computes s.locals KeygenPublicEncodeBinding077.guard039
      (C99ScalarReference.boolean (decide (0<n))) := by
  have source := C99IntegerReference.CompareExec.step .gt (.uint64 (BitVec.ofNat 64 n)) (.int32 0)
    .uint64 rfl (.uint64 (BitVec.ofNat 64 n)) (.uint64 0) (KeygenDecodeStaticOuterCounter.self64 _).symm rfl
  rw [KeygenCodecNoneCursor.unsigned_nat64 n (by omega)] at source
  have compare : C99IntegerReference.CompareExec .gt (.uint64 (BitVec.ofNat 64 n)) (.int32 0)
      (C99ScalarReference.boolean (decide (0<n))) := by
    change C99IntegerReference.CompareExec .gt (.uint64 (BitVec.ofNat 64 n)) (.int32 0)
      (C99ScalarReference.boolean (decide ((0 : Int)<(n : Int)))) at source
    simpa only [show (0 : Int)<(n : Int) ↔ 0<n by omega] using source
  exact .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold KeygenCodecScalarCalculation.Ordinary; decide +kernel) remaining)
    (.number _ _ _ (by decide +kernel)) (.gt _ _ _ compare)

theorem input_frame (a b : Memory) (out ptr : ArrayPointer) (u : Nat) (bytes : List (BitVec 8))
    (separate : ptr.block≠out.block)
    (trace : KeygenCodecByteHistory.Trace a b (KeygenCodecStaticHistory.positions (some out) u bytes)) :
    KeygenCodecStaticMaterial.Preserved ptr.block a b := by
  have away : KeygenCodecStaticMaterial.Separated (some out) ptr.block := by
    intro dst same
    cases Option.some.inj same
    exact separate
  exact ⟨KeygenCodecStaticMaterial.trace_sizes _ _ _ trace,fun offset =>
    KeygenCodecByteHistory.outside _ _ _ trace ptr.block offset
      (fun write member => Or.inl (KeygenCodecStaticMaterial.positions_away (some out) ptr.block u bytes away write member))⟩

theorem loop (inputs : List (BitVec 16)) (args : Args) (s : State) (out ptr : ArrayPointer) (u p : Nat) (acc : BitVec 32)
    (count : inputs.length≤1536) (small : p<8)
    (budget : u+(KeygenPublicBits077.bytes inputs p acc).length≤2880) (enough : 2880≤args.capacity.toNat)
    (ready : Ready args out ptr inputs.length u p acc s) (legal : WritableBytes s.heap out 2880)
    (words : KeygenCodecStaticMaterial.Words s.heap ptr inputs) (separate : ptr.block≠out.block) :
    ∃ t lastPtr, Checked args KeygenPublicEncodeBinding077.node039 s t .normal ∧
      Ready args out lastPtr 0 (u+(KeygenPublicBits077.bytes inputs p acc).length)
        (KeygenPublicBits077.fold inputs p acc).1 (KeygenPublicBits077.fold inputs p acc).2 t ∧
      KeygenCodecByteHistory.Trace s.heap t.heap
        (KeygenCodecStaticHistory.positions (some out) u (KeygenPublicBits077.bytes inputs p acc)) ∧
      WritableBytes t.heap out 2880 := by
  induction inputs generalizing s ptr u p acc with
  | nil =>
    have same : withLocals s s.locals=s := by cases s; rfl
    have source := KeygenPublicEncodeCertifiedLoop077.done args KeygenPublicEncodeBinding077.guard039
      KeygenPublicEncodeBinding077.node038 s _ s.locals (.pure _ _ _ (guard s 0 (by decide +kernel) ready.remaining))
      (by decide +kernel)
    rw [same] at source
    exact ⟨s,ptr,source,by simpa only [KeygenPublicBits077.bytes,List.length_nil,Nat.add_zero,KeygenPublicBits077.fold] using ready,.nil _,legal⟩
  | cons input rest ih =>
    cases words with
    | cons ptr next input rest load advance tail =>
      have nextBlock : next.block=ptr.block := by cases advance; rfl
      have split := budget
      simp only [KeygenPublicBits077.bytes,List.length_append] at split
      obtain ⟨middle,iteration,middleReady,firstTrace,middleLegal⟩ := KeygenPublicEncodeIteration077.iteration args s out ptr next
        (rest.length+1) u p acc input (by omega) small (by omega) enough ready legal advance load
      have nextWords : KeygenCodecStaticMaterial.Words middle.heap next rest :=
        KeygenCodecStaticMaterial.words_preserved ptr.block s.heap middle.heap
          (input_frame _ _ out ptr u _ separate firstTrace) next nextBlock rest tail
      obtain ⟨t,lastPtr,restRun,lastReady,tailTrace,lastLegal⟩ := ih middle next
        (u+(KeygenPublicBits077.coefficientBytes p acc input).length) (KeygenPublicBits077.nextPending p)
        (KeygenPublicBits077.nextWord p acc input) (by simp only [List.length_cons] at count; omega)
        (by unfold KeygenPublicBits077.nextPending; exact Nat.mod_lt _ (by decide +kernel))
        (by omega) middleReady middleLegal nextWords (by rw [nextBlock]; exact separate)
      have same : withLocals s s.locals=s := by cases s; rfl
      have full := KeygenPublicEncodeCertifiedLoop077.next args KeygenPublicEncodeBinding077.guard039
        KeygenPublicEncodeBinding077.node038 s middle t .normal _ s.locals
        (.pure _ _ _ (guard s (rest.length+1) count ready.remaining))
        (by simp [KeygenCodecValues.truth,C99ScalarReference.boolean,C99IntegerReference.Value.integer])
        (by rw [same]; exact iteration) restRun
      refine ⟨t,lastPtr,full,?_,?_,lastLegal⟩
      · simpa only [KeygenPublicBits077.bytes,KeygenPublicBits077.fold,List.length_append,Nat.add_assoc] using lastReady
      · rw [KeygenPublicBits077.bytes,KeygenCodecStaticHistory.positions_append]
        exact KeygenCodecByteHistory.append _ _ _ _ _ firstTrace tailTrace

end FT1536.Source3.KeygenPublicEncodeLoop077
