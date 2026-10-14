import Source3.KeygenTableObjects127

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenFftObjects127
open C99MemoryReference
open C99FiniteMemory114 (Heap memory)
open KeygenTableObjects127 (table64 pointer64)

def square (before : Heap) : Heap := table64 before 1 (FftTableSources.words .square)
def heap (before : Heap) : Heap := table64 (square before) 2 (FftTableSources.words .cubic)

theorem word_fits (table : FftTableParser.Table) : 8*(FftTableSources.words table).length<2^64 := by
  rw [FftTableSources.words_length]
  cases table <;> decide

theorem pinned (before : Heap) : CertificateM0Environment.Pinned FftGlobalMemory.environment (memory (heap before)) := by
  refine ⟨rfl,?_⟩
  intro table i bound
  cases table with
  | square =>
      have frame := C99FiniteInit123.outside (square before) 2 (8*(FftTableSources.words .cubic).length) false
        (C99FiniteInit123.words64 (fun j => (FftTableSources.words .cubic)[j.val])) 1 (by decide)
      have loaded := KeygenCallerShape123.load64_block _ _ _ _ frame
        (KeygenTableObjects127.read64 before 1 (FftTableSources.words .square) (word_fits .square) ⟨i,bound⟩)
      have pointer : ({pointer64 1 (FftTableSources.words .square) with index := i} : ArrayPointer)=
          {FftGlobalMemory.pointer .square with index := i} := by
        simp [pointer64,FftGlobalMemory.pointer,FftGlobalMemory.block,FftTableSources.words_length]
      rw [pointer] at loaded
      exact ⟨loaded,frame.2.1.trans (KeygenTableObjects127.readonly64 before 1 _)⟩
  | cubic =>
      have loaded := KeygenTableObjects127.read64 (square before) 2 (FftTableSources.words .cubic) (word_fits .cubic) ⟨i,bound⟩
      have pointer : ({pointer64 2 (FftTableSources.words .cubic) with index := i} : ArrayPointer)=
          {FftGlobalMemory.pointer .cubic with index := i} := by
        simp [pointer64,FftGlobalMemory.pointer,FftGlobalMemory.block,FftTableSources.words_length]
      rw [pointer] at loaded
      exact ⟨loaded,KeygenTableObjects127.readonly64 (square before) 2 _⟩

theorem pinned_swap (before : Memory) (block : Nat) (notSquare : block≠1) (notCubic : block≠2)
    (source : CertificateM0Environment.Pinned FftGlobalMemory.environment before) :
    CertificateM0Environment.Pinned FftGlobalMemory.environment (KeygenMakeWorkspaceRelocation.swap block before) := by
  refine ⟨rfl,?_⟩
  intro table i bound
  have loaded := KeygenMakeWorkspaceRelocation.load64_forward block before
    {FftGlobalMemory.pointer table with index := i} (FftTableSources.words table)[i] (source.2 table i bound).1
  have fixed : KeygenMakeWorkspaceRelocation.swapPtr block {FftGlobalMemory.pointer table with index := i}=
      {FftGlobalMemory.pointer table with index := i} := by
    cases table <;> simp [KeygenMakeWorkspaceRelocation.swapPtr,KeygenMakeWorkspaceRelocation.swapBlock,
      FftGlobalMemory.pointer,FftGlobalMemory.block,Ne.symm notSquare,Ne.symm notCubic]
  rw [fixed] at loaded
  refine ⟨loaded,?_⟩
  have readonly := (source.2 table i bound).2
  cases table <;> simpa [KeygenMakeWorkspaceRelocation.swap,KeygenMakeWorkspaceRelocation.swapBlock,
    FftGlobalMemory.block,Ne.symm notSquare,Ne.symm notCubic] using readonly

end FT1536.Source3.KeygenFftObjects127
