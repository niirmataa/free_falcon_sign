import Source3.ShakeSeedMemory
import Source3.ShakeSeedProgram
import Source3.ShakeSeedReference
import Source3.KeygenEntropySource
import Source3.KeygenRngProgram
import Source3.KeygenRngReference
import Source3.KeygenRngFrame
import Source3.KeygenReadyResult
import Source3.KeygenMakeReady
import Source3.KeygenMakeReadySampling
import Source3.KeygenRngAdequacy
import Source3.KeygenMakePreprocess
import Source3.KeygenPublicAccepted
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated internal048 full-term audit; no loop or independent acceptance. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.ShakeSeedMemory,
      ["Fill","Read8","byte","shifted","decoded","decodeExpr","decodeEntry","declareBuf","assignBuf","Decode","decode_source","xorEntry","declaration","initial","condition","increment","index","XorStep","XorLoop","XorCall","xor_source","fill_frame","pointer_outside","step_slots","step_frame","loop_frame","xor_frame"]),
    (`FT1536.Source3.ShakeSeedProgram,
      ["readName","member","var","num","zero","one","fieldToken","typeToken","unary","expressionAt","expression","Stmt","chain","initRate","complementedZero","initCode","injectIteration","injectCode","flipCode","simple","declarations","parsed","init_source","inject_source","flip_source","signatures_source"]),
    (`FT1536.Source3.ShakeSeedReference,
      ["ReadCall","Eval","Exec","source_frame","entry","initEntry","injectEntry","Init","Inject","Flip","init_frame","inject_frame","flip_frame","init_slots","inject_slots","flip_slots"]),
    (`FT1536.Source3.KeygenEntropySource,
      ["frngSha256","urandomLines","wrapperLines","linuxWrapper","linuxMacros","InputWrite","Event","ReadIO","Compare","ReadLoop","Urandom","Call","write_frame","read_frame","loop_frame","urandom_frame","call_frame","call_value","call_slots"]),
    (`FT1536.Source3.KeygenRngProgram,
      ["Stmt","chain","num","len","replacing","remix","setSeedCode","seedStage","flipStage","readyCode","flagToken","simple","parsed","set_seed_source","ready_source","signatures_source","noEntropy","set_seed_no_entropy"]),
    (`FT1536.Source3.KeygenRngReference,
      ["memberEnv","memberExpr","FlagTest","params","arguments","readyParams","readyArguments","entered","closed","returned","Exec","Call","slots","call_slots"]),
    (`FT1536.Source3.KeygenRngFrame,
      ["Outside","rng_outside","flags_outside","contextOnly","TmpOutside","Safe","safe_first","safe_second","safe_branch","sizes","source_frame","call_frame"]),
    (`FT1536.Source3.KeygenReadyResult,
      ["flagPresent","returnsOnly","returnedFlow","outcomes","normal_only","seed_outcome","flip_normal","normal_split","skip_result","return_tail","ready_flow","ready_success_split","call_value","skipped_flag","flag_test_legal","stored_one","auto_split","normal_form","closed_flag","seed_flag","other_flag","flip_preserves_seed","flip_flags","ready_flags","call_flags"]),
    (`FT1536.Source3.KeygenMakeReady,
      ["block_frame","profile_frame","tmp_frame","initial_frame","returnedZero","Gate","failure_result","gate_normal","Prefix","normal_prefix","literal_prefix_source","normal_prefix_locals"]),
    (`FT1536.Source3.KeygenMakeReadySampling,
      ["FirstSamples","source_same_material"]),
    (`FT1536.Source3.KeygenRngAdequacy,
      ["decodeUnary","decodeAt","parsedDecode","decodedByte","shiftedByte","decoderTree","decoder_source_tree","decoder_lowering","LinuxPreprocess","linux_wrapper_source","linux_urandom_source","actual_rng_offsets","both_tmp_extents","disposal_before_or_after_return"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenCallerEntry.Initial,
    ``FT1536.Source3.KeygenCallerInit.Setup,
    ``FT1536.Source3.KeygenCallerInit.setup_source,
    ``FT1536.Source3.KeygenCallerInit.rtDeclared,
    ``FT1536.Source3.KeygenAttemptCap.limit,
    ``FT1536.Source3.KeygenAttemptCap.source_bound,
    ``FT1536.Source3.KeygenCapWords.Count,
    ``FT1536.Source3.KeygenCapWords.source_increment,
    ``FT1536.Source3.KeygenCapExecution.source_result,
    ``FT1536.Source3.KeygenAttemptMaterial.Entry,
    ``FT1536.Source3.KeygenAttemptMaterial.Material,
    ``FT1536.Source3.KeygenAttemptMaterial.sampled_material,
    ``FT1536.Source3.KeygenSamplerContext.Call,
    ``FT1536.Source3.KeygenSamplerContext.rng,
    ``FT1536.Source3.KeygenSamplerCalls.Call,
    ``FT1536.Source3.KeygenSamplerSource.Exec,
    ``FT1536.Source3.KeygenSearchContext.Context,
    ``FT1536.Source3.KeygenSearchContext.M0,
    ``FT1536.Source3.KeygenSearchContext.ObjectLegal,
    ``FT1536.Source3.KeygenSearchContext.ReadLogn,
    ``FT1536.Source3.KeygenSearchContext.ReadTernary,
    ``FT1536.Source3.KeygenSearchContext.ReadTmp,
    ``FT1536.Source3.KeygenMkgm3Layout.Legal,
    ``FT1536.Source3.KeygenMaterial.Represents,
    ``FT1536.Source3.KeygenIntegerLift.Bound,
    ``FT1536.Source3.KeygenRngSource.Fresh,
    ``FT1536.Source3.C99ProcedureReference.Exec,
    ``FT1536.Source3.C99ProcedureReference.ReturnValue,
    ``FT1536.Source3.KeygenMakePreprocess.make_bound,
    ``FT1536.Source3.KeygenPublicAccepted.source_same_material,
    ``FT1536.Source3.KeygenMakeEntry.Original,
    ``FT1536.Source3.KeygenMakePrologue.AlreadyReadyPrefix,
    ``FT1536.Source3.KeygenMakePrologue.Declarations,
    ``FT1536.Source3.KeygenMakePrologue.count_result,
    ``FT1536.Source3.KeygenMakePrologue.dimensions_result,
    ``FT1536.Source3.KeygenMakePrologue.prefix_tokens_source,
    ``FT1536.Source3.KeygenMakePrologue.ready_count,
    ``FT1536.Source3.KeygenReadyFast.Read,
    ``FT1536.Source3.KeygenReadyFast.NotTest,
    ``FT1536.Source3.KeygenReadyFast.skipped_nonzero,
    ``FT1536.Source3.ShakeExtractFrame.Call,
    ``FT1536.Source3.ShakeExtractSource.Process,
    ``FT1536.Source3.ShakeExtractSource.Layout,
    ``FT1536.Source3.ShakeExtractSource.struct_source,
    ``FT1536.Source3.ShakePointFrame.call,
    ``FT1536.Source3.ShakeEncode.Store8]
  let names := groups.flatMap fun (ns,decls) => decls.toArray.map (Lean.Name.str ns)
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  let mut rows : Array Lean.Json := #[]
  for name in names ++ inherited do
    IO.FS.writeFile "../RNG_AUDIT_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
    IO.FS.withFile "../RNG_AUDIT_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn rows.back!.compress
  IO.FS.writeFile "../RNG_AUDIT.json" (Lean.Json.arr rows |>.pretty)
