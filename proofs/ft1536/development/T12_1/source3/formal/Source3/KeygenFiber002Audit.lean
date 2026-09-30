import Source3.CertificateWorkspace
import Source3.FftLeafFrames
import Source3.KeygenNinv31

set_option pp.proofs true
set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Internal batch002 audit. The full emitted-KeyGen theorem is still open. -/
#check @FT1536.Source3.C99InitializationTrace.steps_preserve
#print FT1536.Source3.C99InitializationTrace.steps_preserve
#print axioms FT1536.Source3.C99InitializationTrace.steps_preserve
#check @FT1536.Source3.CertificateWorkspace.suffix_wellFormed
#print FT1536.Source3.CertificateWorkspace.suffix_wellFormed
#print axioms FT1536.Source3.CertificateWorkspace.suffix_wellFormed
#check @FT1536.Source3.CertificateWorkspace.after_root_copy
#print FT1536.Source3.CertificateWorkspace.after_root_copy
#print axioms FT1536.Source3.CertificateWorkspace.after_root_copy
#check @FT1536.Source3.FprPrefixCalls.lookup_result
#print FT1536.Source3.FprPrefixCalls.lookup_result
#print axioms FT1536.Source3.FprPrefixCalls.lookup_result
#check @FT1536.Source3.C99ArrayReference.memory_steps
#print FT1536.Source3.C99ArrayReference.memory_steps
#print axioms FT1536.Source3.C99ArrayReference.memory_steps
#check @FT1536.Source3.FftLeafPrograms.source_name
#print FT1536.Source3.FftLeafPrograms.source_name
#print axioms FT1536.Source3.FftLeafPrograms.source_name
#check @FT1536.Source3.FftLeafPrograms.call_preserves_initialization
#print FT1536.Source3.FftLeafPrograms.call_preserves_initialization
#print axioms FT1536.Source3.FftLeafPrograms.call_preserves_initialization
#check @FT1536.Source3.C99ArrayFrame.body_frame
#print FT1536.Source3.C99ArrayFrame.body_frame
#print axioms FT1536.Source3.C99ArrayFrame.body_frame
#check @FT1536.Source3.FftLeafFrames.parsed_body_frame
#print FT1536.Source3.FftLeafFrames.parsed_body_frame
#print axioms FT1536.Source3.FftLeafFrames.parsed_body_frame
#check @FT1536.Source3.KeygenModpWord.source_parses
#print FT1536.Source3.KeygenModpWord.source_parses
#print axioms FT1536.Source3.KeygenModpWord.source_parses
#check @FT1536.Source3.KeygenModpWord.source_exists
#print FT1536.Source3.KeygenModpWord.source_exists
#print axioms FT1536.Source3.KeygenModpWord.source_exists
#check @FT1536.Source3.KeygenModpWord.source_exact
#print FT1536.Source3.KeygenModpWord.source_exact
#print axioms FT1536.Source3.KeygenModpWord.source_exact
#check @FT1536.Source3.MontgomeryArithmetic.reduction_contract
#print FT1536.Source3.MontgomeryArithmetic.reduction_contract
#print axioms FT1536.Source3.MontgomeryArithmetic.reduction_contract
#check @FT1536.Source3.KeygenMontgomery.low_product
#print FT1536.Source3.KeygenMontgomery.low_product
#print axioms FT1536.Source3.KeygenMontgomery.low_product
#check @FT1536.Source3.KeygenMontgomery.source_reduction_contract
#print FT1536.Source3.KeygenMontgomery.source_reduction_contract
#print axioms FT1536.Source3.KeygenMontgomery.source_reduction_contract
#check @FT1536.Source3.KeygenNinv31.source_parses
#print FT1536.Source3.KeygenNinv31.source_parses
#print axioms FT1536.Source3.KeygenNinv31.source_parses
#check @FT1536.Source3.KeygenNinv31.source_exists
#print FT1536.Source3.KeygenNinv31.source_exists
#print axioms FT1536.Source3.KeygenNinv31.source_exists
#check @FT1536.Source3.KeygenNinv31.source_exact
#print FT1536.Source3.KeygenNinv31.source_exact
#print axioms FT1536.Source3.KeygenNinv31.source_exact
#check @FT1536.Source3.KeygenNinv31.inverse_identity
#print FT1536.Source3.KeygenNinv31.inverse_identity
#print axioms FT1536.Source3.KeygenNinv31.inverse_identity
#check @FT1536.Source3.KeygenNinv31.initialized_montgomery_contract
#print FT1536.Source3.KeygenNinv31.initialized_montgomery_contract
#print axioms FT1536.Source3.KeygenNinv31.initialized_montgomery_contract
