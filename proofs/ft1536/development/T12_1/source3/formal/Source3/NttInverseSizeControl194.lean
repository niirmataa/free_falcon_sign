import Source3.NttInversePrologue192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Logn-8 control variant of the prologue size lemma. The sealed
   NttInversePrologue192 proves the MKN size evaluation of the inverse
   prologue at logn 9 / full 0 (512) and its hn halving (256). This module
   records the same evaluations at logn 8 / full 0 (256 and 128): the
   corpus instance the s8 branch body would need if the fd/gd inverse pair
   at logn-1 = 8 were ever executed. It is a CONTROL only — at this step
   out_ntt = 1, the !out_ntt branch is false and no logn-8 corpus
   execution exists; nothing here is a premise of any execution claim. -/
namespace FT1536.Source3.NttInverseSizeControl194
open C99ArrayReference (State)

theorem size_value8 (s : State)
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 8)))
    (full : s.locals "full".toList=some (.uint32,some (.uint32 0))) :
    C99ArrayReference.scalar s (C99ArrayParser.mkn (.var "logn".toList) (.var "full".toList))
      (.uint64 256) := by
  have l : C99ArrayReference.scalar s (.var "logn".toList) (.uint32 8) := .variable _ _ _ logn
  have t : C99ArrayReference.scalar s (.var "full".toList) (.uint32 0) := .variable _ _ _ full
  have shifted : C99ArrayReference.scalar s
      (.bin .shl (.var "full".toList) (.literal .i32 1)) (.uint32 0) :=
    .shift .left _ _ _ _ _ t (.literal .int32 1)
      (.unsignedLeft (.uint32 0) (.int32 1) 1 rfl rfl (by decide))
  have sum : C99ArrayReference.scalar s (.bin .add (.literal .i32 1)
      (.bin .shl (.var "full".toList) (.literal .i32 1))) (.uint32 1) :=
    .arithmetic .plus _ _ _ _ _ (.literal .int32 1) shifted
      (.step .plus (.int32 1) (.uint32 0) .uint32 rfl (.uint32 1) (.uint32 0) rfl rfl
        (by intro impossible; cases impossible))
  have difference : C99ArrayReference.scalar s
      (.bin .sub (.var "logn".toList) (.var "full".toList)) (.uint32 8) :=
    .arithmetic .minus _ _ _ _ _ l t
      (.step .minus (.uint32 8) (.uint32 0) .uint32 rfl (.uint32 8) (.uint32 0) rfl rfl
        (by intro impossible; cases impossible))
  exact .shift .left _ _ _ _ _ (.cast .uint64 _ (.uint32 1) sum) difference
    (.unsignedLeft (.uint64 1) (.uint32 8) 8 rfl rfl (by decide))

theorem hn_value8 (s : State)
    (n : s.locals "n".toList=some (.uint64,some (.uint64 (C99NatWord141.word 256)))) :
    C99ArrayReference.scalar s (.bin .shr (.var "n".toList) (.literal .i32 1))
      (.uint64 128) :=
  .shift .right _ _ _ _ _ (.variable _ _ _ n) (.literal .int32 1)
    (.right (.uint64 256) (.int32 1) 1 rfl (by decide))

end FT1536.Source3.NttInverseSizeControl194
