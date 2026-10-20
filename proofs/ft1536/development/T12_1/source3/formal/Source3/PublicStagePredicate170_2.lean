import Source3.SelectedStageCertificate170_1

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicStagePredicate170_2
open GeneratedPublicEvaluation170 (stage1 stage2)

def predicate (i : Fin 1536) : Prop := PublicEvaluationCertificate170.value stage2 i.val=PublicRootArrayValues170.stage stage1 (KeygenPublicRadixStages.count 1) (KeygenPublicRadixStages.size 1/2) i.val
instance predicateDecidable : DecidablePred predicate := fun _ => ZMod.decidableEq 18433 _ _


end FT1536.Source3.PublicStagePredicate170_2
