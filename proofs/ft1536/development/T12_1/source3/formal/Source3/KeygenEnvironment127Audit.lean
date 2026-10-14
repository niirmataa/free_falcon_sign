import Source3.KeygenCallerConflict127
import Source3.KeygenTableObjects127
import Source3.KeygenFftObjects127
import Source3.KeygenGlobalCells127
import Source3.KeygenFullData127
import Source3.KeygenFullMemory127
import Source3.KeygenFullFacts127
import Source3.KeygenFullDomain127
import Source3.KeygenSizeObjects127
import Source3.KeygenStaticFrames127
import Source3.KeygenFullStatics127
import Source3.KeygenFullBuffers127
import Source3.SelectedFullStart127
import Source3.SelectedFullStatics127

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
    ``FT1536.Source3.KeygenCallerConflict127.no_certificate_at_two,
    ``FT1536.Source3.KeygenCallerConflict127.old_base_writable,
    ``FT1536.Source3.KeygenCallerConflict127.old_base_not_certificate,
    ``FT1536.Source3.KeygenTableObjects127.table32,
    ``FT1536.Source3.KeygenTableObjects127.pointer32,
    ``FT1536.Source3.KeygenTableObjects127.read32,
    ``FT1536.Source3.KeygenTableObjects127.static32,
    ``FT1536.Source3.KeygenTableObjects127.table64,
    ``FT1536.Source3.KeygenTableObjects127.pointer64,
    ``FT1536.Source3.KeygenTableObjects127.read64,
    ``FT1536.Source3.KeygenTableObjects127.readonly64,
    ``FT1536.Source3.KeygenFftObjects127.square,
    ``FT1536.Source3.KeygenFftObjects127.heap,
    ``FT1536.Source3.KeygenFftObjects127.word_fits,
    ``FT1536.Source3.KeygenFftObjects127.pinned,
    ``FT1536.Source3.KeygenFftObjects127.pinned_swap,
    ``FT1536.Source3.KeygenGlobalCells127.cells,
    ``FT1536.Source3.KeygenGlobalCells127.lookup_source,
    ``FT1536.Source3.KeygenGlobalCells127.globals,
    ``FT1536.Source3.KeygenGlobalCells127.source,
    ``FT1536.Source3.KeygenFullData127.rawEnv,
    ``FT1536.Source3.KeygenFullData127.env,
    ``FT1536.Source3.KeygenFullData127.contextBytes,
    ``FT1536.Source3.KeygenFullData127.buffers,
    ``FT1536.Source3.KeygenFullData127.externals,
    ``FT1536.Source3.KeygenFullData127.withRC,
    ``FT1536.Source3.KeygenFullData127.withPrimes3,
    ``FT1536.Source3.KeygenFullData127.primary,
    ``FT1536.Source3.KeygenFullData127.withPrimes2,
    ``FT1536.Source3.KeygenFullData127.withSmall2,
    ``FT1536.Source3.KeygenFullData127.withLarge2,
    ``FT1536.Source3.KeygenFullData127.withSmall3,
    ``FT1536.Source3.KeygenFullData127.withLarge3,
    ``FT1536.Source3.KeygenFullData127.withVv,
    ``FT1536.Source3.KeygenFullData127.extras,
    ``FT1536.Source3.KeygenFullData127.heap,
    ``FT1536.Source3.KeygenFullData127.primes,
    ``FT1536.Source3.KeygenFullData127.rev,
    ``FT1536.Source3.KeygenFullData127.tables,
    ``FT1536.Source3.KeygenFullData127.base,
    ``FT1536.Source3.KeygenFullData127.scratch_word,
    ``FT1536.Source3.KeygenFullData127.canonical_representation,
    ``FT1536.Source3.KeygenFullMemory127.extras_sizes,
    ``FT1536.Source3.KeygenFullMemory127.extras_permissions,
    ``FT1536.Source3.KeygenFullMemory127.extras_frame,
    ``FT1536.Source3.KeygenFullMemory127.primary_sizes,
    ``FT1536.Source3.KeygenFullMemory127.primary_permissions,
    ``FT1536.Source3.KeygenFullMemory127.primary_frame,
    ``FT1536.Source3.KeygenFullMemory127.external_frame,
    ``FT1536.Source3.KeygenFullFacts127.sizes,
    ``FT1536.Source3.KeygenFullFacts127.permissions,
    ``FT1536.Source3.KeygenFullFacts127.external_sizes,
    ``FT1536.Source3.KeygenFullFacts127.external_permissions,
    ``FT1536.Source3.KeygenFullFacts127.lookup_mem,
    ``FT1536.Source3.KeygenFullFacts127.table_blocks,
    ``FT1536.Source3.KeygenFullFacts127.tables_separate,
    ``FT1536.Source3.KeygenFullFacts127.tables_live,
    ``FT1536.Source3.KeygenFullFacts127.fft_pinned,
    ``FT1536.Source3.KeygenFullFacts127.certificate_pinned,
    ``FT1536.Source3.KeygenFullFacts127.globals_source,
    ``FT1536.Source3.KeygenFullDomain127.primes_object,
    ``FT1536.Source3.KeygenFullDomain127.rev_object,
    ``FT1536.Source3.KeygenFullDomain127.profile,
    ``FT1536.Source3.KeygenFullDomain127.object_legal,
    ``FT1536.Source3.KeygenFullDomain127.scratch_legal,
    ``FT1536.Source3.KeygenFullDomain127.original,
    ``FT1536.Source3.KeygenFullDomain127.root_legal,
    ``FT1536.Source3.KeygenFullDomain127.buffers_legal,
    ``FT1536.Source3.KeygenFullDomain127.public_capacity,
    ``FT1536.Source3.KeygenFullDomain127.public_writable,
    ``FT1536.Source3.KeygenFullDomain127.public_tail_writable,
    ``FT1536.Source3.KeygenFullDomain127.public_legal,
    ``FT1536.Source3.KeygenFullDomain127.domain,
    ``FT1536.Source3.KeygenFullDomain127.seed_fresh,
    ``FT1536.Source3.KeygenFullDomain127.input,
    ``FT1536.Source3.KeygenSizeObjects127.object,
    ``FT1536.Source3.KeygenStaticFrames127.primes2,
    ``FT1536.Source3.KeygenStaticFrames127.small2,
    ``FT1536.Source3.KeygenStaticFrames127.large2,
    ``FT1536.Source3.KeygenStaticFrames127.small3,
    ``FT1536.Source3.KeygenStaticFrames127.large3,
    ``FT1536.Source3.KeygenStaticFrames127.vv,
    ``FT1536.Source3.KeygenFullStatics127.size_block,
    ``FT1536.Source3.KeygenFullStatics127.static32_block,
    ``FT1536.Source3.KeygenFullStatics127.prime_block,
    ``FT1536.Source3.KeygenFullStatics127.primes2_object,
    ``FT1536.Source3.KeygenFullStatics127.sizeBlock,
    ``FT1536.Source3.KeygenFullStatics127.size_object,
    ``FT1536.Source3.KeygenFullStatics127.vv_object,
    ``FT1536.Source3.KeygenFullStatics127.environment,
    ``FT1536.Source3.KeygenFullBuffers127.private_capacity,
    ``FT1536.Source3.KeygenFullBuffers127.private_writable,
    ``FT1536.Source3.KeygenFullBuffers127.stored_scratch,
    ``FT1536.Source3.KeygenFullBuffers127.stored_scratch_length,
    ``FT1536.Source3.KeygenFullBuffers127.actual_scratch_read,
    ``FT1536.Source3.KeygenFullBuffers127.initial_flag,
    ``FT1536.Source3.KeygenFullBuffers127.rc_object,
    ``FT1536.Source3.SelectedFullStart127.seed,
    ``FT1536.Source3.SelectedFullStart127.seedResult,
    ``FT1536.Source3.SelectedFullStart127.seed_defined,
    ``FT1536.Source3.SelectedFullStart127.seeded,
    ``FT1536.Source3.SelectedFullStart127.seed_computed,
    ``FT1536.Source3.SelectedFullStart127.seeding,
    ``FT1536.Source3.SelectedFullStart127.domain,
    ``FT1536.Source3.SelectedFullStart127.prefixResult,
    ``FT1536.Source3.SelectedFullStart127.prefix_defined,
    ``FT1536.Source3.SelectedFullStart127.ready,
    ``FT1536.Source3.SelectedFullStart127.prefix_computed,
    ``FT1536.Source3.SelectedFullStart127.invocation,
    ``FT1536.Source3.SelectedFullStart127.prefix_source,
    ``FT1536.Source3.SelectedFullStart127.source,
    ``FT1536.Source3.SelectedFullStart127.entry_facts,
    ``FT1536.Source3.SelectedFullStatics127.block_frame,
    ``FT1536.Source3.SelectedFullStatics127.tables,
    ``FT1536.Source3.SelectedFullStatics127.fft_frame,
    ``FT1536.Source3.SelectedFullStatics127.fft_pinned,
    ``FT1536.Source3.SelectedFullStatics127.certificate_pinned]
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
