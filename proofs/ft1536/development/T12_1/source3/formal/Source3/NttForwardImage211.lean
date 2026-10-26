import Source3.NttForwardMiddle211

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttForwardImage211
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open StepCopyBody190 (elem)
open NttBinaryBody183 (leftWord rightWord)
open StepNttImage195 (pairAt)

variable {size : Nat}

abbrev Image (s : State) (a : ArrayPointer) (W : Nat → BitVec 32) := ZintNormWalkFlat208.Data s a size W

theorem image_keep {s out : State} {a : ArrayPointer} {W : Nat → BitVec 32} (data : Image (size:=size) s a W)
    (heap : out.heap=s.heap) : Image (size:=size) out a W := by intro j bound; rw [heap]; exact data j bound

theorem image_reads {s : State} {a : ArrayPointer} {W : Nat → BitVec 32} (data : Image (size:=size) s a W)
    (j : Nat) (bound : j < size) : ∃ w, Load32 s.heap (elem a j) w := ⟨W j,data j bound⟩

theorem image_word {s : State} {a : ArrayPointer} {W : Nat → BitVec 32} (data : Image (size:=size) s a W)
    {j : Nat} {w : BitVec 32} (bound : j < size) (read : Load32 s.heap (elem a j) w) : w=W j :=
  Gate00Memory.load32_deterministic _ _ _ _ read (data j bound)

theorem binary_step {s : State} {a : ArrayPointer} {W : Nat → BitVec 32} (data : Image (size:=size) s a W)
    (width : a.elementBytes=4) (writable : s.heap.writable a.block=true) (i k : Nat) (ib : i < size) (kb : k < size)
    (different : i≠k) (tw p pi : BitVec 32) (pc : Slot s "p" p) (ic : Slot s "p0i" pi) (wc : Slot s "s" tw)
    (r1 : s.arrays "r1".toList=some (elem a i)) (r2 : s.arrays "r2".toList=some (elem a k)) :
    let out:=NttBinaryBody183.after s (elem a i) (elem a k) (W i) (W k) tw p pi
    Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.binaryBody) s ⟨out,.normal⟩ ∧
      Image (size:=size) out a (pairAt W i k (leftWord (W i) (W k) tw p pi) (rightWord (W i) (W k) tw p pi)) := by
  have result:=NttForwardBinary211.source s a size W i k tw p pi data ib kb different width writable pc ic wc r1 r2
  exact ⟨result.1,result.2.1⟩

end FT1536.Source3.NttForwardImage211
