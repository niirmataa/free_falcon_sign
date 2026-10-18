import Source3.NttMiddleAddress183

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttMiddleTable183
open C99MemoryReference (Memory ArrayPointer Load32)
open KeygenSmallOutput (element)

def Reads (heap : Memory) (gm : ArrayPointer) : Prop :=
  ∀ i<1024, ∃ w, Load32 heap (element gm i) w

def Separate (a gm : ArrayPointer) : Prop :=
  ∀ i<1024, ∀ byte : Fin 4, NttWriteFrame182.Outside a 1536 (element gm i).block ((element gm i).offset+byte.val)

theorem transport (before after : Memory) (a gm : ArrayPointer) (sep : Separate a gm)
    (frame : NttWriteFrame182.Frame a 1536 before after) (reads : Reads before gm) : Reads after gm := by
  intro i hi
  obtain ⟨w,read⟩ := reads i hi
  exact ⟨w,Gate00Memory.load32_transport before after _ _ read frame.size
    (fun byte => frame.bytes _ _ (sep i hi byte))⟩

end FT1536.Source3.NttMiddleTable183
