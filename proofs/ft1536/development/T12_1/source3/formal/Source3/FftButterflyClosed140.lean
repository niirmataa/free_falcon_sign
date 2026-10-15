import Source3.FftButterflyExec140
import Source3.FftRestoreState140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftButterflyClosed140
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open FftMulStates140 (Words)
open FftButterflyStates140
open FftLoadShape140 (names)

theorem locals_restored (before : State) (x : Words) (sr si : BitVec 64) :
    C99ArrayReference.restoreScope before (afterMul before x sr si) names []=before := by
  rw [afterMul,FftMulStates140.output]
  rw [FftRestoreState140.inside before
    (FftLocalCells140.put (FftLoadStates140.s4 before x) "a1r".toList (FftMulStates140.real (mulWords x sr si)))
    names "a1i".toList (FftMulStates140.imag (mulWords x sr si)) (by decide)]
  rw [FftRestoreState140.inside before (FftLoadStates140.s4 before x)
    names "a1r".toList (FftMulStates140.real (mulWords x sr si)) (by decide)]
  rw [FftLoadStates140.s4,FftRestoreState140.inside before (FftLoadStates140.s3 before x) names "a1i".toList x.bi (by decide)]
  rw [FftLoadStates140.s3,FftRestoreState140.inside before (FftLoadStates140.s2 before x) names "a1r".toList x.br (by decide)]
  rw [FftLoadStates140.s2,FftRestoreState140.inside before (FftLoadStates140.s1 before x) names "a0i".toList x.ai (by decide)]
  rw [FftLoadStates140.s1,FftRestoreState140.inside before (FftLoadStates140.declared before) names "a0r".toList x.ar (by decide)]
  rw [FftLoadStates140.declared,FftRestoreState140.declarations before before names names .u64 (fun _ h => h),
    FftRestoreState140.self]

theorem restored (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64) :
    C99ArrayReference.restoreScope before (afterSub before x p sr si) names []=output before x p sr si := by
  rw [final_shape]
  change {C99ArrayReference.restoreScope before (afterMul before x sr si) names [] with heap := finalHeap before x p sr si}=
    {before with heap := finalHeap before x p sr si}
  rw [locals_restored]

/-- One parametric source theorem for the entire original butterfly body.
    Entry carries source-evaluated legal addresses, incoming words, writable
    objects and the two twiddle cells. No result or callee contract is assumed. -/
theorem source (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64)
    (entry : FftLoadExec140.Entry before x p sr si) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.butterflyBody before
      ⟨output before x p sr si,.normal⟩ := by
  rw [← restored before x p sr si]
  exact FftButterflyExec140.scoped_source before x p sr si entry

theorem locals_same (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64) :
    (output before x p sr si).locals=before.locals := rfl

theorem arrays_same (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64) :
    (output before x p sr si).arrays=before.arrays := rfl

theorem globals_same (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64) :
    (output before x p sr si).globals=before.globals := rfl

theorem tables_same (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64) :
    (output before x p sr si).tables=before.tables := rfl

theorem sizes_same (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64) :
    (output before x p sr si).heap.size=before.heap.size := rfl

theorem writable_same (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64) :
    (output before x p sr si).heap.writable=before.heap.writable := rfl

theorem other_byte (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64) (block offset : Nat)
    (outside : ∀ i, block≠(p i).block ∨ offset<(p i).offset ∨ (p i).offset+8≤offset) :
    (output before x p sr si).heap.bytes block offset=before.heap.bytes block offset := by
  rw [← restored before x p sr si]
  change (afterSub before x p sr si).heap.bytes block offset=before.heap.bytes block offset
  exact (FftPairClosed140.other_byte .sub (afterAdd before x p sr si) (pairWords x sr si) (p 2) (p 3)
    block offset (outside 2) (outside 3)).trans
    (FftPairClosed140.other_byte .add (afterMul before x sr si) (pairWords x sr si) (p 0) (p 1)
      block offset (outside 0) (outside 1))

end FT1536.Source3.FftButterflyClosed140
