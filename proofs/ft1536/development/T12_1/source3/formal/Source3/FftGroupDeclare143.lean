import Source3.FftMiddleLoad139
import Source3.C99DeclareOutside140
import Source3.C99ControlCells142

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftGroupDeclare143
open C99ArrayReference (State Name)
open C99LoopScalar141 (Cell)

def counters : List Name := ["v".toList,"v2".toList]
def scalars : List Name := ["sr".toList,"si".toList]
def first (s : State) := C99DeclarationStatements.effect .u64 counters s
def after (s : State) := C99DeclarationStatements.effect .u64 scalars (first s)

theorem shape : FftMiddleLoad139.declarations=
    .seq (.base (.scalar (.declare .u64 counters)))
      (.seq (.base (.scalar (.declare .u64 scalars))) (.base .skip)) := by rfl

theorem source (s : State) : C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleLoad139.declarations s
    ⟨after s,.normal⟩ := by
  rw [shape]
  exact .seqNormal _ _ _ (first s) _ (.base _ _ _ (C99DeclarationStatements.source_exists _ .u64 counters s))
    (.seqNormal _ _ _ (after s) _ (.base _ _ _ (C99DeclarationStatements.source_exists _ .u64 scalars (first s)))
      (.base _ _ _ (.skip _)))

theorem outside (s : State) (name : Name) (notCounter : name∉counters) (notScalar : name∉scalars) :
    (after s).locals name=s.locals name :=
  (C99DeclareOutside140.source .uint64 scalars (first s).locals name notScalar).trans
    (C99DeclareOutside140.source .uint64 counters s.locals name notCounter)

theorem cell (s : State) (name : Name) (value : Nat) (notCounter : name∉counters)
    (notScalar : name∉scalars) (old : Cell s name value) : Cell (after s) name value :=
  (outside s name notCounter notScalar).trans old

theorem sr (s : State) : (after s).locals "sr".toList=some (.uint64,none) := by
  simp [after,first,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,counters,scalars,C99ScalarReference.set,C99ValueBridge.type]

theorem si (s : State) : (after s).locals "si".toList=some (.uint64,none) := by
  simp [after,first,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,counters,scalars,C99ScalarReference.set,C99ValueBridge.type]

theorem v (s : State) : (after s).locals "v".toList=some (.uint64,none) := by
  simp [after,first,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,counters,scalars,C99ScalarReference.set,C99ValueBridge.type]

theorem v2 (s : State) : (after s).locals "v2".toList=some (.uint64,none) := by
  simp [after,first,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,counters,scalars,C99ScalarReference.set,C99ValueBridge.type]

end FT1536.Source3.FftGroupDeclare143
