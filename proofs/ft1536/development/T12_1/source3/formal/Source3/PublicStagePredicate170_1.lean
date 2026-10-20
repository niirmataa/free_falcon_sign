import Source3.SelectedFirstCertificate170

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicStagePredicate170_1
open GeneratedPublicEvaluation170 (first stage1)

def predicate (i : Fin 1536) : Prop := PublicEvaluationCertificate170.value stage1 i.val=PublicRootArrayValues170.stage first (KeygenPublicRadixStages.count 0) (KeygenPublicRadixStages.size 0/2) i.val
instance predicateDecidable : DecidablePred predicate := fun _ => ZMod.decidableEq 18433 _ _


end FT1536.Source3.PublicStagePredicate170_1
