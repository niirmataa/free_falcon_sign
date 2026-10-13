import Source3.KeygenDecodeNoneSubtract
import Source3.KeygenDecodeWrite16
import Source3.KeygenDecodeControl

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Stable activation cells of a NONE coefficient. These local entry facts
   will be derived from the complete decoder prologue, not final premises. -/
namespace FT1536.Source3.KeygenDecodeNoneReady
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeNoneCore

structure Ready (args : Args) (n : Nat) (src dst : ArrayPointer) (s : State) : Prop where
  cursor : KeygenDecodeNoneRead.Cursor n s.locals
  q : Cell "q" .uint32 (.uint32 18433) s.locals
  hq : Cell "hq" .uint32 (.uint32 9216) s.locals
  tq : Cell "tq" .uint32 (.uint32 27650) s.locals
  count : Cell "n" .uint64 (.uint64 1536) s.locals
  length : Cell "len" .uint64 (.uint64 args.len) s.locals
  buffer : s.buf=some (some src)
  destination : s.locals.x=some dst

def Checks (stmt : Stmt) : Prop :=
  KeygenDecodeCellFrame.statement "u".toList stmt=true ∧
  KeygenDecodeCellFrame.statement "q".toList stmt=true ∧
  KeygenDecodeCellFrame.statement "hq".toList stmt=true ∧
  KeygenDecodeCellFrame.statement "tq".toList stmt=true ∧
  KeygenDecodeCellFrame.statement "n".toList stmt=true ∧
  KeygenDecodeCellFrame.statement "len".toList stmt=true ∧
  KeygenDecodeStateFrame.preserves false stmt=true ∧
  KeygenDecodePointerFrame.statement stmt=true

theorem ready_frame (args : Args) (n : Nat) (src dst : ArrayPointer) (stmt : Stmt)
    (s t : State) (flow : Flow) (source : Exec args stmt s t flow)
    (checked : Checks stmt) (ready : Ready args n src dst s) : Ready args n src dst t := by
  obtain ⟨u,q,hq,tq,count,length,buffer,pointer⟩ := checked
  exact ⟨
    (KeygenDecodeCellFrame.exec_frame "u".toList args stmt s t flow source u).trans ready.cursor,
    (KeygenDecodeCellFrame.exec_frame "q".toList args stmt s t flow source q).trans ready.q,
    (KeygenDecodeCellFrame.exec_frame "hq".toList args stmt s t flow source hq).trans ready.hq,
    (KeygenDecodeCellFrame.exec_frame "tq".toList args stmt s t flow source tq).trans ready.tq,
    (KeygenDecodeCellFrame.exec_frame "n".toList args stmt s t flow source count).trans ready.count,
    (KeygenDecodeCellFrame.exec_frame "len".toList args stmt s t flow source length).trans ready.length,
    (KeygenDecodeStateFrame.buf_frame args stmt s t flow source buffer).trans ready.buffer,
    (KeygenDecodePointerFrame.exec_frame args stmt s t flow source pointer).trans ready.destination⟩

theorem body_checked : Checks KeygenDecodeNoneBinding.node041 := by unfold Checks; decide +kernel

theorem declare_w (args : Args) (s t : State) (flow : Flow)
    (source : Exec args KeygenDecodeNoneBinding.node020 s t flow) :
    t.locals.scalars "w".toList=some (.uint32,none) := by
  cases source with
  | declare s objects locals declarations =>
    have same : locals=localSet s.locals "w".toList .uint32 none := by
      simpa [KeygenDecodeNoneBinding.node020,declareLocals,scalarTy] using declarations.symm
    subst locals
    simp [declared,localSet,C99ScalarReference.set]

theorem declare_y (args : Args) (s t : State) (flow : Flow)
    (source : Exec args KeygenDecodeNoneBinding.node021 s t flow) :
    t.locals.scalars "y".toList=some (.int64,none) := by
  cases source with
  | declare s objects locals declarations =>
    have same : locals=localSet s.locals "y".toList .int64 none := by
      simpa [KeygenDecodeNoneBinding.node021,declareLocals,scalarTy] using declarations.symm
    subst locals
    simp [declared,localSet,C99ScalarReference.set]

end FT1536.Source3.KeygenDecodeNoneReady
