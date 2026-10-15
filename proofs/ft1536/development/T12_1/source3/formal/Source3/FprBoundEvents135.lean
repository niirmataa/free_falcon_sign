import Source3.KeygenBoundSound135

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprBoundEvents135
open B20.C (Val Name)
open C99ValueBridge (value)

structure Event where
  name : Name
  args : List Val
  out : Val
  deriving Repr, DecidableEq

def Valid (event : Event) : Prop :=
  FprScalarClosure132.calls event.name (event.args.map value) (value event.out)

def lookup : List Event → B20.C.Scalar.Calls
  | [], _, _ => none
  | event::rest, name, args =>
      if event.name=name ∧ event.args=args then some event.out else lookup rest name args

theorem sound (events : List Event) (valid : ∀ event∈events, Valid event) :
    C99ExpressionSound.CallsSound FprScalarClosure132.calls (lookup events) := by
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

theorem checked (event : Event)
    (computed : KeygenBoundModel135.calls event.name event.args=some event.out) : Valid event :=
  KeygenBoundSound135.calls_sound event.name event.args event.out computed

end FT1536.Source3.FprBoundEvents135
