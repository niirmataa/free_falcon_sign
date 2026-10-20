import Source3.ShakeEncode

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The complete SHAKE extraction control with fixed process_block/enc64le
   callees. Layout is the LP64 typed subobject view of shake_context. The
   enclosing KeyGen caller must locate that object at its actual fk->rng. -/
namespace FT1536.Source3.ShakeExtractSource
open C99ArrayReference (State Name bindValue bindPointer)
open C99IntegerReference (Value Ty)
open C99MemoryReference
open B20.C (Token)

structure Layout where
  block : Nat
  base : Nat

inductive Field where
  | dbuf | dptr | rate | a
  deriving DecidableEq, Repr

def field (ctx : Layout) : Field → ArrayPointer
  | .dbuf => ⟨ctx.block,ctx.base,200,1,0⟩
  | .dptr => ⟨ctx.block,ctx.base+200,1,8,0⟩
  | .rate => ⟨ctx.block,ctx.base+208,1,8,0⟩
  | .a => ⟨ctx.block,ctx.base+216,25,8,0⟩

theorem struct_source : (ShakeSource.headerLines.drop 80).take 6 =
    ["typedef struct {\n","\tunsigned char dbuf[200];\n","\tsize_t dptr;\n",
     "\tsize_t rate;\n","\tuint64_t A[25];\n","} shake_context;\n"] := by decide

def rcTokens : Option (List Token) := C99ProcedureParser.tokens
  (((ShakeSource.sourceLines.drop 39).take 12).flatMap String.toList)
def rcInitializer : List Token → Option (List (BitVec 64))
  | [] => some []
  | number::rest => do
      let expression ← CLogicParser.number number
      let n ← match expression with | .literal _ n => some n | _ => none
      if n≥2^64 then none else do
        match rest with
        | [] => pure [BitVec.ofNat 64 n]
        | [',']::rest => do pure (BitVec.ofNat 64 n::(← rcInitializer rest))
        | _ => none
def rc : List (BitVec 64) := [
  0x0000000000000001,0x0000000000008082,0x800000000000808A,0x8000000080008000,
  0x000000000000808B,0x0000000080000001,0x8000000080008081,0x8000000000008009,
  0x000000000000008A,0x0000000000000088,0x0000000080008009,0x000000008000000A,
  0x000000008000808B,0x800000000000008B,0x8000000000008089,0x8000000000008003,
  0x8000000000008002,0x8000000000000080,0x000000000000800A,0x800000008000000A,
  0x8000000080008081,0x8000000000008080,0x0000000080000001,0x8000000080008008]
def StaticRC (heap : Memory) (p : ArrayPointer) : Prop :=
  heap.writable p.block=false ∧ p.elementBytes=8 ∧
    ∀ i : Fin 24, Load64 heap (KeygenSmallOutput.element p i.val) (rc[i.val]!)

def blockEntry (s : State) (p table : ArrayPointer) : State :=
  { s with
    locals := fun _ => none
    arrays := fun name => if name="A".toList then some p else if name="RC".toList then some table else none }

inductive Process (before : State) (p : ArrayPointer) : State → Prop where
  | run (table : ArrayPointer) (after : State)
      (binding : before.tables "RC".toList=some table) (static : StaticRC before.heap table)
      (body : ShakeBlock.Exec ShakeBlockProgram.code (blockEntry before p table) after) :
      Process before p {before with heap := after.heap}

theorem process_frame (before after : State) (p : ArrayPointer) (source : Process before p after) :
    ShakeEncode.BlockFrame before.heap after.heap p.block := by
  cases source with
  | run table after binding static body =>
      have hf := ShakeBlockProgram.source_frame (blockEntry before p table) after p (by simp [blockEntry]) body
      exact ⟨hf.1,hf.2.1,fun b offset outside => hf.2.2 b offset (Or.inl outside)⟩
theorem process_pointers (before after : State) (p : ArrayPointer) (source : Process before p after) :
    after.arrays=before.arrays := by cases source; rfl

inductive Stmt where
  | scalar (code : CLogic.Stmt)
  | declarePointer (name : Name)
  | pointer (dst src : Name) (index : CLogic.Expr)
  | fieldPointer (dst : Name) (member : Field)
  | fieldRead (dst : Name) (member : Field)
  | fieldStore (member : Field) (value : CLogic.Expr)
  | process (src : Name)
  | encode (dst : Name) (index value : CLogic.Expr)
  | copy (dst : Name) (index count : CLogic.Expr)
  | skip
  | seq (first second : Stmt)
  | scope (locals pointers : List Name) (body : Stmt)
  | branch (condition : CLogic.Expr) (yes no : Stmt)
  | loop (condition : CLogic.Expr) (body : Stmt)
  deriving DecidableEq, Repr

def chain : List Stmt → Stmt
  | [] => .skip
  | first::rest => .seq first (chain rest)
def var (name : String) : CLogic.Expr := .var name.toList
def zero : CLogic.Expr := C99ProcedureParser.zero
def enc (i : Nat) : Stmt := .encode "dbuf".toList (.literal .i32 (8*i))
  (let load := CLogic.Expr.call1 (ShakeBlock.readName "A".toList) (.literal .i32 i)
   if i∈[1,2,8,12,17,20] then .bitNot load else load)
def refill : Stmt := .scope [] ["dbuf".toList,"A".toList] (chain ([
  .declarePointer "dbuf".toList,.declarePointer "A".toList,
  .fieldPointer "A".toList .a,.fieldPointer "dbuf".toList .dbuf,.process "A".toList]++
  (List.range 25).map enc++[.scalar (.assign "dptr".toList (.literal .i32 0))]))
def iteration : Stmt := .scope ["clen".toList] [] (chain [
  .scalar (.declare .u64 ["clen".toList]),
  .branch (.cmp .eq (var "dptr") (var "rate")) refill .skip,
  .scalar (.assign "clen".toList (.bin .sub (var "rate") (var "dptr"))),
  .branch (.cmp .gt (var "clen") (var "len"))
    (.scope [] [] (chain [.scalar (.assign "clen".toList (var "len"))])) .skip,
  .copy "buf".toList (var "dptr") (var "clen"),
  .scalar (.update "dptr".toList .add (var "clen")),
  .pointer "buf".toList "buf".toList (var "clen"),
  .scalar (.update "len".toList .sub (var "clen"))])
def code : Stmt := chain [
  .declarePointer "buf".toList,.scalar (.declare .u64 ["dptr".toList,"rate".toList]),
  .pointer "buf".toList "out".toList zero,
  .fieldRead "dptr".toList .dptr,.fieldRead "rate".toList .rate,
  .loop (.cmp .gt (var "len") (.literal .i32 0)) iteration,
  .fieldStore .dptr (var "dptr")]

def fieldToken : Token → Option Field
  | ['d','b','u','f'] => some .dbuf
  | ['d','p','t','r'] => some .dptr
  | ['r','a','t','e'] => some .rate
  | ['A'] => some .a
  | _ => none

def simple : List Token → Option (Stmt × List Token)
  | ['u','n','s','i','g','n','e','d']::['c','h','a','r']::['*']::name::[';']::rest =>
      some (.declarePointer name,rest)
  | ['u','i','n','t','6','4','_','t']::['*']::name::[';']::rest => some (.declarePointer name,rest)
  | ['f','p','r']::['*']::name::[';']::rest => some (.declarePointer name,rest)
  | ['s','c']::['-']::['>']::member::['=']::rest => do
      let member ← fieldToken member
      let (value,rest) ← ShakeBlock.expression rest
      match rest with | [';']::rest => pure (.fieldStore member value,rest) | _ => none
  | dst::['=']::['s','c']::['-']::['>']::member::[';']::rest => do
      let member ← fieldToken member
      pure ((match member with | .a | .dbuf => .fieldPointer dst member | _ => .fieldRead dst member),rest)
  | ['p','r','o','c','e','s','s','_','b','l','o','c','k']::['(']::src::[')']::[';']::rest =>
      some (.process src,rest)
  | ['e','n','c','6','4','l','e']::['(']::dst::['+']::rest => do
      let (index,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [',']::rest => do
          let (value,rest) ← ShakeBlock.expression rest
          match rest with | [')']::[';']::rest => pure (.encode dst index value,rest) | _ => none
      | _ => none
  | ['m','e','m','c','p','y']::['(']::dst::[',']::['s','c']::['-']::['>']::['d','b','u','f']::['+']::rest => do
      let (index,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [',']::rest => do
          let (count,rest) ← C99ArrayParser.pureExpr rest
          match rest with | [')']::[';']::rest => pure (.copy dst index count,rest) | _ => none
      | _ => none
  | ['b','u','f']::['=']::src::[';']::rest => some (.pointer "buf".toList src zero,rest)
  | ['b','u','f']::['+','=']::rest => do
      let (index,rest) ← C99ArrayParser.pureExpr rest
      match rest with | [';']::rest => pure (.pointer "buf".toList "buf".toList index,rest) | _ => none
  | rest => do
      let (scalar,tail) ← CLogicParser.statement rest
      pure (.scalar scalar,tail)

def declarations : Stmt → List Name × List Name
  | .scalar (.declare _ names) => (names,[])
  | .declarePointer name => ([],[name])
  | .seq a b => ((declarations a).1++(declarations b).1,(declarations a).2++(declarations b).2)
  | _ => ([],[])

mutual
  def statement : Nat → List Token → Option (Stmt × List Token)
    | 0,_ => none
    | fuel+1,['{']::rest => do
        let (code,rest) ← body fuel rest
        let names := declarations code
        pure (.scope names.1 names.2 code,rest)
    | fuel+1,['i','f']::['(']::rest => do
        let (condition,rest) ← C99ArrayParser.pureExpr rest
        match rest with
        | [')']::rest => do
            let (yes,rest) ← statement fuel rest
            pure (.branch condition yes .skip,rest)
        | _ => none
    | fuel+1,['w','h','i','l','e']::['(']::rest => do
        let (condition,rest) ← C99ArrayParser.pureExpr rest
        match rest with
        | [')']::rest => do
            let (iteration,rest) ← statement fuel rest
            pure (.loop condition iteration,rest)
        | _ => none
    | _+1,rest => simple rest
  def body : Nat → List Token → Option (Stmt × List Token)
    | 0,_ => none
    | _+1,['}']::rest => some (.skip,rest)
    | fuel+1,rest => do
        let (head,rest) ← statement fuel rest
        let (tail,rest) ← body fuel rest
        pure (.seq head tail,rest)
end

def parsed : Option Stmt := do
  let tokens ← C99ProcedureParser.tokens (((ShakeSource.sourceLines.drop 583).take 54).flatMap String.toList)
  let (code,tail) ← body 128 tokens
  if tail.isEmpty then pure code else none
inductive Exec (ctx : Layout) : Stmt → State → State → Prop where
  | scalar (code : CLogic.Stmt) (before : State) (env : C99ScalarReference.Env)
      (body : C99ScalarReference.Exec (ShakeBlock.ReadCall before) before.locals (C99Frontend.scalar code) (.normal env)) :
      Exec ctx (.scalar code) before {before with locals := env}
  | declarePointer (name : Name) (s : State) : Exec ctx (.declarePointer name) s
      {s with arrays := fun n => if n=name then none else s.arrays n}
  | pointer (dst src : Name) (index : CLogic.Expr) (s : State) (p : ArrayPointer)
      (address : C99ArrayReference.Pointer s src index p) : Exec ctx (.pointer dst src index) s (bindPointer s dst p)
  | fieldPointer (dst : Name) (member : Field) (s : State) :
      Exec ctx (.fieldPointer dst member) s (bindPointer s dst (field ctx member))
  | fieldRead (dst : Name) (member : Field) (s : State) (ty : Ty) (old : Option Value) (v : BitVec 64)
      (declared : s.locals dst=some (ty,old)) (read : Load64 s.heap (field ctx member) v) :
      Exec ctx (.fieldRead dst member) s (bindValue s dst ty (.uint64 v))
  | fieldStore (member : Field) (value : CLogic.Expr) (s : State) (heap : Memory) (v : Value)
      (evaluated : ShakeBlock.Eval s value v) (write : Store64 s.heap (field ctx member) (BitVec.ofInt 64 v.integer) heap) :
      Exec ctx (.fieldStore member value) s {s with heap := heap}
  | process (src : Name) (before after : State) (p : ArrayPointer)
      (address : C99ArrayReference.Pointer before src zero p) (call : Process before p after) :
      Exec ctx (.process src) before after
  | encode (dst : Name) (index value : CLogic.Expr) (before after : State) (p : ArrayPointer) (v : Value)
      (address : C99ArrayReference.Pointer before dst index p) (evaluated : ShakeBlock.Eval before value v)
      (call : ShakeEncode.Invoke before p v after) : Exec ctx (.encode dst index value) before after
  | copy (dst : Name) (index count : CLogic.Expr) (s : State) (heap : Memory) (p q : ArrayPointer)
      (i n : BitVec 64) (destination : C99ArrayReference.Pointer s dst zero p)
      (offset : C99ArrayReference.scalar s index (.uint64 i)) (length : C99ArrayReference.scalar s count (.uint64 n))
      (source : PointerAdd (field ctx .dbuf) i.toNat q)
      (destinationObject : p.offset+n.toNat≤p.base+p.elementBytes*p.count)
      (sourceObject : q.offset+n.toNat≤q.base+q.elementBytes*q.count)
      (copy : Memcpy s.heap p q n.toNat heap) : Exec ctx (.copy dst index count) s {s with heap := heap}
  | skip (s : State) : Exec ctx .skip s s
  | seq (first second : Stmt) (before middle after : State)
      (head : Exec ctx first before middle) (tail : Exec ctx second middle after) : Exec ctx (.seq first second) before after
  | scope (locals pointers : List Name) (body : Stmt) (before after : State)
      (inner : Exec ctx body before after) :
      Exec ctx (.scope locals pointers body) before (C99ArrayReference.restoreScope before after locals pointers)
  | branchTrue (condition : CLogic.Expr) (yes no : Stmt) (before after : State) (v : Value)
      (guard : ShakeBlock.Eval before condition v) (nonzero : v.integer≠0) (body : Exec ctx yes before after) :
      Exec ctx (.branch condition yes no) before after
  | branchFalse (condition : CLogic.Expr) (yes no : Stmt) (before after : State) (v : Value)
      (guard : ShakeBlock.Eval before condition v) (zero : v.integer=0) (body : Exec ctx no before after) :
      Exec ctx (.branch condition yes no) before after
  | loopFalse (condition : CLogic.Expr) (body : Stmt) (s : State) (v : Value)
      (guard : ShakeBlock.Eval s condition v) (zero : v.integer=0) : Exec ctx (.loop condition body) s s
  | loopNext (condition : CLogic.Expr) (body : Stmt) (before middle after : State) (v : Value)
      (guard : ShakeBlock.Eval before condition v) (nonzero : v.integer≠0)
      (iteration : Exec ctx body before middle) (rest : Exec ctx (.loop condition body) middle after) :
      Exec ctx (.loop condition body) before after

end FT1536.Source3.ShakeExtractSource
