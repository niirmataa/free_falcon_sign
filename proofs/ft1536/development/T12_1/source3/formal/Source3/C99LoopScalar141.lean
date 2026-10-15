import Source3.C99NatWord141
import Source3.FftLocalCells140
import Source3.C99ProcedureReference

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99LoopScalar141
open C99ArrayReference (State Name scalar)
open C99NatWord141 (word)

def Cell (s : State) (name : Name) (n : Nat) : Prop :=
  s.locals name=some (.uint64,some (.uint64 (word n)))

theorem read (s : State) (name : Name) (n : Nat) (binding : Cell s name n) :
    scalar s (.var name) (.uint64 (word n)) :=
  .variable name .uint64 (.uint64 (word n)) binding

theorem add (s : State) (left right : CLogic.Expr) (a b : Nat)
    (boundA : a<2^64) (boundB : b<2^64)
    (first : scalar s left (.uint64 (word a))) (second : scalar s right (.uint64 (word b))) :
    scalar s (.bin .add left right) (.uint64 (word (a+b))) :=
  .arithmetic .plus _ _ _ _ _ first second (C99NatWord141.add a b boundA boundB)

theorem less (s : State) (left right : CLogic.Expr) (a b : Nat)
    (boundA : a<2^64) (boundB : b<2^64)
    (first : scalar s left (.uint64 (word a))) (second : scalar s right (.uint64 (word b))) :
    scalar s (.cmp .lt left right) (C99ScalarReference.boolean (decide (a<b))) :=
  .compare .lt _ _ _ _ _ first second (C99NatWord141.less a b boundA boundB)

theorem increment (program : C99ProcedureReference.Program) (s : State) (name : Name) (n : Nat)
    (bound : n<2^64) (binding : Cell s name n) :
    C99ProcedureReference.Exec program (.base (.scalar (.update name .add (.literal .i32 1)))) s
      ⟨FftLocalCells140.put s name (word (n+1)),.normal⟩ := by
  rw [FftLocalCells140.put_bind]
  refine .base _ _ _ (.scalar s _ (.update name .add (.literal .i32 1)) ?_)
  exact .assign s.locals name _ .uint64 (some (.uint64 (word n))) (.uint64 (word (n+1))) binding
    (.arithmetic .plus _ _ _ _ _ (read s name n binding) (.literal .int32 1) (C99NatWord141.add_one n bound))

end FT1536.Source3.C99LoopScalar141
