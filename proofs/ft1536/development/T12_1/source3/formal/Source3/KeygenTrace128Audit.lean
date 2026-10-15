import Source3.ShakeProcessEvents128
import Source3.ShakeExtractTrace128
import Source3.ShakeExtractTraceSound128
import Source3.ShakeExtractTraceCall128
import Source3.KeygenRngTrace128
import Source3.KeygenRefillTrace128
import Source3.KeygenInnerTrace128
import Source3.KeygenOuterSegment128
import Source3.KeygenSamplerPrefix128
import Source3.KeygenPrefixFrame128
import Source3.KeygenSamplerNormalize128
import Source3.ShakeProcessProposal128
import Source3.SelectedFullSampler128
import Source3.GeneratedProcessTransitions128
import Source3.SelectedSegment128
import Source3.ShakeEventFrame128
import Source3.FirstProcessSite128
import Source3.SelectedFirst128
import Source3.GeneratedEventProcess128Round00
import Source3.GeneratedEventProcess128Round01
import Source3.GeneratedEventProcess128Round02
import Source3.GeneratedEventProcess128Round03
import Source3.GeneratedEventProcess128Round04
import Source3.GeneratedEventProcess128Round05
import Source3.GeneratedEventProcess128Round06
import Source3.GeneratedEventProcess128Round07
import Source3.GeneratedEventProcess128Round08
import Source3.GeneratedEventProcess128Round09
import Source3.GeneratedEventProcess128Round10
import Source3.GeneratedEventProcess128Round11
import Source3.FirstProcess128
import Source3.FirstEventValid128
import Source3.KeygenPrefixCompose128
import Source3.GeneratedFirstSegment128
import Source3.FirstNormalized128
import Source3.GeneratedSampler128F01
import Source3.First64Source128

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
    ``FT1536.Source3.ShakeProcessEvents128.Event,
    ``FT1536.Source3.ShakeProcessEvents128.applyWords,
    ``FT1536.Source3.ShakeProcessEvents128.Event.after,
    ``FT1536.Source3.ShakeProcessEvents128.Proposal,
    ``FT1536.Source3.ShakeProcessEvents128.Result,
    ``FT1536.Source3.ShakeProcessEvents128.request,
    ``FT1536.Source3.ShakeProcessEvents128.Valid,
    ``FT1536.Source3.ShakeProcessEvents128.All,
    ``FT1536.Source3.ShakeProcessEvents128.left,
    ``FT1536.Source3.ShakeProcessEvents128.right,
    ``FT1536.Source3.ShakeProcessEvents128.singleton,
    ``FT1536.Source3.ShakeProcessEvents128.request_sound,
    ``FT1536.Source3.ShakeExtractTrace128.ordinary,
    ``FT1536.Source3.ShakeExtractTrace128.run,
    ``FT1536.Source3.ShakeExtractTraceSound128.ordinary_source,
    ``FT1536.Source3.ShakeExtractTraceSound128.run_sound,
    ``FT1536.Source3.ShakeExtractTraceCall128.invoke,
    ``FT1536.Source3.ShakeExtractTraceCall128.invoke_sound,
    ``FT1536.Source3.KeygenRngTrace128.Result,
    ``FT1536.Source3.KeygenRngTrace128.draw,
    ``FT1536.Source3.KeygenRngTrace128.draw_sound,
    ``FT1536.Source3.KeygenRefillTrace128.refill,
    ``FT1536.Source3.KeygenRefillTrace128.refill_sound,
    ``FT1536.Source3.KeygenInnerTrace128.run,
    ``FT1536.Source3.KeygenInnerTrace128.run_sound,
    ``FT1536.Source3.KeygenOuterSegment128.declareX,
    ``FT1536.Source3.KeygenOuterSegment128.declaration_source,
    ``FT1536.Source3.KeygenOuterSegment128.run,
    ``FT1536.Source3.KeygenOuterSegment128.run_sound,
    ``FT1536.Source3.KeygenSamplerPrefix128.Prefix,
    ``FT1536.Source3.KeygenSamplerPrefix128.finish,
    ``FT1536.Source3.KeygenSamplerPrefix128.run_prefix,
    ``FT1536.Source3.KeygenPrefixFrame128.stable,
    ``FT1536.Source3.KeygenPrefixFrame128.arrays,
    ``FT1536.Source3.KeygenPrefixFrame128.outside,
    ``FT1536.Source3.KeygenSamplerNormalize128.normalize,
    ``FT1536.Source3.KeygenSamplerNormalize128.heap_equal,
    ``FT1536.Source3.KeygenSamplerNormalize128.reference_equal,
    ``FT1536.Source3.KeygenSamplerNormalize128.source_normalized,
    ``FT1536.Source3.ShakeProcessProposal128.Transition,
    ``FT1536.Source3.ShakeProcessProposal128.candidateMatches,
    ``FT1536.Source3.ShakeProcessProposal128.propose,
    ``FT1536.Source3.SelectedFullSampler128.ctx,
    ``FT1536.Source3.SelectedFullSampler128.capResult,
    ``FT1536.Source3.SelectedFullSampler128.cap_defined,
    ``FT1536.Source3.SelectedFullSampler128.counted,
    ``FT1536.Source3.SelectedFullSampler128.cap_computed,
    ``FT1536.Source3.SelectedFullSampler128.cap_source,
    ``FT1536.Source3.SelectedFullSampler128.setupResult,
    ``FT1536.Source3.SelectedFullSampler128.setup_defined,
    ``FT1536.Source3.SelectedFullSampler128.prepared,
    ``FT1536.Source3.SelectedFullSampler128.setup_computed,
    ``FT1536.Source3.SelectedFullSampler128.capped,
    ``FT1536.Source3.SelectedFullSampler128.context,
    ``FT1536.Source3.SelectedFullSampler128.bindingResult,
    ``FT1536.Source3.SelectedFullSampler128.binding_defined,
    ``FT1536.Source3.SelectedFullSampler128.bound,
    ``FT1536.Source3.SelectedFullSampler128.binding_computed,
    ``FT1536.Source3.SelectedFullSampler128.binding,
    ``FT1536.Source3.SelectedFullSampler128.prologueResult,
    ``FT1536.Source3.SelectedFullSampler128.prologue_defined,
    ``FT1536.Source3.SelectedFullSampler128.declared,
    ``FT1536.Source3.SelectedFullSampler128.prologue_computed,
    ``FT1536.Source3.SelectedFullSampler128.prologue,
    ``FT1536.Source3.SelectedFullSampler128.initialResult,
    ``FT1536.Source3.SelectedFullSampler128.initial_defined,
    ``FT1536.Source3.SelectedFullSampler128.initial,
    ``FT1536.Source3.SelectedFullSampler128.initial_computed,
    ``FT1536.Source3.SelectedFullSampler128.initialization,
    ``FT1536.Source3.SelectedFullSampler128.destination,
    ``FT1536.Source3.SelectedFullSampler128.pointer_binding,
    ``FT1536.Source3.SelectedFullSampler128.dimension,
    ``FT1536.Source3.GeneratedProcessTransitions128.candidates,
    ``FT1536.Source3.SelectedSegment128.propose,
    ``FT1536.Source3.SelectedSegment128.result,
    ``FT1536.Source3.SelectedSegment128.defined,
    ``FT1536.Source3.SelectedSegment128.output,
    ``FT1536.Source3.SelectedSegment128.computed,
    ``FT1536.Source3.SelectedSegment128.event_count,
    ``FT1536.Source3.SelectedSegment128.counter,
    ``FT1536.Source3.SelectedSegment128.Obligations,
    ``FT1536.Source3.SelectedSegment128.source,
    ``FT1536.Source3.ShakeEventFrame128.pairs_frame,
    ``FT1536.Source3.ShakeEventFrame128.event_frame,
    ``FT1536.Source3.ShakeEventFrame128.process_slots,
    ``FT1536.Source3.ShakeEventFrame128.heap_equal,
    ``FT1536.Source3.ShakeEventFrame128.valid,
    ``FT1536.Source3.FirstProcessSite128.event,
    ``FT1536.Source3.FirstProcessSite128.caller,
    ``FT1536.Source3.FirstProcessSite128.ctx,
    ``FT1536.Source3.FirstProcessSite128.pointer,
    ``FT1536.Source3.FirstProcessSite128.table,
    ``FT1536.Source3.FirstProcessSite128.blockEntry,
    ``FT1536.Source3.FirstProcessSite128.pointer_exact,
    ``FT1536.Source3.FirstProcessSite128.event_pointer,
    ``FT1536.Source3.FirstProcessSite128.name_exact,
    ``FT1536.Source3.FirstProcessSite128.table_binding,
    ``FT1536.Source3.FirstProcessSite128.static_checked,
    ``FT1536.Source3.FirstProcessSite128.one_list,
    ``FT1536.Source3.FirstProcessSite128.event_list,
    ``FT1536.Source3.FirstProcessSite128.obligations,
    ``FT1536.Source3.SelectedFirst128.propose,
    ``FT1536.Source3.SelectedFirst128.result,
    ``FT1536.Source3.SelectedFirst128.defined,
    ``FT1536.Source3.SelectedFirst128.output,
    ``FT1536.Source3.SelectedFirst128.computed,
    ``FT1536.Source3.SelectedFirst128.event_count,
    ``FT1536.Source3.SelectedFirst128.counter,
    ``FT1536.Source3.SelectedFirst128.Obligations,
    ``FT1536.Source3.SelectedFirst128.source,
    ``FT1536.Source3.GeneratedEventProcess128Round00.declared,
    ``FT1536.Source3.GeneratedEventProcess128Round00.ready,
    ``FT1536.Source3.GeneratedEventProcess128Round00.contextBlock,
    ``FT1536.Source3.GeneratedEventProcess128Round00.localSnapshot,
    ``FT1536.Source3.GeneratedEventProcess128Round00.finished,
    ``FT1536.Source3.GeneratedEventProcess128Round00.next,
    ``FT1536.Source3.GeneratedEventProcess128Round00.prologue_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round00.initial_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round00.guard_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round00.locals_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round00.context_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round00.increment_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round00.source,
    ``FT1536.Source3.GeneratedEventProcess128Round01.ready,
    ``FT1536.Source3.GeneratedEventProcess128Round01.contextBlock,
    ``FT1536.Source3.GeneratedEventProcess128Round01.localSnapshot,
    ``FT1536.Source3.GeneratedEventProcess128Round01.finished,
    ``FT1536.Source3.GeneratedEventProcess128Round01.next,
    ``FT1536.Source3.GeneratedEventProcess128Round01.guard_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round01.locals_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round01.context_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round01.increment_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round01.source,
    ``FT1536.Source3.GeneratedEventProcess128Round02.ready,
    ``FT1536.Source3.GeneratedEventProcess128Round02.contextBlock,
    ``FT1536.Source3.GeneratedEventProcess128Round02.localSnapshot,
    ``FT1536.Source3.GeneratedEventProcess128Round02.finished,
    ``FT1536.Source3.GeneratedEventProcess128Round02.next,
    ``FT1536.Source3.GeneratedEventProcess128Round02.guard_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round02.locals_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round02.context_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round02.increment_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round02.source,
    ``FT1536.Source3.GeneratedEventProcess128Round03.ready,
    ``FT1536.Source3.GeneratedEventProcess128Round03.contextBlock,
    ``FT1536.Source3.GeneratedEventProcess128Round03.localSnapshot,
    ``FT1536.Source3.GeneratedEventProcess128Round03.finished,
    ``FT1536.Source3.GeneratedEventProcess128Round03.next,
    ``FT1536.Source3.GeneratedEventProcess128Round03.guard_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round03.locals_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round03.context_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round03.increment_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round03.source,
    ``FT1536.Source3.GeneratedEventProcess128Round04.ready,
    ``FT1536.Source3.GeneratedEventProcess128Round04.contextBlock,
    ``FT1536.Source3.GeneratedEventProcess128Round04.localSnapshot,
    ``FT1536.Source3.GeneratedEventProcess128Round04.finished,
    ``FT1536.Source3.GeneratedEventProcess128Round04.next,
    ``FT1536.Source3.GeneratedEventProcess128Round04.guard_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round04.locals_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round04.context_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round04.increment_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round04.source,
    ``FT1536.Source3.GeneratedEventProcess128Round05.ready,
    ``FT1536.Source3.GeneratedEventProcess128Round05.contextBlock,
    ``FT1536.Source3.GeneratedEventProcess128Round05.localSnapshot,
    ``FT1536.Source3.GeneratedEventProcess128Round05.finished,
    ``FT1536.Source3.GeneratedEventProcess128Round05.next,
    ``FT1536.Source3.GeneratedEventProcess128Round05.guard_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round05.locals_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round05.context_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round05.increment_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round05.source,
    ``FT1536.Source3.GeneratedEventProcess128Round06.ready,
    ``FT1536.Source3.GeneratedEventProcess128Round06.contextBlock,
    ``FT1536.Source3.GeneratedEventProcess128Round06.localSnapshot,
    ``FT1536.Source3.GeneratedEventProcess128Round06.finished,
    ``FT1536.Source3.GeneratedEventProcess128Round06.next,
    ``FT1536.Source3.GeneratedEventProcess128Round06.guard_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round06.locals_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round06.context_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round06.increment_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round06.source,
    ``FT1536.Source3.GeneratedEventProcess128Round07.ready,
    ``FT1536.Source3.GeneratedEventProcess128Round07.contextBlock,
    ``FT1536.Source3.GeneratedEventProcess128Round07.localSnapshot,
    ``FT1536.Source3.GeneratedEventProcess128Round07.finished,
    ``FT1536.Source3.GeneratedEventProcess128Round07.next,
    ``FT1536.Source3.GeneratedEventProcess128Round07.guard_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round07.locals_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round07.context_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round07.increment_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round07.source,
    ``FT1536.Source3.GeneratedEventProcess128Round08.ready,
    ``FT1536.Source3.GeneratedEventProcess128Round08.contextBlock,
    ``FT1536.Source3.GeneratedEventProcess128Round08.localSnapshot,
    ``FT1536.Source3.GeneratedEventProcess128Round08.finished,
    ``FT1536.Source3.GeneratedEventProcess128Round08.next,
    ``FT1536.Source3.GeneratedEventProcess128Round08.guard_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round08.locals_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round08.context_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round08.increment_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round08.source,
    ``FT1536.Source3.GeneratedEventProcess128Round09.ready,
    ``FT1536.Source3.GeneratedEventProcess128Round09.contextBlock,
    ``FT1536.Source3.GeneratedEventProcess128Round09.localSnapshot,
    ``FT1536.Source3.GeneratedEventProcess128Round09.finished,
    ``FT1536.Source3.GeneratedEventProcess128Round09.next,
    ``FT1536.Source3.GeneratedEventProcess128Round09.guard_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round09.locals_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round09.context_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round09.increment_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round09.source,
    ``FT1536.Source3.GeneratedEventProcess128Round10.ready,
    ``FT1536.Source3.GeneratedEventProcess128Round10.contextBlock,
    ``FT1536.Source3.GeneratedEventProcess128Round10.localSnapshot,
    ``FT1536.Source3.GeneratedEventProcess128Round10.finished,
    ``FT1536.Source3.GeneratedEventProcess128Round10.next,
    ``FT1536.Source3.GeneratedEventProcess128Round10.guard_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round10.locals_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round10.context_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round10.increment_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round10.source,
    ``FT1536.Source3.GeneratedEventProcess128Round11.ready,
    ``FT1536.Source3.GeneratedEventProcess128Round11.contextBlock,
    ``FT1536.Source3.GeneratedEventProcess128Round11.localSnapshot,
    ``FT1536.Source3.GeneratedEventProcess128Round11.finished,
    ``FT1536.Source3.GeneratedEventProcess128Round11.next,
    ``FT1536.Source3.GeneratedEventProcess128Round11.guard_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round11.locals_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round11.context_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round11.increment_computed,
    ``FT1536.Source3.GeneratedEventProcess128Round11.source,
    ``FT1536.Source3.FirstProcess128.caller,
    ``FT1536.Source3.FirstProcess128.pointer,
    ``FT1536.Source3.FirstProcess128.table,
    ``FT1536.Source3.FirstProcess128.finalState,
    ``FT1536.Source3.FirstProcess128.after,
    ``FT1536.Source3.FirstProcess128.static_checked,
    ``FT1536.Source3.FirstProcess128.final_guard,
    ``FT1536.Source3.FirstProcess128.loop12,
    ``FT1536.Source3.FirstProcess128.loop11,
    ``FT1536.Source3.FirstProcess128.loop10,
    ``FT1536.Source3.FirstProcess128.loop09,
    ``FT1536.Source3.FirstProcess128.loop08,
    ``FT1536.Source3.FirstProcess128.loop07,
    ``FT1536.Source3.FirstProcess128.loop06,
    ``FT1536.Source3.FirstProcess128.loop05,
    ``FT1536.Source3.FirstProcess128.loop04,
    ``FT1536.Source3.FirstProcess128.loop03,
    ``FT1536.Source3.FirstProcess128.loop02,
    ``FT1536.Source3.FirstProcess128.loop01,
    ``FT1536.Source3.FirstProcess128.loop00,
    ``FT1536.Source3.FirstProcess128.source_body,
    ``FT1536.Source3.FirstProcess128.source_process,
    ``FT1536.Source3.FirstProcess128.output_image,
    ``FT1536.Source3.FirstEventValid128.changed_block,
    ``FT1536.Source3.FirstEventValid128.valid,
    ``FT1536.Source3.FirstEventValid128.obligations,
    ``FT1536.Source3.FirstEventValid128.first_coefficient,
    ``FT1536.Source3.KeygenPrefixCompose128.append,
    ``FT1536.Source3.KeygenPrefixCompose128.done,
    ``FT1536.Source3.GeneratedFirstSegment128.contextBlock,
    ``FT1536.Source3.GeneratedFirstSegment128.coefficientBlock,
    ``FT1536.Source3.GeneratedFirstSegment128.localSnapshot,
    ``FT1536.Source3.GeneratedFirstSegment128.after,
    ``FT1536.Source3.GeneratedFirstSegment128.context_image,
    ``FT1536.Source3.GeneratedFirstSegment128.coefficient_image,
    ``FT1536.Source3.GeneratedFirstSegment128.locals_image,
    ``FT1536.Source3.GeneratedFirstSegment128.normalized,
    ``FT1536.Source3.FirstNormalized128.source,
    ``FT1536.Source3.GeneratedSampler128F01.before,
    ``FT1536.Source3.GeneratedSampler128F01.propose,
    ``FT1536.Source3.GeneratedSampler128F01.result,
    ``FT1536.Source3.GeneratedSampler128F01.defined,
    ``FT1536.Source3.GeneratedSampler128F01.output,
    ``FT1536.Source3.GeneratedSampler128F01.computed,
    ``FT1536.Source3.GeneratedSampler128F01.contextBlock,
    ``FT1536.Source3.GeneratedSampler128F01.coefficientBlock,
    ``FT1536.Source3.GeneratedSampler128F01.localSnapshot,
    ``FT1536.Source3.GeneratedSampler128F01.after,
    ``FT1536.Source3.GeneratedSampler128F01.pointer_binding,
    ``FT1536.Source3.GeneratedSampler128F01.context_image,
    ``FT1536.Source3.GeneratedSampler128F01.coefficient_image,
    ``FT1536.Source3.GeneratedSampler128F01.locals_image,
    ``FT1536.Source3.GeneratedSampler128F01.event_count,
    ``FT1536.Source3.GeneratedSampler128F01.Obligations,
    ``FT1536.Source3.GeneratedSampler128F01.source,
    ``FT1536.Source3.GeneratedSampler128F01.normalized,
    ``FT1536.Source3.GeneratedSampler128F01.obligations,
    ``FT1536.Source3.GeneratedSampler128F01.closed,
    ``FT1536.Source3.First64Source128.source]
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
