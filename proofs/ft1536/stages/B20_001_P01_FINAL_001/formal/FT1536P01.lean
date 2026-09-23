import B20.Foundation.Core
import B20.Foundation.CExec
import B20.Foundation.SourceBinding
import B20.Foundation.Certificate
import B20.Foundation.CertificateTransport
import B20.Foundation.Probability
import B20.Foundation.EndToEnd

/-! # Axiom scan of every named export (TASK §5)

No export may depend on a target axiom; only standard library axioms
(`propext`, `Quot.sound`, `Classical.choice`) are tolerated and listed. -/

-- CExec family
#print axioms B20.Foundation.evalStmt_sound
#print axioms B20.Foundation.CExec_complete
#print axioms B20.Foundation.compile_refines
#print axioms B20.Foundation.Outcome.stuck_ne_abort
#print axioms B20.Foundation.u64Add_toNat

-- SourceBinding family
#print axioms B20.Foundation.checker_sound
#print axioms B20.Foundation.SourceBinding.checker_sound
#print axioms B20.Foundation.source17ReturnZero_translation
#print axioms B20.Foundation.source17ReturnZero_binding
#print axioms B20.Foundation.mutated_constant_rejected
#print axioms B20.Foundation.mutated_constant_translation_rejected
#print axioms B20.Foundation.mutated_operator_rejected
#print axioms B20.Foundation.mutated_operator_translation_rejected
#print axioms B20.Foundation.syntheticShape_binding

-- Certificate family
#print axioms B20.Foundation.certificate_sound
#print axioms B20.Foundation.CertificateSound
#print axioms B20.Foundation.sqrt2Witness_checked
#print axioms B20.Foundation.sqrt2Witness_sound
#print axioms B20.Foundation.false_inequality_rejected
#print axioms B20.Foundation.reversed_endpoint_rejected
#print axioms B20.Foundation.missing_denominator_rejected
#print axioms B20.Foundation.certificate_checker_discriminates

-- Certificate transport
#print axioms B20.Foundation.Transport.decodeNat_encodeNat
#print axioms B20.Foundation.Transport.lowerNum_transport
#print axioms B20.Foundation.Transport.upperNum_transport

-- ObservedKernel family
#print axioms B20.Foundation.totalVariation_self_zero
#print axioms B20.Foundation.directedChi2_self_zero
#print axioms B20.Foundation.pinned_observation_initState
#print axioms B20.Foundation.pinned_observed_initState
#print axioms B20.Foundation.pinned_tv_self
#print axioms B20.Foundation.pinned_chi2_self
#print axioms B20.Foundation.pinned_conditionalHistory_state
#print axioms B20.Foundation.pinned_conditionalHistory_fresh

-- End-to-end
#print axioms B20.Foundation.endToEnd_receipt_valid
#print axioms B20.Foundation.source17ReturnZero_exec
#print axioms B20.Foundation.endToEnd_chain
