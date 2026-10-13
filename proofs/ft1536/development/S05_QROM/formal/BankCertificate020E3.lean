import BankDriver020E3
import MachineCertificate020D

namespace FT1536.S05.BankCertificate020E3
open WordRAM020 FT1536.Relation

/-- All h: the same full reference, including modeled failures. -/
theorem all_h_ac (h : Rq) (dirty : State) :
    Divergence.AC (BankDriver020E3.law h dirty) (MachineCertificate020D.reference h) := by
  rw [BankDriver020E3.law_eq]
  exact MachineCertificate020D.all_h_ac h initial

/-- The exact existing M is required only for this unchanged moment bound. -/
theorem certificate (h : Rq) (mass : SamplerMassCondition014.MassCondition h) (dirty : State) :
    Divergence.AC (BankDriver020E3.law h dirty) (MachineCertificate020D.reference h) ∧
      Divergence.second (BankDriver020E3.law h dirty) (MachineCertificate020D.reference h)≤1+1/2^47 := by
  rw [BankDriver020E3.law_eq]
  exact MachineCertificate020D.public_initial h mass

theorem same_key_law (domain : Rq → Prop) (mu : Law Rq)
    (cover : KeySupport011.Covered mu domain)
    (mass : ∀ h,domain h → SamplerMassCondition014.MassCondition h) (dirty : Rq → State) :
    Divergence.AC (Divergence.joint mu (fun h => BankDriver020E3.law h (dirty h)))
      (Divergence.joint mu MachineCertificate020D.reference) ∧
    Divergence.second (Divergence.joint mu (fun h => BankDriver020E3.law h (dirty h)))
      (Divergence.joint mu MachineCertificate020D.reference)≤1+1/2^47 := by
  simp only [BankDriver020E3.law_eq]
  exact MachineCertificate020D.same_key_law domain mu cover mass (fun _ => initial)

end FT1536.S05.BankCertificate020E3
