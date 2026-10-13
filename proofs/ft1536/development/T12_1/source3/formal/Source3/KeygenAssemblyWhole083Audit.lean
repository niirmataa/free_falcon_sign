import Source3.KeygenAcceptedMaterial079
import Source3.KeygenAcceptedLoop079
import Source3.KeygenSerializationEntry079
import Source3.KeygenAttemptSerialization079
import Source3.KeygenCertificateReadonly080
import Source3.KeygenCertificateReachable080
import Source3.KeygenCertificateAt080
import Source3.KeygenAcceptedLoop080
import Source3.KeygenAttemptSerialization080
import Source3.KeygenPrecertificate080
import Source3.KeygenAttemptAt080
import Source3.KeygenRetryAt080
import Source3.KeygenLoopAt080
import Source3.KeygenCertificateOccurrence080
import Source3.KeygenLoopMaterial080
import Source3.KeygenEntryAt080
import Source3.KeygenTailCellsAt080
import Source3.KeygenSameCertificate080
import Source3.KeygenMakeAssembly080
import Source3.KeygenCertificateSource080
import Source3.KeygenPinnedInvocation080
import Source3.KeygenSecretBits081
import Source3.KeygenSecretSegment081
import Source3.KeygenSecretPacket081
import Source3.KeygenSecretChain081
import Source3.KeygenSecretPrelude081
import Source3.KeygenSecretObserved081
import Source3.KeygenSecretCallerTrace081
import Source3.KeygenPublicForeign081
import Source3.KeygenPublicSuffixFrame081
import Source3.KeygenSecretTailSource081
import Source3.KeygenSecretLocal081
import Source3.KeygenSecretTailBinding081
import Source3.KeygenSecretInvocation081
import Source3.KeygenOutputMemory081
import Source3.KeygenSecretComplete081
import Source3.KeygenSecretDecodeSource081
import Source3.KeygenExternalSampling082
import Source3.KeygenExternalGates082
import Source3.KeygenExternalLoop082
import Source3.KeygenPublicEntry082
import Source3.KeygenPublicPrivateBridge082
import Source3.KeygenPublicComplete082
import Source3.KeygenEmittedFiber083
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Coherent full audit of all new assembly079-083 declarations and exact inherited boundaries. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenAcceptedMaterial079,["attempt_material"]),
    (`FT1536.Source3.KeygenAcceptedLoop079,["sampled_tables","attempt_tables","facts_after","loop_material","final_state"]),
    (`FT1536.Source3.KeygenSerializationEntry079,["head_frame","prefix_frame","prefix_material","prefix_legal"]),
    (`FT1536.Source3.KeygenAttemptSerialization079,["CallsCarry","accepted_loop_to_calls"]),
    (`FT1536.Source3.KeygenCertificateReadonly080,["prefix_stable","source_readonly","call_same_block"]),
    (`FT1536.Source3.KeygenCertificateReachable080,["call_frame","gate_entry","attempt_entry"]),
    (`FT1536.Source3.KeygenCertificateAt080,["workspace","call_frame","entry_frame","space_preserved"]),
    (`FT1536.Source3.KeygenAcceptedLoop080,["facts_after","loop_material"]),
    (`FT1536.Source3.KeygenAttemptSerialization080,["accepted_loop_to_calls"]),
    (`FT1536.Source3.KeygenPrecertificate080,["Entry","source_material"]),
    (`FT1536.Source3.KeygenAttemptAt080,["sampled_material","Exec","accepted_material"]),
    (`FT1536.Source3.KeygenRetryAt080,["gate_call","gate_entry","attempt_remaining","attempt_entry","facts_after"]),
    (`FT1536.Source3.KeygenLoopAt080,["AttemptExecution","AttemptAccepted","AttemptRejected","Aborted","Numbered","LoopTrace","LoopExecution","LoopSucceeded","attemptCap","actual_attempt_cap","BoundFacts","source_bounds","loop_bounds","successful_loop_last_attempt","loop_bounds_success"]),
    (`FT1536.Source3.KeygenLoopAt080.AttemptExecution,["exit"]),
    (`FT1536.Source3.KeygenLoopAt080.LoopExecution,["exit"]),
    (`FT1536.Source3.KeygenCertificateOccurrence080,["CanonicalOccurrence","canonical","Package","from_call"]),
    (`FT1536.Source3.KeygenLoopMaterial080,["material","AttemptCertificate","attempt_certificate","final_certificate"]),
    (`FT1536.Source3.KeygenEntryAt080,["entry_facts","scratch_size"]),
    (`FT1536.Source3.KeygenTailCellsAt080,["attempt_arrays","attempt_comp","attempt_cells","loop_cells"]),
    (`FT1536.Source3.KeygenSameCertificate080,["Joined","material","attempt_joined","loop_joined"]),
    (`FT1536.Source3.KeygenMakeAssembly080,["LegalEntry","Invocation","Frontier","successful_frontier","callId","call_id_bound","automatic_objects_dead","no_dead_material_read"]),
    (`FT1536.Source3.KeygenCertificateSource080,["Call","call_projection","Gate","gate_projection","Attempt","attempt_projection","AttemptExecution","projected","Loop","loop_projection"]),
    (`FT1536.Source3.KeygenPinnedInvocation080,["PinnedExec","projection","successful_frontier"]),
    (`FT1536.Source3.KeygenSecretBits081,["word","many","word_honest","many_honest","stream_length"]),
    (`FT1536.Source3.KeygenSecretSegment081,["usedBits","usedBytes","paddingBits","segment","remaining","parsed","used_bits","used_bytes","bit_count","padding","segment_honest"]),
    (`FT1536.Source3.KeygenSecretPacket081,["Material","decodeVector","DecodeSecret","payload","packet","decode_vector","segment_wordlist","segment_last","decode_honest","packet_length"]),
    (`FT1536.Source3.KeygenSecretChain081,["bytes","bytes_step","bytes_done","bytes_zero","Cursor","CallBytes","next_cursor","source_trace","length_bound"]),
    (`FT1536.Source3.KeygenSecretPrelude081,["skeStores","header_value","header","ske_head","ske_frame","prelude"]),
    (`FT1536.Source3.KeygenSecretObserved081,["ObservedSecret","packet_observed","byte_block","length_block","preserved","unique"]),
    (`FT1536.Source3.KeygenSecretCallerTrace081,["privateCode","source_parts","split_success","split_normal","next_normal","no_public_calls","legacy","length_store","trace"]),
    (`FT1536.Source3.KeygenPublicForeign081,["BufferOutside","same_trans","execution","call","site"]),
    (`FT1536.Source3.KeygenPublicSuffixFrame081,["head_frame","encoding_frame"]),
    (`FT1536.Source3.KeygenSecretTailSource081,["Source","Addresses","from_encoding"]),
    (`FT1536.Source3.KeygenSecretLocal081,["Separation","packet","Laws","trace_foreign","private_output","through_public"]),
    (`FT1536.Source3.KeygenSecretTailBinding081,["prelude_head","prelude_encoding","append","to_encoding"]),
    (`FT1536.Source3.KeygenSecretInvocation081,["PinnedExec","projection","Frontier","successful_frontier"]),
    (`FT1536.Source3.KeygenOutputMemory081,["Legal","bound_heap","external","internal","separation","material_legal","after_return"]),
    (`FT1536.Source3.KeygenSecretComplete081,["SameCertificate","same_symm","certificate_material","Output","observed_secret","actual_observed_decode","length_bounds"]),
    (`FT1536.Source3.KeygenSecretDecodeSource081,["observed_slice","packet_split","args","source_decoder_at_return"]),
    (`FT1536.Source3.KeygenExternalSampling082,["Outside","moved","prepared","norm_prepared","sampler","two_samplers","resultants","ternary"]),
    (`FT1536.Source3.KeygenExternalGates082,["public_call","after_ternary","gates","sampled"]),
    (`FT1536.Source3.KeygenExternalLoop082,["attempt","loop"]),
    (`FT1536.Source3.KeygenPublicEntry082,["Legal","ready_parts","ready_block","ready_metadata","ready_tables","writable_block","at_loop_output"]),
    (`FT1536.Source3.KeygenPublicPrivateBridge082,["site_frame","segments_frame","private_frame","public_entry"]),
    (`FT1536.Source3.KeygenPublicComplete082,["Output","public_after_return","observed_pair","actual_observed_pair"]),
    (`FT1536.Source3.KeygenEmittedFiber083,["f","g","bigF","bigG","h","fInv","FiberFacts","from_output","emitted_to_actual_fiber","actual_observed_fiber"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMakeProgram.source_bound,
    ``FT1536.Source3.KeygenCodecStaticBinding.source_bound,
    ``FT1536.Source3.KeygenDecodeStaticBinding.source_bound,
    ``FT1536.Source3.KeygenPublicEncodeBinding077.source_bound,
    ``FT1536.Source3.KeygenPublicDecodeBinding077.source_bound,
    ``FT1536.Source3.KeygenMakeEntry.Original,
    ``FT1536.Source3.KeygenMakeInvocation.VirtualLegal,
    ``FT1536.Source3.KeygenMakeMaterialWitness.Witness,
    ``FT1536.Source3.KeygenInt16Caller076.chain_transport,
    ``FT1536.Source3.KeygenDecodeStaticComplete.source_outcome,
    ``FT1536.Source3.KeygenPublicCallerComplete077.observed_output,
    ``FT1536.Source3.FftGlobalMemory.environment,
    ``FT1536.Source3.CertificateFunctionReference.Exec,
    ``FT1536.Run2.ActualNTRUFiber.coordinates_formula,
    ``FT1536.Run2.ActualNTRUFiber.gaussian_fiber_in_basis]
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
