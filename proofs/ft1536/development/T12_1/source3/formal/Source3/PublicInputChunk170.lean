import Source3.PublicFiniteChecks170

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicInputChunk170
open KeygenPublicAlgebra (R)

theorem first_sixteen : (List.finRange 16).all (fun i => decide
    (PublicEvaluationCertificate170.value GeneratedPublicEvaluation170.input i.val=
      ((SelectedSamplerWords158.fValues ⟨i.val,by have h:=i.isLt; omega⟩).toInt : R)))=true := by decide +kernel

end FT1536.Source3.PublicInputChunk170
