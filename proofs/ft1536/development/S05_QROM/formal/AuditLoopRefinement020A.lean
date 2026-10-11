import ReadSemantics020A
import BitValue020A
import ReadWordStep020A
import ReadWordLoop020A
import ReadWordCorrect020A
import ReadWordSites020A
import SearchBounds020A
import CdfPrefix020A
import CdfStep020A
import CdfLoop020A
import CoordinateCorrect020A
import ActualCoordinate020A

#check FT1536.S05.ReadSemantics020A.eval_lit
#print axioms FT1536.S05.ReadSemantics020A.eval_lit
#check FT1536.S05.ReadSemantics020A.eval_reg
#print axioms FT1536.S05.ReadSemantics020A.eval_reg
#check FT1536.S05.ReadSemantics020A.eval_bin
#print axioms FT1536.S05.ReadSemantics020A.eval_bin
#check FT1536.S05.ReadSemantics020A.exec_set
#print axioms FT1536.S05.ReadSemantics020A.exec_set
#check FT1536.S05.ReadSemantics020A.exec_seq
#print axioms FT1536.S05.ReadSemantics020A.exec_seq
#check FT1536.S05.ReadSemantics020A.put_self
#print axioms FT1536.S05.ReadSemantics020A.put_self
#check FT1536.S05.ReadSemantics020A.exec_skip
#print axioms FT1536.S05.ReadSemantics020A.exec_skip
#check FT1536.S05.ReadSemantics020A.exec_seqs_nil
#print axioms FT1536.S05.ReadSemantics020A.exec_seqs_nil
#check FT1536.S05.ReadSemantics020A.exec_seqs_cons
#print axioms FT1536.S05.ReadSemantics020A.exec_seqs_cons
#check FT1536.S05.ReadSemantics020A.exec_bit
#print axioms FT1536.S05.ReadSemantics020A.exec_bit
#check FT1536.S05.ReadSemantics020A.iterate_erasure
#print axioms FT1536.S05.ReadSemantics020A.iterate_erasure
#check FT1536.S05.ReadSemantics020A.exec_loop
#print axioms FT1536.S05.ReadSemantics020A.exec_loop
#check FT1536.S05.ReadSemantics020A.eval_of_agree
#print axioms FT1536.S05.ReadSemantics020A.eval_of_agree
#check FT1536.S05.ReadSemantics020A.eval_put
#print axioms FT1536.S05.ReadSemantics020A.eval_put
#check FT1536.S05.ReadSemantics020A.frame_refl
#print axioms FT1536.S05.ReadSemantics020A.frame_refl
#check FT1536.S05.ReadSemantics020A.frame_trans
#print axioms FT1536.S05.ReadSemantics020A.frame_trans
#check FT1536.S05.ReadSemantics020A.frame_put
#print axioms FT1536.S05.ReadSemantics020A.frame_put
#check FT1536.S05.BitValue020A.bit_le
#print axioms FT1536.S05.BitValue020A.bit_le
#check FT1536.S05.BitValue020A.value_lt
#print axioms FT1536.S05.BitValue020A.value_lt
#check FT1536.S05.BitValue020A.value_snoc
#print axioms FT1536.S05.BitValue020A.value_snoc
#check FT1536.S05.BitValue020A.reference_value
#print axioms FT1536.S05.BitValue020A.reference_value
#check FT1536.S05.BitValue020A.tapeBits_at
#print axioms FT1536.S05.BitValue020A.tapeBits_at
#check FT1536.S05.BitValue020A.nat_fits
#print axioms FT1536.S05.BitValue020A.nat_fits
#check FT1536.S05.BitValue020A.tiny_fits
#print axioms FT1536.S05.BitValue020A.tiny_fits
#check FT1536.S05.ReadWordStep020A.body_step
#print axioms FT1536.S05.ReadWordStep020A.body_step
#check FT1536.S05.ReadWordLoop020A.body_frame
#print axioms FT1536.S05.ReadWordLoop020A.body_frame
#check FT1536.S05.ReadWordLoop020A.guard_positive
#print axioms FT1536.S05.ReadWordLoop020A.guard_positive
#check FT1536.S05.ReadWordLoop020A.loop_correct
#print axioms FT1536.S05.ReadWordLoop020A.loop_correct
#check FT1536.S05.ReadWordCorrect020A.program_shape
#print axioms FT1536.S05.ReadWordCorrect020A.program_shape
#check FT1536.S05.ReadWordCorrect020A.readWord_correct
#print axioms FT1536.S05.ReadWordCorrect020A.readWord_correct
#check FT1536.S05.ReadWordCorrect020A.readWord_reference
#print axioms FT1536.S05.ReadWordCorrect020A.readWord_reference
#check FT1536.S05.ReadWordCorrect020A.readWord_no_new_fault
#print axioms FT1536.S05.ReadWordCorrect020A.readWord_no_new_fault
#check FT1536.S05.ReadWordSites020A.register_base
#print axioms FT1536.S05.ReadWordSites020A.register_base
#check FT1536.S05.ReadWordSites020A.offset_base
#print axioms FT1536.S05.ReadWordSites020A.offset_base
#check FT1536.S05.ReadWordSites020A.unsigned_result
#print axioms FT1536.S05.ReadWordSites020A.unsigned_result
#check FT1536.S05.SearchBounds020A.interval_step
#print axioms FT1536.S05.SearchBounds020A.interval_step
#check FT1536.S05.SearchBounds020A.search_interval
#print axioms FT1536.S05.SearchBounds020A.search_interval
#check FT1536.S05.SearchBounds020A.initial_search_bound
#print axioms FT1536.S05.SearchBounds020A.initial_search_bound
#check FT1536.S05.CdfPrefix020A.exec_branch
#print axioms FT1536.S05.CdfPrefix020A.exec_branch
#check FT1536.S05.CdfPrefix020A.exec_rom
#print axioms FT1536.S05.CdfPrefix020A.exec_rom
#check FT1536.S05.CdfPrefix020A.prefix_correct
#print axioms FT1536.S05.CdfPrefix020A.prefix_correct
#check FT1536.S05.CdfStep020A.seqs_append
#print axioms FT1536.S05.CdfStep020A.seqs_append
#check FT1536.S05.CdfStep020A.body_run
#print axioms FT1536.S05.CdfStep020A.body_run
#check FT1536.S05.CdfStep020A.body_correct
#print axioms FT1536.S05.CdfStep020A.body_correct
#check FT1536.S05.CdfLoop020A.next_bound
#print axioms FT1536.S05.CdfLoop020A.next_bound
#check FT1536.S05.CdfLoop020A.reference_step
#print axioms FT1536.S05.CdfLoop020A.reference_step
#check FT1536.S05.CdfLoop020A.guard_nonzero
#print axioms FT1536.S05.CdfLoop020A.guard_nonzero
#check FT1536.S05.CdfLoop020A.loop_correct
#print axioms FT1536.S05.CdfLoop020A.loop_correct
#check FT1536.S05.CoordinateCorrect020A.program_shape
#print axioms FT1536.S05.CoordinateCorrect020A.program_shape
#check FT1536.S05.CoordinateCorrect020A.clamp_correct
#print axioms FT1536.S05.CoordinateCorrect020A.clamp_correct
#check FT1536.S05.CoordinateCorrect020A.outside_ne
#print axioms FT1536.S05.CoordinateCorrect020A.outside_ne
#check FT1536.S05.CoordinateCorrect020A.coordinate_correct
#print axioms FT1536.S05.CoordinateCorrect020A.coordinate_correct
#check FT1536.S05.ActualCoordinate020A.cdf_at
#print axioms FT1536.S05.ActualCoordinate020A.cdf_at
#check FT1536.S05.ActualCoordinate020A.actual_image
#print axioms FT1536.S05.ActualCoordinate020A.actual_image
#check FT1536.S05.ActualCoordinate020A.actual_width
#print axioms FT1536.S05.ActualCoordinate020A.actual_width
#check FT1536.S05.ActualCoordinate020A.result_eq_coord
#print axioms FT1536.S05.ActualCoordinate020A.result_eq_coord
#check FT1536.S05.ActualCoordinate020A.actual_coordinate
#print axioms FT1536.S05.ActualCoordinate020A.actual_coordinate
