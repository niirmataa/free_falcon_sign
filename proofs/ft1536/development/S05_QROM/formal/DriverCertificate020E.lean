import PublicDriver020E
import MachineCertificate020D

namespace FT1536.S05.DriverCertificate020E
open WordRAM020 FT1536.Relation

theorem all_h_ac (h : Rq) (dirty : State) :
    Divergence.AC (PublicDriver020E.law h dirty) (MachineCertificate020D.reference h) := by
  rw [PublicDriver020E.law_eq]
  exact MachineCertificate020D.all_h_ac h initial

theorem certificate (h : Rq) (mass : SamplerMassCondition014.MassCondition h) (dirty : State) :
    Divergence.AC (PublicDriver020E.law h dirty) (MachineCertificate020D.reference h) ∧
      Divergence.second (PublicDriver020E.law h dirty) (MachineCertificate020D.reference h)≤1+1/2^47 := by
  rw [PublicDriver020E.law_eq]
  exact MachineCertificate020D.public_initial h mass

theorem same_key_law (domain : Rq → Prop) (mu : Law Rq)
    (cover : KeySupport011.Covered mu domain)
    (mass : ∀ h,domain h → SamplerMassCondition014.MassCondition h) (dirty : Rq → State) :
    Divergence.AC (Divergence.joint mu (fun h => PublicDriver020E.law h (dirty h)))
      (Divergence.joint mu MachineCertificate020D.reference) ∧
    Divergence.second (Divergence.joint mu (fun h => PublicDriver020E.law h (dirty h)))
      (Divergence.joint mu MachineCertificate020D.reference)≤1+1/2^47 := by
  simp only [PublicDriver020E.law_eq]
  exact MachineCertificate020D.same_key_law domain mu cover mass (fun _ => initial)

end FT1536.S05.DriverCertificate020E
