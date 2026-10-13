import Source3.KeygenDecodeValues
import Source3.KeygenDecodeExecution
import Source3.KeygenDecodeCellFrame
import Source3.KeygenDecodePointerFrame
import Source3.KeygenDecodeStateFrame
import Source3.KeygenDecodeMemory
import Source3.KeygenDecodeNoneFrame
import Source3.KeygenDecodePure
import Source3.KeygenCodecExactLengths
import Source3.KeygenDecodeNonePairs
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Author audit of decoder operations and frames only; no round-trip claim. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenDecodeValues,["Name","calleeArgs","Args","Value","Locals","State","initialLocals","initial","withLocals","localSet","scalarTy","castInteger","truth","boolean","Load16","LoadByte","UnaryOp","BinaryOp","Update","Eval","assignOp","Assigned","declareLocals","hasBuf","declared"]),
    (`FT1536.Source3.KeygenDecodeExecution,["Store16","Flow","testExpr","desugar","scopeObjects","scopeExit","Exec"]),
    (`FT1536.Source3.KeygenDecodeCellFrame,["expression","parts","update_frame","eval_frame","objects","declare_frame","statement","exec_frame"]),
    (`FT1536.Source3.KeygenDecodePointerFrame,["expression","parts","update_frame","eval_frame","declare_frame","statement","exec_frame"]),
    (`FT1536.Source3.KeygenDecodeStateFrame,["preserves","Same","exec_same","heap_frame","buf_frame"]),
    (`FT1536.Source3.KeygenDecodeMemory,["Window","window_refl","window_trans","store_window","bytes_reconstruct","store_readback","load_unique","store_same_memory"]),
    (`FT1536.Source3.KeygenDecodeNoneFrame,["exec_window","source_frame"]),
    (`FT1536.Source3.KeygenDecodePure,["Denotes","compare_unique","binary_unique","unary_unique","literal","scalar","cast","binary","unary"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenDecodeNoneBinding.source_bound,
    ``FT1536.Source3.KeygenDecodeNoneScalar.pair_roundtrip,
    ``FT1536.Source3.KeygenDecodeNonePairs.segment_roundtrip,
    ``FT1536.Source3.KeygenCodecExactLengths.none_source_length]
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
