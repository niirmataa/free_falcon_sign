import Source3.KeygenPublicDecodeIteration077
import Source3.KeygenPublicDecodeCertifiedLoop077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicDecodeLoop077
open KeygenDecodeSyntax KeygenDecodeValues KeygenPublicDecodeExecution077 C99MemoryReference
open KeygenDecodeDynamicCalculation KeygenPublicDecodeCertified077 KeygenPublicDecodeReady077
open KeygenDecodeNoneMemory (element WritableArray Trace)

theorem guard (args : Args) (s : State) (n : Nat) (small : n≤1536)
    (remaining : Cell "n" .uint64 (.uint64 (BitVec.ofNat 64 n)) s.locals) :
    KeygenDecodeCalculation.Computes args s.heap s.buf s.locals KeygenPublicDecodeBinding077.guard043
      (C99ScalarReference.boolean (decide (0<n))) := by
  have source := C99IntegerReference.CompareExec.step .gt (.uint64 (BitVec.ofNat 64 n)) (.int32 0)
    .uint64 rfl (.uint64 (BitVec.ofNat 64 n)) (.uint64 0) (KeygenDecodeStaticOuterCounter.self64 _).symm rfl
  rw [KeygenCodecNoneCursor.unsigned_nat64 n (by omega)] at source
  have compare : C99IntegerReference.CompareExec .gt (.uint64 (BitVec.ofNat 64 n)) (.int32 0)
      (C99ScalarReference.boolean (decide (0<n))) := by
    change C99IntegerReference.CompareExec .gt (.uint64 (BitVec.ofNat 64 n)) (.int32 0)
      (C99ScalarReference.boolean (decide ((0 : Int)<(n : Int)))) at source
    simpa only [show (0 : Int)<(n : Int) ↔ 0<n by omega] using source
  exact .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) remaining)
    (.number _ _ _ (by decide +kernel)) (.gt _ _ _ compare)

theorem next (args : Args) (s middle t : State) (n : Nat) (positive : 0<n) (small : n≤1536)
    (count : Cell "n" .uint64 (.uint64 (BitVec.ofNat 64 n)) s.locals)
    (iteration : Checked args KeygenPublicDecodeBinding077.node042 s middle .normal)
    (rest : Checked args KeygenPublicDecodeBinding077.node043 middle t .normal) :
    Checked args KeygenPublicDecodeBinding077.node043 s t .normal := by
  have same : withLocals s s.locals=s := by cases s; rfl
  exact KeygenPublicDecodeCertifiedLoop077.next args KeygenPublicDecodeBinding077.guard043
    KeygenPublicDecodeBinding077.node042 s middle t .normal _ s.locals (.pure _ _ _ (guard args s n small count))
    (by simp [positive,truth,C99ScalarReference.boolean,C99IntegerReference.Value.integer])
    (by rw [same]; exact iteration) rest

theorem advance_one (heap : Memory) (dst : ArrayPointer) (i : Nat) (inside : i<1536)
    (legal : WritableArray heap dst 1536) : PointerAdd (element dst i) 1 (element dst (i+1)) := by
  have allocated := legal.2.2 i inside
  have within : (element dst i).index+1≤(element dst i).count := by have bound:=allocated.2.2.1; omega
  simpa only [element,Nat.add_assoc] using PointerAdd.within (element dst i) 1 within

theorem loop (bytes : List (BitVec 8)) (inputs : List (BitVec 16)) (args : Args) (s : State)
    (src dst : ArrayPointer) (i u p : Nat) (acc : BitVec 32)
    (count : i+inputs.length≤1536) (small : p<15) (canonical : KeygenPublicBits077.Canonical inputs)
    (wire : Wire args src (element dst i) inputs.length u p acc bytes s)
    (held : remaining p acc bytes=KeygenPublicBits077.bits inputs)
    (legal : WritableArray s.heap dst 1536) (separate : src.block≠dst.block) :
    ∃ t, Checked args KeygenPublicDecodeBinding077.node043 s t .normal ∧
      Ready args src (element dst (i+inputs.length)) 0 (u+bytes.length) 0 0 t ∧
      Trace dst s.heap t.heap i inputs := by
  induction bytes generalizing inputs s i u p acc with
  | nil =>
    have sizes := congrArg List.length held
    simp only [KeygenDecodeStaticWire.remaining,KeygenCodecStaticBitBuffer.buffer_length,
      List.length_append,KeygenDecodeStaticWire.bytes_length,List.length_nil,Nat.mul_zero,Nat.add_zero,
      KeygenPublicDecodeBits077.bits_length] at sizes
    have empty : inputs=[] := List.length_eq_zero_iff.mp (by omega)
    subst inputs
    have zeroP : p=0 := by simp only [List.length_nil,Nat.mul_zero] at sizes; omega
    subst p
    have zeroAcc : acc=0 := by
      apply BitVec.eq_of_toNat_eq
      have bound:=wire.accumulatorBound
      change acc.toNat<1 at bound
      change acc.toNat=0
      omega
    subst acc
    have same : withLocals s s.locals=s := by cases s; rfl
    have source := KeygenPublicDecodeCertifiedLoop077.done args KeygenPublicDecodeBinding077.guard043
      KeygenPublicDecodeBinding077.node042 s _ s.locals (.pure _ _ _ (guard args s 0 (by decide +kernel) wire.ready.remaining))
      (by decide +kernel)
    rw [same] at source
    exact ⟨s,source,by simpa only [List.length_nil,Nat.add_zero] using wire.ready,.nil _ _⟩
  | cons byte bytes ih =>
    have sizes := congrArg List.length held
    simp only [KeygenDecodeStaticWire.remaining,KeygenCodecStaticBitBuffer.buffer_length,
      List.length_append,KeygenDecodeStaticWire.bytes_length,List.length_cons,KeygenPublicDecodeBits077.bits_length] at sizes
    have positive : 0 < inputs.length := by omega
    by_cases emits : 15≤p+8
    · cases inputs with
      | nil => simp only [List.length_nil] at positive; omega
      | cons input rest =>
        have inside : i<1536 := by simp only [List.length_cons] at count; omega
        obtain ⟨middle,iteration,middleWire,lastBits,store⟩ := KeygenPublicDecodeIteration077.store args s src (element dst i)
          (element dst (i+1)) (rest.length+1) u p acc byte bytes input rest (by omega) small emits
          (canonical input List.mem_cons_self) wire held (advance_one s.heap dst i inside legal)
          (legal.2.2 i inside) legal.1 legal.2.1 separate
        have middleLegal := KeygenDecodeNoneMemory.legal_preserved s.heap middle.heap dst (element dst i) 1536 input legal store
        have tailCanonical : KeygenPublicBits077.Canonical rest := fun word member => canonical word (List.mem_cons_of_mem input member)
        obtain ⟨t,restRun,lastReady,trace⟩ := ih rest middle (i+1) (u+1) (p+8-15)
          (KeygenPublicBits077.masked (p+8-15) (KeygenPublicDecodeBits077.appended acc byte))
          (by simp only [List.length_cons] at count; omega) (by omega) tailCanonical middleWire lastBits middleLegal
        have full := next args s middle t (rest.length+1) (by omega) (by simp only [List.length_cons] at count; omega)
          wire.ready.remaining iteration restRun
        refine ⟨t,full,?_,.cons s.heap middle.heap t.heap i input rest store trace⟩
        simpa only [List.length_cons,show i+1+rest.length=i+(rest.length+1) by omega,
          show u+1+bytes.length=u+(bytes.length+1) by omega] using lastReady
    · obtain ⟨middle,iteration,middleWire,heap⟩ := KeygenPublicDecodeIteration077.no_store args s src (element dst i)
        inputs.length u p acc byte bytes (by omega) wire
      have middleBits : remaining (p+8) (KeygenPublicDecodeBits077.appended acc byte) bytes=KeygenPublicBits077.bits inputs :=
        (KeygenPublicDecodeBits077.refill p acc byte bytes small).trans held
      obtain ⟨t,restRun,lastReady,trace⟩ := ih inputs middle i (u+1) (p+8) (KeygenPublicDecodeBits077.appended acc byte)
        count (by omega) canonical middleWire middleBits (by rw [heap]; exact legal)
      have full := next args s middle t inputs.length positive (by omega) wire.ready.remaining iteration restRun
      rw [heap] at trace
      exact ⟨t,full,by simpa only [List.length_cons,show u+1+bytes.length=u+(bytes.length+1) by omega] using lastReady,trace⟩

end FT1536.Source3.KeygenPublicDecodeLoop077
