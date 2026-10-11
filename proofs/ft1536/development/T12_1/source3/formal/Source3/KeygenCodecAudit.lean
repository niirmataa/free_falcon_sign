import Source3.KeygenCodecSyntax
import Source3.KeygenCodecGrammar
import Source3.KeygenCodecSource
import Source3.KeygenCodecDispatchBinding
import Source3.KeygenCodecDispatchBindingPart00
import Source3.KeygenCodecNoneBinding
import Source3.KeygenCodecNoneBindingPart00
import Source3.KeygenCodecNoneBindingPart01
import Source3.KeygenCodecStaticBinding
import Source3.KeygenCodecStaticBindingPart00
import Source3.KeygenCodecStaticBindingPart01
import Source3.KeygenCodecStaticBindingPart02
import Source3.KeygenCodecStaticBindingPart03
import Source3.KeygenCodecStaticBindingPart04
import Source3.KeygenCodecFootprint
import Source3.KeygenCodecSkeSurvival
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated064 full terms for codec binding, projected frames and ske survival.
   Internal audit only; typed value adequacy and exact capacity windows remain open. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenCodecSyntax,
      ["Ty","typeToken","pointerType","Callee","calleeName","allCallees","callee","arity","Op","operator","precedence","Unary","Expr","argumentTree","word","numeral","unaryToken","expression","unary","suffix","more","arguments","Object","declarators","Assign","Stmt","lvalue","assignOp","clause","endedClause","simple","statement","body","Header","parameters","headerCore","header","parseTokens","expand","tokens"]),
    (`FT1536.Source3.KeygenCodecGrammar,
      ["guard","initialClause","incrementClause","Test","Statement","Body","Whole"]),
    (`FT1536.Source3.KeygenCodecSource,
      ["sourceSha","noneLines","staticLines","dispatchLines","macroLines","macro_values"]),
    (`FT1536.Source3.KeygenCodecDispatchBinding,
      ["expectedHeader","signatureTokens","signature_source","code","allTokens","lexical_source","complete_tokens_source","source_bound","switch000Test","switch000TestTokens","switch000Value0","switch000Tokens0","switch000Value1","switch000Tokens1","switch000Value2","switch000Tokens2","node000","node000Tokens","switch000_test","switch000_arm0","switch000_arm1","switch000_arm2","node000_source","node001","node001Tokens","node001_source","node002","node002Tokens","node002_source"]),
    (`FT1536.Source3.KeygenCodecNoneBinding,
      ["expectedHeader","signatureTokens","signature_source","code","allTokens","lexical_source","complete_tokens_source","source_bound","node000","node000Tokens","node000_source","node001","node001Tokens","node001_source","node002","node002Tokens","node002_source","node003","node003Tokens","node003_source","node004","node004Tokens","node004_source","node005","node005Tokens","node005_source","node006","node006Tokens","node006_source","node007","node007Tokens","node007_source","node008","node008Tokens","node008_source","node009","node009Tokens","node009_source","guard010","guard010Tokens","guard010_source","node010","node010Tokens","node010_source","node011","node011Tokens","node011_source","node012","node012Tokens","node012_source","node013","node013Tokens","node013_source","node014","node014Tokens","node014_source","guard015","guard015Tokens","guard015_source","node015","node015Tokens","node015_source","node016","node016Tokens","node016_source","node017","node017Tokens","node017_source","node018","node018Tokens","node018_source","node019","node019Tokens","node019_source","guard020","guard020Tokens","guard020_source","node020","node020Tokens","node020_source","node021","node021Tokens","node021_source","node022","node022Tokens","node022_source","node023","node023Tokens","node023_source","node024","node024Tokens","node024_source","node025","node025Tokens","node025_source","node026","node026Tokens","node026_source","node027","node027Tokens","node027_source","node028","node028Tokens","node028_source","node029","node029Tokens","node029_source","node030","node030Tokens","node030_source","node031","node031Tokens","node031_source","loop032Init","loop032Update","loop032Test","loop032First","loop032Middle","loop032Last","loop032_initial","loop032_increment","loop032_condition","node032","node032Tokens","node032_source","node033","node033Tokens","node033_source","node034","node034Tokens","node034_source","node035","node035Tokens","node035_source","node036","node036Tokens","node036_source","node037","node037Tokens","node037_source","node038","node038Tokens","node038_source","node039","node039Tokens","node039_source","node040","node040Tokens","node040_source","node041","node041Tokens","node041_source","node042","node042Tokens","node042_source"]),
    (`FT1536.Source3.KeygenCodecStaticBinding,
      ["expectedHeader","signatureTokens","signature_source","code","allTokens","lexical_source","complete_tokens_source","source_bound","node000","node000Tokens","node000_source","node001","node001Tokens","node001_source","node002","node002Tokens","node002_source","node003","node003Tokens","node003_source","node004","node004Tokens","node004_source","node005","node005Tokens","node005_source","node006","node006Tokens","node006_source","node007","node007Tokens","node007_source","node008","node008Tokens","node008_source","node009","node009Tokens","node009_source","node010","node010Tokens","node010_source","node011","node011Tokens","node011_source","node012","node012Tokens","node012_source","node013","node013Tokens","node013_source","node014","node014Tokens","node014_source","node015","node015Tokens","node015_source","guard016","guard016Tokens","guard016_source","node016","node016Tokens","node016_source","node017","node017Tokens","node017_source","node018","node018Tokens","node018_source","node019","node019Tokens","node019_source","node020","node020Tokens","node020_source","node021","node021Tokens","node021_source","node022","node022Tokens","node022_source","node023","node023Tokens","node023_source","node024","node024Tokens","node024_source","node025","node025Tokens","node025_source","node026","node026Tokens","node026_source","node027","node027Tokens","node027_source","node028","node028Tokens","node028_source","node029","node029Tokens","node029_source","node030","node030Tokens","node030_source","node031","node031Tokens","node031_source","node032","node032Tokens","node032_source","node033","node033Tokens","node033_source","node034","node034Tokens","node034_source","node035","node035Tokens","node035_source","node036","node036Tokens","node036_source","guard037","guard037Tokens","guard037_source","node037","node037Tokens","node037_source","node038","node038Tokens","node038_source","node039","node039Tokens","node039_source","node040","node040Tokens","node040_source","node041","node041Tokens","node041_source","node042","node042Tokens","node042_source","node043","node043Tokens","node043_source","node044","node044Tokens","node044_source","node045","node045Tokens","node045_source","node046","node046Tokens","node046_source","guard047","guard047Tokens","guard047_source","node047","node047Tokens","node047_source","node048","node048Tokens","node048_source","node049","node049Tokens","node049_source","node050","node050Tokens","node050_source","node051","node051Tokens","node051_source","node052","node052Tokens","node052_source","guard053","guard053Tokens","guard053_source","node053","node053Tokens","node053_source","node054","node054Tokens","node054_source","node055","node055Tokens","node055_source","node056","node056Tokens","node056_source","node057","node057Tokens","node057_source","node058","node058Tokens","node058_source","node059","node059Tokens","node059_source","guard060","guard060Tokens","guard060_source","node060","node060Tokens","node060_source","node061","node061Tokens","node061_source","node062","node062Tokens","node062_source","node063","node063Tokens","node063_source","node064","node064Tokens","node064_source","node065","node065Tokens","node065_source","node066","node066Tokens","node066_source","guard067","guard067Tokens","guard067_source","node067","node067Tokens","node067_source","node068","node068Tokens","node068_source","node069","node069Tokens","node069_source","node070","node070Tokens","node070_source","node071","node071Tokens","node071_source","node072","node072Tokens","node072_source","guard073","guard073Tokens","guard073_source","node073","node073Tokens","node073_source","node074","node074Tokens","node074_source","node075","node075Tokens","node075_source","node076","node076Tokens","node076_source","node077","node077Tokens","node077_source","node078","node078Tokens","node078_source","node079","node079Tokens","node079_source","node080","node080Tokens","node080_source","guard081","guard081Tokens","guard081_source","node081","node081Tokens","node081_source","node082","node082Tokens","node082_source","node083","node083Tokens","node083_source","node084","node084Tokens","node084_source","node085","node085Tokens","node085_source","node086","node086Tokens","node086_source","guard087","guard087Tokens","guard087_source","node087","node087Tokens","node087_source","node088","node088Tokens","node088_source","node089","node089Tokens","node089_source","node090","node090Tokens","node090_source","node091","node091Tokens","node091_source","node092","node092Tokens","node092_source","node093","node093Tokens","node093_source","node094","node094Tokens","node094_source","node095","node095Tokens","node095_source","node096","node096Tokens","node096_source","node097","node097Tokens","node097_source","node098","node098Tokens","node098_source","node099","node099Tokens","node099_source","node100","node100Tokens","node100_source","node101","node101Tokens","node101_source","guard102","guard102Tokens","guard102_source","node102","node102Tokens","node102_source","node103","node103Tokens","node103_source","node104","node104Tokens","node104_source","node105","node105Tokens","node105_source","node106","node106Tokens","node106_source","guard107","guard107Tokens","guard107_source","node107","node107Tokens","node107_source","node108","node108Tokens","node108_source","node109","node109Tokens","node109_source","node110","node110Tokens","node110_source","node111","node111Tokens","node111_source","node112","node112Tokens","node112_source","guard113","guard113Tokens","guard113_source","node113","node113Tokens","node113_source","node114","node114Tokens","node114_source","node115","node115Tokens","node115_source","node116","node116Tokens","node116_source","node117","node117Tokens","node117_source","node118","node118Tokens","node118_source","guard119","guard119Tokens","guard119_source","node119","node119Tokens","node119_source","node120","node120Tokens","node120_source","node121","node121Tokens","node121_source","node122","node122Tokens","node122_source","node123","node123Tokens","node123_source","node124","node124Tokens","node124_source","node125","node125Tokens","node125_source","node126","node126Tokens","node126_source","node127","node127Tokens","node127_source","node128","node128Tokens","node128_source","node129","node129Tokens","node129_source","node130","node130Tokens","node130_source","node131","node131Tokens","node131_source","node132","node132Tokens","node132_source","node133","node133Tokens","node133_source","node134","node134Tokens","node134_source"]),
    (`FT1536.Source3.KeygenCodecFootprint,
      ["Code","readEffect","calleeArgs","project","noneCode","staticCode","dispatchCode","none_complete","static_complete","dispatch_complete","body","State","Flow","Exec","Bound","Frame","frame_refl","frame_trans","exec_frame","Run","run_frame","load64_frame"]),
    (`FT1536.Source3.KeygenCodecSkeSurvival,
      ["destination","BodyRun","separate_of_allocation","word_after_call","Site","nextState","Segments","erase","call_histories","chain_call_histories"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMakeSkeChain.chain,
    ``FT1536.Source3.KeygenMakeSkeChain.chain_words_at_loop,
    ``FT1536.Source3.KeygenMakeSkeCells.SkeCellWord,
    ``FT1536.Source3.KeygenMakeSkeCells.small_site_src_live,
    ``FT1536.Source3.KeygenMakeSkeCells.small_site_material_extended,
    ``FT1536.Source3.KeygenMakeInvocation.SmallSite,
    ``FT1536.Source3.KeygenMakeInvocation.Segments,
    ``FT1536.Source3.KeygenMakeInvocation.StoreByte,
    ``FT1536.Source3.KeygenMakeInvocation.byteOff,
    ``FT1536.Source3.KeygenMakeInvocation.skeElem,
    ``FT1536.Source3.KeygenMakeObjects.Exec,
    ``FT1536.Source3.KeygenMakeObjects.fresh_separate,
    ``FT1536.Source3.C99MemoryReference.Load64,
    ``FT1536.Source3.C99MemoryReference.Allocated]
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
