import Source3.SelectedGeneratorInverseFacts178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorRowFixed179
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)
open KeygenSmallOutput (element)

structure Fixed (s : State) (gm igm rev : ArrayPointer) (p p0i g2 g4 ig2 ig4 : BitVec 32) : Prop where
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  g2Cell : Slot s "g2" g2
  g4Cell : Slot s "g4" g4
  ig2Cell : Slot s "ig2" ig2
  ig4Cell : Slot s "ig4" ig4
  kCell : Slot s "k" 1
  bCell : USlot s "b" 512
  gBinding : s.arrays "gm".toList=some gm
  iBinding : s.arrays "igm".toList=some igm
  table : KeygenMkgm3RevMemory.Rev s rev
  gWidth : gm.elementBytes=4
  iWidth : igm.elementBytes=4
  gAllocated : ∀ j<1024, Allocated s.heap (element gm j)
  iAllocated : ∀ j<1024, Allocated s.heap (element igm j)
  gWritable : s.heap.writable gm.block=true
  iWritable : s.heap.writable igm.block=true

theorem transported (code : C99ModularReference.Stmt) (s : State) (out : C99ProcedureReference.Result)
    (gm igm rev : ArrayPointer) (p p0i g2 g4 ig2 ig4 : BitVec 32)
    (fixed : Fixed s gm igm rev p p0i g2 g4 ig2 ig4)
    (supported : KeygenMkgm3Control.supported code=true)
    (writes : KeygenMkgm3Control.writes code ⊆ ["x".toList,"ix".toList,"u".toList])
    (source : C99ModularReference.Exec code s out) : Fixed out.state gm igm rev p p0i g2 g4 ig2 ig4 := by
  have frame := KeygenMkgm3Control.frame code s out supported source
  have stable := KeygenMemoryStability.modular code s out source
  have keep (name : C99ArrayReference.Name) (outside : name∉["x".toList,"ix".toList,"u".toList]) :
      out.state.locals name=s.locals name := frame.2.2 name (fun member => outside (writes member))
  refine ⟨(keep _ (by decide)).trans fixed.pCell,(keep _ (by decide)).trans fixed.iCell,
    (keep _ (by decide)).trans fixed.g2Cell,(keep _ (by decide)).trans fixed.g4Cell,
    (keep _ (by decide)).trans fixed.ig2Cell,(keep _ (by decide)).trans fixed.ig4Cell,
    (keep _ (by decide)).trans fixed.kCell,(keep _ (by decide)).trans fixed.bCell,
    ?_,?_,KeygenMkgm3RevMemory.transported code s out rev supported fixed.table source,
    fixed.gWidth,fixed.iWidth,?_,?_,?_,?_⟩
  · rw [frame.2.1]; exact fixed.gBinding
  · rw [frame.2.1]; exact fixed.iBinding
  · intro j hj; simpa only [Allocated,stable.size] using fixed.gAllocated j hj
  · intro j hj; simpa only [Allocated,stable.size] using fixed.iAllocated j hj
  · rw [stable.writable]; exact fixed.gWritable
  · rw [stable.writable]; exact fixed.iWritable

end FT1536.Source3.GeneratorRowFixed179
