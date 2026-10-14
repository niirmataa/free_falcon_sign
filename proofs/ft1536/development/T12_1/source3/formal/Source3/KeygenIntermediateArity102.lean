import Source3.KeygenIntermediateLift102
import Source3.KeygenIntermediateReduce102
import Source3.KeygenIntermediateTopPart0102
import Source3.KeygenIntermediateTopPart1102
import Source3.KeygenIntermediateTopPart2102
import Source3.KeygenIntermediateTopPart3102
import Source3.KeygenIntermediateTopPart4102
import Source3.KeygenIntermediateTopPart6102
import Source3.KeygenIntermediateTopPart7102
import Source3.KeygenIntermediateTopPart9102

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenIntermediateArity102
open KeygenIntermediateSource
open KeygenIntermediateDeterminism102 (checkedCode)

theorem body_checked : checkedCode code = true :=
  KeygenIntermediateCombine102.ten (part 0) (part 1) (part 2) (part 3) (part 4) (part 5) (part 6) (part 7) (part 8) (part 9)
    KeygenIntermediateTopPart0102.checked
    KeygenIntermediateTopPart1102.checked
    KeygenIntermediateTopPart2102.checked
    KeygenIntermediateTopPart3102.checked
    KeygenIntermediateTopPart4102.checked
    KeygenIntermediateLift102.body_checked
    KeygenIntermediateTopPart6102.checked
    KeygenIntermediateTopPart7102.checked
    KeygenIntermediateReduce102.body_checked
    KeygenIntermediateTopPart9102.checked

theorem parsed (i : Fin 10) : KeygenIntermediateSource.parsed i = some (part i) := by
  fin_cases i
  · exact parsed_part 0 audit0
  · exact parsed_part 1 audit1
  · exact parsed_part 2 audit2
  · exact parsed_part 3 audit3
  · exact parsed_part 4 audit4
  · exact parsed_part 5 audit5
  · exact parsed_part 6 audit6
  · exact parsed_part 7 audit7
  · exact parsed_part 8 audit8
  · exact parsed_part 9 audit9

end FT1536.Source3.KeygenIntermediateArity102
