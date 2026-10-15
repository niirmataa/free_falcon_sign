import Source3.FpcMulExec145

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FpcMulClosed145
open C99ArrayReference (State Name Program Exec)
open FpcMulShape145 (Parameters Entry lastReal lastImag output)
open FftMulShape140 (temporaries)
open FftMulStates140 (Words)

theorem restored (s : State) (p : Parameters) (x : Words) (drSafe : p.dr∉temporaries) (diSafe : p.di∉temporaries) :
    C99ArrayReference.restoreScope s (lastImag s p x) temporaries []=output s p x := by
  rw [lastImag,FftRestoreState140.outside s (lastReal s p x) temporaries p.di (FftMulStates140.imag x) diSafe]
  rw [lastReal,FftRestoreState140.outside s (FftMulStates140.s9 s x) temporaries p.dr (FftMulStates140.real x) drSafe]
  rw [FpcMulFrame145.restore9]
  rfl

/-- The original pinned MUL expansion for arbitrary legal caller names and words. -/
theorem source (program : Program) (s : State) (p : Parameters) (x : Words) (entry : Entry s p x) :
    Exec program (FpcMulShape145.code p) s (output s p x) := by
  rw [← restored s p x entry.drSafe entry.diSafe]
  exact .scope _ _ _ _ _ (FpcMulExec145.internal_source program s p x entry)

theorem heap (s : State) (p : Parameters) (x : Words) : (output s p x).heap=s.heap := rfl

theorem outside (s : State) (p : Parameters) (x : Words) (name : Name) (notReal : name≠p.dr) (notImag : name≠p.di) :
    (output s p x).locals name=s.locals name :=
  (FftLocalCells140.outside _ _ name _ notImag).trans (FftLocalCells140.outside _ _ name _ notReal)

theorem real_cell (s : State) (p : Parameters) (x : Words) (distinct : p.dr≠p.di) :
    (output s p x).locals p.dr=some (.uint64,some (.uint64 (FftMulStates140.real x))) :=
  (FftLocalCells140.outside _ _ _ _ distinct).trans (FftLocalCells140.cell_at _ _ _)

theorem imag_cell (s : State) (p : Parameters) (x : Words) :
    (output s p x).locals p.di=some (.uint64,some (.uint64 (FftMulStates140.imag x))) := FftLocalCells140.cell_at _ _ _

end FT1536.Source3.FpcMulClosed145
