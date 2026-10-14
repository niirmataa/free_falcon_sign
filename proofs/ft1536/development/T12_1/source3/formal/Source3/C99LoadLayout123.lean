import Source3.C99FiniteWords123

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99LoadLayout123
open C99MemoryReference

/-- A change of descriptor needs its own allocation and width checks;
    equality of byte addresses alone does not confer pointer legality. -/
theorem load32 (heap : Memory) (p q : ArrayPointer) (word : BitVec 32)
    (source : Load32 heap p word) (allocated : Allocated heap q) (width : q.elementBytes=4)
    (block : q.block=p.block) (offset : q.offset=p.offset) : Load32 heap q word := by
  cases source with
  | load bytes _ _ initialized =>
      exact .load heap q bytes allocated width (fun i => by rw [block,offset]; exact initialized i)

theorem load64 (heap : Memory) (p q : ArrayPointer) (word : BitVec 64)
    (source : Load64 heap p word) (allocated : Allocated heap q) (width : q.elementBytes=8)
    (block : q.block=p.block) (offset : q.offset=p.offset) : Load64 heap q word := by
  cases source with
  | load bytes _ _ initialized =>
      exact .load heap q bytes allocated width (fun i => by rw [block,offset]; exact initialized i)

theorem load16 (heap : Memory) (p q : ArrayPointer) (word : BitVec 16)
    (source : C99NarrowReads.Load16 heap p word) (allocated : Allocated heap q) (width : q.elementBytes=2)
    (block : q.block=p.block) (offset : q.offset=p.offset) : C99NarrowReads.Load16 heap q word := by
  cases source with
  | load bytes _ _ initialized =>
      exact .load heap q bytes allocated width (fun i => by rw [block,offset]; exact initialized i)

end FT1536.Source3.C99LoadLayout123
