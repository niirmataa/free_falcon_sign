import Source3.KeygenDecodeStaticRead
import Source3.KeygenDecodeStaticStateFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Local reader seams. Their initial values must be derived from the
   complete source prologue before any whole-decoder theorem is exported. -/
namespace FT1536.Source3.KeygenDecodeStaticReady
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference

abbrev IV := C99IntegerReference.Value
def Cell (name : String) (ty : C99IntegerReference.Ty) (value : IV) (l : Locals) : Prop :=
  l.scalars name.toList=some (ty,some value)

structure Context (args : Args) (src dst : ArrayPointer) (s : State) : Prop where
  j : Cell "j" .uint32 (.uint32 8) s.locals
  mask : Cell "mask" .uint32 (.uint32 255) s.locals
  count : Cell "n" .uint64 (.uint64 1536) s.locals
  length : Cell "len" .uint64 (.uint64 args.len) s.locals
  buffer : s.buf=some (some src)
  destination : s.locals.x=some dst

structure Ready (args : Args) (src dst : ArrayPointer) (v p : Nat) (db : BitVec 32) (s : State) : Prop where
  context : Context args src dst s
  cursor : KeygenDecodeStaticRead.cursor v s.locals
  pending : Cell "db_len" .uint32 (.uint32 (BitVec.ofNat 32 p)) s.locals
  accumulator : Cell "db" .uint32 (.uint32 db) s.locals

def Checks (code : Stmt) : Prop :=
  KeygenDecodeStaticCellFrame.statement "j".toList code=true ∧
  KeygenDecodeStaticCellFrame.statement "mask".toList code=true ∧
  KeygenDecodeStaticCellFrame.statement "n".toList code=true ∧
  KeygenDecodeStaticCellFrame.statement "len".toList code=true ∧
  KeygenDecodeStaticStateFrame.preserves false code=true ∧
  KeygenDecodeStaticPointerFrame.statement code=true

theorem context_frame (args : Args) (src dst : ArrayPointer) (s t : State) (code : Stmt) (flow : Flow)
    (source : Exec args code s t flow) (checks : Checks code) (context : Context args src dst s) :
    Context args src dst t := by
  refine ⟨?_,?_,?_,?_,?_,?_⟩
  · exact (KeygenDecodeStaticCellFrame.exec_frame "j".toList args _ _ _ _ source checks.1).trans context.j
  · exact (KeygenDecodeStaticCellFrame.exec_frame "mask".toList args _ _ _ _ source checks.2.1).trans context.mask
  · exact (KeygenDecodeStaticCellFrame.exec_frame "n".toList args _ _ _ _ source checks.2.2.1).trans context.count
  · exact (KeygenDecodeStaticCellFrame.exec_frame "len".toList args _ _ _ _ source checks.2.2.2.1).trans context.length
  · exact (KeygenDecodeStaticStateFrame.buf_frame args _ _ _ _ source checks.2.2.2.2.1).trans context.buffer
  · exact (KeygenDecodeStaticPointerFrame.exec_frame args _ _ _ _ source checks.2.2.2.2.2).trans context.destination

theorem empty_scope (code : Stmt) (s t : State) (empty : scopeObjects code=[]) : scopeExit code s t=t := by
  simp only [scopeExit,empty,List.any_nil,Bool.false_eq_true,ite_false]
  cases t; rfl

end FT1536.Source3.KeygenDecodeStaticReady
