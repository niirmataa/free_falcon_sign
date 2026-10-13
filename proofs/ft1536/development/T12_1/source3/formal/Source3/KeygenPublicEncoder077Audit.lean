import Source3.KeygenDecodeWrite16
import Source3.KeygenCodecStaticBitInverse
import Source3.KeygenDecodeNoneExactFrame
import Source3.KeygenPublicNormalizePolynomial
import Source3.KeygenInt16Vector076
import Source3.KeygenPublicBits077
import Source3.KeygenPublicDecodeBinding077Part00
import Source3.KeygenPublicDecodeBinding077Part01
import Source3.KeygenPublicDecodeBinding077Part02
import Source3.KeygenPublicDecodeSource077
import Source3.KeygenPublicDecodeBinding077
import Source3.KeygenPublicDecodeExecution077
import Source3.KeygenPublicDecodeAssignments077
import Source3.KeygenPublicDecodeCellFrame077
import Source3.KeygenPublicDecodeCertified077
import Source3.KeygenPublicDecodeCertifiedLoop077
import Source3.KeygenPublicDecodeStateFrame077
import Source3.KeygenPublicDecodeStore077
import Source3.KeygenPublicEncodeValues077
import Source3.KeygenPublicEncodeBinding077Part00
import Source3.KeygenPublicEncodeBinding077Part01
import Source3.KeygenPublicEncodeBinding077Part02
import Source3.KeygenPublicEncodeSource077
import Source3.KeygenPublicEncodeBinding077
import Source3.KeygenPublicEncodeExecution077
import Source3.KeygenPublicEncodeCellFrame077
import Source3.KeygenPublicEncodeStateFrame077
import Source3.KeygenPublicEncodePure077
import Source3.KeygenPublicEncodeDynamic077
import Source3.KeygenPublicEncodeAssignments077
import Source3.KeygenPublicEncodeCertified077
import Source3.KeygenPublicEncodeStore077
import Source3.KeygenPublicInteger077
import Source3.KeygenPublicEncodeReady077
import Source3.KeygenPublicEncodeAppend077
import Source3.KeygenPublicEncodePrepare077
import Source3.KeygenPublicEncodeByteCalc077
import Source3.KeygenPublicEncodeCertifiedLoop077
import Source3.KeygenPublicEncodeEmit077
import Source3.KeygenPublicEncodeDrainStep077
import Source3.KeygenPublicEncodeDrain077
import Source3.KeygenPublicEncodeSequence077
import Source3.KeygenPublicEncodeIteration077
import Source3.KeygenPublicEncodeLoop077
import Source3.KeygenPublicEncodePrologue077
import Source3.KeygenPublicEncodeComplete077
import Source3.KeygenPublicStream077
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Full public encoder/source foundation audit; public decoder and caller assembly remain open. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenPublicBits077,["Canonical","appended","masked","nextPending","drainBytes","drainWord","nextWord","coefficientBytes","bytes","fold","bits","encoded","masked_buffer","drain_size","drain_buffer","coefficient_bits","fold_pending","conservation","source_profile_lengths"]),
    (`FT1536.Source3.KeygenPublicDecodeBinding077,["node000","node000Tokens","node000_source","node001","node001Tokens","node001_source","node002","node002Tokens","node002_source","node003","node003Tokens","node003_source","node004","node004Tokens","node004_source","node005","node005Tokens","node005_source","node006","node006Tokens","node006_source","node007","node007Tokens","node007_source","node008","node008Tokens","node008_source","node009","node009Tokens","node009_source","node010","node010Tokens","node010_source","node011","node011Tokens","node011_source","node012","node012Tokens","node012_source","guard013","guard013Tokens","guard013_source","node013","node013Tokens","node013_source","node014","node014Tokens","node014_source","node015","node015Tokens","node015_source","node016","node016Tokens","node016_source","node017","node017Tokens","node017_source","node018","node018Tokens","node018_source","node019","node019Tokens","node019_source","node020","node020Tokens","node020_source","node021","node021Tokens","node021_source","node022","node022Tokens","node022_source","guard023","guard023Tokens","guard023_source","node023","node023Tokens","node023_source","node024","node024Tokens","node024_source","node025","node025Tokens","node025_source","node026","node026Tokens","node026_source","node027","node027Tokens","node027_source","node028","node028Tokens","node028_source","node029","node029Tokens","node029_source","node030","node030Tokens","node030_source","node031","node031Tokens","node031_source","node032","node032Tokens","node032_source","node033","node033Tokens","node033_source","node034","node034Tokens","node034_source","node035","node035Tokens","node035_source","guard036","guard036Tokens","guard036_source","node036","node036Tokens","node036_source","node037","node037Tokens","node037_source","node038","node038Tokens","node038_source","node039","node039Tokens","node039_source","node040","node040Tokens","node040_source","node041","node041Tokens","node041_source","node042","node042Tokens","node042_source","guard043","guard043Tokens","guard043_source","node043","node043Tokens","node043_source","node044","node044Tokens","node044_source","node045","node045Tokens","node045_source","node046","node046Tokens","node046_source","node047","node047Tokens","node047_source","guard048","guard048Tokens","guard048_source","node048","node048Tokens","node048_source","node049","node049Tokens","node049_source","node050","node050Tokens","node050_source","node051","node051Tokens","node051_source","node052","node052Tokens","node052_source","node053","node053Tokens","node053_source","node054","node054Tokens","node054_source","node055","node055Tokens","node055_source","node056","node056Tokens","node056_source","node057","node057Tokens","node057_source","node058","node058Tokens","node058_source","node059","node059Tokens","node059_source","node060","node060Tokens","node060_source","node061","node061Tokens","node061_source","node062","node062Tokens","node062_source","expectedHeader","signatureTokens","signature_source","code","allTokens","lexical_source","complete_tokens_source","source_bound"]),
    (`FT1536.Source3.KeygenPublicDecodeSource077,["sourceSha","lines"]),
    (`FT1536.Source3.KeygenPublicDecodeExecution077,["Store16","Flow","testExpr","desugar","scopeObjects","scopeExit","Exec","Call"]),
    (`FT1536.Source3.KeygenPublicDecodeAssignments077,["assign_set","assign_exists","compound","compound_exists"]),
    (`FT1536.Source3.KeygenPublicDecodeCellFrame077,["expression","parts","update_frame","eval_frame","objects","declare_frame","statement","exec_frame"]),
    (`FT1536.Source3.KeygenPublicDecodeCertified077,["Checked","skip","breakLoop","declare","bind","assign","compound","evaluate","ret","seq","seq_break","seq_return","scope","branch_true","branch_false"]),
    (`FT1536.Source3.KeygenPublicDecodeCertifiedLoop077,["done","next","break_exit","return_exit","forLoop"]),
    (`FT1536.Source3.KeygenPublicDecodeStateFrame077,["preserves","Same","exec_same","heap_frame","buf_frame"]),
    (`FT1536.Source3.KeygenPublicDecodeStore077,["store"]),
    (`FT1536.Source3.KeygenPublicEncodeValues077,["Name","Args","Value","Locals","State","initialLocals","initial","withLocals","localSet","scalarTy","castInteger","truth","boolean","Load16","UnaryOp","BinaryOp","Update","assignOp","Assigned","declareLocals","hasBuf","declared","Eval"]),
    (`FT1536.Source3.KeygenPublicEncodeBinding077,["node000","node000Tokens","node000_source","node001","node001Tokens","node001_source","node002","node002Tokens","node002_source","node003","node003Tokens","node003_source","node004","node004Tokens","node004_source","node005","node005Tokens","node005_source","node006","node006Tokens","node006_source","node007","node007Tokens","node007_source","node008","node008Tokens","node008_source","node009","node009Tokens","node009_source","node010","node010Tokens","node010_source","node011","node011Tokens","node011_source","node012","node012Tokens","node012_source","node013","node013Tokens","node013_source","node014","node014Tokens","node014_source","node015","node015Tokens","node015_source","node016","node016Tokens","node016_source","guard017","guard017Tokens","guard017_source","node017","node017Tokens","node017_source","node018","node018Tokens","node018_source","node019","node019Tokens","node019_source","node020","node020Tokens","node020_source","node021","node021Tokens","node021_source","node022","node022Tokens","node022_source","guard023","guard023Tokens","guard023_source","node023","node023Tokens","node023_source","node024","node024Tokens","node024_source","node025","node025Tokens","node025_source","node026","node026Tokens","node026_source","node027","node027Tokens","node027_source","node028","node028Tokens","node028_source","node029","node029Tokens","node029_source","node030","node030Tokens","node030_source","node031","node031Tokens","node031_source","guard032","guard032Tokens","guard032_source","node032","node032Tokens","node032_source","node033","node033Tokens","node033_source","node034","node034Tokens","node034_source","node035","node035Tokens","node035_source","node036","node036Tokens","node036_source","node037","node037Tokens","node037_source","node038","node038Tokens","node038_source","guard039","guard039Tokens","guard039_source","node039","node039Tokens","node039_source","node040","node040Tokens","node040_source","node041","node041Tokens","node041_source","node042","node042Tokens","node042_source","node043","node043Tokens","node043_source","guard044","guard044Tokens","guard044_source","node044","node044Tokens","node044_source","node045","node045Tokens","node045_source","node046","node046Tokens","node046_source","node047","node047Tokens","node047_source","node048","node048Tokens","node048_source","node049","node049Tokens","node049_source","guard050","guard050Tokens","guard050_source","node050","node050Tokens","node050_source","node051","node051Tokens","node051_source","node052","node052Tokens","node052_source","node053","node053Tokens","node053_source","node054","node054Tokens","node054_source","node055","node055Tokens","node055_source","guard056","guard056Tokens","guard056_source","node056","node056Tokens","node056_source","node057","node057Tokens","node057_source","node058","node058Tokens","node058_source","node059","node059Tokens","node059_source","node060","node060Tokens","node060_source","node061","node061Tokens","node061_source","node062","node062Tokens","node062_source","node063","node063Tokens","node063_source","node064","node064Tokens","node064_source","node065","node065Tokens","node065_source","node066","node066Tokens","node066_source","node067","node067Tokens","node067_source","node068","node068Tokens","node068_source","node069","node069Tokens","node069_source","node070","node070Tokens","node070_source","expectedHeader","signatureTokens","signature_source","code","allTokens","lexical_source","complete_tokens_source","source_bound"]),
    (`FT1536.Source3.KeygenPublicEncodeSource077,["sourceSha","lines"]),
    (`FT1536.Source3.KeygenPublicEncodeExecution077,["byteOff","StoreByte","Flow","testExpr","desugar","scopeObjects","scopeExit","Exec","Call"]),
    (`FT1536.Source3.KeygenPublicEncodeCellFrame077,["expression","parts","update_frame","eval_frame","objects","declare_frame","statement","exec_frame"]),
    (`FT1536.Source3.KeygenPublicEncodeStateFrame077,["preserves","Same","exec_same","heap_frame","buf_frame"]),
    (`FT1536.Source3.KeygenPublicEncodePure077,["IV","Ordinary","Computes","exists_eval","value_eval"]),
    (`FT1536.Source3.KeygenPublicEncodeDynamic077,["IV","ScalarUpdate","update_exists","update_value","Computes","computes_exists","computes_eval"]),
    (`FT1536.Source3.KeygenPublicEncodeAssignments077,["assign_set","assign_exists","compound","compound_exists"]),
    (`FT1536.Source3.KeygenPublicEncodeCertified077,["Checked","skip","declare","bind","assign","compound","evaluate","ret","seq","seq_return","scope","branch_true","branch_false"]),
    (`FT1536.Source3.KeygenPublicEncodeStore077,["overwrite","exists_store","unique","store"]),
    (`FT1536.Source3.KeygenPublicInteger077,["i32","u64","self_i32","plus_i32","minus_i32","compare_i32","decrement64"]),
    (`FT1536.Source3.KeygenPublicEncodeReady077,["IV","Cell","Context","Ready","Checks","context_frame","set32","set64","setPending","WritableBytes","writable_preserved","empty_scope"]),
    (`FT1536.Source3.KeygenPublicEncodeAppend077,["rhs","after","unsigned_convert","or_input","calculation","source_append"]),
    (`FT1536.Source3.KeygenPublicEncodePrepare077,["code","after","prepare"]),
    (`FT1536.Source3.KeygenPublicEncodeByteCalc077,["drainRhs","maskRhs","drain_calculation","mask_calculation","capacity_calculation","source_mask","source_drain"]),
    (`FT1536.Source3.KeygenPublicEncodeCertifiedLoop077,["done","next","return_exit","forLoop"]),
    (`FT1536.Source3.KeygenPublicEncodeEmit077,["byte","after","emit"]),
    (`FT1536.Source3.KeygenPublicEncodeDrainStep077,["after","step"]),
    (`FT1536.Source3.KeygenPublicEncodeDrain077,["guard","drain"]),
    (`FT1536.Source3.KeygenPublicEncodeSequence077,["chain","append_run","split_run","append_checked"]),
    (`FT1536.Source3.KeygenPublicEncodeIteration077,["iteration"]),
    (`FT1536.Source3.KeygenPublicEncodeLoop077,["guard","input_frame","loop"]),
    (`FT1536.Source3.KeygenPublicEncodePrologue077,["nRhs","pieces","code","partition","freshNU","freshAcc","freshPending","initialized","n_calculation","zero","prologue"]),
    (`FT1536.Source3.KeygenPublicEncodeComplete077,["suffix","encoder_checked","source_outcome","encoder_exists"]),
    (`FT1536.Source3.KeygenPublicStream077,["stream","encoded_bits","canonical_word"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenCodecStaticMaterial.Words,
    ``FT1536.Source3.KeygenDecodeNoneMemory.Trace,
    ``FT1536.Source3.KeygenPublicNormalizePolynomial.Represents,
    ``FT1536.Source3.KeygenInt16Vector076.signedEquiv]
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
