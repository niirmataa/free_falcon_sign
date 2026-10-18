import Source3.NttTripleLoop184
import Source3.GeneratorTablePointer181

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttTripleSquare184
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)
open NttFirstFixed182 (Fixed)

def square (x p p0i : BitVec 32) := KeygenModpWord.montgomery x x p p0i
def after (s : State) (x p p0i : BitVec 32) := ModularAtoms178.set s "w" (square x p p0i)

theorem source (s : State) (a gm : ArrayPointer) (p p0i w x : BitVec 32) (f : Fixed s a gm p p0i w)
    (read : Load32 s.heap (element gm 1) x) :
    Exec KeygenNttForwardPrograms.wSquared s ⟨after s x p p0i,.normal⟩ := by
  have value : C99ModularReference.Eval s (.load32 "gm".toList (KeygenNttForwardPrograms.num 1)) (.uint32 x) :=
    .load32 _ _ (element gm 1) x
      (GeneratorTablePointer181.literal s "gm" gm 1 (by decide) f.gmBinding (NttReadFacts182.allocated _ _ _ read)) read
  exact ModularAtoms178.assign s "w" (some (.uint32 w)) _ (square x p p0i) f.wCell
    (ModularAtoms178.mont s _ _ x x p p0i value value f.pCell f.iCell)

theorem fixed (s : State) (a gm : ArrayPointer) (p p0i w x : BitVec 32) (f : Fixed s a gm p p0i w) :
    Fixed (after s x p p0i) a gm p p0i (square x p p0i) :=
  ⟨f.pCell,f.iCell,ModularAtoms178.slot s "w" (square x p p0i),f.nCell,f.hnCell,f.stride,
    f.aBinding,f.gmBinding,f.width,f.capacity,f.allocated,f.writable,f.initialized⟩

end FT1536.Source3.NttTripleSquare184
