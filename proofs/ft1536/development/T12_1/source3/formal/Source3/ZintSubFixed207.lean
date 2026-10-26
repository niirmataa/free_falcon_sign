import Source3.ZintSubLimb207

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintSubFixed207
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open CrtState205 (set64)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)

def borrowWord (av bv : Nat → BitVec 32) : Nat → BitVec 32
  | 0 => 0
  | i+1 => ZintSubLimb207.borrow (av i) (bv i) (borrowWord av bv i)
 def outputWord (av bv : Nat → BitVec 32) (i : Nat) := ZintSubLimb207.limb (av i) (bv i) (borrowWord av bv i)

structure Fixed (s : State) (pa pb : ArrayPointer) (n : Nat) (bv : Nat → BitVec 32) : Prop where
  nBound : n < 2^64
  width : pa.elementBytes=4
  capacity : pa.index+n ≤ pa.count
  writable : s.heap.writable pa.block=true
  aBinding : s.arrays ZintSubWord194.aName=some pa
  bBinding : s.arrays ZintSubWord194.bName=some pb
  lenCell : Cell s ZintSubWord194.lenName n
  bRead : ∀ i, i < n → Load32 s.heap (elem pb i) (bv i)
  apart : ∀ i j, i < n → j < n → Separate (elem pa i) (elem pb j)

def Pending (s : State) (pa : ArrayPointer) (n : Nat) (av : Nat → BitVec 32) (v : Nat) : Prop :=
  ∀ i, v ≤ i → i < n → Load32 s.heap (elem pa i) (av i)
 def Written (s : State) (pa : ArrayPointer) (av bv : Nat → BitVec 32) (v : Nat) : Prop :=
  ∀ i, i < v → Load32 s.heap (elem pa i) (outputWord av bv i)
 def output (s : State) (pa : ArrayPointer) (av bv : Nat → BitVec 32) (v : Nat) :=
  ZintSubLimb207.after s (elem pa v) (av v) (bv v) (borrowWord av bv v)
 def next (s : State) (pa : ArrayPointer) (av bv : Nat → BitVec 32) (v : Nat) :=
  set64 (output s pa av bv v) "u" (C99NatWord141.word (v+1))

theorem next_locals (s : State) (pa : ArrayPointer) (av bv : Nat → BitVec 32) (v : Nat) (name : Name)
    (nu : name≠ZintSubWord194.uName) (nc : name≠ZintSubWord194.ccName) :
    (next s pa av bv v).locals name=s.locals name :=
  (SelectedStepAddPrime195.locals_keep (output s pa av bv v) ZintSubWord194.uName .uint64
    (.uint64 (C99NatWord141.word (v+1))) name nu).trans
    (ZintSubLimb207.locals s (elem pa v) (av v) (bv v) (borrowWord av bv v) name nc)

theorem next_arrays (s : State) (pa : ArrayPointer) (av bv : Nat → BitVec 32) (v : Nat) :
    (next s pa av bv v).arrays=s.arrays := rfl

end FT1536.Source3.ZintSubFixed207
