import Source3.KeygenIntermediateCombine102
import Source3.KeygenIntermediateReducePart0102
import Source3.KeygenIntermediateReducePart1102
import Source3.KeygenIntermediateReducePart2102
import Source3.KeygenIntermediateReducePart3102
import Source3.KeygenIntermediateReducePart4102
import Source3.KeygenIntermediateReducePart5102

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenIntermediateReduce102
open KeygenIntermediateReduceData
open KeygenIntermediateDeterminism102 (checkedCode)

theorem inner_checked : checkedCode inner = true :=
  KeygenIntermediateCombine102.six (part 0) (part 1) (part 2) (part 3) (part 4) (part 5)
    KeygenIntermediateReducePart0102.checked KeygenIntermediateReducePart1102.checked KeygenIntermediateReducePart2102.checked KeygenIntermediateReducePart3102.checked KeygenIntermediateReducePart4102.checked KeygenIntermediateReducePart5102.checked

theorem body_checked : checkedCode code = true :=
  KeygenIntermediateCombine102.reduce_shell inner inner_checked

theorem parsed (i : Fin 6) : KeygenIntermediateReduceData.parsed i = some (part i) := by
  fin_cases i
  · exact parsed_part 0 KeygenIntermediateReduceCheck0.checked
  · exact parsed_part 1 KeygenIntermediateReduceCheck1.checked
  · exact parsed_part 2 KeygenIntermediateReduceCheck2.checked
  · exact parsed_part 3 KeygenIntermediateReduceCheck3.checked
  · exact parsed_part 4 KeygenIntermediateReduceCheck4.checked
  · exact parsed_part 5 KeygenIntermediateReduceCheck5.checked

end FT1536.Source3.KeygenIntermediateReduce102
