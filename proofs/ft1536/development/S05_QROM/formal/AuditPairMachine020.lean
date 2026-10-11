import PairEncodingInjective020
import WordRAM020
import PairProgram020
import ProgramCost020
import InputLayout020
import MemoryFrames020
import TapeLayout020
import PairEncoding020
import WordArithmetic020
import RefinementTarget020

#check FT1536.S05.WordRAM020.iterate_bound
#print axioms FT1536.S05.WordRAM020.iterate_bound
#check FT1536.S05.WordRAM020.run_bound
#print axioms FT1536.S05.WordRAM020.run_bound
#check FT1536.S05.WordRAM020.put_same
#print axioms FT1536.S05.WordRAM020.put_same
#check FT1536.S05.WordRAM020.put_other
#print axioms FT1536.S05.WordRAM020.put_other
#check FT1536.S05.WordRAM020.put_memory
#print axioms FT1536.S05.WordRAM020.put_memory
#check FT1536.S05.WordRAM020.word_exact
#print axioms FT1536.S05.WordRAM020.word_exact
#check FT1536.S05.WordRAM020.address_exact
#print axioms FT1536.S05.WordRAM020.address_exact
#check FT1536.S05.WordRAM020.initial_no_fault
#print axioms FT1536.S05.WordRAM020.initial_no_fault
#check FT1536.S05.PairProgram020.operational_bound
#print axioms FT1536.S05.PairProgram020.operational_bound
#check FT1536.S05.ProgramCost020.program_bound_value
#print axioms FT1536.S05.ProgramCost020.program_bound_value
#check FT1536.S05.ProgramCost020.program_nodes
#print axioms FT1536.S05.ProgramCost020.program_nodes
#check FT1536.S05.ProgramCost020.program_depth
#print axioms FT1536.S05.ProgramCost020.program_depth
#check FT1536.S05.ProgramCost020.finite_data_bits
#print axioms FT1536.S05.ProgramCost020.finite_data_bits
#check FT1536.S05.ProgramCost020.core_cost
#print axioms FT1536.S05.ProgramCost020.core_cost
#check FT1536.S05.ProgramCost020.core_cost_initial
#print axioms FT1536.S05.ProgramCost020.core_cost_initial
#check FT1536.S05.InputLayout020.tape_unchanged
#print axioms FT1536.S05.InputLayout020.tape_unchanged
#check FT1536.S05.InputLayout020.nat_word_exact
#print axioms FT1536.S05.InputLayout020.nat_word_exact
#check FT1536.S05.InputLayout020.cdf_exact
#print axioms FT1536.S05.InputLayout020.cdf_exact
#check FT1536.S05.InputLayout020.threshold_exact
#print axioms FT1536.S05.InputLayout020.threshold_exact
#check FT1536.S05.InputLayout020.key_first_exact
#print axioms FT1536.S05.InputLayout020.key_first_exact
#check FT1536.S05.InputLayout020.key_second_exact
#print axioms FT1536.S05.InputLayout020.key_second_exact
#check FT1536.S05.InputLayout020.fresh_suffix
#print axioms FT1536.S05.InputLayout020.fresh_suffix
#check FT1536.S05.InputLayout020.trialAddress_injective
#print axioms FT1536.S05.InputLayout020.trialAddress_injective
#check FT1536.S05.InputLayout020.cubeAddress_injective
#print axioms FT1536.S05.InputLayout020.cubeAddress_injective
#check FT1536.S05.MemoryFrames020.store_step
#print axioms FT1536.S05.MemoryFrames020.store_step
#check FT1536.S05.MemoryFrames020.emit_step
#print axioms FT1536.S05.MemoryFrames020.emit_step
#check FT1536.S05.MemoryFrames020.rom_step
#print axioms FT1536.S05.MemoryFrames020.rom_step
#check FT1536.S05.MemoryFrames020.ram_step
#print axioms FT1536.S05.MemoryFrames020.ram_step
#check FT1536.S05.MemoryFrames020.bit_step
#print axioms FT1536.S05.MemoryFrames020.bit_step
#check FT1536.S05.MemoryFrames020.store_frame
#print axioms FT1536.S05.MemoryFrames020.store_frame
#check FT1536.S05.MemoryFrames020.store_read_same
#print axioms FT1536.S05.MemoryFrames020.store_read_same
#check FT1536.S05.MemoryFrames020.store_read_other
#print axioms FT1536.S05.MemoryFrames020.store_read_other
#check FT1536.S05.MemoryFrames020.emit_frame
#print axioms FT1536.S05.MemoryFrames020.emit_frame
#check FT1536.S05.MemoryFrames020.load_rom
#print axioms FT1536.S05.MemoryFrames020.load_rom
#check FT1536.S05.MemoryFrames020.load_ram
#print axioms FT1536.S05.MemoryFrames020.load_ram
#check FT1536.S05.MemoryFrames020.load_bit
#print axioms FT1536.S05.MemoryFrames020.load_bit
#check FT1536.S05.MemoryFrames020.invalid_store_fault
#print axioms FT1536.S05.MemoryFrames020.invalid_store_fault
#check FT1536.S05.MemoryFrames020.invalid_load_fault
#print axioms FT1536.S05.MemoryFrames020.invalid_load_fault
#check FT1536.S05.MemoryFrames020.atom_fault_sticky
#print axioms FT1536.S05.MemoryFrames020.atom_fault_sticky
#check FT1536.S05.MemoryFrames020.iterate_fault_sticky
#print axioms FT1536.S05.MemoryFrames020.iterate_fault_sticky
#check FT1536.S05.MemoryFrames020.fault_sticky
#print axioms FT1536.S05.MemoryFrames020.fault_sticky
#check FT1536.S05.TapeLayout020.split_left
#print axioms FT1536.S05.TapeLayout020.split_left
#check FT1536.S05.TapeLayout020.split_right
#print axioms FT1536.S05.TapeLayout020.split_right
#check FT1536.S05.TapeLayout020.chunks_apply
#print axioms FT1536.S05.TapeLayout020.chunks_apply
#check FT1536.S05.TapeLayout020.first_word_address
#print axioms FT1536.S05.TapeLayout020.first_word_address
#check FT1536.S05.TapeLayout020.second_word_address
#print axioms FT1536.S05.TapeLayout020.second_word_address
#check FT1536.S05.TapeLayout020.accept_word_address
#print axioms FT1536.S05.TapeLayout020.accept_word_address
#check FT1536.S05.TapeLayout020.right_first_word_address
#print axioms FT1536.S05.TapeLayout020.right_first_word_address
#check FT1536.S05.TapeLayout020.right_second_word_address
#print axioms FT1536.S05.TapeLayout020.right_second_word_address
#check FT1536.S05.TapeLayout020.right_accept_word_address
#print axioms FT1536.S05.TapeLayout020.right_accept_word_address
#check FT1536.S05.TapeLayout020.cube_first_word_address
#print axioms FT1536.S05.TapeLayout020.cube_first_word_address
#check FT1536.S05.TapeLayout020.cube_second_word_address
#print axioms FT1536.S05.TapeLayout020.cube_second_word_address
#check FT1536.S05.TapeLayout020.cube_right_first_word_address
#print axioms FT1536.S05.TapeLayout020.cube_right_first_word_address
#check FT1536.S05.TapeLayout020.cube_right_second_word_address
#print axioms FT1536.S05.TapeLayout020.cube_right_second_word_address
#check FT1536.S05.PairEncoding020.keyCell_length
#print axioms FT1536.S05.PairEncoding020.keyCell_length
#check FT1536.S05.PairEncoding020.replyCell_length
#print axioms FT1536.S05.PairEncoding020.replyCell_length
#check FT1536.S05.PairEncoding020.flatten_fixed_length
#print axioms FT1536.S05.PairEncoding020.flatten_fixed_length
#check FT1536.S05.PairEncoding020.keyBits_length
#print axioms FT1536.S05.PairEncoding020.keyBits_length
#check FT1536.S05.PairEncoding020.replyBits_length
#print axioms FT1536.S05.PairEncoding020.replyBits_length
#check FT1536.S05.PairEncoding020.full_pair_length
#print axioms FT1536.S05.PairEncoding020.full_pair_length
#check FT1536.S05.PairEncoding020.no_failure_erasure
#print axioms FT1536.S05.PairEncoding020.no_failure_erasure
#check FT1536.S05.PairEncoding020.field_word_exact
#print axioms FT1536.S05.PairEncoding020.field_word_exact
#check FT1536.S05.PairEncoding020.box_word_exact
#print axioms FT1536.S05.PairEncoding020.box_word_exact
#check FT1536.S05.WordArithmetic020.decode_word
#print axioms FT1536.S05.WordArithmetic020.decode_word
#check FT1536.S05.WordArithmetic020.add_word
#print axioms FT1536.S05.WordArithmetic020.add_word
#check FT1536.S05.WordArithmetic020.sub_word
#print axioms FT1536.S05.WordArithmetic020.sub_word
#check FT1536.S05.WordArithmetic020.mul_word
#print axioms FT1536.S05.WordArithmetic020.mul_word
#check FT1536.S05.WordArithmetic020.div_word
#print axioms FT1536.S05.WordArithmetic020.div_word
#check FT1536.S05.WordArithmetic020.mod_word
#print axioms FT1536.S05.WordArithmetic020.mod_word
#check FT1536.S05.WordArithmetic020.lt_word
#print axioms FT1536.S05.WordArithmetic020.lt_word
#check FT1536.S05.WordArithmetic020.small_fits
#print axioms FT1536.S05.WordArithmetic020.small_fits
#check FT1536.S05.WordArithmetic020.read_accumulator_bound
#print axioms FT1536.S05.WordArithmetic020.read_accumulator_bound
#check FT1536.S05.WordArithmetic020.canonical_remainder
#print axioms FT1536.S05.WordArithmetic020.canonical_remainder
#check FT1536.S05.WordArithmetic020.scatter_scalar_bound
#print axioms FT1536.S05.WordArithmetic020.scatter_scalar_bound
#check FT1536.S05.RefinementTarget020.public_initial_no_fault
#print axioms FT1536.S05.RefinementTarget020.public_initial_no_fault
#check FT1536.S05.RefinementTarget020.EveryTape
#check FT1536.S05.PairEncodingInjective020.flatten_injective
#print axioms FT1536.S05.PairEncodingInjective020.flatten_injective
#check FT1536.S05.PairEncodingInjective020.keyCell_injective
#print axioms FT1536.S05.PairEncodingInjective020.keyCell_injective
#check FT1536.S05.PairEncodingInjective020.replyCell_injective
#print axioms FT1536.S05.PairEncodingInjective020.replyCell_injective
#check FT1536.S05.PairEncodingInjective020.keyBits_injective
#print axioms FT1536.S05.PairEncodingInjective020.keyBits_injective
#check FT1536.S05.PairEncodingInjective020.replyBits_injective
#print axioms FT1536.S05.PairEncodingInjective020.replyBits_injective
#check FT1536.S05.PairEncodingInjective020.full_pair_injective
#print axioms FT1536.S05.PairEncodingInjective020.full_pair_injective
