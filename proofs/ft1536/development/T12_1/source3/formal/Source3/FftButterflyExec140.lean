import Source3.FftButterflyStates140
import Source3.C99Chain139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftButterflyExec140
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Exec)
open FftMulStates140 (Words)
open FftButterflyStates140

theorem multiply (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64)
    (entry : FftLoadExec140.Entry before x p sr si) :
    Exec KeygenSearchFft.program FftMulShape140.sourcePart (FftLoadStates140.s4 before x)
      ⟨afterMul before x sr si,.normal⟩ :=
  FftMulClosed140.in_butterfly (FftLoadStates140.s4 before x) (mulWords x sr si) (mul_entry before x p sr si entry)

theorem add (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64)
    (entry : FftLoadExec140.Entry before x p sr si) :
    Exec KeygenSearchFft.program (FftPairShape140.sourcePart .add) (afterMul before x sr si)
      ⟨afterAdd before x p sr si,.normal⟩ := by
  apply FftPairClosed140.in_butterfly .add (afterMul before x sr si) (pairWords x sr si) (p 0) (p 1)
    (pair_entry before x sr si)
  · rw [FftLoadShape140.add_real]
    exact address_after_mul before x p sr si entry 0
  · rw [FftLoadShape140.add_imag]
    exact address_after_mul before x p sr si entry 1
  · exact FftLoadExec140.allocated_of_load before.heap (p 0) (FftLoadStates140.value x 0) (entry.read 0)
  · exact FftLoadExec140.allocated_of_load before.heap (p 1) (FftLoadStates140.value x 1) (entry.read 1)
  · exact FftLoadExec140.width_of_load _ _ _ (entry.read 0)
  · exact FftLoadExec140.width_of_load _ _ _ (entry.read 1)
  · exact entry.writable 0
  · exact entry.writable 1

theorem subtract (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64)
    (entry : FftLoadExec140.Entry before x p sr si) :
    Exec KeygenSearchFft.program (FftPairShape140.sourcePart .sub) (afterAdd before x p sr si)
      ⟨afterSub before x p sr si,.normal⟩ := by
  apply FftPairClosed140.in_butterfly .sub (afterAdd before x p sr si) (pairWords x sr si) (p 2) (p 3)
    (pair_entry_after_add before x p sr si)
  · rw [FftLoadShape140.sub_real]
    exact address_after_add before x p sr si entry 2
  · rw [FftLoadShape140.sub_imag]
    exact address_after_add before x p sr si entry 3
  · exact FftLoadExec140.allocated_of_load before.heap (p 2) (FftLoadStates140.value x 2) (entry.read 2)
  · exact FftLoadExec140.allocated_of_load before.heap (p 3) (FftLoadStates140.value x 3) (entry.read 3)
  · exact FftLoadExec140.width_of_load _ _ _ (entry.read 2)
  · exact FftLoadExec140.width_of_load _ _ _ (entry.read 3)
  · exact entry.writable 2
  · exact entry.writable 3

theorem internal_source (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64)
    (entry : FftLoadExec140.Entry before x p sr si) :
    Exec KeygenSearchFft.program (C99ProcedureParser.chain [FftLoadShape140.declaration,
      FftLoadShape140.load 0,FftLoadShape140.load 1,FftLoadShape140.load 2,FftLoadShape140.load 3,
      FftMulShape140.sourcePart,FftPairShape140.sourcePart .add,FftPairShape140.sourcePart .sub])
      before ⟨afterSub before x p sr si,.normal⟩ := by
  apply C99Chain139.append KeygenSearchFft.program
    [FftLoadShape140.declaration,FftLoadShape140.load 0,FftLoadShape140.load 1,FftLoadShape140.load 2,FftLoadShape140.load 3]
    [FftMulShape140.sourcePart,FftPairShape140.sourcePart .add,FftPairShape140.sourcePart .sub]
    before (FftLoadStates140.s4 before x) _ (FftLoadExec140.source before x p sr si entry)
  exact .seqNormal _ _ _ _ _ (multiply before x p sr si entry)
    (.seqNormal _ _ _ _ _ (add before x p sr si entry)
      (.seqNormal _ _ _ _ _ (subtract before x p sr si entry) (.base _ _ _ (.skip _))))

theorem scoped_source (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64)
    (entry : FftLoadExec140.Entry before x p sr si) :
    Exec KeygenSearchFft.program FftMiddleShape139.butterflyBody before
      ⟨C99ArrayReference.restoreScope before (afterSub before x p sr si) FftLoadShape140.names [],.normal⟩ := by
  rw [FftLoadShape140.body_source]
  exact .scope _ _ _ before ⟨afterSub before x p sr si,.normal⟩ (internal_source before x p sr si entry)

end FT1536.Source3.FftButterflyExec140
