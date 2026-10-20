import Source3.StepProductKeep193

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The original pair-product loop (statement s6 of the make_fg_step
   first-prime tail) on the gd region with two tracked read images: the
   loop invariant binds the gd destination name, and images loaded from
   cells separate from the gd walk survive every product write. Used at
   the gs path for the gs source image (needed by the later gs inverse
   call) and the igm twiddle reads; values stay the executed load words
   and the two nested Montgomery product words. No product or transform
   property is claimed. -/
namespace FT1536.Source3.StepGsProductKeep194
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open StepCopyBody190 (addr elem)
open StepProductBody191 (value output next)
open StepProductFixed191 (Image)
open StepCopyKeep193 (Reads)
open StepProductKeep193 (reads_output reads_next)
open KeygenMakeFgSource (Exec)

structure FixedGd (s : State) (gd t1 : ArrayPointer) (u0 tlen n : Nat)
    (p p0i r2 : BitVec 32) (gv : Nat → BitVec 32) : Prop where
  nBound : n<2^64
  nWide : 2*n+1<2^64
  tlenBound : tlen<2^64
  uBound : u0<2^64
  gdWidth : gd.elementBytes=4
  gdCapacity : gd.index+u0+n*tlen≤gd.count
  gdWritable : s.heap.writable gd.block=true
  gdBinding : s.arrays "gd".toList=some gd
  t1Binding : s.arrays "t1".toList=some t1
  nCell : Cell s "hn".toList n
  tlenCell : Cell s "tlen".toList tlen
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  r2Cell : Slot s "R2" r2
  gdAllocated : ∀ i : Fin n, Allocated s.heap (addr gd u0 i.val tlen)
  dstSrcSeparate : ∀ i : Fin n, ∀ j : Fin (2*n), Separate (addr gd u0 i.val tlen) (elem t1 j.val)
  dstSeparate : ∀ i j : Fin n, i≠j → Separate (addr gd u0 i.val tlen) (addr gd u0 j.val tlen)
  src : ∀ i : Fin (2*n), Load32 s.heap (elem t1 i.val) (gv i.val)

theorem load_allocated {h : C99MemoryReference.Memory} {p : ArrayPointer} {w : BitVec 32}
    (read : Load32 h p w) : Allocated h p := by
  cases read with
  | load b allocated width init => exact allocated

theorem source_reads (s : State) (gd t1 : ArrayPointer) (u0 tlen n : Nat) (p p0i r2 : BitVec 32)
    (gv : Nat → BitVec 32) (v : Nat) (fixed : FixedGd s gd t1 u0 tlen n p p0i r2 gv)
    (slot : v<n) :
    Load32 s.heap (elem t1 (2*v)) (gv (2*v)) ∧
      Load32 s.heap (elem t1 (2*v+1)) (gv (2*v+1)) ∧ t1.index+(2*v+1)<t1.count := by
  have lower : 2*v<2*n := by omega
  have upper : 2*v+1<2*n := by omega
  refine ⟨fixed.src ⟨2*v,lower⟩,fixed.src ⟨2*v+1,upper⟩,?_⟩
  have base := (load_allocated (fixed.src ⟨2*v+1,upper⟩)).2.2.1
  simpa [StepCopyBody190.elem] using base

theorem output_fixed (s : State) (gd t1 : ArrayPointer) (u0 tlen n : Nat) (p p0i r2 : BitVec 32)
    (gv : Nat → BitVec 32) (v : Nat) (z : BitVec 32)
    (fixed : FixedGd s gd t1 u0 tlen n p p0i r2 gv) (slot : v<n) :
    FixedGd (output s gd u0 tlen v z) gd t1 u0 tlen n p p0i r2 gv := by
  refine ⟨fixed.nBound,fixed.nWide,fixed.tlenBound,fixed.uBound,fixed.gdWidth,fixed.gdCapacity,
    ?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · rw [StepProductFixed191.output_heap s gd u0 tlen v z]
    exact fixed.gdWritable
  · exact fixed.gdBinding
  · exact fixed.t1Binding
  · exact fixed.nCell
  · exact fixed.tlenCell
  · exact fixed.pCell
  · exact fixed.iCell
  · exact fixed.r2Cell
  · intro i
    rw [StepProductFixed191.output_heap s gd u0 tlen v z]
    exact fixed.gdAllocated i
  · intro i j
    exact fixed.dstSrcSeparate i j
  · intro i j different
    exact fixed.dstSeparate i j different
  · intro i
    rw [StepProductFixed191.output_heap s gd u0 tlen v z]
    exact Word32Memory176.outside s.heap (addr gd u0 v tlen) (elem t1 i.val) z (gv i.val)
      (fixed.dstSrcSeparate ⟨v,slot⟩ i) (fixed.src i)

theorem output_prefix (s : State) (gd t1 : ArrayPointer) (u0 tlen n : Nat) (p p0i r2 : BitVec 32)
    (gv : Nat → BitVec 32) (v : Nat) (fixed : FixedGd s gd t1 u0 tlen n p p0i r2 gv) (slot : v<n)
    (copied : Image s gd u0 tlen n p p0i r2 gv v) :
    Image (output s gd u0 tlen v (value (gv (2*v)) (gv (2*v+1)) r2 p p0i))
      gd u0 tlen n p p0i r2 gv (v+1) := by
  intro i bound
  rw [StepProductFixed191.output_heap s gd u0 tlen v]
  by_cases same : i.val=v
  · have key : i=⟨v,slot⟩ := Fin.ext same
    subst key
    exact Word32Memory176.here s.heap (addr gd u0 v tlen)
      (value (gv (2*v)) (gv (2*v+1)) r2 p p0i)
      (fixed.gdAllocated ⟨v,slot⟩) fixed.gdWidth fixed.gdWritable
  · have different : (⟨v,slot⟩ : Fin n)≠i := fun equal =>
      same (congrArg Fin.val equal).symm
    exact Word32Memory176.outside s.heap (addr gd u0 v tlen) (addr gd u0 i.val tlen)
      (value (gv (2*v)) (gv (2*v+1)) r2 p p0i) (value (gv (2*i.val)) (gv (2*i.val+1)) r2 p p0i)
      (fixed.dstSeparate ⟨v,slot⟩ i different) (copied i (by omega))

theorem next_fixed (s : State) (gd t1 : ArrayPointer) (u0 tlen n : Nat) (p p0i r2 : BitVec 32)
    (gv : Nat → BitVec 32) (v : Nat) (fixed : FixedGd s gd t1 u0 tlen n p p0i r2 gv) :
    FixedGd (next s gd u0 tlen v) gd t1 u0 tlen n p p0i r2 gv := by
  refine ⟨fixed.nBound,fixed.nWide,fixed.tlenBound,fixed.uBound,fixed.gdWidth,fixed.gdCapacity,
    ?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · rw [StepProductFixed191.next_heap]; exact fixed.gdWritable
  · rw [StepProductFixed191.next_arrays s gd u0 tlen v "gd".toList (by decide)]
    exact fixed.gdBinding
  · rw [StepProductFixed191.next_arrays s gd u0 tlen v "t1".toList (by decide)]
    exact fixed.t1Binding
  · exact StepProductFixed191.next_cell s gd u0 tlen v "hn".toList n (by decide) fixed.nCell
  · exact StepProductFixed191.next_cell s gd u0 tlen v "tlen".toList tlen (by decide)
      fixed.tlenCell
  · exact StepProductFixed191.next_slot s gd u0 tlen v "p" p (by decide) fixed.pCell
  · exact StepProductFixed191.next_slot s gd u0 tlen v "p0i" p0i (by decide) fixed.iCell
  · exact StepProductFixed191.next_slot s gd u0 tlen v "R2" r2 (by decide) fixed.r2Cell
  · intro i
    rw [StepProductFixed191.next_heap]
    exact fixed.gdAllocated i
  · intro i j
    exact fixed.dstSrcSeparate i j
  · intro i j different
    exact fixed.dstSeparate i j different
  · intro i
    rw [StepProductFixed191.next_heap]
    exact fixed.src i

theorem next_prefix (s : State) (gd : ArrayPointer) (u0 tlen n : Nat) (p p0i r2 : BitVec 32)
    (gv : Nat → BitVec 32) (v : Nat) (copied : Image s gd u0 tlen n p p0i r2 gv (v+1)) :
    Image (next s gd u0 tlen v) gd u0 tlen n p p0i r2 gv (v+1) := by
  intro i bound
  rw [StepProductFixed191.next_heap]
  exact copied i bound

theorem remaining (count v : Nat) (s : State) (gd t1 : ArrayPointer) (u0 tlen n : Nat)
    (p p0i r2 : BitVec 32) (gv : Nat → BitVec 32)
    (fixed : FixedGd s gd t1 u0 tlen n p p0i r2 gv)
    (vCell : Cell s "v".toList v) (xBinding : s.arrays "x".toList=some (addr gd u0 v tlen))
    (image : Image s gd u0 tlen n p p0i r2 gv v) (finish : v+count=n)
    (qA : ArrayPointer) (mA : Nat) (imgA : Nat → BitVec 32) (readsA : Reads s qA mA imgA)
    (separateA : ∀ i : Fin n, ∀ k : Nat, k<mA →
      Separate (addr gd u0 i.val tlen) ({qA with index := qA.index+k}))
    (qB : ArrayPointer) (mB : Nat) (imgB : Nat → BitVec 32) (readsB : Reads s qB mB imgB)
    (separateB : ∀ i : Fin n, ∀ k : Nat, k<mB →
      Separate (addr gd u0 i.val tlen) ({qB with index := qB.index+k})) :
    ∃ after, Exec MakeFgProductShape191.productLoop s ⟨after,.normal⟩ ∧
      FixedGd after gd t1 u0 tlen n p p0i r2 gv ∧ Cell after "v".toList n ∧
      after.arrays "x".toList=some (addr gd u0 n tlen) ∧
      Image after gd u0 tlen n p p0i r2 gv n ∧
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
    obtain ⟨read0,read1,t1Capacity⟩ := source_reads s gd t1 u0 tlen n p p0i r2 gv v fixed slot
    have body : Exec MakeFgProductShape191.productBody s
        ⟨output s gd u0 tlen v (value (gv (2*v)) (gv (2*v+1)) r2 p p0i),.normal⟩ :=
      StepProductBody191.body_source s gd t1 u0 tlen v p p0i r2 (gv (2*v)) (gv (2*v+1))
        (by have := fixed.nBound; omega) (by have := fixed.nWide; omega)
        (StepProductFixed191.product_capacity s gd u0 tlen v (fixed.gdAllocated ⟨v,slot⟩))
        t1Capacity fixed.gdWidth fixed.gdWritable fixed.t1Binding xBinding vCell
        fixed.pCell fixed.iCell fixed.r2Cell read0 read1 (fixed.gdAllocated ⟨v,slot⟩)
    have bodyReadsA : Reads (output s gd u0 tlen v (value (gv (2*v)) (gv (2*v+1)) r2 p p0i))
        qA mA imgA :=
      reads_output s gd u0 tlen v (value (gv (2*v)) (gv (2*v+1)) r2 p p0i) qA mA imgA readsA
        (fun k bound => separateA ⟨v,slot⟩ k bound)
    have bodyReadsB : Reads (output s gd u0 tlen v (value (gv (2*v)) (gv (2*v+1)) r2 p p0i))
        qB mB imgB :=
      reads_output s gd u0 tlen v (value (gv (2*v)) (gv (2*v+1)) r2 p p0i) qB mB imgB readsB
        (fun k bound => separateB ⟨v,slot⟩ k bound)
    have bodyFixed : FixedGd (output s gd u0 tlen v (value (gv (2*v)) (gv (2*v+1)) r2 p p0i))
        gd t1 u0 tlen n p p0i r2 gv :=
      output_fixed s gd t1 u0 tlen n p p0i r2 gv v
        (value (gv (2*v)) (gv (2*v+1)) r2 p p0i) fixed slot
    have bodyImage : Image (output s gd u0 tlen v (value (gv (2*v)) (gv (2*v+1)) r2 p p0i))
        gd u0 tlen n p p0i r2 gv (v+1) :=
      output_prefix s gd t1 u0 tlen n p p0i r2 gv v fixed slot image
    have update : Exec MakeFgProductShape191.productInc
        (output s gd u0 tlen v (value (gv (2*v)) (gv (2*v+1)) r2 p p0i))
        ⟨next (output s gd u0 tlen v (value (gv (2*v)) (gv (2*v+1)) r2 p p0i)) gd u0 tlen v,.normal⟩ :=
      StepProductBody191.inc_source
        (output s gd u0 tlen v (value (gv (2*v)) (gv (2*v+1)) r2 p p0i)) gd u0 tlen v
        (by have := fixed.nBound; omega) fixed.tlenBound
        (StepProductFixed191.product_capacity_next gd u0 tlen n v fixed.gdCapacity slot)
        vCell fixed.tlenCell xBinding
    set tail : State := next (output s gd u0 tlen v (value (gv (2*v)) (gv (2*v+1)) r2 p p0i))
      gd u0 tlen v with tailEq
    have tailReadsA : Reads tail qA mA imgA := by
      rw [tailEq]
      exact reads_next _ gd u0 tlen v qA mA imgA bodyReadsA
    have tailReadsB : Reads tail qB mB imgB := by
      rw [tailEq]
      exact reads_next _ gd u0 tlen v qB mB imgB bodyReadsB
    have tailFixed : FixedGd tail gd t1 u0 tlen n p p0i r2 gv := by
      rw [tailEq]
      exact next_fixed _ gd t1 u0 tlen n p p0i r2 gv v bodyFixed
    have tailV : Cell tail "v".toList (v+1) := by
      rw [tailEq]
      exact StepProductFixed191.next_v _ gd u0 tlen v
    have tailX : tail.arrays "x".toList=some (addr gd u0 (v+1) tlen) := by
      rw [tailEq]
      exact StepProductFixed191.next_x _ gd u0 tlen v
    have tailImage : Image tail gd u0 tlen n p p0i r2 gv (v+1) := by
      rw [tailEq]
      exact next_prefix _ gd u0 tlen n p p0i r2 gv v bodyImage
    obtain ⟨after,rest,finalFixed,finalV,finalX,finalImage,finalLocals,finalArrays,
        finalReadsA,finalReadsB⟩ :=
      ih (v+1) tail tailFixed tailV tailX tailImage (by omega) tailReadsA tailReadsB
    refine ⟨after,?_,finalFixed,finalV,finalX,finalImage,?_,?_,finalReadsA,finalReadsB⟩
    · refine .loopNormal _ _ _ s
        (output s gd u0 tlen v (value (gv (2*v)) (gv (2*v+1)) r2 p p0i)) tail
        ⟨after,.normal⟩ (C99ScalarReference.boolean (decide (v<n))) ?_ nonzero body update rest
      exact StepProductLoop191.guard s v n (by have := fixed.nBound; omega) fixed.nBound
        vCell fixed.nCell
    · intro name different
      have first : tail.locals name=s.locals name := by
        rw [tailEq]
        exact (StepProductFixed191.next_locals
          (output s gd u0 tlen v (value (gv (2*v)) (gv (2*v+1)) r2 p p0i)) gd u0 tlen v name
          different)
      exact (finalLocals name different).trans first
    · intro name different
      have first : tail.arrays name=s.arrays name := by
        rw [tailEq]
        exact (StepProductFixed191.next_arrays
          (output s gd u0 tlen v (value (gv (2*v)) (gv (2*v+1)) r2 p p0i)) gd u0 tlen v name
          different)
      exact (finalArrays name different).trans first

theorem source (s : State) (gd t1 : ArrayPointer) (u0 tlen n : Nat)
    (p p0i r2 : BitVec 32) (gv : Nat → BitVec 32)
    (fixed : FixedGd s gd t1 u0 tlen n p p0i r2 gv)
    (vCell : Cell s "v".toList 0) (xBinding : s.arrays "x".toList=some (addr gd u0 0 tlen))
    (image : Image s gd u0 tlen n p p0i r2 gv 0)
    (qA : ArrayPointer) (mA : Nat) (imgA : Nat → BitVec 32) (readsA : Reads s qA mA imgA)
    (separateA : ∀ i : Fin n, ∀ k : Nat, k<mA →
      Separate (addr gd u0 i.val tlen) ({qA with index := qA.index+k}))
    (qB : ArrayPointer) (mB : Nat) (imgB : Nat → BitVec 32) (readsB : Reads s qB mB imgB)
    (separateB : ∀ i : Fin n, ∀ k : Nat, k<mB →
      Separate (addr gd u0 i.val tlen) ({qB with index := qB.index+k})) :
    ∃ after, Exec MakeFgProductShape191.productLoop s ⟨after,.normal⟩ ∧
      FixedGd after gd t1 u0 tlen n p p0i r2 gv ∧ Cell after "v".toList n ∧
      after.arrays "x".toList=some (addr gd u0 n tlen) ∧
      Image after gd u0 tlen n p p0i r2 gv n ∧
      (∀ name : Name, name≠"v".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=s.arrays name) ∧
      Reads after qA mA imgA ∧ Reads after qB mB imgB :=
  remaining n 0 s gd t1 u0 tlen n p p0i r2 gv fixed vCell xBinding image (by omega)
    qA mA imgA readsA separateA qB mB imgB readsB separateB

end FT1536.Source3.StepGsProductKeep194
