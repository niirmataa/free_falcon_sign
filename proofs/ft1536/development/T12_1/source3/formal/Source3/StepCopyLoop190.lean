import Source3.StepCopyFixed190

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Induction for the original fs-to-t1 copy loop, on the exact source
   statements; the final image is only the executed loads. -/
namespace FT1536.Source3.StepCopyLoop190
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open StepCopyBody190 (addr elem output next)
open StepCopyFixed190 (Fixed PrefixImage)
open KeygenMakeFgSource (Exec)

theorem guard (s : State) (v n : Nat) (vBound : v<2^64) (nBound : n<2^64)
    (vCell : Cell s "v".toList v) (nCell : Cell s "n".toList n) :
    C99ArrayReference.scalar s MakeFgTailShape190.copyCondition
      (C99ScalarReference.boolean (decide (v<n))) :=
  C99LoopScalar141.less s MakeFgTailShape190.varV MakeFgTailShape190.varN v n vBound nBound
    (C99LoopScalar141.read s "v".toList v vCell) (C99LoopScalar141.read s "n".toList n nCell)

theorem next_v (s : State) (fs t1 : ArrayPointer) (u0 slen i : Nat) (w : BitVec 32) :
    Cell (next s fs t1 u0 slen i w) "v".toList (i+1) := by
  exact FftLocalCells140.cell_at (output s t1 i w) "v".toList (C99NatWord141.word (i+1))

theorem next_prefix (s : State) (fs t1 : ArrayPointer) (u0 slen n v : Nat) (fv : Fin n → BitVec 32)
    (fixed : Fixed s fs t1 u0 slen n fv) (slot : v<n) (copied : PrefixImage s t1 fv v) :
    PrefixImage (next s fs t1 u0 slen v (fv ⟨v,slot⟩)) t1 fv (v+1) := by
  intro i bound
  rw [StepCopyFixed190.next_heap]
  by_cases same : i.val=v
  · have key : i=⟨v,slot⟩ := Fin.ext same
    subst key
    exact Word32Memory176.here s.heap (elem t1 v) (fv ⟨v,slot⟩)
      (fixed.t1Allocated ⟨v,slot⟩) fixed.t1Width fixed.t1Writable
  · have different : (⟨v,slot⟩ : Fin n)≠i := fun equal =>
      same (congrArg Fin.val equal).symm
    exact Word32Memory176.outside s.heap (elem t1 v) (elem t1 i) (fv ⟨v,slot⟩) (fv i)
      (fixed.prefixSeparate ⟨v,slot⟩ i different) (copied i (by omega))

theorem remaining (count v : Nat) (s : State) (fs t1 : ArrayPointer) (u0 slen n : Nat)
    (fv : Fin n → BitVec 32) (fixed : Fixed s fs t1 u0 slen n fv)
    (vCell : Cell s "v".toList v) (xBinding : s.arrays "x".toList=some (addr fs u0 v slen))
    (copied : PrefixImage s t1 fv v) (finish : v+count=n) :
    ∃ after, Exec MakeFgTailShape190.copyLoop s ⟨after,.normal⟩ ∧
      Fixed after fs t1 u0 slen n fv ∧ Cell after "v".toList n ∧
      after.arrays "x".toList=some (addr fs u0 n slen) ∧ PrefixImage after t1 fv n ∧
      (∀ name : C99ArrayReference.Name, name≠"v".toList → after.locals name=s.locals name) ∧
      (∀ name : C99ArrayReference.Name, name≠"x".toList → after.arrays name=s.arrays name) := by
  induction count generalizing v s with
  | zero =>
    have equal : v=n := by omega
    subst v
    have guard : C99ArrayReference.scalar s MakeFgTailShape190.copyCondition (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        StepCopyLoop190.guard s n n fixed.nBound fixed.nBound vCell fixed.nCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) guard (by decide),fixed,vCell,xBinding,copied,
      fun _ _ => rfl,fun _ _ => rfl⟩
  | succ count ih =>
    have slot : v<n := by omega
    have nonzero : (C99ScalarReference.boolean (decide (v<n))).integer≠0 := by
      simp [slot,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    have body : Exec MakeFgTailShape190.copyBody s
        ⟨output s t1 v (fv ⟨v,slot⟩),.normal⟩ :=
      StepCopyBody190.body_source s fs t1 u0 slen v (fv ⟨v,slot⟩)
        (by have h := fixed.nBound; omega)
        (StepCopyFixed190.copy_capacity fs u0 slen n v fixed.fsCapacity slot)
        (by have := fixed.t1Capacity; omega)
        fixed.t1Binding xBinding vCell (fixed.src ⟨v,slot⟩) (fixed.t1Allocated ⟨v,slot⟩)
        fixed.t1Width fixed.t1Writable
    have update : Exec MakeFgTailShape190.copyInc (output s t1 v (fv ⟨v,slot⟩))
        ⟨next s fs t1 u0 slen v (fv ⟨v,slot⟩),.normal⟩ :=
      StepCopyBody190.inc_source s fs t1 u0 slen v (fv ⟨v,slot⟩)
        (by have h := fixed.nBound; omega) fixed.slenBound
        (StepCopyFixed190.copy_capacity_next fs u0 slen n v fixed.fsCapacity slot)
        vCell fixed.slenCell xBinding
    obtain ⟨after,rest,finalFixed,finalV,finalX,finalPrefix,finalLocals,finalArrays⟩ :=
      ih (v+1) (next s fs t1 u0 slen v (fv ⟨v,slot⟩))
        (StepCopyFixed190.next_fixed s fs t1 u0 slen n v fv fixed slot)
        (next_v s fs t1 u0 slen v (fv ⟨v,slot⟩))
        (StepCopyFixed190.next_x s fs t1 u0 slen v (fv ⟨v,slot⟩))
        (next_prefix s fs t1 u0 slen n v fv fixed slot copied)
        (by omega)
    refine ⟨after,?_,finalFixed,finalV,finalX,finalPrefix,?_,?_⟩
    · refine .loopNormal _ _ _ s (output s t1 v (fv ⟨v,slot⟩)) (next s fs t1 u0 slen v (fv ⟨v,slot⟩))
        ⟨after,.normal⟩ (C99ScalarReference.boolean (decide (v<n))) ?_ nonzero body update rest
      exact StepCopyLoop190.guard s v n (by have h := fixed.nBound; omega) fixed.nBound vCell fixed.nCell
    · intro name different
      exact (finalLocals name different).trans
        (StepCopyFixed190.next_locals s fs t1 u0 slen v (fv ⟨v,slot⟩) name different)
    · intro name different
      exact (finalArrays name different).trans
        (StepCopyFixed190.next_arrays s fs t1 u0 slen v (fv ⟨v,slot⟩) name different)

theorem source (s : State) (fs t1 : ArrayPointer) (u0 slen n : Nat)
    (fv : Fin n → BitVec 32) (fixed : Fixed s fs t1 u0 slen n fv)
    (vCell : Cell s "v".toList 0) (xBinding : s.arrays "x".toList=some (addr fs u0 0 slen))
    (copied : PrefixImage s t1 fv 0) :
    ∃ after, Exec MakeFgTailShape190.copyLoop s ⟨after,.normal⟩ ∧
      Fixed after fs t1 u0 slen n fv ∧ Cell after "v".toList n ∧
      after.arrays "x".toList=some (addr fs u0 n slen) ∧ PrefixImage after t1 fv n ∧
      (∀ name : C99ArrayReference.Name, name≠"v".toList → after.locals name=s.locals name) ∧
      (∀ name : C99ArrayReference.Name, name≠"x".toList → after.arrays name=s.arrays name) :=
  remaining n 0 s fs t1 u0 slen n fv fixed vCell xBinding copied (by omega)

end FT1536.Source3.StepCopyLoop190
