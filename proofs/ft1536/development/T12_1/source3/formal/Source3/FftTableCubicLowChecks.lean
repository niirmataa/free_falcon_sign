import Source3.FftTableChecks00

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FftTableCubicLowChecks
open FftTableParser

theorem row02 : CheckedChunk .cubic 2 := by decide
theorem row03 : CheckedChunk .cubic 3 := by decide
theorem row04 : CheckedChunk .cubic 4 := by decide
theorem row05 : CheckedChunk .cubic 5 := by decide
theorem row06 : CheckedChunk .cubic 6 := by decide
theorem row07 : CheckedChunk .cubic 7 := by decide
theorem row08 : CheckedChunk .cubic 8 := by decide
theorem row09 : CheckedChunk .cubic 9 := by decide
theorem row10 : CheckedChunk .cubic 10 := by decide
theorem row11 : CheckedChunk .cubic 11 := by decide
theorem row12 : CheckedChunk .cubic 12 := by decide
theorem row13 : CheckedChunk .cubic 13 := by decide
theorem row14 : CheckedChunk .cubic 14 := by decide
theorem row15 : CheckedChunk .cubic 15 := by decide
theorem row16 : CheckedChunk .cubic 16 := by decide
theorem row17 : CheckedChunk .cubic 17 := by decide
theorem row18 : CheckedChunk .cubic 18 := by decide
theorem row19 : CheckedChunk .cubic 19 := by decide
theorem row20 : CheckedChunk .cubic 20 := by decide
theorem row21 : CheckedChunk .cubic 21 := by decide
theorem row22 : CheckedChunk .cubic 22 := by decide
theorem row23 : CheckedChunk .cubic 23 := by decide
theorem row24 : CheckedChunk .cubic 24 := by decide
theorem row25 : CheckedChunk .cubic 25 := by decide
theorem row26 : CheckedChunk .cubic 26 := by decide
theorem row27 : CheckedChunk .cubic 27 := by decide
theorem row28 : CheckedChunk .cubic 28 := by decide
theorem row29 : CheckedChunk .cubic 29 := by decide
theorem row30 : CheckedChunk .cubic 30 := by decide
theorem row31 : CheckedChunk .cubic 31 := by decide

theorem all_chunks (index : Fin 32) : CheckedChunk .cubic index.val := by
  fin_cases index
  · exact FftTableChecks00.cubic00
  · exact FftTableChecks00.cubic01
  · exact row02
  · exact row03
  · exact row04
  · exact row05
  · exact row06
  · exact row07
  · exact row08
  · exact row09
  · exact row10
  · exact row11
  · exact row12
  · exact row13
  · exact row14
  · exact row15
  · exact row16
  · exact row17
  · exact row18
  · exact row19
  · exact row20
  · exact row21
  · exact row22
  · exact row23
  · exact row24
  · exact row25
  · exact row26
  · exact row27
  · exact row28
  · exact row29
  · exact row30
  · exact row31

end FT1536.Source3.FftTableCubicLowChecks
