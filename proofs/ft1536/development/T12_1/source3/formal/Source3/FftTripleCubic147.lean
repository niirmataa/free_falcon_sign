import Source3.FftTripleLoadExec147
import Source3.FftCubicIndex147

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleCubic147
open C99ArrayReference (State Name)
open C99LoopScalar141 (Cell)
open FftTripleLoadState147 (state)

def real (s : State) (words : Fin 6 → BitVec 64) (q : Nat) :=
  FftLocalCells140.put (state s words 6) "xr".toList (FftCubicWord147.pair q).1
def after (s : State) (words : Fin 6 → BitVec 64) (q : Nat) :=
  FftLocalCells140.put (real s words q) "xi".toList (FftCubicWord147.pair q).2

theorem real_uninitialized (s : State) (words : Fin 6 → BitVec 64) :
    (state s words 6).locals "xr".toList=some (.uint64,none) :=
  (FftTripleLoadState147.outside s words 6 "xr".toList (by decide +kernel)).trans
    (FftTripleDeclare147.uninitialized s "xr".toList (by decide +kernel))

theorem imag_uninitialized (s : State) (words : Fin 6 → BitVec 64) (q : Nat) :
    (real s words q).locals "xi".toList=some (.uint64,none) :=
  (FftLocalCells140.outside _ _ _ _ (by decide)).trans
    ((FftTripleLoadState147.outside s words 6 "xi".toList (by decide +kernel)).trans
      (FftTripleDeclare147.uninitialized s "xi".toList (by decide +kernel)))

theorem real_source (s : State) (words : Fin 6 → BitVec 64) (q : Nat) (bound : q<2048)
    (vCell : Cell s "v".toList (2*q))
    (binding : s.arrays "fpr_gm3_cubic".toList=some (FftGlobalMemory.pointer .cubic))
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment s.heap) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part 10)
      (state s words 6) ⟨real s words q,.normal⟩ := by
  rw [FftCubicIndex147.real_shape]
  have kept := FftTripleLoadState147.metadata s words 6
  apply FftGroupExec143.load (state s words 6) "xr".toList "fpr_gm3_cubic".toList FftCubicIndex147.realIndex
    {FftGlobalMemory.pointer .cubic with index := 2*q} (FftCubicWord147.pair q).1 (real_uninitialized s words)
  · exact FftCubicIndex147.real_address (state s words 6) q bound
      ((FftTripleLoadState147.scope_outside s words 6 "v".toList (by decide +kernel)).trans vCell)
      ((congrFun kept.2.1 "fpr_gm3_cubic".toList).trans binding)
  · rw [kept.1]
    exact FftCubicWord147.real_load s.heap pinned q bound

theorem imag_source (s : State) (words : Fin 6 → BitVec 64) (q : Nat) (bound : q<2048)
    (vCell : Cell s "v".toList (2*q))
    (binding : s.arrays "fpr_gm3_cubic".toList=some (FftGlobalMemory.pointer .cubic))
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment s.heap) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part 11)
      (real s words q) ⟨after s words q,.normal⟩ := by
  rw [FftCubicIndex147.imag_shape]
  have kept := FftTripleLoadState147.metadata s words 6
  apply FftGroupExec143.load (real s words q) "xi".toList "fpr_gm3_cubic".toList FftCubicIndex147.imagIndex
    {FftGlobalMemory.pointer .cubic with index := 2*q+1} (FftCubicWord147.pair q).2 (imag_uninitialized s words q)
  · exact FftCubicIndex147.imag_address (real s words q) q bound
      ((FftLocalCells140.outside _ _ _ _ (by decide)).trans
        ((FftTripleLoadState147.scope_outside s words 6 "v".toList (by decide +kernel)).trans vCell))
      ((congrFun kept.2.1 "fpr_gm3_cubic".toList).trans binding)
  · change C99MemoryReference.Load64 (state s words 6).heap _ _
    rw [kept.1]
    exact FftCubicWord147.imag_load s.heap pinned q bound

theorem real_cell (s : State) (words : Fin 6 → BitVec 64) (q : Nat) :
    (after s words q).locals "xr".toList=some (.uint64,some (.uint64 (FftCubicWord147.pair q).1)) :=
  (FftLocalCells140.outside (real s words q) "xi".toList "xr".toList (FftCubicWord147.pair q).2 (by decide)).trans
    (FftLocalCells140.cell_at (state s words 6) "xr".toList (FftCubicWord147.pair q).1)

theorem imag_cell (s : State) (words : Fin 6 → BitVec 64) (q : Nat) :
    (after s words q).locals "xi".toList=some (.uint64,some (.uint64 (FftCubicWord147.pair q).2)) := FftLocalCells140.cell_at (real s words q) "xi".toList (FftCubicWord147.pair q).2

theorem input_cell (s : State) (words : Fin 6 → BitVec 64) (q : Nat) (i : Fin 6) :
    (after s words q).locals (FftTripleLoadShape147.name i)=some (.uint64,some (.uint64 (words i))) := by
  have notXr : FftTripleLoadShape147.name i≠"xr".toList := by fin_cases i <;> decide +kernel
  have notXi : FftTripleLoadShape147.name i≠"xi".toList := by fin_cases i <;> decide +kernel
  exact (FftLocalCells140.outside _ _ _ _ notXi).trans
    ((FftLocalCells140.outside _ _ _ _ notXr).trans (FftTripleLoadState147.written s words 6 i i.isLt (Nat.le_refl _)))

theorem declared (s : State) (words : Fin 6 → BitVec 64) (q : Nat) :
    C99Declared147.Declared (after s words q) FftTripleDeclare147.names :=
  C99Declared147.put _ _ _ _ (C99Declared147.put _ _ _ _ (FftTripleLoadState147.declared s words 6))

theorem outside (s : State) (words : Fin 6 → BitVec 64) (q : Nat) (key : Name)
    (absent : key∉FftTripleDeclare147.names) : (after s words q).locals key=s.locals key := by
  have notXr : key≠"xr".toList := by intro same; subst key; exact absent (by decide +kernel)
  have notXi : key≠"xi".toList := by intro same; subst key; exact absent (by decide +kernel)
  exact (FftLocalCells140.outside _ _ _ _ notXi).trans
    ((FftLocalCells140.outside _ _ _ _ notXr).trans (FftTripleLoadState147.scope_outside s words 6 key absent))

theorem metadata (s : State) (words : Fin 6 → BitVec 64) (q : Nat) :
    (after s words q).heap=s.heap ∧ (after s words q).arrays=s.arrays ∧
    (after s words q).globals=s.globals ∧ (after s words q).tables=s.tables := FftTripleLoadState147.metadata s words 6

end FT1536.Source3.FftTripleCubic147
