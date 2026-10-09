import Source3.KeygenPublicFirstFold

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Diagnostic probe (parser/type/axiom readout, NOT a correctness theorem):
   prints the exact headline type and the axioms it depends on. -/
#check @FT1536.Source3.KeygenPublicFirstFold.source_first_fold
#print axioms FT1536.Source3.KeygenPublicFirstFold.source_first_fold
#print axioms FT1536.Source3.KeygenPublicFirstFold.loop_result
#print axioms FT1536.Source3.KeygenPublicFirstFold.body_data
#print axioms FT1536.Source3.KeygenPublicFirstFold.folded
