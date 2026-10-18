import Source3.NttReadFacts182
import Source3.NttPrologue182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttFirstSetup182
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated Load32)
open KeygenSmallOutput (element)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)

structure Input (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) : Prop where
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  logn : Slot s "logn" 10
  full : Slot s "full" 1
  stride : USlot s "stride" 1
  aBinding : s.arrays "a".toList=some a
  gmBinding : s.arrays "gm".toList=some gm
  width : a.elementBytes=4
  capacity : a.index+1536≤a.count
  allocated : ∀ j<1536, Allocated s.heap (element a j)
  writable : s.heap.writable a.block=true
  initialized : ∀ j<1536, Word32Initialized180.At s.heap (element a j)
  twiddle : Load32 s.heap (element gm 1) w

def ready := KeygenNttForwardExec.ready
def after (s : State) (w : BitVec 32) := ModularAtoms178.set (ready s) "w" w

theorem source (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (input : Input s a gm p p0i w) :
    C99ModularReference.Exec KeygenNttForwardPrograms.wAssign (ready s) ⟨after s w,.normal⟩ :=
  ModularAtoms178.assign (ready s) "w" none _ w (NttPrologue182.w_declared s)
    (.load32 "gm".toList (KeygenNttForwardPrograms.num 1) (element gm 1) w
      (GeneratorTablePointer181.literal (ready s) "gm" gm 1 (by decide) input.gmBinding
        (NttReadFacts182.allocated s.heap (element gm 1) w input.twiddle)) input.twiddle)

theorem fixed (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (input : Input s a gm p p0i w) :
    NttFirstFixed182.Fixed (after s w) a gm p p0i w :=
  ⟨input.pCell,input.iCell,ModularAtoms178.slot (ready s) "w" w,
    NttPrologue182.n_cell s,NttPrologue182.hn_cell s,input.stride,input.aBinding,input.gmBinding,
    input.width,input.capacity,input.allocated,input.writable,input.initialized⟩

theorem u_declared (s : State) (w : BitVec 32) : (after s w).locals "u".toList=some (.uint64,none) :=
  (ModularAtoms178.outside (ready s) "w" "u" w (by decide)).trans (NttPrologue182.u_declared s)

end FT1536.Source3.NttFirstSetup182
