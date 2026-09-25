import FT1536.Basic
import FT1536.MathSign
import FT1536.Geometry
import FT1536.Divergence
import FT1536.EventTransfer
import FT1536.Adaptive
import FT1536.RetryDivergence
import FT1536.ROM
import FT1536.Collision
import FT1536.PublicSimulation
import FT1536.PublicCode
import FT1536.Relation
import FT1536.Model
import FT1536.TraceBound
import FT1536.Certificate

set_option pp.width 120
set_option pp.universes true

#check @FT1536.Law.event_nonneg
#print axioms FT1536.Law.event_nonneg

#check @FT1536.Law.event_le_one
#print axioms FT1536.Law.event_le_one

#check @FT1536.Law.event_mono
#print axioms FT1536.Law.event_mono

#check @FT1536.Law.remove_bad_bound
#print axioms FT1536.Law.remove_bad_bound

#check @FT1536.MathSign.cap_none
#print axioms FT1536.MathSign.cap_none

#check @FT1536.MathSign.cap_some
#print axioms FT1536.MathSign.cap_some

#check @FT1536.MathSign.full_reply_law
#print axioms FT1536.MathSign.full_reply_law

#check @FT1536.MathSign.cap16_exhaustion
#print axioms FT1536.MathSign.cap16_exhaustion

#check @FT1536.MathSign.pre_abort_has_no_nonce
#print axioms FT1536.MathSign.pre_abort_has_no_nonce

#check @FT1536.MathSign.positive_reply_not_filtered
#print axioms FT1536.MathSign.positive_reply_not_filtered

#check @FT1536.Geometry.block_nonneg
#print axioms FT1536.Geometry.block_nonneg

#check @FT1536.Geometry.coord_square_le_twice
#print axioms FT1536.Geometry.coord_square_le_twice

#check @FT1536.Geometry.Q0_nonneg
#print axioms FT1536.Geometry.Q0_nonneg

#check @FT1536.Geometry.coord_bound
#print axioms FT1536.Geometry.coord_bound

#check @FT1536.Geometry.Q0_swap
#print axioms FT1536.Geometry.Q0_swap

#check @FT1536.Geometry.all_coord_bounds
#print axioms FT1536.Geometry.all_coord_bounds

#check @FT1536.Geometry.Q0_spike
#print axioms FT1536.Geometry.Q0_spike

#check @FT1536.Geometry.center_spike
#print axioms FT1536.Geometry.center_spike

#check @FT1536.Geometry.centering_can_break_acceptance
#print axioms FT1536.Geometry.centering_can_break_acceptance

#check @FT1536.Divergence.support_mismatch
#print axioms FT1536.Divergence.support_mismatch

#check @FT1536.Divergence.density_mean
#print axioms FT1536.Divergence.density_mean

#check @FT1536.Divergence.energy_eq_second
#print axioms FT1536.Divergence.energy_eq_second

#check @FT1536.Divergence.centered_energy
#print axioms FT1536.Divergence.centered_energy

#check @FT1536.Divergence.weighted_cauchy
#print axioms FT1536.Divergence.weighted_cauchy

#check @FT1536.Divergence.energy_ge_one
#print axioms FT1536.Divergence.energy_ge_one

#check @FT1536.Divergence.chi2_toReal
#print axioms FT1536.Divergence.chi2_toReal

#check @FT1536.Divergence.chi2_finite
#print axioms FT1536.Divergence.chi2_finite

#check @FT1536.Divergence.joint_chi2
#print axioms FT1536.Divergence.joint_chi2

#check @FT1536.Divergence.joint_ac
#print axioms FT1536.Divergence.joint_ac

#check @FT1536.Divergence.joint_chi2_finite
#print axioms FT1536.Divergence.joint_chi2_finite

#check @FT1536.Divergence.joint_bound
#print axioms FT1536.Divergence.joint_bound

#check @FT1536.Divergence.image_conditional_bound
#print axioms FT1536.Divergence.image_conditional_bound

#check @FT1536.EventTransfer.event_quadratic
#print axioms FT1536.EventTransfer.event_quadratic

#check @FT1536.EventTransfer.discriminant_nonneg
#print axioms FT1536.EventTransfer.discriminant_nonneg

#check @FT1536.EventTransfer.phi_bound
#print axioms FT1536.EventTransfer.phi_bound

#check @FT1536.EventTransfer.phi_zero_delta
#print axioms FT1536.EventTransfer.phi_zero_delta

#check @FT1536.EventTransfer.phi_at_zero
#print axioms FT1536.EventTransfer.phi_at_zero

#check @FT1536.EventTransfer.phi_at_one
#print axioms FT1536.EventTransfer.phi_at_one

#check @FT1536.EventTransfer.phi_ge_b
#print axioms FT1536.EventTransfer.phi_ge_b

#check @FT1536.EventTransfer.phi_le_one
#print axioms FT1536.EventTransfer.phi_le_one

#check @FT1536.EventTransfer.phi_satisfies
#print axioms FT1536.EventTransfer.phi_satisfies

#check @FT1536.EventTransfer.phi_mono
#print axioms FT1536.EventTransfer.phi_mono

#check @FT1536.Divergence.transcript_ac
#print axioms FT1536.Divergence.transcript_ac

#check @FT1536.Divergence.stopped_adaptive_chi2
#print axioms FT1536.Divergence.stopped_adaptive_chi2

#check @FT1536.Divergence.constant_adaptive_chi2
#print axioms FT1536.Divergence.constant_adaptive_chi2

#check @FT1536.Divergence.stopped_transcript_event_bound
#print axioms FT1536.Divergence.stopped_transcript_event_bound

#check @FT1536.MathSign.geometric_acceptance
#print axioms FT1536.MathSign.geometric_acceptance

#check @FT1536.MathSign.cap_mixture
#print axioms FT1536.MathSign.cap_mixture

#check @FT1536.MathSign.cap16_success_probability
#print axioms FT1536.MathSign.cap16_success_probability

#check @FT1536.MathSign.success_vs_capped_second
#print axioms FT1536.MathSign.success_vs_capped_second

#check @FT1536.MathSign.zero_success_support_mismatch
#print axioms FT1536.MathSign.zero_success_support_mismatch

#check @FT1536.ROM.lookup_miss
#print axioms FT1536.ROM.lookup_miss

#check @FT1536.ROM.empty_good
#print axioms FT1536.ROM.empty_good

#check @FT1536.ROM.hash_good
#print axioms FT1536.ROM.hash_good

#check @FT1536.ROM.hash_used_le
#print axioms FT1536.ROM.hash_used_le

#check @FT1536.ROM.hash_unique
#print axioms FT1536.ROM.hash_unique

#check @FT1536.ROM.submit_good
#print axioms FT1536.ROM.submit_good

#check @FT1536.ROM.submitted_even_on_abort
#print axioms FT1536.ROM.submitted_even_on_abort

#check @FT1536.ROM.program_good
#print axioms FT1536.ROM.program_good

#check @FT1536.ROM.program_unique
#print axioms FT1536.ROM.program_unique

#check @FT1536.ROM.lookup_mem
#print axioms FT1536.ROM.lookup_mem

#check @FT1536.ROM.indexed_entry
#print axioms FT1536.ROM.indexed_entry

#check @FT1536.ROM.final_hash_index
#print axioms FT1536.ROM.final_hash_index

#check @FT1536.ROM.target_count_le_QH_add_one
#print axioms FT1536.ROM.target_count_le_QH_add_one

#check @FT1536.ROM.hash_cached
#print axioms FT1536.ROM.hash_cached

#check @FT1536.ROM.hash_nonanticipating
#print axioms FT1536.ROM.hash_nonanticipating

#check @FT1536.ROM.fixed_length_framing
#print axioms FT1536.ROM.fixed_length_framing

#check @FT1536.ROM.reachable_invariants
#print axioms FT1536.ROM.reachable_invariants

#check @FT1536.ROM.reachable_unique
#print axioms FT1536.ROM.reachable_unique

#check @FT1536.ROM.uniform_event_card
#print axioms FT1536.ROM.uniform_event_card

#check @FT1536.ROM.fresh_nonce_conflict
#print axioms FT1536.ROM.fresh_nonce_conflict

#check @FT1536.ROM.adaptive_average
#print axioms FT1536.ROM.adaptive_average

#check @FT1536.ROM.event_union_bound
#print axioms FT1536.ROM.event_union_bound

#check @FT1536.ROM.programming_conflict_bound
#print axioms FT1536.ROM.programming_conflict_bound

#check @FT1536.ROM.collision_sum
#print axioms FT1536.ROM.collision_sum

#check @FT1536.ROM.accumulated_conflicts
#print axioms FT1536.ROM.accumulated_conflicts

#check @FT1536.PublicSimulation.decode_encodeCoord
#print axioms FT1536.PublicSimulation.decode_encodeCoord

#check @FT1536.PublicSimulation.decode_encodeVec
#print axioms FT1536.PublicSimulation.decode_encodeVec

#check @FT1536.PublicSimulation.full_norm_support_in_box
#print axioms FT1536.PublicSimulation.full_norm_support_in_box

#check @FT1536.PublicSimulation.zero_norm
#print axioms FT1536.PublicSimulation.zero_norm

#check @FT1536.PublicSimulation.boundedWeight_nonneg
#print axioms FT1536.PublicSimulation.boundedWeight_nonneg

#check @FT1536.PublicSimulation.bounded_normalizer_pos
#print axioms FT1536.PublicSimulation.bounded_normalizer_pos

#check @FT1536.PublicSimulation.boundedGaussian_support
#print axioms FT1536.PublicSimulation.boundedGaussian_support

#check @FT1536.PublicSimulation.joint_law
#print axioms FT1536.PublicSimulation.joint_law

#check @FT1536.PublicSimulation.fiberWeight_nonneg
#print axioms FT1536.PublicSimulation.fiberWeight_nonneg

#check @FT1536.PublicSimulation.signBody_normalized
#print axioms FT1536.PublicSimulation.signBody_normalized

#check @FT1536.PublicSimulation.simSign_invariants
#print axioms FT1536.PublicSimulation.simSign_invariants

#check @FT1536.PublicSimulation.simSign_table_growth
#print axioms FT1536.PublicSimulation.simSign_table_growth

#check @FT1536.Relation.reduce_center
#print axioms FT1536.Relation.reduce_center

#check @FT1536.Relation.extraction_equation
#print axioms FT1536.Relation.extraction_equation

#check @FT1536.Relation.accepted_extracts
#print axioms FT1536.Relation.accepted_extracts

#check @FT1536.Reduction.indexed_extraction
#print axioms FT1536.Reduction.indexed_extraction

#check @FT1536.SigmaMath.sign_normalized
#print axioms FT1536.SigmaMath.sign_normalized

#check @FT1536.SigmaMath.key_marginal_normalized
#print axioms FT1536.SigmaMath.key_marginal_normalized

#check @FT1536.Reduction.finite_trace_bound
#print axioms FT1536.Reduction.finite_trace_bound

#check @FT1536.Reduction.hardness_substitution
#print axioms FT1536.Reduction.hardness_substitution

#check @FT1536.Reduction.one_key_unconditional
#print axioms FT1536.Reduction.one_key_unconditional

#check @FT1536.Reduction.zero_key_success
#print axioms FT1536.Reduction.zero_key_success

#check @FT1536.Certificate.centering_values
#print axioms FT1536.Certificate.centering_values

#check @FT1536.Certificate.nontrivial_directional_chi2
#print axioms FT1536.Certificate.nontrivial_directional_chi2

#check @FT1536.Certificate.adaptive_exact_value
#print axioms FT1536.Certificate.adaptive_exact_value
