import Source3.PublicRoundScalar163

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicRoundLoop163
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenPublicWord (Eval)
open KeygenNttLoopSupport (USlot u64)
open PublicRoundContext163 (Arrays Valid)
open PublicMiddleWrites161 (MemoryFrame)
open PublicTailShape159 (midGuard midLoop)

def Plan : Nat → Nat → Nat → Prop
  | 0,t,_ => t ≤ 3 ∧ t < 2^64
  | count+1,t,m => 3 < t ∧ Valid t m ∧ Plan count (t/2) (m*2)
def finalT : Nat → Nat → Nat
  | 0,t => t
  | count+1,t => finalT count (t/2)
def finalM : Nat → Nat → Nat
  | 0,m => m
  | count+1,m => finalM count (m*2)

theorem actual_plan : Plan 8 768 2 := by
  simp only [Plan]
  repeat' first | apply And.intro | apply Valid.mk
  all_goals decide

theorem actual_t : finalT 8 768=3 := by decide
theorem actual_m : finalM 8 2=512 := by decide

theorem source (count t m : Nat) (s : State) (a gm : ArrayPointer)
    (ctx : Arrays s a gm) (plan : Plan count t m)
    (tSlot : USlot s "t" t) (mSlot : USlot s "m" m)
    (vCell : ∃ old, s.locals "v".toList=some (.uint64,old)) :
    ∃ after, Exec KeygenPublicSource.program [] midLoop s ⟨after,.normal⟩ ∧
      Arrays after a gm ∧ USlot after "t" (finalT count t) ∧ USlot after "m" (finalM count m) ∧
      (∃ old, after.locals "v".toList=some (.uint64,old)) ∧ MemoryFrame s after a := by
  induction count generalizing t m s with
  | zero =>
      have stopped : ¬3 < t := by have := plan.1; omega
      have no : Eval [] s midGuard (C99ScalarReference.boolean false) := by
        simpa only [stopped,decide_false] using PublicRoundScalar163.guard s t plan.2 tSlot
      exact ⟨s,.loopFalse _ _ _ _ _ no (by decide),ctx,tSlot,mSlot,vCell,
        PublicMiddleLoop161.frame_refl s a⟩
  | succ count ih =>
      obtain ⟨active,valid,restPlan⟩ := plan
      obtain ⟨middle,bodyRun,midCtx,midT,midM,midV,bodyMemory⟩ :=
        PublicRoundBody163.source s a gm t m ctx valid tSlot mSlot vCell
      let next := bindValue middle "m".toList .uint64 (u64 (m*2))
      have groupsBound := valid.groupsBound
      have step := PublicRoundScalar163.increment middle m (by omega) midM
      have nextCtx := PublicRoundScalar163.arrays_increment middle a gm m midCtx
      have nextT := PublicGenerateRow159.keep_u64 middle "t" "m" .uint64 (u64 (m*2))
        (t/2) (by decide) midT
      have nextM := PublicGenerateRow159.u64_slot_after middle "m" (m*2) (by omega)
      have nextV : ∃ old, next.locals "v".toList=some (.uint64,old) := midV
      obtain ⟨after,rest,lastCtx,lastT,lastM,lastV,restMemory⟩ :=
        ih (t/2) (m*2) next nextCtx restPlan nextT nextM nextV
      have yes : Eval [] s midGuard (C99ScalarReference.boolean true) := by
        simpa only [active,decide_true] using PublicRoundScalar163.guard s t valid.wordBound tSlot
      exact ⟨after,.loopNormal _ _ _ s middle next ⟨after,.normal⟩
        (C99ScalarReference.boolean true) yes (by decide) bodyRun step rest,
        lastCtx,lastT,lastM,lastV,
        PublicMiddleLoop161.frame_trans s middle after a bodyMemory
          (PublicMiddleLoop161.frame_trans middle next after a
            (PublicGroupBody162.same_heap_frame middle next a rfl) restMemory)⟩

theorem eight_rounds (s : State) (a gm : ArrayPointer) (ctx : Arrays s a gm)
    (tSlot : USlot s "t" 768) (mSlot : USlot s "m" 2)
    (vCell : ∃ old, s.locals "v".toList=some (.uint64,old)) :
    ∃ after, Exec KeygenPublicSource.program [] midLoop s ⟨after,.normal⟩ ∧
      Arrays after a gm ∧ USlot after "t" 3 ∧ USlot after "m" 512 ∧
      (∃ old, after.locals "v".toList=some (.uint64,old)) ∧ MemoryFrame s after a := by
  simpa only [actual_t,actual_m] using source 8 768 2 s a gm ctx actual_plan tSlot mSlot vCell

end FT1536.Source3.PublicRoundLoop163
