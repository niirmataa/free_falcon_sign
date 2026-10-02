import Source3.C99ModularReference
import Source3.C99ProcedureParser

/- Rejecting parser for scalar control, uint32 reads and closed modular
   expression calls. Pointer types are bound by the enclosing declaration.
   Beyond the scalar fragment it accepts exactly the forward-NTT control
   syntax: void return, block-local uint32 pointer declarations, pointer
   assignment/advance through a pointer-name context, comma-separated
   for-clauses and compound updates. MKN is a macro and is expanded, never
   parsed as a call. -/
namespace FT1536.Source3.C99ModularParser
open C99ModularReference (Expr Stmt)
open B20.C (Token Name)

abbrev Context := List Name

def dereference : List Token → Option (Name×CLogic.Expr×List Token)
  | ['(']::rest => do
      let (pointer,rest) ← C99ProcedureParser.pointerExpr rest
      match pointer,rest with
      | .pointer name index,[')']::rest => pure (name,index,rest)
      | _,_ => none
  | name::rest => if name.all B20.C.wordChar && !name.isEmpty then
      some (name,.literal .u64 0,rest) else none
  | _ => none

def expr : Nat → List Token → Option (Expr×List Token)
  | 0,_ => none
  | _+1,['*']::rest => do
      let (name,index,rest) ← dereference rest
      pure (.load32 name index,rest)
  | _+1,name::['[']::rest => do
      let (index,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [']']::rest => pure (.load32 name index,rest)
      | _ => none
  | fuel+1,name::['(']::rest =>
      if name="MKN".toList then
        (C99ArrayParser.pureExpr (name::['(']::rest)).map (fun (e,rest) => (.scalar e,rest))
      else do
        let (a,rest) ← expr fuel rest
        match rest with
        | [')']::rest => pure (.call1 name a,rest)
        | [',']::rest => do
            let (b,rest) ← expr fuel rest
            match rest with
            | [')']::rest => pure (.call2 name a b,rest)
            | [',']::rest => do
                let (c,rest) ← expr fuel rest
                match rest with
                | [')']::rest => pure (.call3 name a b c,rest)
                | [',']::rest => do
                    let (d,rest) ← expr fuel rest
                    match rest with
                    | [')']::rest => pure (.call4 name a b c d,rest)
                    | _ => none
                | _ => none
            | _ => none
        | _ => none
  | _+1,rest => (C99ArrayParser.pureExpr rest).map (fun (e,rest) => (.scalar e,rest))

def chain : List Stmt → Stmt
  | [] => .base .skip
  | first::rest => .seq first (chain rest)

/- One for-clause: scalar assign/update with its ordinary expression, or
   pointer assignment/advance when the destination is a known pointer. A
   pointer increment is rejected rather than mis-parsed as scalar update. -/
def clause (ctx : Context) : List Token → Option (Stmt×List Token)
  | name::['+','+']::rest =>
      if ctx.contains name then none else
        some (.base (.scalar (.update name .add (.literal .i32 1))),rest)
  | name::op::rest =>
      if ctx.contains name then
        (match op with
        | ['='] => do
            let (p,rest) ← C99ProcedureParser.pointerExpr rest
            match p with
            | .pointer src index => pure (.base (.bindPtr name src index),rest)
            | _ => none
        | ['+','='] => do
            let (index,rest) ← C99ArrayParser.pureExpr rest
            pure (.base (.bindPtr name name index),rest)
        | _ => none)
      else do
        let (e,rest) ← expr 32 rest
        if op=['='] then pure (.assign name e,rest) else do
          let operation ← B20.C.Scalar.updateOp op
          match e with
          | .scalar code => pure (.base (.scalar (.update name operation code)),rest)
          | _ => none
  | _ => none

/- Comma-separated clauses with a parameterized terminator token. -/
def clauses (ctx : Context) (ending : Token) : Nat → List Token → Option (Stmt×List Token)
  | 0,_ => none
  | fuel+1,ts =>
      if ts.head?=some ending then some (.base .skip,ts.drop 1) else do
        let (first,rest) ← clause ctx ts
        match rest with
        | [',']::tail => do
            let (other,rest) ← clauses ctx ending fuel tail
            pure (.seq first other,rest)
        | last::tail => if last=ending then pure (first,tail) else none
        | _ => none

def simple (ctx : Context) : List Token → Option (Stmt×Context×List Token)
  | ['r','e','t','u','r','n']::[';']::rest => pure (.retVoid,ctx,rest)
  | ['*']::rest => do
      let (name,index,rest) ← dereference rest
      match rest with
      | ['=']::rest => do
          let (e,rest) ← expr 32 rest
          match rest with
          | [';']::rest => pure (.store32 name index e,ctx,rest)
          | _ => none
      | _ => none
  | name::['[']::rest => do
      let (index,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [']']::['=']::rest => do
          let (e,rest) ← expr 32 rest
          match rest with
          | [';']::rest => pure (.store32 name index e,ctx,rest)
          | _ => none
      | _ => none
  | ty::['*']::rest =>
      if B20.C.Scalar.typeToken ty≠some .u32 then none else do
        let (names,rest) ← C99ProcedureParser.pointerNames 32 (['*']::rest)
        pure (chain (names.map (fun n => .base (.declarePtr n))),names++ctx,rest)
  | name::['=']::rest =>
      if ctx.contains name then do
        let (p,rest) ← C99ProcedureParser.pointerExpr rest
        match p,rest with
        | .pointer src index,[';']::tail => pure (.base (.bindPtr name src index),ctx,tail)
        | _,_ => none
      else do
        let (e,rest) ← expr 32 rest
        match rest with
        | [';']::rest => pure (.assign name e,ctx,rest)
        | _ => none
  | rest => do
      let (s,rest) ← CLogicParser.statement rest
      match s with
      | .ret e => pure (.ret (.scalar e),ctx,rest)
      | _ => pure (.base (.scalar s),ctx,rest)

def declarations : Stmt → List Name
  | .base (.scalar (.declare _ names)) => names
  | .seq a b => declarations a++declarations b
  | _ => []

mutual
  def statement (ctx : Context) : Nat → List Token → Option (Stmt×Context×List Token)
    | 0,_ => none
    | fuel+1,['f','o','r']::['(']::rest => do
        let (initial,rest) ← clauses ctx [';'] 16 rest
        let (condition,rest) ← if rest.head?=some [';'] then
          some (CLogic.Expr.literal .i32 1,rest.drop 1) else do
            let (c,rest) ← C99ArrayParser.pureExpr rest
            match rest with | [';']::tail => pure (c,tail) | _ => none
        let (increment,rest) ← clauses ctx [')'] 16 rest
        let (inner,_,rest) ← statement ctx fuel rest
        pure (.seq initial (.loop condition inner increment),ctx,rest)
    | fuel+1,['i','f']::['(']::rest => do
        let (condition,rest) ← C99ArrayParser.pureExpr rest
        match rest with
        | [')']::rest => do
            let (yes,_,rest) ← statement ctx fuel rest
            match rest with
            | ['e','l','s','e']::rest => do
                let (no,_,rest) ← statement ctx fuel rest
                pure (.branch condition yes no,ctx,rest)
            | _ => pure (.branch condition yes (.base .skip),ctx,rest)
        | _ => none
    | fuel+1,['{']::rest => do
        let (inner,_,rest) ← body ctx fuel rest
        pure (.scope (declarations inner) inner,ctx,rest)
    | _+1,rest => simple ctx rest
  def body (ctx : Context) : Nat → List Token → Option (Stmt×Context×List Token)
    | 0,_ => none
    | _+1,['}']::rest => some (.base .skip,ctx,rest)
    | fuel+1,rest => do
        let (first,next,rest) ← statement ctx fuel rest
        let (tail,final,rest) ← body next fuel rest
        pure (.seq first tail,final,rest)
end

def regionContext (ctx : Context) (start count : Nat) : Option Stmt := do
  let chars := ((Pinned.keygenLines.drop (start-1)).take count).flatMap String.toList++['}']
  let tokens ← C99ProcedureParser.tokens chars
  let (code,_,rest) ← body ctx 512 tokens
  if rest.isEmpty then pure code else none

def region (start count : Nat) : Option Stmt := regionContext [] start count

end FT1536.Source3.C99ModularParser
