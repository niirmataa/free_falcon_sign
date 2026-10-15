import Source3.KeygenPrefixCompose128
import Source3.KeygenSamplerInvoke121

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSamplerComplete129
open C99CompactState115 (State reference)

/-- Completion needs the original final guard, in addition to all source
    prefix steps. Return restores the actual caller slots, retaining memory. -/
theorem call (ctx : ShakeExtractSource.Layout) (count : Nat)
    (before bound declared initial after : State) (args : List C99ArrayReference.Arg)
    (binding : C99ArrayReference.Bind (reference before) KeygenSamplerCalls.params args (reference bound))
    (prologue : C99ModularReference.Exec KeygenSamplerSource.prologue (reference bound) ⟨reference declared,.normal⟩)
    (initialization : C99ModularReference.Exec KeygenSamplerSource.initial (reference declared) ⟨reference initial,.normal⟩)
    (steps : KeygenSamplerPrefix128.Prefix ctx count (reference initial) (reference after))
    (ending : KeygenSamplerSource.Outer ctx (reference after) (reference after)) :
    KeygenSamplerCalls.Call ctx (reference before) args (reference {before with heap := after.heap}) := by
  rw [C99CompactState115.reference_heap before after.heap]
  exact .run (reference bound) (reference after) binding
    (.run (reference declared) (reference initial) (reference after) prologue initialization
      (KeygenSamplerPrefix128.finish ctx count (reference initial) (reference after) (reference after) steps ending))

end FT1536.Source3.KeygenSamplerComplete129
