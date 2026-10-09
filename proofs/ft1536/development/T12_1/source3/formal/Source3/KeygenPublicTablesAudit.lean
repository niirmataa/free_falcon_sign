import Source3.KeygenPublicScalarControl
import Source3.KeygenPublicRev
import Source3.KeygenPublicRevCert
import Source3.KeygenPublicTableAtoms
import Source3.KeygenPublicTableSeed
import Source3.KeygenPublicTableRows
import Source3.KeygenPublicTableCells
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated internal audit; no independent review or table/NTT completion claim. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenPublicScalarControl,
      ["lower","projection"]),
    (`FT1536.Source3.KeygenPublicRev,
      ["var","condition","increment","round","prologue","iteration","loop","tail","prepend","program","sourceProgram","source_lowered","types","state","initial","nextY","reversed","noCalls","calls_ok","state_good","initial_good","round_checked","round_no_return","prologue_checked","round_model","increment_model","condition_model","condition_value","iteration_complete","loop_complete","prologue_model","prefix_complete","seq_associate","prepend_map","source_program","program_result","call_body","source_result"]),
    (`FT1536.Source3.KeygenPublicRevCert,
      ["Correct","correctDecidable","chunk00","chunk01","chunk02","chunk03","chunk04","chunk05","chunk06","chunk07","chunk08","chunk09","chunk10","chunk11","chunk12","chunk13","chunk14","chunk15","chunk16","chunk17","chunk18","chunk19","chunk20","chunk21","chunk22","chunk23","chunk24","chunk25","chunk26","chunk27","chunk28","chunk29","chunk30","chunk31","chunk32","chunk33","chunk34","chunk35","chunk36","chunk37","chunk38","chunk39","chunk40","chunk41","chunk42","chunk43","chunk44","chunk45","chunk46","chunk47","chunk48","chunk49","chunk50","chunk51","chunk52","chunk53","chunk54","chunk55","chunk56","chunk57","chunk58","chunk59","chunk60","chunk61","chunk62","chunk63","block00","block01","block02","block03","all_indices","source_bitrev","source_last_index"]),
    (`FT1536.Source3.KeygenPublicTableAtoms,
      ["var","literal","mont","divide","Slot","literal_value","variable_value","mont_value","divide_value","literal_argument","variable_argument","assign_result","declaration_result","slot_after","slot_preserved","guard_value","increment_result"]),
    (`FT1536.Source3.KeygenPublicTableSeed,
      ["locals","increment","square","loop","postLoop","steps","prepend","suffix","source_complete","suffix_checked","declaredU","declaredK","declared","convertedWord","rootWord","inverseWord","converted","setup","beforeSquare","squared","completed","ready","ready_memory","converted_slot","setup_slots","square_slots","squared_slots","ready_slots","take_step","square_result","loop_false","loop_result","post_result","declared_g","converted_k_declared","converted_profile","unchanged_cell","declared_ig","completed_ig_declared","completed_g","conversion_result","setup_result","inverse_result","source_prefix","root_scaled","root_nonzero","inverse_scaled"]),
    (`FT1536.Source3.KeygenPublicTableRows,
      ["noReturn","normal","fragment","two","four","inverseTwo","inverseFour","rowSteps","remaining","body","lastRow","simpleRow","afterRows","dispatch","source_dispatch","dispatch_normal","full_normal","bDeclared","xReady","ixReady","twoReady","fourReady","inverseTwoReady","ready","Owned","declaration_preserves","declaration_member","initial_declared","ready_uninitialized","initial_owned","ready_x","ready_ix","ready_two","ready_four","ready_inverse_two","ready_inverse_four","slots","b_preserves","declared_x","declared_ix","declared_two","declared_four","declared_inverse_two","declared_inverse_four","row_prefix","dispatch_false","scope_result","seed_profile","source_last_row_entry","scaled_seeds"]),
    (`FT1536.Source3.KeygenPublicTableCells,
      ["Cell","narrowing","stored_load","written_cell","different_cell","preserves_cell","separate_store","unsigned_argument","promoted_cell"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenPublicScalar.Kind,
    ``FT1536.Source3.KeygenPublicScalar.params,
    ``FT1536.Source3.KeygenPublicScalar.code,
    ``FT1536.Source3.KeygenPublicScalar.Body,
    ``FT1536.Source3.KeygenPublicScalar.Leaf,
    ``FT1536.Source3.KeygenPublicScalar.Square,
    ``FT1536.Source3.KeygenPublicScalar.Call,
    ``FT1536.Source3.KeygenPublicSource.code_checked,
    ``FT1536.Source3.KeygenPublicSource.Call,
    ``FT1536.Source3.KeygenPublicSource.program,
    ``FT1536.Source3.KeygenPublicSource.params,
    ``FT1536.Source3.KeygenPublicSource.function,
    ``FT1536.Source3.KeygenPublicWord.scalar,
    ``FT1536.Source3.KeygenPublicWord.Eval,
    ``FT1536.Source3.KeygenPublicWord.Address,
    ``FT1536.Source3.KeygenPublicWord.Bind,
    ``FT1536.Source3.KeygenPublicExec.Stmt,
    ``FT1536.Source3.KeygenPublicExec.Exec,
    ``FT1536.Source3.KeygenPublicParser.statement,
    ``FT1536.Source3.KeygenPublicParser.body,
    ``FT1536.Source3.C99ModularReference.GenEval,
    ``FT1536.Source3.C99ModularReference.GenExec,
    ``FT1536.Source3.C99ModularReference.bindParams,
    ``FT1536.Source3.C99ScalarReference.Exec,
    ``FT1536.Source3.C99ScalarReference.Eval,
    ``FT1536.Source3.C99ProcedureReference.ReturnValue,
    ``FT1536.Source3.KeygenPublicAlgebra.source_scaled_product,
    ``FT1536.Source3.KeygenPublicArguments.U32,
    ``FT1536.Source3.KeygenPublicDivisionAlgebra.source_division,
    ``FT1536.Source3.KeygenPublicRoots.root_order,
    ``FT1536.Source3.KeygenPublicRoots.points_distinct,
    ``FT1536.Source3.KeygenPublicRoots.coefficient_injective,
    ``FT1536.Source3.KeygenSmallOutput.Store16,
    ``FT1536.Source3.C99NarrowReads.Load16,
    ``FT1536.Source3.KeygenMkgm3IndexCert.all_indices]
  let names := groups.flatMap fun (ns,decls) => decls.toArray.map (Lean.Name.str ns)
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  let mut rows : Array Lean.Json := #[]
  for name in names ++ inherited do
    IO.FS.writeFile "../PUBLIC_TABLES_AUDIT_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
    IO.FS.withFile "../PUBLIC_TABLES_AUDIT_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn rows.back!.compress
  IO.FS.writeFile "../PUBLIC_TABLES_AUDIT.json" (Lean.Json.arr rows |>.pretty)
