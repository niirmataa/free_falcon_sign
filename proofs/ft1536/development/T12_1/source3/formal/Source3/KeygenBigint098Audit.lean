import Source3.KeygenZintDeterminism098
import Source3.KeygenZintCoreArity098
import Source3.KeygenZintExtractArity098
import Source3.KeygenTokenizerStep098
import Source3.KeygenBezoutText098
import Source3.KeygenLexPrefix098
import Source3.KeygenLexCompose098
import Source3.KeygenLexData098
import Source3.KeygenLexChunks098A
import Source3.KeygenLexChunks098B
import Source3.KeygenLexChunks098C
import Source3.KeygenLexChunks098D
import Source3.KeygenLexChunks098E
import Source3.KeygenLexFinish098
import Source3.KeygenLexAll098
import Source3.KeygenBezoutTokens098
import Source3.KeygenBezoutParse098
import Source3.KeygenBezoutCheck098
import Source3.KeygenBezoutArity098
import Source3.KeygenZintCall098

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
    ``FT1536.Source3.KeygenZintDeterminism098.memzero,
    ``FT1536.Source3.KeygenZintDeterminism098.receive,
    ``FT1536.Source3.KeygenZintDeterminism098.checkedCode,
    ``FT1536.Source3.KeygenZintDeterminism098.execution,
    ``FT1536.Source3.KeygenZintCoreArity098.leaf,
    ``FT1536.Source3.KeygenZintCoreArity098.modSigned,
    ``FT1536.Source3.KeygenZintCoreArity098.normZero,
    ``FT1536.Source3.KeygenZintCoreArity098.exactLen,
    ``FT1536.Source3.KeygenZintCoreArity098.rshiftMod,
    ``FT1536.Source3.KeygenZintCoreArity098.subMod,
    ``FT1536.Source3.KeygenZintCoreArity098.rebuildCrt,
    ``FT1536.Source3.KeygenZintCoreArity098.coReduce,
    ``FT1536.Source3.KeygenZintCoreArity098.coReduceMod,
    ``FT1536.Source3.KeygenZintCoreArity098.reduce,
    ``FT1536.Source3.KeygenZintCoreArity098.reduceMod,
    ``FT1536.Source3.KeygenZintExtractArity098.chain_checked,
    ``FT1536.Source3.KeygenZintExtractArity098.bitlength0,
    ``FT1536.Source3.KeygenZintExtractArity098.bitlength1,
    ``FT1536.Source3.KeygenZintExtractArity098.bitlength2,
    ``FT1536.Source3.KeygenZintExtractArity098.signed0,
    ``FT1536.Source3.KeygenZintExtractArity098.signed1,
    ``FT1536.Source3.KeygenZintExtractArity098.signed2,
    ``FT1536.Source3.KeygenZintExtractArity098.signed3,
    ``FT1536.Source3.KeygenZintExtractArity098.signed4,
    ``FT1536.Source3.KeygenZintExtractArity098.bitlength,
    ``FT1536.Source3.KeygenZintExtractArity098.signedBitLength,
    ``FT1536.Source3.KeygenTokenizerStep098.zero,
    ``FT1536.Source3.KeygenTokenizerStep098.step,
    ``FT1536.Source3.KeygenTokenizerStep098.unfold_all,
    ``FT1536.Source3.KeygenBezoutText098.lines,
    ``FT1536.Source3.KeygenBezoutText098.chars,
    ``FT1536.Source3.KeygenBezoutText098.source_lines,
    ``FT1536.Source3.KeygenBezoutText098.source_chars,
    ``FT1536.Source3.KeygenLexPrefix098.chars,
    ``FT1536.Source3.KeygenLexPrefix098.tokens,
    ``FT1536.Source3.KeygenLexPrefix098.compose,
    ``FT1536.Source3.KeygenLexCompose098.Prefix,
    ``FT1536.Source3.KeygenLexCompose098.prefix_append,
    ``FT1536.Source3.KeygenLexCompose098.Chunk,
    ``FT1536.Source3.KeygenLexCompose098.empty,
    ``FT1536.Source3.KeygenLexCompose098.append,
    ``FT1536.Source3.KeygenLexCompose098.terminal,
    ``FT1536.Source3.KeygenLexCompose098.finish,
    ``FT1536.Source3.KeygenLexData098.raw,
    ``FT1536.Source3.KeygenLexData098.tokens,
    ``FT1536.Source3.KeygenLexData098.normalized,
    ``FT1536.Source3.KeygenLexChunks098A.lines00,
    ``FT1536.Source3.KeygenLexChunks098A.raw00,
    ``FT1536.Source3.KeygenLexChunks098A.equation00,
    ``FT1536.Source3.KeygenLexChunks098A.budget00,
    ``FT1536.Source3.KeygenLexChunks098A.chunk00,
    ``FT1536.Source3.KeygenLexChunks098A.lines01,
    ``FT1536.Source3.KeygenLexChunks098A.raw01,
    ``FT1536.Source3.KeygenLexChunks098A.equation01,
    ``FT1536.Source3.KeygenLexChunks098A.budget01,
    ``FT1536.Source3.KeygenLexChunks098A.chunk01,
    ``FT1536.Source3.KeygenLexChunks098A.lines02,
    ``FT1536.Source3.KeygenLexChunks098A.raw02,
    ``FT1536.Source3.KeygenLexChunks098A.equation02,
    ``FT1536.Source3.KeygenLexChunks098A.budget02,
    ``FT1536.Source3.KeygenLexChunks098A.chunk02,
    ``FT1536.Source3.KeygenLexChunks098A.lines03,
    ``FT1536.Source3.KeygenLexChunks098A.raw03,
    ``FT1536.Source3.KeygenLexChunks098A.equation03,
    ``FT1536.Source3.KeygenLexChunks098A.budget03,
    ``FT1536.Source3.KeygenLexChunks098A.chunk03,
    ``FT1536.Source3.KeygenLexChunks098A.lines04,
    ``FT1536.Source3.KeygenLexChunks098A.raw04,
    ``FT1536.Source3.KeygenLexChunks098A.equation04,
    ``FT1536.Source3.KeygenLexChunks098A.budget04,
    ``FT1536.Source3.KeygenLexChunks098A.chunk04,
    ``FT1536.Source3.KeygenLexChunks098A.lines05,
    ``FT1536.Source3.KeygenLexChunks098A.raw05,
    ``FT1536.Source3.KeygenLexChunks098A.equation05,
    ``FT1536.Source3.KeygenLexChunks098A.budget05,
    ``FT1536.Source3.KeygenLexChunks098A.chunk05,
    ``FT1536.Source3.KeygenLexChunks098A.lines06,
    ``FT1536.Source3.KeygenLexChunks098A.raw06,
    ``FT1536.Source3.KeygenLexChunks098A.equation06,
    ``FT1536.Source3.KeygenLexChunks098A.budget06,
    ``FT1536.Source3.KeygenLexChunks098A.chunk06,
    ``FT1536.Source3.KeygenLexChunks098A.lines07,
    ``FT1536.Source3.KeygenLexChunks098A.raw07,
    ``FT1536.Source3.KeygenLexChunks098A.equation07,
    ``FT1536.Source3.KeygenLexChunks098A.budget07,
    ``FT1536.Source3.KeygenLexChunks098A.chunk07,
    ``FT1536.Source3.KeygenLexChunks098A.lines08,
    ``FT1536.Source3.KeygenLexChunks098A.raw08,
    ``FT1536.Source3.KeygenLexChunks098A.equation08,
    ``FT1536.Source3.KeygenLexChunks098A.budget08,
    ``FT1536.Source3.KeygenLexChunks098A.chunk08,
    ``FT1536.Source3.KeygenLexChunks098B.lines09,
    ``FT1536.Source3.KeygenLexChunks098B.raw09,
    ``FT1536.Source3.KeygenLexChunks098B.equation09,
    ``FT1536.Source3.KeygenLexChunks098B.budget09,
    ``FT1536.Source3.KeygenLexChunks098B.chunk09,
    ``FT1536.Source3.KeygenLexChunks098B.lines10,
    ``FT1536.Source3.KeygenLexChunks098B.raw10,
    ``FT1536.Source3.KeygenLexChunks098B.equation10,
    ``FT1536.Source3.KeygenLexChunks098B.budget10,
    ``FT1536.Source3.KeygenLexChunks098B.chunk10,
    ``FT1536.Source3.KeygenLexChunks098B.lines11,
    ``FT1536.Source3.KeygenLexChunks098B.raw11,
    ``FT1536.Source3.KeygenLexChunks098B.equation11,
    ``FT1536.Source3.KeygenLexChunks098B.budget11,
    ``FT1536.Source3.KeygenLexChunks098B.chunk11,
    ``FT1536.Source3.KeygenLexChunks098B.lines12,
    ``FT1536.Source3.KeygenLexChunks098B.raw12,
    ``FT1536.Source3.KeygenLexChunks098B.equation12,
    ``FT1536.Source3.KeygenLexChunks098B.budget12,
    ``FT1536.Source3.KeygenLexChunks098B.chunk12,
    ``FT1536.Source3.KeygenLexChunks098B.lines13,
    ``FT1536.Source3.KeygenLexChunks098B.raw13,
    ``FT1536.Source3.KeygenLexChunks098B.equation13,
    ``FT1536.Source3.KeygenLexChunks098B.budget13,
    ``FT1536.Source3.KeygenLexChunks098B.chunk13,
    ``FT1536.Source3.KeygenLexChunks098B.lines14,
    ``FT1536.Source3.KeygenLexChunks098B.raw14,
    ``FT1536.Source3.KeygenLexChunks098B.equation14,
    ``FT1536.Source3.KeygenLexChunks098B.budget14,
    ``FT1536.Source3.KeygenLexChunks098B.chunk14,
    ``FT1536.Source3.KeygenLexChunks098B.lines15,
    ``FT1536.Source3.KeygenLexChunks098B.raw15,
    ``FT1536.Source3.KeygenLexChunks098B.equation15,
    ``FT1536.Source3.KeygenLexChunks098B.budget15,
    ``FT1536.Source3.KeygenLexChunks098B.chunk15,
    ``FT1536.Source3.KeygenLexChunks098B.lines16,
    ``FT1536.Source3.KeygenLexChunks098B.raw16,
    ``FT1536.Source3.KeygenLexChunks098B.equation16,
    ``FT1536.Source3.KeygenLexChunks098B.budget16,
    ``FT1536.Source3.KeygenLexChunks098B.chunk16,
    ``FT1536.Source3.KeygenLexChunks098B.lines17,
    ``FT1536.Source3.KeygenLexChunks098B.raw17,
    ``FT1536.Source3.KeygenLexChunks098B.equation17,
    ``FT1536.Source3.KeygenLexChunks098B.budget17,
    ``FT1536.Source3.KeygenLexChunks098B.chunk17,
    ``FT1536.Source3.KeygenLexChunks098C.lines18,
    ``FT1536.Source3.KeygenLexChunks098C.raw18,
    ``FT1536.Source3.KeygenLexChunks098C.equation18,
    ``FT1536.Source3.KeygenLexChunks098C.budget18,
    ``FT1536.Source3.KeygenLexChunks098C.chunk18,
    ``FT1536.Source3.KeygenLexChunks098C.lines19,
    ``FT1536.Source3.KeygenLexChunks098C.raw19,
    ``FT1536.Source3.KeygenLexChunks098C.equation19,
    ``FT1536.Source3.KeygenLexChunks098C.budget19,
    ``FT1536.Source3.KeygenLexChunks098C.chunk19,
    ``FT1536.Source3.KeygenLexChunks098C.lines20,
    ``FT1536.Source3.KeygenLexChunks098C.raw20,
    ``FT1536.Source3.KeygenLexChunks098C.equation20,
    ``FT1536.Source3.KeygenLexChunks098C.budget20,
    ``FT1536.Source3.KeygenLexChunks098C.chunk20,
    ``FT1536.Source3.KeygenLexChunks098C.lines21,
    ``FT1536.Source3.KeygenLexChunks098C.raw21,
    ``FT1536.Source3.KeygenLexChunks098C.equation21,
    ``FT1536.Source3.KeygenLexChunks098C.budget21,
    ``FT1536.Source3.KeygenLexChunks098C.chunk21,
    ``FT1536.Source3.KeygenLexChunks098C.lines22,
    ``FT1536.Source3.KeygenLexChunks098C.raw22,
    ``FT1536.Source3.KeygenLexChunks098C.equation22,
    ``FT1536.Source3.KeygenLexChunks098C.budget22,
    ``FT1536.Source3.KeygenLexChunks098C.chunk22,
    ``FT1536.Source3.KeygenLexChunks098C.lines23,
    ``FT1536.Source3.KeygenLexChunks098C.raw23,
    ``FT1536.Source3.KeygenLexChunks098C.equation23,
    ``FT1536.Source3.KeygenLexChunks098C.budget23,
    ``FT1536.Source3.KeygenLexChunks098C.chunk23,
    ``FT1536.Source3.KeygenLexChunks098C.lines24,
    ``FT1536.Source3.KeygenLexChunks098C.raw24,
    ``FT1536.Source3.KeygenLexChunks098C.equation24,
    ``FT1536.Source3.KeygenLexChunks098C.budget24,
    ``FT1536.Source3.KeygenLexChunks098C.chunk24,
    ``FT1536.Source3.KeygenLexChunks098C.lines25,
    ``FT1536.Source3.KeygenLexChunks098C.raw25,
    ``FT1536.Source3.KeygenLexChunks098C.equation25,
    ``FT1536.Source3.KeygenLexChunks098C.budget25,
    ``FT1536.Source3.KeygenLexChunks098C.chunk25,
    ``FT1536.Source3.KeygenLexChunks098C.lines26,
    ``FT1536.Source3.KeygenLexChunks098C.raw26,
    ``FT1536.Source3.KeygenLexChunks098C.equation26,
    ``FT1536.Source3.KeygenLexChunks098C.budget26,
    ``FT1536.Source3.KeygenLexChunks098C.chunk26,
    ``FT1536.Source3.KeygenLexChunks098D.lines27,
    ``FT1536.Source3.KeygenLexChunks098D.raw27,
    ``FT1536.Source3.KeygenLexChunks098D.equation27,
    ``FT1536.Source3.KeygenLexChunks098D.budget27,
    ``FT1536.Source3.KeygenLexChunks098D.chunk27,
    ``FT1536.Source3.KeygenLexChunks098D.lines28,
    ``FT1536.Source3.KeygenLexChunks098D.raw28,
    ``FT1536.Source3.KeygenLexChunks098D.equation28,
    ``FT1536.Source3.KeygenLexChunks098D.budget28,
    ``FT1536.Source3.KeygenLexChunks098D.chunk28,
    ``FT1536.Source3.KeygenLexChunks098D.lines29,
    ``FT1536.Source3.KeygenLexChunks098D.raw29,
    ``FT1536.Source3.KeygenLexChunks098D.equation29,
    ``FT1536.Source3.KeygenLexChunks098D.budget29,
    ``FT1536.Source3.KeygenLexChunks098D.chunk29,
    ``FT1536.Source3.KeygenLexChunks098D.lines30,
    ``FT1536.Source3.KeygenLexChunks098D.raw30,
    ``FT1536.Source3.KeygenLexChunks098D.equation30,
    ``FT1536.Source3.KeygenLexChunks098D.budget30,
    ``FT1536.Source3.KeygenLexChunks098D.chunk30,
    ``FT1536.Source3.KeygenLexChunks098D.lines31,
    ``FT1536.Source3.KeygenLexChunks098D.raw31,
    ``FT1536.Source3.KeygenLexChunks098D.equation31,
    ``FT1536.Source3.KeygenLexChunks098D.budget31,
    ``FT1536.Source3.KeygenLexChunks098D.chunk31,
    ``FT1536.Source3.KeygenLexChunks098D.lines32,
    ``FT1536.Source3.KeygenLexChunks098D.raw32,
    ``FT1536.Source3.KeygenLexChunks098D.equation32,
    ``FT1536.Source3.KeygenLexChunks098D.budget32,
    ``FT1536.Source3.KeygenLexChunks098D.chunk32,
    ``FT1536.Source3.KeygenLexChunks098D.lines33,
    ``FT1536.Source3.KeygenLexChunks098D.raw33,
    ``FT1536.Source3.KeygenLexChunks098D.equation33,
    ``FT1536.Source3.KeygenLexChunks098D.budget33,
    ``FT1536.Source3.KeygenLexChunks098D.chunk33,
    ``FT1536.Source3.KeygenLexChunks098D.lines34,
    ``FT1536.Source3.KeygenLexChunks098D.raw34,
    ``FT1536.Source3.KeygenLexChunks098D.equation34,
    ``FT1536.Source3.KeygenLexChunks098D.budget34,
    ``FT1536.Source3.KeygenLexChunks098D.chunk34,
    ``FT1536.Source3.KeygenLexChunks098D.lines35,
    ``FT1536.Source3.KeygenLexChunks098D.raw35,
    ``FT1536.Source3.KeygenLexChunks098D.equation35,
    ``FT1536.Source3.KeygenLexChunks098D.budget35,
    ``FT1536.Source3.KeygenLexChunks098D.chunk35,
    ``FT1536.Source3.KeygenLexChunks098E.lines36,
    ``FT1536.Source3.KeygenLexChunks098E.raw36,
    ``FT1536.Source3.KeygenLexChunks098E.equation36,
    ``FT1536.Source3.KeygenLexChunks098E.budget36,
    ``FT1536.Source3.KeygenLexChunks098E.chunk36,
    ``FT1536.Source3.KeygenLexChunks098E.lines37,
    ``FT1536.Source3.KeygenLexChunks098E.raw37,
    ``FT1536.Source3.KeygenLexChunks098E.equation37,
    ``FT1536.Source3.KeygenLexChunks098E.budget37,
    ``FT1536.Source3.KeygenLexChunks098E.chunk37,
    ``FT1536.Source3.KeygenLexChunks098E.lines38,
    ``FT1536.Source3.KeygenLexChunks098E.raw38,
    ``FT1536.Source3.KeygenLexChunks098E.equation38,
    ``FT1536.Source3.KeygenLexChunks098E.budget38,
    ``FT1536.Source3.KeygenLexChunks098E.chunk38,
    ``FT1536.Source3.KeygenLexChunks098E.lines39,
    ``FT1536.Source3.KeygenLexChunks098E.raw39,
    ``FT1536.Source3.KeygenLexChunks098E.equation39,
    ``FT1536.Source3.KeygenLexChunks098E.budget39,
    ``FT1536.Source3.KeygenLexChunks098E.chunk39,
    ``FT1536.Source3.KeygenLexChunks098E.lines40,
    ``FT1536.Source3.KeygenLexChunks098E.raw40,
    ``FT1536.Source3.KeygenLexChunks098E.equation40,
    ``FT1536.Source3.KeygenLexChunks098E.budget40,
    ``FT1536.Source3.KeygenLexChunks098E.chunk40,
    ``FT1536.Source3.KeygenLexFinish098.chars,
    ``FT1536.Source3.KeygenLexFinish098.raw,
    ``FT1536.Source3.KeygenLexFinish098.normalized,
    ``FT1536.Source3.KeygenLexAll098.whole,
    ``FT1536.Source3.KeygenLexAll098.lines_source,
    ``FT1536.Source3.KeygenLexAll098.raw_value,
    ``FT1536.Source3.KeygenLexAll098.chars_value,
    ``FT1536.Source3.KeygenLexAll098.tokens_source,
    ``FT1536.Source3.KeygenBezoutTokens098.chars,
    ``FT1536.Source3.KeygenBezoutTokens098.tokens,
    ``FT1536.Source3.KeygenBezoutTokens098.input_chars,
    ``FT1536.Source3.KeygenBezoutTokens098.source,
    ``FT1536.Source3.KeygenBezoutParse098.sourceChars,
    ``FT1536.Source3.KeygenBezoutParse098.after,
    ``FT1536.Source3.KeygenBezoutParse098.fromChars,
    ``FT1536.Source3.KeygenBezoutParse098.region_source,
    ``FT1536.Source3.KeygenBezoutParse098.after_lexer,
    ``FT1536.Source3.KeygenBezoutParse098.region_alias,
    ``FT1536.Source3.KeygenBezoutParse098.chars_link,
    ``FT1536.Source3.KeygenBezoutParse098.source_parsed,
    ``FT1536.Source3.KeygenBezoutParse098.codeFromTokens,
    ``FT1536.Source3.KeygenBezoutParse098.getD_congr,
    ``FT1536.Source3.KeygenBezoutParse098.part_alias,
    ``FT1536.Source3.KeygenBezoutParse098.source_code,
    ``FT1536.Source3.KeygenBezoutCheck098.checked,
    ``FT1536.Source3.KeygenBezoutCheck098.source,
    ``FT1536.Source3.KeygenBezoutArity098.part0,
    ``FT1536.Source3.KeygenBezoutArity098.part1,
    ``FT1536.Source3.KeygenBezoutArity098.part2,
    ``FT1536.Source3.KeygenBezoutArity098.part3,
    ``FT1536.Source3.KeygenBezoutArity098.part4,
    ``FT1536.Source3.KeygenBezoutArity098.part5,
    ``FT1536.Source3.KeygenBezoutArity098.part6,
    ``FT1536.Source3.KeygenBezoutArity098.part7,
    ``FT1536.Source3.KeygenBezoutArity098.body,
    ``FT1536.Source3.KeygenZintCall098.source_parsed,
    ``FT1536.Source3.KeygenZintCall098.leaf_parsed,
    ``FT1536.Source3.KeygenZintCall098.bezout_parsed,
    ``FT1536.Source3.KeygenZintCall098.bitlength_parsed,
    ``FT1536.Source3.KeygenZintCall098.signed_parsed,
    ``FT1536.Source3.KeygenZintCall098.closed,
    ``FT1536.Source3.KeygenZintCall098.body_unique,
    ``FT1536.Source3.KeygenZintCall098.call_unique,
    ``FT1536.Source3.KeygenZintCall098.runCall,
    ``FT1536.Source3.KeygenZintCall098.runCall_spec]
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
