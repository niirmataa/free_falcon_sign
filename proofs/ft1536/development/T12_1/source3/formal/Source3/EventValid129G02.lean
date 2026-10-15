import Source3.ProcessSource129G02

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.EventValid129G02
open C99CompactState115 (reference)
open ProcessSite129G02 (ctx event pointer)

theorem changed_block : C99FiniteMap114.lookup ProcessSource129G02.after.heap.blocks pointer.block=
    C99FiniteMap114.lookup event.after.heap.blocks pointer.block := by decide +kernel

theorem valid : ShakeProcessEvents128.Valid ctx event := by
  have source := ProcessSource129G02.source_process
  have block := changed_block
  change ShakeExtractSource.Process (reference NormalizedProcessSite129G02.caller) pointer (reference ProcessSource129G02.after) at source
  rw [NormalizedProcessSite129G02.caller_same] at source
  rw [← ProcessSite129G02.event_pointer] at source block
  exact ShakeEventFrame128.valid ctx event ProcessSource129G02.after source block

theorem obligations : GeneratedSampler129G02.Obligations := ProcessSite129G02.obligations valid

/-- All recorded events are now proved from the original source. -/
theorem closed : KeygenSamplerPrefix128.Prefix ctx 64
    (reference GeneratedSampler129G02.before)
    (reference GeneratedSampler129G02.after) :=
  GeneratedSampler129G02.normalized obligations

end FT1536.Source3.EventValid129G02
