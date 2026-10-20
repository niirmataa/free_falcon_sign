import Source3.StepGsCopyKeep194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The original gs-to-t1 copy loop (statement s4 of the make_fg_step
   first-prime tail) with the per-cell bystander keep in the
   NttInverseMiddleRounds192.source form: every load from a cell separate
   from the whole t1 walk survives every copy write, with the writable
   transport. The gs-bound invariant and the tracked read image of
   StepGsCopyKeep194 are kept unchanged; the per-cell keep closes the
   keep-arity gap for the fs and fd bystander images of the step
   re-assembly. Values stay the executed words and no table or transform
   property is claimed. -/
namespace FT1536.Source3.StepGsCopyKeepCell194
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open C99LoopScalar141 (Cell)
open StepCopyBody190 (addr elem output next)
open StepCopyFixed190 (PrefixImage)
open StepGsCopyKeep194 (FixedGs next_fixed next_prefix)
open StepCopyKeep193 (Reads reads_output reads_next)
open KeygenMakeFgSource (Exec)

theorem remaining (count v : Nat) (s : State) (gs t1 : ArrayPointer) (u0 slen n : Nat)
    (gv : Fin n → BitVec 32) (fixed : FixedGs s gs t1 u0 slen n gv)
    (vCell : Cell s "v".toList v) (xBinding : s.arrays "x".toList=some (addr gs u0 v slen))
    (copied : PrefixImage s t1 gv v) (finish : v+count=n)
    (q : ArrayPointer) (m : Nat) (img : Nat → BitVec 32) (reads : Reads s q m img)
    (separate : ∀ i : Fin n, ∀ k : Nat, k<m → Separate (elem t1 i.val) ({q with index := q.index+k})) :
    ∃ after, Exec MakeFgTailShape190.copyLoop s ⟨after,.normal⟩ ∧
      FixedGs after gs t1 u0 slen n gv ∧ Cell after "v".toList n ∧
      after.arrays "x".toList=some (addr gs u0 n slen) ∧ PrefixImage after t1 gv n ∧
      (∀ name : Name, name≠"v".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=s.arrays name) ∧
      Reads after q m img ∧
      (∀ r : ArrayPointer, (∀ x : Nat, x<n → Separate (elem t1 x) r) →
        ∀ w : BitVec 32, Load32 s.heap r w → Load32 after.heap r w) ∧
      after.heap.writable=s.heap.writable := by
  induction count generalizing v s with
  | zero =>
    have equal : v=n := by omega
    subst v
    have guard : C99ArrayReference.scalar s MakeFgTailShape190.copyCondition (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        StepCopyLoop190.guard s n n fixed.nBound fixed.nBound vCell fixed.nCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) guard (by decide),fixed,vCell,xBinding,copied,
      fun _ _ => rfl,fun _ _ => rfl,reads,fun r _ w load => load,rfl⟩
  | succ count ih =>
    have slot : v<n := by omega
    have nonzero : (C99ScalarReference.boolean (decide (v<n))).integer≠0 := by
      simp [slot,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    have body : Exec MakeFgTailShape190.copyBody s
        ⟨output s t1 v (gv ⟨v,slot⟩),.normal⟩ :=
      StepCopyBody190.body_source s gs t1 u0 slen v (gv ⟨v,slot⟩)
        (by have h := fixed.nBound; omega)
        (StepCopyFixed190.copy_capacity gs u0 slen n v fixed.gsCapacity slot)
        (by have := fixed.t1Capacity; omega)
        fixed.t1Binding xBinding vCell (fixed.src ⟨v,slot⟩) (fixed.t1Allocated ⟨v,slot⟩)
        fixed.t1Width fixed.t1Writable
    have bodyReads : Reads (output s t1 v (gv ⟨v,slot⟩)) q m img :=
      reads_output s t1 v (gv ⟨v,slot⟩) q m img reads (fun k bound => separate ⟨v,slot⟩ k bound)
    have bodyKeep : ∀ r : ArrayPointer, (∀ x : Nat, x<n → Separate (elem t1 x) r) →
        ∀ w : BitVec 32, Load32 s.heap r w →
          Load32 (output s t1 v (gv ⟨v,slot⟩)).heap r w := by
      intro r apart w load
      show Load32 (Word32Memory176.write s.heap (elem t1 v) (gv ⟨v,slot⟩)) r w
      exact Word32Memory176.outside s.heap (elem t1 v) r (gv ⟨v,slot⟩) w (apart v slot) load
    have update : Exec MakeFgTailShape190.copyInc (output s t1 v (gv ⟨v,slot⟩))
        ⟨next s gs t1 u0 slen v (gv ⟨v,slot⟩),.normal⟩ :=
      StepCopyBody190.inc_source s gs t1 u0 slen v (gv ⟨v,slot⟩)
        (by have h := fixed.nBound; omega) fixed.slenBound
        (StepCopyFixed190.copy_capacity_next gs u0 slen n v fixed.gsCapacity slot)
        vCell fixed.slenCell xBinding
    have tailReads : Reads (next s gs t1 u0 slen v (gv ⟨v,slot⟩)) q m img :=
      reads_next s gs t1 u0 slen v (gv ⟨v,slot⟩) q m img reads
        (fun k bound => separate ⟨v,slot⟩ k bound)
    have tailKeep : ∀ r : ArrayPointer, (∀ x : Nat, x<n → Separate (elem t1 x) r) →
        ∀ w : BitVec 32, Load32 s.heap r w →
          Load32 (next s gs t1 u0 slen v (gv ⟨v,slot⟩)).heap r w := by
      intro r apart w load
      rw [StepCopyFixed190.next_heap]
      exact bodyKeep r apart w load
    have stepWritable : (next s gs t1 u0 slen v (gv ⟨v,slot⟩)).heap.writable=s.heap.writable := by
      rw [StepCopyFixed190.next_heap]
      rfl
    obtain ⟨after,rest,finalFixed,finalV,finalX,finalPrefix,finalLocals,finalArrays,finalReads,
      finalKeep,finalWritable⟩ :=
      ih (v+1) (next s gs t1 u0 slen v (gv ⟨v,slot⟩))
        (next_fixed s gs t1 u0 slen n v gv fixed slot)
        (StepCopyLoop190.next_v s gs t1 u0 slen v (gv ⟨v,slot⟩))
        (StepCopyFixed190.next_x s gs t1 u0 slen v (gv ⟨v,slot⟩))
        (next_prefix s gs t1 u0 slen n v gv fixed slot copied)
        (by omega) tailReads
    refine ⟨after,?_,finalFixed,finalV,finalX,finalPrefix,?_,?_,finalReads,
      (fun r apart w load => finalKeep r apart w (tailKeep r apart w load)),
      finalWritable.trans stepWritable⟩
    · refine .loopNormal _ _ _ s (output s t1 v (gv ⟨v,slot⟩)) (next s gs t1 u0 slen v (gv ⟨v,slot⟩))
        ⟨after,.normal⟩ (C99ScalarReference.boolean (decide (v<n))) ?_ nonzero body update rest
      exact StepCopyLoop190.guard s v n (by have h := fixed.nBound; omega) fixed.nBound vCell fixed.nCell
    · intro name different
      exact (finalLocals name different).trans
        (StepCopyFixed190.next_locals s gs t1 u0 slen v (gv ⟨v,slot⟩) name different)
    · intro name different
      exact (finalArrays name different).trans
        (StepCopyFixed190.next_arrays s gs t1 u0 slen v (gv ⟨v,slot⟩) name different)

theorem source (s : State) (gs t1 : ArrayPointer) (u0 slen n : Nat)
    (gv : Fin n → BitVec 32) (fixed : FixedGs s gs t1 u0 slen n gv)
    (vCell : Cell s "v".toList 0) (xBinding : s.arrays "x".toList=some (addr gs u0 0 slen))
    (copied : PrefixImage s t1 gv 0)
    (q : ArrayPointer) (m : Nat) (img : Nat → BitVec 32) (reads : Reads s q m img)
    (separate : ∀ i : Fin n, ∀ k : Nat, k<m → Separate (elem t1 i.val) ({q with index := q.index+k})) :
    ∃ after, Exec MakeFgTailShape190.copyLoop s ⟨after,.normal⟩ ∧
      FixedGs after gs t1 u0 slen n gv ∧ Cell after "v".toList n ∧
      after.arrays "x".toList=some (addr gs u0 n slen) ∧ PrefixImage after t1 gv n ∧
      (∀ name : Name, name≠"v".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=s.arrays name) ∧
      Reads after q m img ∧
      (∀ r : ArrayPointer, (∀ x : Nat, x<n → Separate (elem t1 x) r) →
        ∀ w : BitVec 32, Load32 s.heap r w → Load32 after.heap r w) ∧
      after.heap.writable=s.heap.writable :=
  remaining n 0 s gs t1 u0 slen n gv fixed vCell xBinding copied (by omega) q m img reads separate

end FT1536.Source3.StepGsCopyKeepCell194
