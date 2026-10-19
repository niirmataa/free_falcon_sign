import Source3.StepCopyBody190

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Loop invariant for the original fs-to-t1 copy loop: stable source reads,
   exact pointer walk and the copied prefix; values come only from the
   executed loads. -/
namespace FT1536.Source3.StepCopyFixed190
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open C99LoopScalar141 (Cell)
open StepCopyBody190 (addr elem output next)

structure Fixed (s : State) (fs t1 : ArrayPointer) (u0 slen n : Nat) (fv : Fin n → BitVec 32) : Prop where
  nBound : n<2^64
  slenBound : slen<2^64
  uBound : u0<2^64
  fsWidth : fs.elementBytes=4
  t1Width : t1.elementBytes=4
  fsCapacity : fs.index+u0+n*slen≤fs.count
  t1Capacity : t1.index+n≤t1.count
  t1Writable : s.heap.writable t1.block=true
  fsBinding : s.arrays "fs".toList=some fs
  t1Binding : s.arrays "t1".toList=some t1
  nCell : Cell s "n".toList n
  slenCell : Cell s "slen".toList slen
  t1Allocated : ∀ i : Fin n, Allocated s.heap (elem t1 i)
  t1Separate : ∀ v i : Fin n, Separate (elem t1 v) (addr fs u0 i.val slen)
  prefixSeparate : ∀ i j : Fin n, i≠j → Separate (elem t1 i) (elem t1 j)
  src : ∀ i : Fin n, Load32 s.heap (addr fs u0 i.val slen) (fv i)

def PrefixImage (s : State) (t1 : ArrayPointer) {n : Nat} (fv : Fin n → BitVec 32) (v : Nat) : Prop :=
  ∀ i : Fin n, i.val<v → Load32 s.heap (elem t1 i) (fv i)

theorem elem_separate (t1 : ArrayPointer) (width : t1.elementBytes=4) (i j : Nat) (different : i≠j) :
    Separate (elem t1 i) (elem t1 j) := by
  unfold Separate StepCopyBody190.elem C99MemoryReference.ArrayPointer.offset
  rw [width]
  change t1.block≠t1.block ∨ t1.base+4*(t1.index+i)+4≤t1.base+4*(t1.index+j) ∨
    t1.base+4*(t1.index+j)+4≤t1.base+4*(t1.index+i)
  omega

theorem separate_symm {p q : ArrayPointer} (separate : Separate p q) : Separate q p := by
  unfold Separate at *
  omega

theorem bindPointer_arrays (s : State) (name : Name) (p : ArrayPointer) (other : Name)
    (different : other≠name) : (C99ArrayReference.bindPointer s name p).arrays other=s.arrays other := by
  simp [C99ArrayReference.bindPointer,different]

theorem next_locals (s : State) (fs t1 : ArrayPointer) (u0 slen i : Nat) (w : BitVec 32)
    (other : Name) (different : other≠"v".toList) :
    (next s fs t1 u0 slen i w).locals other=s.locals other := by
  have first : (next s fs t1 u0 slen i w).locals other=
      (FftLocalCells140.put (output s t1 i w) "v".toList (C99NatWord141.word (i+1))).locals other := rfl
  rw [first]
  exact (FftLocalCells140.outside (output s t1 i w) "v".toList other
    (C99NatWord141.word (i+1)) different).trans rfl

theorem next_cell (s : State) (fs t1 : ArrayPointer) (u0 slen i : Nat) (w : BitVec 32)
    (name : Name) (m : Nat) (different : name≠"v".toList) (cell : Cell s name m) :
    Cell (next s fs t1 u0 slen i w) name m := by
  show (next s fs t1 u0 slen i w).locals name=some (.uint64,some (.uint64 (C99NatWord141.word m)))
  rw [next_locals s fs t1 u0 slen i w name different]
  exact cell

theorem next_arrays (s : State) (fs t1 : ArrayPointer) (u0 slen i : Nat) (w : BitVec 32)
    (other : Name) (different : other≠"x".toList) :
    (next s fs t1 u0 slen i w).arrays other=s.arrays other := by
  have first : (next s fs t1 u0 slen i w).arrays other=
      (C99ArrayReference.bindPointer (FftLocalCells140.put (output s t1 i w) "v".toList
        (C99NatWord141.word (i+1))) "x".toList (addr fs u0 (i+1) slen)).arrays other := rfl
  rw [first]
  rw [bindPointer_arrays (FftLocalCells140.put (output s t1 i w) "v".toList
    (C99NatWord141.word (i+1))) "x".toList (addr fs u0 (i+1) slen) other different]
  rfl

theorem next_heap (s : State) (fs t1 : ArrayPointer) (u0 slen i : Nat) (w : BitVec 32) :
    (next s fs t1 u0 slen i w).heap=Word32Memory176.write s.heap (elem t1 i) w := rfl

theorem next_x (s : State) (fs t1 : ArrayPointer) (u0 slen i : Nat) (w : BitVec 32) :
    (next s fs t1 u0 slen i w).arrays "x".toList=some (addr fs u0 (i+1) slen) := rfl

theorem copy_capacity (fs : ArrayPointer) (u0 slen n v : Nat)
    (capacity : fs.index+u0+n*slen≤fs.count) (slot : v<n) : fs.index+u0+v*slen≤fs.count := by
  have step : (v+1)*slen≤n*slen := Nat.mul_le_mul_right slen (by omega)
  rw [Nat.add_mul,Nat.one_mul] at step
  omega

theorem copy_capacity_next (fs : ArrayPointer) (u0 slen n v : Nat)
    (capacity : fs.index+u0+n*slen≤fs.count) (slot : v<n) : fs.index+u0+v*slen+slen≤fs.count := by
  have step : (v+1)*slen≤n*slen := Nat.mul_le_mul_right slen (by omega)
  rw [Nat.add_mul,Nat.one_mul] at step
  omega

theorem next_fixed (s : State) (fs t1 : ArrayPointer) (u0 slen n v : Nat) (fv : Fin n → BitVec 32)
    (fixed : Fixed s fs t1 u0 slen n fv) (slot : v<n) :
    Fixed (next s fs t1 u0 slen v (fv ⟨v,slot⟩)) fs t1 u0 slen n fv := by
  refine ⟨fixed.nBound,fixed.slenBound,fixed.uBound,fixed.fsWidth,fixed.t1Width,fixed.fsCapacity,
    fixed.t1Capacity,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · exact fixed.t1Writable
  · rw [next_arrays s fs t1 u0 slen v (fv ⟨v,slot⟩) "fs".toList (by decide)]
    exact fixed.fsBinding
  · rw [next_arrays s fs t1 u0 slen v (fv ⟨v,slot⟩) "t1".toList (by decide)]
    exact fixed.t1Binding
  · exact next_cell s fs t1 u0 slen v (fv ⟨v,slot⟩) "n".toList n (by decide) fixed.nCell
  · exact next_cell s fs t1 u0 slen v (fv ⟨v,slot⟩) "slen".toList slen (by decide) fixed.slenCell
  · intro i
    rw [next_heap]
    exact fixed.t1Allocated i
  · intro v' i
    exact fixed.t1Separate v' i
  · intro i j different
    exact fixed.prefixSeparate i j different
  · intro i
    rw [next_heap]
    exact Word32Memory176.outside s.heap (elem t1 v) (addr fs u0 i.val slen)
      (fv ⟨v,slot⟩) (fv i) (fixed.t1Separate ⟨v,slot⟩ i) (fixed.src i)

end FT1536.Source3.StepCopyFixed190
