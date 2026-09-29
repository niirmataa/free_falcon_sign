import B20.C.Scalar
import B20.C.Parser

namespace B20.C.Scalar

def skipBlock : Nat → List Char → Option (List Char)
  | 0, _ => none
  | _ + 1, '*' :: '/' :: rest => some rest
  | fuel + 1, _ :: rest => skipBlock fuel rest
  | _ + 1, [] => none

def tokenize : Nat → List Char → Option (List Token)
  | 0, _ => none
  | _ + 1, [] => some []
  | fuel + 1, '/' :: '*' :: rest => do
    let tail ← skipBlock (rest.length + 1) rest
    tokenize fuel tail
  | fuel + 1, '/' :: '/' :: rest => tokenize fuel (rest.dropWhile (· != '\n'))
  | fuel + 1, c :: cs =>
    if c == ' ' || c == '\t' || c == '\n' || c == '\r' then tokenize fuel cs
    else if wordChar c then
      let tail := cs.takeWhile wordChar
      (tokenize fuel (cs.drop tail.length)).map ((c :: tail) :: ·)
    else match c, cs with
      | '>', '>' :: '=' :: rest => (tokenize fuel rest).map (['>','>','='] :: ·)
      | '<', '<' :: '=' :: rest => (tokenize fuel rest).map (['<','<','='] :: ·)
      | '>', '>' :: rest => (tokenize fuel rest).map (['>','>'] :: ·)
      | '<', '<' :: rest => (tokenize fuel rest).map (['<','<'] :: ·)
      | _, '=' :: rest =>
        if ['+', '-', '*', '^', '&', '|'].contains c then (tokenize fuel rest).map ([c,'='] :: ·)
        else none
      | _, _ =>
        if ['(', ')', '{', '}', ';', ',', '^', '&', '|', '-', '+', '*', '~', '='].contains c then
          (tokenize fuel cs).map ([c] :: ·)
        else none

def typeToken : Token → Option Ty
  | ['i','n','t'] => some .i32
  | ['l','o','n','g'] | ['i','n','t','6','4','_','t'] => some .i64
  | ['u','n','s','i','g','n','e','d'] | ['u','i','n','t','3','2','_','t'] => some .u32
  | ['f','p','r'] | ['u','i','n','t','6','4','_','t'] => some .u64
  | _ => none

def hexDigit (c : Char) : Bool :=
  digit c || ('a' ≤ c && c ≤ 'f') || ('A' ≤ c && c ≤ 'F')

def digitValue (c : Char) : Nat :=
  if digit c then c.toNat - 48
  else if 'a' ≤ c && c ≤ 'f' then c.toNat - 87
  else c.toNat - 55

def literalType (hex : Bool) (suffix : List Char) (n : Nat) : Option Ty :=
  if n ≥ 2^64 then none
  else if suffix = ['U'] || suffix = ['u'] then
    if n < 2^32 then some .u32 else some .u64
  else if suffix = ['U','L'] || suffix = ['U','L','L'] || suffix = ['u','l'] || suffix = ['u','l','l'] then some .u64
  else if suffix.isEmpty then
    if n < 2^31 then some .i32
    else if hex && n < 2^32 then some .u32
    else if n < 2^63 then some .i64
    else if hex then some .u64 else none
  else none

def number (t : Token) : Option Expr := do
  let (hex, digitsAndSuffix) := match t with
    | '0' :: 'x' :: rest => (true, rest)
    | '0' :: 'X' :: rest => (true, rest)
    | _ => (false, t)
  let ds := digitsAndSuffix.takeWhile (if hex then hexDigit else digit)
  if ds.isEmpty then none else do
    let suffix := digitsAndSuffix.drop ds.length
    let base := if hex then 16 else 10
    let n := ds.foldl (fun acc c => acc * base + digitValue c) 0
    let ty ← literalType hex suffix n
    pure (.literal ty n)

def opInfo : Token → Option (BinOp × Nat)
  | ['*'] => some (.mul, 6)
  | ['+'] => some (.add, 5)
  | ['-'] => some (.sub, 5)
  | ['<','<'] => some (.shl, 4)
  | ['>','>'] => some (.shr, 4)
  | ['&'] => some (.band, 3)
  | ['^'] => some (.xor, 2)
  | ['|'] => some (.bor, 1)
  | _ => none

abbrev Parser := List Token → Option (Expr × List Token)

def parenthesized (sub : Parser) (ts : List Token) : Option (Expr × List Token) := do
  let (e, rest) ← sub ts
  match rest with
  | [')'] :: tail => pure (e, tail)
  | _ => none

def arguments (sub : Parser) : Nat → List Token → Option (List Expr × List Token)
  | 0, _ => none
  | fuel + 1, ts => do
    let (e, rest) ← sub ts
    match rest with
    | [')'] :: tail => pure ([e], tail)
    | [','] :: tail => do
      let (args, rest) ← arguments sub fuel tail
      pure (e :: args, rest)
    | _ => none

def unary (sub : Parser) : Nat → Parser
  | 0, _ => none
  | fuel + 1, ['-'] :: ts => do
    let (e, rest) ← unary sub fuel ts
    pure (.neg e, rest)
  | fuel + 1, ['~'] :: ts => do
    let (e, rest) ← unary sub fuel ts
    pure (.bitNot e, rest)
  | fuel + 1, ['('] :: ty :: [')'] :: ts =>
    match typeToken ty with
    | some t => do
      let (e, rest) ← unary sub fuel ts
      pure (.cast t e, rest)
    | none => parenthesized sub (ty :: [')'] :: ts)
  | _ + 1, ['('] :: ts => parenthesized sub ts
  | _ + 1, name :: ['('] :: ts => do
    let (args, rest) ← arguments sub 4 ts
    match args with
    | [a] => pure (.call1 name a, rest)
    | [a,b] => pure (.call2 name a b, rest)
    | [a,b,c] => pure (.call3 name a b c, rest)
    | _ => none
  | _ + 1, t :: ts =>
    if t.isEmpty then none
    else if digit t.head! then (number t).map (·, ts)
    else if t.all wordChar then some (.var t, ts) else none
  | _ + 1, [] => none

def parseTail (sub : Parser) (precedence : Nat) : Nat → Expr → Parser
  | 0, _, _ => none
  | fuel + 1, left, t :: ts =>
    match opInfo t with
    | some (op, prec) => if prec = precedence then do
        let (right, rest) ← sub ts
        parseTail sub precedence fuel (.bin op left right) rest
      else some (left, t :: ts)
    | none => some (left, t :: ts)
  | _ + 1, left, [] => some (left, [])

def level (sub : Parser) (precedence : Nat) : Parser := fun ts => do
  let (e, rest) ← sub ts
  parseTail sub precedence 32 e rest

def expression : Nat → Parser
  | 0 => fun _ => none
  | fuel + 1 =>
    let atom := unary (expression fuel) 16
    level (level (level (level (level (level atom 6) 5) 4) 3) 2) 1

def names : Nat → List Token → Option (List Name × List Token)
  | 0, _ => none
  | _ + 1, name :: [';'] :: ts => some ([name], ts)
  | fuel + 1, name :: [','] :: ts => do
    let (rest, tail) ← names fuel ts
    pure (name :: rest, tail)
  | _ + 1, _ => none

def updateOp : Token → Option BinOp
  | ['+','='] => some .add
  | ['-','='] => some .sub
  | ['*','='] => some .mul
  | ['&','='] => some .band
  | ['|','='] => some .bor
  | ['^','='] => some .xor
  | ['>','>','='] => some .shr
  | ['<','<','='] => some .shl
  | _ => none

def statement : List Token → Option (Stmt × List Token)
  | ['r','e','t','u','r','n'] :: ts => do
    let (e, rest) ← expression 16 ts
    match rest with
    | [';'] :: tail => pure (.ret e, tail)
    | _ => none
  | first :: ts =>
    match typeToken first with
    | some ty => do
      let (ns, rest) ← names 16 ts
      pure (.declare ty ns, rest)
    | none => do
      match ts with
      | op :: ts =>
        let (e, rest) ← expression 16 ts
        let stmt ← if op = ['='] then some (.assign first e)
          else (updateOp op).map (fun operation => .update first operation e)
        match rest with
        | [';'] :: tail => pure (stmt, tail)
        | _ => none
      | _ => none
  | [] => none

def body : Nat → List Token → Option (List Stmt × List Token)
  | 0, _ => none
  | _ + 1, ['}'] :: ts => some ([], ts)
  | fuel + 1, ts => do
    let (stmt, rest) ← statement ts
    let (stmts, tail) ← body fuel rest
    pure (stmt :: stmts, tail)

def params : Nat → List Token → Option (List (Ty × Name) × List Token)
  | 0, _ => none
  | _ + 1, [')'] :: ts => some ([], ts)
  | fuel + 1, ty :: name :: sep :: ts => do
    let t ← typeToken ty
    if sep = [')'] then pure ([(t, name)], ts)
    else if sep = [','] then do
      let (rest, tail) ← params fuel ts
      pure ((t, name) :: rest, tail)
    else none
  | _ + 1, _ => none

def functionCore : List Token → Option Function
  | ty :: name :: ['('] :: ts => do
    let result ← typeToken ty
    let (ps, rest) ← params 8 ts
    match rest with
    | ['{'] :: tail => do
      let (stmts, rest) ← body 64 tail
      if rest.isEmpty then pure ⟨name, result, ps, stmts⟩ else none
    | _ => none
  | _ => none

def parseFunctionTokens : List Token → Option Function
  | ['s','t','a','t','i','c'] :: ['i','n','l','i','n','e'] :: ts => functionCore ts
  | ts => functionCore ts

def parseFunction (chars : List Char) : Option Function :=
  (tokenize (chars.length + 1) chars).bind parseFunctionTokens

end B20.C.Scalar
