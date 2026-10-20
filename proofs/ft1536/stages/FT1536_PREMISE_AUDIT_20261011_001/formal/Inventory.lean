import AllSource3
import Lean.Util.FoldConsts

set_option maxRecDepth 32768
set_option maxHeartbeats 0
set_option Elab.async false
set_option pp.fullNames true
set_option pp.proofs true
set_option pp.maxSteps 200000

open Lean Meta in
run_cmd Lean.Elab.Command.liftTermElabM do
  let raw ← IO.FS.readFile "WANTED.json"
  let parsed ← match Json.parse raw with
    | .ok j => pure j
    | .error e => throwError "{e}"
  let wanted ← match fromJson? parsed (α := Array String) with
    | .ok names => pure names
    | .error e => throwError "{e}"
  let env ← getEnv
  let render (e : Expr) : MetaM String := do
    let s := (← ppExpr e).pretty
    if s.contains '⋯' then throwError "Elided type"
    pure s
  let binders (type : Expr) (term : Option Expr := none) : MetaM (Array Json × Bool × String × String) := forallTelescope type fun xs result => do
    let mut out := #[]
    for x in xs do
      let d ← x.fvarId!.getDecl
      out := out.push (Json.mkObj [
        ("name",toJson d.userName.toString), ("type",toJson (← render d.type)),
        ("proof",toJson (← isProp d.type)),
        ("used_in_term",toJson (term.map fun t => (((mkAppN t xs).headBeta).find? (fun e => e == x)).isSome)),
        ("constants",toJson (d.type.getUsedConstants.map Name.toString))])
    pure (out,result.isProp,(← render result),result.getAppFn.constName?.getD Name.anonymous |>.toString)
  let file ← IO.FS.Handle.mk "ELABORATED.jsonl" .write
  for label in wanted do
    let name := label.toName
    match env.find? name with
    | none => file.putStrLn (Json.mkObj [("name",toJson label),("available",toJson false)]).compress
    | some info =>
      let (params,returnsProp,resultType,resultHead) ← binders info.type (info.value? (allowOpaque := true))
      let kind := match info with
        | .thmInfo _ => "theorem"
        | .defnInfo _ => "definition"
        | .inductInfo _ => "inductive"
        | .opaqueInfo _ => "opaque"
        | .axiomInfo _ => "axiom"
        | _ => "other"
      let mut ctors := #[]
      if let .inductInfo ind := info then
        for ctor in ind.ctors do
          let ci ← getConstInfo ctor
          let (bs,_,_,_) ← binders ci.type
          ctors := ctors.push (Json.mkObj [("name",toJson ctor.toString),
            ("type",toJson (← render ci.type)),("binders",Json.arr bs),
            ("constants",toJson (ci.type.getUsedConstants.map Name.toString))])
      let bodyRefs := match info.value? (allowOpaque := true) with
        | some b => b.getUsedConstants.map Name.toString
        | none => #[]
      let row := Json.mkObj [("name",toJson label),("available",toJson true),
        ("kind",toJson kind),("returns_prop",toJson returnsProp),
        ("result_type",toJson resultType),("result_head",toJson resultHead),
        ("type",toJson (← render info.type)),("binders",Json.arr params),
        ("constructors",Json.arr ctors),
        ("type_constants",toJson (info.type.getUsedConstants.map Name.toString)),
        ("body_constants",toJson bodyRefs)]
      file.putStrLn row.compress
