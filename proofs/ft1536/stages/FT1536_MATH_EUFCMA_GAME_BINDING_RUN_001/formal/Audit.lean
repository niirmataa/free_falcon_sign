import FT1536.GameByte
import FT1536.GameNames
import FT1536.GameMach
import FT1536.PaidSteps
import FT1536.Mixture
import FT1536.Lazy
import FT1536.GameLaw
import FT1536.PathCounter
import FT1536.AdversaryFold
import FT1536.BitCost
import FT1536.FinalBind
import FT1536.FinalTheorem
import FT1536.GameCertificate
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

set_option format.width 120
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

/- New exports of this run (task INTERACTIVE_GAME_AND_RESOURCE_BINDING) -/
#check @FT1536.GameByte.Byte
#print axioms FT1536.GameByte.Byte
#check @FT1536.GameByte.Name
#print axioms FT1536.GameByte.Name
#check @FT1536.GameByte.Message
#print axioms FT1536.GameByte.Message
#check @FT1536.GameByte.bytesLE
#print axioms FT1536.GameByte.bytesLE
#check @FT1536.GameByte.bytesVal
#print axioms FT1536.GameByte.bytesVal
#check @FT1536.GameByte.length_bytesLE
#print axioms FT1536.GameByte.length_bytesLE
#check @FT1536.GameByte.bytesVal_lt
#print axioms FT1536.GameByte.bytesVal_lt
#check @FT1536.GameByte.mod_mul_digits
#print axioms FT1536.GameByte.mod_mul_digits
#check @FT1536.GameByte.bytesVal_bytesLE
#print axioms FT1536.GameByte.bytesVal_bytesLE
#check @FT1536.GameByte.bytesLE_bytesVal
#print axioms FT1536.GameByte.bytesLE_bytesVal
#check @FT1536.GameByte.Nonce
#print axioms FT1536.GameByte.Nonce
#check @FT1536.GameByte.pow256_40
#print axioms FT1536.GameByte.pow256_40
#check @FT1536.GameByte.nonceBytes
#print axioms FT1536.GameByte.nonceBytes
#check @FT1536.GameByte.nonceBytes_length
#print axioms FT1536.GameByte.nonceBytes_length
#check @FT1536.GameByte.nonceBytes_val
#print axioms FT1536.GameByte.nonceBytes_val
#check @FT1536.GameByte.nonceOf
#print axioms FT1536.GameByte.nonceOf
#check @FT1536.GameByte.nonceBytes_nonceOf
#print axioms FT1536.GameByte.nonceBytes_nonceOf
#check @FT1536.GameByte.nonceOf_nonceBytes
#print axioms FT1536.GameByte.nonceOf_nonceBytes
#check @FT1536.GameByte.nonceBytes_injective
#print axioms FT1536.GameByte.nonceBytes_injective
#check @FT1536.GameByte.NameKind
#print axioms FT1536.GameByte.NameKind
#check @FT1536.GameByte.signName
#print axioms FT1536.GameByte.signName
#check @FT1536.GameByte.render
#print axioms FT1536.GameByte.render
#check @FT1536.GameByte.signName_length
#print axioms FT1536.GameByte.signName_length
#check @FT1536.GameByte.render_sign_frame
#print axioms FT1536.GameByte.render_sign_frame
#check @FT1536.GameByte.pair_framing
#print axioms FT1536.GameByte.pair_framing
#check @FT1536.GameByte.signName_injective
#print axioms FT1536.GameByte.signName_injective
#check @FT1536.GameByte.short_ne_sign
#print axioms FT1536.GameByte.short_ne_sign
#check @FT1536.GameByte.render_injective
#print axioms FT1536.GameByte.render_injective
#check @FT1536.GameByte.long_names_distinct
#print axioms FT1536.GameByte.long_names_distinct
#check @FT1536.GameNames.NameBody
#print axioms FT1536.GameNames.NameBody
#check @FT1536.GameNames.take40_len
#print axioms FT1536.GameNames.take40_len
#check @FT1536.GameNames.length_take40
#print axioms FT1536.GameNames.length_take40
#check @FT1536.GameNames.nonceOfBytes
#print axioms FT1536.GameNames.nonceOfBytes
#check @FT1536.GameNames.bytesLE_bytesVal40
#print axioms FT1536.GameNames.bytesLE_bytesVal40
#check @FT1536.GameNames.nonceBytes_nonceOfBytes
#print axioms FT1536.GameNames.nonceBytes_nonceOfBytes
#check @FT1536.GameNames.nonceOfBytes_nonceBytes
#print axioms FT1536.GameNames.nonceOfBytes_nonceBytes
#check @FT1536.GameNames.decodeName
#print axioms FT1536.GameNames.decodeName
#check @FT1536.GameNames.decodeName_short
#print axioms FT1536.GameNames.decodeName_short
#check @FT1536.GameNames.decodeName_sign
#print axioms FT1536.GameNames.decodeName_sign
#check @FT1536.GameNames.render_decodeName
#print axioms FT1536.GameNames.render_decodeName
#check @FT1536.GameNames.decodeName_render
#print axioms FT1536.GameNames.decodeName_render
#check @FT1536.GameNames.nameKind_bijection
#print axioms FT1536.GameNames.nameKind_bijection
#check @FT1536.GameNames.embedName
#print axioms FT1536.GameNames.embedName
#check @FT1536.GameNames.paint
#print axioms FT1536.GameNames.paint
#check @FT1536.GameNames.WF
#print axioms FT1536.GameNames.WF
#check @FT1536.GameNames.paint_embedName
#print axioms FT1536.GameNames.paint_embedName
#check @FT1536.GameNames.embedName_injective
#print axioms FT1536.GameNames.embedName_injective
#check @FT1536.GameNames.embedName_wf
#print axioms FT1536.GameNames.embedName_wf
#check @FT1536.GameNames.paint_injective_wf
#print axioms FT1536.GameNames.paint_injective_wf
#check @FT1536.GameNames.tableAddr
#print axioms FT1536.GameNames.tableAddr
#check @FT1536.GameNames.tableAddr_wf
#print axioms FT1536.GameNames.tableAddr_wf
#check @FT1536.GameNames.paint_tableAddr
#print axioms FT1536.GameNames.paint_tableAddr
#check @FT1536.GameNames.tableAddr_injective
#print axioms FT1536.GameNames.tableAddr_injective
#check @FT1536.GameNames.take40_sign
#print axioms FT1536.GameNames.take40_sign
#check @FT1536.GameNames.drop40_sign
#print axioms FT1536.GameNames.drop40_sign
#check @FT1536.GameNames.nonceOfBytes_sign
#print axioms FT1536.GameNames.nonceOfBytes_sign
#check @FT1536.GameNames.tableAddr_sign
#print axioms FT1536.GameNames.tableAddr_sign
#check @FT1536.GameNames.tableAddr_short
#print axioms FT1536.GameNames.tableAddr_short
#check @FT1536.GameNames.short_addr_ne_sign
#print axioms FT1536.GameNames.short_addr_ne_sign
#check @FT1536.GameMach.Budget
#print axioms FT1536.GameMach.Budget
#check @FT1536.GameMach.Mode
#print axioms FT1536.GameMach.Mode
#check @FT1536.GameMach.Reply
#print axioms FT1536.GameMach.Reply
#check @FT1536.GameMach.Op
#print axioms FT1536.GameMach.Op
#check @FT1536.GameMach.Env
#print axioms FT1536.GameMach.Env
#check @FT1536.GameMach.Mach
#print axioms FT1536.GameMach.Mach
#check @FT1536.GameMach.init
#print axioms FT1536.GameMach.init
#check @FT1536.GameMach.sigVec
#print axioms FT1536.GameMach.sigVec
#check @FT1536.GameMach.Verdict
#print axioms FT1536.GameMach.Verdict
#check @FT1536.GameMach.signStep
#print axioms FT1536.GameMach.signStep
#check @FT1536.GameMach.step
#print axioms FT1536.GameMach.step
#check @FT1536.GameMach.step_eq
#print axioms FT1536.GameMach.step_eq
#check @FT1536.GameMach.stepBounded
#print axioms FT1536.GameMach.stepBounded
#check @FT1536.GameMach.stepBounded_eq_step_of_within
#print axioms FT1536.GameMach.stepBounded_eq_step_of_within
#check @FT1536.GameMach.signStep_seen
#print axioms FT1536.GameMach.signStep_seen
#check @FT1536.GameMach.signStep_used
#print axioms FT1536.GameMach.signStep_used
#check @FT1536.GameMach.step_sq_seen
#print axioms FT1536.GameMach.step_sq_seen
#check @FT1536.GameMach.stopped_absorbing
#print axioms FT1536.GameMach.stopped_absorbing
#check @FT1536.GameMach.sign_atomic
#print axioms FT1536.GameMach.sign_atomic
#check @FT1536.GameMach.used_le_of_step
#print axioms FT1536.GameMach.used_le_of_step
#check @FT1536.GameMach.signStep_table
#print axioms FT1536.GameMach.signStep_table
#check @FT1536.GameMach.verdict_fresh
#print axioms FT1536.GameMach.verdict_fresh
#check @FT1536.PaidSteps.second_self
#print axioms FT1536.PaidSteps.second_self
#check @FT1536.PaidSteps.second_of_eq
#print axioms FT1536.PaidSteps.second_of_eq
#check @FT1536.PaidSteps.countPaid
#print axioms FT1536.PaidSteps.countPaid
#check @FT1536.PaidSteps.countPaid_succ
#print axioms FT1536.PaidSteps.countPaid_succ
#check @FT1536.PaidSteps.countPaid_zero
#print axioms FT1536.PaidSteps.countPaid_zero
#check @FT1536.PaidSteps.paid_counter_chi2
#print axioms FT1536.PaidSteps.paid_counter_chi2
#check @FT1536.PaidSteps.paid_counter_le
#print axioms FT1536.PaidSteps.paid_counter_le
#check @FT1536.PaidSteps.paid_event_bound
#print axioms FT1536.PaidSteps.paid_event_bound
#check @FT1536.PaidSteps.paid_trace_bound
#print axioms FT1536.PaidSteps.paid_trace_bound
#check @FT1536.PaidSteps.sign_frame_injective
#print axioms FT1536.PaidSteps.sign_frame_injective
#check @FT1536.PaidSteps.sign_conflict_risk
#print axioms FT1536.PaidSteps.sign_conflict_risk
#check @FT1536.PaidSteps.conflict_bound_shape
#print axioms FT1536.PaidSteps.conflict_bound_shape
#check @FT1536.PaidSteps.zero_paid_boundary
#print axioms FT1536.PaidSteps.zero_paid_boundary
#check @FT1536.Mixture.law_ext
#print axioms FT1536.Mixture.law_ext
#check @FT1536.Mixture.keyed_mass
#print axioms FT1536.Mixture.keyed_mass
#check @FT1536.Mixture.mixture_event_eq
#print axioms FT1536.Mixture.mixture_event_eq
#check @FT1536.Mixture.mixture_event_le
#print axioms FT1536.Mixture.mixture_event_le
#check @FT1536.Mixture.mixture_split
#print axioms FT1536.Mixture.mixture_split
#check @FT1536.Mixture.mixture_good_bound
#print axioms FT1536.Mixture.mixture_good_bound
#check @FT1536.Mixture.latent_secret_event
#print axioms FT1536.Mixture.latent_secret_event
#check @FT1536.Mixture.latent_secret_event_muH
#print axioms FT1536.Mixture.latent_secret_event_muH
#check @FT1536.Lazy.extendAt
#print axioms FT1536.Lazy.extendAt
#check @FT1536.Lazy.restrictTo
#print axioms FT1536.Lazy.restrictTo
#check @FT1536.Lazy.lastOf
#print axioms FT1536.Lazy.lastOf
#check @FT1536.Lazy.seqTargets_succ
#print axioms FT1536.Lazy.seqTargets_succ
#check @FT1536.Lazy.map_uniform_mass
#print axioms FT1536.Lazy.map_uniform_mass
#check @FT1536.Lazy.map_uniform_at
#print axioms FT1536.Lazy.map_uniform_at
#check @FT1536.Lazy.seqTargets_snoc
#print axioms FT1536.Lazy.seqTargets_snoc
#check @FT1536.Lazy.seqTargets_mass
#print axioms FT1536.Lazy.seqTargets_mass
#check @FT1536.Lazy.seqTargets_eq_uniform
#print axioms FT1536.Lazy.seqTargets_eq_uniform
#check @FT1536.Lazy.lazy_independence
#print axioms FT1536.Lazy.lazy_independence
#check @FT1536.GameLaw.replyEquiv
#print axioms FT1536.GameLaw.replyEquiv
#check @FT1536.GameLaw.LocalCert
#print axioms FT1536.GameLaw.LocalCert
#check @FT1536.GameLaw.map_mass_inj
#print axioms FT1536.GameLaw.map_mass_inj
#check @FT1536.GameLaw.map_mass_off
#print axioms FT1536.GameLaw.map_mass_off
#check @FT1536.GameLaw.second_map_inj
#print axioms FT1536.GameLaw.second_map_inj
#check @FT1536.GameLaw.ac_map
#print axioms FT1536.GameLaw.ac_map
#check @FT1536.GameLaw.signEnc
#print axioms FT1536.GameLaw.signEnc
#check @FT1536.GameLaw.signEnc_injective
#print axioms FT1536.GameLaw.signEnc_injective
#check @FT1536.GameLaw.sign_miss_reply_bound
#print axioms FT1536.GameLaw.sign_miss_reply_bound
#check @FT1536.GameLaw.finReply
#print axioms FT1536.GameLaw.finReply
#check @FT1536.GameLaw.advance
#print axioms FT1536.GameLaw.advance
#check @FT1536.GameLaw.sign_hit_shared
#print axioms FT1536.GameLaw.sign_hit_shared
#check @FT1536.GameLaw.paidFlag
#print axioms FT1536.GameLaw.paidFlag
#check @FT1536.GameLaw.game_kernel_identification
#print axioms FT1536.GameLaw.game_kernel_identification
#check @FT1536.GameLaw.conditional_shape
#print axioms FT1536.GameLaw.conditional_shape
#check @FT1536.PathCounter.countPath
#print axioms FT1536.PathCounter.countPath
#check @FT1536.PathCounter.countPath_succ
#print axioms FT1536.PathCounter.countPath_succ
#check @FT1536.PathCounter.countPath_zero
#print axioms FT1536.PathCounter.countPath_zero
#check @FT1536.PathCounter.stepRatio_split
#print axioms FT1536.PathCounter.stepRatio_split
#check @FT1536.PathCounter.potential_succ_le
#print axioms FT1536.PathCounter.potential_succ_le
#check @FT1536.PathCounter.potential_le_one
#print axioms FT1536.PathCounter.potential_le_one
#check @FT1536.PathCounter.paid_counter_pathwise
#print axioms FT1536.PathCounter.paid_counter_pathwise
#check @FT1536.AdversaryFold.Adv
#print axioms FT1536.AdversaryFold.Adv
#check @FT1536.AdversaryFold.paidAt
#print axioms FT1536.AdversaryFold.paidAt
#check @FT1536.AdversaryFold.bind_eq_map_snd
#print axioms FT1536.AdversaryFold.bind_eq_map_snd
#check @FT1536.AdversaryFold.map_mass_fiber
#print axioms FT1536.AdversaryFold.map_mass_fiber
#check @FT1536.AdversaryFold.fiber_zero
#print axioms FT1536.AdversaryFold.fiber_zero
#check @FT1536.AdversaryFold.second_map_le
#print axioms FT1536.AdversaryFold.second_map_le
#check @FT1536.AdversaryFold.ac_map_any
#print axioms FT1536.AdversaryFold.ac_map_any
#check @FT1536.AdversaryFold.signReply_bound
#print axioms FT1536.AdversaryFold.signReply_bound
#check @FT1536.AdversaryFold.signKernel_bound
#print axioms FT1536.AdversaryFold.signKernel_bound
#check @FT1536.AdversaryFold.adversary_fold_paid_flag_binding
#print axioms FT1536.AdversaryFold.adversary_fold_paid_flag_binding
#check @FT1536.BitCost.Cost
#print axioms FT1536.BitCost.Cost
#check @FT1536.BitCost.le_of_comp
#print axioms FT1536.BitCost.le_of_comp
#check @FT1536.BitCost.sum_comp
#print axioms FT1536.BitCost.sum_comp
#check @FT1536.BitCost.Kind
#print axioms FT1536.BitCost.Kind
#check @FT1536.BitCost.kindOf
#print axioms FT1536.BitCost.kindOf
#check @FT1536.BitCost.cnt
#print axioms FT1536.BitCost.cnt
#check @FT1536.BitCost.cnt_nil
#print axioms FT1536.BitCost.cnt_nil
#check @FT1536.BitCost.cnt_cons
#print axioms FT1536.BitCost.cnt_cons
#check @FT1536.BitCost.cmpCost
#print axioms FT1536.BitCost.cmpCost
#check @FT1536.BitCost.copyCost
#print axioms FT1536.BitCost.copyCost
#check @FT1536.BitCost.memCost
#print axioms FT1536.BitCost.memCost
#check @FT1536.BitCost.uniformDrawCost
#print axioms FT1536.BitCost.uniformDrawCost
#check @FT1536.BitCost.polyMulRemCost
#print axioms FT1536.BitCost.polyMulRemCost
#check @FT1536.BitCost.verifySteps
#print axioms FT1536.BitCost.verifySteps
#check @FT1536.BitCost.extractBytes
#print axioms FT1536.BitCost.extractBytes
#check @FT1536.BitCost.lookupCost
#print axioms FT1536.BitCost.lookupCost
#check @FT1536.BitCost.targetReadCost
#print axioms FT1536.BitCost.targetReadCost
#check @FT1536.BitCost.tableMem
#print axioms FT1536.BitCost.tableMem
#check @FT1536.BitCost.seenMem
#print axioms FT1536.BitCost.seenMem
#check @FT1536.BitCost.targetsMem
#print axioms FT1536.BitCost.targetsMem
#check @FT1536.BitCost.stateMem
#print axioms FT1536.BitCost.stateMem
#check @FT1536.BitCost.costOp
#print axioms FT1536.BitCost.costOp
#check @FT1536.BitCost.derivedResourceBound
#print axioms FT1536.BitCost.derivedResourceBound
#check @FT1536.BitCost.sum_components_t
#print axioms FT1536.BitCost.sum_components_t
#check @FT1536.BitCost.sum_components_L
#print axioms FT1536.BitCost.sum_components_L
#check @FT1536.BitCost.stateMem_mono
#print axioms FT1536.BitCost.stateMem_mono
#check @FT1536.BitCost.w_peak_bound
#print axioms FT1536.BitCost.w_peak_bound
#check @FT1536.BitCost.cost_composition
#print axioms FT1536.BitCost.cost_composition
#check @FT1536.BitCost.reducer_bit_cost_bound
#print axioms FT1536.BitCost.reducer_bit_cost_bound
#check @FT1536.FinalBind.hash_seen
#print axioms FT1536.FinalBind.hash_seen
#check @FT1536.FinalBind.readPath
#print axioms FT1536.FinalBind.readPath
#check @FT1536.FinalBind.isWin
#print axioms FT1536.FinalBind.isWin
#check @FT1536.FinalBind.isMT
#print axioms FT1536.FinalBind.isMT
#check @FT1536.FinalBind.hist_extraction_implication
#print axioms FT1536.FinalBind.hist_extraction_implication
#check @FT1536.FinalTheorem.hash_table_len
#print axioms FT1536.FinalTheorem.hash_table_len
#check @FT1536.FinalTheorem.badAt
#print axioms FT1536.FinalTheorem.badAt
#check @FT1536.FinalTheorem.isBad
#print axioms FT1536.FinalTheorem.isBad
#check @FT1536.FinalTheorem.kernelOf_halt_mass
#print axioms FT1536.FinalTheorem.kernelOf_halt_mass
#check @FT1536.GameCertificate.byte_frame_identity
#print axioms FT1536.GameCertificate.byte_frame_identity
#check @FT1536.GameCertificate.paid_counter_exact
#print axioms FT1536.GameCertificate.paid_counter_exact
#check @FT1536.GameCertificate.conflict_sum_exact
#print axioms FT1536.GameCertificate.conflict_sum_exact
#check @FT1536.GameCertificate.shared_step_identity
#print axioms FT1536.GameCertificate.shared_step_identity
#check @FT1536.GameCertificate.lazy_uniform_three
#print axioms FT1536.GameCertificate.lazy_uniform_three
#check @FT1536.GameCertificate.centering_values_game
#print axioms FT1536.GameCertificate.centering_values_game
