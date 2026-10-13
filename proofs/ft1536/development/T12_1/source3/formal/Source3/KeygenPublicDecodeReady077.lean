import Source3.KeygenPublicDecodeStateFrame077
import Source3.KeygenPublicDecodeCellFrame077
import Source3.KeygenPublicDecodeStore077
import Source3.KeygenPublicInteger077
import Source3.KeygenDecodeStaticWire

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicDecodeReady077
open KeygenDecodeSyntax KeygenDecodeValues KeygenPublicDecodeExecution077 C99MemoryReference

def Cell (name : String) (ty : C99IntegerReference.Ty) (value : C99IntegerReference.Value) (l : Locals) : Prop :=
  l.scalars name.toList=some (ty,some value)
structure Context (args : Args) (src : ArrayPointer) (s : State) : Prop where
  data : args.data=some src
  buffer : s.buf=some (some src)
  length : Cell "len" .uint64 (.uint64 args.len) s.locals
structure Ready (args : Args) (src ptr : ArrayPointer) (n u p : Nat) (acc : BitVec 32) (s : State) : Prop where
  context : Context args src s
  pointer : s.locals.x=some ptr
  remaining : Cell "n" .uint64 (.uint64 (BitVec.ofNat 64 n)) s.locals
  cursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) s.locals
  pending : Cell "acc_len" .int32 (.int32 (BitVec.ofNat 32 p)) s.locals
  accumulator : Cell "acc" .uint32 (.uint32 acc) s.locals
def Checks (code : Stmt) : Prop :=
  KeygenPublicDecodeCellFrame077.statement "len".toList code=true ∧
  KeygenPublicDecodeStateFrame077.preserves false code=true
theorem context_frame (args : Args) (src : ArrayPointer) (s t : State) (code : Stmt) (flow : Flow)
    (source : Exec args code s t flow) (checks : Checks code) (context : Context args src s) : Context args src t :=
  ⟨context.data,(KeygenPublicDecodeStateFrame077.buf_frame args _ _ _ _ source checks.2).trans context.buffer,
    (KeygenPublicDecodeCellFrame077.exec_frame "len".toList args _ _ _ _ source checks.1).trans context.length⟩
def set32 (s : State) (name : String) (word : BitVec 32) : State :=
  withLocals s (localSet s.locals name.toList .uint32 (some (.uint32 word)))
def set64 (s : State) (name : String) (word : BitVec 64) : State :=
  withLocals s (localSet s.locals name.toList .uint64 (some (.uint64 word)))
def setPending (s : State) (p : Nat) : State :=
  withLocals s (localSet s.locals "acc_len".toList .int32 (some (.int32 (BitVec.ofNat 32 p))))
abbrev Reads := KeygenDecodeStaticWire.Reads
abbrev remaining := KeygenDecodeStaticWire.remaining
structure Wire (args : Args) (src ptr : ArrayPointer) (n u p : Nat) (acc : BitVec 32)
    (bytes : List (BitVec 8)) (s : State) : Prop where
  ready : Ready args src ptr n u p acc s
  reads : Reads s.heap src u bytes
  extent : u+bytes.length≤args.len.toNat
  accumulatorBound : acc.toNat<2^p
theorem empty_scope (code : Stmt) (s t : State) (empty : scopeObjects code=[]) : scopeExit code s t=t := by
  simp only [KeygenPublicDecodeExecution077.scopeExit,empty,List.any_nil,Bool.false_eq_true,ite_false]
  cases t; rfl

end FT1536.Source3.KeygenPublicDecodeReady077
