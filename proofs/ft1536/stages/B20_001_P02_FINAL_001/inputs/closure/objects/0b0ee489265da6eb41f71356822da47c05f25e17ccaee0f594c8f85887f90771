import Floor
import ValueDomain
import SourceFloor
import Proposal
import CDF
import OrderedResidual
import Comparator
import GuardPrefix
import ZeroRho
import BitErrors
import PackOf
import ErrorArithmetic
import RootDiv
import RootFrame
import RootBounds
import RootModel
import NodeInverse
import NodeDataflow
import NodeConstants
import Half
import TargetWords
import TargetAlgebra
import TargetFrame
import TargetSequence
import ReachOutcomes
import ReachFrame
import BankEnergy
import MetricTransport
import LeftClosure
set_option pp.universes true
#print axioms H3Range.p2_mono
#print axioms H3Range.mant_bounds
#print axioms H3Range.p2_shift
#print axioms H3Range.normal_floor_refinement
#print axioms H3Range.subnormal_floor_refinement
#print axioms H3Range.floor_refinement
#print axioms H3Range.negative_zero_exception
#print axioms H3Range.signed_zero_guard
#print axioms H3Range.integer_safety
#print axioms H3Range.negative_zero_sum_still_safe
#print axioms H3Range.conditional_H3_local
#print axioms ZeroScalar.p2_pos
#print axioms ZeroScalar.D_pos
#print axioms ZeroScalar.p2_add
#print axioms ZeroScalar.frac_bound
#print axioms ZeroScalar.exponent_from_value
#print axioms ZeroScalar.floorVal_old
#print axioms ZeroScalar.floorVal_range
#print axioms ZeroScalar.negzero_fields
#print axioms ZeroScalar.zero_aware_parts
#print axioms ZeroScalar.raw_mantissa
#print axioms ZeroScalar.raw_mantissa_int
#print axioms ZeroScalar.floorC_parts
#print axioms ZeroScalar.FLOOR_ZERO
#print axioms ZeroScalar.source_floor_range
#print axioms ZeroScalar.C_INT_BRIDGE
#print axioms H3Range.scan_bound
#print axioms H3Range.max_at_zero
#print axioms H3Range.select_found
#print axioms H3Range.select_bound
#print axioms H3Range.proposal_support
#print axioms H3Range.proposal_return_safe
#print axioms H3Range.bank0_size
#print axioms H3Range.bank0_max
#print axioms H3Range.bank0_support
#print axioms H3Range.bank1_size
#print axioms H3Range.bank1_max
#print axioms H3Range.bank1_support
#print axioms H3Range.bank2_size
#print axioms H3Range.bank2_max
#print axioms H3Range.bank2_support
#print axioms H3Range.bank3_size
#print axioms H3Range.bank3_max
#print axioms H3Range.bank3_support
#print axioms H3Range.bank4_size
#print axioms H3Range.bank4_max
#print axioms H3Range.bank4_support
#print axioms H3Range.all_bank_support
#print axioms H3Range.scalar_residual
#print axioms H3Range.terminal_right_then_left
#print axioms H3Range.next_terminal_center
#print axioms H3Range.safe_next_center
#print axioms H3Range.inner_visits_count
#print axioms H3Range.actual_3072_calls
#print axioms H3Range.first_terminal_right_first
#print axioms H3Range.checked_key_coefficients
#print axioms H3Range.lt64_correct
#print axioms H3Range.eq64_correct
#print axioms H3Range.lt128_correct
#print axioms H3Range.active_guards
#print axioms H3Range.sticky_path
#print axioms H3Range.negative_zero_admitted
#print axioms H3Range.guards_do_not_imply_floor_refinement
#print axioms H3Range.complete_local_lift
#print axioms ZeroScalar.value_negative_zero
#print axioms ZeroScalar.RHO_CLOSED
#print axioms ZeroScalar.EXACT_RESIDUAL_366
#print axioms ZeroScalar.old_new_relation
#print axioms ZeroScalar.old_floor_equality
#print axioms ZeroScalar.old_implies_numeric
#print axioms ZeroScalar.or_one_bounds
#print axioms ZeroScalar.sticky_cases
#print axioms ZeroScalar.sticky_interval
#print axioms ZeroScalar.round_error
#print axioms ZeroScalar.normalizer_bounds
#print axioms ZeroScalar.normalizer_for_add
#print axioms ZeroScalar.shrink9_range
#print axioms ZeroScalar.pack_normal_value
#print axioms ZeroScalar.round_normal_range
#print axioms ZeroScalar.norm_small_shift
#print axioms ZeroScalar.sticky_multiple
#print axioms ZeroScalar.OF_EXACT
#print axioms ZeroScalar.error_rational
#print axioms ZeroScalar.error_budget_numeric
#print axioms ZeroScalar.phase_scale_bound
#print axioms ZeroScalar.error_budget_composition
#print axioms ZeroScalar.MACHINE_RESIDUAL_366
#print axioms ZeroScalar.MACHINE_CENTER_INTERVAL
#print axioms ZeroScalar.ORDERED_ZERO_TERMINAL
#print axioms RootLDL.step_range
#print axioms RootLDL.step_invariant
#print axioms RootLDL.loop_range
#print axioms RootLDL.loop_invariant
#print axioms RootLDL.loop55
#print axioms RootLDL.store_frame
#print axioms RootLDL.root_frame
#print axioms RootLDL.root_layout
#print axioms RootLDL.fft_partition
#print axioms RootLDL.ternary_store
#print axioms RootLDL.coefficient_test
#print axioms RootLDL.positive_margin
#print axioms RootLDL.machine_schur_consumer
#print axioms RootLDL.imaginary_consumer
#print axioms RootLDL.no_overflow_primitive_scale
#print axioms RootLDL.zero_domain_not_root_domain
#print axioms RootLDL.coefficient_reduction_bound
#print axioms Node3.inverse3_bits
#print axioms Node3.inverse3_units
#print axioms Node3.expanded_div_exponent
#print axioms Node3.normalization_indices
#print axioms Node3.real_slot_noninterference
#print axioms Node3.divReal_ignores_imag
#print axioms Node3.mulReal_ignores_imag
#print axioms Node3.selfadj_imag_store
#print axioms Node3.valid_c3
#print axioms Node3.branch0_round_margin
#print axioms Node3.branch1_round_margin
#print axioms Node3.quotient_domain
#print axioms Node3.safe_order
#print axioms Node2.half_bits
#print axioms Node2.half_fields
#print axioms Node2.half_value
#print axioms Node2.parts_error
#print axioms Node2.half_error_units
#print axioms Node2.finite_half
#print axioms Node2.half_endpoint_classes
#print axioms InitialTarget.one_word
#print axioms InitialTarget.q_word
#print axioms InitialTarget.ni_word
#print axioms InitialTarget.ni_fields
#print axioms InitialTarget.ni_value_scaled
#print axioms InitialTarget.reciprocal_error_numerator
#print axioms InitialTarget.reciprocal_interval
#print axioms InitialTarget.canonical_int_ranges
#print axioms InitialTarget.canonical_of_exact
#print axioms InitialTarget.hash_to_point_written_range
#print axioms InitialTarget.hash_to_point_uint16
#print axioms InitialTarget.rejection_limit
#print axioms InitialTarget.basis_determinant
#print axioms InitialTarget.target_numerator_identity
#print axioms InitialTarget.reduced_low_count
#print axioms InitialTarget.reduced_high_count
#print axioms InitialTarget.reduced_row_bound
#print axioms InitialTarget.gram_pair_identities
#print axioms InitialTarget.gram_pair_bounds
#print axioms InitialTarget.two_error_layers
#print axioms InitialTarget.inverse_eval_energy_transport
#print axioms InitialTarget.target_frame
#print axioms InitialTarget.prefix_offsets
#print axioms InitialTarget.buffers_and_future_pointers
#print axioms InitialTarget.target_read_write_indices
#print axioms InitialTarget.packed_indices
#print axioms InitialTarget.copy_disjoint
#print axioms InitialTarget.whole_key_frame
#print axioms InitialTarget.source_word_match
#print axioms InitialTarget.defined_prefix_from_local_domains
#print axioms OrderedReach.fault_sticky
#print axioms OrderedReach.clear_prefix
#print axioms OrderedReach.safe_normal_return
#print axioms OrderedReach.normal_residual_after_center
#print axioms OrderedReach.fault_zero_is_not_close
#print axioms OrderedReach.normal_zero_distinct_tag
#print axioms OrderedReach.rejection_no_return
#print axioms OrderedReach.shifted_half_bound
#print axioms OrderedReach.next_center_needs_update
#print axioms OrderedReach.final_residual_after_unshift
#print axioms OrderedReach.right_margin
#print axioms OrderedReach.right_margin_constants
#print axioms OrderedReach.cutoff_counts
#print axioms OrderedReach.safe_shift
#print axioms OrderedReach.scalar_integer_products
#print axioms OrderedReach.key_and_root_target_frame
#print axioms OrderedReach.scratch_formula
#print axioms OrderedReach.root_peak
#print axioms OrderedReach.structural_calls
#print axioms OrderedReach.right_and_whole_counts
#print axioms OrderedReach.terminal_inverse_identity
#print axioms OrderedReach.repeated_product_same_inputs
#print axioms OrderedReach.rounded_cancellation_requires_error
#print axioms LeftRoot.failed_bank_lower
#print axioms LeftRoot.passed_bank_upper
#print axioms LeftRoot.paired_three_quarters
#print axioms LeftRoot.A2_four
#print axioms LeftRoot.terminal_defect_identity
#print axioms LeftRoot.terminal_cross_expansion
#print axioms LeftRoot.half_last_defect
#print axioms LeftRoot.right_terminal_count
#print axioms LeftRoot.reverse_leaf_index
#print axioms LeftRoot.reverse_leaf_injective
#print axioms LeftRoot.square_roundoff_identity
#print axioms LeftRoot.form_congruence
#print axioms LeftRoot.form_scale
#print axioms LeftRoot.form_transitive
#print axioms LeftRoot.minimum_comparison
#print axioms LeftRoot.metric_weight_composition
#print axioms LeftRoot.binary_reconstruction_identity
#print axioms LeftRoot.cubic_reconstruction_identity
#print axioms LeftRoot.imaginary_defect_not_zero
#print axioms LeftRoot.positive_budget
#print axioms LeftRoot.signal_history_bound
#print axioms LeftRoot.split_defect_bound
#print axioms LeftRoot.left_numeric_center
#print axioms LeftRoot.global_range_union
#print axioms LeftRoot.global_margins
#print axioms LeftRoot.normal_return_zero_is_not_fault
#print axioms LeftRoot.conditional_right_completion_is_not_termination
