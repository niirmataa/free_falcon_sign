import Source3.ShakeExtractRun120

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeProcessEvents128
open C99CompactState115 (State reference)

/-- An untrusted proposed call records its exact states. These data are
    not a source execution until Valid is proved for this entire event. -/
structure Event where
  before : State
  name : C99ArrayReference.Name
  after : State

abbrev Proposal := State → C99ArrayReference.Name → Option State
abbrev Result := State × List Event

def Valid (ctx : ShakeExtractSource.Layout) (event : Event) : Prop :=
  ShakeExtractSource.Exec ctx (.process event.name) (reference event.before) (reference event.after)

def All (ctx : ShakeExtractSource.Layout) (events : List Event) : Prop := ∀ event∈events, Valid ctx event

theorem left (ctx : ShakeExtractSource.Layout) (first second : List Event) (checked : All ctx (first++second)) : All ctx first :=
  fun event member => checked event (List.mem_append_left second member)

theorem right (ctx : ShakeExtractSource.Layout) (first second : List Event) (checked : All ctx (first++second)) : All ctx second :=
  fun event member => checked event (List.mem_append_right first member)

theorem singleton (ctx : ShakeExtractSource.Layout) (event : Event) (checked : All ctx [event]) : Valid ctx event :=
  checked event (List.mem_cons_self)

end FT1536.Source3.ShakeProcessEvents128
