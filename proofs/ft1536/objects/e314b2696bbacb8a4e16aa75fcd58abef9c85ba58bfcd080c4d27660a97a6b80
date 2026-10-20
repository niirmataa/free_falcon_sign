import Source3.KeygenSmallCalls
import Source3.KeygenTernaryStore
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Complete internal type/term/axiom inventory of this midpoint. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenSmallSource,
      ["var","number","plainPrefix","plain_prefix_source","plain_return_source","plainEntry",
       "SignedLocalRead","signed_object_roundtrip","PlainCall","plain_heap","plain_signed",
       "Stmt","skip","chain","Exec","simple","declarations","statement","body","region",
       "guard","ret","gate","iteration","increment","loop","counter","prologue","sizeAssign","code",
       "source_bound","signature_source"]),
    (`FT1536.Source3.KeygenSmallStep,
      ["abortFlow","declared","assigned","tailStore","tailGate","tailCall","skip_result","ret_result",
       "reject_result","compare_signed","lower_compare","upper_compare","guard_bounds","gate_cases",
       "assigned_slot","assigned_counter","restored","call_result","store_result","gate_tail","iteration_cases"]),
    (`FT1536.Source3.KeygenSmallBounds,
      ["Writes","earlier_bytes","write_values","material","loop_result","Profile","declared","sized",
       "mkn_value","prologue_result","size_result","continuation","initialized","source_writes","source_material"]),
    (`FT1536.Source3.KeygenSmallCalls,
      ["params","Call","call_frame","return_one","writes_frame","preserves","bound_call","two_outputs"]),
    (`FT1536.Source3.KeygenTernaryStore,
      ["var","num","extract","shift","decrement","draw","condition","coefficient","store","draw_source",
       "branch_source","store_source","condition_source","Branch","Exec","assigned_else","updated_else",
       "updates_preserve","draw_slots","scalar_store_bound","accepted_store","rejected_heap"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenSmallOutput.source_plain,
    ``FT1536.Source3.KeygenSmallOutput.Store16,
    ``FT1536.Source3.KeygenSmallOutput.Stored,
    ``FT1536.Source3.KeygenSmallOutput.narrowed_exact,
    ``FT1536.Source3.KeygenMaterial.Represents,
    ``FT1536.Source3.KeygenIntegerLift.Bound,
    ``FT1536.Source3.C99MemoryReference.Load32,
    ``FT1536.Source3.C99ArrayReference.Bind,
    ``FT1536.Source3.KeygenTernaryBound.stored_integer]
  let names := groups.flatMap fun (ns,decls) => decls.toArray.map (Lean.Name.str ns)
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  let mut rows : Array Lean.Json := #[]
  for name in names ++ inherited do
    IO.FS.writeFile "../SMALL_BOUNDS_AUDIT_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
    IO.FS.writeFile "../SMALL_BOUNDS_AUDIT_PARTIAL.json" (Lean.Json.arr rows |>.pretty)
  IO.FS.writeFile "../SMALL_BOUNDS_AUDIT.json" (Lean.Json.arr rows |>.pretty)
