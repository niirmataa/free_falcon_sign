import Lean

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Audit-only lossless encoding for shared closed kernel expressions. A
   flat pretty print can expand sharing exponentially. Child indices in
   this DAG always precede their parent; names and universe levels are
   structural, not reparsed display strings. Unsupported annotations or
   free metavariables are rejected. The serialized JSON is round-tripped
   against Expr.equal before it can be accepted as evidence. -/
namespace FT1536.Source3.ExprAuditDag
open Lean

private def arr (tag : String) (fields : Array Json := #[]) : Json :=
  Json.arr (#[toJson tag]++fields)

private def nameJson : Name → Json
  | .anonymous => arr "anonymous"
  | .str p s => arr "str" #[nameJson p,toJson s]
  | .num p n => arr "num" #[nameJson p,toJson n]

private partial def levelJson : Level → Json
  | .zero => arr "zero"
  | .succ u => arr "succ" #[levelJson u]
  | .max u v => arr "max" #[levelJson u,levelJson v]
  | .imax u v => arr "imax" #[levelJson u,levelJson v]
  | .param n => arr "param" #[nameJson n]
  | .mvar n => arr "mvar" #[nameJson n.name]

private def binderJson : BinderInfo → Json
  | .default => toJson (0 : Nat)
  | .implicit => toJson (1 : Nat)
  | .strictImplicit => toJson (2 : Nat)
  | .instImplicit => toJson (3 : Nat)

private structure Dump where
  ids : ExprStructMap Nat := {}
  nodes : Array Json := #[]

private partial def visit (e : Expr) : StateT Dump (Except String) Nat := do
  if let some id := (← get).ids[(⟨e⟩ : ExprStructEq)]? then return id
  let node ← match e with
    | .bvar i => pure (arr "bvar" #[toJson i])
    | .sort u => pure (arr "sort" #[levelJson u])
    | .const n us => pure (arr "const" #[nameJson n,Json.arr (us.toArray.map levelJson)])
    | .app f a => do
        let f ← visit f
        let a ← visit a
        pure (arr "app" #[toJson f,toJson a])
    | .lam n t b bi => do
        let t ← visit t
        let b ← visit b
        pure (arr "lam" #[nameJson n,toJson t,toJson b,binderJson bi])
    | .forallE n t b bi => do
        let t ← visit t
        let b ← visit b
        pure (arr "forall" #[nameJson n,toJson t,toJson b,binderJson bi])
    | .letE n t v b nondep => do
        let t ← visit t
        let v ← visit v
        let b ← visit b
        pure (arr "let" #[nameJson n,toJson t,toJson v,toJson b,toJson nondep])
    | .lit (.natVal n) => pure (arr "nat" #[toJson n])
    | .lit (.strVal s) => pure (arr "string" #[toJson s])
    | .proj n i e => do
        let e ← visit e
        pure (arr "proj" #[nameJson n,toJson i,toJson e])
    | .fvar _ | .mvar _ | .mdata _ _ => throw "Expression is not a closed annotation-free kernel term"
  let id := (← get).nodes.size
  modify fun s => {ids := s.ids.insert ⟨e⟩ id,nodes := s.nodes.push node}
  return id

private def field (a : Array Json) (i : Nat) : Except String Json :=
  match a[i]? with
  | some j => .ok j
  | none => .error "Missing DAG field"

private partial def decodeName (j : Json) : Except String Name := do
  let a ← j.getArr?
  match ← (← field a 0).getStr? with
  | "anonymous" => return .anonymous
  | "str" => return .str (← decodeName (← field a 1)) (← (← field a 2).getStr?)
  | "num" => return .num (← decodeName (← field a 1)) (← (← field a 2).getNat?)
  | _ => throw "Invalid DAG name"

private partial def decodeLevel (j : Json) : Except String Level := do
  let a ← j.getArr?
  match ← (← field a 0).getStr? with
  | "zero" => return .zero
  | "succ" => return .succ (← decodeLevel (← field a 1))
  | "max" => return .max (← decodeLevel (← field a 1)) (← decodeLevel (← field a 2))
  | "imax" => return .imax (← decodeLevel (← field a 1)) (← decodeLevel (← field a 2))
  | "param" => return .param (← decodeName (← field a 1))
  | "mvar" => throw "Universe metavariable in closed term"
  | _ => throw "Invalid DAG universe"

private def decodeBinder (j : Json) : Except String BinderInfo := do
  match ← j.getNat? with
  | 0 => return .default
  | 1 => return .implicit
  | 2 => return .strictImplicit
  | 3 => return .instImplicit
  | _ => throw "Invalid DAG binder"

def decode (j : Json) : Except String Expr := do
  let nodes ← (← j.getObjVal? "nodes").getArr?
  let root ← (← j.getObjVal? "root").getNat?
  let mut terms : Array Expr := #[]
  for node in nodes do
    let a ← node.getArr?
    let child (i : Nat) : Except String Expr := do
      let id ← (← field a i).getNat?
      match terms[id]? with
      | some e => return e
      | none => throw "DAG child does not precede parent"
    let e ← match ← (← field a 0).getStr? with
      | "bvar" => pure (.bvar (← (← field a 1).getNat?))
      | "sort" => pure (.sort (← decodeLevel (← field a 1)))
      | "const" => do
          let us ← (← (← field a 2).getArr?).toList.mapM decodeLevel
          pure (.const (← decodeName (← field a 1)) us)
      | "app" => pure (.app (← child 1) (← child 2))
      | "lam" => pure (.lam (← decodeName (← field a 1)) (← child 2) (← child 3)
          (← decodeBinder (← field a 4)))
      | "forall" => pure (.forallE (← decodeName (← field a 1)) (← child 2) (← child 3)
          (← decodeBinder (← field a 4)))
      | "let" => pure (.letE (← decodeName (← field a 1)) (← child 2) (← child 3) (← child 4)
          (← (← field a 5).getBool?))
      | "nat" => pure (.lit (.natVal (← (← field a 1).getNat?)))
      | "string" => pure (.lit (.strVal (← (← field a 1).getStr?)))
      | "proj" => pure (.proj (← decodeName (← field a 1)) (← (← field a 2).getNat?) (← child 3))
      | _ => throw "Invalid DAG expression node"
    terms := terms.push e
  match terms[root]? with
  | some e => return e
  | none => throw "Missing DAG root"

def encodeChecked (e : Expr) : Except String Json := do
  let (root,state) ← (visit e).run {}
  let json := Json.mkObj [("format",toJson "Lean.Expr.DAG.v1"),("root",toJson root),
    ("nodes",Json.arr state.nodes)]
  let restored ← decode (← Json.parse json.compress)
  unless Expr.equal e restored do throw "DAG JSON round-trip changed the kernel expression"
  return json

end FT1536.Source3.ExprAuditDag
