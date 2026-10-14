import Source3.KeygenZintCall098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenMakeFgTop099
open C99ArrayReference (State)

theorem checked : KeygenLevelDeterminism097.checkedCode KeygenMakeFgTop.code = true := by decide +kernel

theorem call_unique (before a b : State) (args : List C99ArrayReference.Arg)
    (first : KeygenMakeFgTop.Call before args a) (second : KeygenMakeFgTop.Call before args b) : a = b := by
  cases first with
  | run entry1 out1 binding1 body1 returned1 =>
      cases second with
      | run entry2 out2 binding2 body2 returned2 =>
          have entries := C99ArrayDeterminism089.parameters before _ args entry1 entry2 binding1 binding2
          subst entry2
          have outcomes := KeygenLevelDeterminism097.execution _ entry1 out1 out2 checked body1 body2
          cases outcomes
          rfl

end FT1536.Source3.KeygenMakeFgTop099
