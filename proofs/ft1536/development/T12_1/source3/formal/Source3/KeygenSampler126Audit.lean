import Source3.KeygenCapCompute126
import Source3.SelectedCap126
import Source3.KeygenAttemptSetup126
import Source3.SelectedSetup126
import Source3.SelectedSamplerStart126
import Source3.ActualExtractPrep126
import Source3.ShakeBlockNormalize126
import Source3.GeneratedActualProcess126Round00
import Source3.GeneratedActualProcess126Round01
import Source3.GeneratedActualProcess126Round02
import Source3.GeneratedActualProcess126Round03
import Source3.GeneratedActualProcess126Round04
import Source3.GeneratedActualProcess126Round05
import Source3.GeneratedActualProcess126Round06
import Source3.GeneratedActualProcess126Round07
import Source3.GeneratedActualProcess126Round08
import Source3.GeneratedActualProcess126Round09
import Source3.GeneratedActualProcess126Round10
import Source3.GeneratedActualProcess126Round11
import Source3.ActualProcess126
import Source3.ShakeExtractFragments126
import Source3.ActualExtractTail126
import Source3.ActualExtractBody126
import Source3.ActualDraw126
import Source3.ActualRefill126

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
    ``FT1536.Source3.KeygenCapCompute126.increment,
    ``FT1536.Source3.KeygenCapCompute126.increment_sound,
    ``FT1536.Source3.KeygenCapCompute126.run,
    ``FT1536.Source3.KeygenCapCompute126.run_sound,
    ``FT1536.Source3.SelectedCap126.result,
    ``FT1536.Source3.SelectedCap126.defined,
    ``FT1536.Source3.SelectedCap126.first,
    ``FT1536.Source3.SelectedCap126.computed,
    ``FT1536.Source3.SelectedCap126.source,
    ``FT1536.Source3.SelectedCap126.exact_state,
    ``FT1536.Source3.SelectedCap126.count,
    ``FT1536.Source3.KeygenAttemptSetup126.rtDeclared,
    ``FT1536.Source3.KeygenAttemptSetup126.reference_declared,
    ``FT1536.Source3.KeygenAttemptSetup126.Guard,
    ``FT1536.Source3.KeygenAttemptSetup126.guardDecidable,
    ``FT1536.Source3.KeygenAttemptSetup126.pointer_source,
    ``FT1536.Source3.KeygenAttemptSetup126.run,
    ``FT1536.Source3.KeygenAttemptSetup126.run_sound,
    ``FT1536.Source3.SelectedSetup126.result,
    ``FT1536.Source3.SelectedSetup126.defined,
    ``FT1536.Source3.SelectedSetup126.ready,
    ``FT1536.Source3.SelectedSetup126.computed,
    ``FT1536.Source3.SelectedSetup126.setup,
    ``FT1536.Source3.SelectedSetup126.capped,
    ``FT1536.Source3.SelectedSetup126.exact_state,
    ``FT1536.Source3.SelectedSetup126.count,
    ``FT1536.Source3.SelectedSetup126.entry,
    ``FT1536.Source3.SelectedSamplerStart126.context,
    ``FT1536.Source3.SelectedSamplerStart126.bindingResult,
    ``FT1536.Source3.SelectedSamplerStart126.binding_defined,
    ``FT1536.Source3.SelectedSamplerStart126.bound,
    ``FT1536.Source3.SelectedSamplerStart126.binding_computed,
    ``FT1536.Source3.SelectedSamplerStart126.binding,
    ``FT1536.Source3.SelectedSamplerStart126.prologueResult,
    ``FT1536.Source3.SelectedSamplerStart126.prologue_defined,
    ``FT1536.Source3.SelectedSamplerStart126.declared,
    ``FT1536.Source3.SelectedSamplerStart126.prologue_computed,
    ``FT1536.Source3.SelectedSamplerStart126.prologue,
    ``FT1536.Source3.SelectedSamplerStart126.initialResult,
    ``FT1536.Source3.SelectedSamplerStart126.initial_defined,
    ``FT1536.Source3.SelectedSamplerStart126.initial,
    ``FT1536.Source3.SelectedSamplerStart126.initial_computed,
    ``FT1536.Source3.SelectedSamplerStart126.initialization,
    ``FT1536.Source3.SelectedSamplerStart126.outer_guard_computed,
    ``FT1536.Source3.SelectedSamplerStart126.outer_guard,
    ``FT1536.Source3.SelectedSamplerStart126.xResult,
    ``FT1536.Source3.SelectedSamplerStart126.x_defined,
    ``FT1536.Source3.SelectedSamplerStart126.firstRead,
    ``FT1536.Source3.SelectedSamplerStart126.x_computed,
    ``FT1536.Source3.SelectedSamplerStart126.declaration,
    ``FT1536.Source3.SelectedSamplerStart126.refill_guard_computed,
    ``FT1536.Source3.SelectedSamplerStart126.refill_guard,
    ``FT1536.Source3.ActualExtractPrep126.ctx,
    ``FT1536.Source3.ActualExtractPrep126.caller,
    ``FT1536.Source3.ActualExtractPrep126.allocated,
    ``FT1536.Source3.ActualExtractPrep126.entered,
    ``FT1536.Source3.ActualExtractPrep126.fresh,
    ``FT1536.Source3.ActualExtractPrep126.headStatements,
    ``FT1536.Source3.ActualExtractPrep126.headResult,
    ``FT1536.Source3.ActualExtractPrep126.head_defined,
    ``FT1536.Source3.ActualExtractPrep126.headed,
    ``FT1536.Source3.ActualExtractPrep126.head_computed,
    ``FT1536.Source3.ActualExtractPrep126.head_source,
    ``FT1536.Source3.ActualExtractPrep126.loopCondition,
    ``FT1536.Source3.ActualExtractPrep126.loop_guard_computed,
    ``FT1536.Source3.ActualExtractPrep126.declaration,
    ``FT1536.Source3.ActualExtractPrep126.declarationResult,
    ``FT1536.Source3.ActualExtractPrep126.declaration_defined,
    ``FT1536.Source3.ActualExtractPrep126.iterationStart,
    ``FT1536.Source3.ActualExtractPrep126.declaration_computed,
    ``FT1536.Source3.ActualExtractPrep126.declaration_source,
    ``FT1536.Source3.ActualExtractPrep126.refillCondition,
    ``FT1536.Source3.ActualExtractPrep126.refill_guard_computed,
    ``FT1536.Source3.ActualExtractPrep126.refillHead,
    ``FT1536.Source3.ActualExtractPrep126.processResult,
    ``FT1536.Source3.ActualExtractPrep126.process_defined,
    ``FT1536.Source3.ActualExtractPrep126.processBefore,
    ``FT1536.Source3.ActualExtractPrep126.process_computed,
    ``FT1536.Source3.ActualExtractPrep126.process_head_source,
    ``FT1536.Source3.ActualExtractPrep126.aPointer,
    ``FT1536.Source3.ActualExtractPrep126.rcPointer,
    ``FT1536.Source3.ActualExtractPrep126.blockEntry,
    ``FT1536.Source3.ShakeBlockNormalize126.globals_tables,
    ``FT1536.Source3.ShakeBlockNormalize126.normalize,
    ``FT1536.Source3.ShakeBlockNormalize126.heap_equal,
    ``FT1536.Source3.ShakeBlockNormalize126.reference_equal,
    ``FT1536.Source3.ShakeBlockNormalize126.certified,
    ``FT1536.Source3.GeneratedActualProcess126Round00.declared,
    ``FT1536.Source3.GeneratedActualProcess126Round00.ready,
    ``FT1536.Source3.GeneratedActualProcess126Round00.contextBlock,
    ``FT1536.Source3.GeneratedActualProcess126Round00.localSnapshot,
    ``FT1536.Source3.GeneratedActualProcess126Round00.finished,
    ``FT1536.Source3.GeneratedActualProcess126Round00.next,
    ``FT1536.Source3.GeneratedActualProcess126Round00.prologue_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round00.initial_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round00.guard_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round00.locals_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round00.context_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round00.increment_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round00.source,
    ``FT1536.Source3.GeneratedActualProcess126Round01.ready,
    ``FT1536.Source3.GeneratedActualProcess126Round01.contextBlock,
    ``FT1536.Source3.GeneratedActualProcess126Round01.localSnapshot,
    ``FT1536.Source3.GeneratedActualProcess126Round01.finished,
    ``FT1536.Source3.GeneratedActualProcess126Round01.next,
    ``FT1536.Source3.GeneratedActualProcess126Round01.guard_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round01.locals_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round01.context_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round01.increment_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round01.source,
    ``FT1536.Source3.GeneratedActualProcess126Round02.ready,
    ``FT1536.Source3.GeneratedActualProcess126Round02.contextBlock,
    ``FT1536.Source3.GeneratedActualProcess126Round02.localSnapshot,
    ``FT1536.Source3.GeneratedActualProcess126Round02.finished,
    ``FT1536.Source3.GeneratedActualProcess126Round02.next,
    ``FT1536.Source3.GeneratedActualProcess126Round02.guard_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round02.locals_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round02.context_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round02.increment_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round02.source,
    ``FT1536.Source3.GeneratedActualProcess126Round03.ready,
    ``FT1536.Source3.GeneratedActualProcess126Round03.contextBlock,
    ``FT1536.Source3.GeneratedActualProcess126Round03.localSnapshot,
    ``FT1536.Source3.GeneratedActualProcess126Round03.finished,
    ``FT1536.Source3.GeneratedActualProcess126Round03.next,
    ``FT1536.Source3.GeneratedActualProcess126Round03.guard_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round03.locals_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round03.context_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round03.increment_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round03.source,
    ``FT1536.Source3.GeneratedActualProcess126Round04.ready,
    ``FT1536.Source3.GeneratedActualProcess126Round04.contextBlock,
    ``FT1536.Source3.GeneratedActualProcess126Round04.localSnapshot,
    ``FT1536.Source3.GeneratedActualProcess126Round04.finished,
    ``FT1536.Source3.GeneratedActualProcess126Round04.next,
    ``FT1536.Source3.GeneratedActualProcess126Round04.guard_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round04.locals_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round04.context_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round04.increment_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round04.source,
    ``FT1536.Source3.GeneratedActualProcess126Round05.ready,
    ``FT1536.Source3.GeneratedActualProcess126Round05.contextBlock,
    ``FT1536.Source3.GeneratedActualProcess126Round05.localSnapshot,
    ``FT1536.Source3.GeneratedActualProcess126Round05.finished,
    ``FT1536.Source3.GeneratedActualProcess126Round05.next,
    ``FT1536.Source3.GeneratedActualProcess126Round05.guard_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round05.locals_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round05.context_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round05.increment_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round05.source,
    ``FT1536.Source3.GeneratedActualProcess126Round06.ready,
    ``FT1536.Source3.GeneratedActualProcess126Round06.contextBlock,
    ``FT1536.Source3.GeneratedActualProcess126Round06.localSnapshot,
    ``FT1536.Source3.GeneratedActualProcess126Round06.finished,
    ``FT1536.Source3.GeneratedActualProcess126Round06.next,
    ``FT1536.Source3.GeneratedActualProcess126Round06.guard_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round06.locals_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round06.context_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round06.increment_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round06.source,
    ``FT1536.Source3.GeneratedActualProcess126Round07.ready,
    ``FT1536.Source3.GeneratedActualProcess126Round07.contextBlock,
    ``FT1536.Source3.GeneratedActualProcess126Round07.localSnapshot,
    ``FT1536.Source3.GeneratedActualProcess126Round07.finished,
    ``FT1536.Source3.GeneratedActualProcess126Round07.next,
    ``FT1536.Source3.GeneratedActualProcess126Round07.guard_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round07.locals_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round07.context_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round07.increment_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round07.source,
    ``FT1536.Source3.GeneratedActualProcess126Round08.ready,
    ``FT1536.Source3.GeneratedActualProcess126Round08.contextBlock,
    ``FT1536.Source3.GeneratedActualProcess126Round08.localSnapshot,
    ``FT1536.Source3.GeneratedActualProcess126Round08.finished,
    ``FT1536.Source3.GeneratedActualProcess126Round08.next,
    ``FT1536.Source3.GeneratedActualProcess126Round08.guard_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round08.locals_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round08.context_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round08.increment_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round08.source,
    ``FT1536.Source3.GeneratedActualProcess126Round09.ready,
    ``FT1536.Source3.GeneratedActualProcess126Round09.contextBlock,
    ``FT1536.Source3.GeneratedActualProcess126Round09.localSnapshot,
    ``FT1536.Source3.GeneratedActualProcess126Round09.finished,
    ``FT1536.Source3.GeneratedActualProcess126Round09.next,
    ``FT1536.Source3.GeneratedActualProcess126Round09.guard_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round09.locals_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round09.context_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round09.increment_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round09.source,
    ``FT1536.Source3.GeneratedActualProcess126Round10.ready,
    ``FT1536.Source3.GeneratedActualProcess126Round10.contextBlock,
    ``FT1536.Source3.GeneratedActualProcess126Round10.localSnapshot,
    ``FT1536.Source3.GeneratedActualProcess126Round10.finished,
    ``FT1536.Source3.GeneratedActualProcess126Round10.next,
    ``FT1536.Source3.GeneratedActualProcess126Round10.guard_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round10.locals_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round10.context_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round10.increment_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round10.source,
    ``FT1536.Source3.GeneratedActualProcess126Round11.ready,
    ``FT1536.Source3.GeneratedActualProcess126Round11.contextBlock,
    ``FT1536.Source3.GeneratedActualProcess126Round11.localSnapshot,
    ``FT1536.Source3.GeneratedActualProcess126Round11.finished,
    ``FT1536.Source3.GeneratedActualProcess126Round11.next,
    ``FT1536.Source3.GeneratedActualProcess126Round11.guard_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round11.locals_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round11.context_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round11.increment_computed,
    ``FT1536.Source3.GeneratedActualProcess126Round11.source,
    ``FT1536.Source3.ActualProcess126.caller,
    ``FT1536.Source3.ActualProcess126.pointer,
    ``FT1536.Source3.ActualProcess126.table,
    ``FT1536.Source3.ActualProcess126.finalState,
    ``FT1536.Source3.ActualProcess126.after,
    ``FT1536.Source3.ActualProcess126.static_checked,
    ``FT1536.Source3.ActualProcess126.final_guard,
    ``FT1536.Source3.ActualProcess126.loop12,
    ``FT1536.Source3.ActualProcess126.loop11,
    ``FT1536.Source3.ActualProcess126.loop10,
    ``FT1536.Source3.ActualProcess126.loop09,
    ``FT1536.Source3.ActualProcess126.loop08,
    ``FT1536.Source3.ActualProcess126.loop07,
    ``FT1536.Source3.ActualProcess126.loop06,
    ``FT1536.Source3.ActualProcess126.loop05,
    ``FT1536.Source3.ActualProcess126.loop04,
    ``FT1536.Source3.ActualProcess126.loop03,
    ``FT1536.Source3.ActualProcess126.loop02,
    ``FT1536.Source3.ActualProcess126.loop01,
    ``FT1536.Source3.ActualProcess126.loop00,
    ``FT1536.Source3.ActualProcess126.source_body,
    ``FT1536.Source3.ActualProcess126.source_process,
    ``FT1536.Source3.ActualProcess126.output_image,
    ``FT1536.Source3.ShakeExtractFragments126.append,
    ``FT1536.Source3.ActualExtractTail126.refillTail,
    ``FT1536.Source3.ActualExtractTail126.refillResult,
    ``FT1536.Source3.ActualExtractTail126.refill_defined,
    ``FT1536.Source3.ActualExtractTail126.refillRaw,
    ``FT1536.Source3.ActualExtractTail126.refill_computed,
    ``FT1536.Source3.ActualExtractTail126.refill_tail_source,
    ``FT1536.Source3.ActualExtractTail126.refilled,
    ``FT1536.Source3.ActualExtractTail126.process_call,
    ``FT1536.Source3.ActualExtractTail126.refill_source,
    ``FT1536.Source3.ActualExtractTail126.iterationTail,
    ``FT1536.Source3.ActualExtractTail126.iterationResult,
    ``FT1536.Source3.ActualExtractTail126.iteration_defined,
    ``FT1536.Source3.ActualExtractTail126.iterationRaw,
    ``FT1536.Source3.ActualExtractTail126.iteration_computed,
    ``FT1536.Source3.ActualExtractTail126.iteration_tail_source,
    ``FT1536.Source3.ActualExtractTail126.iterationDone,
    ``FT1536.Source3.ActualExtractBody126.iteration_source,
    ``FT1536.Source3.ActualExtractBody126.exit_computed,
    ``FT1536.Source3.ActualExtractBody126.loop_source,
    ``FT1536.Source3.ActualExtractBody126.finalCode,
    ``FT1536.Source3.ActualExtractBody126.finalResult,
    ``FT1536.Source3.ActualExtractBody126.final_defined,
    ``FT1536.Source3.ActualExtractBody126.finalState,
    ``FT1536.Source3.ActualExtractBody126.final_computed,
    ``FT1536.Source3.ActualExtractBody126.final_source,
    ``FT1536.Source3.ActualExtractBody126.body,
    ``FT1536.Source3.ActualExtractBody126.extracted,
    ``FT1536.Source3.ActualExtractBody126.call,
    ``FT1536.Source3.ActualDraw126.readResult,
    ``FT1536.Source3.ActualDraw126.read_defined,
    ``FT1536.Source3.ActualDraw126.word,
    ``FT1536.Source3.ActualDraw126.read_computed,
    ``FT1536.Source3.ActualDraw126.after,
    ``FT1536.Source3.ActualDraw126.source,
    ``FT1536.Source3.ActualDraw126.cursor,
    ``FT1536.Source3.ActualDraw126.disposed,
    ``FT1536.Source3.ActualRefill126.native_word,
    ``FT1536.Source3.ActualRefill126.assigned,
    ``FT1536.Source3.ActualRefill126.result,
    ``FT1536.Source3.ActualRefill126.defined,
    ``FT1536.Source3.ActualRefill126.refilled,
    ``FT1536.Source3.ActualRefill126.computed,
    ``FT1536.Source3.ActualRefill126.source]
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
