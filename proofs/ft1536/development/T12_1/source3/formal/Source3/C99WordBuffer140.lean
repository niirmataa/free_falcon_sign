import Source3.C99WordRead140
import Source3.FftLoadExec140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99WordBuffer140
open C99MemoryReference

def element (base : ArrayPointer) {n : Nat} (i : Fin n) : ArrayPointer :=
  {base with index := base.index+i.val}

def Represents (heap : Memory) (base : ArrayPointer) {n : Nat} (values : Fin n → BitVec 64) : Prop :=
  ∀ i, Load64 heap (element base i) (values i)

def updated {n : Nat} (values : Fin n → BitVec 64) (slot : Fin n) (word : BitVec 64) : Fin n → BitVec 64 :=
  fun i => if i=slot then word else values i

theorem separate {n : Nat} (base : ArrayPointer) (width : base.elementBytes=8) (i j : Fin n) (different : i≠j) :
    C99WordRead140.Separate (element base i) (element base j) := by
  have distinct : i.val≠j.val := fun same => different (Fin.ext same)
  unfold C99WordRead140.Separate element ArrayPointer.offset
  rw [width]
  change base.block≠base.block ∨ base.base+8*(base.index+i.val)+8≤base.base+8*(base.index+j.val) ∨
    base.base+8*(base.index+j.val)+8≤base.base+8*(base.index+i.val)
  omega

/-- A source-legal word write preserves a complete symbolic buffer image.
    This is universal in the buffer length, contents and selected index. -/
theorem write_preserves {n : Nat} (heap : Memory) (base : ArrayPointer) (values : Fin n → BitVec 64)
    (represented : Represents heap base values) (width : base.elementBytes=8)
    (writable : heap.writable base.block=true) (slot : Fin n) (word : BitVec 64) :
    Represents (C99WordStore140.write heap (element base slot) word) base (updated values slot word) := by
  intro i
  by_cases same : i=slot
  · subst i
    have result := C99WordRead140.here heap (element base slot) word
      (FftLoadExec140.allocated_of_load heap (element base slot) (values slot) (represented slot)) width writable
    simpa [updated] using result
  · have result := C99WordRead140.outside heap (element base slot) (element base i) word (values i)
      (separate base width slot i (Ne.symm same)) (represented i)
    simpa only [updated,ite_eq_right same] using result

end FT1536.Source3.C99WordBuffer140
