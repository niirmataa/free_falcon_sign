import Source3.KeygenMakeSyntax
import Source3.KeygenMakeTokens
import Source3.KeygenMakeGrammar
import Source3.KeygenMakeAtomProbe
import Source3.KeygenMakeExpressionProbe
import Source3.KeygenMakeBindingPart00
import Source3.KeygenMakeBindingPart01
import Source3.KeygenMakeBindingPart02
import Source3.KeygenMakeBindingPart03
import Source3.KeygenMakeBindingPart04
import Source3.KeygenMakeBindingPart05
import Source3.KeygenMakeBindingPart06
import Source3.KeygenMakeBindingPart07
import Source3.KeygenMakeBindingPart08
import Source3.KeygenMakeBindingPart09
import Source3.KeygenMakeBindingPart10
import Source3.KeygenMakeBindingPart11
import Source3.KeygenMakeBinding
import Source3.KeygenMakeProgram
import Source3.KeygenMakeLifetime
import Source3.KeygenPublicAccepted
import Source3.KeygenRootCaller
import Source3.KeygenMakeReadySampling
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated internal049 complete terms; no independent review or whole-attempt proof. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenMakeSyntax,
      ["Ty","typeToken","pointerType","Callee","calleeName","allCallees","callee","arity","Op","operator","precedence","Unary","Expr","argumentTree","word","numeral","unaryToken","expression","unary","suffix","more","arguments","Object","declarators","Assign","Stmt","lvalue","clause","endedClause","simple","statement","body","Header","parameters","header","parseTokens","expand","tokens","parse","source","expectedHeader"]),
    (`FT1536.Source3.KeygenMakeTokens,
      ["piece00","piece00_source","piece01","piece01_source","piece02","piece02_source","piece03","piece03_source","piece04","piece04_source","piece05","piece05_source","piece06","piece06_source","piece07","piece07_source","piece08","piece08_source","piece09","piece09_source","piece10","piece10_source","piece11","piece11_source","piece12","piece12_source","all","pieces","all_pieces"]),
    (`FT1536.Source3.KeygenMakeGrammar,
      ["guard","initialClause","incrementClause","Test","Statement","Body","Whole"]),
    (`FT1536.Source3.KeygenMakeAtomProbe,
      ["readyExpr","readyTokens","ready_source","countCode","countTokens","count_source"]),
    (`FT1536.Source3.KeygenMakeExpressionProbe,
      ["long_number","ofEight","sqrtEight","sqrtTokens","nested_sqrt","longProduct","productTokens","long_product","boundExpr","boundTokens","complete_bound"]),
    (`FT1536.Source3.KeygenMakeBinding,
      ["node000","node000Tokens","node000_source","node001","node001Tokens","node001_source","node002","node002Tokens","node002_source","node003","node003Tokens","node003_source","node004","node004Tokens","node004_source","node005","node005Tokens","node005_source","node006","node006Tokens","node006_source","node007","node007Tokens","node007_source","node008","node008Tokens","node008_source","node009","node009Tokens","node009_source","node010","node010Tokens","node010_source","node011","node011Tokens","node011_source","node012","node012Tokens","node012_source","node013","node013Tokens","node013_source","node014","node014Tokens","node014_source","node015","node015Tokens","node015_source","node016","node016Tokens","node016_source","guard017","guard017Tokens","guard017_source","node017","node017Tokens","node017_source","node018","node018Tokens","node018_source","node019","node019Tokens","node019_source","node020","node020Tokens","node020_source","node021","node021Tokens","node021_source","node022","node022Tokens","node022_source","guard023","guard023Tokens","guard023_source","node023","node023Tokens","node023_source","node024","node024Tokens","node024_source","node025","node025Tokens","node025_source","node026","node026Tokens","node026_source","node027","node027Tokens","node027_source","node028","node028Tokens","node028_source","node029","node029Tokens","node029_source","node030","node030Tokens","node030_source","node031","node031Tokens","node031_source","node032","node032Tokens","node032_source","node033","node033Tokens","node033_source","node034","node034Tokens","node034_source","guard035","guard035Tokens","guard035_source","node035","node035Tokens","node035_source","node036","node036Tokens","node036_source","node037","node037Tokens","node037_source","node038","node038Tokens","node038_source","node039","node039Tokens","node039_source","guard040","guard040Tokens","guard040_source","node040","node040Tokens","node040_source","node041","node041Tokens","node041_source","node042","node042Tokens","node042_source","node043","node043Tokens","node043_source","node044","node044Tokens","node044_source","node045","node045Tokens","node045_source","node046","node046Tokens","node046_source","node047","node047Tokens","node047_source","node048","node048Tokens","node048_source","node049","node049Tokens","node049_source","node050","node050Tokens","node050_source","node051","node051Tokens","node051_source","node052","node052Tokens","node052_source","node053","node053Tokens","node053_source","loop054Init","loop054Update","loop054Test","loop054First","loop054Middle","loop054Last","loop054_initial","loop054_increment","loop054_condition","node054","node054Tokens","node054_source","node055","node055Tokens","node055_source","node056","node056Tokens","node056_source","node057","node057Tokens","node057_source","node058","node058Tokens","node058_source","node059","node059Tokens","node059_source","guard060","guard060Tokens","guard060_source","node060","node060Tokens","node060_source","node061","node061Tokens","node061_source","node062","node062Tokens","node062_source","node063","node063Tokens","node063_source","node064","node064Tokens","node064_source","node065","node065Tokens","node065_source","node066","node066Tokens","node066_source","node067","node067Tokens","node067_source","node068","node068Tokens","node068_source","node069","node069Tokens","node069_source","node070","node070Tokens","node070_source","node071","node071Tokens","node071_source","node072","node072Tokens","node072_source","node073","node073Tokens","node073_source","node074","node074Tokens","node074_source","loop075Init","loop075Update","loop075Test","loop075First","loop075Middle","loop075Last","loop075_initial","loop075_increment","loop075_condition","node075","node075Tokens","node075_source","node076","node076Tokens","node076_source","node077","node077Tokens","node077_source","node078","node078Tokens","node078_source","node079","node079Tokens","node079_source","node080","node080Tokens","node080_source","guard081","guard081Tokens","guard081_source","node081","node081Tokens","node081_source","node082","node082Tokens","node082_source","node083","node083Tokens","node083_source","node084","node084Tokens","node084_source","node085","node085Tokens","node085_source","node086","node086Tokens","node086_source","node087","node087Tokens","node087_source","node088","node088Tokens","node088_source","node089","node089Tokens","node089_source","node090","node090Tokens","node090_source","node091","node091Tokens","node091_source","node092","node092Tokens","node092_source","node093","node093Tokens","node093_source","node094","node094Tokens","node094_source","node095","node095Tokens","node095_source","node096","node096Tokens","node096_source","node097","node097Tokens","node097_source","node098","node098Tokens","node098_source","node099","node099Tokens","node099_source","node100","node100Tokens","node100_source","node101","node101Tokens","node101_source","node102","node102Tokens","node102_source","node103","node103Tokens","node103_source","node104","node104Tokens","node104_source","node105","node105Tokens","node105_source","node106","node106Tokens","node106_source","node107","node107Tokens","node107_source","node108","node108Tokens","node108_source","node109","node109Tokens","node109_source","node110","node110Tokens","node110_source","node111","node111Tokens","node111_source","node112","node112Tokens","node112_source","node113","node113Tokens","node113_source","node114","node114Tokens","node114_source","node115","node115Tokens","node115_source","node116","node116Tokens","node116_source","node117","node117Tokens","node117_source","node118","node118Tokens","node118_source","node119","node119Tokens","node119_source","node120","node120Tokens","node120_source","node121","node121Tokens","node121_source","node122","node122Tokens","node122_source","node123","node123Tokens","node123_source","node124","node124Tokens","node124_source","node125","node125Tokens","node125_source","node126","node126Tokens","node126_source","node127","node127Tokens","node127_source","guard128","guard128Tokens","guard128_source","node128","node128Tokens","node128_source","node129","node129Tokens","node129_source","node130","node130Tokens","node130_source","node131","node131Tokens","node131_source","node132","node132Tokens","node132_source","node133","node133Tokens","node133_source","node134","node134Tokens","node134_source","node135","node135Tokens","node135_source","node136","node136Tokens","node136_source","node137","node137Tokens","node137_source","node138","node138Tokens","node138_source","node139","node139Tokens","node139_source","node140","node140Tokens","node140_source","node141","node141Tokens","node141_source","node142","node142Tokens","node142_source","node143","node143Tokens","node143_source","node144","node144Tokens","node144_source","node145","node145Tokens","node145_source","node146","node146Tokens","node146_source","node147","node147Tokens","node147_source","node148","node148Tokens","node148_source","node149","node149Tokens","node149_source","node150","node150Tokens","node150_source","node151","node151Tokens","node151_source","loop152Init","loop152Update","loop152Test","loop152First","loop152Middle","loop152Last","loop152_initial","loop152_increment","loop152_condition","node152","node152Tokens","node152_source","node153","node153Tokens","node153_source","node154","node154Tokens","node154_source","node155","node155Tokens","node155_source","node156","node156Tokens","node156_source","guard157","guard157Tokens","guard157_source","node157","node157Tokens","node157_source","node158","node158Tokens","node158_source","node159","node159Tokens","node159_source","node160","node160Tokens","node160_source","node161","node161Tokens","node161_source","node162","node162Tokens","node162_source","node163","node163Tokens","node163_source","node164","node164Tokens","node164_source","node165","node165Tokens","node165_source","node166","node166Tokens","node166_source","node167","node167Tokens","node167_source","node168","node168Tokens","node168_source","node169","node169Tokens","node169_source","node170","node170Tokens","node170_source","node171","node171Tokens","node171_source","node172","node172Tokens","node172_source","node173","node173Tokens","node173_source","node174","node174Tokens","node174_source","node175","node175Tokens","node175_source","node176","node176Tokens","node176_source","node177","node177Tokens","node177_source","node178","node178Tokens","node178_source","node179","node179Tokens","node179_source","node180","node180Tokens","node180_source","node181","node181Tokens","node181_source","node182","node182Tokens","node182_source","node183","node183Tokens","node183_source","node184","node184Tokens","node184_source","node185","node185Tokens","node185_source","node186","node186Tokens","node186_source","node187","node187Tokens","node187_source","guard188","guard188Tokens","guard188_source","node188","node188Tokens","node188_source","node189","node189Tokens","node189_source","node190","node190Tokens","node190_source","node191","node191Tokens","node191_source","node192","node192Tokens","node192_source","guard193","guard193Tokens","guard193_source","node193","node193Tokens","node193_source","node194","node194Tokens","node194_source","node195","node195Tokens","node195_source","node196","node196Tokens","node196_source","node197","node197Tokens","node197_source","guard198","guard198Tokens","guard198_source","node198","node198Tokens","node198_source","node199","node199Tokens","node199_source","node200","node200Tokens","node200_source","node201","node201Tokens","node201_source","node202","node202Tokens","node202_source","guard203","guard203Tokens","guard203_source","node203","node203Tokens","node203_source","node204","node204Tokens","node204_source","node205","node205Tokens","node205_source","node206","node206Tokens","node206_source","guard207","guard207Tokens","guard207_source","node207","node207Tokens","node207_source","node208","node208Tokens","node208_source","node209","node209Tokens","node209_source","node210","node210Tokens","node210_source","node211","node211Tokens","node211_source","node212","node212Tokens","node212_source","node213","node213Tokens","node213_source","node214","node214Tokens","node214_source","node215","node215Tokens","node215_source","loop216Init","loop216Update","loop216Test","loop216First","loop216Middle","loop216Last","loop216_initial","loop216_increment","loop216_condition","node216","node216Tokens","node216_source","node217","node217Tokens","node217_source","node218","node218Tokens","node218_source","node219","node219Tokens","node219_source","node220","node220Tokens","node220_source","node221","node221Tokens","node221_source","node222","node222Tokens","node222_source","guard223","guard223Tokens","guard223_source","node223","node223Tokens","node223_source","node224","node224Tokens","node224_source","node225","node225Tokens","node225_source","node226","node226Tokens","node226_source","node227","node227Tokens","node227_source","node228","node228Tokens","node228_source","node229","node229Tokens","node229_source","node230","node230Tokens","node230_source","node231","node231Tokens","node231_source","node232","node232Tokens","node232_source","node233","node233Tokens","node233_source","node234","node234Tokens","node234_source","node235","node235Tokens","node235_source","guard236","guard236Tokens","guard236_source","node236","node236Tokens","node236_source","node237","node237Tokens","node237_source","node238","node238Tokens","node238_source","node239","node239Tokens","node239_source","node240","node240Tokens","node240_source","node241","node241Tokens","node241_source","node242","node242Tokens","node242_source","node243","node243Tokens","node243_source","loop244Init","loop244Update","loop244Test","loop244First","loop244Middle","loop244Last","loop244_initial","loop244_increment","loop244_condition","node244","node244Tokens","node244_source","node245","node245Tokens","node245_source","node246","node246Tokens","node246_source","node247","node247Tokens","node247_source","node248","node248Tokens","node248_source","node249","node249Tokens","node249_source","node250","node250Tokens","node250_source","guard251","guard251Tokens","guard251_source","node251","node251Tokens","node251_source","node252","node252Tokens","node252_source","node253","node253Tokens","node253_source","node254","node254Tokens","node254_source","node255","node255Tokens","node255_source","node256","node256Tokens","node256_source","node257","node257Tokens","node257_source","node258","node258Tokens","node258_source","node259","node259Tokens","node259_source","node260","node260Tokens","node260_source","guard261","guard261Tokens","guard261_source","node261","node261Tokens","node261_source","node262","node262Tokens","node262_source","node263","node263Tokens","node263_source","node264","node264Tokens","node264_source","node265","node265Tokens","node265_source","guard266","guard266Tokens","guard266_source","node266","node266Tokens","node266_source","node267","node267Tokens","node267_source","node268","node268Tokens","node268_source","node269","node269Tokens","node269_source","node270","node270Tokens","node270_source","node271","node271Tokens","node271_source","node272","node272Tokens","node272_source","node273","node273Tokens","node273_source","node274","node274Tokens","node274_source","node275","node275Tokens","node275_source","node276","node276Tokens","node276_source","node277","node277Tokens","node277_source","node278","node278Tokens","node278_source","node279","node279Tokens","node279_source","node280","node280Tokens","node280_source","node281","node281Tokens","node281_source","node282","node282Tokens","node282_source","node283","node283Tokens","node283_source","node284","node284Tokens","node284_source","node285","node285Tokens","node285_source","node286","node286Tokens","node286_source","node287","node287Tokens","node287_source","node288","node288Tokens","node288_source","node289","node289Tokens","node289_source","node290","node290Tokens","node290_source","node291","node291Tokens","node291_source","node292","node292Tokens","node292_source","node293","node293Tokens","node293_source","node294","node294Tokens","node294_source","node295","node295Tokens","node295_source","node296","node296Tokens","node296_source","node297","node297Tokens","node297_source","node298","node298Tokens","node298_source","node299","node299Tokens","node299_source","node300","node300Tokens","node300_source","node301","node301Tokens","node301_source","node302","node302Tokens","node302_source","signatureTokens","signature_source","code","completeTokens","complete_tokens_source","source_bound"]),
    (`FT1536.Source3.KeygenMakeProgram,
      ["code","source_bound","statements","outer","get","attempt","attemptParts","ternary","binary","ternaryParts","encoding","number","varExpr","called","continuing","failCall","publicArgs","solveArgs","certificateArgs","profileTest","certificateGate","expectedTail","attemptedLoop","outer_shape","dispatch_shape","actual_attempt_tail","actual_ternary_length","actual_encoder_tail_length","declared","automaticObjects","expectedObjects","objectWidth","extent","automatic_objects_source","automatic_extents","expectedCounter","expectedLogn","expectedTer","expectedN","readyGate","prefix_assignment_source","capIncrement","capTest","capReturn","cap_source","sampled","sampling_source","resultant","resultants_source","normGate","both_norm_gates_source","secretCall","secretIteration","secretLoop","actual_four_segment_loop","publicCall","publicDispatch","actual_public_dispatch","capacityTest","capacityReturn","post_acceptance_capacity_tests","final_return_source","foreign_call_rejected","wrong_ready_arity_rejected","trailing_tokens_rejected","unsupported_statement_rejected","signedLongExpr","expectedSignedLong","signed_long_retained"]),
    (`FT1536.Source3.KeygenMakeLifetime,
      ["isPointer","isObject","declarations","scalarNames","pointerNames","scalars","pointers","outer_names_source","scope_source","close","close_flow","close_object","close_outside","close_local","close_pointer","original_empty","prefix_empty","closed_empty","dead_read16","dead_read64","failed_prefix_result","ReadinessFailure","readiness_failure"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMakePreprocess.source_partition,
    ``FT1536.Source3.KeygenMakePreprocess.make_bound,
    ``FT1536.Source3.KeygenMakeObjects.Exec,
    ``FT1536.Source3.KeygenMakeObjects.dispose_object,
    ``FT1536.Source3.KeygenMakeObjects.dispose_other,
    ``FT1536.Source3.KeygenMakePrologue.Declarations,
    ``FT1536.Source3.KeygenMakePrologue.allocation_projection,
    ``FT1536.Source3.KeygenMakePrologue.count_result,
    ``FT1536.Source3.KeygenMakePrologue.dimensions_result,
    ``FT1536.Source3.KeygenMakeReady.Prefix,
    ``FT1536.Source3.KeygenMakeReady.Gate,
    ``FT1536.Source3.KeygenMakeReady.normal_prefix,
    ``FT1536.Source3.KeygenMakeReady.failure_result,
    ``FT1536.Source3.KeygenMakeReady.normal_prefix_locals,
    ``FT1536.Source3.KeygenMakeEntry.Original,
    ``FT1536.Source3.KeygenCapWords.Count,
    ``FT1536.Source3.KeygenMakeSampling.CappedSetup,
    ``FT1536.Source3.KeygenMakeSampling.cap_before_setup,
    ``FT1536.Source3.KeygenMakeSampling.no_counter_wrap,
    ``FT1536.Source3.KeygenMakeReadySampling.FirstSamples,
    ``FT1536.Source3.KeygenMakeReadySampling.source_same_material,
    ``FT1536.Source3.KeygenRngReference.Call,
    ``FT1536.Source3.KeygenRngReference.call_slots,
    ``FT1536.Source3.KeygenReadyResult.call_flags,
    ``FT1536.Source3.C99ArrayReference.restoreScope,
    ``FT1536.Source3.C99MemoryReference.Load64,
    ``FT1536.Source3.C99NarrowReads.Load16,
    ``FT1536.Source3.KeygenPublicAccepted.source_same_material,
    ``FT1536.Source3.KeygenRootCaller.Legal,
    ``FT1536.Source3.KeygenRootCaller.success,
    ``FT1536.Source3.CertificateFunctionReference.Arguments,
    ``FT1536.Source3.CertificateFunctionReference.Environment,
    ``FT1536.Source3.CertificateFunctionReference.Profile,
    ``FT1536.Source3.CertificateFunctionReference.Exec,
    ``FT1536.Source3.CertificateFunctionReference.initial,
    ``FT1536.Source3.CertificateFunctionReference.resolveLayout,
    ``FT1536.Source3.CertificateFunctionReference.bad_dead_after_return,
    ``FT1536.Source3.CertificateM0Environment.Pinned,
    ``FT1536.Source3.CertificateM0Environment.Exec,
    ``FT1536.Source3.CertificateM0Environment.stored_words,
    ``FT1536.Source3.CertificateFunctionOutcome.accepted]
  let names := groups.flatMap fun (ns,decls) => decls.toArray.map (Lean.Name.str ns)
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  let mut rows : Array Lean.Json := #[]
  for name in names ++ inherited do
    IO.FS.writeFile "../MAKE_AUDIT_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
    IO.FS.withFile "../MAKE_AUDIT_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn rows.back!.compress
  IO.FS.writeFile "../MAKE_AUDIT.json" (Lean.Json.arr rows |>.pretty)
