import Source3.FftShape138
import Source3.FprFastCalls137
import Source3.C99ProcedureSegments138

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftFirstChecks138

theorem pointer_after (before : C99CompactState115.State) (name : C99ArrayReference.Name)
    (pointer : C99MemoryReference.ArrayPointer) (data : C99FiniteMemory114.Block)
    (locals : C99CompactCells115.Locals)
    (binding : (C99CompactState115.reference before).arrays name=some pointer) :
    (C99CompactState115.reference (C99ProcedureNormalize138.normalize before pointer.block data locals)).arrays name=some pointer := binding

end FT1536.Source3.FftFirstChecks138
