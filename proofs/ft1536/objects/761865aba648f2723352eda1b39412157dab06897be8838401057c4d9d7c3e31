import Source3.KeygenIntermediateLift
import Source3.KeygenIntermediateReduceCheck0
import Source3.KeygenIntermediateReduceCheck1
import Source3.KeygenIntermediateReduceCheck2
import Source3.KeygenIntermediateReduceCheck3
import Source3.KeygenIntermediateReduceCheck4
import Source3.KeygenIntermediateReduceCheck5

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenIntermediateReduce
open KeygenIntermediateExec (only)
open KeygenIntermediateReduceData (part inner part_checked)
open KeygenIntermediateLiftData (only_seq)
def writable := KeygenIntermediateReduceData.writable
def code := KeygenIntermediateReduceData.code
theorem inner_checked : only writable inner=true := by
  show only writable (.seq (part 0) (.seq (part 1) (.seq (part 2) (.seq (part 3) (.seq (part 4) (.seq (part 5) .skip))))))=true
  unfold writable
  rw [only_seq,only_seq,only_seq,only_seq,only_seq,only_seq,
    part_checked 0 KeygenIntermediateReduceCheck0.checked,part_checked 1 KeygenIntermediateReduceCheck1.checked,
    part_checked 2 KeygenIntermediateReduceCheck2.checked,part_checked 3 KeygenIntermediateReduceCheck3.checked,
    part_checked 4 KeygenIntermediateReduceCheck4.checked,part_checked 5 KeygenIntermediateReduceCheck5.checked]
  rfl
theorem code_checked : only writable code=true := by
  change (true && (only writable inner && true))=true
  rw [inner_checked]
  rfl
theorem inner_covered : KeygenIntermediateCoverage.statement inner=true := by
  show KeygenIntermediateCoverage.statement (.seq (part 0) (.seq (part 1) (.seq (part 2)
    (.seq (part 3) (.seq (part 4) (.seq (part 5) .skip))))))=true
  rw [KeygenIntermediateCoverage.sequence,KeygenIntermediateCoverage.sequence,KeygenIntermediateCoverage.sequence,
    KeygenIntermediateCoverage.sequence,KeygenIntermediateCoverage.sequence,KeygenIntermediateCoverage.sequence,
    KeygenIntermediateReduceData.part_covered 0 KeygenIntermediateReduceCheck0.checked,
    KeygenIntermediateReduceData.part_covered 1 KeygenIntermediateReduceCheck1.checked,
    KeygenIntermediateReduceData.part_covered 2 KeygenIntermediateReduceCheck2.checked,
    KeygenIntermediateReduceData.part_covered 3 KeygenIntermediateReduceCheck3.checked,
    KeygenIntermediateReduceData.part_covered 4 KeygenIntermediateReduceCheck4.checked,
    KeygenIntermediateReduceData.part_covered 5 KeygenIntermediateReduceCheck5.checked]
  rfl
theorem code_covered : KeygenIntermediateCoverage.statement code=true := by
  change (true && (true && KeygenIntermediateCoverage.statement inner && true))=true
  rw [inner_covered]
  rfl
end FT1536.Source3.KeygenIntermediateReduce
