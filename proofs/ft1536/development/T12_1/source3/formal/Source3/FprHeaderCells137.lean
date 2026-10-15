import Source3.FprHeaderEval137

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprHeaderCells137

theorem u64 (word : BitVec 64) : C99CompactCells115.Cell.converted .u64 (.u64 word)=.u64 (some word) := by
  have same := C99CountedWords.convert_self (C99IntegerReference.Value.uint64 word)
  have bits := C99IntegerReference.Value.uint64.inj same
  exact congrArg (fun result => C99CompactCells115.Cell.u64 (some result)) bits

theorem u32 (word : BitVec 32) : C99CompactCells115.Cell.converted .u32 (.u32 word)=.u32 (some word) := by
  have same := C99CountedWords.convert_self (C99IntegerReference.Value.uint32 word)
  have bits := C99IntegerReference.Value.uint32.inj same
  exact congrArg (fun result => C99CompactCells115.Cell.u32 (some result)) bits

end FT1536.Source3.FprHeaderCells137
