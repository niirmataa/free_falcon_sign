import Source3.SelectedStageCertificate170_2

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicStagePredicate170_3
open GeneratedPublicEvaluation170 (stage2 stage3)

def predicate (i : Fin 1536) : Prop := PublicEvaluationCertificate170.value stage3 i.val=PublicRootArrayValues170.stage stage2 (KeygenPublicRadixStages.count 2) (KeygenPublicRadixStages.size 2/2) i.val
instance predicateDecidable : DecidablePred predicate := fun _ => ZMod.decidableEq 18433 _ _


end FT1536.Source3.PublicStagePredicate170_3
