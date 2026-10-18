import Source3.SelectedGeneratorInitialized180

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorCubeFixed180
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenModpR2Exec (Slot)
open KeygenSmallOutput (element)
open Word32Initialized180 (At)

structure Fixed (s : State) (gm igm : ArrayPointer) (p p0i : BitVec 32) : Prop where
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  kCell : Slot s "k" 8
  gBinding : s.arrays "gm".toList=some gm
  iBinding : s.arrays "igm".toList=some igm
  gWidth : gm.elementBytes=4
  iWidth : igm.elementBytes=4
  gAllocated : ∀ j<1024, Allocated s.heap (element gm j)
  iAllocated : ∀ j<1024, Allocated s.heap (element igm j)
  gWritable : s.heap.writable gm.block=true
  iWritable : s.heap.writable igm.block=true
  gUpper : ∀ j, 512≤j → j<1024 → At s.heap (element gm j)
  iUpper : ∀ j, 512≤j → j<1024 → At s.heap (element igm j)

theorem transported (code : C99ModularReference.Stmt) (s : State) (out : C99ProcedureReference.Result)
    (gm igm : ArrayPointer) (p p0i : BitVec 32) (fixed : Fixed s gm igm p p0i)
    (supported : KeygenMkgm3Control.supported code=true)
    (writes : KeygenMkgm3Control.writes code ⊆ ["y".toList,"z".toList,"u".toList])
    (source : C99ModularReference.Exec code s out) : Fixed out.state gm igm p p0i := by
  have frame := KeygenMkgm3Control.frame code s out supported source
  have memory := C99InitializationTrace.steps_preserve s.heap out.state.heap
    (KeygenMkgm3RevMemory.memory_steps code s out source)
  have keep (name : C99ArrayReference.Name) (outside : name∉["y".toList,"z".toList,"u".toList]) :
      out.state.locals name=s.locals name := frame.2.2 name (fun member => outside (writes member))
  refine ⟨(keep _ (by decide)).trans fixed.pCell,(keep _ (by decide)).trans fixed.iCell,
    (keep _ (by decide)).trans fixed.kCell,?_,?_,fixed.gWidth,fixed.iWidth,?_,?_,?_,?_,?_,?_⟩
  · rw [frame.2.1]; exact fixed.gBinding
  · rw [frame.2.1]; exact fixed.iBinding
  · intro j hj; simpa only [Allocated,memory.size] using fixed.gAllocated j hj
  · intro j hj; simpa only [Allocated,memory.size] using fixed.iAllocated j hj
  · rw [memory.writable]; exact fixed.gWritable
  · rw [memory.writable]; exact fixed.iWritable
  · intro j lo hi; exact Word32Initialized180.transported _ _ _ memory (fixed.gUpper j lo hi)
  · intro j lo hi; exact Word32Initialized180.transported _ _ _ memory (fixed.iUpper j lo hi)

end FT1536.Source3.GeneratorCubeFixed180
