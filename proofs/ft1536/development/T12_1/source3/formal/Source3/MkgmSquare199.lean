import Source3.MkgmRowLoop198
import Source3.MkgmControl199
import Source3.GeneratorSquareBody181

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MkgmSquare199
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated Memory)
open KeygenModpR2Exec (Slot)
open KeygenSmallOutput (element)
open MkgmParams198 (Level half count)
open Word32Initialized180 (At)

structure Fixed (l : Level) (s : State) (gm igm : ArrayPointer) (p p0i : BitVec 32) : Prop where
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  gBinding : s.arrays "gm".toList=some gm
  iBinding : s.arrays "igm".toList=some igm
  gWidth : gm.elementBytes=4
  iWidth : igm.elementBytes=4
  gAllocated : ∀ j<count l, Allocated s.heap (element gm j)
  iAllocated : ∀ j<count l, Allocated s.heap (element igm j)
  gWritable : s.heap.writable gm.block=true
  iWritable : s.heap.writable igm.block=true

def From (l : Level) (h : Memory) (gm igm : ArrayPointer) (lo : Nat) : Prop :=
  ∀ j : Nat, lo≤j → j<count l → At h (element gm j) ∧ At h (element igm j)

theorem from_transport (l : Level) (a b : Memory) (gm igm : ArrayPointer) (lo : Nat)
    (preserves : C99InitializationTrace.Preserves a b) (old : From l a gm igm lo) : From l b gm igm lo :=
  fun j lower upper => ⟨Word32Initialized180.transported _ _ _ preserves (old j lower upper).1,
    Word32Initialized180.transported _ _ _ preserves (old j lower upper).2⟩

theorem transported (l : Level) (code : C99ModularReference.Stmt) (s : State) (out : C99ProcedureReference.Result)
    (gm igm : ArrayPointer) (p p0i : BitVec 32) (fixed : Fixed l s gm igm p p0i)
    (supported : KeygenMkgm3Control.supported code=true)
    (writes : KeygenMkgm3Control.writes code ⊆ ["u".toList,"v".toList,"w".toList])
    (source : C99ModularReference.Exec code s out) : Fixed l out.state gm igm p p0i := by
  have frame := KeygenMkgm3Control.frame code s out supported source
  have stable := KeygenMemoryStability.modular code s out source
  have keep (name : C99ArrayReference.Name) (absent : name∉["u".toList,"v".toList,"w".toList]) :
      out.state.locals name=s.locals name := frame.2.2 name (fun h => absent (writes h))
  refine ⟨(keep _ (by decide)).trans fixed.pCell,(keep _ (by decide)).trans fixed.iCell,
    ?_,?_,fixed.gWidth,fixed.iWidth,?_,?_,?_,?_⟩
  · rw [frame.2.1]; exact fixed.gBinding
  · rw [frame.2.1]; exact fixed.iBinding
  · intro j bound; simpa only [Allocated,stable.size] using fixed.gAllocated j bound
  · intro j bound; simpa only [Allocated,stable.size] using fixed.iAllocated j bound
  · rw [stable.writable]; exact fixed.gWritable
  · rw [stable.writable]; exact fixed.iWritable

end FT1536.Source3.MkgmSquare199
