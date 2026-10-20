import Source3.KeygenSolverValidation
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Internal complete type/term/axiom audit, including definitions of the
   remaining local inputs. This is not an independent acceptance review. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenSolverEquation,
      ["arrays","Images","Bounds","Equation","image_read","images_canonical","checked_pointwise",
       "cast_multiply","cast_sub","cast_constant","residual_zero","exact_of_images"]),
    (`FT1536.Source3.KeygenSolverNttCalls,
      ["macroParams","params","signatures","arguments","expandArgs","call","code","parsed","source_bound",
       "signature_source","Exec","Caller","pointer_zero","binding_entry","frame","caller_preserved","call_contract"]),
    (`FT1536.Source3.KeygenSolverTransforms,
      ["Bindings","code","four_code","outputs_outside","canonical_value_injective","frame_read",
       "input_preserved","image_preserved","sequence_images","four_images"]),
    (`FT1536.Source3.KeygenSolverTarget,
      ["expression","target","code","target_source","literal_arguments","target_expression","target_result",
       "checked_images","transformed_checked"]),
    (`FT1536.Source3.KeygenNttMemoryFrame,
      ["names","Descendant","Bindings","supported","pointer_descendant","store_bytes","Frame","frame_trans",
       "source_frame","tailCode","tail_supported","whole_frame","call_frame","material_preserved"]),
    (`FT1536.Source3.KeygenSolverValidation,
      ["sequence_frame","readOnly","read_only_heap","loop_counter","conversion_counter","bounds_wide",
       "generated_converted_checked"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMkgm3.Entry,
    ``FT1536.Source3.KeygenMkgm3Layout.Legal,
    ``FT1536.Source3.KeygenMkgm3Layout.DisjointBytes,
    ``FT1536.Source3.KeygenMkgm3Frame.objectBytes,
    ``FT1536.Source3.KeygenMkgm3Program.source_bound,
    ``FT1536.Source3.KeygenResidueRanges.Layout,
    ``FT1536.Source3.KeygenResidueTrace.Inputs,
    ``FT1536.Source3.KeygenResidueProgram.source_bound,
    ``FT1536.Source3.KeygenMaterial.Represents,
    ``FT1536.Source3.KeygenIntegerLift.Bound,
    ``FT1536.Source3.KeygenIntegerLift.residual_bound,
    ``FT1536.Source3.KeygenIntegerLift.exact_ntru_of_modular_check,
    ``FT1536.Source3.KeygenNinv31.SourceExec,
    ``FT1536.Source3.KeygenNttForwardPrograms.body_source,
    ``FT1536.Source3.KeygenNttButterflyPrograms.wrapper_source,
    ``FT1536.Source3.KeygenNttTransform.Image,
    ``FT1536.Source3.KeygenNttEvaluation.equation_of_pointwise,
    ``FT1536.Source3.KeygenCheckProgram.source_bound,
    ``FT1536.Source3.KeygenCheckLoopBridge.accepted_coordinates]
  let names := groups.flatMap fun (ns,decls) => decls.toArray.map (Lean.Name.str ns)
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  let mut rows : Array Lean.Json := #[]
  for name in names ++ inherited do
    IO.FS.writeFile "../SOLVER_VALIDATION_AUDIT_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
    IO.FS.writeFile "../SOLVER_VALIDATION_AUDIT_PARTIAL.json" (Lean.Json.arr rows |>.pretty)
  IO.FS.writeFile "../SOLVER_VALIDATION_AUDIT.json" (Lean.Json.arr rows |>.pretty)
