import Source3.KeygenNttForwardExec
import Source3.KeygenSmallOutput
import Source3.C99ModularFrame
import Source3.StableBinaryByteView

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Source-bound narrow-output language. Scalar expressions retain the existing
   C99 semantics. The only pointer callee is the complete pinned zint helper;
   its signed read uses the actual uint32 local object's four bytes. -/
namespace FT1536.Source3.KeygenSmallSource
open C99ArrayReference (State Name Pointer bindValue restoreScope)
open C99MemoryReference
open C99IntegerReference (Value Ty)
open C99ProcedureReference (Result)

def var (s : String) : CLogic.Expr := .var s.toList
def number (n : Nat) : CLogic.Expr := .literal .i32 n
def plainPrefix : C99ModularReference.Stmt := C99ModularParser.chain [
  .base (.scalar (.declare .u32 ["w".toList])),
  .assign "w".toList (.load32 "x".toList (number 0)),
  .base (.scalar (.update "w".toList .bor
    (.bin .shl (.bin .band (var "w") (number 0x40000000)) (number 1))))]

theorem plain_prefix_source : C99ModularParser.region 4433 4=some plainPrefix := by decide
theorem plain_return_source : Pinned.keygenLines[4436]?=some "\treturn *(int32_t *)&w;\n" := by decide

def plainEntry (before : State) (p : ArrayPointer) : State :=
  { before with
    arrays := fun name => if name="x".toList then some p else none
    locals := fun _ => none }

inductive SignedLocalRead (state : State) (name : Name) : Value → Prop where
  | read (w : BitVec 32) (bytes : Fin 4 → Byte)
      (slot : state.locals name=some (.uint32,some (.uint32 w)))
      (object : bytes=byte32 w) : SignedLocalRead state name (.int32 (le32 bytes))

theorem signed_object_roundtrip (w : BitVec 32) : le32 (byte32 w)=w :=
  StableBinaryByteView.flag_join_bytes w

inductive PlainCall (before : State) (p : ArrayPointer) : Value → Prop where
  | run (out : Result) (v : Value)
      (prefixExecution : C99ModularReference.Exec plainPrefix (plainEntry before p) out)
      (normal : out.flow=.normal) (read : SignedLocalRead out.state "w".toList v) :
      PlainCall before p (C99IntegerReference.convert .int32 v.integer)

theorem plain_heap (before : State) (p : ArrayPointer) (out : Result)
    (source : C99ModularReference.Exec plainPrefix (plainEntry before p) out) :
    out.state.heap=before.heap :=
  (C99ModularFrame.source_frame plainPrefix (plainEntry before p) out source (by decide)).1

theorem plain_signed (before : State) (p : ArrayPointer) (v : Value)
    (source : PlainCall before p v) : ∃ w : BitVec 32, v=.int32 w := by
  cases source with
  | run out v prefixExecution normal read =>
    cases read with
    | read w bytes slot object =>
      subst bytes
      rw [signed_object_roundtrip]
      exact ⟨w,C99CountedWords.convert_self (.int32 w)⟩

inductive Stmt where
  | modular (code : C99ModularReference.Stmt)
  | plain (dst src : Name) (index : CLogic.Expr)
  | store16 (dst : Name) (index value : CLogic.Expr)
  | seq (first second : Stmt)
  | scope (locals : List Name) (body : Stmt)
  | branch (condition : CLogic.Expr) (yes no : Stmt)
  | loop (condition : CLogic.Expr) (body increment : Stmt)
  deriving DecidableEq, Repr

def skip : Stmt := .modular (.base .skip)
def chain : List Stmt → Stmt
  | [] => skip
  | x::xs => .seq x (chain xs)

inductive Exec : Stmt → State → Result → Prop where
  | modular (code : C99ModularReference.Stmt) (before : State) (out : Result)
      (source : C99ModularReference.Exec code before out) : Exec (.modular code) before out
  | plain (dst src : Name) (index : CLogic.Expr) (before : State) (p : ArrayPointer)
      (ty : Ty) (old : Option Value) (v : Value)
      (address : Pointer before src index p) (declared : before.locals dst=some (ty,old))
      (call : PlainCall before p v) :
      Exec (.plain dst src index) before ⟨bindValue before dst ty v,.normal⟩
  | store16 (dst : Name) (index value : CLogic.Expr) (before : State) (after : Memory)
      (p : ArrayPointer) (v : Value) (address : Pointer before dst index p)
      (evaluated : C99ArrayReference.scalar before value v)
      (store : KeygenSmallOutput.Store16 before.heap p (BitVec.ofInt 16 v.integer) after) :
      Exec (.store16 dst index value) before ⟨{before with heap := after},.normal⟩
  | seqNormal (first second : Stmt) (before middle : State) (out : Result)
      (head : Exec first before ⟨middle,.normal⟩) (tail : Exec second middle out) :
      Exec (.seq first second) before out
  | seqExit (first second : Stmt) (before : State) (out : Result)
      (head : Exec first before out) (exit : out.flow≠.normal) : Exec (.seq first second) before out
  | scope (locals : List Name) (body : Stmt) (before : State) (out : Result)
      (inner : Exec body before out) :
      Exec (.scope locals body) before ⟨restoreScope before out.state locals [],out.flow⟩
  | branchTrue (condition : CLogic.Expr) (yes no : Stmt) (before : State) (out : Result)
      (v : Value) (guard : C99ArrayReference.scalar before condition v) (nonzero : v.integer≠0)
      (body : Exec yes before out) : Exec (.branch condition yes no) before out
  | branchFalse (condition : CLogic.Expr) (yes no : Stmt) (before : State) (out : Result)
      (v : Value) (guard : C99ArrayReference.scalar before condition v) (zero : v.integer=0)
      (body : Exec no before out) : Exec (.branch condition yes no) before out
  | loopFalse (condition : CLogic.Expr) (body increment : Stmt) (before : State) (v : Value)
      (guard : C99ArrayReference.scalar before condition v) (zero : v.integer=0) :
      Exec (.loop condition body increment) before ⟨before,.normal⟩
  | loopNormal (condition : CLogic.Expr) (body increment : Stmt) (before middle next : State)
      (out : Result) (v : Value) (guard : C99ArrayReference.scalar before condition v)
      (nonzero : v.integer≠0) (iteration : Exec body before ⟨middle,.normal⟩)
      (update : Exec increment middle ⟨next,.normal⟩) (rest : Exec (.loop condition body increment) next out) :
      Exec (.loop condition body increment) before out
  | loopReturn (condition : CLogic.Expr) (body increment : Stmt) (before after : State)
      (v value : Value) (guard : C99ArrayReference.scalar before condition v) (nonzero : v.integer≠0)
      (iteration : Exec body before ⟨after,.returned (some value)⟩) :
      Exec (.loop condition body increment) before ⟨after,.returned (some value)⟩

/- The extra grammar productions retain the pointer argument and int16 store.
   Unsupported calls, casts and statements are rejected. -/
def simple : List B20.C.Token → Option (Stmt × List B20.C.Token)
  | ['i','n','t','3','2','_','t']::name::[';']::rest =>
      some (.modular (.base (.scalar (.declare .i32 [name]))),rest)
  | dst::['=']::['z','i','n','t','_','o','n','e','_','t','o','_','p','l','a','i','n']::['(']::rest => do
      let (arg,rest) ← C99ProcedureParser.pointerExpr rest
      match arg,rest with
      | .pointer src index,[')']::[';']::tail => pure (.plain dst src index,tail)
      | _,_ => none
  | dst::['[']::rest => do
      let (index,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [']']::['=']::['(']::['i','n','t','1','6','_','t']::[')']::rest => do
          let (value,rest) ← C99ArrayParser.pureExpr rest
          match rest with
          | [';']::tail => pure (.store16 dst index value,tail)
          | _ => none
      | _ => none
  | rest => do
      let (code,_,tail) ← C99ModularParser.simple [] rest
      pure (.modular code,tail)

def declarations : Stmt → List Name
  | .modular (.base (.scalar (.declare _ ns))) => ns
  | .seq a b => declarations a++declarations b
  | _ => []

mutual
  def statement : Nat → List B20.C.Token → Option (Stmt × List B20.C.Token)
    | 0,_ => none
    | fuel+1,['{']::rest => do
        let (code,rest) ← body fuel rest
        pure (.scope (declarations code) code,rest)
    | fuel+1,['i','f']::['(']::rest => do
        let (condition,rest) ← C99ArrayParser.pureExpr rest
        match rest with
        | [')']::rest => do
            let (yes,rest) ← statement fuel rest
            match rest with
            | ['e','l','s','e']::rest => do
                let (no,rest) ← statement fuel rest
                pure (.branch condition yes no,rest)
            | _ => pure (.branch condition yes skip,rest)
        | _ => none
    | fuel+1,['f','o','r']::['(']::rest => do
        let (initial,rest) ← C99ModularParser.clauses [] [';'] 16 rest
        let (condition,rest) ← C99ArrayParser.pureExpr rest
        match rest with
        | [';']::rest => do
            let (increment,rest) ← C99ModularParser.clauses [] [')'] 16 rest
            let (iteration,rest) ← statement fuel rest
            pure (.seq (.modular initial) (.loop condition iteration (.modular increment)),rest)
        | _ => none
    | _+1,rest => simple rest
  def body : Nat → List B20.C.Token → Option (Stmt × List B20.C.Token)
    | 0,_ => none
    | _+1,['}']::rest => some (skip,rest)
    | fuel+1,rest => do
        let (first,rest) ← statement fuel rest
        let (tail,rest) ← body fuel rest
        pure (.seq first tail,rest)
end

def region (start count : Nat) : Option Stmt := do
  let chars := ((Pinned.keygenLines.drop (start-1)).take count).flatMap String.toList++['}']
  let tokens ← C99ProcedureParser.tokens chars
  let (code,rest) ← body 128 tokens
  if rest.isEmpty then pure code else none

def guard : CLogic.Expr := .lor (.cmp .lt (var "z") (.neg (number 2047)))
  (.cmp .gt (var "z") (number 2047))
def ret (n : Nat) : Stmt := .modular (.ret (.scalar (number n)))
def gate : Stmt := .branch guard (.scope [] (chain [ret 0])) skip
def iteration : Stmt := .scope ["z".toList] (chain [
  .modular (.base (.scalar (.declare .i32 ["z".toList]))),
  .plain "z".toList "s".toList (var "u"),gate,
  .store16 "d".toList (var "u") (var "z")])
def increment : Stmt := .modular (.base (.scalar (.update "u".toList .add (number 1))))
def loop : Stmt := .loop C99CountedWords.condition iteration increment
def counter : Stmt := .modular (.assign "u".toList (.scalar (number 0)))
def prologue : Stmt := .modular (.base (.scalar (.declare .u64 ["n".toList,"u".toList])))
def sizeAssign : Stmt := .modular (.assign "n".toList
  (.scalar (C99ArrayParser.mkn (var "logn") (var "ter"))))
def code : Stmt := chain [prologue,sizeAssign,.seq counter loop,ret 1]

theorem source_bound : region 4495 13=some code := by decide
theorem signature_source : (Pinned.keygenLines.drop 4491).take 3 =
  ["static int\n","poly_big_to_small(int16_t *d, const uint32_t *s, unsigned logn, unsigned ter)\n","{\n"] := by decide

end FT1536.Source3.KeygenSmallSource
