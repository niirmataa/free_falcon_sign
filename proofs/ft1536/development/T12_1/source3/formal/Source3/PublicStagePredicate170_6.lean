import Source3.SelectedStageCertificate170_5

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicStagePredicate170_6
open GeneratedPublicEvaluation170 (stage5 stage6)

def predicate (i : Fin 1536) : Prop := PublicEvaluationCertificate170.value stage6 i.val=PublicRootArrayValues170.stage stage5 (KeygenPublicRadixStages.count 5) (KeygenPublicRadixStages.size 5/2) i.val
instance predicateDecidable : DecidablePred predicate := fun _ => ZMod.decidableEq 18433 _ _


end FT1536.Source3.PublicStagePredicate170_6
