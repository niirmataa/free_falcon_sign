import Source3.KeygenMakeObjects
import Source3.KeygenMakeEntry
import Source3.KeygenReadyFast
import Source3.KeygenMakePrologue
import Source3.KeygenMakeSampling
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

/- Generated internal047 full-term audit; no whole-loop or independent acceptance. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenMakeObjects,
      ["name","count","width","extent","pointer","allocated","enter","Block","declarations_source","name_injective","sizes","Exec","block_trans","enter_other","live_frame","slots","outside_name","object","allocated_object","fresh_separate","distinct","dispose","dispose_object","dispose_other"]),
    (`FT1536.Source3.KeygenMakeEntry,
      ["Original","input","publicPointer","input_name","input_width","object_live","scratch_live","outside_fk","allocated_block","load32_block","load16_block","prime_block","rev_block","original_transport","initial"]),
    (`FT1536.Source3.KeygenReadyFast,
      ["Flag","offset","field","Read","complete_body_source","signature_source","caller_source","returnedOne","NotTest","Body","not_test","skipped_nonzero","result","flags","Call","call_result"]),
    (`FT1536.Source3.KeygenMakePrologue,
      ["middle","tailDeclared","a0","a1","a2","a3","a4","a5","a6","declared","projectionStart","b1","b2","b3","b4","b5","b6","prefix_tokens_source","middle_enter","tail_enter","projection_equal","Declarations","allocation_projection","projection_original","initial","countCode","counted","count_declared","count_result","logged","ternary","sized","Dimensions","dimensions_result","ready","ready_count","ready_initial","AlreadyReadyPrefix","prefix_result"]),
    (`FT1536.Source3.KeygenMakeSampling,
      ["prepared","setup_result","prepared_slot","prepared_count","prepared_initial","CappedSetup","cap_before_setup","cap_exhaustion_has_no_setup","no_counter_wrap","firstEntry","first_cap","prepared_rt","prepared_limit","entry_from_prepared","sampler_locals","FirstSamples","first_sampled_material"])]
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
    ``FT1536.Source3.KeygenPublicAccepted.source_same_material]
  let names := groups.flatMap fun (ns,decls) => decls.toArray.map (Lean.Name.str ns)
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  let mut rows : Array Lean.Json := #[]
  for name in names ++ inherited do
    IO.FS.writeFile "../MAKE_ENTRY_AUDIT_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
    IO.FS.withFile "../MAKE_ENTRY_AUDIT_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn rows.back!.compress
  IO.FS.writeFile "../MAKE_ENTRY_AUDIT.json" (Lean.Json.arr rows |>.pretty)
