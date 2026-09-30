import Source3.KeygenFiberAssembly
import Source3.KeygenMaterial
import Source3.Gate00Memory
import Source3.CertificateReturnLifetime

set_option pp.proofs true
set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Audit of INTERNAL exports. The requested emitted_to_actual_fiber source
   theorem is not present; no audit of it or completion is claimed. -/
#check @FT1536.Source3.KeygenIntegerLift.fold_remainder
#print FT1536.Source3.KeygenIntegerLift.fold_remainder
#print axioms FT1536.Source3.KeygenIntegerLift.fold_remainder
#check @FT1536.Source3.KeygenIntegerLift.residual_bound
#print FT1536.Source3.KeygenIntegerLift.residual_bound
#print axioms FT1536.Source3.KeygenIntegerLift.residual_bound
#check @FT1536.Source3.KeygenIntegerLift.exact_ntru_of_modular_check
#print FT1536.Source3.KeygenIntegerLift.exact_ntru_of_modular_check
#print axioms FT1536.Source3.KeygenIntegerLift.exact_ntru_of_modular_check
#check @FT1536.Source3.KeygenFiberAssembly.from_modular_check
#print FT1536.Source3.KeygenFiberAssembly.from_modular_check
#print axioms FT1536.Source3.KeygenFiberAssembly.from_modular_check
#check @FT1536.Source3.KeygenSmallOutput.source_plain
#print FT1536.Source3.KeygenSmallOutput.source_plain
#print axioms FT1536.Source3.KeygenSmallOutput.source_plain
#check @FT1536.Source3.KeygenSmallOutput.source_body
#print FT1536.Source3.KeygenSmallOutput.source_body
#print axioms FT1536.Source3.KeygenSmallOutput.source_body
#check @FT1536.Source3.KeygenSmallOutput.narrowed_exact
#print FT1536.Source3.KeygenSmallOutput.narrowed_exact
#print axioms FT1536.Source3.KeygenSmallOutput.narrowed_exact
#check @FT1536.Source3.KeygenSmallOutput.output_range
#print FT1536.Source3.KeygenSmallOutput.output_range
#print axioms FT1536.Source3.KeygenSmallOutput.output_range
#check @FT1536.Source3.KeygenMaterial.converted_material
#print FT1536.Source3.KeygenMaterial.converted_material
#print axioms FT1536.Source3.KeygenMaterial.converted_material
#check @FT1536.Source3.C99CompareObjects.source_decomposition
#print FT1536.Source3.C99CompareObjects.source_decomposition
#print axioms FT1536.Source3.C99CompareObjects.source_decomposition
#check @FT1536.Source3.C99CompareObjects.exact_result
#print FT1536.Source3.C99CompareObjects.exact_result
#print axioms FT1536.Source3.C99CompareObjects.exact_result
#check @FT1536.Source3.C99CompareObjects.exists_execution
#print FT1536.Source3.C99CompareObjects.exists_execution
#print axioms FT1536.Source3.C99CompareObjects.exists_execution
#check @FT1536.Source3.Gate00Scalar.exact_result
#print FT1536.Source3.Gate00Scalar.exact_result
#print axioms FT1536.Source3.Gate00Scalar.exact_result
#check @FT1536.Source3.Gate00Scalar.exists_execution
#print FT1536.Source3.Gate00Scalar.exists_execution
#print axioms FT1536.Source3.Gate00Scalar.exists_execution
#check @FT1536.Source3.Gate00Memory.step_frame
#print FT1536.Source3.Gate00Memory.step_frame
#print axioms FT1536.Source3.Gate00Memory.step_frame
#check @FT1536.Source3.Gate00Memory.accepted_words
#print FT1536.Source3.Gate00Memory.accepted_words
#print axioms FT1536.Source3.Gate00Memory.accepted_words
#check @FT1536.Source3.Gate00Memory.source_checks_768
#print FT1536.Source3.Gate00Memory.source_checks_768
#print axioms FT1536.Source3.Gate00Memory.source_checks_768
#check @FT1536.Source3.CertificateReturnLifetime.dead_read_impossible
#print FT1536.Source3.CertificateReturnLifetime.dead_read_impossible
#print axioms FT1536.Source3.CertificateReturnLifetime.dead_read_impossible
#check @FT1536.Source3.CertificateReturnLifetime.source_return_observation
#print FT1536.Source3.CertificateReturnLifetime.source_return_observation
#print axioms FT1536.Source3.CertificateReturnLifetime.source_return_observation
#check @FT1536.Source3.CertificateReturnLifetime.accepted_snapshot
#print FT1536.Source3.CertificateReturnLifetime.accepted_snapshot
#print axioms FT1536.Source3.CertificateReturnLifetime.accepted_snapshot
