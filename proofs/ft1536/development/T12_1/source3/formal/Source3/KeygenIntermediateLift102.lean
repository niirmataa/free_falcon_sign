import Source3.KeygenIntermediateCombine102
import Source3.KeygenIntermediateLiftPart0102
import Source3.KeygenIntermediateLiftPart1102
import Source3.KeygenIntermediateLiftPart2102
import Source3.KeygenIntermediateLiftPart3102
import Source3.KeygenIntermediateLiftPart4102
import Source3.KeygenIntermediateLiftPart5102

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenIntermediateLift102
open KeygenIntermediateLiftData
open KeygenIntermediateDeterminism102 (checkedCode)

theorem inner_checked : checkedCode inner = true :=
  KeygenIntermediateCombine102.six (part 0) (part 1) (part 2) (part 3) (part 4) (part 5)
    KeygenIntermediateLiftPart0102.checked KeygenIntermediateLiftPart1102.checked KeygenIntermediateLiftPart2102.checked KeygenIntermediateLiftPart3102.checked KeygenIntermediateLiftPart4102.checked KeygenIntermediateLiftPart5102.checked

theorem body_checked : checkedCode code = true :=
  KeygenIntermediateCombine102.lift_shell inner inner_checked

theorem parsed (i : Fin 6) : KeygenIntermediateLiftData.parsed i = some (part i) := by
  fin_cases i
  · exact parsed_part 0 KeygenIntermediateLiftCheck0.checked
  · exact parsed_part 1 KeygenIntermediateLiftCheck1.checked
  · exact parsed_part 2 KeygenIntermediateLiftCheck2.checked
  · exact parsed_part 3 KeygenIntermediateLiftCheck3.checked
  · exact parsed_part 4 KeygenIntermediateLiftCheck4.checked
  · exact parsed_part 5 KeygenIntermediateLiftCheck5.checked

end FT1536.Source3.KeygenIntermediateLift102
