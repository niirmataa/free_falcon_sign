import Source3.PublicGroupInvariant162

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicGroupLoop162
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenPublicWord (Eval)
open KeygenPublicTableAtoms (var)
open KeygenNttLoopSupport (USlot u64)
open PublicGroupInvariant162 (Fixed)
open PublicMiddleWrites161 (MemoryFrame)
open PublicTailShape159 (midGroupGuard midGroupInc midGroupLoop)

def next (s : State) (u ht : Nat) : State :=
  bindValue (bindValue s "u1".toList .uint64 (u64 (u+1)))
    "v1".toList .uint64 (u64 ((u+1)*(2*ht)))

theorem fixed_next (s : State) (a gm : ArrayPointer) (ht m u : Nat)
    (fixed : Fixed s a gm ht m) : Fixed (next s u ht) a gm ht m :=
  ⟨fixed.total,fixed.groupsBound,fixed.capacity,fixed.tableCapacity,fixed.binding,
    fixed.tableBinding,fixed.half,fixed.stride,fixed.groups,fixed.vCell,
    fixed.tableWritten,fixed.separate,fixed.width,fixed.writable,fixed.allocated,fixed.written⟩

theorem increment (s : State) (a gm : ArrayPointer) (ht m u : Nat)
    (fixed : Fixed s a gm ht m) (inside : u < m)
    (counter : USlot s "u1" u) (offset : USlot s "v1" (u*(2*ht))) :
    Exec KeygenPublicSource.program [] midGroupInc s ⟨next s u ht,.normal⟩ ∧
      USlot (next s u ht) "u1" (u+1) ∧ USlot (next s u ht) "v1" ((u+1)*(2*ht)) := by
  have domain := PublicGroupInvariant162.domain s a gm ht m u fixed inside
  have groupsBound := fixed.groupsBound
  let middle := bindValue s "u1".toList .uint64 (u64 (u+1))
  have first : Exec KeygenPublicSource.program []
      (.scalar (.update "u1".toList .add (.literal .i32 1))) s ⟨middle,.normal⟩ :=
    .scalar _ _ _ (.assign _ _ _ .uint64 (some (u64 u)) (u64 (u+1)) counter
      (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ counter)
        (.literal .int32 1) (C99NatWord141.add_one u (by omega))))
  have offsetM : USlot middle "v1" (u*(2*ht)) :=
    PublicGenerateRow159.keep_u64 s "v1" "u1" .uint64 _ _ (by decide) offset
  have strideM : USlot middle "t" (2*ht) :=
    PublicGenerateRow159.keep_u64 s "t" "u1" .uint64 _ _ (by decide) fixed.stride
  have sum : Eval [] middle (.bin .add (var "v1") (var "t")) (u64 ((u+1)*(2*ht))) := by
    have raw : Eval [] middle (.bin .add (var "v1") (var "t")) (u64 (u*(2*ht)+2*ht)) :=
      .bin .add _ _ _ _ _
        (.scalar _ _ (PublicGenerateIndex159.var_u64 middle "v1" (u*(2*ht)) offsetM))
        (.scalar _ _ (PublicGenerateIndex159.var_u64 middle "t" (2*ht) strideM))
        (C99NatWord141.add (u*(2*ht)) (2*ht) (by omega) (by omega))
    simpa only [Nat.add_mul,Nat.one_mul] using raw
  have second : Exec KeygenPublicSource.program []
      (.assign "v1".toList (.bin .add (var "v1") (var "t"))) middle ⟨next s u ht,.normal⟩ :=
    .assign _ _ _ .uint64 (some (u64 (u*(2*ht)))) (u64 ((u+1)*(2*ht))) offsetM sum
  have bound : (u+1)*(2*ht) < 2^64 := by
    rw [Nat.add_mul,Nat.one_mul]
    omega
  exact ⟨.seqNormal _ _ s middle ⟨next s u ht,.normal⟩ first second,
    PublicGenerateRow159.keep_u64 middle "u1" "v1" .uint64 _ _ (by decide)
      (PublicGenerateRow159.u64_slot_after s "u1" (u+1) (by omega)),
    PublicGenerateRow159.u64_slot_after middle "v1" ((u+1)*(2*ht)) bound⟩

theorem guard (s : State) (a gm : ArrayPointer) (ht m u : Nat)
    (fixed : Fixed s a gm ht m) (counter : USlot s "u1" u) (bound : u ≤ m) :
    Eval [] s midGroupGuard (C99ScalarReference.boolean (decide (u < m))) := by
  have groupsBound := fixed.groupsBound
  exact .cmp .lt _ _ _ _ _
    (.scalar _ _ (PublicGenerateIndex159.var_u64 s "u1" u counter))
    (.scalar _ _ (PublicGenerateIndex159.var_u64 s "m" m fixed.groups))
    (C99NatWord141.less u m (by omega) (by omega))

theorem remaining (count u : Nat) (s : State) (a gm : ArrayPointer) (ht m : Nat)
    (fixed : Fixed s a gm ht m) (counter : USlot s "u1" u)
    (offset : USlot s "v1" (u*(2*ht))) (finish : u+count=m) :
    ∃ after, Exec KeygenPublicSource.program [] midGroupLoop s ⟨after,.normal⟩ ∧
      Fixed after a gm ht m ∧ USlot after "u1" m ∧ USlot after "v1" (m*(2*ht)) ∧
      MemoryFrame s after a := by
  induction count generalizing u s with
  | zero =>
      have equal : u=m := by omega
      subst u
      have no : Eval [] s midGroupGuard (C99ScalarReference.boolean false) := by
        simpa only [Nat.lt_irrefl,decide_false] using guard s a gm ht m m fixed counter (by omega)
      exact ⟨s,.loopFalse _ _ _ _ _ no (by decide),fixed,counter,offset,
        PublicMiddleLoop161.frame_refl s a⟩
  | succ count ih =>
      have inside : u < m := by omega
      obtain ⟨middle,bodyRun,result⟩ := PublicGroupBody162.source s a gm ht m u (u*(2*ht))
        (PublicGroupInvariant162.entry s a gm ht m u fixed inside counter offset)
      have midFixed := PublicGroupInvariant162.fixed_after s middle a gm ht m _ fixed result
      have midCounter : USlot middle "u1" u := (result.locals _ (by decide)).trans counter
      have midOffset : USlot middle "v1" (u*(2*ht)) := (result.locals _ (by decide)).trans offset
      obtain ⟨step,nextCounter,nextOffset⟩ := increment middle a gm ht m u midFixed inside midCounter midOffset
      obtain ⟨after,rest,lastFixed,lastCounter,lastOffset,restFrame⟩ :=
        ih (u+1) (next middle u ht) (fixed_next middle a gm ht m u midFixed)
          nextCounter nextOffset (by omega)
      have yes : Eval [] s midGroupGuard (C99ScalarReference.boolean true) := by
        simpa only [inside,decide_true] using guard s a gm ht m u fixed counter (by omega)
      exact ⟨after,.loopNormal _ _ _ s middle (next middle u ht) ⟨after,.normal⟩
        (C99ScalarReference.boolean true) yes (by decide) bodyRun step rest,
        lastFixed,lastCounter,lastOffset,
        PublicMiddleLoop161.frame_trans s middle after a result.toMemoryFrame
          (PublicMiddleLoop161.frame_trans middle (next middle u ht) after a
            (PublicGroupBody162.same_heap_frame middle (next middle u ht) a rfl) restFrame)⟩

theorem source (s : State) (a gm : ArrayPointer) (ht m start : Nat)
    (fixed : Fixed s a gm ht m) (counter : USlot s "u1" start)
    (offset : USlot s "v1" (start*(2*ht))) (bound : start ≤ m) :
    ∃ after, Exec KeygenPublicSource.program [] midGroupLoop s ⟨after,.normal⟩ ∧
      Fixed after a gm ht m ∧ USlot after "u1" m ∧ USlot after "v1" (m*(2*ht)) ∧
      MemoryFrame s after a :=
  remaining (m-start) start s a gm ht m fixed counter offset (by omega)

end FT1536.Source3.PublicGroupLoop162
