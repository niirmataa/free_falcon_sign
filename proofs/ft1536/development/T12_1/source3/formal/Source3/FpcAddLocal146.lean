import Source3.FpcAddCompute146

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FpcAddLocal146
open C99ArrayReference (State Name Stmt Program Exec)
open FftPairShape140 (temporaries)
open FftMulStates140 (Words)
open FftPairStates140 (imagState)
open FftMulShape140 (varExpr)

structure Parameters where
  inputs : FpcAddCompute146.Inputs
  dr : Name
  di : Name

def operations (p : Parameters) := FpcAddCompute146.operations p.inputs++[
  .assign p.dr (varExpr "fpct_re"),.assign p.di (varExpr "fpct_im")]
def code (p : Parameters) : Stmt := .scope temporaries [] (FpcSourceExpansion.sequence (operations p))
def first (s : State) (p : Parameters) (x : Words) := FftLocalCells140.put (imagState .add s x) p.dr (FftPairStates140.real .add x)
def last (s : State) (p : Parameters) (x : Words) := FftLocalCells140.put (first s p x) p.di (FftPairStates140.imag .add x)
def output (s : State) (p : Parameters) (x : Words) :=
  FftLocalCells140.put (FftLocalCells140.put s p.dr (FftPairStates140.real .add x)) p.di (FftPairStates140.imag .add x)

structure Entry (s : State) (p : Parameters) (x : Words) : Prop where
  inputs : FpcAddCompute146.Entry s p.inputs x
  drCell : ∃ old, s.locals p.dr=some (.uint64,old)
  diCell : ∃ old, s.locals p.di=some (.uint64,old)
  drSafe : p.dr∉temporaries
  diSafe : p.di∉temporaries
  distinct : p.dr≠p.di

theorem write_real (program : Program) (s : State) (p : Parameters) (x : Words) (entry : Entry s p x) :
    Exec program (.assign p.dr (varExpr "fpct_re")) (imagState .add s x) (first s p x) := by
  obtain ⟨old,declared⟩ := entry.drCell
  apply FftLocalCells140.assign program (imagState .add s x) p.dr _ old (FftPairStates140.real .add x)
  · exact (FftPairStates140.other_local .add s x p.dr entry.drSafe).trans declared
  · exact FftLocalCells140.read_var _ _ _ ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at _ _ _))

theorem write_imag (program : Program) (s : State) (p : Parameters) (x : Words) (entry : Entry s p x) :
    Exec program (.assign p.di (varExpr "fpct_im")) (first s p x) (last s p x) := by
  obtain ⟨old,declared⟩ := entry.diCell
  apply FftLocalCells140.assign program (first s p x) p.di _ old (FftPairStates140.imag .add x)
  · exact (FftLocalCells140.outside _ _ _ _ (Ne.symm entry.distinct)).trans
      ((FftPairStates140.other_local .add s x p.di entry.diSafe).trans declared)
  · exact FftLocalCells140.read_var _ _ _ ((FftLocalCells140.outside _ _ _ _
      (Ne.symm (FpcAddCompute146.different p.dr _ entry.drSafe (by decide)))).trans (FftLocalCells140.cell_at _ _ _))

theorem internal_source (program : Program) (s : State) (p : Parameters) (x : Words) (entry : Entry s p x) :
    Exec program (FpcSourceExpansion.sequence (operations p)) s (last s p x) :=
  C99ArrayChain146.append program (FpcAddCompute146.operations p.inputs) _ s (imagState .add s x) _
    (FpcAddCompute146.source program s p.inputs x entry.inputs)
    (.seq _ _ _ _ _ (write_real program s p x entry) (.seq _ _ _ _ _ (write_imag program s p x entry) (.skip _)))

theorem restored (s : State) (p : Parameters) (x : Words) (drSafe : p.dr∉temporaries) (diSafe : p.di∉temporaries) :
    C99ArrayReference.restoreScope s (last s p x) temporaries []=output s p x := by
  rw [last,FftRestoreState140.outside s (first s p x) temporaries p.di (FftPairStates140.imag .add x) diSafe]
  rw [first,FftRestoreState140.outside s (imagState .add s x) temporaries p.dr (FftPairStates140.real .add x) drSafe]
  rw [FftPairClosed140.locals_restored]
  rfl

theorem source (program : Program) (s : State) (p : Parameters) (x : Words) (entry : Entry s p x) :
    Exec program (code p) s (output s p x) := by
  rw [← restored s p x entry.drSafe entry.diSafe]
  exact .scope _ _ _ _ _ (internal_source program s p x entry)

theorem heap (s : State) (p : Parameters) (x : Words) : (output s p x).heap=s.heap := rfl

theorem outside (s : State) (p : Parameters) (x : Words) (name : Name) (notReal : name≠p.dr) (notImag : name≠p.di) :
    (output s p x).locals name=s.locals name :=
  (FftLocalCells140.outside _ _ name _ notImag).trans (FftLocalCells140.outside _ _ name _ notReal)

theorem real_cell (s : State) (p : Parameters) (x : Words) (distinct : p.dr≠p.di) :
    (output s p x).locals p.dr=some (.uint64,some (.uint64 (FftPairStates140.real .add x))) :=
  (FftLocalCells140.outside _ _ _ _ distinct).trans (FftLocalCells140.cell_at _ _ _)

theorem imag_cell (s : State) (p : Parameters) (x : Words) :
    (output s p x).locals p.di=some (.uint64,some (.uint64 (FftPairStates140.imag .add x))) := FftLocalCells140.cell_at _ _ _

end FT1536.Source3.FpcAddLocal146
