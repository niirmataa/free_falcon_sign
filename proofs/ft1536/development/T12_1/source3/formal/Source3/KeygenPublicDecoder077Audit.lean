import Source3.KeygenDecodeWrite16
import Source3.KeygenCodecStaticBitInverse
import Source3.KeygenDecodeNoneExactFrame
import Source3.KeygenPublicNormalizePolynomial
import Source3.KeygenInt16Vector076
import Source3.KeygenPublicDecodeReady077
import Source3.KeygenPublicDecodeSequence077
import Source3.KeygenPublicDecodeBits077
import Source3.KeygenPublicDecodeRead077
import Source3.KeygenPublicDecodeRefill077
import Source3.KeygenPublicDecodeExtractCalc077
import Source3.KeygenPublicDecodeExtract077
import Source3.KeygenPublicDecodeIteration077
import Source3.KeygenPublicDecodeLoop077
import Source3.KeygenPublicDecodePrologue077
import Source3.KeygenPublicDecodeComplete077
import Source3.KeygenPublicRoundtrip077
import Source3.KeygenPublicMaterial077
import Source3.KeygenPublicMath077
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Complete public payload round-trip and SAME mathematical h; caller header/length assembly remains open. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenPublicDecodeReady077,["Cell","Context","Ready","Checks","context_frame","set32","set64","setPending","Reads","remaining","Wire","empty_scope"]),
    (`FT1536.Source3.KeygenPublicDecodeSequence077,["chain","append_run","split_run","append_checked"]),
    (`FT1536.Source3.KeygenPublicDecodeBits077,["appended","bits_length","append_bound","refill","extract"]),
    (`FT1536.Source3.KeygenPublicDecodeRead077,["next","readRhs","appendRhs","after","or_byte","read_calculation","append_calculation","source_append"]),
    (`FT1536.Source3.KeygenPublicDecodeRefill077,["pieces","code","after","refill"]),
    (`FT1536.Source3.KeygenPublicDecodeExtractCalc077,["shiftRhs","maskRhs","promoted","promoted_integer","narrowed","cast_input","pending_calculation","shift_calculation","mask_calculation","word_calculation"]),
    (`FT1536.Source3.KeygenPublicDecodeExtract077,["freshW","afterStore","extract"]),
    (`FT1536.Source3.KeygenPublicDecodeIteration077,["finish","no_store","reads_preserved","store"]),
    (`FT1536.Source3.KeygenPublicDecodeLoop077,["guard","next","advance_one","loop"]),
    (`FT1536.Source3.KeygenPublicDecodePrologue077,["nRhs","pieces","code","partition","freshNU","freshAcc","freshPending","initialized","n_calculation","zero","prologue"]),
    (`FT1536.Source3.KeygenPublicDecodeComplete077,["suffix","decoder_checked","source_outcome","decoder_exists"]),
    (`FT1536.Source3.KeygenPublicRoundtrip077,["EncoderArgs","DecoderArgs","decoderArgs","Entry","encoded_facts","source_roundtrip","roundtrip_exists","honest_roundtrip_exists","in_place_identity"]),
    (`FT1536.Source3.KeygenPublicMaterial077,["coefficient","Realizes","coefficient_low","coefficient_high","represented_cell","represented_words","decoder_narrow","decoded_represents"]),
    (`FT1536.Source3.KeygenPublicMath077,["Legal","source_roundtrip","honest_roundtrip_exists","from_witness"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenPublicEncodeBinding077.source_bound,
    ``FT1536.Source3.KeygenPublicDecodeBinding077.source_bound,
    ``FT1536.Source3.KeygenPublicEncodeComplete077.source_outcome,
    ``FT1536.Source3.KeygenMakeMaterialWitness.Witness]
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
