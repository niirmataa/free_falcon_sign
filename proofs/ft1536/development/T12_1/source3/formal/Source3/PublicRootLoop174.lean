import Source3.PublicRootBody174
import Source3.PublicInverseMemory172

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicRootLoop174
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenPublicWord (Eval)
open KeygenNttLoopSupport (USlot u64)
open PublicMiddleWrites161 (MemoryFrame)

structure Fixed (s : State) (a : ArrayPointer) : Prop where
  data : PublicForwardMemory167.Data s.heap a
  binding : s.arrays "a".toList=some a
  half : USlot s "hn" 768
  factor : PublicU32Locals165.Has s "r"

theorem context (s : State) (a : ArrayPointer) (u : Nat) (inside : u<768)
    (fixed : Fixed s a) (counter : USlot s "u" u) : PublicRootBody174.Context s a u := by
  have cap:=PublicForwardMemory167.capacity s.heap a fixed.data
  have allocated (j : Nat) (hj : j<1536) := (KeygenPublicRangeMemory.load_allocated _ _ _
    (Classical.choose_spec (fixed.data.written j hj))).1
  exact ⟨by omega,by omega,fixed.binding,counter,fixed.half,fixed.factor,
    fixed.data.written u (by omega),fixed.data.written (u+768) (by omega),
    PublicForwardMemory167.width s.heap a fixed.data,fixed.data.writable,
    allocated u (by omega),allocated (u+768) (by omega)⟩

theorem fixed_after (s after : State) (a : ArrayPointer) (fixed : Fixed s a)
    (frame : PublicMiddleBody161.Frame s after a) : Fixed after a := by
  refine ⟨⟨?_,fun j hj => frame.written j (fixed.data.written j hj)⟩,?_,?_,?_⟩
  · rw [frame.writable]; exact fixed.data.writable
  · rw [frame.arrays]; exact fixed.binding
  · exact (congrFun frame.locals _).trans fixed.half
  · obtain ⟨w,slot⟩ := fixed.factor
    exact ⟨w,(congrFun frame.locals _).trans slot⟩

theorem fixed_next (s : State) (a : ArrayPointer) (fixed : Fixed s a) (u : Nat) :
    Fixed (bindValue s "u".toList .uint64 (u64 (u+1))) a := ⟨fixed.data,fixed.binding,fixed.half,fixed.factor⟩

theorem increment (s : State) (u : Nat) (bound : u<2^64) (counter : USlot s "u" u) :
    Exec KeygenPublicSource.program [] KeygenPublicRootInverseProgram.increment s
      ⟨bindValue s "u".toList .uint64 (u64 (u+1)),.normal⟩ :=
  .scalar _ _ _ (.assign _ _ _ .uint64 (some (u64 u)) (u64 (u+1)) counter
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ counter) (.literal .int32 1) (C99NatWord141.add_one u bound)))

theorem guard (s : State) (u : Nat) (bound : u≤768) (counter : USlot s "u" u) (half : USlot s "hn" 768) :
    Eval [] s (.cmp .lt (KeygenPublicTableAtoms.var "u") (KeygenPublicTableAtoms.var "hn"))
      (C99ScalarReference.boolean (decide (u<768))) :=
  .cmp .lt _ _ _ _ _ (.scalar _ _ (PublicGenerateIndex159.var_u64 s "u" u counter))
    (.scalar _ _ (PublicGenerateIndex159.var_u64 s "hn" 768 half)) (C99NatWord141.less u 768 (by omega) (by decide))

theorem remaining (count u : Nat) (s : State) (a : ArrayPointer) (fixed : Fixed s a)
    (counter : USlot s "u" u) (finish : u+count=768) :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicRootInverseProgram.loop s ⟨after,.normal⟩ ∧
      Fixed after a ∧ USlot after "u" 768 ∧ MemoryFrame s after a := by
  induction count generalizing u s with
  | zero =>
    have equal : u=768 := by omega
    subst u
    have no := guard s 768 (by decide) counter fixed.half
    exact ⟨s,.loopFalse _ _ _ _ _ no (by decide),fixed,counter,PublicMiddleLoop161.frame_refl s a⟩
  | succ count ih =>
    have inside : u<768 := by omega
    obtain ⟨middle,run,frame⟩ := PublicRootBody174.source s a u (context s a u inside fixed counter)
    have midFixed := fixed_after s middle a fixed frame
    have midCounter : USlot middle "u" u := (congrFun frame.locals _).trans counter
    let next := bindValue middle "u".toList .uint64 (u64 (u+1))
    have step := increment middle u (by omega) midCounter
    obtain ⟨after,rest,lastFixed,lastCounter,memory⟩ := ih (u+1) next (fixed_next middle a midFixed u)
      (PublicGenerateRow159.u64_slot_after middle "u" (u+1) (by omega)) (by omega)
    have yes : Eval [] s (.cmp .lt (KeygenPublicTableAtoms.var "u") (KeygenPublicTableAtoms.var "hn"))
        (C99ScalarReference.boolean true) := by
      simpa only [inside,decide_true] using guard s u (by omega) counter fixed.half
    exact ⟨after,.loopNormal _ _ _ s middle next ⟨after,.normal⟩ (C99ScalarReference.boolean true)
      yes (by decide) run step rest,lastFixed,lastCounter,
      PublicMiddleLoop161.frame_trans s middle after a frame.toMemoryFrame
        (PublicMiddleLoop161.frame_trans middle next after a
          (PublicGroupBody162.same_heap_frame middle next a rfl) memory)⟩

end FT1536.Source3.PublicRootLoop174
