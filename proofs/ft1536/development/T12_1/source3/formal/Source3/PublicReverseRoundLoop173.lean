import Source3.PublicReverseRoundScalar173

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicReverseRoundLoop173
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenPublicWord (Eval)
open KeygenNttLoopSupport (USlot u64)
open PublicReverseRoundContext173 (Arrays Valid)
open PublicMiddleWrites161 (MemoryFrame)


def Plan : Nat → Nat → Nat → Prop
  | 0,t,_ => 1536 ≤ t ∧ t < 2^64
  | count+1,t,m => t < 1536 ∧ Valid t m ∧ Plan count (t*2) (m/2)
def finalT : Nat → Nat → Nat
  | 0,t => t
  | count+1,t => finalT count (t*2)
def finalM : Nat → Nat → Nat
  | 0,m => m
  | count+1,m => finalM count (m/2)

theorem actual_plan : Plan 8 6 256 := by
  simp only [Plan]
  repeat' first | apply And.intro | apply Valid.mk
  all_goals decide

theorem actual_t : finalT 8 6=1536 := by decide
theorem actual_m : finalM 8 256=1 := by decide

theorem source (count t m : Nat) (s : State) (a gm : ArrayPointer)
    (ctx : Arrays s a gm) (plan : Plan count t m)
    (tSlot : USlot s "t" t) (mSlot : USlot s "m" m)
    (vCell : ∃ old, s.locals "v".toList=some (.uint64,old))
    (nCell : USlot s "n" 1536) :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicReverseProgram.stageLoop s ⟨after,.normal⟩ ∧
      Arrays after a gm ∧ USlot after "t" (finalT count t) ∧ USlot after "m" (finalM count m) ∧
      (∃ old, after.locals "v".toList=some (.uint64,old)) ∧ MemoryFrame s after a := by
  induction count generalizing t m s with
  | zero =>
      have stopped : ¬t < 1536 := by have := plan.1; omega
      have no : Eval [] s KeygenPublicReverseProgram.stageGuard (C99ScalarReference.boolean false) := by
        simpa only [stopped,decide_false] using PublicReverseRoundScalar173.guard s t plan.2 tSlot nCell
      exact ⟨s,.loopFalse _ _ _ _ _ no (by decide),ctx,tSlot,mSlot,vCell,
        PublicMiddleLoop161.frame_refl s a⟩
  | succ count ih =>
      obtain ⟨active,valid,restPlan⟩ := plan
      obtain ⟨middle,bodyRun,midCtx,midT,midM,midV,bodyMemory⟩ :=
        PublicReverseRoundBody173.source s a gm t m ctx valid active tSlot mSlot vCell
      let next := bindValue middle "m".toList .uint64 (u64 (m/2))
      have groupsBound := valid.groupsBound
      have step := PublicReverseRoundScalar173.increment middle m (by omega) midM
      have nextCtx := PublicReverseRoundScalar173.arrays_increment middle a gm m midCtx
      have nextT := PublicGenerateRow159.keep_u64 middle "t" "m" .uint64 (u64 (m/2))
        (t*2) (by decide) midT
      have nextM := PublicGenerateRow159.u64_slot_after middle "m" (m/2) (by omega)
      have midN : USlot middle "n" 1536 :=
        (PublicScopedFrame162.frame _ _ _ _ _ (by decide) bodyRun).2.2 _ (by decide) |>.trans nCell
      have nextN : USlot next "n" 1536 := midN
      have nextV : ∃ old, next.locals "v".toList=some (.uint64,old) := midV
      obtain ⟨after,rest,lastCtx,lastT,lastM,lastV,restMemory⟩ :=
        ih (t*2) (m/2) next nextCtx restPlan nextT nextM nextV nextN
      have yes : Eval [] s KeygenPublicReverseProgram.stageGuard (C99ScalarReference.boolean true) := by
        simpa only [active,decide_true] using PublicReverseRoundScalar173.guard s t valid.wordBound tSlot nCell
      exact ⟨after,.loopNormal _ _ _ s middle next ⟨after,.normal⟩
        (C99ScalarReference.boolean true) yes (by decide) bodyRun step rest,
        lastCtx,lastT,lastM,lastV,
        PublicMiddleLoop161.frame_trans s middle after a bodyMemory
          (PublicMiddleLoop161.frame_trans middle next after a
            (PublicGroupBody162.same_heap_frame middle next a rfl) restMemory)⟩

theorem eight_rounds (s : State) (a gm : ArrayPointer) (ctx : Arrays s a gm)
    (tSlot : USlot s "t" 6) (mSlot : USlot s "m" 256)
    (vCell : ∃ old, s.locals "v".toList=some (.uint64,old))
    (nCell : USlot s "n" 1536) :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicReverseProgram.stageLoop s ⟨after,.normal⟩ ∧
      Arrays after a gm ∧ USlot after "t" 1536 ∧ USlot after "m" 1 ∧
      (∃ old, after.locals "v".toList=some (.uint64,old)) ∧ MemoryFrame s after a := by
  simpa only [actual_t,actual_m] using source 8 6 256 s a gm ctx actual_plan tSlot mSlot vCell nCell

end FT1536.Source3.PublicReverseRoundLoop173
