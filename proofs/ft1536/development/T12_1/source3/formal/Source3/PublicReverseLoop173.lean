import Source3.PublicReverseBody173
import Source3.PublicMiddleLoop161

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicReverseLoop173
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenPublicWord (Eval)
open KeygenNttLoopSupport (USlot u64)
open PublicMiddleWrites161 (MemoryFrame)
open PublicMiddleLoop161 (Fixed body_context fixed_after fixed_increment guard increment
  frame_refl frame_trans frame_increment)

theorem guard_same : KeygenPublicReverseProgram.guard=PublicTailShape159.midInnerGuard := by decide

theorem remaining (count v : Nat) (s : State) (a : ArrayPointer) (ht stop : Nat)
    (fixed : Fixed s a ht stop) (counter : USlot s "v" v) (finish : v+count=stop) :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicReverseProgram.loop s ⟨after,.normal⟩ ∧
      Fixed after a ht stop ∧ USlot after "v" stop ∧ MemoryFrame s after a := by
  induction count generalizing v s with
  | zero =>
      have equal : v=stop := by omega
      subst v
      have guardFalse : Eval [] s KeygenPublicReverseProgram.guard (C99ScalarReference.boolean false) := by
        simpa only [guard_same,Nat.lt_irrefl,decide_false] using guard s a ht stop stop fixed counter (by omega)
      exact ⟨s,.loopFalse _ _ _ _ _ guardFalse (by decide),fixed,counter,frame_refl s a⟩
  | succ count ih =>
      have inside : v < stop := by omega
      have limit := fixed.limit
      obtain ⟨middle,bodyRun,bodyFrame⟩ := PublicReverseBody173.source s a v ht
        (body_context s a ht stop v fixed counter inside)
      have middleFixed := fixed_after s middle a ht stop fixed bodyFrame
      have middleCounter : USlot middle "v" v := (congrFun bodyFrame.locals _).trans counter
      let next := bindValue middle "v".toList .uint64 (u64 (v+1))
      have step := increment middle v (by omega) middleCounter
      have nextFixed := fixed_increment middle a ht stop v middleFixed
      have nextCounter := PublicGenerateRow159.u64_slot_after middle "v" (v+1) (by omega)
      obtain ⟨after,rest,lastFixed,lastCounter,restFrame⟩ :=
        ih (v+1) next nextFixed nextCounter (by omega)
      have yes : Eval [] s KeygenPublicReverseProgram.guard (C99ScalarReference.boolean true) := by
        simpa only [guard_same,inside,decide_true] using guard s a ht stop v fixed counter (by omega)
      exact ⟨after,.loopNormal _ _ _ s middle next ⟨after,.normal⟩
        (C99ScalarReference.boolean true) yes (by decide) bodyRun step rest,
        lastFixed,lastCounter,frame_trans s next after a
          (frame_trans s middle next a bodyFrame.toMemoryFrame (frame_increment middle a v)) restFrame⟩

theorem source (s : State) (a : ArrayPointer) (ht stop start : Nat)
    (fixed : Fixed s a ht stop) (counter : USlot s "v" start) (bound : start ≤ stop) :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicReverseProgram.loop s ⟨after,.normal⟩ ∧
      Fixed after a ht stop ∧ USlot after "v" stop ∧ MemoryFrame s after a :=
  remaining (stop-start) start s a ht stop fixed counter (by omega)

end FT1536.Source3.PublicReverseLoop173
