import Source3.PublicTailFrame160

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- One body theorem, instantiated by induction on the remaining iterations.
   No table values, independence or transform-correctness premise is used. -/
namespace FT1536.Source3.PublicTailLoop160
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenPublicWord (Eval)
open KeygenNttLoopSupport (USlot u64)
open PublicTailFirst159 (FirstInv TailEntry)
open PublicTailShape159 (firstGuard firstInc firstLoop firstPass uInit)
open PublicGenerateIndex159 (var_u64)
open PublicGenerateRow159 (keep_slot keep_u64 u64_slot_after)

theorem guard (s : State) (a gm : ArrayPointer) (u : Nat)
    (bound : u < 2^64) (inv : FirstInv s a gm u) :
    Eval [] s firstGuard (C99ScalarReference.boolean (decide (u < 768))) :=
  .cmp .lt _ _ _ _ _ (.scalar _ _ (var_u64 s "u" u inv.uSlot))
    (.scalar _ _ (var_u64 s "hn" 768 inv.hnSlot))
    (C99NatWord141.less u 768 bound (by decide))

theorem increment (s : State) (u : Nat) (bound : u < 2^64)
    (counter : USlot s "u" u) :
    Exec KeygenPublicSource.program [] firstInc s
      ⟨bindValue s "u".toList .uint64 (u64 (u+1)),.normal⟩ :=
  .scalar _ _ _ (.assign _ _ _ .uint64 (some (u64 u)) (u64 (u+1)) counter
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ counter)
      (.literal .int32 1) (C99NatWord141.add_one u bound)))

theorem loop_source (count u : Nat) (s : State) (a gm : ArrayPointer)
    (inv : FirstInv s a gm u) (finish : u+count=768) :
    ∃ after, Exec KeygenPublicSource.program [] firstLoop s ⟨after,.normal⟩ ∧
      FirstInv after a gm 768 := by
  induction count generalizing u s with
  | zero =>
      have equal : u=768 := by omega
      subst u
      exact ⟨s,.loopFalse _ _ _ _ _ (guard s a gm 768 (by decide) inv) (by decide),inv⟩
  | succ count ih =>
      have inside : u < 768 := by omega
      obtain ⟨middle,bodyRun,invMiddle⟩ := PublicTailFrame160.body_source s a gm u inside inv
      have step := increment middle u (by omega) invMiddle.uSlot
      have invNext := PublicTailFirst159.firstInv_next middle a gm u (by omega) invMiddle
      obtain ⟨after,rest,invAfter⟩ :=
        ih (u+1) (bindValue middle "u".toList .uint64 (u64 (u+1))) invNext (by omega)
      have yes : Eval [] s firstGuard (C99ScalarReference.boolean true) := by
        simpa only [inside,decide_true] using guard s a gm u (by omega) inv
      exact ⟨after,.loopNormal _ _ _ s middle
        (bindValue middle "u".toList .uint64 (u64 (u+1))) ⟨after,.normal⟩
        (C99ScalarReference.boolean true) yes (by decide) bodyRun step rest,invAfter⟩

theorem initial (s : State) (old : Option C99IntegerReference.Value)
    (slot : s.locals "u".toList=some (.uint64,old)) :
    Exec KeygenPublicSource.program [] uInit s
      ⟨bindValue s "u".toList .uint64 (u64 0),.normal⟩ :=
  .assign _ _ _ .uint64 old (.int32 0) slot (.scalar _ _ (.literal .int32 0))

theorem seed_initial_invariant (s : State) (a gm : ArrayPointer) (e : TailEntry s a gm)
    (w : BitVec 16)
    (rSlot : KeygenPublicTableAtoms.Slot
      (bindValue s "r".toList .uint32 (C99NarrowReads.unsignedPromotion w)) "r"
      (BitVec.ofNat 32 w.toNat)) :
    FirstInv (bindValue (bindValue s "r".toList .uint32 (C99NarrowReads.unsignedPromotion w))
      "u".toList .uint64 (u64 0)) a gm 0 := by
  let rState := bindValue s "r".toList .uint32 (C99NarrowReads.unsignedPromotion w)
  have n := keep_u64 s "n" "r" .uint32 (C99NarrowReads.unsignedPromotion w) 1536 (by decide) e.nSlot
  have hn := keep_u64 s "hn" "r" .uint32 (C99NarrowReads.unsignedPromotion w) 768 (by decide) e.hnSlot
  have logn := keep_slot s "logn" "r" .uint32 (C99NarrowReads.unsignedPromotion w) 10 (by decide) e.lognSlot
  exact ⟨e.aBinding,e.squareBinding,
    keep_u64 rState "n" "u" .uint64 _ 1536 (by decide) n,
    keep_u64 rState "hn" "u" .uint64 _ 768 (by decide) hn,
    keep_slot rState "logn" "u" .uint64 _ 10 (by decide) logn,
    ⟨_,keep_slot rState "r" "u" .uint64 _ _ (by decide) rSlot⟩,
    u64_slot_after rState "u" 0 (by decide),e.aImage,e.aWidth,
    e.aWritable,e.aAllocated,e.aCount⟩

theorem seed_firstPass_source (s : State) (a gm : ArrayPointer) (e : TailEntry s a gm) :
    ∃ after, Exec KeygenPublicSource.program []
      (.seq PublicTailShape159.rSet firstPass) s ⟨after,.normal⟩ ∧
      FirstInv after a gm 768 := by
  obtain ⟨w,_,seedRun,rSlot⟩ := PublicTailFirst159.rSet_exec s a gm e
  let rState := bindValue s "r".toList .uint32 (C99NarrowReads.unsignedPromotion w)
  let initialState := bindValue rState "u".toList .uint64 (u64 0)
  obtain ⟨old,uCell⟩ := e.uCell
  have uCellR : rState.locals "u".toList=some (.uint64,old) := by
    exact uCell
  have init := initial rState old uCellR
  have inv := seed_initial_invariant s a gm e w rSlot
  obtain ⟨after,loopRun,invAfter⟩ := loop_source 768 0 initialState a gm inv (by decide)
  exact ⟨after,.seqNormal _ _ s rState ⟨after,.normal⟩ seedRun
    (.seqNormal _ _ rState initialState ⟨after,.normal⟩ init loopRun),invAfter⟩

end FT1536.Source3.PublicTailLoop160
