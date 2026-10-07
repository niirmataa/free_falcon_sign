import Source3.ShakeBlockProgram
import Source3.KeygenSolverNttCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.ShakeEncode
open C99MemoryReference
open C99ArrayReference (State Name)
open C99IntegerReference (Value)

def Store8 (before : Memory) (p : ArrayPointer) (v : Byte) (after : Memory) : Prop :=
  Allocated before p ∧ p.elementBytes=1 ∧ before.writable p.block=true ∧
  after.size=before.size ∧ after.writable=before.writable ∧
  after.bytes p.block p.offset=some v ∧
  ∀ block offset, block≠p.block ∨ offset≠p.offset → after.bytes block offset=before.bytes block offset

structure Instruction where
  index : CLogic.Expr
  value : CLogic.Expr
  deriving DecidableEq, Repr

def byteExpression (i : Nat) : CLogic.Expr :=
  if i=0 then .var "x".toList else .bin .shr (.var "x".toList) (.literal .i32 (8*i))
def code : List Instruction := (List.range 8).map (fun i => ⟨.literal .i32 i,byteExpression i⟩)

def parseLine (line : String) : Option Instruction := do
  let tokens ← C99ProcedureParser.tokens line.toList
  match tokens with
  | ['b','u','f']::['[']::rest => do
      let (index,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [']']::['=']::['(']::['u','n','s','i','g','n','e','d']::['c','h','a','r']::[')']::rest => do
          let (value,rest) ← C99ArrayParser.pureExpr rest
          if rest=[[';']] then pure ⟨index,value⟩ else none
      | _ => none
  | _ => none

def parsed : Option (List Instruction) := ((ShakeSource.sourceLines.drop 81).take 8).mapM parseLine
theorem source_bound : parsed=some code := by decide
theorem scaffold_source : (ShakeSource.sourceLines.drop 75).take 6 =
    ["static inline void\n","enc64le(void *out, uint64_t x)\n","{\n",
     "\tunsigned char *buf;\n","\n","\tbuf = out;\n"] ∧
    ShakeSource.sourceLines[89]?=some "}\n" := by decide

inductive Exec : List Instruction → State → State → Prop where
  | done (s : State) : Exec [] s s
  | next (i : Instruction) (tail : List Instruction) (before : State) (heap : Memory) (after : State)
      (p : ArrayPointer) (v : Value)
      (address : C99ArrayReference.Pointer before "buf".toList i.index p)
      (evaluated : C99ArrayReference.scalar before i.value v)
      (write : Store8 before.heap p (BitVec.ofInt 8 v.integer) heap)
      (rest : Exec tail {before with heap := heap} after) : Exec (i::tail) before after

def params : List C99ArrayReference.Param := [.pointer "out".toList,.scalar .uint64 "x".toList]
def localDeclaration : C99ArrayReference.Stmt := .declarePtr "buf".toList
def localAssignment : C99ArrayReference.Stmt := .bindPtr "buf".toList "out".toList C99ProcedureParser.zero

inductive Call (before : State) (args : List C99ArrayReference.Arg) : State → Prop where
  | run (entry declared ready after : State)
      (binding : C99ArrayReference.Bind before params args entry)
      (declaration : C99ArrayReference.Exec FftLeafPrograms.program localDeclaration entry declared)
      (assignment : C99ArrayReference.Exec FftLeafPrograms.program localAssignment declared ready)
      (body : Exec code ready after) : Call before args {before with heap := after.heap}

def BlockFrame (before after : Memory) (block : Nat) : Prop :=
  after.size=before.size ∧ after.writable=before.writable ∧
    ∀ b offset, b≠block → after.bytes b offset=before.bytes b offset

theorem frame (statements : List Instruction) (before after : State) (root : ArrayPointer)
    (source : Exec statements before after) (binding : before.arrays "buf".toList=some root) :
    BlockFrame before.heap after.heap root.block := by
  induction source with
  | done => exact ⟨rfl,rfl,fun _ _ _ => rfl⟩
  | next instruction tail before heap after p v address evaluated write rest ih =>
      cases address with
      | add original p index bound value nonnegative within =>
        have he : original=root := Option.some.inj (bound.symm.trans binding)
        subst original
        cases within
        have keep := ih binding
        refine ⟨keep.1.trans write.2.2.2.1,keep.2.1.trans write.2.2.2.2.1,?_⟩
        intro b offset outside
        exact (keep.2.2 b offset outside).trans (write.2.2.2.2.2.2 b offset (Or.inl outside))

theorem call_frame (before after : State) (dst : Name) (index value : CLogic.Expr) (root : ArrayPointer)
    (binding : before.arrays dst=some root)
    (source : Call before [.pointer dst index,.scalar value] after) :
    BlockFrame before.heap after.heap root.block := by
  cases source with
  | run entry declared ready after parameters declaration assignment body =>
    have entryHeap := C99ArrayReference.bind_heap before params _ entry parameters
    cases parameters with
    | pointer _ _ _ p _ _ _ address tail =>
      cases tail with
      | scalar _ _ _ _ _ _ v value tail =>
        cases tail
        cases declaration
        cases assignment with
        | bindPtr _ _ _ _ actual assigned =>
          have hp := KeygenSolverNttCalls.pointer_zero _ "out" p actual (by rfl) assigned
          subst actual
          have result := frame code _ after p body (by simp [C99ArrayReference.bindPointer])
          cases address with
          | add original p i bound ev nonnegative within =>
            have he : original=root := Option.some.inj (bound.symm.trans binding)
            subst original
            cases within
            exact result

def entry (before : State) (p : ArrayPointer) (v : Value) : State :=
  { before with
    locals := C99ScalarReference.set (fun _ => none) "x".toList
      (.uint64,some (C99IntegerReference.convert .uint64 v.integer))
    arrays := fun name => if name="out".toList then some p else none }

/- Already-evaluated arguments also admit the actual memory-reading
   expressions A[k] and ~A[k] used in shake_extract. Their evaluation is
   performed by that caller; Invoke always executes this fixed body. -/
inductive Invoke (before : State) (p : ArrayPointer) (v : Value) : State → Prop where
  | run (declared ready after : State)
      (declaration : C99ArrayReference.Exec FftLeafPrograms.program localDeclaration (entry before p v) declared)
      (assignment : C99ArrayReference.Exec FftLeafPrograms.program localAssignment declared ready)
      (body : Exec code ready after) : Invoke before p v {before with heap := after.heap}

theorem invoke_frame (before after : State) (p : ArrayPointer) (v : Value)
    (source : Invoke before p v after) : BlockFrame before.heap after.heap p.block := by
  cases source with
  | run declared ready after declaration assignment body =>
    cases declaration
    cases assignment with
    | bindPtr _ _ _ _ actual assigned =>
      have hp := KeygenSolverNttCalls.pointer_zero _ "out" p actual (by rfl) assigned
      subst actual
      have result := frame code _ after p body (by simp [C99ArrayReference.bindPointer])
      exact result

theorem invoke_pointers (before after : State) (p : ArrayPointer) (v : Value)
    (source : Invoke before p v after) : after.arrays=before.arrays := by cases source; rfl

end FT1536.Source3.ShakeEncode
