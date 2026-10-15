import Source3.FprBoundEvents135
import Source3.FprFastCalls137

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprTable138
open FprBoundEvents135 (Event lookup)
open C99ValueBridge (value)

def Valid (event : Event) : Prop := FprPrefixCalls.calls event.name (event.args.map value) (value event.out)

theorem sound (events : List Event) (valid : ∀ event∈events, Valid event) :
    C99ExpressionSound.CallsSound FprPrefixCalls.calls (lookup events) := by
  intro name args out computed
  induction events with
  | nil => cases computed
  | cons event rest ih =>
    by_cases same : event.name=name ∧ event.args=args
    · have equal : event.out=out := Option.some.inj (by simpa [lookup,same] using computed)
      subst out
      have source := valid event (by simp)
      simpa only [Valid,same.1,same.2] using source
    · have tail : lookup rest name args=some out := by simpa only [lookup,ite_eq_right same] using computed
      exact ih (fun e member => valid e (by simp [member])) tail

theorem checked (event : Event) (computed : FprFastCalls137.calls event.name event.args=some event.out) : Valid event :=
  FprFastCalls137.sound event.name event.args event.out computed

end FT1536.Source3.FprTable138
