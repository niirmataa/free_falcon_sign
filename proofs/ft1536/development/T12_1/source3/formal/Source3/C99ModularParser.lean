import Source3.C99ModularReference
import Source3.C99ProcedureParser

/- Rejecting parser for scalar control, uint32 reads and closed modular
   expression calls. Pointer types are bound by the enclosing declaration. -/
namespace FT1536.Source3.C99ModularParser
open C99ModularReference (Expr Stmt)
open B20.C (Token Name)

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
  | fuel+1,name::['(']::rest => do
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

def simple : List Token → Option (Stmt×List Token)
  | ['*']::rest => do
      let (name,index,rest) ← dereference rest
      match rest with
      | ['=']::rest => do
          let (e,rest) ← expr 32 rest
          match rest with
          | [';']::rest => pure (.store32 name index e,rest)
          | _ => none
      | _ => none
  | name::['[']::rest => do
      let (index,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [']']::['=']::rest => do
          let (e,rest) ← expr 32 rest
          match rest with
          | [';']::rest => pure (.store32 name index e,rest)
          | _ => none
      | _ => none
  | name::['=']::rest => do
      let (e,rest) ← expr 32 rest
      match rest with
      | [';']::rest => pure (.assign name e,rest)
      | _ => none
  | rest => do
      let (s,rest) ← CLogicParser.statement rest
      match s with
      | .ret e => pure (.ret (.scalar e),rest)
      | _ => pure (.base (.scalar s),rest)

def declarations : Stmt → List Name
  | .base (.scalar (.declare _ names)) => names
  | .seq a b => declarations a++declarations b
  | _ => []

mutual
  def statement : Nat → List Token → Option (Stmt×List Token)
    | 0,_ => none
    | fuel+1,['f','o','r']::['(']::rest => do
        let (initial,rest) ← simple rest
        let (condition,rest) ← C99ArrayParser.pureExpr rest
        match rest with
        | [';']::counter::['+','+']::[')']::rest => do
            let (inner,rest) ← statement fuel rest
            pure (.seq initial (.loop condition inner (.base (.scalar (.update counter .add (.literal .i32 1))))),rest)
        | _ => none
    | fuel+1,['i','f']::['(']::rest => do
        let (condition,rest) ← C99ArrayParser.pureExpr rest
        match rest with
        | [')']::rest => do
            let (yes,rest) ← statement fuel rest
            match rest with
            | ['e','l','s','e']::rest => do
                let (no,rest) ← statement fuel rest
                pure (.branch condition yes no,rest)
            | _ => pure (.branch condition yes (.base .skip),rest)
        | _ => none
    | fuel+1,['{']::rest => do
        let (inner,rest) ← body fuel rest
        pure (.scope (declarations inner) inner,rest)
    | _+1,rest => simple rest
  def body : Nat → List Token → Option (Stmt×List Token)
    | 0,_ => none
    | _+1,['}']::rest => some (.base .skip,rest)
    | fuel+1,rest => do
        let (first,rest) ← statement fuel rest
        let (tail,rest) ← body fuel rest
        pure (.seq first tail,rest)
end

def region (start count : Nat) : Option Stmt := do
  let chars := ((Pinned.keygenLines.drop (start-1)).take count).flatMap String.toList++['}']
  let tokens ← C99ProcedureParser.tokens chars
  let (code,rest) ← body 512 tokens
  if rest.isEmpty then pure code else none

end FT1536.Source3.C99ModularParser
