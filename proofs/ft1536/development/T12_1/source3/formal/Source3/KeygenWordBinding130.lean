import Source3.KeygenWordNormalize130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenWordBinding130
open C99CompactState115 (State reference)

theorem pointer_after (before : State) (name : C99ArrayReference.Name)
    (pointer : C99MemoryReference.ArrayPointer) (data : C99FiniteMemory114.Block)
    (locals : C99CompactCells115.Locals)
    (binding : (reference before).arrays name=some pointer) :
    (reference (KeygenWordNormalize130.normalize before pointer.block data locals)).arrays name=some pointer := binding

end FT1536.Source3.KeygenWordBinding130
