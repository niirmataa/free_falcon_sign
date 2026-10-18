import Source3.Gen0RowFixed189

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.Gen0RowControl189
open C99ArrayReference (State)
open KeygenNttLoopSupport (USlot)

theorem guard (s : State) (u : Nat) (bound : u<2^64) (counter : USlot s "u" u) (base : USlot s "b" 256) :
    C99ArrayReference.scalar s GeneratorRowControl179.condition (C99ScalarReference.boolean (decide (u<256))) :=
  C99LoopScalar141.less s _ _ u 256 bound (by decide) (.variable _ _ _ counter) (.variable _ _ _ base)

end FT1536.Source3.Gen0RowControl189
