import Source3.ExactLengthCalls217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ExactLengthFrame217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (highest)
open ExactLengthCalls217 (after)

theorem source (s : State) (x y : ArrayPointer) (X Y : Nat → BitVec 32)
    (xb : s.arrays "x".toList=some x) (yb : s.arrays "y".toList=some y)
    (len : Cell s "len".toList 335) (xc : x.index+335 ≤ x.count) (yc : y.index+335 ≤ y.count)
    (xf : Data s x 335 X) (yf : Data s y 335 Y)
    (xdecl : s.locals "xlen".toList=some (.uint64,none)) (ydecl : s.locals "ylen".toList=some (.uint64,none)) :
    KeygenZintCall.Exec (KeygenZintCall.bezoutPart 2) s ⟨after s X Y,.normal⟩ ∧
    Cell (after s X Y) "xlen".toList (highest X 335) ∧ Cell (after s X Y) "ylen".toList (highest Y 335) ∧
    Data (after s X Y) x 335 X ∧ Data (after s X Y) y 335 Y := by
  have run := ExactLengthCalls217.source s x y X Y xb yb len xc yc xf yf xdecl ydecl
  have xbound : highest X 335<2^64 := lt_of_le_of_lt (ExactLengthProgram217.highest_le X 335) (by decide)
  have ybound : highest Y 335<2^64 := lt_of_le_of_lt (ExactLengthProgram217.highest_le Y 335) (by decide)
  have xcell : Cell (after s X Y) "xlen".toList (highest X 335) :=
    (SelectedStepAddPrime195.locals_keep _ "ylen".toList .uint64 _ "xlen".toList (by decide)).trans
      (KeygenMkgm3RowInit.set64_slot s "xlen" (highest X 335) xbound)
  have ycell : Cell (after s X Y) "ylen".toList (highest Y 335) :=
    KeygenMkgm3RowInit.set64_slot _ "ylen" (highest Y 335) ybound
  exact ⟨run,xcell,ycell,xf,yf⟩

end FT1536.Source3.ExactLengthFrame217
