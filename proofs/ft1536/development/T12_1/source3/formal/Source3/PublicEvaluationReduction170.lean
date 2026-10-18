import Source3.GeneratedPublicEvaluation170

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicEvaluationReduction170
open KeygenPublicAlgebra (R)

theorem field_zero : (0 : R)=(0 : Int) := by decide +kernel
theorem field_one : (1 : R)=(1 : Int) := by decide +kernel
theorem field_minus : (18432 : R)=(-1 : Int) := by decide +kernel
theorem first_nat : GeneratedPublicEvaluation170.input[0]?.getD 0=18432 := by decide +kernel

theorem first_word : SelectedSamplerWords158.fValues ⟨0,by decide⟩=65535 := by decide +kernel
theorem first_int : (SelectedSamplerWords158.fValues ⟨0,by decide⟩).toInt=(-1 : Int) := by decide +kernel
theorem first_cast : ((SelectedSamplerWords158.fValues ⟨0,by decide⟩).toInt : R)=18432 := by decide +kernel
theorem first_combined : PublicEvaluationCertificate170.value GeneratedPublicEvaluation170.input 0=
    ((SelectedSamplerWords158.fValues ⟨0,by decide⟩).toInt : R) := by decide +kernel

end FT1536.Source3.PublicEvaluationReduction170
