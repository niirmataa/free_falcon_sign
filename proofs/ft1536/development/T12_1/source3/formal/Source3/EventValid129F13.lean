import Source3.ProcessSource129F13

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.EventValid129F13
open C99CompactState115 (reference)
open ProcessSite129F13 (ctx event pointer)

theorem changed_block : C99FiniteMap114.lookup ProcessSource129F13.after.heap.blocks pointer.block=
    C99FiniteMap114.lookup event.after.heap.blocks pointer.block := by decide +kernel

theorem valid : ShakeProcessEvents128.Valid ctx event := by
  have source := ProcessSource129F13.source_process
  have block := changed_block
  change ShakeExtractSource.Process (reference NormalizedProcessSite129F13.caller) pointer (reference ProcessSource129F13.after) at source
  rw [NormalizedProcessSite129F13.caller_same] at source
  rw [← ProcessSite129F13.event_pointer] at source block
  exact ShakeEventFrame128.valid ctx event ProcessSource129F13.after source block

theorem obligations : GeneratedSampler129F13.Obligations := ProcessSite129F13.obligations valid

/-- All recorded events are now proved from the original source. -/
theorem closed : KeygenSamplerPrefix128.Prefix ctx 64
    (reference GeneratedSampler129F13.before)
    (reference GeneratedSampler129F13.after) :=
  GeneratedSampler129F13.normalized obligations

end FT1536.Source3.EventValid129F13
