import Lean.AddDecl
import Lean.Elab.Command
import Source3.NttInversePrograms192

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
    ``FT1536.Source3.NttInversePrograms192.var]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_000.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_000_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_000_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_000.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_000.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.num]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_001.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_001_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_001_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_001.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_001.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.zero]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_002.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_002_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_002_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_002.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_002.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.scalar]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_003.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_003_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_003_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_003.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_003.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.read]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_004.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_004_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_004_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_004.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_004.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.call1]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_005.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_005_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_005_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_005.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_005.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.call3]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_006.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_006_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_006_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_006.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_006.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.call4]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_007.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_007_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_007_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_007.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_007.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.call5]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_008.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_008_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_008_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_008.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_008.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.update]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_009.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_009_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_009_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_009.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_009.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.assign]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_010.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_010_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_010_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_010.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_010.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.bind]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_011.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_011_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_011_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_011.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_011.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.write]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_012.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_012_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_012_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_012.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_012.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.declareU64]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_013.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_013_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_013_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_013.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_013.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.declareU32]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_014.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_014_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_014_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_014.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_014.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.declarePtr]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_015.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_015_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_015_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_015.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_015.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.block]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_016.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_016_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_016_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_016.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_016.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.chain]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_017.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_017_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_017_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_017.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_017.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.sizeDecl]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_018.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_018_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_018_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_018.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_018.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.sizeCode]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_019.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_019_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_019_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_019.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_019.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.mixedCode]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_020.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_020_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_020_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_020.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_020.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.lognZero]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_021.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_021_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_021_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_021.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_021.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.earlyExit]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_022.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_022_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_022_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_022.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_022.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.nAssign]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_023.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_023_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_023_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_023.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_023.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.hnAssign]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_024.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_024_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_024_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_024.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_024.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.guardPart]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_025.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_025_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_025_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_025.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_025.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.prologue]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_026.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_026_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_026_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_026.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_026.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.size_shape]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_027.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_027_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_027_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_027.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_027.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.mixed_shape]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_028.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_028_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_028_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_028.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_028.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.part0_shape]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_029.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_029_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_029_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_029.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_029.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.tripleStmt]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_030.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_030_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_030_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_030.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_030.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.tripleTail]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_031.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_031_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_031_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_031.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_031.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.tripleBody]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_032.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_032_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_032_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_032.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_032.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.tripleNo]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_033.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_033_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_033_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_033.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_033.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.tripleGuard]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_034.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_034_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_034_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_034.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_034.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.triplePass]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_035.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_035_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_035_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_035.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_035.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.part1_split]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_036.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_036_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_036_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_036.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_036.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.part1_tail]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_037.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_037_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_037_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_037.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_037.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.part1_branch]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_038.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_038_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_038_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_038.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_038.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.tInit]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_039.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_039_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_039_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_039.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_039.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.mInit]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_040.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_040_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_040_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_040.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_040.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.mGuard]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_041.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_041_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_041_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_041.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_041.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.mStep]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_042.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_042_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_042_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_042.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_042.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.htAssign]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_043.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_043_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_043_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_043.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_043.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.u1Init]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_044.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_044_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_044_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_044.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_044.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.u1Step]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_045.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_045_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_045_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_045.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_045.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.sAssign]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_046.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_046_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_046_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_046.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_046.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.v1Bind]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_047.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_047_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_047_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_047.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_047.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.htBind]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_048.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_048_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_048_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_048.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_048.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.vInit]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_049.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_049_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_049_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_049.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_049.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.pairStep]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_050.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_050_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_050_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_050.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_050.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.vStep]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_051.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_051_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_051_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_051.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_051.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.vGuard]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_052.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_052_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_052_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_052.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_052.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.xRead]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_053.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_053_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_053_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_053.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_053.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.yRead]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_054.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_054_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_054_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_054.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_054.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.addXY]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_055.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_055_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_055_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_055.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_055.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.subXY]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_056.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_056_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_056_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_056.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_056.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.vWriteLow]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_057.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_057_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_057_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_057.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_057.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.vWriteHigh]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_058.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_058_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_058_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_058.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_058.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.vBody]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_059.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_059_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_059_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_059.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_059.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.vLoop]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_060.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_060_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_060_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_060.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_060.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.u1Inner]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_061.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_061_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_061_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_061.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_061.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.u1Guard]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_062.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_062_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_062_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_062.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_062.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.u1Loop]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_063.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_063_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_063_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_063.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_063.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.mInner]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_064.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_064_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_064_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_064.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_064.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.mLoop]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_065.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_065_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_065_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_065.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_065.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.intermediatePass]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_066.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_066_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_066_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_066.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_066.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.part2_shape]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_067.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_067_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_067_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_067.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_067.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.wAssign]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_068.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_068_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_068_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_068.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_068.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.uInit]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_069.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_069_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_069_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_069.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_069.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.r1Init]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_070.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_070_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_070_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_070.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_070.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.r2Init]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_071.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_071_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_071_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_071.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_071.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.uStep]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_072.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_072_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_072_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_072.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_072.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.uGuard]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_073.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_073_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_073_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_073.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_073.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.a0Read]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_074.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_074_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_074_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_074.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_074.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.a1Read]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_075.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_075_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_075_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_075.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_075.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.bAssign]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_076.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_076_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_076_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_076.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_076.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.subA]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_077.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_077_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_077_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_077.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_077.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.cAssign]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_078.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_078_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_078_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_078.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_078.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.fWriteLow]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_079.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_079_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_079_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_079.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_079.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.fWriteHigh]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_080.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_080_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_080_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_080.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_080.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.fBody]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_081.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_081_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_081_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_081.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_081.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.fLoop]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_082.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_082_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_082_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_082.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_082.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.finalPass]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_083.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_083_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_083_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_083.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_083.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.part3_shape]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_084.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_084_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_084_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_084.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_084.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.rAssign]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_085.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_085_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_085_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_085.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_085.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.niAssign]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_086.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_086_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_086_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_086.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_086.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.cInit]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_087.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_087_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_087_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_087.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_087.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.cStep]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_088.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_088_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_088_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_088.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_088.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.cGuard]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_089.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_089_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_089_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_089.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_089.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.cScale]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_090.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_090_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_090_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_090.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_090.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.cBody]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_091.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_091_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_091_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_091.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_091.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.cLoop]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_092.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_092_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_092_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_092.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_092.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.correction]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_093.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_093_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_093_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_093.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_093.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.part4_shape]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_094.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_094_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_094_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_094.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_094.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.inverseBody]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_095.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_095_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_095_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_095.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_095.json" .append fun stream =>
    stream.putStr "\n]\n"

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.NttInversePrograms192.body_source]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_096.json" "[\n"
  let mut firstRow := true
  for name in names do
    IO.FS.writeFile "../AUDIT192_V2_PART_001_DECL_096_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
          let opts ← Lean.getOptions
          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"
          let checkedName := Lean.Name.str name "_roundtrip_checked_129"
          let declaration : Lean.Declaration := .defnDecl {
            name := checkedName
            levelParams := info.levelParams
            type := info.type
            value := restored
            hints := .abbrev
            safety := .safe }
          discard <| Lean.ofExceptKernelException <|
            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none
          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),
            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),
            ("roundtrip_term_and_type_checked",Lean.toJson true),("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")])
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
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_096_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\n"
    IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_096.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../AUDIT192_V2_PART_001_DECL_096.json" .append fun stream =>
    stream.putStr "\n]\n"
