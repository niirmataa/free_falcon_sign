import Source3.TopProductEval186

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.TopProductMemory186
open C99MemoryReference (Memory ArrayPointer Allocated Load32)
open KeygenSmallOutput (element)
open SelectedTopLayout177 (fd gd fs gs)

def Reads (heap : Memory) (base : ArrayPointer) : Prop := ∀ i<1536, ∃ word, Load32 heap (element base i) word
abbrev Frame := NttWriteFrame182.Frame fd 1024

theorem f_outside (i : Nat) (byte : Fin 4) :
    NttWriteFrame182.Outside fd 1024 (element fs i).block ((element fs i).offset+byte.val) := by
  right; right
  change 0+4*670+4*1024≤0+4*(1694+i)+byte.val
  omega

theorem g_outside (i : Nat) (byte : Fin 4) :
    NttWriteFrame182.Outside fd 1024 (element gs i).block ((element gs i).offset+byte.val) := by
  right; right
  change 0+4*670+4*1024≤0+4*(3230+i)+byte.val
  omega

theorem f_transport (before after : Memory) (frame : Frame before after) (reads : Reads before fs) : Reads after fs := by
  intro i hi
  obtain ⟨word,read⟩ := reads i hi
  exact ⟨word,Gate00Memory.load32_transport before after _ _ read frame.size
    (fun byte => frame.bytes _ _ (f_outside i byte))⟩

theorem g_transport (before after : Memory) (frame : Frame before after) (reads : Reads before gs) : Reads after gs := by
  intro i hi
  obtain ⟨word,read⟩ := reads i hi
  exact ⟨word,Gate00Memory.load32_transport before after _ _ read frame.size
    (fun byte => frame.bytes _ _ (g_outside i byte))⟩

theorem f_write (heap : Memory) (j : Nat) (bound : j<512) (word : BitVec 32) :
    Frame heap (Word32Memory176.write heap (element fd j) word) :=
  NttWriteFrame182.write heap fd 1024 ⟨j,by omega⟩ word (by decide)

theorem gd_element (j : Nat) : element gd j=element fd (512+j) := by
  dsimp only [SelectedTopLayout177.gd,element]
  rw [Nat.add_assoc]

theorem g_write (heap : Memory) (j : Nat) (bound : j<512) (word : BitVec 32) :
    Frame heap (Word32Memory176.write heap (element gd j) word) := by
  rw [gd_element]
  exact NttWriteFrame182.write heap fd 1024 ⟨512+j,by omega⟩ word (by decide)

theorem relocate (heap : Memory) (base : ArrayPointer) (index : Nat) (bound : index<base.count)
    (allocated : Allocated heap base) : Allocated heap {base with index:=index} :=
  ⟨allocated.1,allocated.2.1,bound,allocated.2.2.2⟩

end FT1536.Source3.TopProductMemory186
