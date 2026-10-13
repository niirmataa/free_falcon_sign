import Source3.KeygenPublicEncodeStateFrame077
import Source3.KeygenPublicEncodeStore077
import Source3.KeygenPublicInteger077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEncodeReady077
open KeygenCodecSyntax KeygenPublicEncodeValues077 KeygenPublicEncodeExecution077 C99MemoryReference

abbrev IV := C99IntegerReference.Value
def Cell (name : String) (ty : C99IntegerReference.Ty) (value : IV) (l : Locals) : Prop :=
  l.scalars name.toList=some (ty,some value)
structure Context (args : Args) (out : ArrayPointer) (s : State) : Prop where
  output : args.out=some out
  buffer : s.buf=some (some out)
  capacity : Cell "max_out_len" .uint64 (.uint64 args.capacity) s.locals
  noOut : s.locals.scalars "out".toList=none
  noNull : s.locals.scalars "NULL".toList=none
structure Ready (args : Args) (out ptr : ArrayPointer) (n u p : Nat) (acc : BitVec 32) (s : State) : Prop where
  context : Context args out s
  pointer : s.locals.x=some ptr
  remaining : Cell "n" .uint64 (.uint64 (BitVec.ofNat 64 n)) s.locals
  cursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) s.locals
  pending : Cell "acc_len" .int32 (.int32 (BitVec.ofNat 32 p)) s.locals
  accumulator : Cell "acc" .uint32 (.uint32 acc) s.locals

def Checks (code : Stmt) : Prop :=
  KeygenPublicEncodeCellFrame077.statement "max_out_len".toList code=true ∧
  KeygenPublicEncodeCellFrame077.statement "out".toList code=true ∧
  KeygenPublicEncodeCellFrame077.statement "NULL".toList code=true ∧
  KeygenPublicEncodeStateFrame077.preserves false code=true

theorem context_frame (args : Args) (out : ArrayPointer) (s t : State) (code : Stmt) (flow : Flow)
    (source : Exec args code s t flow) (checks : Checks code) (context : Context args out s) : Context args out t :=
  ⟨context.output,(KeygenPublicEncodeStateFrame077.buf_frame args _ _ _ _ source checks.2.2.2).trans context.buffer,
    (KeygenPublicEncodeCellFrame077.exec_frame "max_out_len".toList args _ _ _ _ source checks.1).trans context.capacity,
    (KeygenPublicEncodeCellFrame077.exec_frame "out".toList args _ _ _ _ source checks.2.1).trans context.noOut,
    (KeygenPublicEncodeCellFrame077.exec_frame "NULL".toList args _ _ _ _ source checks.2.2.1).trans context.noNull⟩

def set32 (s : State) (name : String) (word : BitVec 32) : State :=
  withLocals s (localSet s.locals name.toList .uint32 (some (.uint32 word)))
def set64 (s : State) (name : String) (word : BitVec 64) : State :=
  withLocals s (localSet s.locals name.toList .uint64 (some (.uint64 word)))
def setPending (s : State) (p : Nat) : State :=
  withLocals s (localSet s.locals "acc_len".toList .int32 (some (.int32 (BitVec.ofNat 32 p))))

def WritableBytes (heap : Memory) (out : ArrayPointer) (count : Nat) : Prop :=
  heap.writable out.block=true ∧ ∀ i<count, Allocated heap (byteOff out i)

theorem writable_preserved (a b : Memory) (out ptr : ArrayPointer) (count : Nat) (word : BitVec 8)
    (legal : WritableBytes a out count) (write : StoreByte a ptr word b) : WritableBytes b out count :=
  ⟨by rw [write.2.2.2.2.1]; exact legal.1,
    fun i bound => by simpa only [Allocated,write.2.2.2.1] using legal.2 i bound⟩

theorem empty_scope (code : Stmt) (s t : State) (empty : scopeObjects code=[]) : scopeExit code s t=t := by
  simp only [KeygenCodecExecution.scopeExit,empty,List.any_nil,Bool.false_eq_true,ite_false]
  cases t; rfl

end FT1536.Source3.KeygenPublicEncodeReady077
