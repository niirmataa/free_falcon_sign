import Source3.SelectedStageCertificate170_8

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicTriplePredicate170
open GeneratedPublicEvaluation170 (stage8 output)

def predicate (i : Fin 1536) : Prop := PublicEvaluationCertificate170.value output i.val=PublicRootArrayValues170.triple stage8 i.val
instance predicateDecidable : DecidablePred predicate := fun _ => ZMod.decidableEq 18433 _ _


end FT1536.Source3.PublicTriplePredicate170
