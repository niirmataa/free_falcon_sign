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
import Buffer
import Layouts
import Deps.Tables
import Deps.Words
import Twiddles
import Deps.Composition
import SourceModel
import Deps.Linear
import Expressions
import BlockExpressions
import BlockChecks
import LocalInverse
import Stages
import InverseGlobal
import ForwardProgress
import Pipeline
import Sums
import Evaluation
import CRTStages
import NodeArithmetic
import LeafData.C00
import LeafData.C01
import LeafData.C02
import LeafData.C03
import LeafData.C04
import LeafData.C05
import LeafData.C06
import LeafData.C07
import LeafData.C08
import LeafData.C09
import LeafData.C10
import LeafData.C11
import LeafData.C12
import LeafData.C13
import LeafData.C14
import LeafData.C15
import LeafData.C16
import LeafData.C17
import LeafData.C18
import LeafData.C19
import LeafData.C20
import LeafData.C21
import LeafData.C22
import LeafData.C23
import LeafData.C24
import LeafData.C25
import LeafData.C26
import LeafData.C27
import LeafData.C28
import LeafData.C29
import LeafData.C30
import LeafData.C31
import LeafChecks
import LeafFacts
import ForwardGlobal
import Monomials
import Product
import Rho
import Complete
import BridgeWords
import Norm64
import RawBridge
import ByteCursor
import CapacityMath
import DecodeStatic
import EncoderCount
import IidCDF
import IidBytes
import IidBerExp
import IidHighWord
import IidRejection
import GaussianMul
import GaussianIntervals
import GaussianMetrics
import MetricTransport
import LeftClosure
import JointOrder
import JointPrefix
import JointMetrics
import RintBits
import RintRefinement
import H6PMap
import H6PVariance
import H6PMoment
import H6PEvent
import Precast
import SourceBytes
import RetryState
import RetryProbability
import RetryCoupling
import RetryResources
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
#print axioms FT1536Global.store_at
#print axioms FT1536Global.store_away
#print axioms FT1536Global.prefix_invariant
#print axioms FT1536Global.prefix_frame
#print axioms FT1536Global.pair_local
#print axioms FT1536Global.pair_frame
#print axioms FT1536Global.pair_first_store
#print axioms FT1536Global.pair_prefix
#print axioms FT1536Global.fin3_cases
#print axioms FT1536Global.triple_local
#print axioms FT1536Global.triple_frame
#print axioms FT1536Global.triple_prefix
#print axioms FT1536Global.pair_address_bound
#print axioms FT1536Global.pair_decode
#print axioms FT1536Global.pair_cover
#print axioms FT1536Global.pair_layout
#print axioms FT1536Global.source_pair_prefix
#print axioms FT1536Global.triple_address_bound
#print axioms FT1536Global.triple_layout
#print axioms FT1536Global.triple_cover
#print axioms FT1536Global.source_triple_prefix
#print axioms FT1536Global.pair_prefix_canonical
#print axioms FT1536Global.triple_prefix_canonical
#print axioms FT1536Global.forward_schedule
#print axioms FT1536Global.inverse_schedule
#print axioms FT1536Tables.all_sound
#print axioms FT1536Tables.row2_sound
#print axioms FT1536Tables.row3_sound
#print axioms FT1536Tables.rev_even_range
#print axioms FT1536Tables.rev_even_involution
#print axioms FT1536Tables.units_0_checked
#print axioms FT1536Tables.units_1_checked
#print axioms FT1536Tables.units_2_checked
#print axioms FT1536Tables.units_3_checked
#print axioms FT1536Tables.units_4_checked
#print axioms FT1536Tables.units_5_checked
#print axioms FT1536Tables.units_6_checked
#print axioms FT1536Tables.units_7_checked
#print axioms FT1536Tables.units_8_checked
#print axioms FT1536Tables.units_9_checked
#print axioms FT1536Tables.units_10_checked
#print axioms FT1536Tables.units_11_checked
#print axioms FT1536Tables.units_12_checked
#print axioms FT1536Tables.units_13_checked
#print axioms FT1536Tables.units_14_checked
#print axioms FT1536Tables.units_15_checked
#print axioms FT1536Tables.units_16_checked
#print axioms FT1536Tables.units_17_checked
#print axioms FT1536Tables.units_18_checked
#print axioms FT1536Tables.units_19_checked
#print axioms FT1536Tables.units_20_checked
#print axioms FT1536Tables.units_21_checked
#print axioms FT1536Tables.units_22_checked
#print axioms FT1536Tables.units_23_checked
#print axioms FT1536Tables.units_24_checked
#print axioms FT1536Tables.units_25_checked
#print axioms FT1536Tables.units_26_checked
#print axioms FT1536Tables.units_27_checked
#print axioms FT1536Tables.units_28_checked
#print axioms FT1536Tables.units_29_checked
#print axioms FT1536Tables.units_30_checked
#print axioms FT1536Tables.units_31_checked
#print axioms FT1536Tables.sequence_0_checked
#print axioms FT1536Tables.sequence_1_checked
#print axioms FT1536Tables.sequence_2_checked
#print axioms FT1536Tables.sequence_3_checked
#print axioms FT1536Tables.sequence_4_checked
#print axioms FT1536Tables.sequence_5_checked
#print axioms FT1536Tables.sequence_6_checked
#print axioms FT1536Tables.sequence_7_checked
#print axioms FT1536Tables.parents_0_checked
#print axioms FT1536Tables.parents_1_checked
#print axioms FT1536Tables.parents_2_checked
#print axioms FT1536Tables.parents_3_checked
#print axioms FT1536Tables.parents_4_checked
#print axioms FT1536Tables.parents_5_checked
#print axioms FT1536Tables.parents_6_checked
#print axioms FT1536Tables.parents_7_checked
#print axioms FT1536Tables.parents_8_checked
#print axioms FT1536Tables.parents_9_checked
#print axioms FT1536Tables.parents_10_checked
#print axioms FT1536Tables.parents_11_checked
#print axioms FT1536Tables.parents_12_checked
#print axioms FT1536Tables.parents_13_checked
#print axioms FT1536Tables.parents_14_checked
#print axioms FT1536Tables.parents_15_checked
#print axioms FT1536Tables.tree_0_checked
#print axioms FT1536Tables.tree_1_checked
#print axioms FT1536Tables.tree_2_checked
#print axioms FT1536Tables.tree_3_checked
#print axioms FT1536Tables.tree_4_checked
#print axioms FT1536Tables.tree_5_checked
#print axioms FT1536Tables.tree_6_checked
#print axioms FT1536Tables.tree_7_checked
#print axioms FT1536Tables.tree_8_checked
#print axioms FT1536Tables.tree_9_checked
#print axioms FT1536Tables.tree_10_checked
#print axioms FT1536Tables.tree_11_checked
#print axioms FT1536Tables.tree_12_checked
#print axioms FT1536Tables.tree_13_checked
#print axioms FT1536Tables.tree_14_checked
#print axioms FT1536Tables.tree_15_checked
#print axioms FT1536Tables.rows2_0_checked
#print axioms FT1536Tables.rows2_1_checked
#print axioms FT1536Tables.rows2_2_checked
#print axioms FT1536Tables.rows2_3_checked
#print axioms FT1536Tables.rows2_4_checked
#print axioms FT1536Tables.rows2_5_checked
#print axioms FT1536Tables.rows2_6_checked
#print axioms FT1536Tables.rows2_7_checked
#print axioms FT1536Tables.rows2_8_checked
#print axioms FT1536Tables.rows2_9_checked
#print axioms FT1536Tables.rows2_10_checked
#print axioms FT1536Tables.rows2_11_checked
#print axioms FT1536Tables.rows2_12_checked
#print axioms FT1536Tables.rows2_13_checked
#print axioms FT1536Tables.rows2_14_checked
#print axioms FT1536Tables.rows2_15_checked
#print axioms FT1536Tables.rows2_16_checked
#print axioms FT1536Tables.rows2_17_checked
#print axioms FT1536Tables.rows2_18_checked
#print axioms FT1536Tables.rows2_19_checked
#print axioms FT1536Tables.rows2_20_checked
#print axioms FT1536Tables.rows2_21_checked
#print axioms FT1536Tables.rows2_22_checked
#print axioms FT1536Tables.rows2_23_checked
#print axioms FT1536Tables.rows2_24_checked
#print axioms FT1536Tables.rows2_25_checked
#print axioms FT1536Tables.rows2_26_checked
#print axioms FT1536Tables.rows2_27_checked
#print axioms FT1536Tables.rows2_28_checked
#print axioms FT1536Tables.rows2_29_checked
#print axioms FT1536Tables.rows2_30_checked
#print axioms FT1536Tables.rows2_31_checked
#print axioms FT1536Tables.rows3_0_checked
#print axioms FT1536Tables.rows3_1_checked
#print axioms FT1536Tables.rows3_2_checked
#print axioms FT1536Tables.rows3_3_checked
#print axioms FT1536Tables.rows3_4_checked
#print axioms FT1536Tables.rows3_5_checked
#print axioms FT1536Tables.rows3_6_checked
#print axioms FT1536Tables.rows3_7_checked
#print axioms FT1536Tables.rows3_8_checked
#print axioms FT1536Tables.rows3_9_checked
#print axioms FT1536Tables.rows3_10_checked
#print axioms FT1536Tables.rows3_11_checked
#print axioms FT1536Tables.rows3_12_checked
#print axioms FT1536Tables.rows3_13_checked
#print axioms FT1536Tables.rows3_14_checked
#print axioms FT1536Tables.rows3_15_checked
#print axioms FT1536Tables.rows3_16_checked
#print axioms FT1536Tables.rows3_17_checked
#print axioms FT1536Tables.rows3_18_checked
#print axioms FT1536Tables.rows3_19_checked
#print axioms FT1536Tables.rows3_20_checked
#print axioms FT1536Tables.rows3_21_checked
#print axioms FT1536Tables.rows3_22_checked
#print axioms FT1536Tables.rows3_23_checked
#print axioms FT1536Tables.rows3_24_checked
#print axioms FT1536Tables.rows3_25_checked
#print axioms FT1536Tables.rows3_26_checked
#print axioms FT1536Tables.rows3_27_checked
#print axioms FT1536Tables.rows3_28_checked
#print axioms FT1536Tables.rows3_29_checked
#print axioms FT1536Tables.rows3_30_checked
#print axioms FT1536Tables.rows3_31_checked
#print axioms FT1536Tables.rows3_32_checked
#print axioms FT1536Tables.rows3_33_checked
#print axioms FT1536Tables.rows3_34_checked
#print axioms FT1536Tables.rows3_35_checked
#print axioms FT1536Tables.rows3_36_checked
#print axioms FT1536Tables.rows3_37_checked
#print axioms FT1536Tables.rows3_38_checked
#print axioms FT1536Tables.rows3_39_checked
#print axioms FT1536Tables.rows3_40_checked
#print axioms FT1536Tables.rows3_41_checked
#print axioms FT1536Tables.rows3_42_checked
#print axioms FT1536Tables.rows3_43_checked
#print axioms FT1536Tables.rows3_44_checked
#print axioms FT1536Tables.rows3_45_checked
#print axioms FT1536Tables.rows3_46_checked
#print axioms FT1536Tables.rows3_47_checked
#print axioms FT1536Tables.chain_0_checked
#print axioms FT1536Tables.chain_1_checked
#print axioms FT1536Tables.root_and_scale_facts
#print axioms FT1536NTT.constants
#print axioms FT1536NTT.fix_contract
#print axioms FT1536NTT.add_contract
#print axioms FT1536NTT.sub_contract
#print axioms FT1536NTT.half_contract
#print axioms FT1536NTT.low_bits_preserved
#print axioms FT1536NTT.mont_ranges
#print axioms FT1536NTT.mont_divisibility
#print axioms FT1536NTT.mont_contract_z
#print axioms FT1536NTT.product_range
#print axioms FT1536NTT.mq_montymul_contract
#print axioms FT1536NTT.mq_montysqr_contract
#print axioms FT1536NTT.small_divisors
#print axioms FT1536NTT.prime_factorization
#print axioms FT1536Global.unitRows_length
#print axioms FT1536Global.unitRows_checked
#print axioms FT1536Global.unit_bounds
#print axioms FT1536Global.table_canonical
#print axioms FT1536Global.gmAt_canonical
#print axioms FT1536Global.igmAt_canonical
#print axioms FT1536Composition.product_canonical
#print axioms FT1536Composition.tomont_factor
#print axioms FT1536Composition.prepared_product
#print axioms FT1536Composition.prepared_point_product
#print axioms FT1536Composition.L_NTT_after_global_interfaces
#print axioms FT1536Global.addQ_range
#print axioms FT1536Global.subQ_range
#print axioms FT1536Global.mmQ_range
#print axioms FT1536Global.addQ_source
#print axioms FT1536Global.subQ_source
#print axioms FT1536Global.mmQ_source
#print axioms FT1536Global.forwardRootOp_range
#print axioms FT1536Global.forwardBinaryOp_range
#print axioms FT1536Global.forwardCubicOp_range
#print axioms FT1536Global.inverseCubicOp_range
#print axioms FT1536Global.inverseBinaryOp_range
#print axioms FT1536Global.inverseRootOp_range
#print axioms FT1536Global.forward_params_half
#print axioms FT1536Global.inverse_params_half
#print axioms FT1536Global.forwardMiddle_canonical
#print axioms FT1536Global.inverseMiddle_canonical
#print axioms FT1536Global.store_canonical
#print axioms FT1536Global.scale_canonical
#print axioms FT1536Global.forward_canonical
#print axioms FT1536Global.inverse_canonical
#print axioms FT1536Global.fromVec_canonical
#print axioms FT1536Global.forwardC_canonical
#print axioms FT1536Global.inverseC_canonical
#print axioms FT1536Global.canonical_fixed
#print axioms FT1536Global.liftForward_agrees
#print axioms FT1536Global.liftInverse_agrees
#print axioms FT1536Linear.dot2_compose
#print axioms FT1536Linear.dot2_congr
#print axioms FT1536Linear.dot3_compose
#print axioms FT1536Linear.dot3_congr
#print axioms FT1536Linear.three_row_action
#print axioms FT1536Linear.two_row_inverse
#print axioms FT1536Linear.final_scaling
#print axioms FT1536Global.eval_subst
#print axioms FT1536Global.dot_add
#print axioms FT1536Global.dot_sub
#print axioms FT1536Global.dot_mm_left
#print axioms FT1536Global.dot_mm_right
#print axioms FT1536Global.eval_linear
#print axioms FT1536Global.eval_diagonal
#print axioms FT1536Global.eval_scaled
#print axioms FT1536Global.rootF_bind
#print axioms FT1536Global.rootI_bind
#print axioms FT1536Global.binF_bind
#print axioms FT1536Global.binI_bind
#print axioms FT1536Global.cubeF_bind
#print axioms FT1536Global.cubeI_bind
#print axioms FT1536Global.fin3_mem
#print axioms FT1536Global.blockCheck_sound
#print axioms FT1536Global.row_ids
#print axioms FT1536Global.unitRow_id
#print axioms FT1536Global.root_checked
#print axioms FT1536Global.local_checked_0
#print axioms FT1536Global.local_checked_1
#print axioms FT1536Global.local_checked_2
#print axioms FT1536Global.local_checked_3
#print axioms FT1536Global.local_checked_4
#print axioms FT1536Global.local_checked_5
#print axioms FT1536Global.local_checked_6
#print axioms FT1536Global.local_checked_7
#print axioms FT1536Global.local_checked_8
#print axioms FT1536Global.local_checked_9
#print axioms FT1536Global.local_checked_10
#print axioms FT1536Global.local_checked_11
#print axioms FT1536Global.local_checked_12
#print axioms FT1536Global.local_checked_13
#print axioms FT1536Global.local_checked_14
#print axioms FT1536Global.local_checked_15
#print axioms FT1536Global.local_checked_16
#print axioms FT1536Global.local_checked_17
#print axioms FT1536Global.local_checked_18
#print axioms FT1536Global.local_checked_19
#print axioms FT1536Global.local_checked_20
#print axioms FT1536Global.local_checked_21
#print axioms FT1536Global.local_checked_22
#print axioms FT1536Global.local_checked_23
#print axioms FT1536Global.local_checked_24
#print axioms FT1536Global.local_checked_25
#print axioms FT1536Global.local_checked_26
#print axioms FT1536Global.local_checked_27
#print axioms FT1536Global.local_checked_28
#print axioms FT1536Global.local_checked_29
#print axioms FT1536Global.local_checked_30
#print axioms FT1536Global.local_checked_31
#print axioms FT1536Global.local_checked
#print axioms FT1536Global.local_at
#print axioms FT1536Global.pairInput_slot
#print axioms FT1536Global.pairInput_canonical
#print axioms FT1536Global.root_inverse
#print axioms FT1536Global.binary_inverse
#print axioms FT1536Global.cubic_inverse
#print axioms FT1536Global.root_homogeneous
#print axioms FT1536Global.binary_homogeneous
#print axioms FT1536Global.cubic_homogeneous
#print axioms FT1536Global.forward_params_ok
#print axioms FT1536Global.schedules_reverse
#print axioms FT1536Global.scale_at
#print axioms FT1536Global.scale_out
#print axioms FT1536Global.scale_range
#print axioms FT1536Global.scale_combine
#print axioms FT1536Global.scale_one
#print axioms FT1536Global.pair_stage_at
#print axioms FT1536Global.triple_stage_at
#print axioms FT1536Global.pair_stage_out
#print axioms FT1536Global.triple_stage_out
#print axioms FT1536Global.pair_stage_inverse
#print axioms FT1536Global.triple_stage_inverse
#print axioms FT1536Global.pair_stage_homogeneous
#print axioms FT1536Global.point_prefix
#print axioms FT1536Global.scale_loop
#print axioms FT1536Global.scale_cancel
#print axioms FT1536Global.fpair_canonical
#print axioms FT1536Global.ipair_canonical
#print axioms FT1536Global.froot_canonical
#print axioms FT1536Global.pair_source_inverse
#print axioms FT1536Global.pair_source_homogeneous
#print axioms FT1536Global.root_source_inverse
#print axioms FT1536Global.root_source_homogeneous
#print axioms FT1536Global.cubic_source_inverse
#print axioms FT1536Global.inverse_append
#print axioms FT1536Global.middle_homogeneous
#print axioms FT1536Global.middle_reverse_inverse
#print axioms FT1536Global.inverseMem_forwardMem
#print axioms FT1536Global.forwardMiddle_out
#print axioms FT1536Global.forward_out
#print axioms FT1536Global.forward_from_to
#print axioms FT1536Global.inverseC_forwardC
#print axioms FT1536Global.canonicalVec
#print axioms FT1536Global.inverse_forward
#print axioms FT1536Global.mmQ_ordinary
#print axioms FT1536Global.ordinary_root
#print axioms FT1536Global.root_coefficients
#print axioms FT1536Global.binary_coefficients
#print axioms FT1536Global.initialized_binary_read
#print axioms FT1536Global.initialized_cubic_read
#print axioms FT1536Global.toMontC_eq
#print axioms FT1536Global.montPointC_eq
#print axioms FT1536Global.subtractC_eq
#print axioms FT1536Global.montPoint_canonical
#print axioms FT1536Global.pipelineC_lift
#print axioms FT1536Global.L_NTT_pending_forward
#print axioms FT1536Forward.sum_congr
#print axioms FT1536Forward.sum_zero
#print axioms FT1536Forward.sum_add
#print axioms FT1536Forward.sum_sub
#print axioms FT1536Forward.sum_scale
#print axioms FT1536Forward.sum_scale_right
#print axioms FT1536Forward.sum_split
#print axioms FT1536Forward.sum_mod
#print axioms FT1536Forward.sum_congr_mod
#print axioms FT1536Forward.sum_swap
#print axioms FT1536Forward.sum_delta
#print axioms FT1536Forward.sum_ofFn
#print axioms FT1536Forward.sum_ofFn_congr
#print axioms FT1536Forward.eval_congr
#print axioms FT1536Forward.eval_mod_coeff
#print axioms FT1536Forward.eval_linear
#print axioms FT1536Forward.eval_sub
#print axioms FT1536Forward.eval_scale
#print axioms FT1536Forward.eval_split
#print axioms FT1536Forward.split_preserves_eval
#print axioms FT1536Forward.pow_mod
#print axioms FT1536Forward.eval_mod_node
#print axioms FT1536Forward.eval_delta
#print axioms FT1536Forward.powM_correct
#print axioms FT1536Forward.split_layout
#print axioms FT1536Forward.binary_block_coefficient
#print axioms FT1536Forward.binary_block_eval
#print axioms FT1536Forward.root_block_eval
#print axioms FT1536Forward.powFuel_correct
#print axioms FT1536Forward.powFast_correct
#print axioms FT1536Forward.nodeCheck_sound
#print axioms FT1536Forward.leaf_checked_0
#print axioms FT1536Forward.leaf_checked_1
#print axioms FT1536Forward.leaf_checked_2
#print axioms FT1536Forward.leaf_checked_3
#print axioms FT1536Forward.leaf_checked_4
#print axioms FT1536Forward.leaf_checked_5
#print axioms FT1536Forward.leaf_checked_6
#print axioms FT1536Forward.leaf_checked_7
#print axioms FT1536Forward.leaf_checked_8
#print axioms FT1536Forward.leaf_checked_9
#print axioms FT1536Forward.leaf_checked_10
#print axioms FT1536Forward.leaf_checked_11
#print axioms FT1536Forward.leaf_checked_12
#print axioms FT1536Forward.leaf_checked_13
#print axioms FT1536Forward.leaf_checked_14
#print axioms FT1536Forward.leaf_checked_15
#print axioms FT1536Forward.leaf_checked_16
#print axioms FT1536Forward.leaf_checked_17
#print axioms FT1536Forward.leaf_checked_18
#print axioms FT1536Forward.leaf_checked_19
#print axioms FT1536Forward.leaf_checked_20
#print axioms FT1536Forward.leaf_checked_21
#print axioms FT1536Forward.leaf_checked_22
#print axioms FT1536Forward.leaf_checked_23
#print axioms FT1536Forward.leaf_checked_24
#print axioms FT1536Forward.leaf_checked_25
#print axioms FT1536Forward.leaf_checked_26
#print axioms FT1536Forward.leaf_checked_27
#print axioms FT1536Forward.leaf_checked_28
#print axioms FT1536Forward.leaf_checked_29
#print axioms FT1536Forward.leaf_checked_30
#print axioms FT1536Forward.leaf_checked_31
#print axioms FT1536Forward.leaf_checked
#print axioms FT1536Forward.leaf_facts
#print axioms FT1536Forward.actual_chain
#print axioms FT1536Forward.middle_eval
#print axioms FT1536Forward.cubic_eval
#print axioms FT1536Forward.forwardMem_eval
#print axioms FT1536Forward.forwardC_eval
#print axioms FT1536Forward.FORWARD_GLOBAL
#print axioms FT1536Forward.fromVec_canonical_mod
#print axioms FT1536Forward.liftForward_eval
#print axioms FT1536Forward.node_zero
#print axioms FT1536Forward.phi_square
#print axioms FT1536Forward.phi_cube
#print axioms FT1536Forward.power_middle
#print axioms FT1536Forward.power_high
#print axioms FT1536Forward.remMonomial_eval
#print axioms FT1536Forward.eval_sum
#print axioms FT1536Forward.eval_convolution
#print axioms FT1536Forward.productCoefficient_eq
#print axioms FT1536Forward.product_raw
#print axioms FT1536Forward.product_eval
#print axioms FT1536Forward.forward_product
#print axioms FT1536Forward.lift_canonical
#print axioms FT1536Forward.product_canonical_inputs
#print axioms FT1536.intermediate_ranges
#print axioms FT1536.positive_remainder
#print axioms FT1536.rho_contract
#print axioms FT1536.result_cast_exact
#print axioms FT1536.canonical_unique
#print axioms FT1536.old_piecewise
#print axioms FT1536.old_congruence_domain
#print axioms FT1536.old_canonical_domain
#print axioms FT1536.agree_on_old_canonical
#print axioms FT1536.vector_contract
#print axioms FT1536.loop_progress
#print axioms FT1536.center_antisymmetric
#print axioms FT1536Forward.L_NTT
#print axioms FT1536Forward.L_NTT_p
#print axioms FT1536Forward.L_NTT_d
#print axioms FT1536Forward.product_range
#print axioms FT1536Forward.subtract_range
#print axioms FT1536Forward.L_NTT_ranges
#print axioms FT1536Forward.toMontC_range
#print axioms FT1536Forward.montPointC_range
#print axioms FT1536Forward.subtractC_range
#print axioms FT1536Forward.point_prefix_range
#print axioms FT1536Forward.point_read_bound
#print axioms FT1536Forward.pipeline_intermediate_ranges
#print axioms FT1536Forward.rhoVec_eq
#print axioms FT1536Forward.rhoVec_range
#print axioms FT1536Forward.L_NTT_rho
#print axioms FT1536Forward.L_NTT_rho_ranges
#print axioms FT1536Bridge.s16_range
#print axioms FT1536Bridge.s16_exact
#print axioms FT1536Bridge.s16_bits
#print axioms FT1536Bridge.s32_exact
#print axioms FT1536Bridge.s64_exact
#print axioms FT1536Bridge.u32_range
#print axioms FT1536Bridge.fromVec_signed
#print axioms FT1536Bridge.center_borrow
#print axioms FT1536Bridge.center_correction
#print axioms FT1536Bridge.CENTER_C
#print axioms FT1536Bridge.center_mod
#print axioms FT1536Bridge.center_congruence
#print axioms FT1536Bridge.center_range
#print axioms FT1536Bridge.center_prefix
#print axioms FT1536Bridge.center_unread
#print axioms FT1536Bridge.center_loop_correct
#print axioms FT1536Bridge.fromVec_neg
#print axioms FT1536Bridge.Q0_neg
#print axioms FT1536Bridge.int16_product
#print axioms FT1536Bridge.normTerm_bound
#print axioms FT1536Bridge.norm_prefix
#print axioms FT1536Bridge.norm_no_overflow
#print axioms FT1536Bridge.interleave_sum
#print axioms FT1536Bridge.norm_sum
#print axioms FT1536Bridge.NORM64_EXACT
#print axioms FT1536Bridge.STRICT_B
#print axioms FT1536Bridge.raw_before_eq
#print axioms FT1536Bridge.raw_signed
#print axioms FT1536Bridge.extract_signed
#print axioms FT1536Bridge.SIGN_BRIDGE
#print axioms FT1536Bridge.extract_congruence
#print axioms FT1536Bridge.RAW_VERIFIER_SOUND
#print axioms FT1536Bridge.raw_reject_at_bound
#print axioms FT1536Bridge.start_valid
#print axioms FT1536Bridge.pull_spec
#print axioms FT1536Bridge.fill_source
#print axioms FT1536Bridge.fill_spec
#print axioms FT1536Bridge.nextBit_spec
#print axioms FT1536Bridge.nextBit_empty
#print axioms FT1536Bridge.unary_source
#print axioms FT1536Bridge.unary_spec
#print axioms FT1536Bridge.unary_wrap
#print axioms FT1536Bridge.zeroCount_shift
#print axioms FT1536Bridge.unary_skip_zeros
#print axioms FT1536Bridge.unary_full_wrap
#print axioms FT1536M0.sum_le
#print axioms FT1536M0.sum_nonneg
#print axioms FT1536M0.sum_const
#print axioms FT1536M0.square_nonnegative
#print axioms FT1536M0.a2_square_bound
#print axioms FT1536M0.a2_nonnegative
#print axioms FT1536M0.Q0_nonnegative
#print axioms FT1536M0.square_sum_bound
#print axioms FT1536M0.abs_majorant
#print axioms FT1536M0.l1_bound
#print axioms FT1536M0.quotient_bound
#print axioms FT1536M0.CAPACITY_3160
#print axioms FT1536M0.capacity_after_source_norm
#print axioms FT1536M0.integer_endpoint_checks
#print axioms FT1536Bridge.static_value_range
#print axioms FT1536Bridge.static_promotions
#print axioms FT1536Bridge.readStatic_spec
#print axioms FT1536Bridge.static_head_source
#print axioms FT1536Bridge.static_head_shifts
#print axioms FT1536Bridge.static_loop_spec
#print axioms FT1536Bridge.DECODE_STATIC
#print axioms FT1536Bridge.listVec_property
#print axioms FT1536Bridge.static_vector_signed
#print axioms FT1536M0.drain_ok
#print axioms FT1536M0.prefix9_ok
#print axioms FT1536M0.oneBit_ok
#print axioms FT1536M0.manyBits_ok
#print axioms FT1536M0.coeff_bits_eq
#print axioms FT1536M0.list_bits_nonneg
#print axioms FT1536M0.encoder_body_ok
#print axioms FT1536M0.finish_ok
#print axioms FT1536M0.encoder_count_exact
#print axioms FT1536M0.list_bits_append
#print axioms FT1536M0.list_bits_ofFn
#print axioms FT1536M0.vector_bits
#print axioms FT1536M0.STATIC_FITS_4096
#print axioms FT1536M0.source_ne_bounds
#print axioms FT1536M0.terminal_bit
#print axioms FT1536M0.post_decrement_count
#print axioms ScalarIID.mass_telescopes
#print axioms ScalarIID.count_append
#print axioms ScalarIID.count_all
#print axioms ScalarIID.count_none
#print axioms ScalarIID.atom_partition
#print axioms ScalarIID.threshold_strict
#print axioms ScalarIID.sign_outputs_disjoint
#print axioms ScalarIID.small_atom_mass
#print axioms ScalarIID.getter64_ranges
#print axioms ScalarIID.getter64_read_range
#print axioms ScalarIID.getter8_ranges
#print axioms ScalarIID.sign_getter_no_refill
#print axioms ScalarIID.exact_boundary
#print axioms ScalarIID.returned_proposal_bytes
#print axioms ScalarIID.refill_budget
#print axioms ScalarIID.discarded_budget
#print axioms ScalarIID.unique_read_positions
#print axioms ScalarIID.unsigned_low55_comparison
#print axioms ScalarIID.saturated_count
#print axioms ScalarIID.zero_low_bits
#print axioms ScalarIID.high_half_bound
#print axioms ScalarIID.horner_interval
#print axioms ScalarIID.final_positive_threshold
#print axioms ScalarIID.cutoff_integer
#print axioms ScalarIID.small_trunc_shift
#print axioms ScalarIID.raw_trunc_counts
#print axioms ScalarIID.limb_expansion
#print axioms ScalarIID.high_carry
#print axioms ScalarIID.first_limb_sum_bound
#print axioms ScalarIID.high_product_range
#print axioms ScalarIID.finite_geometric_count
#print axioms ScalarIID.normalized_mass_integer
#print axioms ScalarIID.positive_normalizer
#print axioms ScalarIID.strict_reject_fraction
#print axioms ScalarIID.source_return_injective_left
#print axioms ScalarIID.source_return_injective_right
#print axioms ScalarIID.normal_zero_is_not_fault
#print axioms GaussianComparison.limb25_expansion
#print axioms GaussianComparison.low_product_reconstruction
#print axioms GaussianComparison.limb_product_ranges
#print axioms GaussianComparison.round_lookup
#print axioms GaussianComparison.nearest_non_crossing
#print axioms GaussianComparison.specialized_center_error
#print axioms GaussianComparison.positive_trunc_counts
#print axioms GaussianComparison.source_precision_error_consumer
#print axioms GaussianComparison.monotone_bracket
#print axioms GaussianComparison.adjacent_cover
#print axioms GaussianComparison.interval_difference
#print axioms GaussianComparison.finite_guard_source
#print axioms GaussianComparison.nonwrap_horner
#print axioms GaussianComparison.threshold_upper
#print axioms GaussianComparison.weighted_bounds
#print axioms GaussianComparison.normalization_variance_identity
#print axioms GaussianComparison.squared_sum_bound
#print axioms GaussianComparison.normalization_point_bound
#print axioms GaussianComparison.accepted_mass_lower
#print axioms GaussianComparison.finite_support_reverse_failure
#print axioms GaussianComparison.conditioned_support
#print axioms GaussianComparison.tail_is_nonnegative
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
#print axioms OrderedJoint.inner_count
#print axioms OrderedJoint.root_count
#print axioms OrderedJoint.branch_count
#print axioms OrderedJoint.scratch_size
#print axioms OrderedJoint.root_frame
#print axioms OrderedJoint.call_pair_counts
#print axioms OrderedJoint.correlated_branch_budget
#print axioms OrderedJoint.support_realizes
#print axioms OrderedJoint.before_next
#print axioms OrderedJoint.same_value_projection
#print axioms OrderedJoint.zero_atom_not_support
#print axioms OrderedJoint.positive_atom_has_element
#print axioms OrderedJoint.paired_terminal_identity
#print axioms OrderedJoint.conditioning_second_moment
#print axioms OrderedJoint.conditioning_decreases
#print axioms OrderedJoint.weighted_step_bound
#print axioms OrderedJoint.second_moment_chain
#print axioms OrderedJoint.survival_tilt_cleared
#print axioms OrderedJoint.reverse_support_same
#print axioms OrderedJoint.numerical_chi_bound
#print axioms OrderedJoint.tv_square_bound
#print axioms OrderedJoint.union_epsilon
#print axioms OrderedJoint.reverse_exponent
#print axioms Postprocess.dd_zero
#print axioms Postprocess.increment_rule
#print axioms Postprocess.shift_product
#print axioms Postprocess.discarded_word
#print axioms Postprocess.scaled_half_comparison
#print axioms Postprocess.source_shift_range
#print axioms Postprocess.below_half_mask
#print axioms Postprocess.normal_round_count
#print axioms Postprocess.signed_reconstruction_range
#print axioms Postprocess.magnitude_is_nearest
#print axioms Postprocess.nearest_error
#print axioms Postprocess.nearest_tie_even
#print axioms Postprocess.negative_error
#print axioms H6P.terminal_innovation_identity
#print axioms H6P.terminal_A2
#print axioms H6P.binary_map
#print axioms H6P.cubic_map
#print axioms H6P.root_basis_map
#print axioms H6P.no_affine_offset
#print axioms H6P.output_counts
#print axioms H6P.A2_coordinate0
#print axioms H6P.A2_coordinate1
#print axioms H6P.gram_determinant
#print axioms H6P.energy_max_composition
#print axioms H6P.row_norm_consumer
#print axioms H6P.cauchy_two
#print axioms H6P.completing_square
#print axioms H6P.local_conditioning_count
#print axioms H6P.conditional_product_bound
#print axioms H6P.signed_union_count
#print axioms H6P.event_factor_monotone
#print axioms H6P.exit_subprobability_event
#print axioms H6P.joint_bad_has_coefficient
#print axioms H6P.second_vector_matters
#print axioms H6P.negative_safe_tie
#print axioms H6P.positive_bad_tie
#print axioms H6P.bad_rint_argument
#print axioms H6P.error_to_symmetric_tail
#print axioms H6P.exit_not_bad
#print axioms Postprocess.narrow_range
#print axioms Postprocess.narrow_preserves_iff
#print axioms Postprocess.joint_preserves_iff
#print axioms Postprocess.narrow_matches_LV
#print axioms Postprocess.narrowing_countermodel
#print axioms Postprocess.negative_endpoint_roundtrip
#print axioms Postprocess.rint_word_bound_consumer
#print axioms Postprocess.int64_margin
#print axioms Postprocess.bad_in_one_attempt
#print axioms Postprocess.source_magnitude
#print axioms Postprocess.coefficient_roundtrip
#print axioms Postprocess.no_negative_zero
#print axioms Postprocess.byte_append
#print axioms Postprocess.unsigned_wrap_preserves_suffix
#print axioms Postprocess.encoder_buffer_guard
#print axioms Postprocess.encoder_header
#print axioms Postprocess.narrowed_signed
#print axioms Postprocess.stored_norm
#print axioms Postprocess.stored_capacity
#print axioms RetryIID.counter_guard
#print axioms RetryIID.reached_index
#print axioms RetryIID.guard17_before_init
#print axioms RetryIID.source_reset_pointer
#print axioms RetryIID.target_overwrite
#print axioms RetryIID.reentry_induction
#print axioms RetryIID.safe_interfaces
#print axioms RetryIID.weighted_stopped_sum
#print axioms RetryIID.bounded_reach_sum
#print axioms RetryIID.survival_product
#print axioms RetryIID.conjunction_not_conditioning
#print axioms RetryIID.sum_cap_proposals
#print axioms RetryIID.checked_good
#print axioms RetryIID.checked_bad
#print axioms RetryIID.equal_iff_good
#print axioms RetryIID.preservation_before_norm
#print axioms RetryIID.stored_wide_norm_agrees
#print axioms RetryIID.public_map_preserves_agreement
#print axioms RetryIID.chunk_generated
#print axioms RetryIID.fresh_pointer_refill_bound
#print axioms RetryIID.abandoned_root_tail
#print axioms RetryIID.initial_block_not_optional
#print axioms RetryIID.chunk_sum
#print axioms RetryIID.block_bound_numbers
#print axioms RetryIID.root_request_budget
#print axioms RetryIID.counter_projection
