import Source3.ModularWordOps182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttSize182
open C99ArrayReference (State)
open C99IntegerReference (Value)

theorem source (s : State)
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10)))
    (ternary : s.locals "full".toList=some (.uint32,some (.uint32 1))) :
    C99ArrayReference.scalar s (C99ArrayParser.mkn (.var "logn".toList) (.var "full".toList)) (.uint64 1536) := by
  have l : C99ArrayReference.scalar s (.var "logn".toList) (.uint32 10) := .variable _ _ _ logn
  have t : C99ArrayReference.scalar s (.var "full".toList) (.uint32 1) := .variable _ _ _ ternary
  have shifted : C99ArrayReference.scalar s (.bin .shl (.var "full".toList) (.literal .i32 1)) (.uint32 2) :=
    .shift .left _ _ _ _ _ t (.literal .int32 1)
      (.unsignedLeft (.uint32 1) (.int32 1) 1 rfl rfl (by decide))
  have sum : C99ArrayReference.scalar s (.bin .add (.literal .i32 1)
      (.bin .shl (.var "full".toList) (.literal .i32 1))) (.uint32 3) :=
    .arithmetic .plus _ _ _ _ _ (.literal .int32 1) shifted
      (.step .plus (.int32 1) (.uint32 2) .uint32 rfl (.uint32 1) (.uint32 2) rfl rfl
        (by intro impossible; cases impossible))
  have difference : C99ArrayReference.scalar s (.bin .sub (.var "logn".toList) (.var "full".toList)) (.uint32 9) :=
    .arithmetic .minus _ _ _ _ _ l t
      (.step .minus (.uint32 10) (.uint32 1) .uint32 rfl (.uint32 10) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible))
  exact .shift .left _ _ _ _ _ (.cast .uint64 _ (.uint32 3) sum) difference
    (.unsignedLeft (.uint64 3) (.uint32 9) 9 rfl rfl (by decide))

end FT1536.Source3.NttSize182
