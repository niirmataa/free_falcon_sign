import Source3.ProcessSource129G15

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.EventValid129G15
open C99CompactState115 (reference)
open ProcessSite129G15 (ctx event pointer)

theorem changed_block : C99FiniteMap114.lookup ProcessSource129G15.after.heap.blocks pointer.block=
    C99FiniteMap114.lookup event.after.heap.blocks pointer.block := by decide +kernel

theorem valid : ShakeProcessEvents128.Valid ctx event := by
  have source := ProcessSource129G15.source_process
  have block := changed_block
  change ShakeExtractSource.Process (reference NormalizedProcessSite129G15.caller) pointer (reference ProcessSource129G15.after) at source
  rw [NormalizedProcessSite129G15.caller_same] at source
  rw [← ProcessSite129G15.event_pointer] at source block
  exact ShakeEventFrame128.valid ctx event ProcessSource129G15.after source block

theorem obligations : GeneratedSampler129G15.Obligations := ProcessSite129G15.obligations valid

/-- All recorded events are now proved from the original source. -/
theorem closed : KeygenSamplerPrefix128.Prefix ctx 64
    (reference GeneratedSampler129G15.before)
    (reference GeneratedSampler129G15.after) :=
  GeneratedSampler129G15.normalized obligations

end FT1536.Source3.EventValid129G15
