import Source3.NttForwardFirst211

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttForwardBinary211
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Memory Load32 Allocated)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open NttBinaryBody183 (leftWord rightWord)
open ZintNormWalkFlat208 (Data)
open StepNttImage195 (pairAt)

theorem two_words (heap : Memory) (a : ArrayPointer) (n : Nat) (W : Nat → BitVec 32)
    (data : ∀ j, j < n → Load32 heap (elem a j) (W j)) (width : a.elementBytes=4)
    (writable : heap.writable a.block=true) (i k : Nat) (ib : i < n) (kb : k < n) (different : i≠k) (wi wk : BitVec 32) :
    ∀ j, j < n → Load32 (Word32Memory176.write (Word32Memory176.write heap (elem a i) wi) (elem a k) wk)
      (elem a j) (pairAt W i k wi wk j) := by
  have ai:=StepNttFirstLoop195.load_allocated (data i ib)
  have ak:=StepNttFirstLoop195.load_allocated (data k kb)
  intro j bound
  by_cases isK : j=k
  · subst j
    rw [StepNttImage195.pairAt_k]
    exact StepNttFirstLoop195.two_write_here_right heap (elem a i) (elem a k) wi wk ak width writable
  · by_cases isI : j=i
    · subst j
      rw [StepNttImage195.pairAt_i W i k wi wk different]
      exact StepNttFirstLoop195.two_write_here_left heap (elem a i) (elem a k) wi wk ai width writable
        (StepCopyFixed203.elem_separate a width i k different)
    · rw [StepNttImage195.pairAt_out W i k wi wk j isK isI]
      exact StepNttFirstLoop195.two_write_keep heap (elem a i) (elem a j) (elem a k) wi wk (W j)
        (StepCopyFixed203.elem_separate a width j i (by omega)) (StepCopyFixed203.elem_separate a width j k (by omega)) (data j bound)

theorem source (s : State) (a : ArrayPointer) (n : Nat) (W : Nat → BitVec 32) (i k : Nat) (w p pi : BitVec 32)
    (data : Data s a n W) (ib : i < n) (kb : k < n) (different : i≠k) (width : a.elementBytes=4)
    (writable : s.heap.writable a.block=true) (pc : Slot s "p" p) (ic : Slot s "p0i" pi) (wc : Slot s "s" w)
    (r1 : s.arrays "r1".toList=some (elem a i)) (r2 : s.arrays "r2".toList=some (elem a k)) :
    let out:=NttBinaryBody183.after s (elem a i) (elem a k) (W i) (W k) w p pi
    Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.binaryBody) s ⟨out,.normal⟩ ∧
      Data out a n (pairAt W i k (leftWord (W i) (W k) w p pi) (rightWord (W i) (W k) w p pi)) ∧
      out.locals=s.locals ∧ out.arrays=s.arrays ∧ out.heap.writable=s.heap.writable ∧
      (∀ q old, Separate (elem a i) q → Separate (elem a k) q → Load32 s.heap q old → Load32 out.heap q old) := by
  refine ⟨NttBinaryBody183.source s (elem a i) (elem a k) (W i) (W k) w p pi pc ic wc r1 r2
    (StepNttFirstLoop195.load_allocated (data i ib)) (StepNttFirstLoop195.load_allocated (data k kb)) width width writable writable
    (data i ib) (data k kb),?_,NttBinaryFrame183.locals _ _ _ _ _ _ _ _,NttBinaryFrame183.arrays _ _ _ _ _ _ _ _,rfl,?_⟩
  · exact two_words s.heap a n W data width writable i k ib kb different _ _
  · intro q old first second read
    exact Word32Memory176.outside _ _ _ _ _ second (Word32Memory176.outside _ _ _ _ _ first read)

end FT1536.Source3.NttForwardBinary211
