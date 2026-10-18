import Source3.PublicMiddleBody161

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicMiddleLoop161
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenPublicExec (Exec)
open KeygenPublicWord (Eval)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicTableAtoms (Slot)
open PublicGenerateTable159 (Written)
open PublicMiddleWrites161 (MemoryFrame)
open PublicTailShape159 (midInnerGuard midInnerInc midInnerLoop)

structure Fixed (s : State) (a : ArrayPointer) (ht stop : Nat) : Prop where
  limit : stop+ht ≤ 1536
  capacity : a.index+1536 ≤ a.count
  binding : s.arrays "a".toList=some a
  half : USlot s "ht" ht
  stopSlot : USlot s "v2" stop
  factor : ∃ w, Slot s "s" w
  width : a.elementBytes=2
  writable : s.heap.writable a.block=true
  allocated : ∀ j, j < 1536 → Allocated s.heap (element a j)
  written : ∀ j, j < 1536 → Written s.heap (element a j)

theorem frame_refl (s : State) (a : ArrayPointer) : MemoryFrame s s a :=
  ⟨rfl,rfl,fun _ _ _ => rfl,fun _ old => old⟩

theorem frame_trans (s middle after : State) (a : ArrayPointer)
    (first : MemoryFrame s middle a) (second : MemoryFrame middle after a) :
    MemoryFrame s after a :=
  ⟨second.size.trans first.size,second.writable.trans first.writable,
    fun b hb o => (second.outside b hb o).trans (first.outside b hb o),
    fun j old => second.written j (first.written j old)⟩

theorem body_context (s : State) (a : ArrayPointer) (ht stop v : Nat)
    (fixed : Fixed s a ht stop) (counter : USlot s "v" v) (inside : v < stop) :
    PublicMiddleBody161.Context s a v ht := by
  have limit := fixed.limit
  have capacity := fixed.capacity
  exact ⟨by omega,by omega,fixed.binding,counter,fixed.half,fixed.factor,
    fixed.written v (by omega),fixed.written (v+ht) (by omega),fixed.width,
    fixed.writable,fixed.allocated v (by omega),fixed.allocated (v+ht) (by omega)⟩

theorem fixed_after (s after : State) (a : ArrayPointer) (ht stop : Nat)
    (fixed : Fixed s a ht stop) (frame : PublicMiddleBody161.Frame s after a) :
    Fixed after a ht stop := by
  refine ⟨fixed.limit,fixed.capacity,?_,?_,?_,?_,fixed.width,?_,?_,?_⟩
  · rw [frame.arrays]; exact fixed.binding
  · exact (congrFun frame.locals _).trans fixed.half
  · exact (congrFun frame.locals _).trans fixed.stopSlot
  · obtain ⟨w,slot⟩ := fixed.factor
    exact ⟨w,(congrFun frame.locals _).trans slot⟩
  · rw [frame.writable]; exact fixed.writable
  · intro j hj
    simpa only [Allocated,frame.size] using fixed.allocated j hj
  · intro j hj
    exact frame.written j (fixed.written j hj)

theorem fixed_increment (s : State) (a : ArrayPointer) (ht stop v : Nat)
    (fixed : Fixed s a ht stop) :
    Fixed (bindValue s "v".toList .uint64 (u64 (v+1))) a ht stop := by
  refine ⟨fixed.limit,fixed.capacity,fixed.binding,?_,?_,?_,fixed.width,
    fixed.writable,fixed.allocated,fixed.written⟩
  · exact PublicGenerateRow159.keep_u64 s "ht" "v" .uint64 _ ht (by decide) fixed.half
  · exact PublicGenerateRow159.keep_u64 s "v2" "v" .uint64 _ stop (by decide) fixed.stopSlot
  · obtain ⟨w,slot⟩ := fixed.factor
    exact ⟨w,PublicGenerateRow159.keep_slot s "s" "v" .uint64 _ w (by decide) slot⟩

theorem guard (s : State) (a : ArrayPointer) (ht stop v : Nat)
    (fixed : Fixed s a ht stop) (counter : USlot s "v" v) (bound : v ≤ stop) :
    Eval [] s midInnerGuard (C99ScalarReference.boolean (decide (v < stop))) := by
  have limit := fixed.limit
  exact .cmp .lt _ _ _ _ _ (.scalar _ _ (PublicGenerateIndex159.var_u64 s "v" v counter))
    (.scalar _ _ (PublicGenerateIndex159.var_u64 s "v2" stop fixed.stopSlot))
    (C99NatWord141.less v stop (by omega) (by omega))

theorem increment (s : State) (v : Nat) (bound : v < 2^64) (counter : USlot s "v" v) :
    Exec KeygenPublicSource.program [] midInnerInc s
      ⟨bindValue s "v".toList .uint64 (u64 (v+1)),.normal⟩ :=
  .scalar _ _ _ (.assign _ _ _ .uint64 (some (u64 v)) (u64 (v+1)) counter
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ counter)
      (.literal .int32 1) (C99NatWord141.add_one v bound)))

theorem frame_increment (s : State) (a : ArrayPointer) (v : Nat) :
    MemoryFrame s (bindValue s "v".toList .uint64 (u64 (v+1))) a :=
  ⟨rfl,rfl,fun _ _ _ => rfl,fun _ old => old⟩

theorem remaining (count v : Nat) (s : State) (a : ArrayPointer) (ht stop : Nat)
    (fixed : Fixed s a ht stop) (counter : USlot s "v" v) (finish : v+count=stop) :
    ∃ after, Exec KeygenPublicSource.program [] midInnerLoop s ⟨after,.normal⟩ ∧
      Fixed after a ht stop ∧ USlot after "v" stop ∧ MemoryFrame s after a := by
  induction count generalizing v s with
  | zero =>
      have equal : v=stop := by omega
      subst v
      have guardFalse : Eval [] s midInnerGuard (C99ScalarReference.boolean false) := by
        simpa only [Nat.lt_irrefl,decide_false] using guard s a ht stop stop fixed counter (by omega)
      exact ⟨s,.loopFalse _ _ _ _ _ guardFalse (by decide),fixed,counter,frame_refl s a⟩
  | succ count ih =>
      have inside : v < stop := by omega
      have limit := fixed.limit
      obtain ⟨middle,bodyRun,bodyFrame⟩ := PublicMiddleBody161.source s a v ht
        (body_context s a ht stop v fixed counter inside)
      have middleFixed := fixed_after s middle a ht stop fixed bodyFrame
      have middleCounter : USlot middle "v" v := (congrFun bodyFrame.locals _).trans counter
      let next := bindValue middle "v".toList .uint64 (u64 (v+1))
      have step := increment middle v (by omega) middleCounter
      have nextFixed := fixed_increment middle a ht stop v middleFixed
      have nextCounter := PublicGenerateRow159.u64_slot_after middle "v" (v+1) (by omega)
      obtain ⟨after,rest,lastFixed,lastCounter,restFrame⟩ :=
        ih (v+1) next nextFixed nextCounter (by omega)
      have yes : Eval [] s midInnerGuard (C99ScalarReference.boolean true) := by
        simpa only [inside,decide_true] using guard s a ht stop v fixed counter (by omega)
      exact ⟨after,.loopNormal _ _ _ s middle next ⟨after,.normal⟩
        (C99ScalarReference.boolean true) yes (by decide) bodyRun step rest,
        lastFixed,lastCounter,frame_trans s next after a
          (frame_trans s middle next a bodyFrame.toMemoryFrame (frame_increment middle a v)) restFrame⟩

theorem source (s : State) (a : ArrayPointer) (ht stop start : Nat)
    (fixed : Fixed s a ht stop) (counter : USlot s "v" start) (bound : start ≤ stop) :
    ∃ after, Exec KeygenPublicSource.program [] midInnerLoop s ⟨after,.normal⟩ ∧
      Fixed after a ht stop ∧ USlot after "v" stop ∧ MemoryFrame s after a :=
  remaining (stop-start) start s a ht stop fixed counter (by omega)

end FT1536.Source3.PublicMiddleLoop161
