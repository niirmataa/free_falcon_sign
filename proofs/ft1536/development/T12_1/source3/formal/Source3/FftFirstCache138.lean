import Source3.GeneratedFft138FirstCalls
import Source3.FprCached138

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftFirstCache138

def calls := FprCached138.calls GeneratedFft138FirstCalls.events

theorem sound : C99ExpressionSound.CallsSound FprPrefixCalls.calls calls :=
  FprCached138.sound GeneratedFft138FirstCalls.events GeneratedFft138FirstCalls.valid

end FT1536.Source3.FftFirstCache138
