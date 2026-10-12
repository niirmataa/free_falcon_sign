import Interleaved020D
import MachineAtoms020D
import BufferUpdate020D
import Residue020D
import BufferField020D
import ScalarExpr020D
import ScatterBranches020D
import IndexReference020D
import DataWords020D
import ScatterRead020D
import ScatterAlgebra020D
import ScatterTerm020D
import ActualScatter020D
import KeyWords020D
import ClearBuffer020D
import ScatterSums020D
import ScatterRow020D
import RowStart020D
import MultiplyRow020D
import BufferTransport020D
import MultiplyLoop020D
import OutputSlice020D
import EmitStep020D
import EmitWord020D
import OutputValues020D
import OutputChunks020D
import EmitRead020D
import EmitEntry020D
import OutputLoop020D
import ActualEmitEntry020D
import EmitTag020D
import OutputFormat020D
import EmitLoops020D
import EncodedOutput020D
import EmitPredicates020D
import ActualEmit020D
import WireFormat020D
import ProgramRefinement020D
import MachineStateBridge020D
import MachineLaw020D
import MachineCertificate020D

/- Author audit of every new named theorem. No independent-review claim. -/
#check FT1536.S05.Interleaved020D.parity
#print axioms FT1536.S05.Interleaved020D.parity
#check FT1536.S05.Interleaved020D.rebuild
#print axioms FT1536.S05.Interleaved020D.rebuild
#check FT1536.S05.Interleaved020D.exponent_bound
#print axioms FT1536.S05.Interleaved020D.exponent_bound
#check FT1536.S05.Interleaved020D.exponent_even
#print axioms FT1536.S05.Interleaved020D.exponent_even
#check FT1536.S05.Interleaved020D.exponent_odd
#print axioms FT1536.S05.Interleaved020D.exponent_odd
#check FT1536.S05.Interleaved020D.exponent_eval
#print axioms FT1536.S05.Interleaved020D.exponent_eval
#check FT1536.S05.MachineAtoms020D.exec_ram
#print axioms FT1536.S05.MachineAtoms020D.exec_ram
#check FT1536.S05.MachineAtoms020D.exec_rom
#print axioms FT1536.S05.MachineAtoms020D.exec_rom
#check FT1536.S05.MachineAtoms020D.load_ram_at
#print axioms FT1536.S05.MachineAtoms020D.load_ram_at
#check FT1536.S05.MachineAtoms020D.load_rom_at
#print axioms FT1536.S05.MachineAtoms020D.load_rom_at
#check FT1536.S05.MachineAtoms020D.store_at
#print axioms FT1536.S05.MachineAtoms020D.store_at
#check FT1536.S05.MachineAtoms020D.ramPut_same
#print axioms FT1536.S05.MachineAtoms020D.ramPut_same
#check FT1536.S05.MachineAtoms020D.ramPut_other
#print axioms FT1536.S05.MachineAtoms020D.ramPut_other
#check FT1536.S05.BufferUpdate020D.update_correct
#print axioms FT1536.S05.BufferUpdate020D.update_correct
#check FT1536.S05.BufferUpdate020D.result_same
#print axioms FT1536.S05.BufferUpdate020D.result_same
#check FT1536.S05.BufferUpdate020D.result_other
#print axioms FT1536.S05.BufferUpdate020D.result_other
#check FT1536.S05.BufferUpdate020D.result_reg
#print axioms FT1536.S05.BufferUpdate020D.result_reg
#check FT1536.S05.BufferUpdate020D.result_frame
#print axioms FT1536.S05.BufferUpdate020D.result_frame
#check FT1536.S05.Residue020D.field_bounds
#print axioms FT1536.S05.Residue020D.field_bounds
#check FT1536.S05.Residue020D.field_fits
#print axioms FT1536.S05.Residue020D.field_fits
#check FT1536.S05.Residue020D.decode_fw
#print axioms FT1536.S05.Residue020D.decode_fw
#check FT1536.S05.Residue020D.modular_word
#print axioms FT1536.S05.Residue020D.modular_word
#check FT1536.S05.Residue020D.value_cast
#print axioms FT1536.S05.Residue020D.value_cast
#check FT1536.S05.Residue020D.add_modular_word
#print axioms FT1536.S05.Residue020D.add_modular_word
#check FT1536.S05.Residue020D.product_modular_word
#print axioms FT1536.S05.Residue020D.product_modular_word
#check FT1536.S05.Residue020D.neg_value_cast
#print axioms FT1536.S05.Residue020D.neg_value_cast
#check FT1536.S05.BufferField020D.frame_refl
#print axioms FT1536.S05.BufferField020D.frame_refl
#check FT1536.S05.BufferField020D.frame_trans
#print axioms FT1536.S05.BufferField020D.frame_trans
#check FT1536.S05.BufferField020D.slot_injective
#print axioms FT1536.S05.BufferField020D.slot_injective
#check FT1536.S05.BufferField020D.result_holds
#print axioms FT1536.S05.BufferField020D.result_holds
#check FT1536.S05.BufferField020D.result_frame
#print axioms FT1536.S05.BufferField020D.result_frame
#check FT1536.S05.BufferField020D.update_holds
#print axioms FT1536.S05.BufferField020D.update_holds
#check FT1536.S05.BufferField020D.addAt_at
#print axioms FT1536.S05.BufferField020D.addAt_at
#check FT1536.S05.ScalarExpr020D.small_nat
#print axioms FT1536.S05.ScalarExpr020D.small_nat
#check FT1536.S05.ScalarExpr020D.nat_lt
#print axioms FT1536.S05.ScalarExpr020D.nat_lt
#check FT1536.S05.ScalarExpr020D.nat_sub
#print axioms FT1536.S05.ScalarExpr020D.nat_sub
#check FT1536.S05.ScalarExpr020D.negate_field
#print axioms FT1536.S05.ScalarExpr020D.negate_field
#check FT1536.S05.ScalarExpr020D.inc_eval
#print axioms FT1536.S05.ScalarExpr020D.inc_eval
#check FT1536.S05.ScatterBranches020D.positive
#print axioms FT1536.S05.ScatterBranches020D.positive
#check FT1536.S05.ScatterBranches020D.negative
#print axioms FT1536.S05.ScatterBranches020D.negative
#check FT1536.S05.ScatterBranches020D.branches_correct
#print axioms FT1536.S05.ScatterBranches020D.branches_correct
#check FT1536.S05.IndexReference020D.term_even
#print axioms FT1536.S05.IndexReference020D.term_even
#check FT1536.S05.IndexReference020D.term_odd
#print axioms FT1536.S05.IndexReference020D.term_odd
#check FT1536.S05.IndexReference020D.index_term
#print axioms FT1536.S05.IndexReference020D.index_term
#check FT1536.S05.IndexReference020D.term_index
#print axioms FT1536.S05.IndexReference020D.term_index
#check FT1536.S05.IndexReference020D.exponent_eq
#print axioms FT1536.S05.IndexReference020D.exponent_eq
#check FT1536.S05.IndexReference020D.coefficient_eq
#print axioms FT1536.S05.IndexReference020D.coefficient_eq
#check FT1536.S05.IndexReference020D.sum_term
#print axioms FT1536.S05.IndexReference020D.sum_term
#check FT1536.S05.DataWords020D.signed_bounds
#print axioms FT1536.S05.DataWords020D.signed_bounds
#check FT1536.S05.DataWords020D.half_words
#print axioms FT1536.S05.DataWords020D.half_words
#check FT1536.S05.DataWords020D.data_word
#print axioms FT1536.S05.DataWords020D.data_word
#check FT1536.S05.DataWords020D.coefficient_signed
#print axioms FT1536.S05.DataWords020D.coefficient_signed
#check FT1536.S05.ScatterRead020D.read_correct
#print axioms FT1536.S05.ScatterRead020D.read_correct
#check FT1536.S05.ScatterRead020D.result_exponent
#print axioms FT1536.S05.ScatterRead020D.result_exponent
#check FT1536.S05.ScatterRead020D.result_product
#print axioms FT1536.S05.ScatterRead020D.result_product
#check FT1536.S05.ScatterRead020D.result_other
#print axioms FT1536.S05.ScatterRead020D.result_other
#check FT1536.S05.ScatterRead020D.result_memory
#print axioms FT1536.S05.ScatterRead020D.result_memory
#check FT1536.S05.ScatterAlgebra020D.reduced_at
#print axioms FT1536.S05.ScatterAlgebra020D.reduced_at
#check FT1536.S05.ScatterTerm020D.term_shape
#print axioms FT1536.S05.ScatterTerm020D.term_shape
#check FT1536.S05.ScatterTerm020D.term_correct
#print axioms FT1536.S05.ScatterTerm020D.term_correct
#check FT1536.S05.ActualScatter020D.exponent_pair
#print axioms FT1536.S05.ActualScatter020D.exponent_pair
#check FT1536.S05.ActualScatter020D.term_correct
#print axioms FT1536.S05.ActualScatter020D.term_correct
#check FT1536.S05.ActualScatter020D.frame_image
#print axioms FT1536.S05.ActualScatter020D.frame_image
#check FT1536.S05.KeyWords020D.first_word
#print axioms FT1536.S05.KeyWords020D.first_word
#check FT1536.S05.KeyWords020D.second_word
#print axioms FT1536.S05.KeyWords020D.second_word
#check FT1536.S05.KeyWords020D.key_word
#print axioms FT1536.S05.KeyWords020D.key_word
#check FT1536.S05.ClearBuffer020D.body_run
#print axioms FT1536.S05.ClearBuffer020D.body_run
#check FT1536.S05.ClearBuffer020D.step
#print axioms FT1536.S05.ClearBuffer020D.step
#check FT1536.S05.ClearBuffer020D.loop_correct
#print axioms FT1536.S05.ClearBuffer020D.loop_correct
#check FT1536.S05.ClearBuffer020D.code_shape
#print axioms FT1536.S05.ClearBuffer020D.code_shape
#check FT1536.S05.ClearBuffer020D.code_correct
#print axioms FT1536.S05.ClearBuffer020D.code_correct
#check FT1536.S05.ClearBuffer020D.clear_correct
#print axioms FT1536.S05.ClearBuffer020D.clear_correct
#check FT1536.S05.ScatterSums020D.row_zero
#print axioms FT1536.S05.ScatterSums020D.row_zero
#check FT1536.S05.ScatterSums020D.outer_zero
#print axioms FT1536.S05.ScatterSums020D.outer_zero
#check FT1536.S05.ScatterSums020D.row_succ
#print axioms FT1536.S05.ScatterSums020D.row_succ
#check FT1536.S05.ScatterSums020D.outer_succ
#print axioms FT1536.S05.ScatterSums020D.outer_succ
#check FT1536.S05.ScatterSums020D.row_full
#print axioms FT1536.S05.ScatterSums020D.row_full
#check FT1536.S05.ScatterSums020D.outer_full
#print axioms FT1536.S05.ScatterSums020D.outer_full
#check FT1536.S05.ScatterSums020D.original_multiply
#print axioms FT1536.S05.ScatterSums020D.original_multiply
#check FT1536.S05.ScatterRow020D.step
#print axioms FT1536.S05.ScatterRow020D.step
#check FT1536.S05.ScatterRow020D.loop_correct
#print axioms FT1536.S05.ScatterRow020D.loop_correct
#check FT1536.S05.ScatterRow020D.code_shape
#print axioms FT1536.S05.ScatterRow020D.code_shape
#check FT1536.S05.ScatterRow020D.code_correct
#print axioms FT1536.S05.ScatterRow020D.code_correct
#check FT1536.S05.RowStart020D.run_correct
#print axioms FT1536.S05.RowStart020D.run_correct
#check FT1536.S05.RowStart020D.result_key
#print axioms FT1536.S05.RowStart020D.result_key
#check FT1536.S05.RowStart020D.result_exponent
#print axioms FT1536.S05.RowStart020D.result_exponent
#check FT1536.S05.RowStart020D.result_counter
#print axioms FT1536.S05.RowStart020D.result_counter
#check FT1536.S05.RowStart020D.result_memory
#print axioms FT1536.S05.RowStart020D.result_memory
#check FT1536.S05.MultiplyRow020D.bodyN_shape
#print axioms FT1536.S05.MultiplyRow020D.bodyN_shape
#check FT1536.S05.MultiplyRow020D.bodyN_correct
#print axioms FT1536.S05.MultiplyRow020D.bodyN_correct
#check FT1536.S05.MultiplyRow020D.body_correct
#print axioms FT1536.S05.MultiplyRow020D.body_correct
#check FT1536.S05.BufferTransport020D.holds_congr
#print axioms FT1536.S05.BufferTransport020D.holds_congr
#check FT1536.S05.MultiplyLoop020D.step
#print axioms FT1536.S05.MultiplyLoop020D.step
#check FT1536.S05.MultiplyLoop020D.loop_correct
#print axioms FT1536.S05.MultiplyLoop020D.loop_correct
#check FT1536.S05.MultiplyLoop020D.code_shape
#print axioms FT1536.S05.MultiplyLoop020D.code_shape
#check FT1536.S05.MultiplyLoop020D.code_correct
#print axioms FT1536.S05.MultiplyLoop020D.code_correct
#check FT1536.S05.MultiplyLoop020D.multiply_shape
#print axioms FT1536.S05.MultiplyLoop020D.multiply_shape
#check FT1536.S05.MultiplyLoop020D.multiply_outer
#print axioms FT1536.S05.MultiplyLoop020D.multiply_outer
#check FT1536.S05.MultiplyLoop020D.multiply_correct
#print axioms FT1536.S05.MultiplyLoop020D.multiply_correct
#check FT1536.S05.OutputSlice020D.write_nil
#print axioms FT1536.S05.OutputSlice020D.write_nil
#check FT1536.S05.OutputSlice020D.write_at
#print axioms FT1536.S05.OutputSlice020D.write_at
#check FT1536.S05.OutputSlice020D.write_other
#print axioms FT1536.S05.OutputSlice020D.write_other
#check FT1536.S05.OutputSlice020D.write_cons
#print axioms FT1536.S05.OutputSlice020D.write_cons
#check FT1536.S05.EmitStep020D.exec_emit
#print axioms FT1536.S05.EmitStep020D.exec_emit
#check FT1536.S05.EmitStep020D.low_bit
#print axioms FT1536.S05.EmitStep020D.low_bit
#check FT1536.S05.EmitStep020D.body_correct
#print axioms FT1536.S05.EmitStep020D.body_correct
#check FT1536.S05.EmitStep020D.result_remaining
#print axioms FT1536.S05.EmitStep020D.result_remaining
#check FT1536.S05.EmitStep020D.result_value
#print axioms FT1536.S05.EmitStep020D.result_value
#check FT1536.S05.EmitStep020D.result_cursor
#print axioms FT1536.S05.EmitStep020D.result_cursor
#check FT1536.S05.EmitStep020D.result_frame
#print axioms FT1536.S05.EmitStep020D.result_frame
#check FT1536.S05.EmitStep020D.result_other
#print axioms FT1536.S05.EmitStep020D.result_other
#check FT1536.S05.EmitWord020D.guard_positive
#print axioms FT1536.S05.EmitWord020D.guard_positive
#check FT1536.S05.EmitWord020D.loop_correct
#print axioms FT1536.S05.EmitWord020D.loop_correct
#check FT1536.S05.EmitWord020D.code_shape
#print axioms FT1536.S05.EmitWord020D.code_shape
#check FT1536.S05.EmitWord020D.emitWord_correct
#print axioms FT1536.S05.EmitWord020D.emitWord_correct
#check FT1536.S05.OutputValues020D.reply_shift
#print axioms FT1536.S05.OutputValues020D.reply_shift
#check FT1536.S05.OutputValues020D.reply_bound
#print axioms FT1536.S05.OutputValues020D.reply_bound
#check FT1536.S05.OutputValues020D.sum_coefficient
#print axioms FT1536.S05.OutputValues020D.sum_coefficient
#check FT1536.S05.OutputValues020D.vector_coefficient
#print axioms FT1536.S05.OutputValues020D.vector_coefficient
#check FT1536.S05.OutputValues020D.key_save
#print axioms FT1536.S05.OutputValues020D.key_save
#check FT1536.S05.OutputValues020D.challenge_view
#print axioms FT1536.S05.OutputValues020D.challenge_view
#check FT1536.S05.OutputValues020D.key_reference
#print axioms FT1536.S05.OutputValues020D.key_reference
#check FT1536.S05.OutputChunks020D.prefix_zero
#print axioms FT1536.S05.OutputChunks020D.prefix_zero
#check FT1536.S05.OutputChunks020D.frame_refl
#print axioms FT1536.S05.OutputChunks020D.frame_refl
#check FT1536.S05.OutputChunks020D.frame_trans
#print axioms FT1536.S05.OutputChunks020D.frame_trans
#check FT1536.S05.OutputChunks020D.end_bound
#print axioms FT1536.S05.OutputChunks020D.end_bound
#check FT1536.S05.OutputChunks020D.prefix_step
#print axioms FT1536.S05.OutputChunks020D.prefix_step
#check FT1536.S05.OutputChunks020D.write_frame
#print axioms FT1536.S05.OutputChunks020D.write_frame
#check FT1536.S05.EmitRead020D.key_run
#print axioms FT1536.S05.EmitRead020D.key_run
#check FT1536.S05.EmitRead020D.key_fields
#print axioms FT1536.S05.EmitRead020D.key_fields
#check FT1536.S05.EmitRead020D.reply_run
#print axioms FT1536.S05.EmitRead020D.reply_run
#check FT1536.S05.EmitRead020D.reply_fields
#print axioms FT1536.S05.EmitRead020D.reply_fields
#check FT1536.S05.EmitEntry020D.shape
#print axioms FT1536.S05.EmitEntry020D.shape
#check FT1536.S05.EmitEntry020D.from_prefix
#print axioms FT1536.S05.EmitEntry020D.from_prefix
#check FT1536.S05.OutputLoop020D.frame_refl
#print axioms FT1536.S05.OutputLoop020D.frame_refl
#check FT1536.S05.OutputLoop020D.frame_trans
#print axioms FT1536.S05.OutputLoop020D.frame_trans
#check FT1536.S05.OutputLoop020D.step
#print axioms FT1536.S05.OutputLoop020D.step
#check FT1536.S05.OutputLoop020D.loop_correct
#print axioms FT1536.S05.OutputLoop020D.loop_correct
#check FT1536.S05.OutputLoop020D.code_shape
#print axioms FT1536.S05.OutputLoop020D.code_shape
#check FT1536.S05.OutputLoop020D.code_correct
#print axioms FT1536.S05.OutputLoop020D.code_correct
#check FT1536.S05.ActualEmitEntry020D.readVec_ram
#print axioms FT1536.S05.ActualEmitEntry020D.readVec_ram
#check FT1536.S05.ActualEmitEntry020D.key_step
#print axioms FT1536.S05.ActualEmitEntry020D.key_step
#check FT1536.S05.ActualEmitEntry020D.reply_step
#print axioms FT1536.S05.ActualEmitEntry020D.reply_step
#check FT1536.S05.EmitTag020D.run_correct
#print axioms FT1536.S05.EmitTag020D.run_correct
#check FT1536.S05.EmitTag020D.tag_true
#print axioms FT1536.S05.EmitTag020D.tag_true
#check FT1536.S05.EmitTag020D.other
#print axioms FT1536.S05.EmitTag020D.other
#check FT1536.S05.EmitTag020D.cursor
#print axioms FT1536.S05.EmitTag020D.cursor
#check FT1536.S05.EmitTag020D.frame
#print axioms FT1536.S05.EmitTag020D.frame
#check FT1536.S05.OutputFormat020D.encode_ofFn
#print axioms FT1536.S05.OutputFormat020D.encode_ofFn
#check FT1536.S05.OutputFormat020D.paired_region
#print axioms FT1536.S05.OutputFormat020D.paired_region
#check FT1536.S05.OutputFormat020D.split_fn
#print axioms FT1536.S05.OutputFormat020D.split_fn
#check FT1536.S05.OutputFormat020D.split_output
#print axioms FT1536.S05.OutputFormat020D.split_output
#check FT1536.S05.EmitLoops020D.key_shape
#print axioms FT1536.S05.EmitLoops020D.key_shape
#check FT1536.S05.EmitLoops020D.key_correct
#print axioms FT1536.S05.EmitLoops020D.key_correct
#check FT1536.S05.EmitLoops020D.reply_correct
#print axioms FT1536.S05.EmitLoops020D.reply_correct
#check FT1536.S05.EmitLoops020D.emit_shape
#print axioms FT1536.S05.EmitLoops020D.emit_shape
#check FT1536.S05.EncodedOutput020D.key_region
#print axioms FT1536.S05.EncodedOutput020D.key_region
#check FT1536.S05.EncodedOutput020D.reply_even
#print axioms FT1536.S05.EncodedOutput020D.reply_even
#check FT1536.S05.EncodedOutput020D.reply_odd
#print axioms FT1536.S05.EncodedOutput020D.reply_odd
#check FT1536.S05.EncodedOutput020D.reply_region
#print axioms FT1536.S05.EncodedOutput020D.reply_region
#check FT1536.S05.EncodedOutput020D.encode_correct
#print axioms FT1536.S05.EncodedOutput020D.encode_correct
#check FT1536.S05.EmitPredicates020D.combine
#print axioms FT1536.S05.EmitPredicates020D.combine
#check FT1536.S05.EmitPredicates020D.after_key
#print axioms FT1536.S05.EmitPredicates020D.after_key
#check FT1536.S05.EmitPredicates020D.emit_correct
#print axioms FT1536.S05.EmitPredicates020D.emit_correct
#check FT1536.S05.ActualEmit020D.from_post
#print axioms FT1536.S05.ActualEmit020D.from_post
#check FT1536.S05.ActualEmit020D.emit_correct
#print axioms FT1536.S05.ActualEmit020D.emit_correct
#check FT1536.S05.WireFormat020D.list_fixed
#print axioms FT1536.S05.WireFormat020D.list_fixed
#check FT1536.S05.WireFormat020D.wire_list
#print axioms FT1536.S05.WireFormat020D.wire_list
#check FT1536.S05.WireFormat020D.wire_injective
#print axioms FT1536.S05.WireFormat020D.wire_injective
#check FT1536.S05.WireFormat020D.of_list
#print axioms FT1536.S05.WireFormat020D.of_list
#check FT1536.S05.ProgramRefinement020D.after_select
#print axioms FT1536.S05.ProgramRefinement020D.after_select
#check FT1536.S05.ProgramRefinement020D.three_stages
#print axioms FT1536.S05.ProgramRefinement020D.three_stages
#check FT1536.S05.ProgramRefinement020D.program_shape
#print axioms FT1536.S05.ProgramRefinement020D.program_shape
#check FT1536.S05.ProgramRefinement020D.program_correct
#print axioms FT1536.S05.ProgramRefinement020D.program_correct
#check FT1536.S05.ProgramRefinement020D.from_initial
#print axioms FT1536.S05.ProgramRefinement020D.from_initial
#check FT1536.S05.ProgramRefinement020D.every_tape
#print axioms FT1536.S05.ProgramRefinement020D.every_tape
#check FT1536.S05.ProgramRefinement020D.public_initial_with_cost
#print axioms FT1536.S05.ProgramRefinement020D.public_initial_with_cost
#check FT1536.S05.MachineStateBridge020D.result_eq
#print axioms FT1536.S05.MachineStateBridge020D.result_eq
#check FT1536.S05.MachineLaw020D.code_eq
#print axioms FT1536.S05.MachineLaw020D.code_eq
#check FT1536.S05.MachineLaw020D.law_eq
#print axioms FT1536.S05.MachineLaw020D.law_eq
#check FT1536.S05.MachineLaw020D.certificate_transport
#print axioms FT1536.S05.MachineLaw020D.certificate_transport
#check FT1536.S05.MachineLaw020D.all_states_same_law
#print axioms FT1536.S05.MachineLaw020D.all_states_same_law
#check FT1536.S05.MachineCertificate020D.all_h_ac
#print axioms FT1536.S05.MachineCertificate020D.all_h_ac
#check FT1536.S05.MachineCertificate020D.actual_certificate
#print axioms FT1536.S05.MachineCertificate020D.actual_certificate
#check FT1536.S05.MachineCertificate020D.public_initial
#print axioms FT1536.S05.MachineCertificate020D.public_initial
#check FT1536.S05.MachineCertificate020D.same_key_law
#print axioms FT1536.S05.MachineCertificate020D.same_key_law
