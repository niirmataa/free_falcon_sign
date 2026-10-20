import Source3.CLogic
import B20.C.ScalarParser

namespace FT1536.Source3.CLogicParser
open B20.C FT1536.Source3.CLogic

def tokenize : Nat → List Char → Option (List Token)
  | 0,_ => none
  | _+1,[] => some []
  | fuel+1,'/'::'*'::rest => do
      let tail ← B20.C.Scalar.skipBlock (rest.length+1) rest
      tokenize fuel tail
  | fuel+1,'/'::'/'::rest => tokenize fuel (rest.dropWhile (· != '\n'))
  | fuel+1,c::cs =>
      if c==' ' || c=='\t' || c=='\n' || c=='\r' then tokenize fuel cs
      else if wordChar c then
        let tail:=cs.takeWhile wordChar
        (tokenize fuel (cs.drop tail.length)).map ((c::tail)::·)
      else match c,cs with
        | '>','>'::'='::rest => (tokenize fuel rest).map (['>','>','=']::·)
        | '<','<'::'='::rest => (tokenize fuel rest).map (['<','<','=']::·)
        | '>','>'::rest => (tokenize fuel rest).map (['>','>']::·)
        | '<','<'::rest => (tokenize fuel rest).map (['<','<']::·)
        | '&','&'::rest => (tokenize fuel rest).map (['&','&']::·)
        | '|','|'::rest => (tokenize fuel rest).map (['|','|']::·)
        | _,'='::rest =>
            if ['+','-','*','^','&','|','=','!','<','>'].contains c then
              (tokenize fuel rest).map ([c,'=']::·)
            else none
        | _,_ =>
            if ['(',')','{','}',';',',','^','&','|','-','+','*','~','=','!','<','>'].contains c then
              (tokenize fuel cs).map ([c]::·)
            else none

def number (t : Token) : Option CLogic.Expr := do
  match ← B20.C.Scalar.number t with
  | .literal ty n => pure (.literal ty n)
  | _ => none

inductive Op where
  | arithmetic (op : BinOp)
  | comparison (op : CLogic.Cmp)
  | land | lor

def Op.apply : Op → CLogic.Expr → CLogic.Expr → CLogic.Expr
  | .arithmetic op,a,b => .bin op a b
  | .comparison op,a,b => .cmp op a b
  | .land,a,b => .land a b
  | .lor,a,b => .lor a b

def opInfo : Token → Option (Op × Nat)
  | ['*'] => some (.arithmetic .mul,10)
  | ['+'] => some (.arithmetic .add,9)
  | ['-'] => some (.arithmetic .sub,9)
  | ['<','<'] => some (.arithmetic .shl,8)
  | ['>','>'] => some (.arithmetic .shr,8)
  | ['<'] => some (.comparison .lt,7)
  | ['<','='] => some (.comparison .le,7)
  | ['>'] => some (.comparison .gt,7)
  | ['>','='] => some (.comparison .ge,7)
  | ['=','='] => some (.comparison .eq,6)
  | ['!','='] => some (.comparison .ne,6)
  | ['&'] => some (.arithmetic .band,5)
  | ['^'] => some (.arithmetic .xor,4)
  | ['|'] => some (.arithmetic .bor,3)
  | ['&','&'] => some (.land,2)
  | ['|','|'] => some (.lor,1)
  | _ => none

abbrev Parser := List Token → Option (CLogic.Expr × List Token)

def parseArgs (sub : Parser) : Nat → List Token → Option (List CLogic.Expr × List Token)
  | 0,_ => none
  | fuel+1,ts => do
      let (e,rest) ← sub ts
      match rest with
      | [')']::tail => pure ([e],tail)
      | [',']::tail => do
          let (args,rest) ← parseArgs sub fuel tail
          pure (e::args,rest)
      | _ => none

def parseUnary (sub : Parser) : Nat → Parser
  | 0,_ => none
  | fuel+1,['-']::ts => do
      let (e,rest) ← parseUnary sub fuel ts
      pure (.neg e,rest)
  | fuel+1,['~']::ts => do
      let (e,rest) ← parseUnary sub fuel ts
      pure (.bitNot e,rest)
  | fuel+1,['!']::ts => do
      let (e,rest) ← parseUnary sub fuel ts
      pure (.lnot e,rest)
  | fuel+1,['(']::ty::[')']::ts =>
      match B20.C.Scalar.typeToken ty with
      | some t => do
          let (e,rest) ← parseUnary sub fuel ts
          pure (.cast t e,rest)
      | none => do
          let (e,rest) ← sub (ty::[')']::ts)
          match rest with | [')']::tail => pure (e,tail) | _ => none
  | _+1,['(']::ts => do
      let (e,rest) ← sub ts
      match rest with | [')']::tail => pure (e,tail) | _ => none
  | fuel+1,name::['(']::ts => do
      let (args,rest) ← parseArgs sub fuel ts
      match args with
      | [a] => pure (.call1 name a,rest)
      | [a,b] => pure (.call2 name a b,rest)
      | [a,b,c] => pure (.call3 name a b c,rest)
      | _ => none
  | _+1,t::ts =>
      if t.isEmpty then none
      else if digit t.head! then (number t).map (·,ts)
      else if t.all wordChar then some (.var t,ts) else none
  | _+1,[] => none

def parseMore (subPrec : Nat → Parser) (minPrec : Nat) : Nat → CLogic.Expr → Parser
  | _,left,[] => some (left,[])
  | 0,left,ts => some (left,ts)
  | fuel+1,left,t::ts =>
      match opInfo t with
      | none => some (left,t::ts)
      | some (op,prec) =>
          if prec<minPrec then some (left,t::ts)
          else do
            let (right,rest) ← subPrec (prec+1) ts
            parseMore subPrec minPrec fuel (op.apply left right) rest

def parseExpr : Nat → Nat → Parser
  | 0,_,_ => none
  | fuel+1,minPrec,ts => do
      let subPrec : Nat → Parser := fun prec => parseExpr fuel prec
      let (left,rest) ← parseUnary (subPrec 1) fuel ts
      parseMore subPrec minPrec fuel left rest

def expression : Nat → Parser := fun fuel ts => parseExpr fuel 1 ts

def statement : List Token → Option (CLogic.Stmt × List Token)
  | ['r','e','t','u','r','n']::ts => do
      let (e,rest) ← expression 16 ts
      match rest with | [';']::tail => pure (.ret e,tail) | _ => none
  | first::ts =>
      match B20.C.Scalar.typeToken first with
      | some ty => do
          let (names,rest) ← B20.C.Scalar.names 32 ts
          pure (.declare ty names,rest)
      | none => do
          match ts with
          | op::tail =>
              let (e,rest) ← expression 16 tail
              let stmt ← if op=['='] then some (.assign first e)
                else (B20.C.Scalar.updateOp op).map (fun operation => .update first operation e)
              match rest with | [';']::rest => pure (stmt,rest) | _ => none
          | _ => none
  | [] => none

def body : Nat → List Token → Option (List CLogic.Stmt × List Token)
  | 0,_ => none
  | _+1,['}']::ts => some ([],ts)
  | fuel+1,ts => do
      let (stmt,rest) ← statement ts
      let (stmts,tail) ← body fuel rest
      pure (stmt::stmts,tail)

def functionCore : List Token → Option CLogic.Function
  | ty::name::['(']::ts => do
      let result ← B20.C.Scalar.typeToken ty
      let (params,rest) ← B20.C.Scalar.params 16 ts
      match rest with
      | ['{']::tail => do
          let (stmts,rest) ← body 64 tail
          if rest.isEmpty then pure ⟨name,result,params,stmts⟩ else none
      | _ => none
  | _ => none

def parseFunctionTokens : List Token → Option CLogic.Function
  | ['s','t','a','t','i','c']::['i','n','l','i','n','e']::ts => functionCore ts
  | ['s','t','a','t','i','c']::ts => functionCore ts
  | ts => functionCore ts

def parseFunction (chars : List Char) : Option CLogic.Function :=
  (tokenize (chars.length+1) chars).bind parseFunctionTokens

end FT1536.Source3.CLogicParser
