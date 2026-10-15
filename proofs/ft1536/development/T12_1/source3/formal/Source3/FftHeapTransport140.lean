import Source3.FftPairStates140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftHeapTransport140
open C99ArrayReference (State Name Pointer)
open C99MemoryReference (Memory ArrayPointer)

theorem pointer (before : State) (heap : Memory) (name : Name) (index : CLogic.Expr) (p : ArrayPointer)
    (source : Pointer before name index p) : Pointer {before with heap := heap} name index p := by
  apply FftPointerTransport140.source before {before with heap := heap} name index p source rfl
  intro _ _
  rfl

theorem pair_entry (before : State) (heap : Memory) (x : FftMulStates140.Words)
    (entry : FftPairStates140.Entry before x) : FftPairStates140.Entry {before with heap := heap} x :=
  ⟨entry.ar,entry.ai,entry.br,entry.bi⟩

end FT1536.Source3.FftHeapTransport140
