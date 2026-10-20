import Source3.StepCopyLoop190
import Source3.StepCopyKeep193

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The original fs-to-t1 copy loop with TWO additional tracked read images:
   any two images loaded from cells separate from the t1 walk survive every
   copy write simultaneously. The step re-assembly needs the gs source
   image and the igm twiddle reads kept in one run (StepCopyKeep193 keeps
   a single image); values stay the executed load words and no table or
   transform property is claimed. -/
namespace FT1536.Source3.StepCopyKeepTwo194
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open C99LoopScalar141 (Cell)
open StepCopyBody190 (addr elem output next)
open StepCopyFixed190 (Fixed PrefixImage)
open StepCopyKeep193 (Reads reads_write)
open KeygenMakeFgSource (Exec)

theorem remaining (count v : Nat) (s : State) (fs t1 : ArrayPointer) (u0 slen n : Nat)
    (fv : Fin n → BitVec 32) (fixed : Fixed s fs t1 u0 slen n fv)
    (vCell : Cell s "v".toList v) (xBinding : s.arrays "x".toList=some (addr fs u0 v slen))
    (copied : PrefixImage s t1 fv v) (finish : v+count=n)
    (qA : ArrayPointer) (mA : Nat) (imgA : Nat → BitVec 32) (readsA : Reads s qA mA imgA)
    (separateA : ∀ i : Fin n, ∀ k : Nat, k<mA → Separate (elem t1 i.val) ({qA with index := qA.index+k}))
    (qB : ArrayPointer) (mB : Nat) (imgB : Nat → BitVec 32) (readsB : Reads s qB mB imgB)
    (separateB : ∀ i : Fin n, ∀ k : Nat, k<mB → Separate (elem t1 i.val) ({qB with index := qB.index+k})) :
    ∃ after, Exec MakeFgTailShape190.copyLoop s ⟨after,.normal⟩ ∧
      Fixed after fs t1 u0 slen n fv ∧ Cell after "v".toList n ∧
      after.arrays "x".toList=some (addr fs u0 n slen) ∧ PrefixImage after t1 fv n ∧
      (∀ name : Name, name≠"v".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=s.arrays name) ∧
      Reads after qA mA imgA ∧ Reads after qB mB imgB := by
  induction count generalizing v s with
  | zero =>
    have equal : v=n := by omega
    subst v
    have guard : C99ArrayReference.scalar s MakeFgTailShape190.copyCondition (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        StepCopyLoop190.guard s n n fixed.nBound fixed.nBound vCell fixed.nCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) guard (by decide),fixed,vCell,xBinding,copied,
      fun _ _ => rfl,fun _ _ => rfl,readsA,readsB⟩
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
    have bodyReadsA : Reads (output s t1 v (fv ⟨v,slot⟩)) qA mA imgA :=
      StepCopyKeep193.reads_output s t1 v (fv ⟨v,slot⟩) qA mA imgA readsA
        (fun k bound => separateA ⟨v,slot⟩ k bound)
    have bodyReadsB : Reads (output s t1 v (fv ⟨v,slot⟩)) qB mB imgB :=
      StepCopyKeep193.reads_output s t1 v (fv ⟨v,slot⟩) qB mB imgB readsB
        (fun k bound => separateB ⟨v,slot⟩ k bound)
    have update : Exec MakeFgTailShape190.copyInc (output s t1 v (fv ⟨v,slot⟩))
        ⟨next s fs t1 u0 slen v (fv ⟨v,slot⟩),.normal⟩ :=
      StepCopyBody190.inc_source s fs t1 u0 slen v (fv ⟨v,slot⟩)
        (by have h := fixed.nBound; omega) fixed.slenBound
        (StepCopyFixed190.copy_capacity_next fs u0 slen n v fixed.fsCapacity slot)
        vCell fixed.slenCell xBinding
    have tailReadsA : Reads (next s fs t1 u0 slen v (fv ⟨v,slot⟩)) qA mA imgA :=
      StepCopyKeep193.reads_next s fs t1 u0 slen v (fv ⟨v,slot⟩) qA mA imgA readsA
        (fun k bound => separateA ⟨v,slot⟩ k bound)
    have tailReadsB : Reads (next s fs t1 u0 slen v (fv ⟨v,slot⟩)) qB mB imgB :=
      StepCopyKeep193.reads_next s fs t1 u0 slen v (fv ⟨v,slot⟩) qB mB imgB readsB
        (fun k bound => separateB ⟨v,slot⟩ k bound)
    obtain ⟨after,rest,finalFixed,finalV,finalX,finalPrefix,finalLocals,finalArrays,
      finalReadsA,finalReadsB⟩ :=
      ih (v+1) (next s fs t1 u0 slen v (fv ⟨v,slot⟩))
        (StepCopyFixed190.next_fixed s fs t1 u0 slen n v fv fixed slot)
        (StepCopyLoop190.next_v s fs t1 u0 slen v (fv ⟨v,slot⟩))
        (StepCopyFixed190.next_x s fs t1 u0 slen v (fv ⟨v,slot⟩))
        (StepCopyLoop190.next_prefix s fs t1 u0 slen n v fv fixed slot copied)
        (by omega) tailReadsA tailReadsB
    refine ⟨after,?_,finalFixed,finalV,finalX,finalPrefix,?_,?_,finalReadsA,finalReadsB⟩
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
    (copied : PrefixImage s t1 fv 0)
    (qA : ArrayPointer) (mA : Nat) (imgA : Nat → BitVec 32) (readsA : Reads s qA mA imgA)
    (separateA : ∀ i : Fin n, ∀ k : Nat, k<mA → Separate (elem t1 i.val) ({qA with index := qA.index+k}))
    (qB : ArrayPointer) (mB : Nat) (imgB : Nat → BitVec 32) (readsB : Reads s qB mB imgB)
    (separateB : ∀ i : Fin n, ∀ k : Nat, k<mB → Separate (elem t1 i.val) ({qB with index := qB.index+k})) :
    ∃ after, Exec MakeFgTailShape190.copyLoop s ⟨after,.normal⟩ ∧
      Fixed after fs t1 u0 slen n fv ∧ Cell after "v".toList n ∧
      after.arrays "x".toList=some (addr fs u0 n slen) ∧ PrefixImage after t1 fv n ∧
      (∀ name : Name, name≠"v".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=s.arrays name) ∧
      Reads after qA mA imgA ∧ Reads after qB mB imgB :=
  remaining n 0 s fs t1 u0 slen n fv fixed vCell xBinding copied (by omega)
    qA mA imgA readsA separateA qB mB imgB readsB separateB

end FT1536.Source3.StepCopyKeepTwo194
