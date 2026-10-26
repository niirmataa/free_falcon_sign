import Source3.ZintNormPrepare207

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintNormFixed207
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)

structure Fixed (s : State) (px pp : ArrayPointer) (n : Nat) (xv pv : Nat → BitVec 32) : Prop where
  nBound : n < 2^64
  width : px.elementBytes=4
  capacity : px.index+n ≤ px.count
  pCapacity : pp.index+0 ≤ pp.count
  writable : s.heap.writable px.block=true
  xBinding : s.arrays ZintNormWord194.xName=some px
  pBinding : s.arrays ZintNormWord194.pName=some pp
  lenCell : Cell s ZintNormWord194.lenName n
  xRead : ∀ i, i < n → Load32 s.heap (elem px i) (xv i)
  pRead : ∀ i, i < n → Load32 s.heap (elem pp i) (pv i)
  apart : ∀ i j, i < n → j < n → Separate (elem px i) (elem pp j)

/- Operational branch choice for the source's descending comparison of
   x with the word-by-word shifted modulus. No integer normalization law. -/
def choice (xv pv : Nat → BitVec 32) (cc : BitVec 32) : Nat → Ordering
  | 0 => .eq
  | i+1 => if (xv i).toNat < (ZintNormPrepare207.threshold (pv i) cc).toNat then .lt
    else if (ZintNormPrepare207.threshold (pv i) cc).toNat < (xv i).toNat then .gt
    else choice xv pv (pv i &&& 1) i

 def resultWord (xv pv : Nat → BitVec 32) (decision : Ordering) (i : Nat) :=
  if decision=.gt then ZintSubFixed207.outputWord xv pv i else xv i
 def Image (s : State) (px : ArrayPointer) (n : Nat) (xv pv : Nat → BitVec 32) (decision : Ordering) : Prop :=
  ∀ i, i < n → Load32 s.heap (elem px i) (resultWord xv pv decision i)
 def flow (decision : Ordering) : C99ProcedureReference.Flow := if decision=.eq then .normal else .returned none

theorem transport (s out : State) (px pp : ArrayPointer) (n : Nat) (xv pv : Nat → BitVec 32)
    (fixed : Fixed s px pp n xv pv) (heap : out.heap=s.heap) (arrays : out.arrays=s.arrays)
    (len : out.locals ZintNormWord194.lenName=s.locals ZintNormWord194.lenName) : Fixed out px pp n xv pv := by
  refine ⟨fixed.nBound,fixed.width,fixed.capacity,fixed.pCapacity,?_,?_,?_,len.trans fixed.lenCell,?_,?_,fixed.apart⟩
  · rw [heap]; exact fixed.writable
  · rw [arrays]; exact fixed.xBinding
  · rw [arrays]; exact fixed.pBinding
  · intro i bound
    rw [heap]; exact fixed.xRead i bound
  · intro i bound
    rw [heap]; exact fixed.pRead i bound

end FT1536.Source3.ZintNormFixed207
