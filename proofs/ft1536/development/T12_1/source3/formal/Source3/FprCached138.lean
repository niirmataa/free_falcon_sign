import Source3.FprTable138

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprCached138

def calls (events : List FprBoundEvents135.Event) (name : B20.C.Name) (args : List B20.C.Val) : Option B20.C.Val :=
  match FprBoundEvents135.lookup events name args with
  | some out => some out
  | none => FprFastCalls137.calls name args

theorem sound (events : List FprBoundEvents135.Event) (valid : ∀ event∈events, FprTable138.Valid event) :
    C99ExpressionSound.CallsSound FprPrefixCalls.calls (calls events) := by
  intro name args out computed
  cases found : FprBoundEvents135.lookup events name args with
  | none => exact FprFastCalls137.sound name args out (by simpa only [calls,found] using computed)
  | some word =>
    have same : word=out := Option.some.inj (by simpa only [calls,found] using computed)
    subst out
    exact FprTable138.sound events valid name args word found

end FT1536.Source3.FprCached138
