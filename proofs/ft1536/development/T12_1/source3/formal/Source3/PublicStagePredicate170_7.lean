import Source3.SelectedStageCertificate170_6

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicStagePredicate170_7
open GeneratedPublicEvaluation170 (stage6 stage7)

def predicate (i : Fin 1536) : Prop := PublicEvaluationCertificate170.value stage7 i.val=PublicRootArrayValues170.stage stage6 (KeygenPublicRadixStages.count 6) (KeygenPublicRadixStages.size 6/2) i.val
instance predicateDecidable : DecidablePred predicate := fun _ => ZMod.decidableEq 18433 _ _


end FT1536.Source3.PublicStagePredicate170_7
