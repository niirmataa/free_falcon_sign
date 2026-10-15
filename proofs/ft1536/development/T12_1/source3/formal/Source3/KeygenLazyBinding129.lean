import Source3.KeygenLazySampler129

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLazyBinding129
open C99CompactState115 (State reference)

/-- Explicit projection transfer avoids unfolding an arbitrarily long
    chain of concrete state definitions during elaboration. -/
theorem pointer_after (ctx : ShakeExtractSource.Layout) (dst : C99MemoryReference.ArrayPointer)
    (before : State) (context coefficients : C99FiniteMemory114.Block)
    (locals : C99CompactCells115.Locals)
    (binding : (reference before).arrays "v".toList=some dst) :
    (reference (KeygenLazySampler129.normalize ctx dst before context coefficients locals)).arrays "v".toList=some dst :=
  binding

end FT1536.Source3.KeygenLazyBinding129
