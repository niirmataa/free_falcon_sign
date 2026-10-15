import Source3.C99LoopAssign142

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ControlCells142
open C99ArrayReference (State Name)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open FftLocalCells140 (put)

theorem at_cell (before : State) (name : Name) (n : Nat) : Cell (put before name (word n)) name n :=
  FftLocalCells140.cell_at before name (word n)

theorem other_cell (before : State) (name other : Name) (n value : Nat)
    (different : other≠name) (cell : Cell before other value) :
    Cell (put before name (word n)) other value := by
  unfold Cell
  rw [FftLocalCells140.outside before name other (word n) different]
  exact cell

theorem array_copy (program : C99ProcedureReference.Program) (s : State)
    (target origin : Name) (old value : Nat) (targetCell : Cell s target old)
    (sourceCell : Cell s origin value) :
    C99ProcedureReference.Exec program (.base (.assign target (.scalar (.var origin)))) s
      ⟨put s target (word value),.normal⟩ :=
  .base _ _ _ (FftLocalCells140.assign _ s target (.scalar (.var origin))
    (some (.uint64 (word old))) (word value) targetCell
    (FftLocalCells140.read_var s origin (word value) sourceCell))

end FT1536.Source3.C99ControlCells142
