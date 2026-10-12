import BufferField020D

namespace FT1536.S05.BufferTransport020D
open WordRAM020 Residue020D BufferField020D

theorem holds_congr (s : State) (v w : Coeffs) (hv : Holds s v) (he : ∀ r,v r=w r) : Holds s w :=
  fun r => (hv r).trans (congrArg fw (he r))

end FT1536.S05.BufferTransport020D
