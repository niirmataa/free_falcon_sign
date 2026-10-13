import Source3.KeygenDecodeCalculation
import Source3.KeygenDecodeWordOps
import Source3.KeygenDecodeAssignments
import Source3.KeygenDecodeNoneCore
import Source3.KeygenDecodeNoneRead
import Source3.KeygenDecodeNoneSubtract
import Source3.KeygenDecodeWrite16
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Internal audit of constructive scalar/read/store components; full decoder composition remains open. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenDecodeCalculation,["IV","Ordinary","Computes","byte_unique","pointer_unique","computes_exists","computes_eval","assign_set","assign_exists"]),
    (`FT1536.Source3.KeygenDecodeWordOps,["self32","add32","sub32","neg32","and32","or32","mask32","left32","right32","joined_bytes","byte_cast32"]),
    (`FT1536.Source3.KeygenDecodeAssignments,["compound","compound_exists"]),
    (`FT1536.Source3.KeygenDecodeNoneCore,["Cell","signRhs","sign_calculation","sign_source","add_q_source","rangeBits","range_calculation","guard_calculation","guard_source","guard_exists"]),
    (`FT1536.Source3.KeygenDecodeNoneRead,["Cursor","index","joinRhs","twice64","plus64","index_calculation","read_calculation","joined_calculation","joined_source"]),
    (`FT1536.Source3.KeygenDecodeNoneSubtract,["rhs","self64","cast_long32","long_subtraction","rhs_calculation","subtract_source","subtract_exists","narrow_calculation","store_source"]),
    (`FT1536.Source3.KeygenDecodeWrite16,["overwrite","exists_store","readback","byte_preserved"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenCodecNoneOriginal.source_bytes,
    ``FT1536.Source3.KeygenCodecNoneWire.source_readable,
    ``FT1536.Source3.KeygenCodecNoneWire.source_original_preserved,
    ``FT1536.Source3.KeygenDecodeNoneBinding.source_bound,
    ``FT1536.Source3.KeygenDecodeMemory.store_same_memory,
    ``FT1536.Source3.KeygenDecodeNoneScalar.carrier_guard,
    ``FT1536.Source3.KeygenDecodeNoneScalar.carrier_subtract]
  let names := groups.flatMap fun (ns,decls) => decls.toArray.map (Lean.Name.str ns)
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  let mut rows : Array Lean.Json := #[]
  for name in names ++ inherited do
    IO.FS.writeFile "../SEARCH_AUDIT_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
    let info ← Lean.getConstInfo name
    let axes ← Lean.collectAxioms name
    for ax in axes do
      unless allowed.contains ax do throwError "Unexpected axiom {ax} in {name}"
    let body ← match info.value? (allowOpaque := true) with
      | some term => pure (Lean.Json.mkObj [("kind",Lean.toJson "definition_or_theorem"),
          ("term",Lean.toJson (← render term))])
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
    rows := rows.push (Lean.Json.mkObj [
      ("name",Lean.toJson name.toString),("type",Lean.toJson (← render info.type)),
      ("body",body),("axioms",Lean.toJson (axes.map Lean.Name.toString))])
    IO.FS.withFile "../SEARCH_AUDIT_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn rows.back!.compress
  IO.FS.writeFile "../SEARCH_AUDIT.json" (Lean.Json.arr rows |>.pretty)
