import Source3.KeygenMkgm3
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Internal type/term/axiom audit. No independent review verdict. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMkgm3.Entry,
    ``FT1536.Source3.KeygenMkgm3.Rows,
    ``FT1536.Source3.KeygenMkgm3.Preserved,
    ``FT1536.Source3.KeygenMkgm3.Contract,
    ``FT1536.Source3.KeygenMkgm3RevMemory.SourceTable,
    ``FT1536.Source3.KeygenMkgm3RevMemory.Rev,
    ``FT1536.Source3.KeygenMkgm3Layout.Legal,
    ``FT1536.Source3.KeygenMkgm3Frame.Outside,
    ``FT1536.Source3.KeygenMkgm3Frame.objectBytes,
    ``FT1536.Source3.KeygenMkgm3Rows.Scaled,
    ``FT1536.Source3.KeygenMkgm3Rows.root,
    ``FT1536.Source3.KeygenMkgm3Indices.rowExponent,
    ``FT1536.Source3.KeygenMkgm3Indices.tableExponent,
    ``FT1536.Source3.KeygenMkgm3Indices.tableOrder,
    ``FT1536.Source3.KeygenFirstPrime.first_entry,
    ``FT1536.Source3.KeygenMkgm3Program.source_bound,
    ``FT1536.Source3.KeygenRev10Cert.rawTable_exact,
    ``FT1536.Source3.KeygenModpR2.initialized_value_law,
    ``FT1536.Source3.KeygenModpR2.initialized_to_montgomery,
    ``FT1536.Source3.KeygenMkgm3Rows.generator_order,
    ``FT1536.Source3.KeygenMkgm3Rows.root_order,
    ``FT1536.Source3.KeygenMkgm3Rows.initialized_root,
    ``FT1536.Source3.KeygenMkgm3Rows.last_pair,
    ``FT1536.Source3.KeygenMkgm3IndexCert.all_indices,
    ``FT1536.Source3.KeygenMkgm3Table.exact_order,
    ``FT1536.Source3.KeygenMkgm3Table.last_injective,
    ``FT1536.Source3.KeygenMkgm3Table.last_covers,
    ``FT1536.Source3.KeygenMkgm3Control.frame,
    ``FT1536.Source3.KeygenMkgm3RevMemory.from_source,
    ``FT1536.Source3.KeygenMkgm3RevMemory.transported,
    ``FT1536.Source3.KeygenMkgm3RevMemory.storeRev_address,
    ``FT1536.Source3.KeygenMkgm3Upward.cube_body,
    ``FT1536.Source3.KeygenMkgm3Upward.square_body,
    ``FT1536.Source3.KeygenMkgm3LastRow.body_result,
    ``FT1536.Source3.KeygenMkgm3Loops.last_loop,
    ``FT1536.Source3.KeygenMkgm3Loops.cube_loop,
    ``FT1536.Source3.KeygenMkgm3Loops.square_loop,
    ``FT1536.Source3.KeygenMkgm3Prelude.initial_result,
    ``FT1536.Source3.KeygenMkgm3RowInit.selected_row,
    ``FT1536.Source3.KeygenMkgm3Assembly.source_table,
    ``FT1536.Source3.KeygenMkgm3Frame.outside_bytes,
    ``FT1536.Source3.KeygenMkgm3Frame.source_material,
    ``FT1536.Source3.KeygenMkgm3Layout.alias_source,
    ``FT1536.Source3.KeygenMkgm3Layout.alias_result,
    ``FT1536.Source3.KeygenMkgm3Layout.ready_layout,
    ``FT1536.Source3.KeygenMkgm3Layout.temporary_inverse_source,
    ``FT1536.Source3.KeygenMkgm3Layout.bytes_required,
    ``FT1536.Source3.KeygenMkgm3Layout.table_separation,
    ``FT1536.Source3.KeygenMkgm3Layout.output_gm_separation,
    ``FT1536.Source3.KeygenMkgm3Layout.overwrite_preserves,
    ``FT1536.Source3.KeygenMkgm3.source_contract,
    ``FT1536.Source3.KeygenMkgm3.parsed_contract,
    ``FT1536.Source3.KeygenMkgm3.allocated_tables,
    ``FT1536.Source3.KeygenMkgm3.allocated_outputs,
    ``FT1536.Source3.KeygenMkgm3.output_pairwise,
    ``FT1536.Source3.KeygenMkgm3.inverse_prefix,
    ``FT1536.Source3.KeygenMkgm3.source_then_overwrite]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let mut rows : Array Lean.Json := #[]
  for name in names do
    let info ← Lean.getConstInfo name
    let axes ← Lean.collectAxioms name
    for ax in axes do
      unless allowed.contains ax do
        throwError "Unexpected axiom {ax} in {name}"
    let typeText := (← Lean.Meta.ppExpr info.type).pretty
    let some term := info.value? (allowOpaque := true) | throwError "Missing body for {name}"
    let termText := (← Lean.Meta.ppExpr term).pretty
    if typeText.contains '⋯' || termText.contains '⋯' then
      throwError "Truncated audit text for {name}"
    rows := rows.push (Lean.Json.mkObj [
      ("name",Lean.toJson name.toString), ("type",Lean.toJson typeText),
      ("term",Lean.toJson termText), ("axioms",Lean.toJson (axes.map Lean.Name.toString))])
  IO.FS.writeFile "../MKGM3_AUDIT.json" (Lean.Json.arr rows |>.pretty)
