import Source3.KeygenDecodeStaticReady
import Source3.KeygenDecodeStaticWire

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticReaderFrame
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticWire

def Checks (code : Stmt) : Prop := KeygenDecodeStaticReady.Checks code ∧
  KeygenDecodeStaticCellFrame.statement "v".toList code=true ∧
  KeygenDecodeStaticCellFrame.statement "db_len".toList code=true ∧
  KeygenDecodeStaticCellFrame.statement "db".toList code=true

theorem ready_frame (args : Args) (src dst : ArrayPointer) (v p : Nat) (db : BitVec 32)
    (s t : State) (code : Stmt) (flow : Flow) (source : Exec args code s t flow)
    (checks : Checks code) (ready : Ready args src dst v p db s) : Ready args src dst v p db t :=
  ⟨context_frame args src dst s t code flow source checks.1 ready.context,
    (KeygenDecodeStaticCellFrame.exec_frame "v".toList args _ _ _ _ source checks.2.1).trans ready.cursor,
    (KeygenDecodeStaticCellFrame.exec_frame "db_len".toList args _ _ _ _ source checks.2.2.1).trans ready.pending,
    (KeygenDecodeStaticCellFrame.exec_frame "db".toList args _ _ _ _ source checks.2.2.2).trans ready.accumulator⟩

theorem wire_frame (args : Args) (src dst : ArrayPointer) (v p : Nat) (db : BitVec 32)
    (bytes : List (BitVec 8)) (s t : State) (code : Stmt) (flow : Flow)
    (source : Exec args code s t flow) (checks : Checks code)
    (noStores : KeygenDecodeStaticStateFrame.preserves true code=true)
    (wire : Wire args src dst v p db bytes s) : Wire args src dst v p db bytes t := by
  refine ⟨ready_frame args src dst v p db s t code flow source checks wire.ready,?_,wire.extent⟩
  rw [KeygenDecodeStaticStateFrame.heap_frame args _ _ _ _ source noStores]
  exact wire.reads

end FT1536.Source3.KeygenDecodeStaticReaderFrame
