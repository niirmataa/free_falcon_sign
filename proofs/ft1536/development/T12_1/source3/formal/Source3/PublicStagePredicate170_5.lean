import Source3.SelectedStageCertificate170_4

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicStagePredicate170_5
open GeneratedPublicEvaluation170 (stage4 stage5)

def predicate (i : Fin 1536) : Prop := PublicEvaluationCertificate170.value stage5 i.val=PublicRootArrayValues170.stage stage4 (KeygenPublicRadixStages.count 4) (KeygenPublicRadixStages.size 4/2) i.val
instance predicateDecidable : DecidablePred predicate := fun _ => ZMod.decidableEq 18433 _ _


end FT1536.Source3.PublicStagePredicate170_5
