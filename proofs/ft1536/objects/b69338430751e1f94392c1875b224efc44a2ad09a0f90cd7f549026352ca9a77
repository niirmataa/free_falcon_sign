import Source3.FftProcedureFrames

/- Internal declaration audit. The successful-KeyGen theorem is still open. -/
namespace FT1536.Source3.KeygenFiber003Audit
open C99ArrayReference

theorem reject_readonly_copy :
    C99PointerFootprint.only ["dst".toList]
      (.copy "src".toList "dst".toList (.literal .u64 0) (.literal .u64 0) (.literal .u64 8))=false := by decide
theorem reject_readonly_alias :
    C99PointerFootprint.only ["dst".toList,"alias_dst".toList]
      (.bindPtr "alias_dst".toList "src".toList (.literal .u64 0))=false := by decide
theorem reject_wrong_callee_destination :
    C99PointerFootprint.arguments ["dst".toList] ["out".toList]
      [.pointer "out".toList] [.pointer "src".toList (.literal .u64 0)]=false := by decide
end FT1536.Source3.KeygenFiber003Audit

#check @FT1536.Source3.C99ProcedureReference.memory_steps
#print FT1536.Source3.C99ProcedureReference.memory_steps
#print axioms FT1536.Source3.C99ProcedureReference.memory_steps
#check @FT1536.Source3.C99ProcedureReference.return_stops_sequence
#print FT1536.Source3.C99ProcedureReference.return_stops_sequence
#print axioms FT1536.Source3.C99ProcedureReference.return_stops_sequence
#check @FT1536.Source3.C99ProcedureReference.converted_return_type
#print FT1536.Source3.C99ProcedureReference.converted_return_type
#print axioms FT1536.Source3.C99ProcedureReference.converted_return_type
#check @FT1536.Source3.FpcSourceExpansion.source_bound
#print FT1536.Source3.FpcSourceExpansion.source_bound
#print axioms FT1536.Source3.FpcSourceExpansion.source_bound
#check @FT1536.Source3.FpcSourceExpansion.cached_bound
#print FT1536.Source3.FpcSourceExpansion.cached_bound
#print axioms FT1536.Source3.FpcSourceExpansion.cached_bound
#check @FT1536.Source3.FftProcedurePrograms.header_bound
#print FT1536.Source3.FftProcedurePrograms.header_bound
#print axioms FT1536.Source3.FftProcedurePrograms.header_bound
#check @FT1536.Source3.FftProcedurePrograms.signatures_source
#print FT1536.Source3.FftProcedurePrograms.signatures_source
#print axioms FT1536.Source3.FftProcedurePrograms.signatures_source
#check @FT1536.Source3.FftProcedurePrograms.fft_source
#print FT1536.Source3.FftProcedurePrograms.fft_source
#print axioms FT1536.Source3.FftProcedurePrograms.fft_source
#check @FT1536.Source3.FftProcedurePrograms.ldlTop_source
#print FT1536.Source3.FftProcedurePrograms.ldlTop_source
#print axioms FT1536.Source3.FftProcedurePrograms.ldlTop_source
#check @FT1536.Source3.C99PointerFootprint.body_frame
#print FT1536.Source3.C99PointerFootprint.body_frame
#print axioms FT1536.Source3.C99PointerFootprint.body_frame
#check @FT1536.Source3.C99PointerFootprint.copy_frame
#print FT1536.Source3.C99PointerFootprint.copy_frame
#print axioms FT1536.Source3.C99PointerFootprint.copy_frame
#check @FT1536.Source3.C99PointerFootprint.bind_outside
#print FT1536.Source3.C99PointerFootprint.bind_outside
#print axioms FT1536.Source3.C99PointerFootprint.bind_outside
#check @FT1536.Source3.C99ProcedureFootprint.body_frame
#print FT1536.Source3.C99ProcedureFootprint.body_frame
#print axioms FT1536.Source3.C99ProcedureFootprint.body_frame
#check @FT1536.Source3.FftProcedureFrames.audit_all
#print FT1536.Source3.FftProcedureFrames.audit_all
#print axioms FT1536.Source3.FftProcedureFrames.audit_all
#check @FT1536.Source3.FftProcedureFrames.aligned
#print FT1536.Source3.FftProcedureFrames.aligned
#print axioms FT1536.Source3.FftProcedureFrames.aligned
#check @FT1536.Source3.FftProcedureFrames.closed
#print FT1536.Source3.FftProcedureFrames.closed
#print axioms FT1536.Source3.FftProcedureFrames.closed
#check @FT1536.Source3.FftProcedureFrames.parsed_body_frame
#print FT1536.Source3.FftProcedureFrames.parsed_body_frame
#print axioms FT1536.Source3.FftProcedureFrames.parsed_body_frame
#check @FT1536.Source3.KeygenFiber003Audit.reject_readonly_copy
#print FT1536.Source3.KeygenFiber003Audit.reject_readonly_copy
#print axioms FT1536.Source3.KeygenFiber003Audit.reject_readonly_copy
#check @FT1536.Source3.KeygenFiber003Audit.reject_readonly_alias
#print FT1536.Source3.KeygenFiber003Audit.reject_readonly_alias
#print axioms FT1536.Source3.KeygenFiber003Audit.reject_readonly_alias
#check @FT1536.Source3.KeygenFiber003Audit.reject_wrong_callee_destination
#print FT1536.Source3.KeygenFiber003Audit.reject_wrong_callee_destination
#print axioms FT1536.Source3.KeygenFiber003Audit.reject_wrong_callee_destination
