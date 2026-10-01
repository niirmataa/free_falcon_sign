import Source3.SmallintsInvocation
import Source3.CertificateDeclarations
import Source3.CertificateConversions

/- Entry and closed conversion-call exports. The whole B1 bridge is open. -/
#check @FT1536.Source3.C99ArrayReference.memory_steps
#print FT1536.Source3.C99ArrayReference.memory_steps
#print axioms FT1536.Source3.C99ArrayReference.memory_steps
#check @FT1536.Source3.C99ProcedureScalars.sequence_complete
#print FT1536.Source3.C99ProcedureScalars.sequence_complete
#print axioms FT1536.Source3.C99ProcedureScalars.sequence_complete
#check @FT1536.Source3.C99ProcedureScalars.sequence_sound
#print FT1536.Source3.C99ProcedureScalars.sequence_sound
#print axioms FT1536.Source3.C99ProcedureScalars.sequence_sound
#check @FT1536.Source3.CertificatePrologue.source_bound
#print FT1536.Source3.CertificatePrologue.source_bound
#print axioms FT1536.Source3.CertificatePrologue.source_bound
#check @FT1536.Source3.CertificatePrologue.source_result
#print FT1536.Source3.CertificatePrologue.source_result
#print axioms FT1536.Source3.CertificatePrologue.source_result
#check @FT1536.Source3.CertificatePrologue.source_exists
#print FT1536.Source3.CertificatePrologue.source_exists
#print axioms FT1536.Source3.CertificatePrologue.source_exists
#check @FT1536.Source3.CertificateAliases.source_bound
#print FT1536.Source3.CertificateAliases.source_bound
#print axioms FT1536.Source3.CertificateAliases.source_bound
#check @FT1536.Source3.CertificateAliases.source_result
#print FT1536.Source3.CertificateAliases.source_result
#print axioms FT1536.Source3.CertificateAliases.source_result
#check @FT1536.Source3.CertificateAliases.source_exists
#print FT1536.Source3.CertificateAliases.source_exists
#print axioms FT1536.Source3.CertificateAliases.source_exists
#check @FT1536.Source3.CertificateDeclarations.source_bound
#print FT1536.Source3.CertificateDeclarations.source_bound
#print axioms FT1536.Source3.CertificateDeclarations.source_bound
#check @FT1536.Source3.CertificateDeclarations.source_result
#print FT1536.Source3.CertificateDeclarations.source_result
#print axioms FT1536.Source3.CertificateDeclarations.source_result
#check @FT1536.Source3.CertificateDeclarations.source_exists
#print FT1536.Source3.CertificateDeclarations.source_exists
#print axioms FT1536.Source3.CertificateDeclarations.source_exists
#check @FT1536.Source3.SmallintsProgram.source_body
#print FT1536.Source3.SmallintsProgram.source_body
#print axioms FT1536.Source3.SmallintsProgram.source_body
#check @FT1536.Source3.SmallintsProgram.source_header
#print FT1536.Source3.SmallintsProgram.source_header
#print axioms FT1536.Source3.SmallintsProgram.source_header
#check @FT1536.Source3.SmallintsProgram.source_frame
#print FT1536.Source3.SmallintsProgram.source_frame
#print axioms FT1536.Source3.SmallintsProgram.source_frame
#check @FT1536.Source3.C99CountedWords.guard_exact
#print FT1536.Source3.C99CountedWords.guard_exact
#print axioms FT1536.Source3.C99CountedWords.guard_exact
#check @FT1536.Source3.MknReference.source_value
#print FT1536.Source3.MknReference.source_value
#print axioms FT1536.Source3.MknReference.source_value
#check @FT1536.Source3.MknReference.source_exists
#print FT1536.Source3.MknReference.source_exists
#print axioms FT1536.Source3.MknReference.source_exists
#check @FT1536.Source3.SmallintsIteration.source_step
#print FT1536.Source3.SmallintsIteration.source_step
#print axioms FT1536.Source3.SmallintsIteration.source_step
#check @FT1536.Source3.SmallintsCounter.source_increment
#print FT1536.Source3.SmallintsCounter.source_increment
#print axioms FT1536.Source3.SmallintsCounter.source_increment
#check @FT1536.Source3.SmallintsLoopBridge.complete
#print FT1536.Source3.SmallintsLoopBridge.complete
#print axioms FT1536.Source3.SmallintsLoopBridge.complete
#check @FT1536.Source3.SmallintsPrelude.source_loop
#print FT1536.Source3.SmallintsPrelude.source_loop
#print axioms FT1536.Source3.SmallintsPrelude.source_loop
#check @FT1536.Source3.SmallintsPrelude.output_initialized
#print FT1536.Source3.SmallintsPrelude.output_initialized
#print axioms FT1536.Source3.SmallintsPrelude.output_initialized
#check @FT1536.Source3.SmallintsInvocation.parameter_bindings
#print FT1536.Source3.SmallintsInvocation.parameter_bindings
#print axioms FT1536.Source3.SmallintsInvocation.parameter_bindings
#check @FT1536.Source3.SmallintsInvocation.output_initialized
#print FT1536.Source3.SmallintsInvocation.output_initialized
#print axioms FT1536.Source3.SmallintsInvocation.output_initialized
#check @FT1536.Source3.SmallintsInvocation.memory_steps
#print FT1536.Source3.SmallintsInvocation.memory_steps
#print axioms FT1536.Source3.SmallintsInvocation.memory_steps
#check @FT1536.Source3.SmallintsInvocation.source_frame
#print FT1536.Source3.SmallintsInvocation.source_frame
#print axioms FT1536.Source3.SmallintsInvocation.source_frame
#check @FT1536.Source3.SmallintsInvocation.caller_bindings
#print FT1536.Source3.SmallintsInvocation.caller_bindings
#print axioms FT1536.Source3.SmallintsInvocation.caller_bindings
#check @FT1536.Source3.SmallintsInvocation.caller_frame
#print FT1536.Source3.SmallintsInvocation.caller_frame
#print axioms FT1536.Source3.SmallintsInvocation.caller_frame
#check @FT1536.Source3.CertificateConversions.source_bound
#print FT1536.Source3.CertificateConversions.source_bound
#print axioms FT1536.Source3.CertificateConversions.source_bound
#check @FT1536.Source3.CertificateConversions.memory_steps
#print FT1536.Source3.CertificateConversions.memory_steps
#print axioms FT1536.Source3.CertificateConversions.memory_steps
#check @FT1536.Source3.CertificateConversions.destination_initialized
#print FT1536.Source3.CertificateConversions.destination_initialized
#print axioms FT1536.Source3.CertificateConversions.destination_initialized
