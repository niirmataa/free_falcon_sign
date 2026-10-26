import Source3.CrtWalkIncrement206

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtWalkFixed206
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open C99LoopScalar141 (Cell)
open CrtState205 (Slot64)
open KeygenModpR2Exec (Slot)
open CrtWalkIncrement206 (cell)

def high (root : ArrayPointer) (v : Nat) := ZintAddMulWord205.next (cell root v)
 def lowWord (a b t p pi r2 c : BitVec 32) :=
  ZintAddMulWord205.low a t (CrtCoefficient205.correctionWord a b p pi r2 c)
 def highWord (a b t p pi r2 c : BitVec 32) :=
  ZintAddMulWord205.carry a t (CrtCoefficient205.correctionWord a b p pi r2 c)

structure Fixed (s : State) (root tmp : ArrayPointer) (n : Nat) (t p pi r2 c : BitVec 32) : Prop where
  nBound : n < 2^64
  width : root.elementBytes=4
  capacity : root.index+2*n ≤ root.count
  writable : s.heap.writable root.block=true
  tmpBinding : s.arrays "tmp".toList=some tmp
  uCell : Slot64 s "u" 1
  pCell : Slot s "p" p
  iCell : Slot s "p0i" pi
  rCell : Slot s "R2" r2
  sCell : Slot s "s" c
  numCell : Cell s "num".toList n
  strideCell : Cell s "xstride".toList 2
  tmpRead : Load32 s.heap tmp t
  apart : ∀ i : Fin n, Separate (cell root i.val) tmp ∧ Separate (high root i.val) tmp

def Pending (s : State) (root : ArrayPointer) {n : Nat} (av bv : Fin n → BitVec 32) (v : Nat) : Prop :=
  ∀ i : Fin n, v ≤ i.val → Load32 s.heap (cell root i.val) (av i) ∧ Load32 s.heap (high root i.val) (bv i)
 def Written (s : State) (root : ArrayPointer) {n : Nat} (av bv : Fin n → BitVec 32)
    (t p pi r2 c : BitVec 32) (v : Nat) : Prop :=
  ∀ i : Fin n, i.val < v → Load32 s.heap (cell root i.val) (lowWord (av i) (bv i) t p pi r2 c) ∧
    Load32 s.heap (high root i.val) (highWord (av i) (bv i) t p pi r2 c)

theorem high_eq (root : ArrayPointer) (v : Nat) : high root v=StepCopyBody190.elem root (2*v+1) := by
  exact congrArg (fun i : Nat => (⟨root.block,root.base,root.count,root.elementBytes,i⟩ : ArrayPointer))
    (show root.index+2*v+1=root.index+(2*v+1) by omega)

theorem different (root : ArrayPointer) (width : root.elementBytes=4) (i j : Nat) (neq : i≠j) :
    Separate (cell root i) (cell root j) ∧ Separate (cell root i) (high root j) ∧
      Separate (high root i) (cell root j) ∧ Separate (high root i) (high root j) := by
  rw [high_eq,high_eq]
  exact ⟨StepCopyFixed203.elem_separate root width (2*i) (2*j) (by omega),
    StepCopyFixed203.elem_separate root width (2*i) (2*j+1) (by omega),
    StepCopyFixed203.elem_separate root width (2*i+1) (2*j) (by omega),
    StepCopyFixed203.elem_separate root width (2*i+1) (2*j+1) (by omega)⟩

end FT1536.Source3.CrtWalkFixed206
