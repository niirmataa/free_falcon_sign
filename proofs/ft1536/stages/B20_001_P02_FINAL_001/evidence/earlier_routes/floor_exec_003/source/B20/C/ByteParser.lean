import B20.C.ByteMemory

namespace B20.C.Byte

def decimal (t : Token) : Option Nat :=
  if !t.isEmpty && t.all digit then some (t.foldl (fun n c => n * 10 + (c.toNat - 48)) 0) else none

abbrev Parser := List Token → Option (Expr × List Token)

def parenthesized (sub : Parser) (ts : List Token) : Option (Expr × List Token) := do
  let (e, rest) ← sub ts
  match rest with
  | [')'] :: tail => pure (e, tail)
  | _ => none

def unary (sub : Parser) : Nat → Parser
  | 0, _ => none
  | fuel + 1, ['('] :: ['u','i','n','t','6','4','_','t'] :: [')'] :: ts => do
    let (e, rest) ← unary sub fuel ts
    pure (.toWord e, rest)
  | fuel + 1, ['('] :: ['u','n','s','i','g','n','e','d'] :: ['c','h','a','r'] :: [')'] :: ts => do
    let (e, rest) ← unary sub fuel ts
    pure (.toByte e, rest)
  | _ + 1, ['('] :: ts => parenthesized sub ts
  | _ + 1, name :: ['['] :: i :: [']'] :: ts => do
    let index ← decimal i
    if index < 2147483648 then pure (.read name index, ts) else none
  | _ + 1, name :: ts =>
    if !name.isEmpty && name.all wordChar && !(digit name.head!) then
      some (.wordVar name, ts) else none
  | _ + 1, [] => none

def shiftTail : Nat → Expr → Parser
  | 0, _, _ => none
  | fuel + 1, left, ['>','>'] :: n :: ts => do
    let count ← decimal n
    if count < 2147483648 then shiftTail fuel (.shr left count) ts else none
  | fuel + 1, left, ['<','<'] :: n :: ts => do
    let count ← decimal n
    if count < 2147483648 then shiftTail fuel (.shl left count) ts else none
  | _ + 1, left, ts => some (left, ts)

def shifts (sub : Parser) : Parser := fun ts => do
  let (e, rest) ← sub ts
  shiftTail 16 e rest

def orTail (sub : Parser) : Nat → Expr → Parser
  | 0, _, _ => none
  | fuel + 1, left, ['|'] :: ts => do
    let (right, rest) ← sub ts
    orTail sub fuel (.bor left right) rest
  | _ + 1, left, ts => some (left, ts)

def expression : Nat → Parser
  | 0 => fun _ => none
  | fuel + 1 => fun ts => do
    let sub := shifts (unary (expression fuel) 16)
    let (left, rest) ← sub ts
    orTail sub 16 left rest

def parseStatement : List Token → Option (Statement × List Token)
  | ['c','o','n','s','t'] :: ['u','n','s','i','g','n','e','d'] :: ['c','h','a','r'] :: ['*'] :: name :: [';'] :: ts =>
    some (.declarePointer name true, ts)
  | ['u','n','s','i','g','n','e','d'] :: ['c','h','a','r'] :: ['*'] :: name :: [';'] :: ts =>
    some (.declarePointer name false, ts)
  | ['r','e','t','u','r','n'] :: ts => do
    let (e, rest) ← expression 16 ts
    match rest with
    | [';'] :: tail => pure (.ret e, tail)
    | _ => none
  | name :: ['['] :: i :: [']'] :: ['='] :: ts => do
    let index ← decimal i
    if index ≥ 2147483648 then none else do
      let (e, rest) ← expression 16 ts
      match rest with
      | [';'] :: tail => pure (.store name index e, tail)
      | _ => none
  | dst :: ['='] :: src :: [';'] :: ts => some (.assignPointer dst src, ts)
  | _ => none

def body : Nat → List Token → Option (List Statement × List Token)
  | 0, _ => none
  | _ + 1, ['}'] :: ts => some ([], ts)
  | fuel + 1, ts => do
    let (stmt, rest) ← parseStatement ts
    let (stmts, tail) ← body fuel rest
    pure (stmt :: stmts, tail)

def param : List Token → Option (Param × List Token)
  | ['c','o','n','s','t'] :: ['v','o','i','d'] :: ['*'] :: name :: ts =>
    some (.pointer true name, ts)
  | ['v','o','i','d'] :: ['*'] :: name :: ts => some (.pointer false name, ts)
  | ['u','i','n','t','6','4','_','t'] :: name :: ts => some (.word name, ts)
  | _ => none

def params : Nat → List Token → Option (List Param × List Token)
  | 0, _ => none
  | _ + 1, [')'] :: ts => some ([], ts)
  | fuel + 1, ts => do
    let (p, rest) ← param ts
    match rest with
    | [')'] :: tail => pure ([p], tail)
    | [','] :: tail => do
      let (ps, tail') ← params fuel tail
      pure (p :: ps, tail')
    | _ => none

def parseFunctionTokens : List Token → Option Function
  | ['s','t','a','t','i','c'] :: ['i','n','l','i','n','e'] :: ty :: name :: ['('] :: ts => do
    let returnsWord ← if ty == ['u','i','n','t','6','4','_','t'] then some true
      else if ty == ['v','o','i','d'] then some false else none
    let (ps, rest) ← params 8 ts
    match rest with
    | ['{'] :: tail => do
      let (stmts, rest) ← body 32 tail
      if rest.isEmpty then pure ⟨returnsWord, name, ps, stmts⟩ else none
    | _ => none
  | _ => none

def parseFunction (chars : List Char) : Option Function :=
  (B20.C.tokenize (chars.length + 1) chars).bind parseFunctionTokens

end B20.C.Byte
