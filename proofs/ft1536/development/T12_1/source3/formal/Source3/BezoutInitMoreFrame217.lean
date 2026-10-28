import Source3.BezoutInitMore217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutInitMoreFrame217
open C99ArrayReference (State)
open DeepestSelectedCrt217 (tmp)
open BezoutPointerSetup217 (v1)

theorem u1_binding (s : State) : (BezoutPointerSetup217.after s).arrays "u1".toList=some tmp := rfl
theorem v1_binding (s : State) : (BezoutPointerSetup217.after s).arrays "v1".toList=some v1 := rfl
theorem zero_size (s : State) (nx ny : Nat) : (BezoutInitZero217.after s nx ny).heap.size=s.heap.size := rfl
theorem zero_writable (s : State) (nx ny : Nat) : (BezoutInitZero217.after s nx ny).heap.writable=s.heap.writable := rfl

end FT1536.Source3.BezoutInitMoreFrame217
