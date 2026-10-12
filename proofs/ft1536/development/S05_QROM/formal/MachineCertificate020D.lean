import MachineLaw020D
import StandaloneCertificate019

namespace FT1536.S05.MachineCertificate020D
open WordRAM020 JointInterface019 FT1536.Relation

/-- Same pinned legacy reference, encoded losslessly, including failures. -/
noncomputable def reference (h : Rq) : Law (Bits outputSize) :=
  (ReferenceJoint019.reference h).map WireFormat020D.wire

/-- Absolute continuity needs no M; all h and all machine states. -/
theorem all_h_ac (h : Rq) (s : State) : Divergence.AC (MachineLaw020D.law h s) (reference h) := by
  rw [MachineLaw020D.law_eq]
  exact ObservationMoment019.map_ac _ _ (StandaloneCertificate019.actual_all_h_ac h) WireFormat020D.wire

/-- Concrete inherited certificate, not a constructor with a free local
    step or sampler premise. The original mathematical M remains explicit. -/
theorem actual_certificate (h : Rq) (mass : SamplerMassCondition014.MassCondition h) (s : State) :
    Divergence.AC (MachineLaw020D.law h s) (reference h) ∧
      Divergence.second (MachineLaw020D.law h s) (reference h)≤1+1/2^47 :=
  MachineLaw020D.certificate_transport h s _ _ (StandaloneCertificate019.actual_certificate h mass)

theorem public_initial (h : Rq) (mass : SamplerMassCondition014.MassCondition h) :
    Divergence.AC (MachineLaw020D.law h initial) (reference h) ∧
      Divergence.second (MachineLaw020D.law h initial) (reference h)≤1+1/2^47 :=
  actual_certificate h mass initial

/-- One identical covered public-key law on both sides; h is retained.
    No reconditioning, resampling, or source emission witness is invented. -/
theorem same_key_law (domain : Rq → Prop) (mu : Law Rq)
    (cover : KeySupport011.Covered mu domain)
    (mass : ∀ h,domain h → SamplerMassCondition014.MassCondition h) (st : Rq → State) :
    Divergence.AC (Divergence.joint mu (fun h => MachineLaw020D.law h (st h)))
      (Divergence.joint mu reference) ∧
    Divergence.second (Divergence.joint mu (fun h => MachineLaw020D.law h (st h)))
      (Divergence.joint mu reference)≤1+1/2^47 := by
  constructor
  · exact Divergence.joint_ac mu mu _ _ (fun _ hx => hx)
      (fun h _ => all_h_ac h (st h))
  · have hb := Divergence.joint_bound mu mu (fun h => MachineLaw020D.law h (st h)) reference (1+1/2^47)
      (fun h hp => (actual_certificate h (mass h (cover h hp)) (st h)).2)
    rw [KeySupport011.second_self,one_mul] at hb
    exact hb

end FT1536.S05.MachineCertificate020D
