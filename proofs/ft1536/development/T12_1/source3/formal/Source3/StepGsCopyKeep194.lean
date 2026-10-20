import Source3.StepCopyKeep193

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The original gs-to-t1 copy loop (statement s4 of the make_fg_step
   first-prime tail) with one tracked read image: the loop invariant binds
   the gs source name, and any image loaded from cells separate from the
   t1 walk survives every copy write. Used at the gs path for the igm
   twiddle reads of the later gs inverse call; the gs source image itself
   is kept by the invariant as executed load words. Values stay the
   executed words and no table or transform property is claimed. -/
namespace FT1536.Source3.StepGsCopyKeep194
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open C99LoopScalar141 (Cell)
open StepCopyBody190 (addr elem output next)
open StepCopyFixed190 (PrefixImage)
open StepCopyKeep193 (Reads reads_write reads_output reads_next)
open KeygenMakeFgSource (Exec)

structure FixedGs (s : State) (gs t1 : ArrayPointer) (u0 slen n : Nat)
    (gv : Fin n → BitVec 32) : Prop where
  nBound : n<2^64
  slenBound : slen<2^64
  uBound : u0<2^64
  gsWidth : gs.elementBytes=4
  t1Width : t1.elementBytes=4
  gsCapacity : gs.index+u0+n*slen≤gs.count
  t1Capacity : t1.index+n≤t1.count
  t1Writable : s.heap.writable t1.block=true
  gsBinding : s.arrays "gs".toList=some gs
  t1Binding : s.arrays "t1".toList=some t1
  nCell : Cell s "n".toList n
  slenCell : Cell s "slen".toList slen
  t1Allocated : ∀ i : Fin n, Allocated s.heap (elem t1 i)
  t1Separate : ∀ v i : Fin n, Separate (elem t1 v) (addr gs u0 i.val slen)
  prefixSeparate : ∀ i j : Fin n, i≠j → Separate (elem t1 i) (elem t1 j)
  src : ∀ i : Fin n, Load32 s.heap (addr gs u0 i.val slen) (gv i)

theorem next_fixed (s : State) (gs t1 : ArrayPointer) (u0 slen n v : Nat) (gv : Fin n → BitVec 32)
    (fixed : FixedGs s gs t1 u0 slen n gv) (slot : v<n) :
    FixedGs (next s gs t1 u0 slen v (gv ⟨v,slot⟩)) gs t1 u0 slen n gv := by
  refine ⟨fixed.nBound,fixed.slenBound,fixed.uBound,fixed.gsWidth,fixed.t1Width,fixed.gsCapacity,
    fixed.t1Capacity,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · exact fixed.t1Writable
  · rw [StepCopyFixed190.next_arrays s gs t1 u0 slen v (gv ⟨v,slot⟩) "gs".toList (by decide)]
    exact fixed.gsBinding
  · rw [StepCopyFixed190.next_arrays s gs t1 u0 slen v (gv ⟨v,slot⟩) "t1".toList (by decide)]
    exact fixed.t1Binding
  · exact StepCopyFixed190.next_cell s gs t1 u0 slen v (gv ⟨v,slot⟩) "n".toList n (by decide)
      fixed.nCell
  · exact StepCopyFixed190.next_cell s gs t1 u0 slen v (gv ⟨v,slot⟩) "slen".toList slen (by decide)
      fixed.slenCell
  · intro i
    rw [StepCopyFixed190.next_heap]
    exact fixed.t1Allocated i
  · intro v' i
    exact fixed.t1Separate v' i
  · intro i j different
    exact fixed.prefixSeparate i j different
  · intro i
    rw [StepCopyFixed190.next_heap]
    exact Word32Memory176.outside s.heap (elem t1 v) (addr gs u0 i.val slen)
      (gv ⟨v,slot⟩) (gv i) (fixed.t1Separate ⟨v,slot⟩ i) (fixed.src i)

theorem next_prefix (s : State) (gs t1 : ArrayPointer) (u0 slen n v : Nat) (gv : Fin n → BitVec 32)
    (fixed : FixedGs s gs t1 u0 slen n gv) (slot : v<n) (copied : PrefixImage s t1 gv v) :
    PrefixImage (next s gs t1 u0 slen v (gv ⟨v,slot⟩)) t1 gv (v+1) := by
  intro i bound
  rw [StepCopyFixed190.next_heap]
  by_cases same : i.val=v
  · have key : i=⟨v,slot⟩ := Fin.ext same
    subst key
    exact Word32Memory176.here s.heap (elem t1 v) (gv ⟨v,slot⟩)
      (fixed.t1Allocated ⟨v,slot⟩) fixed.t1Width fixed.t1Writable
  · have different : (⟨v,slot⟩ : Fin n)≠i := fun equal =>
      same (congrArg Fin.val equal).symm
    exact Word32Memory176.outside s.heap (elem t1 v) (elem t1 i) (gv ⟨v,slot⟩) (gv i)
      (fixed.prefixSeparate ⟨v,slot⟩ i different) (copied i (by omega))

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
      Reads after q m img := by
  induction count generalizing v s with
  | zero =>
    have equal : v=n := by omega
    subst v
    have guard : C99ArrayReference.scalar s MakeFgTailShape190.copyCondition (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        StepCopyLoop190.guard s n n fixed.nBound fixed.nBound vCell fixed.nCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) guard (by decide),fixed,vCell,xBinding,copied,
      fun _ _ => rfl,fun _ _ => rfl,reads⟩
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
    have update : Exec MakeFgTailShape190.copyInc (output s t1 v (gv ⟨v,slot⟩))
        ⟨next s gs t1 u0 slen v (gv ⟨v,slot⟩),.normal⟩ :=
      StepCopyBody190.inc_source s gs t1 u0 slen v (gv ⟨v,slot⟩)
        (by have h := fixed.nBound; omega) fixed.slenBound
        (StepCopyFixed190.copy_capacity_next gs u0 slen n v fixed.gsCapacity slot)
        vCell fixed.slenCell xBinding
    have tailReads : Reads (next s gs t1 u0 slen v (gv ⟨v,slot⟩)) q m img :=
      reads_next s gs t1 u0 slen v (gv ⟨v,slot⟩) q m img reads
        (fun k bound => separate ⟨v,slot⟩ k bound)
    obtain ⟨after,rest,finalFixed,finalV,finalX,finalPrefix,finalLocals,finalArrays,finalReads⟩ :=
      ih (v+1) (next s gs t1 u0 slen v (gv ⟨v,slot⟩))
        (next_fixed s gs t1 u0 slen n v gv fixed slot)
        (StepCopyLoop190.next_v s gs t1 u0 slen v (gv ⟨v,slot⟩))
        (StepCopyFixed190.next_x s gs t1 u0 slen v (gv ⟨v,slot⟩))
        (next_prefix s gs t1 u0 slen n v gv fixed slot copied)
        (by omega) tailReads
    refine ⟨after,?_,finalFixed,finalV,finalX,finalPrefix,?_,?_,finalReads⟩
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
      Reads after q m img :=
  remaining n 0 s gs t1 u0 slen n gv fixed vCell xBinding copied (by omega) q m img reads separate

end FT1536.Source3.StepGsCopyKeep194
