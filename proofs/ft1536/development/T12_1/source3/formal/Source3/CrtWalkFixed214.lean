import Source3.CrtWalkIncrement214

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtWalkFixed214
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open CrtWalkIncrement214 (row point)

structure Fixed (s : State) (root tmp : ArrayPointer) (n len stride : Nat) (T : Nat → BitVec 32) (p pi r2 c : BitVec 32) : Prop where
  nBound : n < 2^64
  lenBound : len < 2^64
  strideBound : stride < 2^64
  room : len+1 ≤ stride
  width : root.elementBytes=4
  capacity : root.index+n*stride ≤ root.count
  writable : s.heap.writable root.block=true
  tmpBinding : s.arrays "tmp".toList=some tmp
  numCell : Cell s "num".toList n
  uCell : Cell s "u".toList len
  strideCell : Cell s "xstride".toList stride
  pCell : Slot s "p" p
  iCell : Slot s "p0i" pi
  rCell : Slot s "R2" r2
  sCell : Slot s "s" c
  tmpCapacity : tmp.index ≤ tmp.count
  tmpRead : ∀ j, j < len → Load32 s.heap (elem tmp j) (T j)
  apart : ∀ i j k, i < n → j ≤ len → k < len → Separate (point root stride i j) (elem tmp k)

def Pending (s : State) (root : ArrayPointer) (n len stride : Nat) (rows : Nat → Nat → BitVec 32) (v : Nat) : Prop :=
  ∀ i, v ≤ i → i < n → ∀ j, j ≤ len → Load32 s.heap (point root stride i j) (rows i j)
 def Written (s : State) (root : ArrayPointer) (len stride : Nat) (rows : Nat → Nat → BitVec 32) (T : Nat → BitVec 32)
    (p pi r2 c : BitVec 32) (v : Nat) : Prop :=
  ∀ i, i < v → ∀ j, j ≤ len → Load32 s.heap (point root stride i j) (CrtCoefficientState214.words (rows i) T len p pi r2 c j)

theorem different (root : ArrayPointer) (len stride v i a b : Nat) (width : root.elementBytes=4)
    (room : len+1 ≤ stride) (ar : a ≤ len) (br : b ≤ len) (neq : v≠i) :
    Separate (point root stride v a) (point root stride i b) :=
  ZintNormWalkFixed208.different root stride v i a b width (by omega) (by omega) neq

theorem row_capacity (root : ArrayPointer) (n len stride v : Nat) (cap : root.index+n*stride ≤ root.count)
    (slot : v < n) (room : len+1 ≤ stride) : (row root stride v).index+len < (row root stride v).count := by
  have bound:=ZintNormWalkFixed208.row_capacity root n stride v cap slot
  change (row root stride v).index+stride ≤ (row root stride v).count at bound
  omega

end FT1536.Source3.CrtWalkFixed214
