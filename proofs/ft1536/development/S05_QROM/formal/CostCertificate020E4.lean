import CostDriver020E4
import MachineCertificate020D

namespace FT1536.S05.CostCertificate020E4
open WordRAM020 FT1536.Relation CostRun020E4

theorem all_key_ac (k : CostInput020E4.Key) :
    Divergence.AC (CostDriver020E4.law k) (MachineCertificate020D.reference (CostInput020E4.key k)) := by
  rw [CostDriver020E4.law_eq]
  exact MachineCertificate020D.all_h_ac _ initial

/-- Executable instance with all phases charged; the same exact moment
    premise is still explicit. This is not a native-memory or QROM theorem. -/
theorem certificate (k : CostInput020E4.Key)
    (mass : SamplerMassCondition014.MassCondition (CostInput020E4.key k)) :
    (∀ coins,Bounded (CostDriver020E4.run k coins) CostDriver020E4.price CostDriver020E4.price) ∧
    Divergence.AC (CostDriver020E4.law k) (MachineCertificate020D.reference (CostInput020E4.key k)) ∧
    Divergence.second (CostDriver020E4.law k) (MachineCertificate020D.reference (CostInput020E4.key k))≤1+1/2^47 := by
  refine ⟨CostDriver020E4.bound k,?_⟩
  rw [CostDriver020E4.law_eq]
  exact MachineCertificate020D.public_initial _ mass

/-- Reification only identifies the canonical public-array representation
    of the same mathematical key. It is not an unpriced runtime KeyGen. -/
noncomputable def publicLaw (h : Rq) := CostDriver020E4.law (ArrayBank020E4.load h)

theorem public_law_eq (h : Rq) : publicLaw h=MachineLaw020D.law h initial := by
  rw [publicLaw,CostDriver020E4.law_eq,CostInput020E4.same_key]

theorem same_key_law (domain : Rq → Prop) (mu : Law Rq) (cover : KeySupport011.Covered mu domain)
    (mass : ∀ h,domain h → SamplerMassCondition014.MassCondition h) :
    Divergence.AC (Divergence.joint mu publicLaw) (Divergence.joint mu MachineCertificate020D.reference) ∧
    Divergence.second (Divergence.joint mu publicLaw) (Divergence.joint mu MachineCertificate020D.reference)≤1+1/2^47 := by
  have he : publicLaw=fun h => MachineLaw020D.law h initial := funext public_law_eq
  rw [he]
  exact MachineCertificate020D.same_key_law domain mu cover mass (fun _ => initial)

end FT1536.S05.CostCertificate020E4
