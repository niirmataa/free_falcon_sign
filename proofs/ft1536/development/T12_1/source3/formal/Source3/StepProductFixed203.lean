import Source3.StepProductBody191

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Loop invariant for the original pair-product loop: stable source reads
   of the copied t1 image, the exact walked destination addresses and the
   written prefix; values come only from the executed loads and the two
   nested Montgomery multiplications. -/
namespace FT1536.Source3.StepProductFixed203
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open StepCopyBody190 (addr elem)
open StepProductBody191 (value output next)

structure Fixed (s : State) (fd t1 : ArrayPointer) (u0 tlen n : Nat) (p p0i r2 : BitVec 32)
    (fv : Nat → BitVec 32) : Prop where
  nBound : n<2^64
  nWide : 2*n+1<2^64
  tlenBound : tlen<2^64
  uBound : u0<2^64
  fdWidth : fd.elementBytes=4
  fdCapacity : fd.index+u0+n*tlen≤fd.count
  fdWritable : s.heap.writable fd.block=true
  t1Binding : s.arrays "t1".toList=some t1
  nCell : Cell s "hn".toList n
  tlenCell : Cell s "tlen".toList tlen
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  r2Cell : Slot s "R2" r2
  fdAllocated : ∀ i : Fin n, Allocated s.heap (addr fd u0 i.val tlen)
  dstSrcSeparate : ∀ i : Fin n, ∀ j : Fin (2*n), Separate (addr fd u0 i.val tlen) (elem t1 j.val)
  dstSeparate : ∀ i j : Fin n, i≠j → Separate (addr fd u0 i.val tlen) (addr fd u0 j.val tlen)
  src : ∀ i : Fin (2*n), Load32 s.heap (elem t1 i.val) (fv i.val)

def Image (s : State) (fd : ArrayPointer) (u0 tlen n : Nat) (p p0i r2 : BitVec 32)
    (fv : Nat → BitVec 32) (v : Nat) : Prop :=
  ∀ i : Fin n, i.val<v → Load32 s.heap (addr fd u0 i.val tlen)
    (value (fv (2*i.val)) (fv (2*i.val+1)) r2 p p0i)

theorem load_allocated {h : C99MemoryReference.Memory} {p : ArrayPointer} {w : BitVec 32}
    (read : Load32 h p w) : Allocated h p := by
  cases read with
  | load b allocated width init => exact allocated

theorem load_width {h : C99MemoryReference.Memory} {p : ArrayPointer} {w : BitVec 32}
    (read : Load32 h p w) : p.elementBytes=4 := by
  cases read with
  | load b allocated width init => exact width

theorem separate_symm {p q : ArrayPointer} (separate : Separate p q) : Separate q p := by
  unfold Separate at *
  omega

theorem bindPointer_arrays (s : State) (name : Name) (p : ArrayPointer) (other : Name)
    (different : other≠name) : (C99ArrayReference.bindPointer s name p).arrays other=s.arrays other := by
  simp [C99ArrayReference.bindPointer,different]

theorem next_locals (s : State) (fd : ArrayPointer) (u0 tlen i : Nat) (other : Name)
    (different : other≠"v".toList) :
    (next s fd u0 tlen i).locals other=s.locals other := by
  have first : (next s fd u0 tlen i).locals other=
      (FftLocalCells140.put s "v".toList (C99NatWord141.word (i+1))).locals other := rfl
  rw [first]
  exact (FftLocalCells140.outside s "v".toList other
    (C99NatWord141.word (i+1)) different).trans rfl

theorem next_cell (s : State) (fd : ArrayPointer) (u0 tlen i : Nat) (name : Name) (m : Nat)
    (different : name≠"v".toList) (cell : Cell s name m) :
    Cell (next s fd u0 tlen i) name m := by
  show (next s fd u0 tlen i).locals name=some (.uint64,some (.uint64 (C99NatWord141.word m)))
  rw [next_locals s fd u0 tlen i name different]
  exact cell

theorem next_slot (s : State) (fd : ArrayPointer) (u0 tlen i : Nat) (name : String) (m : BitVec 32)
    (different : name.toList≠"v".toList) (cell : Slot s name m) :
    Slot (next s fd u0 tlen i) name m := by
  show (next s fd u0 tlen i).locals name.toList=some (.uint32,some (.uint32 m))
  rw [next_locals s fd u0 tlen i name.toList different]
  exact cell

theorem next_arrays (s : State) (fd : ArrayPointer) (u0 tlen i : Nat) (other : Name)
    (different : other≠"x".toList) :
    (next s fd u0 tlen i).arrays other=s.arrays other := by
  have first : (next s fd u0 tlen i).arrays other=
      (C99ArrayReference.bindPointer (FftLocalCells140.put s "v".toList
        (C99NatWord141.word (i+1))) "x".toList (addr fd u0 (i+1) tlen)).arrays other := rfl
  rw [first]
  rw [bindPointer_arrays (FftLocalCells140.put s "v".toList
    (C99NatWord141.word (i+1))) "x".toList (addr fd u0 (i+1) tlen) other different]
  rfl

theorem next_heap (s : State) (fd : ArrayPointer) (u0 tlen i : Nat) :
    (next s fd u0 tlen i).heap=s.heap := rfl

theorem next_x (s : State) (fd : ArrayPointer) (u0 tlen i : Nat) :
    (next s fd u0 tlen i).arrays "x".toList=some (addr fd u0 (i+1) tlen) := rfl

theorem next_v (s : State) (fd : ArrayPointer) (u0 tlen i : Nat) :
    Cell (next s fd u0 tlen i) "v".toList (i+1) :=
  FftLocalCells140.cell_at s "v".toList (C99NatWord141.word (i+1))

theorem output_heap (s : State) (fd : ArrayPointer) (u0 tlen v : Nat) (z : BitVec 32) :
    (output s fd u0 tlen v z).heap=Word32Memory176.write s.heap (addr fd u0 v tlen) z := rfl

theorem product_capacity (s : State) (fd : ArrayPointer) (u0 tlen v : Nat)
    (allocated : Allocated s.heap (addr fd u0 v tlen)) : fd.index+u0+v*tlen<fd.count := by
  have base := allocated.2.2.1
  simpa [StepCopyBody190.addr] using base

theorem product_capacity_next (fd : ArrayPointer) (u0 tlen n v : Nat)
    (capacity : fd.index+u0+n*tlen≤fd.count) (slot : v<n) : fd.index+u0+v*tlen+tlen≤fd.count := by
  have step : (v+1)*tlen≤n*tlen := Nat.mul_le_mul_right tlen (by omega)
  rw [Nat.add_mul,Nat.one_mul] at step
  omega

theorem output_fixed (s : State) (fd t1 : ArrayPointer) (u0 tlen n : Nat) (p p0i r2 : BitVec 32)
    (fv : Nat → BitVec 32) (v : Nat) (z : BitVec 32) (fixed : Fixed s fd t1 u0 tlen n p p0i r2 fv)
    (slot : v<n) : Fixed (output s fd u0 tlen v z) fd t1 u0 tlen n p p0i r2 fv := by
  refine ⟨fixed.nBound,fixed.nWide,fixed.tlenBound,fixed.uBound,fixed.fdWidth,fixed.fdCapacity,
    ?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · rw [output_heap s fd u0 tlen v z]
    exact fixed.fdWritable
  · exact fixed.t1Binding
  · exact fixed.nCell
  · exact fixed.tlenCell
  · exact fixed.pCell
  · exact fixed.iCell
  · exact fixed.r2Cell
  · intro i
    rw [output_heap s fd u0 tlen v z]
    exact fixed.fdAllocated i
  · intro i j
    exact fixed.dstSrcSeparate i j
  · intro i j different
    exact fixed.dstSeparate i j different
  · intro i
    rw [output_heap s fd u0 tlen v z]
    exact Word32Memory176.outside s.heap (addr fd u0 v tlen) (elem t1 i.val) z (fv i.val)
      (fixed.dstSrcSeparate ⟨v,slot⟩ i) (fixed.src i)

theorem output_prefix (s : State) (fd t1 : ArrayPointer) (u0 tlen n : Nat) (p p0i r2 : BitVec 32)
    (fv : Nat → BitVec 32) (v : Nat) (fixed : Fixed s fd t1 u0 tlen n p p0i r2 fv) (slot : v<n)
    (copied : Image s fd u0 tlen n p p0i r2 fv v) :
    Image (output s fd u0 tlen v (value (fv (2*v)) (fv (2*v+1)) r2 p p0i))
      fd u0 tlen n p p0i r2 fv (v+1) := by
  intro i bound
  rw [output_heap s fd u0 tlen v]
  by_cases same : i.val=v
  · have key : i=⟨v,slot⟩ := Fin.ext same
    subst key
    exact Word32Memory176.here s.heap (addr fd u0 v tlen)
      (value (fv (2*v)) (fv (2*v+1)) r2 p p0i)
      (fixed.fdAllocated ⟨v,slot⟩) fixed.fdWidth fixed.fdWritable
  · have different : (⟨v,slot⟩ : Fin n)≠i := fun equal =>
      same (congrArg Fin.val equal).symm
    exact Word32Memory176.outside s.heap (addr fd u0 v tlen) (addr fd u0 i.val tlen)
      (value (fv (2*v)) (fv (2*v+1)) r2 p p0i) (value (fv (2*i.val)) (fv (2*i.val+1)) r2 p p0i)
      (fixed.dstSeparate ⟨v,slot⟩ i different) (copied i (by omega))

theorem next_fixed (s : State) (fd t1 : ArrayPointer) (u0 tlen n : Nat) (p p0i r2 : BitVec 32)
    (fv : Nat → BitVec 32) (v : Nat) (fixed : Fixed s fd t1 u0 tlen n p p0i r2 fv) :
    Fixed (next s fd u0 tlen v) fd t1 u0 tlen n p p0i r2 fv := by
  refine ⟨fixed.nBound,fixed.nWide,fixed.tlenBound,fixed.uBound,fixed.fdWidth,fixed.fdCapacity,
    ?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · rw [next_heap]; exact fixed.fdWritable
  · rw [next_arrays s fd u0 tlen v "t1".toList (by decide)]
    exact fixed.t1Binding
  · exact next_cell s fd u0 tlen v "hn".toList n (by decide) fixed.nCell
  · exact next_cell s fd u0 tlen v "tlen".toList tlen (by decide) fixed.tlenCell
  · exact next_slot s fd u0 tlen v "p" p (by decide) fixed.pCell
  · exact next_slot s fd u0 tlen v "p0i" p0i (by decide) fixed.iCell
  · exact next_slot s fd u0 tlen v "R2" r2 (by decide) fixed.r2Cell
  · intro i
    rw [next_heap]
    exact fixed.fdAllocated i
  · intro i j
    exact fixed.dstSrcSeparate i j
  · intro i j different
    exact fixed.dstSeparate i j different
  · intro i
    rw [next_heap]
    exact fixed.src i

theorem next_prefix (s : State) (fd : ArrayPointer) (u0 tlen n : Nat) (p p0i r2 : BitVec 32)
    (fv : Nat → BitVec 32) (v : Nat) (copied : Image s fd u0 tlen n p p0i r2 fv (v+1)) :
    Image (next s fd u0 tlen v) fd u0 tlen n p p0i r2 fv (v+1) := by
  intro i bound
  rw [next_heap]
  exact copied i bound

theorem empty_image (s : State) (fd : ArrayPointer) (u0 tlen n : Nat) (p p0i r2 : BitVec 32)
    (fv : Nat → BitVec 32) : Image s fd u0 tlen n p p0i r2 fv 0 :=
  fun i bound => absurd bound (by omega)

end FT1536.Source3.StepProductFixed203
