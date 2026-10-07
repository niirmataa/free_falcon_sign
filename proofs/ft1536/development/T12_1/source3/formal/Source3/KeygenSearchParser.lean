import Source3.KeygenSearchExec

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Rejecting grammar for the additional constructs in ternary_depth0.
   sizeof is lowered only for a declared pointer element type; calls use the
   fixed signatures. The local FPC definition is checked separately. -/
namespace FT1536.Source3.KeygenSearchParser
open B20.C (Token Name)
open KeygenSearchExec

abbrev Types := List (Name×Nat)
def width (ctx : Types) (name : Name) : Option Nat := ((ctx.find? (fun p => p.1==name)).map Prod.snd)
def typeWidth (ty : Token) : Option Nat := do
  match ← B20.C.Scalar.typeToken ty with
  | .u64 | .i64 => pure 8
  | .u32 | .i32 => pure 4

def pointer : Nat → List Token → Option (PointerExpr×List Token)
  | 0,_ => none
  | fuel+1,['(']::ty::['*']::[')']::rest => do
    let size ← typeWidth ty
    let (value,rest) ← pointer fuel rest
    pure (.cast size value,rest)
  | fuel+1,['a','l','i','g','n','_','f','p','r']::['(']::rest => do
    let (base,rest) ← pointer fuel rest
    match rest with
    | [',']::rest => do
      let (data,rest) ← pointer fuel rest
      match rest with
      | [')']::rest => pure (.align base data,rest)
      | _ => none
    | _ => none
  | _+1,['f','k']::['-']::['>']::['t','m','p']::rest => pure (.tmp,rest)
  | _+1,rest => do
    let (arg,rest) ← C99ProcedureParser.pointerExpr rest
    match arg with
    | .pointer name index => pure (.named name index,rest)
    | _ => none

def expr : Nat → List Token → Option (Expr×List Token)
  | 0,_ => none
  | fuel+1,['(']::ty::[')']::name::['(']::rest => do
    let t ← B20.C.Scalar.typeToken ty
    let (value,rest) ← expr fuel (name::['(']::rest)
    pure (.cast (C99ValueBridge.type t) value,rest)
  | _+1,['z','i','n','t','_','o','n','e','_','t','o','_','p','l','a','i','n']::['(']::rest => do
    let (arg,rest) ← pointer 32 rest
    match rest with
    | [')']::tail => pure (.plain arg,tail)
    | _ => none
  | fuel+1,name::['(']::rest =>
    if name="MKN".toList then (C99ArrayParser.expr 32 (name::['(']::rest)).map (fun (e,tail) => (.base e,tail))
    else do
      let (first,rest) ← expr fuel rest
      match rest with
      | [')']::tail => pure (.unary name first,tail)
      | [',']::rest => do
        let (second,rest) ← expr fuel rest
        match rest with
        | [')']::tail => pure (.binary name first second,tail)
        | _ => none
      | _ => none
  | _+1,rest => (C99ArrayParser.expr 32 rest).map (fun (e,tail) => (.base e,tail))

def sizes (ctx : Types) : List Token → Option (List Token)
  | ['s','i','z','e','o','f']::['*']::name::rest => do
    let n ← width ctx name
    pure ((toString n++"ULL").toList::(← sizes ctx rest))
  | ['s','i','z','e','o','f']::['(']::['*']::name::[')']::rest => do
    let n ← width ctx name
    pure ((toString n++"ULL").toList::(← sizes ctx rest))
  | t::ts => do pure (t::(← sizes ctx ts))
  | [] => pure []

def simple (ctx : Types) : List Token → Option (Stmt×Types×List Token)
  | dst::['=']::['f','k']::['-']::['>']::['l','o','g','n']::[';']::rest => pure (.logn dst,ctx,rest)
  | ty::['*']::rest => do
    let n ← typeWidth ty
    let (names,rest) ← C99ProcedureParser.pointerNames 32 (['*']::rest)
    pure (chain (names.map (fun name => .procedure (.base (.declarePtr name)))),
      names.map (fun name => (name,n))++ctx,rest)
  | ['m','e','m','m','o','v','e']::['(']::rest => do
    let (dst,rest) ← pointer 32 rest
    match rest with
    | [',']::rest => do
      let (src,rest) ← pointer 32 rest
      match rest with
      | [',']::rest => do
        let (count,rest) ← C99ArrayParser.pureExpr rest
        match rest with
        | [')']::[';']::tail => pure (.move dst src count,ctx,tail)
        | _ => none
      | _ => none
    | _ => none
  | ['p','o','l','y','_','s','m','a','l','l','_','t','o','_','f','p']::['(']::rest => do
    let (args,rest) ← C99ProcedureParser.arguments KeygenSearchLeaves.smallParams rest
    match rest with
    | [';']::tail => pure (.small args,ctx,tail)
    | _ => none
  | dst::['[']::rest => do
    let n ← width ctx dst
    let (index,rest) ← C99ArrayParser.pureExpr rest
    match rest with
    | [']']::['=']::rest => do
      let (value,rest) ← expr 32 rest
      match rest with
      | [';']::tail => pure (.store n dst index value,ctx,tail)
      | _ => none
    | _ => none
  | dst::['=']::rest =>
    if (width ctx dst).isSome then do
      let (value,rest) ← pointer 32 rest
      match rest with
      | [';']::tail => pure (.pointer dst value,ctx,tail)
      | _ => none
    else do
      let (value,rest) ← expr 32 rest
      match rest with
      | [';']::tail => pure (.assign dst value,ctx,tail)
      | _ => none
  | rest => do
    let (code,_,tail) ← C99ProcedureParser.simple KeygenSearchFft.signatures (ctx.map Prod.fst) rest
    pure (.procedure code,ctx,tail)

def declarations : Stmt → List Name×List Name
  | .procedure code => C99ProcedureParser.localDeclarations code
  | .seq a b => ((declarations a).1++(declarations b).1,(declarations a).2++(declarations b).2)
  | _ => ([],[])

mutual
  def statement (ctx : Types) : Nat → List Token → Option (Stmt×Types×List Token)
    | 0,_ => none
    | fuel+1,['{']::rest => do
      let (code,_,rest) ← body ctx fuel rest
      let names := declarations code
      pure (.scope names.1 names.2 code,ctx,rest)
    | fuel+1,['f','o','r']::['(']::rest => do
      let (initial,rest) ← C99ProcedureParser.clauses [';'] 16 rest
      let (condition,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [';']::rest => do
        let (increment,rest) ← C99ProcedureParser.clauses [')'] 16 rest
        let (inner,_,rest) ← statement ctx fuel rest
        pure (.seq (.procedure initial) (.loop condition inner (.procedure increment)),ctx,rest)
      | _ => none
    | fuel+1,['i','f']::['(']::rest => do
      let (condition,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [')']::rest => do
        let (yes,_,rest) ← statement ctx fuel rest
        match rest with
        | ['e','l','s','e']::rest => do
          let (no,_,rest) ← statement ctx fuel rest
          pure (.branch condition yes no,ctx,rest)
        | _ => pure (.branch condition yes skip,ctx,rest)
      | _ => none
    | _+1,rest => simple ctx rest
  def body (ctx : Types) : Nat → List Token → Option (Stmt×Types×List Token)
    | 0,_ => none
    | _+1,['}']::rest => pure (skip,ctx,rest)
    | fuel+1,rest => do
      let (first,next,rest) ← statement ctx fuel rest
      let (tail,final,rest) ← body next fuel rest
      pure (.seq first tail,final,rest)
end

end FT1536.Source3.KeygenSearchParser
