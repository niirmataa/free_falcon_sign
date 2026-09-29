import B20.C.Syntax

namespace B20.C

abbrev Token := List Char

def wordChar (c : Char) : Bool :=
  ('a' ≤ c && c ≤ 'z') || ('A' ≤ c && c ≤ 'Z') ||
  ('0' ≤ c && c ≤ '9') || c == '_'

def digit (c : Char) : Bool := '0' ≤ c && c ≤ '9'

def tokenize : Nat → List Char → Option (List Token)
  | 0, _ => none
  | _ + 1, [] => some []
  | fuel + 1, c :: cs =>
    if c == ' ' || c == '\t' || c == '\n' || c == '\r' then tokenize fuel cs
    else if wordChar c then
      let tail := cs.takeWhile wordChar
      (tokenize fuel (cs.drop tail.length)).map ((c :: tail) :: ·)
    else match c, cs with
      | '>', '>' :: rest => (tokenize fuel rest).map (['>', '>'] :: ·)
      | '<', '<' :: rest => (tokenize fuel rest).map (['<', '<'] :: ·)
      | '^', '=' :: rest => (tokenize fuel rest).map (['^', '='] :: ·)
      | _, _ =>
        if ['(', ')', '{', '}', ';', ',', '^', '&', '|', '-', '='].contains c then
          (tokenize fuel cs).map ([c] :: ·)
        else none

def parseTy : Token → Option Ty
  | ['u','i','n','t','6','4','_','t'] => some .u64
  | ['i','n','t','6','4','_','t'] => some .i64
  | ['i','n','t'] => some .i32
  | _ => none

def opInfo : Token → Option (BinOp × Nat)
  | ['<','<'] => some (.shl, 4)
  | ['>','>'] => some (.shr, 4)
  | ['&'] => some (.band, 3)
  | ['^'] => some (.xor, 2)
  | ['|'] => some (.bor, 1)
  | _ => none

/-! Precedence climbing parser: casts/unary minus bind above shifts, then
bitwise AND, XOR, OR. Binary operations associate to the left. -/
mutual
  def parseExpr : Nat → Nat → List Token → Option (Expr × List Token)
    | 0, _, _ => none
    | fuel + 1, minPrec, ts => do
      let (left, rest) ← parseUnary fuel ts
      parseMore fuel minPrec left rest

  def parseUnary : Nat → List Token → Option (Expr × List Token)
    | 0, _ => none
    | fuel + 1, ['-'] :: ts => do
      let (e, rest) ← parseUnary fuel ts
      pure (.neg e, rest)
    | fuel + 1, ['('] :: ty :: [')'] :: ts => do
      match parseTy ty with
      | some t =>
        let (e, rest) ← parseUnary fuel ts
        pure (.cast t e, rest)
      | none => parseParen fuel (ty :: [')'] :: ts)
    | fuel + 1, ['('] :: ts => parseParen fuel ts
    | _ + 1, t :: ts =>
      if t.isEmpty then none
      else if t.all digit then
        some (.literal (t.foldl (fun n c => 10 * n + (c.toNat - 48)) 0), ts)
      else if t.all wordChar && !(digit (t.head!)) then some (.var t, ts)
      else none
    | _ + 1, [] => none

  def parseParen : Nat → List Token → Option (Expr × List Token)
    | 0, _ => none
    | fuel + 1, ts => do
      let (e, rest) ← parseExpr fuel 1 ts
      match rest with
      | [')'] :: tail => pure (e, tail)
      | _ => none

  def parseMore : Nat → Nat → Expr → List Token → Option (Expr × List Token)
    | 0, _, _, _ => none
    | fuel + 1, minPrec, left, t :: ts =>
      match opInfo t with
      | none => some (left, t :: ts)
      | some (op, prec) =>
        if prec < minPrec then some (left, t :: ts)
        else do
          let (right, rest) ← parseExpr fuel (prec + 1) ts
          parseMore fuel minPrec (.bin op left right) rest
    | _ + 1, _, left, [] => some (left, [])
end

def parseStmts : Nat → List Token → Option (List Stmt × List Token)
  | 0, _ => none
  | _ + 1, ['}'] :: ts => some ([], ts)
  | fuel + 1, ['r','e','t','u','r','n'] :: ts => do
    let (e, rest) ← parseExpr fuel 1 ts
    match rest with
    | [';'] :: rest =>
      let (body, tail) ← parseStmts fuel rest
      pure (.ret e :: body, tail)
    | _ => none
  | fuel + 1, name :: op :: ts => do
    let (e, rest) ← parseExpr fuel 1 ts
    let stmt ← if op == ['='] then some (.assign name e)
      else if op == ['^','='] then some (.xorAssign name e) else none
    match rest with
    | [';'] :: rest =>
      let (body, tail) ← parseStmts fuel rest
      pure (stmt :: body, tail)
    | _ => none
  | _ + 1, _ => none

def parseParams : Nat → List Token → Option (List (Ty × Name) × List Token)
  | 0, _ => none
  | _ + 1, [')'] :: ts => some ([], ts)
  | fuel + 1, ty :: name :: sep :: ts => do
    let t ← parseTy ty
    if sep == [')'] then pure ([(t, name)], ts)
    else if sep == [','] then
      let (params, rest) ← parseParams fuel ts
      pure ((t, name) :: params, rest)
    else none
  | _ + 1, _ => none

def parseFunctionTokens (ts : List Token) : Option Function := do
  match ts with
  | ['s','t','a','t','i','c'] :: ['i','n','l','i','n','e'] :: ty :: name :: ['('] :: ts =>
    let result ← parseTy ty
    let (params, rest) ← parseParams 128 ts
    match rest with
    | ['{'] :: rest =>
      let (body, tail) ← parseStmts 128 rest
      if tail.isEmpty then pure ⟨result, name, params, body⟩ else none
    | _ => none
  | _ => none

def parseFunction (source : List Char) : Option Function :=
  (tokenize (source.length + 1) source).bind parseFunctionTokens

end B20.C
