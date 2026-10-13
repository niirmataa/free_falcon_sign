import Source3.KeygenCodecStaticLength
import Source3.KeygenCodecExactLengths
import Source3.KeygenCodecStaticSmallLength
import Source3.KeygenCodecChainLengths
import Source3.KeygenDecodeSyntax
import Source3.KeygenDecodeGrammar
import Source3.KeygenDecodeNoneBindingPart00
import Source3.KeygenDecodeNoneBindingPart01
import Source3.KeygenDecodeNoneBindingPart02
import Source3.KeygenDecodeSource
import Source3.KeygenDecodeNoneBinding
import Source3.KeygenDecodeNoneScalar
import Source3.KeygenDecodeNonePairs
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated072 source lengths, exact NONE decoder syntax and scalar/pair inverse adapter.
   Internal audit only; complete source decoder execution and Vec/physical transport remain OPEN; public LAST. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenCodecStaticLength,
      ["unaryCount","bitCost","totalBits","byteLength","unary_length","coefficient_length","coefficient_pending","stream_conservation","stream_length","encoded_length","cost_bounds","total_bounds","profile_bounds"]),
    (`FT1536.Source3.KeygenCodecExactLengths,
      ["none_source_length","none_call_length","LengthOutcome","outcome_length","static_source_length","static_call_length","adequate_return","nonzero_return"]),
    (`FT1536.Source3.KeygenCodecStaticSmallLength,
      ["cost_value","LowMagnitude","small_cost","small_total","small_profile"]),
    (`FT1536.Source3.KeygenCodecChainLengths,
      ["chain_lengths","independent_padding_required"]),
    (`FT1536.Source3.KeygenDecodeSyntax,
      ["Ty","typeToken","pointerType","Callee","calleeName","allCallees","callee","arity","Op","operator","precedence","Unary","Expr","argumentTree","word","numeral","unaryToken","expression","unary","suffix","more","arguments","Object","declarators","Assign","Stmt","lvalue","assignOp","clause","endedClause","simple","statement","body","Header","parameters","headerCore","header","parseTokens","expand","tokens","hexadecimal_value"]),
    (`FT1536.Source3.KeygenDecodeGrammar,
      ["guard","initialClause","incrementClause","Test","Statement","Body","Whole"]),
    (`FT1536.Source3.KeygenDecodeNoneBinding,
      ["node000","node000Tokens","node000_source","node001","node001Tokens","node001_source","node002","node002Tokens","node002_source","node003","node003Tokens","node003_source","node004","node004Tokens","node004_source","node005","node005Tokens","node005_source","node006","node006Tokens","node006_source","node007","node007Tokens","node007_source","node008","node008Tokens","node008_source","node009","node009Tokens","node009_source","node010","node010Tokens","node010_source","guard011","guard011Tokens","guard011_source","node011","node011Tokens","node011_source","node012","node012Tokens","node012_source","node013","node013Tokens","node013_source","node014","node014Tokens","node014_source","node015","node015Tokens","node015_source","guard016","guard016Tokens","guard016_source","node016","node016Tokens","node016_source","node017","node017Tokens","node017_source","node018","node018Tokens","node018_source","node019","node019Tokens","node019_source","node020","node020Tokens","node020_source","node021","node021Tokens","node021_source","node022","node022Tokens","node022_source","node023","node023Tokens","node023_source","node024","node024Tokens","node024_source","node025","node025Tokens","node025_source","node026","node026Tokens","node026_source","node027","node027Tokens","node027_source","node028","node028Tokens","node028_source","guard029","guard029Tokens","guard029_source","node029","node029Tokens","node029_source","node030","node030Tokens","node030_source","node031","node031Tokens","node031_source","node032","node032Tokens","node032_source","node033","node033Tokens","node033_source","node034","node034Tokens","node034_source","node035","node035Tokens","node035_source","node036","node036Tokens","node036_source","node037","node037Tokens","node037_source","node038","node038Tokens","node038_source","node039","node039Tokens","node039_source","node040","node040Tokens","node040_source","node041","node041Tokens","node041_source","loop042Init","loop042Update","loop042Test","loop042First","loop042Middle","loop042Last","loop042_initial","loop042_increment","loop042_condition","node042","node042Tokens","node042_source","node043","node043Tokens","node043_source","node044","node044Tokens","node044_source","node045","node045Tokens","node045_source","node046","node046Tokens","node046_source","node047","node047Tokens","node047_source","node048","node048Tokens","node048_source","node049","node049Tokens","node049_source","node050","node050Tokens","node050_source","node051","node051Tokens","node051_source","node052","node052Tokens","node052_source","node053","node053Tokens","node053_source","node054","node054Tokens","node054_source","expectedHeader","signatureTokens","signature_source","code","allTokens","lexical_source","complete_tokens_source","source_bound"]),
    (`FT1536.Source3.KeygenDecodeSource,
      ["sourceSha","noneLines"]),
    (`FT1536.Source3.KeygenDecodeNoneScalar,
      ["high","low","joined","signedWord","adjusted","guardWord","Carrier","join_bytes","sign_mask","sign_extension","signed_roundtrip","adjusted_value","negative_msb","carrier_guard","carrier_subtract","decodePair","pair_roundtrip","outside_carrier_rejected","unrestricted_pair_roundtrip_false"]),
    (`FT1536.Source3.KeygenDecodeNonePairs,
      ["wire","parse","CarrierList","wire_length","segment_roundtrip"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenCodecStaticComplete.source_outcome,
    ``FT1536.Source3.KeygenCodecStaticCall.call_outcome,
    ``FT1536.Source3.KeygenCodecStaticCalls.chain_static,
    ``FT1536.Source3.KeygenCodecNoneReturn.none_return,
    ``FT1536.Source3.KeygenCodecNoneDispatch.dispatch_result,
    ``FT1536.Source3.KeygenCodecNoneDispatch.segments_nonzero,
    ``FT1536.Source3.KeygenCodecStaticComplete.encoded,
    ``FT1536.Source3.KeygenCodecStaticCoefficientHistory.bytes,
    ``FT1536.Source3.KeygenCodecStaticUnaryHistory.bytes,
    ``FT1536.Source3.KeygenCodecStaticIteration.nextPending,
    ``FT1536.Source3.KeygenCodecStaticOuterState.fold,
    ``FT1536.Source3.KeygenCodecStaticReturnHistory.padding]
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
