import Source3.KeygenIntermediateLiftCheck0
import Source3.KeygenIntermediateLiftCheck1
import Source3.KeygenIntermediateLiftCheck2
import Source3.KeygenIntermediateLiftCheck3
import Source3.KeygenIntermediateLiftCheck4
import Source3.KeygenIntermediateLiftCheck5

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenIntermediateLift
open KeygenIntermediateExec (only)
open KeygenIntermediateLiftData (part inner part_checked only_seq)
def writable := KeygenIntermediateLiftData.writable
def code := KeygenIntermediateLiftData.code
theorem inner_checked : only writable inner=true := by
  show only writable (.seq (part 0) (.seq (part 1) (.seq (part 2) (.seq (part 3) (.seq (part 4) (.seq (part 5) .skip))))))=true
  unfold writable
  rw [only_seq,only_seq,only_seq,only_seq,only_seq,only_seq,
    part_checked 0 KeygenIntermediateLiftCheck0.checked,part_checked 1 KeygenIntermediateLiftCheck1.checked,
    part_checked 2 KeygenIntermediateLiftCheck2.checked,part_checked 3 KeygenIntermediateLiftCheck3.checked,
    part_checked 4 KeygenIntermediateLiftCheck4.checked,part_checked 5 KeygenIntermediateLiftCheck5.checked]
  rfl
theorem code_checked : only writable code=true := by
  change (true && (only writable inner && true))=true
  rw [inner_checked]
  rfl
theorem inner_covered : KeygenIntermediateCoverage.statement inner=true := by
  open KeygenIntermediateCoverage in
    show statement (.seq (part 0) (.seq (part 1) (.seq (part 2) (.seq (part 3) (.seq (part 4) (.seq (part 5) .skip))))))=true
  rw [KeygenIntermediateCoverage.sequence,KeygenIntermediateCoverage.sequence,KeygenIntermediateCoverage.sequence,
    KeygenIntermediateCoverage.sequence,KeygenIntermediateCoverage.sequence,KeygenIntermediateCoverage.sequence,
    KeygenIntermediateLiftData.part_covered 0 KeygenIntermediateLiftCheck0.checked,
    KeygenIntermediateLiftData.part_covered 1 KeygenIntermediateLiftCheck1.checked,
    KeygenIntermediateLiftData.part_covered 2 KeygenIntermediateLiftCheck2.checked,
    KeygenIntermediateLiftData.part_covered 3 KeygenIntermediateLiftCheck3.checked,
    KeygenIntermediateLiftData.part_covered 4 KeygenIntermediateLiftCheck4.checked,
    KeygenIntermediateLiftData.part_covered 5 KeygenIntermediateLiftCheck5.checked]
  rfl
theorem code_covered : KeygenIntermediateCoverage.statement code=true := by
  change (true && (true && KeygenIntermediateCoverage.statement inner && true))=true
  rw [inner_covered]
  rfl
end FT1536.Source3.KeygenIntermediateLift
