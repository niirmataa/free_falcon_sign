import Source3.FpcSqrExec145
import Source3.FftTripleShape145

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FpcSqrClosed145
open C99ArrayReference (State Name Program Exec)
open FpcSqrShape145

theorem restored (s : State) (re im : Name) (x y : BitVec 64) (reSafe : re∉temporaries) (imSafe : im∉temporaries) :
    C99ArrayReference.restoreScope s (s8 s re im x y) temporaries []=output s re im x y := by
  rw [s8,FftRestoreState140.outside s (s7 s re x y) temporaries im (imag x y) imSafe]
  rw [s7,FftRestoreState140.outside s (s6 s x y) temporaries re (real x y) reSafe,FpcSqrFrame145.restore6]
  rfl

/-- Preserve the original sqr/sub/mul/double evaluation; no real-algebra replacement. -/
theorem source (program : Program) (s : State) (re im : Name) (x y : BitVec 64) (entry : Entry s re im x y) :
    Exec program (code re im) s (output s re im x y) := by
  rw [← restored s re im x y entry.reSafe entry.imSafe]
  exact .scope _ _ _ _ _ (FpcSqrExec145.internal_source program s re im x y entry)

theorem source_shape : FftTripleShape145.part 15=.base (code "xr".toList "xi".toList) := by rfl

theorem in_tripling (s : State) (x y : BitVec 64) (entry : Entry s "xr".toList "xi".toList x y) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part 15) s
      ⟨output s "xr".toList "xi".toList x y,.normal⟩ := by
  rw [source_shape]
  exact .base _ _ _ (source FftLeafPrograms.program s _ _ x y entry)

theorem heap (s : State) (re im : Name) (x y : BitVec 64) : (output s re im x y).heap=s.heap := rfl

theorem outside (s : State) (re im : Name) (x y : BitVec 64) (name : Name) (notReal : name≠re) (notImag : name≠im) :
    (output s re im x y).locals name=s.locals name :=
  (FftLocalCells140.outside _ _ name _ notImag).trans (FftLocalCells140.outside _ _ name _ notReal)

end FT1536.Source3.FpcSqrClosed145
