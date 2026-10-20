import Source3.SelectedStageCertificate170_3

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicStagePredicate170_4
open GeneratedPublicEvaluation170 (stage3 stage4)

def predicate (i : Fin 1536) : Prop := PublicEvaluationCertificate170.value stage4 i.val=PublicRootArrayValues170.stage stage3 (KeygenPublicRadixStages.count 3) (KeygenPublicRadixStages.size 3/2) i.val
instance predicateDecidable : DecidablePred predicate := fun _ => ZMod.decidableEq 18433 _ _


end FT1536.Source3.PublicStagePredicate170_4
