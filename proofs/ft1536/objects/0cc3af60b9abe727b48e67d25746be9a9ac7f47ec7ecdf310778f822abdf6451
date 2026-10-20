import Source3.ShakeSeedMemory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Small source grammar for the actual init/inject/flip bodies. Struct
   reads lower to fixed typed memory-read expressions, not symbolic values.
   sizeof sc->A is the declared uint64_t[25] extent. -/
namespace FT1536.Source3.ShakeSeedProgram
open C99ArrayReference (Name)
open B20.C (Token)
open ShakeExtractSource (Field)

def readName (member : Field) : Name := match member with
  | .dptr => "$seed_dptr".toList | .rate => "$seed_rate".toList
  | .a => "$seed_A".toList | .dbuf => "$seed_dbuf".toList
def member (f : Field) : CLogic.Expr := .call1 (readName f) (.literal .i32 0)
def var (name : String) : CLogic.Expr := .var name.toList
def num (n : Nat) : CLogic.Expr := .literal .i32 n
def zero : CLogic.Expr := num 0
def one : CLogic.Expr := num 1
def fieldToken : Token → Option Field := ShakeExtractSource.fieldToken
def typeToken (t : Token) : Option B20.C.Ty :=
  if t="size_t".toList then some .u64 else B20.C.Scalar.typeToken t
def unary (sub : CLogicParser.Parser) : Nat → CLogicParser.Parser
  | 0,_ => none
  | fuel+1,['-']::rest => (unary sub fuel rest).map (fun (e,t) => (.neg e,t))
  | fuel+1,['~']::rest => (unary sub fuel rest).map (fun (e,t) => (.bitNot e,t))
  | fuel+1,['!']::rest => (unary sub fuel rest).map (fun (e,t) => (.lnot e,t))
  | fuel+1,['(']::ty::[')']::rest =>
      match typeToken ty with
      | some t => (unary sub fuel rest).map (fun (e,tail) => (.cast t e,tail))
      | none => do
          let (e,tail) ← sub (ty::[')']::rest)
          match tail with | [')']::tail => pure (e,tail) | _ => none
  | _+1,['(']::rest => do
      let (e,tail) ← sub rest
      match tail with | [')']::tail => pure (e,tail) | _ => none
  | _+1,['s','c']::['-']::['>']::field::rest => do
      let f ← fieldToken field
      if f=.dptr || f=.rate then pure (member f,rest) else none
  | _+1,t::rest =>
      if t.isEmpty then none
      else if B20.C.digit t.head! then (CLogicParser.number t).map (fun e => (e,rest))
      else if t.all B20.C.wordChar then pure (.var t,rest) else none
  | _+1,[] => none
def expressionAt : Nat → Nat → CLogicParser.Parser
  | 0,_,_ => none
  | fuel+1,precedence,ts => do
      let sub := fun prec => expressionAt fuel prec
      let (head,rest) ← unary (sub 1) fuel ts
      CLogicParser.parseMore sub precedence fuel head rest
def expression : CLogicParser.Parser := expressionAt 32 1

inductive Stmt where
  | scalar (code : CLogic.Stmt)
  | declarePointer (name : Name)
  | pointer (dst src : Name) (index : CLogic.Expr)
  | readLocal (dst : Name) (field : Field)
  | write (field : Field) (value : CLogic.Expr)
  | store (field : Field) (index value : CLogic.Expr)
  | postByte (value : CLogic.Expr)
  | fill (field : Field) (start count : CLogic.Expr)
  | copyData (start count : CLogic.Expr)
  | xor (rate : CLogic.Expr)
  | process
  | skip
  | seq (first second : Stmt)
  | scope (locals pointers : List Name) (body : Stmt)
  | branch (condition : CLogic.Expr) (yes no : Stmt)
  | loop (condition : CLogic.Expr) (body : Stmt)
  deriving DecidableEq, Repr
def chain : List Stmt → Stmt | [] => .skip | first::rest => .seq first (chain rest)
def initRate : CLogic.Expr := .bin .sub (num 200) (.cast .u64 (.bin .shr (var "capacity") (num 3)))
def complementedZero : CLogic.Expr := .bitNot (.cast .u64 zero)
def initCode : Stmt := chain ([.write .rate initRate,.write .dptr zero,.fill .a zero (num 200)] ++
  [1,2,8,12,17,20].map (fun i => .store .a (num i) complementedZero))
def injectIteration : Stmt := .scope ["clen".toList] [] (chain [
  .scalar (.declare .u64 ["clen".toList]),
  .scalar (.assign "clen".toList (.bin .sub (var "rate") (var "dptr"))),
  .branch (.cmp .gt (var "clen") (var "len"))
    (.scope [] [] (chain [.scalar (.assign "clen".toList (var "len"))])) .skip,
  .copyData (var "dptr") (var "clen"),
  .scalar (.update "dptr".toList .add (var "clen")),.pointer "buf".toList "buf".toList (var "clen"),
  .scalar (.update "len".toList .sub (var "clen")),
  .branch (.cmp .eq (var "dptr") (var "rate"))
    (.scope [] [] (chain [.xor (var "rate"),.process,.scalar (.assign "dptr".toList zero)])) .skip])
def injectCode : Stmt := chain [.declarePointer "buf".toList,.scalar (.declare .u64 ["rate".toList,"dptr".toList]),
  .pointer "buf".toList "data".toList zero,.readLocal "rate".toList .rate,.readLocal "dptr".toList .dptr,
  .loop (.cmp .gt (var "len") zero) injectIteration,.write .dptr (var "dptr")]
def flipCode : Stmt := chain [
  .branch (.cmp .eq (.bin .add (member .dptr) one) (member .rate))
    (.scope [] [] (chain [.postByte (num 159)]))
    (.scope [] [] (chain [.postByte (num 31),
      .fill .dbuf (member .dptr) (.bin .sub (.bin .sub (member .rate) (member .dptr)) one),
      .store .dbuf (.bin .sub (member .rate) one) (num 128),.write .dptr (member .rate)])),
  .xor (member .rate)]

def simple : List Token → Option (Stmt × List Token)
  | ['c','o','n','s','t']::['u','n','s','i','g','n','e','d']::['c','h','a','r']::['*']::name::[';']::rest =>
      pure (.declarePointer name,rest)
  | ['b','u','f']::['=']::['d','a','t','a']::[';']::rest => pure (.pointer "buf".toList "data".toList zero,rest)
  | ['b','u','f']::['+','=']::rest => do
      let (index,tail) ← expression rest
      match tail with | [';']::tail => pure (.pointer "buf".toList "buf".toList index,tail) | _ => none
  | ['s','c']::['-']::['>']::field::['=']::rest => do
      let f ← fieldToken field
      let (value,tail) ← expression rest
      match tail with | [';']::tail => pure (.write f value,tail) | _ => none
  | ['s','c']::['-']::['>']::['d','b','u','f']::['[']::['s','c']::['-']::['>']::['d','p','t','r']::['+','+']::[']']::['=']::rest => do
      let (value,tail) ← expression rest
      match tail with | [';']::tail => pure (.postByte value,tail) | _ => none
  | ['s','c']::['-']::['>']::field::['[']::rest => do
      let f ← fieldToken field
      let (index,rest) ← expression rest
      match rest with
      | [']']::['=']::rest => do
          let (value,tail) ← expression rest
          match tail with | [';']::tail => pure (.store f index value,tail) | _ => none
      | _ => none
  | ['m','e','m','s','e','t']::['(']::['s','c']::['-']::['>']::['A']::[',']::['0']::[',']::['s','i','z','e','o','f']::['s','c']::['-']::['>']::['A']::[')']::[';']::rest =>
      pure (.fill .a zero (num 200),rest)
  | ['m','e','m','s','e','t']::['(']::['s','c']::['-']::['>']::['d','b','u','f']::['+']::rest => do
      let (start,rest) ← expression rest
      match rest with
      | [',']::['0','x','0','0']::[',']::rest => do
          let (count,tail) ← expression rest
          match tail with | [')']::[';']::tail => pure (.fill .dbuf start count,tail) | _ => none
      | _ => none
  | ['m','e','m','c','p','y']::['(']::['s','c']::['-']::['>']::['d','b','u','f']::['+']::rest => do
      let (start,rest) ← expression rest
      match rest with
      | [',']::['b','u','f']::[',']::rest => do
          let (count,tail) ← expression rest
          match tail with | [')']::[';']::tail => pure (.copyData start count,tail) | _ => none
      | _ => none
  | ['x','o','r','_','b','l','o','c','k']::['(']::['s','c']::['-']::['>']::['A']::[',']::['s','c']::['-']::['>']::['d','b','u','f']::[',']::rest => do
      let (rate,tail) ← expression rest
      match tail with | [')']::[';']::tail => pure (.xor rate,tail) | _ => none
  | ['p','r','o','c','e','s','s','_','b','l','o','c','k']::['(']::['s','c']::['-']::['>']::['A']::[')']::[';']::rest => pure (.process,rest)
  | dst::['=']::['s','c']::['-']::['>']::field::[';']::rest => do
      let f ← fieldToken field
      pure (.readLocal dst f,rest)
  | ty::rest =>
      match typeToken ty with
      | some t => do
          let (names,tail) ← B20.C.Scalar.names 32 rest
          pure (.scalar (.declare t names),tail)
      | none => do
          let (code,tail) ← CLogicParser.statement (ty::rest)
          pure (.scalar code,tail)
  | [] => none
def declarations : Stmt → List Name × List Name
  | .scalar (.declare _ names) => (names,[])
  | .declarePointer n => ([],[n])
  | .seq a b => ((declarations a).1++(declarations b).1,(declarations a).2++(declarations b).2)
  | _ => ([],[])
mutual
  def statement : Nat → List Token → Option (Stmt × List Token)
    | 0,_ => none
    | fuel+1,['{']::rest => do
        let (code,tail) ← body fuel rest
        let names := declarations code
        pure (.scope names.1 names.2 code,tail)
    | fuel+1,['i','f']::['(']::rest => do
        let (condition,rest) ← expression rest
        match rest with
        | [')']::rest => do
            let (yes,rest) ← statement fuel rest
            match rest with
            | ['e','l','s','e']::rest => do
                let (no,tail) ← statement fuel rest
                pure (.branch condition yes no,tail)
            | _ => pure (.branch condition yes .skip,rest)
        | _ => none
    | fuel+1,['w','h','i','l','e']::['(']::rest => do
        let (condition,rest) ← expression rest
        match rest with
        | [')']::rest => do
            let (code,tail) ← statement fuel rest
            pure (.loop condition code,tail)
        | _ => none
    | _+1,rest => simple rest
  def body : Nat → List Token → Option (Stmt × List Token)
    | 0,_ => none
    | _+1,['}']::rest => pure (.skip,rest)
    | fuel+1,rest => do
        let (head,rest) ← statement fuel rest
        let (tail,rest) ← body fuel rest
        pure (.seq head tail,rest)
end
def parsed (first length : Nat) : Option Stmt := do
  let tokens ← C99ProcedureParser.tokens (((ShakeSource.sourceLines.drop (first-1)).take length).flatMap String.toList)
  let (code,tail) ← body 96 tokens
  if tail.isEmpty then pure code else none
theorem init_source : parsed 519 10=some initCode := by decide
theorem inject_source : parsed 534 25=some injectCode := by decide
theorem flip_source : parsed 564 15=some flipCode := by decide
theorem signatures_source : (ShakeSource.sourceLines.drop 515).take 3=[
    "void\n","shake_init(shake_context *sc, int capacity)\n","{\n"] ∧
    (ShakeSource.sourceLines.drop 530).take 3=["void\n","shake_inject(shake_context *sc, const void *data, size_t len)\n","{\n"] ∧
    (ShakeSource.sourceLines.drop 560).take 3=["void\n","shake_flip(shake_context *sc)\n","{\n"] := by decide

end FT1536.Source3.ShakeSeedProgram
