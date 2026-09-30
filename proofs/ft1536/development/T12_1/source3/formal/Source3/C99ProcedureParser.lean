import Source3.C99ProcedureReference
import Source3.FpcSourceExpansion

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Rejecting source grammar for FFT/LDL procedures. It retains return, loop
   increment, compound call assignment, pointer declarations and macro scope.
   Signatures supply argument kinds, not callee postconditions. -/
namespace FT1536.Source3.C99ProcedureParser
open B20.C (Token)
open C99ArrayReference (Name Arg Param Expr)
open C99ProcedureReference (Stmt Function Destination)

abbrev Signatures := Name → Option (List Param×Option C99IntegerReference.Ty)
abbrev Context := List Name

def zero : CLogic.Expr := .literal .u64 0
def skip : Stmt := .base .skip
def chain : List Stmt → Stmt
  | [] => skip
  | s::ss => .seq s (chain ss)

def pointerExpr (ts : List Token) : Option (Arg×List Token) :=
  match ts with
  | name::['+']::rest => do
      let (i,rest) ← C99ArrayParser.pureExpr rest
      pure (.pointer name i,rest)
  | name::rest => if name.isEmpty then none else some (.pointer name zero,rest)
  | _ => none

def argument (p : Param) (ts : List Token) : Option (Arg×List Token) :=
  match p with
  | .pointer _ => pointerExpr ts
  | .scalar _ _ => (C99ArrayParser.pureExpr ts).map (fun (e,rest) => (.scalar e,rest))

def arguments : List Param → List Token → Option (List Arg×List Token)
  | [],[')']::rest => some ([],rest)
  | [p],ts => do
      let (a,rest) ← argument p ts
      match rest with
      | [')']::tail => pure ([a],tail)
      | _ => none
  | p::q::ps,ts => do
      let (a,rest) ← argument p ts
      match rest with
      | [',']::tail => do
          let (args,rest) ← arguments (q::ps) tail
          pure (a::args,rest)
      | _ => none
  | _,_ => none

def macroArguments : Nat → List Token → Option (List Expr×List Token)
  | 0,_ => none
  | fuel+1,ts => do
      let (e,rest) ← C99ArrayParser.expr 24 ts
      match rest with
      | [')']::tail => pure ([e],tail)
      | [',']::tail => do
          let (es,rest) ← macroArguments fuel tail
          pure (e::es,rest)
      | _ => none

def call (signatures : Signatures) (destination : Destination) : List Token → Option (Stmt×List Token)
  | name::['(']::rest => do
      let (params,_) ← signatures name
      let (args,rest) ← arguments params rest
      match rest with
      | [';']::tail => pure (.call name args destination,tail)
      | _ => none
  | _ => none

def pointerNames : Nat → List Token → Option (List Name×List Token)
  | 0,_ => none
  | fuel+1,['*']::name::rest =>
      match rest with
      | [';']::tail => some ([name],tail)
      | [',']::tail => do
          let (names,rest) ← pointerNames fuel tail
          pure (name::names,rest)
      | _ => none
  | _,_ => none

def memcpyCall (ctx : Context) (ts : List Token) : Option (Stmt×List Token) := do
  let (dst,rest) ← pointerExpr ts
  match rest with
  | [',']::rest =>
      let (src,rest) ← pointerExpr rest
      match dst,src,rest with
      | .pointer d di,.pointer s si,[',']::count::['*']::['s','i','z','e','o','f']::['*']::element::[')']::[';']::tail =>
          if ctx.contains element then
            pure (.base (.copy d s di si (.bin .mul (.var count) (.literal .u64 8))),tail)
          else none
      | _,_,_ => none
  | _ => none

def simple (signatures : Signatures) (ctx : Context) (ts : List Token) : Option (Stmt×Context×List Token) := do
  match ts with
  | [';']::rest => pure (skip,ctx,rest)
  | ['r','e','t','u','r','n']::[';']::rest => pure (.ret none,ctx,rest)
  | ['r','e','t','u','r','n']::rest =>
      let (e,rest) ← C99ArrayParser.expr 24 rest
      match rest with
      | [';']::tail => pure (.ret (some e),ctx,tail)
      | _ => none
  | ['b','r','e','a','k']::[';']::rest => pure (.breakLoop,ctx,rest)
  | ['c','o','n','t','i','n','u','e']::[';']::rest => pure (.continueLoop,ctx,rest)
  | ['*']::name::['=']::rest =>
      let (e,rest) ← C99ArrayParser.expr 24 rest
      match rest with
      | [';']::tail => pure (.base (.store64 name zero e),ctx,tail)
      | _ => none
  | ty::['*']::rest =>
      if B20.C.Scalar.typeToken ty≠some .u64 then none else do
        let (names,rest) ← pointerNames 32 (['*']::rest)
        pure (chain (names.map (fun n => .base (.declarePtr n))),names++ctx,rest)
  | ['m','e','m','c','p','y']::['(']::rest =>
      let (code,rest) ← memcpyCall ctx rest
      pure (code,ctx,rest)
  | lhs::op::fn::['(']::rest =>
      if (signatures fn).isSome && (op=['='] || op=['+','=']) then do
        let dst := if op=['='] then Destination.assign lhs else .update lhs .add
        let (code,rest) ← call signatures dst (fn::['(']::rest)
        pure (code,ctx,rest)
      else do
        let (code,rest) ← C99ArrayParser.simple ts
        pure (.base code,ctx,rest)
  | lhs::['=']::rest =>
      if ctx.contains lhs then do
        let (p,rest) ← pointerExpr rest
        match p,rest with
        | .pointer src i,[';']::tail => pure (.base (.bindPtr lhs src i),ctx,tail)
        | _,_ => none
      else do
        let (code,rest) ← C99ArrayParser.simple ts
        pure (.base code,ctx,rest)
  | name::['(']::rest =>
      match FpcSourceExpansion.lookup name with
      | some kind => do
          let (args,rest) ← macroArguments 8 rest
          let code ← FpcSourceExpansion.cached kind args
          match rest with
          | [';']::tail => pure (.base code,ctx,tail)
          | _ => none
      | none => do
          let (code,rest) ← call signatures .discard ts
          pure (code,ctx,rest)
  | _ =>
      let (code,rest) ← C99ArrayParser.simple ts
      pure (.base code,ctx,rest)

def clause : List Token → Option (Stmt×List Token)
  | name::['+','+']::rest => some (.base (.scalar (.update name .add (.literal .i32 1))),rest)
  | name::op::rest => do
      let (e,rest) ← C99ArrayParser.pureExpr rest
      if op=['='] then pure (.base (.scalar (.assign name e)),rest) else do
        let bop ← B20.C.Scalar.updateOp op
        pure (.base (.scalar (.update name bop e)),rest)
  | _ => none

def clauses (ending : Token) : Nat → List Token → Option (Stmt×List Token)
  | 0,_ => none
  | fuel+1,ts =>
      if ts.head?=some ending then some (skip,ts.drop 1) else do
        let (first,rest) ← clause ts
        match rest with
        | [',']::tail => do
            let (other,rest) ← clauses ending fuel tail
            pure (.seq first other,rest)
        | last::tail => if last=ending then pure (first,tail) else none
        | _ => none

def localDeclarations : Stmt → List Name×List Name
  | .base (.scalar (.declare _ ns)) => (ns,[])
  | .base (.declarePtr n) => ([],[n])
  | .seq a b =>
      let left := localDeclarations a
      let right := localDeclarations b
      (left.1++right.1,left.2++right.2)
  | _ => ([],[])

mutual
  def statement (signatures : Signatures) (ctx : Context) : Nat → List Token → Option (Stmt×Context×List Token)
    | 0,_ => none
    | fuel+1,['{']::rest => do
        let (code,_,rest) ← body signatures ctx fuel rest
        let decls := localDeclarations code
        pure (.scope decls.1 decls.2 code,ctx,rest)
    | fuel+1,['i','f']::['(']::rest => do
        let (condition,rest) ← C99ArrayParser.pureExpr rest
        match rest with
        | [')']::tail => do
            let (yes,_,rest) ← statement signatures ctx fuel tail
            match rest with
            | ['e','l','s','e']::tail => do
                let (no,_,rest) ← statement signatures ctx fuel tail
                pure (.branch condition yes no,ctx,rest)
            | _ => pure (.branch condition yes skip,ctx,rest)
        | _ => none
    | fuel+1,['f','o','r']::['(']::rest => do
        let (initial,rest) ← clauses [';'] 16 rest
        let (condition,rest) ← if rest.head?=some [';'] then
          some (CLogic.Expr.literal .i32 1,rest.drop 1) else do
            let (c,rest) ← C99ArrayParser.pureExpr rest
            match rest with | [';']::tail => pure (c,tail) | _ => none
        let (increment,rest) ← clauses [')'] 16 rest
        let (inner,_,rest) ← statement signatures ctx fuel rest
        pure (.seq initial (.loop condition inner increment),ctx,rest)
    | fuel+1,['w','h','i','l','e']::['(']::rest => do
        let (condition,rest) ← C99ArrayParser.pureExpr rest
        match rest with
        | [')']::rest => do
            let (inner,_,rest) ← statement signatures ctx fuel rest
            pure (.loop condition inner skip,ctx,rest)
        | _ => none
    | _+1,ts => simple signatures ctx ts
  def body (signatures : Signatures) (ctx : Context) : Nat → List Token → Option (Stmt×Context×List Token)
    | 0,_ => none
    | _+1,['}']::rest => some (skip,ctx,rest)
    | fuel+1,ts => do
        let (first,next,rest) ← statement signatures ctx fuel ts
        let (tail,final,rest) ← body signatures next fuel rest
        pure (.seq first tail,final,rest)
end

structure Header where
  name : Name
  parameters : List C99ArrayParser.Parameter
  result : Option C99IntegerReference.Ty
  deriving DecidableEq, Repr
def headerCore : List Token → Option (Header×List Token)
  | result::name::['(']::rest => do
      let ty ← if result="void".toList then some none else
        (B20.C.Scalar.typeToken result).map (fun t => some (C99ValueBridge.type t))
      let (ps,rest) ← C99ArrayParser.parameters 16 rest
      if !(ps.all (fun p => p.pointee==none || p.pointee==some .u64)) then none else do
        match rest with
        | ['{']::tail => pure (⟨name,ps,ty⟩,tail)
        | _ => none
  | _ => none
def header : List Token → Option (Header×List Token)
  | ['s','t','a','t','i','c']::rest => headerCore rest
  | ts => headerCore ts
def Header.context (h : Header) : Context := h.parameters.filterMap (fun p =>
  match p.value with | .pointer n => some n | _ => none)
structure Parsed where
  header : Header
  body : Stmt
  deriving DecidableEq, Repr
def Parsed.function (p : Parsed) : Function := ⟨p.header.parameters.map C99ArrayParser.Parameter.value,p.header.result,p.body⟩

def tokens (text : List Char) : Option (List Token) :=
  (LeafScan.tokenize (text.length+1) text).map C99ArrayParser.normalizeTypes
def signature (text : List Char) : Option Header := ((tokens text).bind header).map Prod.fst
def parse (signatures : Signatures) (text : List Char) : Option Parsed := do
  let (h,rest) ← (tokens text).bind header
  let (code,_,tail) ← body signatures h.context 256 rest
  if tail.isEmpty then pure ⟨h,code⟩ else none

end FT1536.Source3.C99ProcedureParser
