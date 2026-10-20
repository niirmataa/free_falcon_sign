import Source3.StepProductLoop191
import Source3.StepCopyKeep193

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The original pair-product loop with two additional tracked read images:
   images loaded from cells separate from the fd walk survive every product
   write. Used at the step assembly for the copied fs image and the igm
   twiddle reads of the later inverse call; values stay the executed load
   words and no product or transform property is claimed. -/
namespace FT1536.Source3.StepProductKeep193
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open C99LoopScalar141 (Cell)
open StepCopyBody190 (addr elem)
open StepProductBody191 (value output next)
open StepProductFixed191 (Fixed Image)
open StepCopyKeep193 (Reads reads_write)
open KeygenMakeFgSource (Exec)

theorem reads_output (s : State) (fd : ArrayPointer) (u0 tlen v : Nat) (z : BitVec 32)
    (q : ArrayPointer) (m : Nat) (img : Nat → BitVec 32) (reads : Reads s q m img)
    (separate : ∀ k : Nat, k<m → Separate (addr fd u0 v tlen) ({q with index := q.index+k})) :
    Reads (output s fd u0 tlen v z) q m img :=
  reads_write s q m img (addr fd u0 v tlen) z reads separate

theorem reads_next (s : State) (fd : ArrayPointer) (u0 tlen i : Nat)
    (q : ArrayPointer) (m : Nat) (img : Nat → BitVec 32) (reads : Reads s q m img) :
    Reads (next s fd u0 tlen i) q m img :=
  reads

theorem remaining (count v : Nat) (s : State) (fd t1 : ArrayPointer) (u0 tlen n : Nat)
    (p p0i r2 : BitVec 32) (fv : Nat → BitVec 32)
    (fixed : Fixed s fd t1 u0 tlen n p p0i r2 fv)
    (vCell : Cell s "v".toList v) (xBinding : s.arrays "x".toList=some (addr fd u0 v tlen))
    (image : Image s fd u0 tlen n p p0i r2 fv v) (finish : v+count=n)
    (qA : ArrayPointer) (mA : Nat) (imgA : Nat → BitVec 32) (readsA : Reads s qA mA imgA)
    (separateA : ∀ i : Fin n, ∀ k : Nat, k<mA →
      Separate (addr fd u0 i.val tlen) ({qA with index := qA.index+k}))
    (qB : ArrayPointer) (mB : Nat) (imgB : Nat → BitVec 32) (readsB : Reads s qB mB imgB)
    (separateB : ∀ i : Fin n, ∀ k : Nat, k<mB →
      Separate (addr fd u0 i.val tlen) ({qB with index := qB.index+k})) :
    ∃ after, Exec MakeFgProductShape191.productLoop s ⟨after,.normal⟩ ∧
      Fixed after fd t1 u0 tlen n p p0i r2 fv ∧ Cell after "v".toList n ∧
      after.arrays "x".toList=some (addr fd u0 n tlen) ∧
      Image after fd u0 tlen n p p0i r2 fv n ∧
      (∀ name : Name, name≠"v".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=s.arrays name) ∧
      Reads after qA mA imgA ∧ Reads after qB mB imgB := by
  induction count generalizing v s with
  | zero =>
    have equal : v=n := by omega
    subst v
    have false : C99ArrayReference.scalar s MakeFgProductShape191.productCondition (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        StepProductLoop191.guard s n n fixed.nBound fixed.nBound vCell fixed.nCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) false (by decide),fixed,vCell,xBinding,image,
      fun _ _ => rfl,fun _ _ => rfl,readsA,readsB⟩
  | succ count ih =>
    have slot : v<n := by omega
    have nonzero : (C99ScalarReference.boolean (decide (v<n))).integer≠0 := by
      simp [slot,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    obtain ⟨read0,read1,t1Capacity⟩ :=
      StepProductLoop191.source_reads s fd t1 u0 tlen n p p0i r2 fv v fixed slot
    have body : Exec MakeFgProductShape191.productBody s
        ⟨output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i),.normal⟩ :=
      StepProductBody191.body_source s fd t1 u0 tlen v p p0i r2 (fv (2*v)) (fv (2*v+1))
        (by have := fixed.nBound; omega) (by have := fixed.nWide; omega)
        (StepProductFixed191.product_capacity s fd u0 tlen v (fixed.fdAllocated ⟨v,slot⟩))
        t1Capacity fixed.fdWidth fixed.fdWritable fixed.t1Binding xBinding vCell
        fixed.pCell fixed.iCell fixed.r2Cell read0 read1 (fixed.fdAllocated ⟨v,slot⟩)
    have bodyReadsA : Reads (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i))
        qA mA imgA :=
      reads_output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i) qA mA imgA readsA
        (fun k bound => separateA ⟨v,slot⟩ k bound)
    have bodyReadsB : Reads (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i))
        qB mB imgB :=
      reads_output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i) qB mB imgB readsB
        (fun k bound => separateB ⟨v,slot⟩ k bound)
    have bodyFixed : Fixed (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i))
        fd t1 u0 tlen n p p0i r2 fv :=
      StepProductFixed191.output_fixed s fd t1 u0 tlen n p p0i r2 fv v
        (value (fv (2*v)) (fv (2*v+1)) r2 p p0i) fixed slot
    have bodyImage : Image (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i))
        fd u0 tlen n p p0i r2 fv (v+1) :=
      StepProductFixed191.output_prefix s fd t1 u0 tlen n p p0i r2 fv v fixed slot image
    have update : Exec MakeFgProductShape191.productInc
        (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i))
        ⟨next (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i)) fd u0 tlen v,.normal⟩ :=
      StepProductBody191.inc_source
        (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i)) fd u0 tlen v
        (by have := fixed.nBound; omega) fixed.tlenBound
        (StepProductFixed191.product_capacity_next fd u0 tlen n v fixed.fdCapacity slot)
        vCell fixed.tlenCell xBinding
    set tail : State := next (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i))
      fd u0 tlen v with tailEq
    have tailReadsA : Reads tail qA mA imgA := by
      rw [tailEq]
      exact reads_next _ fd u0 tlen v qA mA imgA bodyReadsA
    have tailReadsB : Reads tail qB mB imgB := by
      rw [tailEq]
      exact reads_next _ fd u0 tlen v qB mB imgB bodyReadsB
    have tailFixed : Fixed tail fd t1 u0 tlen n p p0i r2 fv := by
      rw [tailEq]
      exact StepProductFixed191.next_fixed _ fd t1 u0 tlen n p p0i r2 fv v bodyFixed
    have tailV : Cell tail "v".toList (v+1) := by
      rw [tailEq]
      exact StepProductFixed191.next_v _ fd u0 tlen v
    have tailX : tail.arrays "x".toList=some (addr fd u0 (v+1) tlen) := by
      rw [tailEq]
      exact StepProductFixed191.next_x _ fd u0 tlen v
    have tailImage : Image tail fd u0 tlen n p p0i r2 fv (v+1) := by
      rw [tailEq]
      exact StepProductFixed191.next_prefix _ fd u0 tlen n p p0i r2 fv v bodyImage
    obtain ⟨after,rest,finalFixed,finalV,finalX,finalImage,finalLocals,finalArrays,
        finalReadsA,finalReadsB⟩ :=
      ih (v+1) tail tailFixed tailV tailX tailImage (by omega) tailReadsA tailReadsB
    refine ⟨after,?_,finalFixed,finalV,finalX,finalImage,?_,?_,finalReadsA,finalReadsB⟩
    · refine .loopNormal _ _ _ s
        (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i)) tail
        ⟨after,.normal⟩ (C99ScalarReference.boolean (decide (v<n))) ?_ nonzero body update rest
      exact StepProductLoop191.guard s v n (by have := fixed.nBound; omega) fixed.nBound
        vCell fixed.nCell
    · intro name different
      have first : tail.locals name=s.locals name := by
        rw [tailEq]
        exact (StepProductFixed191.next_locals
          (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i)) fd u0 tlen v name
          different)
      exact (finalLocals name different).trans first
    · intro name different
      have first : tail.arrays name=s.arrays name := by
        rw [tailEq]
        exact (StepProductFixed191.next_arrays
          (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i)) fd u0 tlen v name
          different)
      exact (finalArrays name different).trans first

theorem source (s : State) (fd t1 : ArrayPointer) (u0 tlen n : Nat)
    (p p0i r2 : BitVec 32) (fv : Nat → BitVec 32)
    (fixed : Fixed s fd t1 u0 tlen n p p0i r2 fv)
    (vCell : Cell s "v".toList 0) (xBinding : s.arrays "x".toList=some (addr fd u0 0 tlen))
    (image : Image s fd u0 tlen n p p0i r2 fv 0)
    (qA : ArrayPointer) (mA : Nat) (imgA : Nat → BitVec 32) (readsA : Reads s qA mA imgA)
    (separateA : ∀ i : Fin n, ∀ k : Nat, k<mA →
      Separate (addr fd u0 i.val tlen) ({qA with index := qA.index+k}))
    (qB : ArrayPointer) (mB : Nat) (imgB : Nat → BitVec 32) (readsB : Reads s qB mB imgB)
    (separateB : ∀ i : Fin n, ∀ k : Nat, k<mB →
      Separate (addr fd u0 i.val tlen) ({qB with index := qB.index+k})) :
    ∃ after, Exec MakeFgProductShape191.productLoop s ⟨after,.normal⟩ ∧
      Fixed after fd t1 u0 tlen n p p0i r2 fv ∧ Cell after "v".toList n ∧
      after.arrays "x".toList=some (addr fd u0 n tlen) ∧
      Image after fd u0 tlen n p p0i r2 fv n ∧
      (∀ name : Name, name≠"v".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=s.arrays name) ∧
      Reads after qA mA imgA ∧ Reads after qB mB imgB :=
  remaining n 0 s fd t1 u0 tlen n p p0i r2 fv fixed vCell xBinding image (by omega)
    qA mA imgA readsA separateA qB mB imgB readsB separateB

end FT1536.Source3.StepProductKeep193
