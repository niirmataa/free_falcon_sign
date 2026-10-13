import Source3.KeygenAcceptedMaterial079
import Source3.KeygenAcceptedLoop079
import Source3.KeygenSerializationEntry079
import Source3.KeygenAttemptSerialization079
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Author inventory; the certificate frame and root relocation remain open. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenAcceptedMaterial079,["attempt_material"]),
    (`FT1536.Source3.KeygenAcceptedLoop079,["sampled_tables","attempt_tables","facts_after","loop_material","final_state"]),
    (`FT1536.Source3.KeygenSerializationEntry079,["head_frame","prefix_frame","prefix_material","prefix_legal"]),
    (`FT1536.Source3.KeygenAttemptSerialization079,["CallsCarry","accepted_loop_to_calls"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMakeAttemptSpine.EntryFacts,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.Shape,
    ``FT1536.Source3.KeygenMakeRetryTransport.CertEntryFrame,
    ``FT1536.Source3.KeygenMakeCertCall.CertBind,
    ``FT1536.Source3.KeygenMakeCertCall.Call,
    ``FT1536.Source3.KeygenMakeInvocation.TailCells,
    ``FT1536.Source3.KeygenCodecInvocation.Encoding,
    ``FT1536.Source3.KeygenCodecTypedSegments.Site,
    ``FT1536.Source3.KeygenMakeMaterialWitness.EncodingInputs,
    ``FT1536.Source3.KeygenInt16Caller076.witness_transport]
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
