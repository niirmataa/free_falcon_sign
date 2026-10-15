import Source3.FftShape138
import Source3.C99ExpressionEnvironment
import Source3.C99CompactPointer115

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftDimension150
open C99ArrayReference (State)

def sizeExpr : CLogic.Expr := match FftShape138.size with
  | .base (.assign _ (.scalar e)) => e
  | _ => .literal .i32 0
def cells : C99CompactCells115.Locals := [("full".toList,.u32 (some 1)),("logn".toList,.u32 (some 10))]

theorem size_shape : FftShape138.size=.base (.assign "n".toList (.scalar sizeExpr)) := by rfl
theorem reads : C99ExpressionEnvironment.readNames (C99Frontend.expression sizeExpr)=
    ["full".toList,"logn".toList,"full".toList] := by rfl
theorem computed : C99CompactScalar115.evaluate C99CompactPointer115.noCalls cells sizeExpr=some (.u64 1536) := by decide +kernel

theorem source (s : State)
    (full : s.locals "full".toList=some (.uint32,some (.uint32 1)))
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10))) :
    C99ArrayReference.scalar s sizeExpr (.uint64 1536) := by
  have evaluated := C99CompactScalar115.evaluate_sound FprPrefixCalls.calls C99CompactPointer115.noCalls
    (C99CompactPointer115.noCalls_sound _) cells sizeExpr (.u64 1536) computed
  apply C99ExpressionEnvironment.transport FprPrefixCalls.calls (C99CompactCells115.environment cells) s.locals _ _ evaluated
  intro key member
  rw [reads] at member
  simp only [List.mem_cons,List.not_mem_nil,or_false] at member
  rcases member with rfl|rfl|rfl
  · exact full.symm
  · exact logn.symm
  · exact full.symm

end FT1536.Source3.FftDimension150
