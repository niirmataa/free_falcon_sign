import Source3.SelectedGeneratorCubeFrame180

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorSquareDomains181
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Memory Allocated)
open GeneratorCubeFixed180 (Fixed)
open KeygenSmallOutput (element)
open Word32Initialized180 (At)

def From (heap : Memory) (gm igm : ArrayPointer) (lo : Nat) : Prop :=
  ∀ j, lo ≤ j → j < 1024 → At heap (element gm j) ∧ At heap (element igm j)

theorem from_transport (before after : Memory) (gm igm : ArrayPointer) (lo : Nat)
    (frame : C99InitializationTrace.Preserves before after) (data : From before gm igm lo) :
    From after gm igm lo := fun j lower upper =>
  ⟨Word32Initialized180.transported _ _ _ frame (data j lower upper).1,
    Word32Initialized180.transported _ _ _ frame (data j lower upper).2⟩

theorem transported (code : C99ModularReference.Stmt) (s : State) (out : C99ProcedureReference.Result)
    (gm igm : ArrayPointer) (p p0i : BitVec 32) (fixed : Fixed s gm igm p p0i)
    (supported : KeygenMkgm3Control.supported code=true)
    (writes : KeygenMkgm3Control.writes code ⊆ ["v".toList,"u".toList,"w".toList])
    (source : C99ModularReference.Exec code s out) : Fixed out.state gm igm p p0i := by
  have frame := KeygenMkgm3Control.frame code s out supported source
  have memory := C99InitializationTrace.steps_preserve s.heap out.state.heap
    (KeygenMkgm3RevMemory.memory_steps code s out source)
  have keep (name : C99ArrayReference.Name) (outside : name∉["v".toList,"u".toList,"w".toList]) :
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

end FT1536.Source3.GeneratorSquareDomains181
