import Source3.C99LoopScalar141

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99LoopAssign142
open C99ArrayReference (State Name scalar)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)

theorem assign (program : C99ProcedureReference.Program) (s : State) (name : Name) (expr : CLogic.Expr)
    (old : Nat) (value : BitVec 64) (cell : Cell s name old)
    (evaluated : scalar s expr (.uint64 value)) :
    C99ProcedureReference.Exec program (.base (.scalar (.assign name expr))) s
      ⟨FftLocalCells140.put s name value,.normal⟩ := by
  rw [FftLocalCells140.put_bind]
  exact .base _ _ _ (.scalar s _ _ (.assign s.locals name _ .uint64 (some (.uint64 (word old)))
    (.uint64 value) cell evaluated))

theorem update (program : C99ProcedureReference.Program) (s : State) (name : Name)
    (op : B20.C.BinOp) (expr : CLogic.Expr) (old : Nat) (value : BitVec 64) (cell : Cell s name old)
    (evaluated : scalar s (.bin op (.var name) expr) (.uint64 value)) :
    C99ProcedureReference.Exec program (.base (.scalar (.update name op expr))) s
      ⟨FftLocalCells140.put s name value,.normal⟩ := by
  rw [FftLocalCells140.put_bind]
  exact .base _ _ _ (.scalar s _ _ (.assign s.locals name _ .uint64 (some (.uint64 (word old)))
    (.uint64 value) cell evaluated))

theorem copy (program : C99ProcedureReference.Program) (s : State) (target origin : Name) (old value : Nat)
    (targetCell : Cell s target old) (sourceCell : Cell s origin value) :
    C99ProcedureReference.Exec program (.base (.scalar (.assign target (.var origin)))) s
      ⟨FftLocalCells140.put s target (word value),.normal⟩ :=
  assign program s target (.var origin) old (word value) targetCell (C99LoopScalar141.read s origin value sourceCell)

theorem add (program : C99ProcedureReference.Program) (s : State) (target origin : Name) (a b : Nat)
    (boundA : a<2^64) (boundB : b<2^64) (targetCell : Cell s target a) (sourceCell : Cell s origin b) :
    C99ProcedureReference.Exec program (.base (.scalar (.update target .add (.var origin)))) s
      ⟨FftLocalCells140.put s target (word (a+b)),.normal⟩ :=
  update program s target .add (.var origin) a (word (a+b)) targetCell
    (C99LoopScalar141.add s _ _ a b boundA boundB (C99LoopScalar141.read s target a targetCell)
      (C99LoopScalar141.read s origin b sourceCell))

end FT1536.Source3.C99LoopAssign142
