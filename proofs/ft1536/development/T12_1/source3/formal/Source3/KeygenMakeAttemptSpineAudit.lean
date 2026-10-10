import Source3.KeygenMakeAttemptSpine
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated056 internal full terms. One accepted attempt carries the
   whole six-gate spine on ONE AttemptExec derivation with allocation-derived
   entry facts, landing the ONE material at the encoding-tail input boundary.
   Not a review and not a codec or law claim. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenMakeAttemptSpine,
      ["close_heap","close_tables","close_locals","dimensions_locals","legal_same_size","live_tables_same","protected_same","tables_same","public_slots_state","public_gate_call","names_zero","names_one","prepared_array","root_legal_prepared","context_norm_prepared","context_public_prepared","EntryFacts","Spine","accepted_spine","spine_witness","attempt_spine","entry_of_allocation"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMakeMaterialWitness.Witness,
    ``FT1536.Source3.KeygenMakeMaterialWitness.EncodingInputs,
    ``FT1536.Source3.KeygenMakeMaterialWitness.public_material_equations,
    ``FT1536.Source3.KeygenMakeMaterialWitness.witness_at_solver,
    ``FT1536.Source3.KeygenMakeMaterialWitness.attempt_witness,
    ``FT1536.Source3.KeygenMakeCertMaterial.LegalWorkspace,
    ``FT1536.Source3.KeygenMakeCertChronology.AttemptExec,
    ``FT1536.Source3.KeygenMakeCertCall.Call,
    ``FT1536.Source3.KeygenMakeCertCall.CertificateGate,
    ``FT1536.Source3.KeygenMakeCertCall.profile_of_dimensions,
    ``FT1536.Source3.KeygenMakeCertCall.accepted_break_requires_call,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Dimensions,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Remaining,
    ``FT1536.Source3.KeygenMakeSearchPrefix.close_local,
    ``FT1536.Source3.KeygenMakeSearchPrefix.dimensions_advanced,
    ``FT1536.Source3.KeygenMakeSearchPrefix.sampled_remaining,
    ``FT1536.Source3.KeygenMakeSampling.CappedSetup,
    ``FT1536.Source3.KeygenMakeSampling.prepared,
    ``FT1536.Source3.KeygenMakeSampling.prepared_slot,
    ``FT1536.Source3.KeygenMakeSampling.prepared_rt,
    ``FT1536.Source3.KeygenMakeSampling.cap_before_setup,
    ``FT1536.Source3.KeygenMakeSampling.entry_from_prepared,
    ``FT1536.Source3.KeygenCallerPrefix.close,
    ``FT1536.Source3.KeygenCallerPrefix.close_root,
    ``FT1536.Source3.KeygenCallerPrefix.close_array,
    ``FT1536.Source3.KeygenCallerPrefix.Ternary,
    ``FT1536.Source3.KeygenCallerPrefix.ternary_material,
    ``FT1536.Source3.KeygenCallerPrefix.ternary_slots,
    ``FT1536.Source3.KeygenCallerPrefix.ternary_size,
    ``FT1536.Source3.KeygenCallerPrefix.ternary_root,
    ``FT1536.Source3.KeygenCallerEntry.Initial,
    ``FT1536.Source3.KeygenCallerEntry.input_not_rt,
    ``FT1536.Source3.KeygenCallerTransport.public_root,
    ``FT1536.Source3.KeygenCallerSuccess.nonzero_one,
    ``FT1536.Source3.KeygenAttemptMaterial.Entry,
    ``FT1536.Source3.KeygenAttemptMaterial.Material,
    ``FT1536.Source3.KeygenAttemptSlots.Slots,
    ``FT1536.Source3.KeygenAttemptNorm.Protected,
    ``FT1536.Source3.KeygenAttemptNorm.Exec,
    ``FT1536.Source3.KeygenResultantGate.Exec,
    ``FT1536.Source3.KeygenSamplerContext.Call,
    ``FT1536.Source3.KeygenPublicSource.Call,
    ``FT1536.Source3.KeygenRootSource.Call,
    ``FT1536.Source3.KeygenRootSource.slots,
    ``FT1536.Source3.KeygenRootCaller.Legal,
    ``FT1536.Source3.KeygenRootSearch.Protected,
    ``FT1536.Source3.KeygenPublicInputMaterial.Legal,
    ``FT1536.Source3.KeygenPublicInputLifetime.LiveTables,
    ``FT1536.Source3.KeygenPublicFrame.Tables,
    ``FT1536.Source3.KeygenPublicFrame.Outside,
    ``FT1536.Source3.KeygenMakeLocalFrame.fixed,
    ``FT1536.Source3.KeygenMakeLocalFrame.ternary,
    ``FT1536.Source3.KeygenMakeEntry.Original,
    ``FT1536.Source3.KeygenMakeEntry.input,
    ``FT1536.Source3.KeygenMakeEntry.publicPointer,
    ``FT1536.Source3.KeygenMakeReady.Prefix,
    ``FT1536.Source3.KeygenMakeReady.normal_prefix,
    ``FT1536.Source3.KeygenMakeSearchTrace.prefix_remaining,
    ``FT1536.Source3.KeygenCapWords.advanced,
    ``FT1536.Source3.KeygenCapWords.Count,
    ``FT1536.Source3.C99CountedWords.Limit,
    ``FT1536.Source3.C99ScalarReference.set,
    ``FT1536.Source3.C99MemoryReference.Memory,
    ``FT1536.Source3.C99MemoryReference.ArrayPointer,
    ``FT1536.Source3.C99MemoryReference.Allocated,
    ``FT1536.Source3.KeygenResidueTrace.names,
    ``FT1536.Source3.KeygenSearchContext.Context,
    ``FT1536.Source3.KeygenEntropySource.Event,
    ``FT1536.Source3.C99ProcedureReference.Result,
    ``FT1536.Source3.C99ProcedureReference.Flow,
    ``FT1536.Source3.C99IntegerReference.Value]
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
