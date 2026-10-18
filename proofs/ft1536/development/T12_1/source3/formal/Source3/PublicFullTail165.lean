import Source3.PublicTripleStart165

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicFullTail165
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenNttLoopSupport (USlot u64)
open PublicRoundContext163 (Arrays)

theorem source (s : State) (a gm : ArrayPointer) (ctx : Arrays s a gm)
    (firstEntry : PublicTailFirst159.TailEntry s a gm)
    (cubic : s.arrays "gm_cubic".toList=some gm)
    (tCell : ∃ old, s.locals "t".toList=some (.uint64,old))
    (mCell : ∃ old, s.locals "m".toList=some (.uint64,old))
    (vCell : ∃ old, s.locals "v".toList=some (.uint64,old)) :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicForwardProgram.tail s ⟨after,.normal⟩ ∧
      PublicTripleLoop165.Fixed after a gm ∧ USlot after "u" 1536 ∧ USlot after "v" 1024 := by
  obtain ⟨middle,prefixRun,arrays,length,profile,uSlot,lastV,wCell,bindings⟩ :=
    PublicTailPrefix164.source s a gm ctx firstEntry tCell mCell vCell
  have cubicMiddle : middle.arrays "gm_cubic".toList=some gm := by rw [bindings]; exact cubic
  obtain ⟨after,lastRun,fixed,lastU,lastV⟩ := PublicTripleStart165.source middle a gm arrays cubicMiddle
    length profile ⟨some (u64 768),uSlot⟩ lastV wCell
  exact ⟨after,PublicTailPrefix164.continue_tail s middle ⟨after,.normal⟩ prefixRun lastRun,fixed,lastU,lastV⟩

end FT1536.Source3.PublicFullTail165
