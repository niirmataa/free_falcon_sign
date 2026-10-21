import Source3.ZintNormWalk194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- DIAGNOSTIC axiom audit (a record, not proof evidence): prints the
   axioms of the 512-step normalize loop exports accepted in job 529.
   No statement is claimed here. -/
namespace FT1536.Source3.ZintNormWalkAudit194

#print axioms FT1536.Source3.ZintNormWalk194.norm_loop
#print axioms FT1536.Source3.ZintNormWalk194.walkImage_cells
#print axioms FT1536.Source3.ZintNormWalk194.walk_fuel
#print axioms FT1536.Source3.ZintNormWalk194.walk_run

end FT1536.Source3.ZintNormWalkAudit194
