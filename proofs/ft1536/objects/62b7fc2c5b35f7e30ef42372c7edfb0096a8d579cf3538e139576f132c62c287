import Source3.KeygenPublicRangeMemory
import Source3.KeygenPublicRangeExpr
import Source3.KeygenPublicRangeExec
import Source3.KeygenPublicForwardProgram
import Source3.KeygenPublicForwardMemory
import Source3.KeygenPublicForwardControl
import Source3.KeygenPublicForwardCall
import Source3.KeygenPublicForwardRange
import Source3.KeygenPublicForwardWrapper
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated full internal forward-range audit. No independent review or evaluation claim. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenPublicRangeMemory,
      ["Domain","Initialized","Image","image","aligned","load_allocated","byte_frame","read_after_store","domain_store","load_survives","initialized_store","domain_same_block","initialized_same_block"]),
    (`FT1536.Source3.KeygenPublicRangeExpr,
      ["Ranged","word","Locals","Arrays","word_nat","word_range","word_argument","uint32_range","converted_nat","converted_integer","converted_range","narrowed_range","add_range","sub_range","mul_range","square_call","square_range","checked","expression"]),
    (`FT1536.Source3.KeygenPublicRangeExec,
      ["checked","Invariant","locals_set","locals_declare","locals_bound","arrays_store","locals_scope","body"]),
    (`FT1536.Source3.KeygenPublicForwardProgram,
      ["residueNames","arrayNames","dimensionNames","pointerNames","types","fragment","tail","declareDimensions","declareResidues","declarePointers","nSet","hnSet","generateArgs","generate","squareAlias","cubicAlias","dynamic","static","condition","dispatch","readyBody","arraysBody","complete","source_complete","tail_range_checked","tail_supported","full_normal","prefix_normal","dynamic_normal","tail_writes","no_dimension_residue","n_untracked","hn_untracked"]),
    (`FT1536.Source3.KeygenPublicForwardMemory,
      ["Block","block_refl","block_trans","block_symm","load_block","domain_block","initialized_block","initialized_live","allocated_other","disposed_other","upper_other","generated_domain"]),
    (`FT1536.Source3.KeygenPublicForwardControl,
      ["checked","pure_result","seq_inv"]),
    (`FT1536.Source3.KeygenPublicForwardCall,
      ["generate_lookup","zero_value","generate_entry","generate_result","alias_result","alias_other","restore_empty","dynamic_result"]),
    (`FT1536.Source3.KeygenPublicForwardRange,
      ["pointerReady","pointer_declarations","condition_value","dispatch_dynamic","ready_result","source_canonical"]),
    (`FT1536.Source3.KeygenPublicForwardWrapper,
      ["arguments","ternaryCall","ternaryBody","binaryBody","dispatch","complete","Ternary","source_complete","forward_lookup","binding_entry","call_canonical","ternary_value","ternary_body_canonical","source_forward_canonical","domain_of_image","source_forward_image"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.C99MemoryReference.Memory,
    ``FT1536.Source3.C99MemoryReference.ArrayPointer,
    ``FT1536.Source3.C99MemoryReference.ArrayPointer.offset,
    ``FT1536.Source3.C99MemoryReference.Allocated,
    ``FT1536.Source3.C99MemoryReference.PointerAdd,
    ``FT1536.Source3.C99IntegerReference.Ty,
    ``FT1536.Source3.C99IntegerReference.Value,
    ``FT1536.Source3.C99IntegerReference.Value.integer,
    ``FT1536.Source3.C99IntegerReference.Value.type,
    ``FT1536.Source3.C99IntegerReference.convert,
    ``FT1536.Source3.C99IntegerReference.compare,
    ``FT1536.Source3.C99IntegerReference.promote,
    ``FT1536.Source3.C99IntegerReference.usual,
    ``FT1536.Source3.C99IntegerReference.ArithmeticExec,
    ``FT1536.Source3.C99ScalarReference.Env,
    ``FT1536.Source3.C99ScalarReference.set,
    ``FT1536.Source3.C99ScalarReference.boolean,
    ``FT1536.Source3.C99ScalarReference.Stmt,
    ``FT1536.Source3.C99ScalarReference.Exec,
    ``FT1536.Source3.C99ScalarReference.Eval,
    ``FT1536.Source3.C99Frontend.scalar,
    ``FT1536.Source3.C99Frontend.expression,
    ``FT1536.Source3.C99Frontend.binary,
    ``FT1536.Source3.C99DeclarationCells.declareCells,
    ``FT1536.Source3.C99DeclarationCells.complete,
    ``FT1536.Source3.C99ArrayReference.Name,
    ``FT1536.Source3.C99ArrayReference.Arg,
    ``FT1536.Source3.C99ArrayReference.Param,
    ``FT1536.Source3.C99ArrayReference.State,
    ``FT1536.Source3.C99ArrayReference.bindValue,
    ``FT1536.Source3.C99ArrayReference.bindPointer,
    ``FT1536.Source3.C99ArrayReference.restoreScope,
    ``FT1536.Source3.C99ProcedureReference.Result,
    ``FT1536.Source3.C99ProcedureReference.Flow,
    ``FT1536.Source3.C99ProcedureReference.ReturnValue,
    ``FT1536.Source3.C99ProcedureParser.zero,
    ``FT1536.Source3.C99CountedWords.comparison_result,
    ``FT1536.Source3.C99NarrowReads.Load16,
    ``FT1536.Source3.C99NarrowReads.le16,
    ``FT1536.Source3.C99NarrowReads.unsignedPromotion,
    ``FT1536.Source3.C99NarrowReads.unsigned_promotion_exact,
    ``FT1536.Source3.C99NarrowReads.load16_deterministic,
    ``FT1536.Source3.C99NarrowReads.load16_transport,
    ``FT1536.Source3.KeygenSmallOutput.element,
    ``FT1536.Source3.KeygenSmallOutput.byte16,
    ``FT1536.Source3.KeygenSmallOutput.Stored,
    ``FT1536.Source3.KeygenSmallOutput.Store16,
    ``FT1536.Source3.KeygenResidueVectors.join_bytes,
    ``FT1536.Source3.KeygenWordExpr.Expr,
    ``FT1536.Source3.KeygenWordExpr.expression,
    ``FT1536.Source3.KeygenPublicScalar.Kind,
    ``FT1536.Source3.KeygenPublicScalar.Call,
    ``FT1536.Source3.KeygenPublicScalar.Square,
    ``FT1536.Source3.KeygenPublicScalar.name,
    ``FT1536.Source3.KeygenPublicScalar.params,
    ``FT1536.Source3.KeygenPublicScalar.lines,
    ``FT1536.Source3.KeygenPublicScalar.expand,
    ``FT1536.Source3.KeygenPublicAlgebra.R,
    ``FT1536.Source3.KeygenPublicAlgebra.Canonical,
    ``FT1536.Source3.KeygenPublicAlgebra.value,
    ``FT1536.Source3.KeygenPublicAlgebra.source_add,
    ``FT1536.Source3.KeygenPublicAlgebra.source_sub,
    ``FT1536.Source3.KeygenPublicAlgebra.call_leaf,
    ``FT1536.Source3.KeygenPublicMontgomery.modulus,
    ``FT1536.Source3.KeygenPublicMontgomery.inverse,
    ``FT1536.Source3.KeygenPublicMontgomery.word_contract,
    ``FT1536.Source3.KeygenPublicArguments.U32,
    ``FT1536.Source3.KeygenPublicArguments.Conversion,
    ``FT1536.Source3.KeygenPublicArguments.u32_self,
    ``FT1536.Source3.KeygenPublicArguments.call_leaf_conversion,
    ``FT1536.Source3.KeygenPublicArguments.source_mul_exact,
    ``FT1536.Source3.KeygenPublicLeafWords.source_add,
    ``FT1536.Source3.KeygenPublicLeafWords.source_sub,
    ``FT1536.Source3.KeygenPublicSquare.source_square_arguments,
    ``FT1536.Source3.KeygenPublicWord.Eval,
    ``FT1536.Source3.KeygenPublicWord.Address,
    ``FT1536.Source3.KeygenPublicWord.scalar,
    ``FT1536.Source3.KeygenPublicWord.Bind,
    ``FT1536.Source3.KeygenPublicWord.narrow,
    ``FT1536.Source3.KeygenPublicWord.bind_heap,
    ``FT1536.Source3.KeygenPublicExec.Stmt,
    ``FT1536.Source3.KeygenPublicExec.Exec,
    ``FT1536.Source3.KeygenPublicExec.Function,
    ``FT1536.Source3.KeygenPublicExec.Program,
    ``FT1536.Source3.KeygenPublicExec.chain,
    ``FT1536.Source3.KeygenPublicExec.allocated,
    ``FT1536.Source3.KeygenPublicExec.localPointer,
    ``FT1536.Source3.KeygenPublicExec.localEntry,
    ``FT1536.Source3.KeygenPublicExec.localExit,
    ``FT1536.Source3.KeygenPublicParser.Types,
    ``FT1536.Source3.KeygenPublicParser.body,
    ``FT1536.Source3.KeygenPublicParser.statement,
    ``FT1536.Source3.KeygenPublicSource.Kind,
    ``FT1536.Source3.KeygenPublicSource.name,
    ``FT1536.Source3.KeygenPublicSource.code,
    ``FT1536.Source3.KeygenPublicSource.params,
    ``FT1536.Source3.KeygenPublicSource.function,
    ``FT1536.Source3.KeygenPublicSource.program,
    ``FT1536.Source3.KeygenPublicSource.types,
    ``FT1536.Source3.KeygenPublicSource.signatures,
    ``FT1536.Source3.KeygenPublicSource.code_checked,
    ``FT1536.Source3.KeygenPublicTableAtoms.Slot,
    ``FT1536.Source3.KeygenPublicTableAtoms.var,
    ``FT1536.Source3.KeygenPublicTableAtoms.literal,
    ``FT1536.Source3.KeygenPublicTableAtoms.variable_value,
    ``FT1536.Source3.KeygenPublicTableAtoms.literal_value,
    ``FT1536.Source3.KeygenPublicTableAtoms.literal_argument,
    ``FT1536.Source3.KeygenPublicTableIndex.address,
    ``FT1536.Source3.KeygenPublicTableStore.Pointers,
    ``FT1536.Source3.KeygenPublicTableStore.Separate,
    ``FT1536.Source3.KeygenPublicTableCells.Cell,
    ``FT1536.Source3.KeygenPublicTableControl.writes,
    ``FT1536.Source3.KeygenPublicTableControl.supported,
    ``FT1536.Source3.KeygenPublicTableControl.frame,
    ``FT1536.Source3.KeygenPublicTableControl.declare_frame,
    ``FT1536.Source3.KeygenPublicTableRows.noReturn,
    ``FT1536.Source3.KeygenPublicTableRows.normal,
    ``FT1536.Source3.KeygenPublicUpperLoops.PairCells,
    ``FT1536.Source3.KeygenPublicUpperFrames.UpperFrame,
    ``FT1536.Source3.KeygenPublicUpperFrames.OutsideFull,
    ``FT1536.Source3.KeygenPublicUpperImages.source_complete_tables,
    ``FT1536.Source3.KeygenPublicRoots.root,
    ``FT1536.Source3.KeygenMkgm3Indices.tableExponent,
    ``FT1536.Source3.KeygenRngSource.Fresh,
    ``FT1536.Source3.KeygenRngSource.disposed,
    ``FT1536.Source3.ShakeExtractFrame.SameBlock,
    ``FT1536.Source3.KeygenZintTop.tokens]
  let names := groups.flatMap fun (ns,decls) => decls.toArray.map (Lean.Name.str ns)
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  let mut rows : Array Lean.Json := #[]
  for name in names ++ inherited do
    IO.FS.writeFile "../PUBLIC_FORWARD_AUDIT_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
    IO.FS.withFile "../PUBLIC_FORWARD_AUDIT_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn rows.back!.compress
  IO.FS.writeFile "../PUBLIC_FORWARD_AUDIT.json" (Lean.Json.arr rows |>.pretty)
