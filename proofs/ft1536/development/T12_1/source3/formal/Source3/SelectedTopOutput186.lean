import Source3.SelectedTopCall186

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedTopOutput186
open C99MemoryReference (Load32)
open KeygenSmallOutput (element)
open SelectedTopLayout177 (fd gd fs gs gm)
open SelectedTopCall186 (before after)

theorem entry_heap : SelectedMakeFgTopEntry176.entry.heap=before.heap :=
  C99ArrayReference.bind_heap before KeygenMakeFgTop.params SelectedMakeFgTopEntry176.arguments
    SelectedMakeFgTopEntry176.entry SelectedMakeFgTopEntry176.binding

theorem initialization : C99InitializationTrace.Preserves before.heap after.heap := by
  have result := SelectedTopProducts186.initialization
  rw [entry_heap] at result
  exact result

theorem fd_read (j : Nat) (bound : j<512) : ∃ word, Load32 after.heap (element fd j) word := by
  obtain ⟨old,read⟩ := SelectedMakeFgTopEntry176.initialized j (by omega)
  have initialized := NttReadFacts182.initialized _ _ _ read
  exact Word32Initialized180.load after.heap (element fd j) (SelectedTopProducts186.fixed.fdAllocated j bound) rfl
    (Word32Initialized180.transported _ _ _ SelectedTopProducts186.initialization initialized)

theorem gd_read (j : Nat) (bound : j<512) : ∃ word, Load32 after.heap (element gd j) word := by
  obtain ⟨old,read⟩ := SelectedMakeFgTopEntry176.initialized (512+j) (by omega)
  have initialized : Word32Initialized180.At SelectedMakeFgTopEntry176.entry.heap (element gd j) := by
    rw [TopProductMemory186.gd_element]
    exact NttReadFacts182.initialized _ _ _ read
  exact Word32Initialized180.load after.heap (element gd j) (SelectedTopProducts186.fixed.gdAllocated j bound) rfl
    (Word32Initialized180.transported _ _ _ SelectedTopProducts186.initialization initialized)

theorem f_readable (j : Nat) (bound : j<1536) : ∃ word, Load32 after.heap (element fs j) word := SelectedTopProducts186.fixed.fReads j bound
theorem g_readable (j : Nat) (bound : j<1536) : ∃ word, Load32 after.heap (element gs j) word := SelectedTopProducts186.fixed.gReads j bound

theorem gm_table : KeygenMkgm3Table.Initialized after.heap gm := by
  intro i bound
  obtain ⟨word,read,law⟩ := SelectedSecondFrame185.gm_table i bound
  refine ⟨word,?_,law⟩
  apply Gate00Memory.load32_transport SelectedSecondCall185.after.heap after.heap _ _ read SelectedTopProducts186.frame.size
  intro byte
  apply SelectedTopProducts186.frame.bytes
  right; right
  change 0+4*670+4*1024≤0+4*(4766+i)+byte.val
  omega

theorem bytes (block offset : Nat) (outside : block≠31 ∨ offset<2680) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  have products := SelectedTopProducts186.frame.bytes block offset (by
    change block≠31 ∨ offset<2680 ∨ 6776≤offset
    omega)
  have forwards := SelectedSecondFrame185.paired_bytes block offset (by omega)
  have generator := SelectedGeneratorFrame181.bytes block offset (by omega)
  have move := SelectedTopMove177.outside block offset (by omega)
  calc
    after.heap.bytes block offset=SelectedSecondCall185.after.heap.bytes block offset := products
    _=SelectedForwardCall184.before.heap.bytes block offset := forwards
    _=SelectedGeneratorCall181.before.heap.bytes block offset := generator
    _=SelectedTopMove177.after.heap.bytes block offset := by
      rw [SelectedGeneratorCall181.before,SelectedTopInit178.heap]
      rfl
    _=SelectedTopMove177.before.heap.bytes block offset := move
    _=before.heap.bytes block offset := by
      rw [SelectedTopMove177.before,SelectedTopLayout177.heap,entry_heap]

theorem sizes : after.heap.size=before.heap.size := initialization.size
theorem writable : after.heap.writable=before.heap.writable := initialization.writable

end FT1536.Source3.SelectedTopOutput186
