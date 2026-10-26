import Source3.MkgmControl199
import Source3.NttInversePrologue192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttSize201
open C99IntegerReference (Value ArithmeticExec ShiftExec CompareExec)
open C99ArrayReference (State)
open KeygenModpR2Exec (Slot)
open MkgmParams198 (Level lognWord count half)
open KeygenNttLoopSupport (u64)

theorem subtract_zero (l : Level) :
    ArithmeticExec .minus (.uint32 (lognWord l)) (.uint32 0) (.uint32 (lognWord l)) := by
  fin_cases l
  all_goals exact .step .minus _ _ .uint32 rfl _ _ rfl rfl (by intro impossible; cases impossible)

theorem shift_count (l : Level) :
    ShiftExec .left (.uint64 1) (.uint32 (lognWord l)) (u64 (count l)) := by
  fin_cases l
  · exact .unsignedLeft (.uint64 1) (.uint32 1) 1 rfl rfl (by decide)
  · exact .unsignedLeft (.uint64 1) (.uint32 2) 2 rfl rfl (by decide)
  · exact .unsignedLeft (.uint64 1) (.uint32 3) 3 rfl rfl (by decide)
  · exact .unsignedLeft (.uint64 1) (.uint32 4) 4 rfl rfl (by decide)
  · exact .unsignedLeft (.uint64 1) (.uint32 5) 5 rfl rfl (by decide)
  · exact .unsignedLeft (.uint64 1) (.uint32 6) 6 rfl rfl (by decide)
  · exact .unsignedLeft (.uint64 1) (.uint32 7) 7 rfl rfl (by decide)
  · exact .unsignedLeft (.uint64 1) (.uint32 8) 8 rfl rfl (by decide)
  · exact .unsignedLeft (.uint64 1) (.uint32 9) 9 rfl rfl (by decide)

theorem shift_half (l : Level) :
    ShiftExec .right (u64 (count l)) (.int32 1) (u64 (half l)) := by
  fin_cases l
  all_goals exact .right _ _ 1 rfl (by decide)

theorem logn_zero (l : Level) : CompareExec .eq (.uint32 (lognWord l)) (.int32 0) (.int32 0) := by
  fin_cases l
  all_goals exact .step .eq _ _ .uint32 rfl _ _ rfl rfl

theorem mkn (l : Level) (s : State) (logn : Slot s "logn" (lognWord l)) (full : Slot s "full" 0) :
    C99ArrayReference.scalar s (C99ArrayParser.mkn (.var "logn".toList) (.var "full".toList)) (u64 (count l)) := by
  have shifted : C99ArrayReference.scalar s
      (.bin .shl (.var "full".toList) (.literal .i32 1)) (.uint32 0) :=
    .shift .left _ _ _ _ _ (.variable _ _ _ full) (.literal .int32 1)
      (.unsignedLeft (.uint32 0) (.int32 1) 1 rfl rfl (by decide))
  have sum : C99ArrayReference.scalar s (.bin .add (.literal .i32 1)
      (.bin .shl (.var "full".toList) (.literal .i32 1))) (.uint32 1) :=
    .arithmetic .plus _ _ _ _ _ (.literal .int32 1) shifted
      (.step .plus (.int32 1) (.uint32 0) .uint32 rfl (.uint32 1) (.uint32 0) rfl rfl
        (by intro impossible; cases impossible))
  have difference : C99ArrayReference.scalar s
      (.bin .sub (.var "logn".toList) (.var "full".toList)) (.uint32 (lognWord l)) :=
    .arithmetic .minus _ _ _ _ _ (.variable _ _ _ logn) (.variable _ _ _ full) (subtract_zero l)
  exact .shift .left _ _ _ _ _ (.cast .uint64 _ (.uint32 1) sum) difference (shift_count l)

end FT1536.Source3.NttSize201
