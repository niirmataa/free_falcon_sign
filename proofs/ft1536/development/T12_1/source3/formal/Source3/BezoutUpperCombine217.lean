import Source3.BezoutUpperZeroImages217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Combine the lower and upper zero ranges without evaluating their words. -/
namespace FT1536.Source3.BezoutUpperCombine217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open KeygenSmallOutput (element)
open StepCopyBody190 (elem)
open DeepestBezoutEntry217 (Fp Gp)
open ZintNormWalkFlat208 (Data)

theorem u_tail (s : State) (ny : Nat) (positive : 0<ny) (bound : ny≤335)
    (low : Data s BezoutInitZero217.firstPtr (ny-1) (fun _ => 0))
    (high : Data s (element Gp ny) (335-ny) (fun _ => 0)) :
    Data s BezoutInitZero217.firstPtr 334 (fun _ => 0) := by
  intro i inside
  by_cases lt : i<ny-1
  · exact low i lt
  · have idx : i-(ny-1)<335-ny := by omega
    have address : elem BezoutInitZero217.firstPtr i=elem (element Gp ny) (i-(ny-1)) := by
      change (⟨31,0,71680,4,336+i⟩ : ArrayPointer)=⟨31,0,71680,4,335+ny+(i-(ny-1))⟩
      apply congrArg (fun k : Nat => (⟨31,0,71680,4,k⟩ : ArrayPointer))
      omega
    rw [address]
    exact high (i-(ny-1)) idx

theorem v_all (s : State) (nx : Nat) (bound : nx≤335)
    (low : Data s Fp nx (fun _ => 0)) (high : Data s (element Fp nx) (335-nx) (fun _ => 0)) :
    Data s Fp 335 (fun _ => 0) := by
  intro i inside
  by_cases lt : i<nx
  · exact low i lt
  · have idx : i-nx<335-nx := by omega
    have address : elem Fp i=elem (element Fp nx) (i-nx) := by
      change (⟨31,0,71680,4,0+i⟩ : ArrayPointer)=⟨31,0,71680,4,0+nx+(i-nx)⟩
      apply congrArg (fun k : Nat => (⟨31,0,71680,4,k⟩ : ArrayPointer))
      omega
    rw [address]
    exact high (i-nx) idx

end FT1536.Source3.BezoutUpperCombine217
