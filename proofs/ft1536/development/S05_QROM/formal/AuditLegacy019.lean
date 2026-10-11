import JointInterface019
import ObservationMoment019
import ReferenceJoint019
import DyadicBridge019
import ReferenceLower019
import ReferencePaid019
import KeyReferenceLower019
import BoundaryControls019
import SupportControl019
import StandaloneRuntime019
import LegacyPairWitness019
import RuntimeAgreement019
import StandaloneCertificate019

set_option pp.universes true
set_option pp.proofs false

#check @FT1536.S05.JointInterface019.law_ext
#print axioms FT1536.S05.JointInterface019.law_ext
#check @FT1536.S05.JointInterface019.map_mass
#print axioms FT1536.S05.JointInterface019.map_mass
#check @FT1536.S05.JointInterface019.map_map
#print axioms FT1536.S05.JointInterface019.map_map
#check @FT1536.S05.JointInterface019.marginal_mass
#print axioms FT1536.S05.JointInterface019.marginal_mass
#check @FT1536.S05.JointInterface019.marginal_joint
#print axioms FT1536.S05.JointInterface019.marginal_joint
#check @FT1536.S05.JointInterface019.fresh_marginal
#print axioms FT1536.S05.JointInterface019.fresh_marginal
#check @FT1536.S05.JointInterface019.pair_marginal
#print axioms FT1536.S05.JointInterface019.pair_marginal
#check @FT1536.S05.ObservationMoment019.fiberEnergy_nonneg
#print axioms FT1536.S05.ObservationMoment019.fiberEnergy_nonneg
#check @FT1536.S05.ObservationMoment019.mapped_cauchy
#print axioms FT1536.S05.ObservationMoment019.mapped_cauchy
#check @FT1536.S05.ObservationMoment019.map_ac
#print axioms FT1536.S05.ObservationMoment019.map_ac
#check @FT1536.S05.ObservationMoment019.mapped_atom_bound
#print axioms FT1536.S05.ObservationMoment019.mapped_atom_bound
#check @FT1536.S05.ObservationMoment019.sum_fiberEnergy
#print axioms FT1536.S05.ObservationMoment019.sum_fiberEnergy
#check @FT1536.S05.ObservationMoment019.map_second
#print axioms FT1536.S05.ObservationMoment019.map_second
#check @FT1536.S05.ObservationMoment019.full_observation
#print axioms FT1536.S05.ObservationMoment019.full_observation
#check @FT1536.S05.ReferenceJoint019.reference_joint
#print axioms FT1536.S05.ReferenceJoint019.reference_joint
#check @FT1536.S05.ReferenceJoint019.reference_mass
#print axioms FT1536.S05.ReferenceJoint019.reference_mass
#check @FT1536.S05.ReferenceJoint019.reference_marginal
#print axioms FT1536.S05.ReferenceJoint019.reference_marginal
#check @FT1536.S05.ReferenceJoint019.reference_normalized
#print axioms FT1536.S05.ReferenceJoint019.reference_normalized
#check @FT1536.S05.DyadicBridge019.uniform_map_card_dvd
#print axioms FT1536.S05.DyadicBridge019.uniform_map_card_dvd
#check @FT1536.S05.DyadicBridge019.rq_card
#print axioms FT1536.S05.DyadicBridge019.rq_card
#check @FT1536.S05.DyadicBridge019.no_bits_uniform_rq
#print axioms FT1536.S05.DyadicBridge019.no_bits_uniform_rq
#check @FT1536.S05.DyadicBridge019.no_exact_adapter
#print axioms FT1536.S05.DyadicBridge019.no_exact_adapter
#check @FT1536.S05.ReferenceLower019.ac_transfer
#print axioms FT1536.S05.ReferenceLower019.ac_transfer
#check @FT1536.S05.ReferenceLower019.atom_transfer
#print axioms FT1536.S05.ReferenceLower019.atom_transfer
#check @FT1536.S05.ReferenceLower019.second_transfer
#print axioms FT1536.S05.ReferenceLower019.second_transfer
#check @FT1536.S05.ReferenceLower019.budget_transfer
#print axioms FT1536.S05.ReferenceLower019.budget_transfer
#check @FT1536.S05.ReferenceLower019.paid_budget
#print axioms FT1536.S05.ReferenceLower019.paid_budget
#check @FT1536.S05.ReferenceLower019.paidError_one
#print axioms FT1536.S05.ReferenceLower019.paidError_one
#check @FT1536.S05.ReferencePaid019.paid_nonneg
#print axioms FT1536.S05.ReferencePaid019.paid_nonneg
#check @FT1536.S05.ReferencePaid019.observed_paid_budget
#print axioms FT1536.S05.ReferencePaid019.observed_paid_budget
#check @FT1536.S05.KeyReferenceLower019.joint_lower
#print axioms FT1536.S05.KeyReferenceLower019.joint_lower
#check @FT1536.S05.KeyReferenceLower019.joint_paid
#print axioms FT1536.S05.KeyReferenceLower019.joint_paid
#check @FT1536.S05.BoundaryControls019.impossible_pair
#print axioms FT1536.S05.BoundaryControls019.impossible_pair
#check @FT1536.S05.BoundaryControls019.independent_not_ac
#print axioms FT1536.S05.BoundaryControls019.independent_not_ac
#check @FT1536.S05.BoundaryControls019.different_joint
#print axioms FT1536.S05.BoundaryControls019.different_joint
#check @FT1536.S05.BoundaryControls019.same_marginals
#print axioms FT1536.S05.BoundaryControls019.same_marginals
#check @FT1536.S05.BoundaryControls019.same_failure_mass
#print axioms FT1536.S05.BoundaryControls019.same_failure_mass
#check @FT1536.S05.BoundaryControls019.reversed_lower_bound_fails
#print axioms FT1536.S05.BoundaryControls019.reversed_lower_bound_fails
#check @FT1536.S05.SupportControl019.raw_second_misleads
#print axioms FT1536.S05.SupportControl019.raw_second_misleads
#check @FT1536.S05.SupportControl019.no_chi2_certificate
#print axioms FT1536.S05.SupportControl019.no_chi2_certificate
#check @FT1536.S05.StandaloneRuntime019.value_lt
#print axioms FT1536.S05.StandaloneRuntime019.value_lt
#check @FT1536.S05.LegacyPairWitness019.law_eq
#print axioms FT1536.S05.LegacyPairWitness019.law_eq
#check @FT1536.S05.LegacyPairWitness019.all_h_ac
#print axioms FT1536.S05.LegacyPairWitness019.all_h_ac
#check @FT1536.S05.LegacyPairWitness019.certificate
#print axioms FT1536.S05.LegacyPairWitness019.certificate
#check @FT1536.S05.LegacyPairWitness019.full_observation
#print axioms FT1536.S05.LegacyPairWitness019.full_observation
#check @FT1536.S05.LegacyPairWitness019.same_key_law
#print axioms FT1536.S05.LegacyPairWitness019.same_key_law
#check @FT1536.S05.RuntimeAgreement019.value_eq
#print axioms FT1536.S05.RuntimeAgreement019.value_eq
#check @FT1536.S05.RuntimeAgreement019.word_eq
#print axioms FT1536.S05.RuntimeAgreement019.word_eq
#check @FT1536.S05.RuntimeAgreement019.first_eq
#print axioms FT1536.S05.RuntimeAgreement019.first_eq
#check @FT1536.S05.RuntimeAgreement019.search_eq
#print axioms FT1536.S05.RuntimeAgreement019.search_eq
#check @FT1536.S05.RuntimeAgreement019.coord_eq
#print axioms FT1536.S05.RuntimeAgreement019.coord_eq
#check @FT1536.S05.RuntimeAgreement019.pairTrial_eq
#print axioms FT1536.S05.RuntimeAgreement019.pairTrial_eq
#check @FT1536.S05.RuntimeAgreement019.pair_eq
#print axioms FT1536.S05.RuntimeAgreement019.pair_eq
#check @FT1536.S05.RuntimeAgreement019.vector_eq
#print axioms FT1536.S05.RuntimeAgreement019.vector_eq
#check @FT1536.S05.RuntimeAgreement019.normTrial_eq
#print axioms FT1536.S05.RuntimeAgreement019.normTrial_eq
#check @FT1536.S05.RuntimeAgreement019.cubeCoord_eq
#print axioms FT1536.S05.RuntimeAgreement019.cubeCoord_eq
#check @FT1536.S05.RuntimeAgreement019.cube_eq
#print axioms FT1536.S05.RuntimeAgreement019.cube_eq
#check @FT1536.S05.RuntimeAgreement019.selected_eq
#print axioms FT1536.S05.RuntimeAgreement019.selected_eq
#check @FT1536.S05.RuntimeAgreement019.seedEquiv_eq
#print axioms FT1536.S05.RuntimeAgreement019.seedEquiv_eq
#check @FT1536.S05.RuntimeAgreement019.scatter_step_eq
#print axioms FT1536.S05.RuntimeAgreement019.scatter_step_eq
#check @FT1536.S05.RuntimeAgreement019.indices_eq
#print axioms FT1536.S05.RuntimeAgreement019.indices_eq
#check @FT1536.S05.RuntimeAgreement019.multiply_eq
#print axioms FT1536.S05.RuntimeAgreement019.multiply_eq
#check @FT1536.S05.RuntimeAgreement019.challenge_eq
#print axioms FT1536.S05.RuntimeAgreement019.challenge_eq
#check @FT1536.S05.RuntimeAgreement019.tables_eq
#print axioms FT1536.S05.RuntimeAgreement019.tables_eq
#check @FT1536.S05.RuntimeAgreement019.run_eq
#print axioms FT1536.S05.RuntimeAgreement019.run_eq
#check @FT1536.S05.RuntimeAgreement019.outputView_eq
#print axioms FT1536.S05.RuntimeAgreement019.outputView_eq
#check @FT1536.S05.RuntimeAgreement019.publicCode_eq
#print axioms FT1536.S05.RuntimeAgreement019.publicCode_eq
#check @FT1536.S05.StandaloneCertificate019.actual_certificate
#print axioms FT1536.S05.StandaloneCertificate019.actual_certificate
#check @FT1536.S05.StandaloneCertificate019.actual_all_h_ac
#print axioms FT1536.S05.StandaloneCertificate019.actual_all_h_ac
#check @FT1536.S05.StandaloneCertificate019.actual_full_observation
#print axioms FT1536.S05.StandaloneCertificate019.actual_full_observation
#check @FT1536.S05.StandaloneCertificate019.actual_no_exact_noise
#print axioms FT1536.S05.StandaloneCertificate019.actual_no_exact_noise
#check @FT1536.S05.StandaloneCertificate019.actual_paid_noise
#print axioms FT1536.S05.StandaloneCertificate019.actual_paid_noise
#check @FT1536.S05.StandaloneCertificate019.actual_same_key_law
#print axioms FT1536.S05.StandaloneCertificate019.actual_same_key_law
#check @FT1536.S05.StandaloneCertificate019.actual_same_key_paid
#print axioms FT1536.S05.StandaloneCertificate019.actual_same_key_paid
