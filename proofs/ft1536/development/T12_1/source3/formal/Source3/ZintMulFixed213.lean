import Source3.ZintMulLimb213

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintMulFixed213
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open CrtState205 (set64)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open KeygenModpR2Exec (Slot)

def carryWord (av : Nat → BitVec 32) (b : BitVec 32) : Nat → BitVec 32
  | 0 => 0
  | i+1 => ZintMulLimb213.nextCarry (av i) b (carryWord av b i)
 def outputWord (av : Nat → BitVec 32) (b : BitVec 32) (i : Nat) := ZintMulLimb213.low (av i) b (carryWord av b i)

structure Fixed (s : State) (pa : ArrayPointer) (n : Nat) (b : BitVec 32) : Prop where
  nBound : n < 2^64
  width : pa.elementBytes=4
  capacity : pa.index+n ≤ pa.count
  writable : s.heap.writable pa.block=true
  binding : s.arrays ZintMulWord205.m=some pa
  lenCell : Cell s ZintMulWord205.mlen n
  xCell : Slot s "x" b

def Pending (s : State) (pa : ArrayPointer) (n : Nat) (av : Nat → BitVec 32) (v : Nat) : Prop :=
  ∀ i, v ≤ i → i < n → Load32 s.heap (elem pa i) (av i)
 def Written (s : State) (pa : ArrayPointer) (av : Nat → BitVec 32) (b : BitVec 32) (v : Nat) : Prop :=
  ∀ i, i < v → Load32 s.heap (elem pa i) (outputWord av b i)
 def output (s : State) (pa : ArrayPointer) (av : Nat → BitVec 32) (b : BitVec 32) (v : Nat) :=
  ZintMulLimb213.after s (elem pa v) (av v) b (carryWord av b v)
 def next (s : State) (pa : ArrayPointer) (av : Nat → BitVec 32) (b : BitVec 32) (v : Nat) :=
  set64 (output s pa av b v) "u" (C99NatWord141.word (v+1))

theorem next_locals (s : State) (pa : ArrayPointer) (av : Nat → BitVec 32) (b : BitVec 32) (v : Nat) (name : Name)
    (nu : name≠ZintMulWord205.u) (nc : name≠ZintMulWord205.cc) :
    (next s pa av b v).locals name=s.locals name :=
  (SelectedStepAddPrime195.locals_keep (output s pa av b v) ZintMulWord205.u .uint64
    (.uint64 (C99NatWord141.word (v+1))) name nu).trans
    (ZintMulLimb213.locals s (elem pa v) (av v) b (carryWord av b v) name nc)

theorem next_arrays (s : State) (pa : ArrayPointer) (av : Nat → BitVec 32) (b : BitVec 32) (v : Nat) :
    (next s pa av b v).arrays=s.arrays := rfl

end FT1536.Source3.ZintMulFixed213
