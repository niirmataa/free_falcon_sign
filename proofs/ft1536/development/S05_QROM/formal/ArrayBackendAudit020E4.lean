import ArrayBank020E4
import ArrayState020E4
import ArrayFrames020E4
import ArrayArena020E4
import ArrayValues020E4
import ArrayAtom020E4
import ArrayAction020E4
import ArrayExecute020E4
import ArrayProgram020E4
import CostRun020E4
import ArrayDriver020E4
import ArrayCertificate020E4
import CostBank020E4
import CostFlow020E4
import CostScalar020E4
import CostValueCell020E4
import CostValues020E4
import CostFrames020E4
import CostState020E4
import CostBounds020E4
import CostAtom020E4
import PublicImage020E4
import CostControl020E4
import ArrayPrefix020E4
import CostAction020E4
import CostExecute020E4
import CostParserRead020E4
import CostParserStep020E4
import CostParse020E4
import CostBoot020E4
import CostInput020E4
import CostProgram020E4
import CostBoundary020E4
import CostPipeline020E4
import CostDriver020E4
import CostCertificate020E4
import CostNumbers020E4
import CostSpaceGap020E4

#print axioms FT1536.S05.ArrayBank020E4.read_load
#print axioms FT1536.S05.ArrayBank020E4.read_write
#print axioms FT1536.S05.ArrayBank020E4.ext
#print axioms FT1536.S05.ArrayBank020E4.load_read
#print axioms FT1536.S05.ArrayBank020E4.fixed_size
#print axioms FT1536.S05.ArrayBank020E4.write_size
#print axioms FT1536.S05.ArrayState020E4.input_load
#print axioms FT1536.S05.ArrayState020E4.model_load
#print axioms FT1536.S05.ArrayState020E4.initial_eq
#print axioms FT1536.S05.ArrayState020E4.put_eq
#print axioms FT1536.S05.ArrayState020E4.store_eq
#print axioms FT1536.S05.ArrayState020E4.emit_eq
#print axioms FT1536.S05.ArrayState020E4.fail_eq
#print axioms FT1536.S05.ArrayFrames020E4.empty_eq
#print axioms FT1536.S05.ArrayFrames020E4.top_eq
#print axioms FT1536.S05.ArrayFrames020E4.drop_eq
#print axioms FT1536.S05.ArrayFrames020E4.put_eq
#print axioms FT1536.S05.ArrayFrames020E4.push_eq
#print axioms FT1536.S05.ArrayFrames020E4.pushMany_eq
#print axioms FT1536.S05.ArrayArena020E4.empty_eq
#print axioms FT1536.S05.ArrayArena020E4.commit_eq
#print axioms FT1536.S05.ArrayArena020E4.step_eq
#print axioms FT1536.S05.ArrayArena020E4.stepCell_eq
#print axioms FT1536.S05.ArrayArena020E4.parse_eq
#print axioms FT1536.S05.ArrayValues020E4.lookup_eq
#print axioms FT1536.S05.ArrayValues020E4.entry_eq
#print axioms FT1536.S05.ArrayValues020E4.advance_eq
#print axioms FT1536.S05.ArrayValues020E4.sweep_eq
#print axioms FT1536.S05.ArrayValues020E4.build_eq
#print axioms FT1536.S05.ArrayAtom020E4.correct
#print axioms FT1536.S05.ArrayAction020E4.loop_eq
#print axioms FT1536.S05.ArrayAction020E4.dispatch_eq
#print axioms FT1536.S05.ArrayAction020E4.withEvaluator_eq
#print axioms FT1536.S05.ArrayAction020E4.action_eq
#print axioms FT1536.S05.ArrayExecute020E4.step_eq
#print axioms FT1536.S05.ArrayExecute020E4.execute_eq
#print axioms FT1536.S05.ArrayProgram020E4.fromArena_eq
#print axioms FT1536.S05.ArrayProgram020E4.actual_eq
#print axioms FT1536.S05.ArrayProgram020E4.actual_correct
#print axioms FT1536.S05.CostRun020E4.bind_value
#print axioms FT1536.S05.CostRun020E4.bind_ticks
#print axioms FT1536.S05.CostRun020E4.bind_allocated
#print axioms FT1536.S05.CostRun020E4.bind_bound
#print axioms FT1536.S05.CostRun020E4.prefix_allocation_bound
#print axioms FT1536.S05.ArrayDriver020E4.observe
#print axioms FT1536.S05.ArrayDriver020E4.run_eq
#print axioms FT1536.S05.ArrayDriver020E4.code_eq
#print axioms FT1536.S05.ArrayDriver020E4.law_eq
#print axioms FT1536.S05.ArrayCertificate020E4.all_h_ac
#print axioms FT1536.S05.ArrayCertificate020E4.certificate
#print axioms FT1536.S05.ArrayCertificate020E4.same_key_law
#print axioms FT1536.S05.CostBank020E4.copyWrite_eq
#print axioms FT1536.S05.CostBank020E4.read_value
#print axioms FT1536.S05.CostBank020E4.write_value
#print axioms FT1536.S05.CostBank020E4.tabulate_bound
#print axioms FT1536.S05.CostBank020E4.zero_value
#print axioms FT1536.S05.CostBank020E4.zero_budget
#print axioms FT1536.S05.CostFlow020E4.overhead_value
#print axioms FT1536.S05.CostFlow020E4.overhead_bound
#print axioms FT1536.S05.CostFlow020E4.optBind_value
#print axioms FT1536.S05.CostFlow020E4.optBind_bound
#print axioms FT1536.S05.CostScalar020E4.reg_value
#print axioms FT1536.S05.CostScalar020E4.reg_budget
#print axioms FT1536.S05.CostScalar020E4.op_value
#print axioms FT1536.S05.CostScalar020E4.op_bound
#print axioms FT1536.S05.CostScalar020E4.address_value
#print axioms FT1536.S05.CostScalar020E4.address_budget
#print axioms FT1536.S05.CostScalar020E4.decode_value
#print axioms FT1536.S05.CostScalar020E4.decode_bound
#print axioms FT1536.S05.CostValueCell020E4.lookup_value
#print axioms FT1536.S05.CostValueCell020E4.lookup_bound
#print axioms FT1536.S05.CostValueCell020E4.compute_value
#print axioms FT1536.S05.CostValueCell020E4.compute_bound
#print axioms FT1536.S05.CostValueCell020E4.entry_value
#print axioms FT1536.S05.CostValueCell020E4.entry_bound
#print axioms FT1536.S05.CostValues020E4.advance_value
#print axioms FT1536.S05.CostValues020E4.advance_bound
#print axioms FT1536.S05.CostValues020E4.sweep_value
#print axioms FT1536.S05.CostValues020E4.sweep_bound
#print axioms FT1536.S05.CostValues020E4.build_value
#print axioms FT1536.S05.CostValues020E4.build_bound
#print axioms FT1536.S05.CostFrames020E4.top_value
#print axioms FT1536.S05.CostFrames020E4.top_bound
#print axioms FT1536.S05.CostFrames020E4.push_value
#print axioms FT1536.S05.CostFrames020E4.push_bound
#print axioms FT1536.S05.CostFrames020E4.pushMany_value
#print axioms FT1536.S05.CostFrames020E4.pushMany_bound
#print axioms FT1536.S05.CostState020E4.put_value
#print axioms FT1536.S05.CostState020E4.store_value
#print axioms FT1536.S05.CostState020E4.emit_value
#print axioms FT1536.S05.CostState020E4.put_budget
#print axioms FT1536.S05.CostState020E4.store_budget
#print axioms FT1536.S05.CostState020E4.emit_budget
#print axioms FT1536.S05.CostBounds020E4.weaken
#print axioms FT1536.S05.CostBounds020E4.map_bound
#print axioms FT1536.S05.CostBounds020E4.optBind_bound_on
#print axioms FT1536.S05.CostAtom020E4.core_prices
#print axioms FT1536.S05.CostAtom020E4.value
#print axioms FT1536.S05.CostAtom020E4.bound
#print axioms FT1536.S05.PublicImage020E4.serial_injective
#print axioms FT1536.S05.PublicImage020E4.serial_binding
#print axioms FT1536.S05.PublicImage020E4.binding
#print axioms FT1536.S05.PublicImage020E4.length
#print axioms FT1536.S05.CostControl020E4.inspect_value
#print axioms FT1536.S05.CostControl020E4.inspect_bound
#print axioms FT1536.S05.CostControl020E4.loop_value
#print axioms FT1536.S05.CostControl020E4.loop_bound
#print axioms FT1536.S05.CostControl020E4.dispatch_value
#print axioms FT1536.S05.CostControl020E4.dispatch_bound
#print axioms FT1536.S05.ArrayPrefix020E4.loop_prefix
#print axioms FT1536.S05.ArrayPrefix020E4.empty_prefix
#print axioms FT1536.S05.ArrayPrefix020E4.dispatch_prefix
#print axioms FT1536.S05.ArrayPrefix020E4.evaluator_prefix
#print axioms FT1536.S05.ArrayPrefix020E4.action_prefix
#print axioms FT1536.S05.CostAction020E4.evaluator_value
#print axioms FT1536.S05.CostAction020E4.evaluator_bound
#print axioms FT1536.S05.CostAction020E4.value
#print axioms FT1536.S05.CostAction020E4.bound
#print axioms FT1536.S05.CostAction020E4.prefix_bound
#print axioms FT1536.S05.CostExecute020E4.step_value
#print axioms FT1536.S05.CostExecute020E4.value
#print axioms FT1536.S05.CostExecute020E4.step_bound
#print axioms FT1536.S05.CostExecute020E4.bound
#print axioms FT1536.S05.CostParserRead020E4.peek_value
#print axioms FT1536.S05.CostParserRead020E4.peek_bound
#print axioms FT1536.S05.CostParserRead020E4.fresh_value
#print axioms FT1536.S05.CostParserRead020E4.fresh_bound
#print axioms FT1536.S05.CostParserRead020E4.kind_value
#print axioms FT1536.S05.CostParserRead020E4.kind_bound
#print axioms FT1536.S05.CostParserRead020E4.kinds_value
#print axioms FT1536.S05.CostParserRead020E4.kinds_bound
#print axioms FT1536.S05.CostParserStep020E4.commit_value
#print axioms FT1536.S05.CostParserStep020E4.commit_budget
#print axioms FT1536.S05.CostParserStep020E4.value
#print axioms FT1536.S05.CostParserStep020E4.bound
#print axioms FT1536.S05.CostParse020E4.value
#print axioms FT1536.S05.CostParse020E4.bound
#print axioms FT1536.S05.CostParse020E4.empty_value
#print axioms FT1536.S05.CostParse020E4.empty_bound
#print axioms FT1536.S05.CostParse020E4.copy_value
#print axioms FT1536.S05.CostParse020E4.copy_budget
#print axioms FT1536.S05.CostParse020E4.load_value
#print axioms FT1536.S05.CostParse020E4.load_bound
#print axioms FT1536.S05.CostBoot020E4.value
#print axioms FT1536.S05.CostBoot020E4.bound
#print axioms FT1536.S05.CostInput020E4.table_value
#print axioms FT1536.S05.CostInput020E4.table_budget
#print axioms FT1536.S05.CostInput020E4.rom_value
#print axioms FT1536.S05.CostInput020E4.rom_bound
#print axioms FT1536.S05.CostInput020E4.value
#print axioms FT1536.S05.CostInput020E4.bound
#print axioms FT1536.S05.CostInput020E4.same_key
#print axioms FT1536.S05.CostProgram020E4.frames_value
#print axioms FT1536.S05.CostProgram020E4.frames_bound
#print axioms FT1536.S05.CostProgram020E4.from_value
#print axioms FT1536.S05.CostProgram020E4.from_bound
#print axioms FT1536.S05.CostProgram020E4.value
#print axioms FT1536.S05.CostProgram020E4.bound
#print axioms FT1536.S05.CostBoundary020E4.initial_value
#print axioms FT1536.S05.CostBoundary020E4.initial_bound
#print axioms FT1536.S05.CostBoundary020E4.copy_value
#print axioms FT1536.S05.CostBoundary020E4.copy_bound
#print axioms FT1536.S05.CostPipeline020E4.value
#print axioms FT1536.S05.CostPipeline020E4.bound
#print axioms FT1536.S05.CostDriver020E4.finish_value
#print axioms FT1536.S05.CostDriver020E4.call_value
#print axioms FT1536.S05.CostDriver020E4.assemble_value
#print axioms FT1536.S05.CostDriver020E4.bound
#print axioms FT1536.S05.CostDriver020E4.value
#print axioms FT1536.S05.CostDriver020E4.every_tape
#print axioms FT1536.S05.CostDriver020E4.code_eq
#print axioms FT1536.S05.CostDriver020E4.law_eq
#print axioms FT1536.S05.CostCertificate020E4.all_key_ac
#print axioms FT1536.S05.CostCertificate020E4.certificate
#print axioms FT1536.S05.CostCertificate020E4.public_law_eq
#print axioms FT1536.S05.CostCertificate020E4.same_key_law
#print axioms FT1536.S05.CostNumbers020E4.total
#print axioms FT1536.S05.CostNumbers020E4.every_call
#print axioms FT1536.S05.CostNumbers020E4.coin_payload_bytes
#print axioms FT1536.S05.CostSpaceGap020E4.zero_counters
#print axioms FT1536.S05.CostSpaceGap020E4.full_payload
#print axioms FT1536.S05.CostSpaceGap020E4.counterexample
#print axioms FT1536.S05.CostSpaceGap020E4.no_universal_storage_rule
