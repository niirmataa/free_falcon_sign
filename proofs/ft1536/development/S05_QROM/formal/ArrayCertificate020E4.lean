import ArrayDriver020E4
import MachineCertificate020D

namespace FT1536.S05.ArrayCertificate020E4
open WordRAM020 FT1536.Relation

theorem all_h_ac (h : Rq) : Divergence.AC (ArrayDriver020E4.law h) (MachineCertificate020D.reference h) := by
  rw [ArrayDriver020E4.law_eq]
  exact MachineCertificate020D.all_h_ac h initial

theorem certificate (h : Rq) (mass : SamplerMassCondition014.MassCondition h) :
    Divergence.AC (ArrayDriver020E4.law h) (MachineCertificate020D.reference h) ∧
      Divergence.second (ArrayDriver020E4.law h) (MachineCertificate020D.reference h)≤1+1/2^47 := by
  rw [ArrayDriver020E4.law_eq]
  exact MachineCertificate020D.public_initial h mass

theorem same_key_law (domain : Rq → Prop) (mu : Law Rq) (cover : KeySupport011.Covered mu domain)
    (mass : ∀ h,domain h → SamplerMassCondition014.MassCondition h) :
    Divergence.AC (Divergence.joint mu ArrayDriver020E4.law) (Divergence.joint mu MachineCertificate020D.reference) ∧
    Divergence.second (Divergence.joint mu ArrayDriver020E4.law) (Divergence.joint mu MachineCertificate020D.reference)≤1+1/2^47 := by
  have he : ArrayDriver020E4.law=fun h => MachineLaw020D.law h initial := funext ArrayDriver020E4.law_eq
  rw [he]
  exact MachineCertificate020D.same_key_law domain mu cover mass (fun _ => initial)

end FT1536.S05.ArrayCertificate020E4
