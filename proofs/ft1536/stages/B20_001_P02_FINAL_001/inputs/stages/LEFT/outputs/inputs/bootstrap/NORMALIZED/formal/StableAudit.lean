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
import RootDiv
import RootFrame
import RootBounds
import RootModel
import NodeInverse
import NodeDataflow
import NodeConstants
import Half
import BinaryMargin
import NodeFrame
import BinaryFrame
import BinaryConstants
import HalfMain
import TowerShape
import TowerOrder
import TowerMargin
import TowerExecution
import RawLayout
import RawComposition
import RawMatching
import StableBits
import NormalizeMap
import Sqrt54
import SqrtPack
import StableOutcome
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
#print axioms Node2.pair_identity
#print axioms Node2.coarse_box_countermodel
#print axioms Node2.first_branch_margin
#print axioms Node2.second_branch_margin
#print axioms Node2.pair_layout
#print axioms Node3.store_prefix
#print axioms Node3.node_frame
#print axioms Node3.layout
#print axioms Node2.input_frame
#print axioms Node2.level_sizes
#print axioms Node2.valid_c2
#print axioms Node2.first_div_domain
#print axioms Tower.words_formula
#print axioms Tower.internal_formula
#print axioms Tower.leaves_formula
#print axioms Tower.scratch_bound
#print axioms Tower.twelve_subtrees
#print axioms Tower.assembly_count
#print axioms Tower.coverage
#print axioms Tower.actual_order
#print axioms Tower.actual_base
#print axioms Tower.frame
#print axioms Tower.partition
#print axioms Tower.harmonic_identity
#print axioms Tower.harmonic_lower
#print axioms Tower.output_transfer
#print axioms Tower.clean_invariant_constants
#print axioms Tower.successful_execution
#print axioms RawAssembly.allocation_sizes
#print axioms RawAssembly.count_from_children
#print axioms RawAssembly.internal_leaf_counts
#print axioms RawAssembly.scratch_from_children
#print axioms RawAssembly.branch_bounds
#print axioms RawAssembly.level8_bounds
#print axioms RawAssembly.inner7_bounds
#print axioms RawAssembly.separate_branches
#print axioms RawAssembly.separate_children
#print axioms RawAssembly.separate_inner7
#print axioms RawAssembly.full_tree_partition
#print axioms RawAssembly.depth_partition
#print axioms RawAssembly.level8_partition
#print axioms RawAssembly.packed_tree_offset
#print axioms RawAssembly.all_byte_offsets_fit
#print axioms RawAssembly.checked_coeff_fits_int16
#print axioms RawAssembly.raw_tree_frame
#print axioms RawAssembly.depth_children_preserve_diagonals
#print axioms RawAssembly.inner_first_child_preserves_input
#print axioms RawAssembly.root_D_read_before_reuse_ranges
#print axioms RawAssembly.inner_step_match
#print axioms RawAssembly.inner8_from_actual_inner7
#print axioms RawAssembly.depth_from_local_domains
#print axioms RawAssembly.top_from_local_domains
#print axioms RawAssembly.raw_prefix_totality_from_local_domains
#print axioms RawAssembly.emitted_corollary
#print axioms RawAssembly.all_append
#print axioms RawAssembly.inner8_length
#print axioms RawAssembly.depth_length
#print axioms RawAssembly.top_length
#print axioms RawAssembly.all_local_words_finite
#print axioms RawAssembly.snapshot_read_before_reuse
#print axioms RawAssembly.fixed_profile_and_late_guard
#print axioms StableNorm.flip_fields
#print axioms StableNorm.square_neg_bit_invariant
#print axioms StableNorm.selfadj_neg_bit_invariant
#print axioms StableNorm.signzero_source_swap
#print axioms StableNorm.ordered_comm
#print axioms StableNorm.nonnegative_add_bit_comm
#print axioms StableNorm.sticky_clear
#print axioms StableNorm.scan_clear
#print axioms StableNorm.inclusive_gate
#print axioms StableNorm.fallback_identity
#print axioms StableNorm.normalized_raw_leaf_map
#print axioms StableNorm.leaf_count
#print axioms StableNorm.leaf_position_range
#print axioms StableNorm.full_count
#print axioms StableNorm.full_map_range
#print axioms StableNorm.normalized_frame
#print axioms StableNorm.basis_preserved
#print axioms StableNorm.reverse_reciprocal_disjoint
#print axioms StableNorm.reverse_reciprocal_injective
#print axioms StableNorm.stable_tmp_ranges
#print axioms StableNorm.scalar_calls_count
#print axioms StableSqrt.square_shift
#print axioms StableSqrt.square_twice
#print axioms StableSqrt.trial_iff
#print axioms StableSqrt.step_invariant
#print axioms StableSqrt.step_bracket
#print axioms StableSqrt.last_bit
#print axioms StableSqrt.run_correct
#print axioms StableSqrt.loop54
#print axioms StableSqrt.state_range
#print axioms StableSqrt.step_cap
#print axioms StableSqrt.unsigned_trial_compare
#print axioms StableSqrt.normalized_root_range
#print axioms StableSqrt.sqrt_initial_target_range
#print axioms StableSqrt.guard_sticky_mantissa
#print axioms StableSqrt.final_remainder_bound
#print axioms StableSqrt.source_s_update
#print axioms StableSqrt.sticky_zero_test
#print axioms StableSqrt.exponent_parity
#print axioms StableSqrt.positive_normal_exponent_pack
#print axioms StableNorm.pack_value_extended
#print axioms StableNorm.sqrt_pack_positive_finite
#print axioms StableNorm.sqrt_pack_value
#print axioms StableNorm.deterministic_gate_transport
#print axioms StableNorm.suffix_runs_before_return
#print axioms StableNorm.mandatory_before_break
#print axioms StableNorm.last_coefficient_suffices
#print axioms StableNorm.scoped_H4_consumer
#print axioms StableNorm.paired_variance_margin
#print axioms StableNorm.source_suffix_count_return
