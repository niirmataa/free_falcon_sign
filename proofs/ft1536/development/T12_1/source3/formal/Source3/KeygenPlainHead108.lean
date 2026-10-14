import Source3.KeygenSkeBinding108

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPlainHead108
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeSyntax (Stmt)
open KeygenMakeInvocation

theorem byte (before : Memory) (p : ArrayPointer) (word : BitVec 8) (a b : Memory)
    (first : StoreByte before p word a) (second : StoreByte before p word b) : a = b :=
  C99HeapDeterminism089.store8 before p word a b first second

theorem pointer (vb : Nat → Nat) (before : Memory) (cell value : ArrayPointer) (a b : Memory)
    (first : WritePointer vb before cell value a) (second : WritePointer vb before cell value b) : a = b :=
  C99HeapDeterminism089.store64 before cell (wordOf vb value) a b first.2 second.2

theorem index (a b : Fin 4) (equal : a.val = b.val) : a = b := Fin.ext equal

/-- Keep source-shape equality explicit while destructing the two heads:
    this avoids dependent elimination on finite-index pointer records. -/
theorem shapes (env : Env) (left right : Stmt) (before : State) (a b : Result)
    (first : Head env left before a) (second : Head env right before b)
    (same : left = right) (notSecret : left ≠ KeygenMakeProgram.secretLoop)
    (notPublic : left ≠ KeygenMakeProgram.publicDispatch) : a = b := by
  cases first
  all_goals try contradiction
  all_goals cases second
  all_goals try simp [privkeyLenRead, skbufAssign, skHeader, skoffOne, skeBind, privkeyLenWrite,
    pubkeyLenRead, pkHeader, zeroCapacity, pubkeyLenWrite, retOne, KeygenMakeProgram.capacityReturn,
    KeygenMakeProgram.capacityTest, KeygenMakeProgram.secretLoop, KeygenMakeProgram.publicDispatch,
    KeygenMakeProgram.varExpr, KeygenMakeProgram.number] at same
  all_goals grind only [load64_deterministic, byte, pointer, C99HeapDeterminism089.store64, → index]

theorem head (env : Env) (stmt : Stmt) (before : State) (a b : Result)
    (notSecret : stmt ≠ KeygenMakeProgram.secretLoop) (notPublic : stmt ≠ KeygenMakeProgram.publicDispatch)
    (first : Head env stmt before a) (second : Head env stmt before b) : a = b :=
  shapes env stmt stmt before a b first second rfl notSecret notPublic

end FT1536.Source3.KeygenPlainHead108
