import Source3.ZintNormWord194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- DIAGNOSTIC axiom audit (a record, not proof evidence): prints the
   axioms of the normZero/zint_sub engine exports accepted in jobs
   520/524. No statement is claimed here. -/
namespace FT1536.Source3.ZintNormAudit194

#print axioms FT1536.Source3.ZintSubWord194.sub_run
#print axioms FT1536.Source3.ZintSubWord194.call_len1
#print axioms FT1536.Source3.ZintSubWord194.sub_shape
#print axioms FT1536.Source3.ZintNormWord194.norm_shape
#print axioms FT1536.Source3.ZintNormWord194.norm_run
#print axioms FT1536.Source3.ZintNormWord194.norm_call

end FT1536.Source3.ZintNormAudit194
