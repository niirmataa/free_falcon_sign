import Source3.FirstProcess128

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FirstEventValid128
open C99CompactState115 (reference)
open FirstProcessSite128 (ctx event pointer)

theorem changed_block : C99FiniteMap114.lookup FirstProcess128.after.heap.blocks pointer.block=
    C99FiniteMap114.lookup event.after.heap.blocks pointer.block := by decide +kernel

theorem valid : ShakeProcessEvents128.Valid ctx event := by
  have source := FirstProcess128.source_process
  have block := changed_block
  change ShakeExtractSource.Process (reference event.before) pointer (reference FirstProcess128.after) at source
  rw [← FirstProcessSite128.event_pointer] at source block
  exact ShakeEventFrame128.valid ctx event FirstProcess128.after source block

theorem obligations : SelectedFirst128.Obligations := FirstProcessSite128.obligations valid

/-- Unconditional original source prefix for the first coefficient on the
    fixed full127 input. The logged SHAKE obligation is fully discharged. -/
theorem first_coefficient : KeygenSamplerPrefix128.Prefix ctx 1
    (reference SelectedFullSampler128.initial) (reference SelectedFirst128.output.1) :=
  SelectedFirst128.source obligations

end FT1536.Source3.FirstEventValid128
