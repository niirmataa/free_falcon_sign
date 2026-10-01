import Source3.FftTableChecks00

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FftTableCubicHighChecks
open FftTableParser

theorem row32 : CheckedChunk .cubic 32 := by decide
theorem row33 : CheckedChunk .cubic 33 := by decide
theorem row34 : CheckedChunk .cubic 34 := by decide
theorem row35 : CheckedChunk .cubic 35 := by decide
theorem row36 : CheckedChunk .cubic 36 := by decide
theorem row37 : CheckedChunk .cubic 37 := by decide
theorem row38 : CheckedChunk .cubic 38 := by decide
theorem row39 : CheckedChunk .cubic 39 := by decide
theorem row40 : CheckedChunk .cubic 40 := by decide
theorem row41 : CheckedChunk .cubic 41 := by decide
theorem row42 : CheckedChunk .cubic 42 := by decide
theorem row43 : CheckedChunk .cubic 43 := by decide
theorem row44 : CheckedChunk .cubic 44 := by decide
theorem row45 : CheckedChunk .cubic 45 := by decide
theorem row46 : CheckedChunk .cubic 46 := by decide
theorem row47 : CheckedChunk .cubic 47 := by decide
theorem row48 : CheckedChunk .cubic 48 := by decide
theorem row49 : CheckedChunk .cubic 49 := by decide
theorem row50 : CheckedChunk .cubic 50 := by decide
theorem row51 : CheckedChunk .cubic 51 := by decide
theorem row52 : CheckedChunk .cubic 52 := by decide
theorem row53 : CheckedChunk .cubic 53 := by decide
theorem row54 : CheckedChunk .cubic 54 := by decide
theorem row55 : CheckedChunk .cubic 55 := by decide
theorem row56 : CheckedChunk .cubic 56 := by decide
theorem row57 : CheckedChunk .cubic 57 := by decide
theorem row58 : CheckedChunk .cubic 58 := by decide
theorem row59 : CheckedChunk .cubic 59 := by decide
theorem row60 : CheckedChunk .cubic 60 := by decide
theorem row61 : CheckedChunk .cubic 61 := by decide
theorem row62 : CheckedChunk .cubic 62 := by decide
theorem row63 : CheckedChunk .cubic 63 := by decide

theorem all_chunks (index : Fin 32) : CheckedChunk .cubic (index.val+32) := by
  fin_cases index
  · exact row32
  · exact row33
  · exact row34
  · exact row35
  · exact row36
  · exact row37
  · exact row38
  · exact row39
  · exact row40
  · exact row41
  · exact row42
  · exact row43
  · exact row44
  · exact row45
  · exact row46
  · exact row47
  · exact row48
  · exact row49
  · exact row50
  · exact row51
  · exact row52
  · exact row53
  · exact row54
  · exact row55
  · exact row56
  · exact row57
  · exact row58
  · exact row59
  · exact row60
  · exact row61
  · exact row62
  · exact row63

end FT1536.Source3.FftTableCubicHighChecks
