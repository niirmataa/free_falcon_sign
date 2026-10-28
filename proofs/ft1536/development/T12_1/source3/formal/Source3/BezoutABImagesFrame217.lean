import Source3.BezoutABZeroCombine217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutABImagesFrame217
open C99ArrayReference (State)
open BezoutPointerSetup217 (a b)
open ZintNormWalkFlat208 (Data)
open BezoutABZeroCombine217 (padded)

theorem source (s : State) (nx ny : Nat) (X Y : Nat → BitVec 32) (h : BezoutABZero217.Input s nx ny)
    (lowA : Data (BezoutABZero217.after s nx ny) a nx X)
    (lowB : Data (BezoutABZero217.after s nx ny) b ny Y) :
    Data (BezoutABZero217.after s nx ny) a (max nx ny) (padded X nx) ∧
    Data (BezoutABZero217.after s nx ny) b (max nx ny) (padded Y ny) :=
  ⟨BezoutABZeroCombine217.combine _ a X nx (max nx ny) (Nat.le_max_left _ _) lowA (BezoutABZeroImages217.a_high s nx ny h),
    BezoutABZeroCombine217.combine _ b Y ny (max nx ny) (Nat.le_max_right _ _) lowB (BezoutABZeroImages217.b_high s nx ny h)⟩

end FT1536.Source3.BezoutABImagesFrame217
