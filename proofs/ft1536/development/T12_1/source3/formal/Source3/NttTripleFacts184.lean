import Source3.NttTripleStates184

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttTripleFacts184
open C99ArrayReference (State)
open NttTripleStates184

theorem heap (s : State) (z : Words) : (state11 s z).heap=s.heap := rfl

end FT1536.Source3.NttTripleFacts184
