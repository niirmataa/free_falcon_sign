import Source3.KeygenWordExec

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenWordParser
open B20.C (Token Name)
open KeygenWordExpr (Expr Types expression)
open KeygenWordExec

def increment (name : Name) (op : B20.C.BinOp) : Stmt :=
  .modular (.base (.scalar (.update name op (.literal .i32 1))))
def clause (types : Types) : List Token → Option (Stmt×List Token)
  | name::['+','+']::rest => some (increment name .add,rest)
  | name::['-']::['-']::rest => some (increment name .sub,rest)
  | name::op::rest => do
    let (e,rest) ← expression types rest
    if op=['='] then pure (.assign name e,rest) else do
      let operation ← B20.C.Scalar.updateOp op
      pure (.assign name (.bin operation (.scalar (.var name)) e),rest)
  | _ => none
def clauses (types : Types) (ending : Token) : Nat → List Token → Option (Stmt×List Token)
  | 0,_ => none
  | fuel+1,ts =>
    if ts.head?=some ending then some (skip,ts.drop 1) else do
      let (head,rest) ← clause types ts
      match rest with
      | [',']::rest => do
        let (tail,rest) ← clauses types ending fuel rest
        pure (.seq head tail,rest)
      | last::rest => if last=ending then some (head,rest) else none
      | _ => none
def simple (types : Types) (ts : List Token) : Option (Stmt×List Token) := do
  match ts with
  | ['r','e','t','u','r','n']::rest =>
    let (e,rest) ← expression types rest
    match rest with
    | [';']::rest => pure (.ret e,rest)
    | _ => none
  | name::['[']::rest =>
    let width ← KeygenSearchParser.width types name
    if width≠4 then none else do
    let (index,rest) ← C99ArrayParser.pureExpr rest
    match rest with
    | [']']::op::rest => do
      let (e,rest) ← expression types rest
      let value ← if op=['='] then some e else
        (B20.C.Scalar.updateOp op).map (fun operation => .bin operation (.load32 name index) e)
      match rest with
      | [';']::rest => pure (.store name index value,rest)
      | _ => none
    | _ => none
  | t::rest =>
    match KeygenWordExpr.typeToken t with
    | some ty => do
      let (names,rest) ← B20.C.Scalar.names 32 rest
      pure (.modular (.base (.scalar (.declare ty names))),rest)
    | none => do
      let (code,rest) ← clause types ts
      match rest with
      | [';']::rest => pure (code,rest)
      | _ => none
  | _ => none
def declarations : Stmt → List Name
  | .modular (.base (.scalar (.declare _ names))) => names
  | .seq a b => declarations a++declarations b
  | _ => []
/- Both successful and failing post-decrement tests execute the update.
   A returned body bypasses the final update, exactly as in the source. -/
def postLoop (name : Name) (condition : Expr) (body : Stmt) : Stmt :=
  .seq (.loop condition (.seq (increment name .sub) body) skip) (increment name .sub)
mutual
  def statement (types : Types) : Nat → List Token → Option (Stmt×List Token)
    | 0,_ => none
    | fuel+1,['w','h','i','l','e']::['(']::name::['-']::['-']::op::rest => do
      let comparison ← C99ModularParser.cmpToken op
      let (bound,rest) ← expression types rest
      match rest with
      | [')']::rest => do
        let (body,rest) ← statement types fuel rest
        pure (postLoop name (.cmp comparison (.scalar (.var name)) bound) body,rest)
      | _ => none
    | fuel+1,['w','h','i','l','e']::['(']::rest => do
      let (condition,rest) ← expression types rest
      match rest with
      | [')']::rest => do
        let (body,rest) ← statement types fuel rest
        pure (.loop condition body skip,rest)
      | _ => none
    | fuel+1,['f','o','r']::['(']::rest => do
      let (initial,rest) ← clauses types [';'] 16 rest
      let (condition,rest) ← expression types rest
      match rest with
      | [';']::rest => do
        let (increment,rest) ← clauses types [')'] 16 rest
        let (body,rest) ← statement types fuel rest
        pure (.seq initial (.loop condition body increment),rest)
      | _ => none
    | fuel+1,['i','f']::['(']::rest => do
      let (condition,rest) ← expression types rest
      match rest with
      | [')']::rest => do
        let (yes,rest) ← statement types fuel rest
        match rest with
        | ['e','l','s','e']::rest => do
          let (no,rest) ← statement types fuel rest
          pure (.branch condition yes no,rest)
        | _ => pure (.branch condition yes skip,rest)
      | _ => none
    | fuel+1,['{']::rest => do
      let (code,rest) ← body types fuel rest
      pure (.scope (declarations code) code,rest)
    | _+1,rest => simple types rest
  def body (types : Types) : Nat → List Token → Option (Stmt×List Token)
    | 0,_ => none
    | _+1,['}']::rest => some (skip,rest)
    | fuel+1,rest => do
      let (first,rest) ← statement types fuel rest
      let (tail,rest) ← body types fuel rest
      pure (.seq first tail,rest)
end
def region (types : Types) (start count : Nat) : Option Stmt := do
  let chars := ((Pinned.keygenLines.drop (start-1)).take count).flatMap String.toList++['}']
  let tokens ← C99ProcedureParser.tokens chars
  let (code,rest) ← body types 256 tokens
  if rest.isEmpty then pure code else none

end FT1536.Source3.KeygenWordParser
