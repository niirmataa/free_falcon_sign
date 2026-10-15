import Source3.FftDimension150
import Source3.FftOuterInduction144
import Source3.C99ScopeFrame147

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftMiddleSetup150
open C99ArrayReference (State Name)
open C99LoopScalar141 (Cell)
open FftLocalCells140 (put)

def minimumExpr : CLogic.Expr := match FftMiddleShape139.setMinimum with
  | .base (.assign _ (.scalar e)) => e
  | _ => .literal .i32 0
def setT (s : State) := put s "t".toList 768
def minimum (s : State) := put (setT s) "tmin".toList 3
def initial (s : State) := put (minimum s) "m".toList 2
def names : List Name := ["t".toList,"tmin".toList,"m".toList]

theorem minimum_shape : FftMiddleShape139.setMinimum=.base (.assign "tmin".toList (.scalar minimumExpr)) := by rfl
theorem minimum_reads : C99ExpressionEnvironment.readNames (C99Frontend.expression minimumExpr)=["full".toList] := by rfl
theorem minimum_computed : C99CompactScalar115.evaluate C99CompactPointer115.noCalls FftDimension150.cells minimumExpr=some (.u32 3) := by decide +kernel

theorem minimum_eval (s : State) (full : s.locals "full".toList=some (.uint32,some (.uint32 1))) :
    C99ArrayReference.scalar s minimumExpr (.uint32 3) := by
  have evaluated := C99CompactScalar115.evaluate_sound FprPrefixCalls.calls C99CompactPointer115.noCalls
    (C99CompactPointer115.noCalls_sound _) FftDimension150.cells minimumExpr (.u32 3) minimum_computed
  apply C99ExpressionEnvironment.transport FprPrefixCalls.calls (C99CompactCells115.environment FftDimension150.cells) s.locals _ _ evaluated
  intro key member
  rw [minimum_reads] at member
  have same := List.mem_singleton.mp member
  subst key
  exact full.symm

theorem set_t (s : State) (declared : s.locals "t".toList=some (.uint64,none)) (hn : Cell s "hn".toList 768) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.setT s ⟨setT s,.normal⟩ :=
  .base _ _ _ (FftLocalCells140.assign _ s "t".toList _ none 768 declared
    (.scalar _ _ (C99LoopScalar141.read s "hn".toList 768 hn)))

theorem set_minimum (s : State) (declared : s.locals "tmin".toList=some (.uint64,none))
    (full : s.locals "full".toList=some (.uint32,some (.uint32 1))) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.setMinimum (setT s) ⟨minimum s,.normal⟩ := by
  rw [minimum_shape]
  exact .base _ _ _ (.assign (setT s) "tmin".toList (.scalar minimumExpr) .uint64 none (.uint32 3)
    ((FftLocalCells140.outside _ _ _ _ (by decide)).trans declared)
    (.scalar _ _ (minimum_eval (setT s) ((FftLocalCells140.outside _ _ _ _ (by decide)).trans full))))

theorem initialization (s : State) (declared : s.locals "m".toList=some (.uint64,none)) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.outerInitial (minimum s) ⟨initial s,.normal⟩ := by
  have cell : (minimum s).locals "m".toList=some (.uint64,none) :=
    (FftLocalCells140.outside _ _ _ _ (by decide)).trans
      ((FftLocalCells140.outside _ _ _ _ (by decide)).trans declared)
  exact .base _ _ _ (.scalar _ _ _ (.assign (minimum s).locals "m".toList _ .uint64 none (.int32 2) cell (.literal .int32 2)))

theorem frame (s : State) : C99ScopeFrame147.Frame names s (initial s) :=
  C99ScopeFrame147.trans names s (setT s) (initial s) (C99ScopeFrame147.put names s "t".toList 768 (by decide))
    (C99ScopeFrame147.trans names (setT s) (minimum s) (initial s)
      (C99ScopeFrame147.put names (setT s) "tmin".toList 3 (by decide))
      (C99ScopeFrame147.put names (minimum s) "m".toList 2 (by decide)))

theorem t_cell (s : State) : Cell (initial s) "t".toList 768 :=
  (FftLocalCells140.outside _ _ _ _ (by decide)).trans
    ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at s "t".toList 768))
theorem minimum_cell (s : State) : Cell (initial s) "tmin".toList 3 :=
  (FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at (setT s) "tmin".toList 3)
theorem m_cell (s : State) : Cell (initial s) "m".toList 2 := FftLocalCells140.cell_at (minimum s) "m".toList 2

end FT1536.Source3.FftMiddleSetup150
