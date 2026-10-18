import Source3.SelectedInputCertificate170
import Source3.PublicRootArrayValues170

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicFirstPredicate170
open GeneratedPublicEvaluation170 (input first)

def predicate (i : Fin 1536) : Prop := PublicEvaluationCertificate170.value first i.val=PublicEvaluationCertificate170.firstValue input (PublicEvaluationCertificate170.value GeneratedPublicEvaluation170.roots 1) i.val
instance predicateDecidable : DecidablePred predicate := fun _ => ZMod.decidableEq 18433 _ _


end FT1536.Source3.PublicFirstPredicate170
