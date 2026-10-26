import Source3.ZintNormWalkIncrement208

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintNormWalkFixed208
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open ZintNormWalkIncrement208 (row point)

structure Fixed (s : State) (root tmp : ArrayPointer) (n len : Nat) (pv : Nat → BitVec 32) : Prop where
  nBound : n < 2^64
  lenBound : len < 2^64
  positive : 0 < len
  width : root.elementBytes=4
  capacity : root.index+n*len ≤ root.count
  writable : s.heap.writable root.block=true
  tmpBinding : s.arrays "tmp".toList=some tmp
  numCell : Cell s "num".toList n
  lenCell : Cell s "xlen".toList len
  strideCell : Cell s "xstride".toList len
  pCapacity : tmp.index+0 ≤ tmp.count
  pRead : ∀ j, j < len → Load32 s.heap (elem tmp j) (pv j)
  apart : ∀ i j k, i < n → j < len → k < len → Separate (point root len i j) (elem tmp k)

def resultWord (rows : Nat → Nat → BitVec 32) (pv : Nat → BitVec 32) (len i j : Nat) :=
  ZintNormFixed207.resultWord (rows i) pv (ZintNormFixed207.choice (rows i) pv 0 len) j
 def Pending (s : State) (root : ArrayPointer) (n len : Nat) (rows : Nat → Nat → BitVec 32) (v : Nat) : Prop :=
  ∀ i, v ≤ i → i < n → ∀ j, j < len → Load32 s.heap (point root len i j) (rows i j)
 def Written (s : State) (root : ArrayPointer) (len : Nat) (rows : Nat → Nat → BitVec 32) (pv : Nat → BitVec 32) (v : Nat) : Prop :=
  ∀ i, i < v → ∀ j, j < len → Load32 s.heap (point root len i j) (resultWord rows pv len i j)

theorem index_different (len v i a b : Nat) (ar : a < len) (br : b < len) (different : v≠i) :
    v*len+a≠i*len+b := by
  intro equal
  by_cases less : v < i
  · have upper : v*len+a < (v+1)*len := by rw [Nat.add_mul,Nat.one_mul]; omega
    have order : (v+1)*len ≤ i*len := Nat.mul_le_mul_right len (by omega)
    omega
  · have lower : i < v := by omega
    have upper : i*len+b < (i+1)*len := by rw [Nat.add_mul,Nat.one_mul]; omega
    have order : (i+1)*len ≤ v*len := Nat.mul_le_mul_right len (by omega)
    omega

theorem different (root : ArrayPointer) (len v i a b : Nat) (width : root.elementBytes=4)
    (ar : a < len) (br : b < len) (neq : v≠i) :
    Separate (point root len v a) (point root len i b) :=
  StepCopyFixed203.elem_separate root width (v*len+a) (i*len+b) (index_different len v i a b ar br neq)

theorem row_capacity (root : ArrayPointer) (n len v : Nat) (cap : root.index+n*len ≤ root.count) (slot : v < n) :
    (row root len v).index+len ≤ (row root len v).count := by
  have order : (v+1)*len ≤ n*len := Nat.mul_le_mul_right len (by omega)
  rw [Nat.add_mul,Nat.one_mul] at order
  change root.index+v*len+len ≤ root.count
  omega

end FT1536.Source3.ZintNormWalkFixed208
