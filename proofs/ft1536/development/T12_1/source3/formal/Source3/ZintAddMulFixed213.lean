import Source3.ZintAddMulLimb213

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintAddMulFixed213
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open CrtState205 (set64)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)

def carryWord (av bv : Nat → BitVec 32) (c : BitVec 32) : Nat → BitVec 32
  | 0 => 0
  | i+1 => ZintAddMulLimb213.nextCarry (av i) (bv i) c (carryWord av bv c i)
 def outputWord (av bv : Nat → BitVec 32) (c : BitVec 32) (i : Nat) := ZintAddMulLimb213.low (av i) (bv i) c (carryWord av bv c i)

structure Fixed (s : State) (pa pb : ArrayPointer) (n : Nat) (bv : Nat → BitVec 32) (c : BitVec 32) : Prop where
  nBound : n < 2^64
  width : pa.elementBytes=4
  capacity : pa.index+n < pa.count
  writable : s.heap.writable pa.block=true
  aBinding : s.arrays ZintAddMulWord205.x=some pa
  bBinding : s.arrays ZintAddMulWord205.y=some pb
  lenCell : Cell s ZintAddMulWord205.len n
  sCell : KeygenModpR2Exec.Slot s "s" c
  tailAllocated : C99MemoryReference.Allocated s.heap (elem pa n)
  bRead : ∀ i, i < n → Load32 s.heap (elem pb i) (bv i)
  apart : ∀ i j, i < n → j < n → Separate (elem pa i) (elem pb j)

def Pending (s : State) (pa : ArrayPointer) (n : Nat) (av : Nat → BitVec 32) (v : Nat) : Prop :=
  ∀ i, v ≤ i → i < n → Load32 s.heap (elem pa i) (av i)
 def Written (s : State) (pa : ArrayPointer) (av bv : Nat → BitVec 32) (c : BitVec 32) (v : Nat) : Prop :=
  ∀ i, i < v → Load32 s.heap (elem pa i) (outputWord av bv c i)
 def output (s : State) (pa : ArrayPointer) (av bv : Nat → BitVec 32) (c : BitVec 32) (v : Nat) :=
  ZintAddMulLimb213.after s (elem pa v) (av v) (bv v) c (carryWord av bv c v)
 def next (s : State) (pa : ArrayPointer) (av bv : Nat → BitVec 32) (c : BitVec 32) (v : Nat) :=
  set64 (output s pa av bv c v) "u" (C99NatWord141.word (v+1))

theorem next_locals (s : State) (pa : ArrayPointer) (av bv : Nat → BitVec 32) (c : BitVec 32) (v : Nat) (name : Name)
    (nu : name≠ZintMulWord205.u) (nc : name≠ZintMulWord205.cc) :
    (next s pa av bv c v).locals name=s.locals name :=
  (SelectedStepAddPrime195.locals_keep (output s pa av bv c v) ZintMulWord205.u .uint64
    (.uint64 (C99NatWord141.word (v+1))) name nu).trans
    (ZintAddMulLimb213.locals s (elem pa v) (av v) (bv v) c (carryWord av bv c v) name nc)

theorem next_arrays (s : State) (pa : ArrayPointer) (av bv : Nat → BitVec 32) (c : BitVec 32) (v : Nat) :
    (next s pa av bv c v).arrays=s.arrays := rfl

end FT1536.Source3.ZintAddMulFixed213
