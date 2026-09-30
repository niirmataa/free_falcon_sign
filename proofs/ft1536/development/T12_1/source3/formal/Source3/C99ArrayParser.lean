import Source3.C99ArrayReference
import Source3.LeafScan

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- A rejecting grammar for the straight-line and for-loop array fragment.
   Parsing fuel bounds syntax traversal only. Execution uses the unbounded
   reference rules. Qualifiers are retained in the parsed signature; the
   caller's memory/lifetime obligations are not inferred from output values. -/
namespace FT1536.Source3.C99ArrayParser
open B20.C (Token Ty)
open C99ArrayReference

def mkn (logn full : CLogic.Expr) : CLogic.Expr :=
  .bin .shl (.cast .u64 (.bin .add (.literal .i32 1) (.bin .shl full (.literal .i32 1))))
    (.bin .sub logn full)

def expand : CLogic.Expr → CLogic.Expr
  | .call2 name a b => if name="MKN".toList then mkn (expand a) (expand b) else .call2 name (expand a) (expand b)
  | .call1 name a => .call1 name (expand a)
  | .call3 name a b c => .call3 name (expand a) (expand b) (expand c)
  | .cast t e => .cast t (expand e)
  | .neg e => .neg (expand e)
  | .bitNot e => .bitNot (expand e)
  | .bin op a b => .bin op (expand a) (expand b)
  | .cmp op a b => .cmp op (expand a) (expand b)
  | .land a b => .land (expand a) (expand b)
  | .lor a b => .lor (expand a) (expand b)
  | .lnot a => .lnot (expand a)
  | e => e

def pureExpr (ts : List Token) : Option (CLogic.Expr×List Token) :=
  (CLogicParser.expression 24 ts).map (fun (e,rest) => (expand e,rest))

def expr : Nat → List Token → Option (Expr×List Token)
  | 0,_ => none
  | _+1,name::['[']::ts => do
      let (index,rest) ← pureExpr ts
      match rest with
      | [']']::tail => pure (.load name index,tail)
      | _ => none
  | fuel+1,name::['(']::ts =>
      if name="MKN".toList then (pureExpr (name::['(']::ts)).map (fun (e,rest) => (.scalar e,rest))
      else do
        let (a,rest) ← expr fuel ts
        match rest with
        | [')']::tail => pure (.call1 name a,tail)
        | [',']::rest => do
            let (b,rest) ← expr fuel rest
            match rest with
            | [')']::tail => pure (.call2 name a b,tail)
            | _ => none
        | _ => none
  | _+1,ts => (pureExpr ts).map (fun (e,rest) => (.scalar e,rest))

def scalarStmt : CLogic.Stmt → CLogic.Stmt
  | .assign name e => .assign name (expand e)
  | .update name op e => .update name op (expand e)
  | .ret e => .ret (expand e)
  | .declare t names => .declare t names

def simple : List Token → Option (Stmt×List Token)
  | name::['[']::ts => do
      let (index,rest) ← pureExpr ts
      match rest with
      | [']']::['=']::rest => do
          let (e,rest) ← expr 24 rest
          match rest with
          | [';']::tail => pure (.store64 name index e,tail)
          | _ => none
      | _ => none
  | name::['=']::ts => do
      let (e,rest) ← expr 24 ts
      match rest with
      | [';']::tail => pure (.assign name e,tail)
      | _ => none
  | ts => (CLogicParser.statement ts).map (fun (s,rest) => (.scalar (scalarStmt s),rest))

def declarations : Stmt → List Name
  | .scalar (.declare _ names) => names
  | .seq a b => declarations a++declarations b
  | _ => []

mutual
  def statement : Nat → List Token → Option (Stmt×List Token)
    | 0,_ => none
    | fuel+1,['f','o','r']::['(']::ts => do
        let (initial,rest) ← simple ts
        let (condition,rest) ← pureExpr rest
        match rest with
        | [';']::counter::['+','+']::[')']::rest => do
            let (inner,tail) ← statement fuel rest
            let increment : Stmt := .scalar (.update counter .add (.literal .i32 1))
            pure (.seq initial (.while condition (.seq inner increment)),tail)
        | _ => none
    | fuel+1,['{']::ts => do
        let (inner,rest) ← body fuel ts
        pure (.scope (declarations inner) [] inner,rest)
    | _+1,ts => simple ts
  def body : Nat → List Token → Option (Stmt×List Token)
    | 0,_ => none
    | _+1,['}']::rest => some (.skip,rest)
    | fuel+1,ts => do
        let (first,rest) ← statement fuel ts
        let (tail,rest) ← body fuel rest
        pure (.seq first tail,rest)
end

structure Parameter where
  value : Param
  pointee : Option Ty
  isConst : Bool
  restricted : Bool
  deriving DecidableEq, Repr

def parameter : List Token → Option (Parameter×List Token)
  | ['c','o','n','s','t']::ty::['*']::['r','e','s','t','r','i','c','t']::name::rest => do
      pure (⟨.pointer name,some (← B20.C.Scalar.typeToken ty),true,true⟩,rest)
  | ['c','o','n','s','t']::ty::['*']::name::rest => do
      pure (⟨.pointer name,some (← B20.C.Scalar.typeToken ty),true,false⟩,rest)
  | ty::['*']::['r','e','s','t','r','i','c','t']::name::rest => do
      pure (⟨.pointer name,some (← B20.C.Scalar.typeToken ty),false,true⟩,rest)
  | ty::['*']::name::rest => do
      pure (⟨.pointer name,some (← B20.C.Scalar.typeToken ty),false,false⟩,rest)
  | ty::name::rest => do
      pure (⟨.scalar (C99ValueBridge.type (← B20.C.Scalar.typeToken ty)) name,none,false,false⟩,rest)
  | _ => none

def parameters : Nat → List Token → Option (List Parameter×List Token)
  | 0,_ => none
  | fuel+1,ts => do
      let (p,rest) ← parameter ts
      match rest with
      | [')']::tail => pure ([p],tail)
      | [',']::tail => do
          let (ps,rest) ← parameters fuel tail
          pure (p::ps,rest)
      | _ => none

structure Parsed where
  name : Name
  parameters : List Parameter
  body : Stmt
  deriving DecidableEq, Repr
def Parsed.function (p : Parsed) : Function := ⟨p.parameters.map Parameter.value,p.body⟩

def parseTokens : List Token → Option Parsed
  | ['v','o','i','d']::name::['(']::ts => do
      let (ps,rest) ← parameters 16 ts
      match rest with
      | ['{']::rest => do
          let (code,tail) ← body 128 rest
          if tail.isEmpty then pure ⟨name,ps,code⟩ else none
      | _ => none
  | _ => none

/- The pinned M0 LP64 profile fixes size_t to the unsigned 64-bit type.
   The inherited scalar parser does not recognize that typedef spelling. -/
def normalizeTypes (ts : List Token) : List Token :=
  ts.map (fun t => if t="size_t".toList then "uint64_t".toList else t)

def parse (text : List Char) : Option Parsed :=
  ((LeafScan.tokenize (text.length+1) text).map normalizeTypes).bind parseTokens

end FT1536.Source3.C99ArrayParser
