import Source3.KeygenDecodeWrite16
import Source3.KeygenCodecStaticBitInverse
import Source3.KeygenDecodeNoneExactFrame
import Source3.KeygenPublicNormalizePolynomial
import Source3.KeygenInt16Vector076
import Source3.KeygenPublicCallerSite077
import Source3.KeygenPublicPacket077
import Source3.KeygenPublicCallerExecution077
import Source3.KeygenPublicCallerTrace077
import Source3.KeygenPublicObserved077
import Source3.KeygenPublicCallerComplete077
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Complete local public caller header/length/observed-byte proof; whole-root B1.07 assembly remains open. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenPublicCallerSite077,["arguments","Site","nextState","call_source","header_source","length_source","header_value","length_value","capacity","source_output"]),
    (`FT1536.Source3.KeygenPublicPacket077,["group","vector","DecodePublic","group_bits","group_append","recovered","decode_honest"]),
    (`FT1536.Source3.KeygenPublicCallerExecution077,["Head","head_erase","head_legacy","Encoding","erase","head_success","next","plain","public_extract","code","source_suffix","return_final"]),
    (`FT1536.Source3.KeygenPublicCallerTrace077,["read_length","capacity_pass","zero_pass","header","length_store","trace"]),
    (`FT1536.Source3.KeygenPublicObserved077,["ObservedPublic","byteOff_add","positions_shift","byte_transport","byte_after_store","byte_after_length","material_after_header","packet_observed","byte_unique","observed_unique"]),
    (`FT1536.Source3.KeygenPublicCallerComplete077,["Legal","observed_output","actual_observed_decode","from_witness"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMakeProgram.source_bound,
    ``FT1536.Source3.KeygenPublicEncodeBinding077.source_bound,
    ``FT1536.Source3.KeygenPublicDecodeBinding077.source_bound,
    ``FT1536.Source3.KeygenPublicMath077.from_witness]
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
