import Source3.FftMulExec140
import Source3.FftRestoreState140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftMulClosed140
open C99ArrayReference (State Exec Program)
open FftMulStates140
open FftMulShape140 (temporaries aNames bNames dNames)

theorem a_subset : ∀ name∈aNames, name∈temporaries := by
  intro name member
  simp only [temporaries,List.mem_append]
  exact Or.inl (Or.inl member)

theorem b_subset : ∀ name∈bNames, name∈temporaries := by
  intro name member
  simp only [temporaries,List.mem_append]
  exact Or.inl (Or.inr member)

theorem d_subset : ∀ name∈dNames, name∈temporaries := by
  intro name member
  simp only [temporaries,List.mem_append]
  exact Or.inr member

theorem restored (before : State) (x : Words) :
    C99ArrayReference.restoreScope before (s11 before x) temporaries []=output before x := by
  rw [s11,FftRestoreState140.outside before (s10 before x) temporaries "a1i".toList (imag x) (by decide)]
  rw [s10,FftRestoreState140.outside before (s9 before x) temporaries "a1r".toList (real x) (by decide)]
  rw [s9,FftRestoreState140.inside before (s8 before x) temporaries "fpct_d_im".toList (imag x) (by decide)]
  rw [s8,FftRestoreState140.inside before (s7 before x) temporaries "fpct_d_re".toList (real x) (by decide)]
  rw [s7,FftRestoreState140.inside before (s6 before x) temporaries "fpct_b_im".toList (x.bi) (by decide)]
  rw [s6,FftRestoreState140.inside before (s5 before x) temporaries "fpct_b_re".toList (x.br) (by decide)]
  rw [s5,FftRestoreState140.inside before (s4 before x) temporaries "fpct_a_im".toList (x.ai) (by decide)]
  rw [s4,FftRestoreState140.inside before (s3 before) temporaries "fpct_a_re".toList (x.ar) (by decide)]
  rw [s3,FftRestoreState140.declarations before (s2 before) temporaries dNames .u64 d_subset]
  rw [s2,FftRestoreState140.declarations before (s1 before) temporaries bNames .u64 b_subset]
  rw [s1,FftRestoreState140.declarations before before temporaries aNames .u64 a_subset,FftRestoreState140.self]
  rfl

/-- One source theorem for all four operand words and all surrounding states.
    Only the two destination cells change; original temporary cells return. -/
theorem source (program : Program) (before : State) (x : Words) (entry : Entry before x) :
    Exec program FftMulShape140.code before (output before x) := by
  rw [← restored before x]
  exact FftMulExec140.scoped_source program before x entry

theorem in_butterfly (before : State) (x : Words) (entry : Entry before x) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftMulShape140.sourcePart before
      ⟨output before x,.normal⟩ := by
  rw [FftMulShape140.source_bound]
  exact .base _ _ _ (source FftLeafPrograms.program before x entry)

theorem heap_same (before : State) (x : Words) : (output before x).heap=before.heap := rfl

theorem other_local (before : State) (x : Words) (name : C99ArrayReference.Name)
    (notReal : name≠"a1r".toList) (notImag : name≠"a1i".toList) :
    (output before x).locals name=before.locals name := by
  exact (FftLocalCells140.outside (FftLocalCells140.put before "a1r".toList (real x))
    "a1i".toList name (imag x) notImag).trans
    (FftLocalCells140.outside before "a1r".toList name (real x) notReal)

end FT1536.Source3.FftMulClosed140
