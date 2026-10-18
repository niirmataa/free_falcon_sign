import Source3.MakeFgTopDeclarations177

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MakeFgTopSizes177
open C99ArrayReference (State scalar)

theorem ternary (s : State) (e : CLogic.Expr) (value : scalar s e (.uint32 10)) :
    scalar s (C99ArrayParser.mkn e (.literal .i32 1)) (.uint64 1536) := by
  have shifted : scalar s (.bin .shl (.literal .i32 1) (.literal .i32 1)) (.int32 2) :=
    .shift .left _ _ _ _ _ (.literal .int32 1) (.literal .int32 1)
      (.signedLeft (.int32 1) (.int32 1) 1 rfl rfl (by decide) (by decide)
        (by unfold C99IntegerReference.fits; decide))
  have sum : scalar s (.bin .add (.literal .i32 1)
      (.bin .shl (.literal .i32 1) (.literal .i32 1))) (.int32 3) :=
    .arithmetic .plus _ _ _ _ _ (.literal .int32 1) shifted
      (.step .plus (.int32 1) (.int32 2) .int32 rfl (.int32 1) (.int32 2) rfl rfl
        (by intro _; unfold C99IntegerReference.fits; decide))
  have difference : scalar s (.bin .sub e (.literal .i32 1)) (.uint32 9) :=
    .arithmetic .minus _ _ _ _ _ value (.literal .int32 1)
      (.step .minus (.uint32 10) (.int32 1) .uint32 rfl (.uint32 10) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible))
  exact .shift .left _ _ _ _ _ (.cast .uint64 _ (.int32 3) sum) difference
    (.unsignedLeft (.uint64 3) (.uint32 9) 9 rfl rfl (by decide))

theorem binary10 (s : State) (e : CLogic.Expr) (value : scalar s e (.uint32 10)) :
    scalar s (C99ArrayParser.mkn e (.literal .i32 0)) (.uint64 1024) := by
  have shifted : scalar s (.bin .shl (.literal .i32 0) (.literal .i32 1)) (.int32 0) :=
    .shift .left _ _ _ _ _ (.literal .int32 0) (.literal .int32 1)
      (.signedLeft (.int32 0) (.int32 1) 1 rfl rfl (by decide) (by decide)
        (by unfold C99IntegerReference.fits; decide))
  have sum : scalar s (.bin .add (.literal .i32 1)
      (.bin .shl (.literal .i32 0) (.literal .i32 1))) (.int32 1) :=
    .arithmetic .plus _ _ _ _ _ (.literal .int32 1) shifted
      (.step .plus (.int32 1) (.int32 0) .int32 rfl (.int32 1) (.int32 0) rfl rfl
        (by intro _; unfold C99IntegerReference.fits; decide))
  have difference : scalar s (.bin .sub e (.literal .i32 0)) (.uint32 10) :=
    .arithmetic .minus _ _ _ _ _ value (.literal .int32 0)
      (.step .minus (.uint32 10) (.int32 0) .uint32 rfl (.uint32 10) (.uint32 0) rfl rfl
        (by intro impossible; cases impossible))
  exact .shift .left _ _ _ _ _ (.cast .uint64 _ (.int32 1) sum) difference
    (.unsignedLeft (.uint64 1) (.uint32 10) 10 rfl rfl (by decide))

theorem binary9 (s : State) (e : CLogic.Expr) (value : scalar s e (.uint32 9)) :
    scalar s (C99ArrayParser.mkn e (.literal .i32 0)) (.uint64 512) := by
  have shifted : scalar s (.bin .shl (.literal .i32 0) (.literal .i32 1)) (.int32 0) :=
    .shift .left _ _ _ _ _ (.literal .int32 0) (.literal .int32 1)
      (.signedLeft (.int32 0) (.int32 1) 1 rfl rfl (by decide) (by decide)
        (by unfold C99IntegerReference.fits; decide))
  have sum : scalar s (.bin .add (.literal .i32 1)
      (.bin .shl (.literal .i32 0) (.literal .i32 1))) (.int32 1) :=
    .arithmetic .plus _ _ _ _ _ (.literal .int32 1) shifted
      (.step .plus (.int32 1) (.int32 0) .int32 rfl (.int32 1) (.int32 0) rfl rfl
        (by intro _; unfold C99IntegerReference.fits; decide))
  have difference : scalar s (.bin .sub e (.literal .i32 0)) (.uint32 9) :=
    .arithmetic .minus _ _ _ _ _ value (.literal .int32 0)
      (.step .minus (.uint32 9) (.int32 0) .uint32 rfl (.uint32 9) (.uint32 0) rfl rfl
        (by intro impossible; cases impossible))
  exact .shift .left _ _ _ _ _ (.cast .uint64 _ (.int32 1) sum) difference
    (.unsignedLeft (.uint64 1) (.uint32 9) 9 rfl rfl (by decide))

theorem tn (s : State) (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10))) :
    scalar s MakeFgTopShape177.tnExpr (.uint64 512) :=
  binary9 s _ (.arithmetic .minus _ _ _ _ _ (.variable _ _ _ logn) (.literal .int32 1)
    (.step .minus (.uint32 10) (.int32 1) .uint32 rfl (.uint32 10) (.uint32 1) rfl rfl
      (by intro impossible; cases impossible)))

end FT1536.Source3.MakeFgTopSizes177
