import Source3.FftTableParser

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FftTableChecks00
open FftTableParser

theorem square00 : CheckedChunk .square 0 := by decide
theorem square01 : CheckedChunk .square 1 := by decide
theorem cubic00 : CheckedChunk .cubic 0 := by decide
theorem cubic01 : CheckedChunk .cubic 1 := by decide

end FT1536.Source3.FftTableChecks00
