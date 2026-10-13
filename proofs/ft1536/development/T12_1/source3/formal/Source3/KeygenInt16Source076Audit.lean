import Source3.KeygenDecodeWrite16
import Source3.KeygenCodecStaticBitInverse
import Source3.KeygenDecodeNoneExactFrame
import Source3.KeygenInt16Bounds076
import Source3.KeygenInt16CodecMath076
import Source3.KeygenInt16FourMaterial076
import Source3.KeygenInt16Caller076
import Source3.KeygenInt16CallerDecode076
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Internal audit of constructive scalar/read/store components; full operational STATIC round-trip remains open. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenInt16Bounds076,["coefficient_bound","word_bound","none_carrier","magnitude_abs","low_magnitude","fg_length","total_upper17","big_length"]),
    (`FT1536.Source3.KeygenInt16CodecMath076,["IntegerReads","decoded_material","static_roundtrip","static_exists","none_roundtrip","none_exists"]),
    (`FT1536.Source3.KeygenInt16FourMaterial076,["Vectors","Legal","Represented","Physical","bounds_signed","bounds_carrier","represented_physical","physical_represented","source_conversion","from_witness"]),
    (`FT1536.Source3.KeygenInt16Caller076,["chain_transport","witness_transport"]),
    (`FT1536.Source3.KeygenInt16CallerDecode076,["decoded_trace","chain_decoders","witness_decoders"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenInt16Vector076.signedEquiv,
    ``FT1536.Source3.KeygenInt16Representation076.represents_iff_words,
    ``FT1536.Source3.KeygenMaterial.converted_material,
    ``FT1536.Source3.KeygenCodecStaticCallRoundtrip.source_call_roundtrip,
    ``FT1536.Source3.KeygenCodecNoneCallRoundtrip.source_call_roundtrip]
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
