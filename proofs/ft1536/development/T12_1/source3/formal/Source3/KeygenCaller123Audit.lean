import Source3.C99FiniteInit123
import Source3.C99FiniteWords123
import Source3.C99LoadLayout123
import Source3.KeygenPrimeObjects123
import Source3.KeygenRevObject123
import Source3.KeygenCallerData123
import Source3.KeygenCallerMemory123
import Source3.KeygenCallerShape123
import Source3.KeygenCallerDomain123
import Source3.KeygenCallerBuffers123

set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.explicit true
set_option pp.universes true
set_option pp.maxSteps 200000

/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sebastian Ullrich
-/

/- Audit-only expression serializers copied from the pinned Lean toolchain.
   No interactive evaluator or network code is included. -/
namespace FT1536.Source3.KeygenLaw087AuditEncoding
open Lean

/-- Custom `Name` serialization that preserves the exact structure.
The standard `ToJson`/`FromJson Name` uses `toString`/`toName` which doesn't
round-trip for hygienic names (e.g., names containing `@`). -/
def nameToJson : Name → Json
  | .anonymous => Json.null
  | .str p s   => Json.mkObj [("str", Json.arr #[nameToJson p, toJson s])]
  | .num p n   => Json.mkObj [("num", Json.arr #[nameToJson p, n])]

/-- Inverse of `nameToJson`. -/
partial def nameFromJson? (j : Json) : Except String Name := do
  if j.isNull then return .anonymous
  if let some arr := (j.getObjVal? "str").toOption then
    let #[p, s] := (← fromJson? arr : Array Json) | .error "str expects 2 elements"
    return .str (← nameFromJson? p) (← fromJson? s)
  if let some arr := (j.getObjVal? "num").toOption then
    let #[p, n] := (← fromJson? arr : Array Json) | .error "num expects 2 elements"
    return .num (← nameFromJson? p) (← fromJson? n)
  .error s!"expected Name, got {j}"

/-- Serialize `BinderInfo` to JSON. -/
def binderInfoToJson : BinderInfo → Json
  | .default        => "default"
  | .implicit       => "implicit"
  | .strictImplicit => "strictImplicit"
  | .instImplicit   => "instImplicit"

/-- Deserialize `BinderInfo` from JSON. -/
def binderInfoFromJson? : Json → Except String BinderInfo
  | .str "default"        => .ok .default
  | .str "implicit"       => .ok .implicit
  | .str "strictImplicit" => .ok .strictImplicit
  | .str "instImplicit"   => .ok .instImplicit
  | j => .error s!"expected BinderInfo, got {j}"

/-- Serialize `Literal` to JSON. -/
def literalToJson : Literal → Json
  | .natVal n => Json.mkObj [("natVal", n)]
  | .strVal s => Json.mkObj [("strVal", s)]

/-- Deserialize `Literal` from JSON. -/
def literalFromJson? (j : Json) : Except String Literal := do
  if let some n := (j.getObjVal? "natVal").toOption then
    return .natVal (← fromJson? n)
  if let some s := (j.getObjVal? "strVal").toOption then
    return .strVal (← fromJson? s)
  .error s!"expected Literal, got {j}"

/-- Serialize `Level` to JSON. -/
partial def levelToJson : Level → Json
  | .zero     => Json.mkObj [("zero", Json.null)]
  | .succ l   => Json.mkObj [("succ", levelToJson l)]
  | .max a b  => Json.mkObj [("max", Json.arr #[levelToJson a, levelToJson b])]
  | .imax a b => Json.mkObj [("imax", Json.arr #[levelToJson a, levelToJson b])]
  | .param n  => Json.mkObj [("param", nameToJson n)]
  | .mvar id  => Json.mkObj [("mvar", nameToJson id.name)]

/-- Deserialize `Level` from JSON. -/
partial def levelFromJson? (j : Json) : Except String Level := do
  if (j.getObjVal? "zero").toOption.isSome then
    return .zero
  if let some l := (j.getObjVal? "succ").toOption then
    return .succ (← levelFromJson? l)
  if let some arr := (j.getObjVal? "max").toOption then
    let #[a, b] := (← fromJson? arr : Array Json) | .error "max expects 2 elements"
    return .max (← levelFromJson? a) (← levelFromJson? b)
  if let some arr := (j.getObjVal? "imax").toOption then
    let #[a, b] := (← fromJson? arr : Array Json) | .error "imax expects 2 elements"
    return .imax (← levelFromJson? a) (← levelFromJson? b)
  if let some n := (j.getObjVal? "param").toOption then
    return .param (← nameFromJson? n)
  if let some n := (j.getObjVal? "mvar").toOption then
    return .mvar ⟨← nameFromJson? n⟩
  .error s!"expected Level, got {j}"

end FT1536.Source3.KeygenLaw087AuditEncoding

/- Audit-only DAG serialization. Child indices refer to earlier nodes;
   names and levels use the pinned Lean serializers. No kernel term is
   truncated. Nonsemantic mdata is omitted and the reconstructed expression
   and its inferred type are checked against the loaded declaration. -/
namespace FT1536.Source3.KeygenLaw087AuditEncoding
open Lean

inductive ExprNode where
  | bvar (index : Nat)
  | fvar (name : Json)
  | mvar (name : Json)
  | sort (level : Json)
  | const (name : Json) (levels : Array Json)
  | app (fn arg : Nat)
  | lam (name : Json) (ty body : Nat) (binder : Json)
  | forallE (name : Json) (ty body : Nat) (binder : Json)
  | letE (name : Json) (ty value body : Nat) (nondep : Bool)
  | lit (value : Json)
  | mdata (body : Nat)
  | proj (name : Json) (index body : Nat)
  deriving ToJson, FromJson

abbrev DagState := Std.HashMap Expr Nat × Array ExprNode

partial def visit (e : Expr) : StateM DagState Nat := do
  if let some index := (← get).1[e]? then return index
  let node : ExprNode ← match e with
    | .bvar i => pure (.bvar i)
    | .fvar id => pure (.fvar (nameToJson id.name))
    | .mvar id => pure (.mvar (nameToJson id.name))
    | .sort l => pure (.sort (levelToJson l))
    | .const n ls => pure (.const (nameToJson n) (ls.toArray.map levelToJson))
    | .app f a => do pure (.app (← visit f) (← visit a))
    | .lam n ty b bi => do pure (.lam (nameToJson n) (← visit ty) (← visit b) (binderInfoToJson bi))
    | .forallE n ty b bi => do pure (.forallE (nameToJson n) (← visit ty) (← visit b) (binderInfoToJson bi))
    | .letE n ty v b nd => do pure (.letE (nameToJson n) (← visit ty) (← visit v) (← visit b) nd)
    | .lit l => pure (.lit (literalToJson l))
    | .mdata _ b => do pure (.mdata (← visit b))
    | .proj n i s => do pure (.proj (nameToJson n) i (← visit s))
  let (seen, nodes) ← get
  let index := nodes.size
  set (seen.insert e index, nodes.push node)
  return index

def child (nodes : Array Expr) (index : Nat) : Except String Expr :=
  match nodes[index]? with
  | some e => .ok e
  | none => .error "DAG child index is not an earlier node"

def restoreNode (nodes : Array Expr) : ExprNode → Except String Expr
  | .bvar i => return .bvar i
  | .fvar n => return .fvar ⟨← nameFromJson? n⟩
  | .mvar n => return .mvar ⟨← nameFromJson? n⟩
  | .sort l => return .sort (← levelFromJson? l)
  | .const n ls => return .const (← nameFromJson? n) (← ls.toList.mapM levelFromJson?)
  | .app f a => do return .app (← child nodes f) (← child nodes a)
  | .lam n ty b bi => do return .lam (← nameFromJson? n) (← child nodes ty) (← child nodes b) (← binderInfoFromJson? bi)
  | .forallE n ty b bi => do return .forallE (← nameFromJson? n) (← child nodes ty) (← child nodes b) (← binderInfoFromJson? bi)
  | .letE n ty v b nd => do return .letE (← nameFromJson? n) (← child nodes ty) (← child nodes v) (← child nodes b) nd
  | .lit l => return .lit (← literalFromJson? l)
  | .mdata b => child nodes b
  | .proj n i s => do return .proj (← nameFromJson? n) i (← child nodes s)

def restoreDag (nodes : Array ExprNode) (root : Nat) : Except String Expr := do
  let mut values := #[]
  for node in nodes do
    values := values.push (← restoreNode values node)
  child values root

end FT1536.Source3.KeygenLaw087AuditEncoding

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.C99FiniteInit123.cells,
    ``FT1536.Source3.C99FiniteInit123.cells_at,
    ``FT1536.Source3.C99FiniteInit123.install,
    ``FT1536.Source3.C99FiniteInit123.metadata,
    ``FT1536.Source3.C99FiniteInit123.initialized,
    ``FT1536.Source3.C99FiniteInit123.outside,
    ``FT1536.Source3.C99FiniteInit123.words32,
    ``FT1536.Source3.C99FiniteInit123.words64,
    ``FT1536.Source3.C99FiniteInit123.words32_at,
    ``FT1536.Source3.C99FiniteInit123.words64_at,
    ``FT1536.Source3.C99FiniteWords123.load32,
    ``FT1536.Source3.C99FiniteWords123.load64,
    ``FT1536.Source3.C99FiniteWords123.words16,
    ``FT1536.Source3.C99FiniteWords123.words16_at,
    ``FT1536.Source3.C99FiniteWords123.load16,
    ``FT1536.Source3.C99LoadLayout123.load32,
    ``FT1536.Source3.C99LoadLayout123.load64,
    ``FT1536.Source3.C99LoadLayout123.load16,
    ``FT1536.Source3.KeygenPrimeObjects123.fieldIndex,
    ``FT1536.Source3.KeygenPrimeObjects123.words,
    ``FT1536.Source3.KeygenPrimeObjects123.heap,
    ``FT1536.Source3.KeygenPrimeObjects123.pointer,
    ``FT1536.Source3.KeygenPrimeObjects123.word_at,
    ``FT1536.Source3.KeygenPrimeObjects123.object,
    ``FT1536.Source3.KeygenRevObject123.words,
    ``FT1536.Source3.KeygenRevObject123.heap,
    ``FT1536.Source3.KeygenRevObject123.pointer,
    ``FT1536.Source3.KeygenRevObject123.object,
    ``FT1536.Source3.KeygenCallerData123.rawEnv,
    ``FT1536.Source3.KeygenCallerData123.env,
    ``FT1536.Source3.KeygenCallerData123.contextBytes,
    ``FT1536.Source3.KeygenCallerData123.buffers,
    ``FT1536.Source3.KeygenCallerData123.externals,
    ``FT1536.Source3.KeygenCallerData123.withPrimes,
    ``FT1536.Source3.KeygenCallerData123.withRev,
    ``FT1536.Source3.KeygenCallerData123.rcWords,
    ``FT1536.Source3.KeygenCallerData123.heap,
    ``FT1536.Source3.KeygenCallerData123.primes,
    ``FT1536.Source3.KeygenCallerData123.rev,
    ``FT1536.Source3.KeygenCallerData123.rcPointer,
    ``FT1536.Source3.KeygenCallerData123.tables,
    ``FT1536.Source3.KeygenCallerData123.base,
    ``FT1536.Source3.KeygenCallerData123.scratch_word,
    ``FT1536.Source3.KeygenCallerData123.tables_cases,
    ``FT1536.Source3.KeygenCallerMemory123.sizes,
    ``FT1536.Source3.KeygenCallerMemory123.permissions,
    ``FT1536.Source3.KeygenCallerMemory123.external_block,
    ``FT1536.Source3.KeygenCallerMemory123.primes_object,
    ``FT1536.Source3.KeygenCallerMemory123.rev_object,
    ``FT1536.Source3.KeygenCallerMemory123.rc_object,
    ``FT1536.Source3.KeygenCallerShape123.external_sizes,
    ``FT1536.Source3.KeygenCallerShape123.external_permissions,
    ``FT1536.Source3.KeygenCallerShape123.profile,
    ``FT1536.Source3.KeygenCallerShape123.object_legal,
    ``FT1536.Source3.KeygenCallerShape123.scratch_legal,
    ``FT1536.Source3.KeygenCallerShape123.load64_block,
    ``FT1536.Source3.KeygenCallerShape123.public_capacity,
    ``FT1536.Source3.KeygenCallerShape123.public_writable,
    ``FT1536.Source3.KeygenCallerShape123.seed_fresh,
    ``FT1536.Source3.KeygenCallerDomain123.tables_separate,
    ``FT1536.Source3.KeygenCallerDomain123.tables_live,
    ``FT1536.Source3.KeygenCallerDomain123.original,
    ``FT1536.Source3.KeygenCallerDomain123.root_legal,
    ``FT1536.Source3.KeygenCallerDomain123.buffers_legal,
    ``FT1536.Source3.KeygenCallerDomain123.public_legal,
    ``FT1536.Source3.KeygenCallerDomain123.domain,
    ``FT1536.Source3.KeygenCallerDomain123.input,
    ``FT1536.Source3.KeygenCallerDomain123.canonical_representation,
    ``FT1536.Source3.KeygenCallerBuffers123.writable_span,
    ``FT1536.Source3.KeygenCallerBuffers123.private_capacity,
    ``FT1536.Source3.KeygenCallerBuffers123.private_writable,
    ``FT1536.Source3.KeygenCallerBuffers123.whole_public_writable,
    ``FT1536.Source3.KeygenCallerBuffers123.stored_scratch,
    ``FT1536.Source3.KeygenCallerBuffers123.stored_scratch_length,
    ``FT1536.Source3.KeygenCallerBuffers123.actual_scratch_read,
    ``FT1536.Source3.KeygenCallerBuffers123.initial_flag]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../SEARCH_AUDIT.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../SEARCH_AUDIT_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
    let info ← Lean.getConstInfo name
    let axes ← Lean.collectAxioms name
    for ax in axes do
      unless allowed.contains ax do throwError "Unexpected axiom {ax} in {name}"
    let body ← match info.value? (allowOpaque := true) with
      | some term =>
          let (root, (_, nodes)) :=
            (FT1536.Source3.KeygenLaw087AuditEncoding.visit term).run ({}, #[])
          let encodedExpr := Lean.toJson nodes
          let decoded ← match (Lean.fromJson? encodedExpr : Except String
              (Array FT1536.Source3.KeygenLaw087AuditEncoding.ExprNode)) with
            | .ok value => pure value
            | .error problem => throwError "DAG JSON decode failed: {problem}"
          let restored ← match FT1536.Source3.KeygenLaw087AuditEncoding.restoreDag decoded root with
            | .ok value => pure value
            | .error problem => throwError "Expression decode failed: {problem}"
          unless ← Lean.Meta.isDefEq term restored do
            throwError "Expression roundtrip changed the term: {name}"
          unless ← Lean.Meta.isDefEq (← Lean.Meta.inferType restored) info.type do
            throwError "Expression roundtrip changed the type: {name}"
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true)])
      | none =>
          match info with
          | .inductInfo ind =>
              let mut constructors : Array Lean.Json := #[]
              for ctor in ind.ctors do
                let ci ← Lean.getConstInfo ctor
                constructors := constructors.push (Lean.Json.mkObj [
                  ("name",Lean.toJson ctor.toString),("type",Lean.toJson (← render ci.type))])
              pure (Lean.Json.mkObj [("kind",Lean.toJson "kernel_inductive"),
                ("constructors",Lean.Json.arr constructors)])
          | _ => throwError "Unexpected bodyless declaration {name}"
    let row := Lean.Json.mkObj [
      ("name",Lean.toJson name.toString),("type",Lean.toJson (← render info.type)),
      ("body",body),("axioms",Lean.toJson (axes.map Lean.Name.toString))]
    let encoded := row.compress
    IO.FS.withFile "../SEARCH_AUDIT_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../SEARCH_AUDIT.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../SEARCH_AUDIT.json" .append fun stream =>
    stream.putStr "\n]\n"
