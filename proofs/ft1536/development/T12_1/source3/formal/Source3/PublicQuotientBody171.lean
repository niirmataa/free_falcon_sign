import Source3.PublicQuotientAtoms171

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicQuotientBody171
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open C99LoopScalar141 (Cell)
open KeygenPublicExec (Exec)
open KeygenPublicInputProgram (signed index)
open KeygenSmallOutput (element)
open PublicMiddleWrites161 (MemoryFrame)

structure Fixed (s : State) (t h : ArrayPointer) : Prop where
  hBinding : s.arrays "h".toList=some h
  tBinding : s.arrays "t".toList=some t
  nCell : Cell s "n".toList 1536
  profile : KeygenPublicTableAtoms.Slot s "logn" 10
  ternary : KeygenPublicForwardWrapper.Ternary s
  separate : h.block≠t.block
  data : PublicForwardMemory167.Data s.heap h
  nonzero : ∀ j, j<1536 → ∃ w : BitVec 16, C99NarrowReads.Load16 s.heap (element t j) w ∧ w.toNat≠0

theorem source (s : State) (t h : ArrayPointer) (i : Nat) (inside : i<1536)
    (fixed : Fixed s t h) (counter : Cell s "u".toList i) :
    ∃ after, Exec KeygenPublicSource.program signed KeygenPublicSuffixProgram.body s ⟨after,.normal⟩ ∧
      Fixed after t h ∧ Cell after "u".toList i ∧ MemoryFrame s after h := by
  obtain ⟨x,hRead⟩ := fixed.data.written i inside
  obtain ⟨y,tRead,nonzero⟩ := fixed.nonzero i inside
  have hAllocated := (KeygenPublicRangeMemory.load_allocated _ _ _ hRead).1
  have tAllocated := (KeygenPublicRangeMemory.load_allocated _ _ _ tRead).1
  have hWidth := (KeygenPublicRangeMemory.load_allocated _ _ _ hRead).2
  have hAddress := PublicNat158.address s "h".toList h i (by omega)
    (by have cap:=hAllocated.2.2.1; change h.index+i<h.count at cap; omega) fixed.hBinding counter
  have tAddress := PublicNat158.address s "t".toList t i (by omega)
    (by have cap:=tAllocated.2.2.1; change t.index+i<t.count at cap; omega) fixed.tBinding counter
  let word := KeygenPublicWord.narrow (.uint32 (PublicQuotientAtoms171.quotient x y))
  let heap := Word16Memory158.write s.heap (element h i) word
  let after : State := {s with heap := heap}
  have write := Word16Memory158.source s.heap (element h i) word hAllocated hWidth fixed.data.writable
  have test := PublicQuotientAtoms171.test s (element t i) y tAddress tRead nonzero
  have store : Exec KeygenPublicSource.program signed KeygenPublicSuffixProgram.ternaryStore s ⟨after,.normal⟩ :=
    .store _ _ _ _ _ heap (element h i) (.uint32 (PublicQuotientAtoms171.quotient x y)) hAddress
      (PublicQuotientAtoms171.quotient_eval s (element h i) (element t i) x y hAddress tAddress hRead tRead) write
  have divide : Exec KeygenPublicSource.program signed KeygenPublicSuffixProgram.divide s ⟨after,.normal⟩ :=
    .branchTrue _ _ _ _ _ (.int32 1) (.scalar _ _ (.variable _ _ _ fixed.ternary)) (by decide) store
  have run : Exec KeygenPublicSource.program signed KeygenPublicSuffixProgram.body s ⟨after,.normal⟩ :=
    .scope _ _ _ _ _ (.seqNormal _ _ _ s _ test (.seqNormal _ _ _ after _ divide (.skip after)))
  have memory := PublicInitializedFrame164.store_frame _ _ _ _ write
  refine ⟨after,run,?_,counter,?_⟩
  · refine ⟨fixed.hBinding,fixed.tBinding,fixed.nCell,fixed.profile,fixed.ternary,fixed.separate,
      ⟨fixed.data.writable,fun j hj => memory.written _ (fixed.data.written j hj)⟩,?_⟩
    intro j hj
    obtain ⟨w,read,nz⟩ := fixed.nonzero j hj
    exact ⟨w,Word16Memory158.outside s.heap (element h i) (element t j) word w
      (Or.inl fixed.separate) read,nz⟩
  · refine ⟨rfl,rfl,?_,?_⟩
    · intro b different offset
      exact write.2.2.2.2.2.2 b offset (Or.inl different)
    · intro j old
      exact memory.written _ old

end FT1536.Source3.PublicQuotientBody171
