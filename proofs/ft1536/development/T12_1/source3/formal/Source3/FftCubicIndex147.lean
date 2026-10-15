import Source3.FftCubicWord147
import Source3.FftTripleShape145
import Source3.C99SmallLiteral146
import Source3.C99PointerNat141

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftCubicIndex147
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)

def realIndex : CLogic.Expr := .bin .add (.var "v".toList) (.literal .i32 0)
def imagIndex : CLogic.Expr := .bin .add (.var "v".toList) (.literal .i32 1)

theorem real_shape : FftTripleShape145.part 10=.base (.assign "xr".toList (.load "fpr_gm3_cubic".toList realIndex)) := by rfl
theorem imag_shape : FftTripleShape145.part 11=.base (.assign "xi".toList (.load "fpr_gm3_cubic".toList imagIndex)) := by rfl

theorem real_address (s : State) (q : Nat) (bound : q<2048) (vCell : Cell s "v".toList (2*q))
    (binding : s.arrays "fpr_gm3_cubic".toList=some (FftGlobalMemory.pointer .cubic)) :
    C99ArrayReference.Pointer s "fpr_gm3_cubic".toList realIndex {FftGlobalMemory.pointer .cubic with index := 2*q} := by
  have evaluated : C99ArrayReference.scalar s realIndex (.uint64 (word (2*q))) :=
    C99SmallLiteral146.add s (.var "v".toList) (2*q) ⟨0,by decide⟩ (by omega) (C99LoopScalar141.read s "v".toList (2*q) vCell)
  simpa only [FftGlobalMemory.pointer,Nat.zero_add] using C99PointerNat141.source s _ realIndex (FftGlobalMemory.pointer .cubic) (2*q)
    (by omega) (by change 0+2*q≤4096; omega) binding evaluated

theorem imag_address (s : State) (q : Nat) (bound : q<2048) (vCell : Cell s "v".toList (2*q))
    (binding : s.arrays "fpr_gm3_cubic".toList=some (FftGlobalMemory.pointer .cubic)) :
    C99ArrayReference.Pointer s "fpr_gm3_cubic".toList imagIndex {FftGlobalMemory.pointer .cubic with index := 2*q+1} := by
  have evaluated : C99ArrayReference.scalar s imagIndex (.uint64 (word (2*q+1))) :=
    C99SmallLiteral146.add s (.var "v".toList) (2*q) ⟨1,by decide⟩ (by omega) (C99LoopScalar141.read s "v".toList (2*q) vCell)
  simpa only [FftGlobalMemory.pointer,Nat.zero_add] using C99PointerNat141.source s _ imagIndex (FftGlobalMemory.pointer .cubic) (2*q+1)
    (by omega) (by change 0+(2*q+1)≤4096; omega) binding evaluated

end FT1536.Source3.FftCubicIndex147
