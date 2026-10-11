import RuntimeAgreement019
import DyadicBridge019
import KeyReferenceLower019

/- Actual code instance, proved in the legacy certificate environment;
   its conclusion uses the game-independent PairCode and full reference.
   The same runtime/common source closure is separately built in variant A.
   No whole-game link or real Sign lower bound is manufactured here. -/
namespace FT1536.S05.StandaloneCertificate019
open FT1536.Relation JointInterface019 ReferenceJoint019 ReferenceLower019

theorem actual_certificate (h : Rq) (mass : SamplerMassCondition014.MassCondition h) :
    Certificate (StandaloneRuntime019.publicCode h) (reference h) (1/2^47) := by
  rw [RuntimeAgreement019.publicCode_eq]
  exact LegacyPairWitness019.certificate h mass

theorem actual_all_h_ac (h : Rq) :
    Divergence.AC (pairLaw (StandaloneRuntime019.publicCode h)) (reference h) := by
  rw [RuntimeAgreement019.publicCode_eq]
  exact LegacyPairWitness019.all_h_ac h

theorem actual_full_observation {O : Type} [Fintype O] [DecidableEq O]
    (h : Rq) (mass : SamplerMassCondition014.MassCondition h)
    (f : Rq×ReferenceJoint019.Reply → O) :
    Divergence.AC ((pairLaw (StandaloneRuntime019.publicCode h)).map f) ((reference h).map f) ∧
    Divergence.second ((pairLaw (StandaloneRuntime019.publicCode h)).map f) ((reference h).map f)≤1+1/2^47 :=
  ObservationMoment019.full_observation _ _ _ (actual_certificate h mass).1 (actual_certificate h mass).2 f

theorem actual_no_exact_noise (h : Rq) (noise : ReplyCode Rq ReferenceJoint019.Reply) :
    pairLaw (StandaloneRuntime019.publicCode h)≠freshLaw noise := DyadicBridge019.no_exact_adapter _ _

theorem actual_paid_noise (h : Rq) (mass : SamplerMassCondition014.MassCondition h)
    (noise : ReplyCode Rq ReferenceJoint019.Reply) (k : ℝ) (hk : 0<k)
    (lower : OnSupportLower (pairLaw (StandaloneRuntime019.publicCode h)) (reference h) (freshLaw noise) k) :
    Divergence.AC (pairLaw (StandaloneRuntime019.publicCode h)) (freshLaw noise) ∧
    Divergence.second (pairLaw (StandaloneRuntime019.publicCode h)) (freshLaw noise)≤1+paidError (1/2^47) k :=
  paid_budget _ _ _ _ k hk (actual_certificate h mass) lower

theorem actual_same_key_law (domain : Rq → Prop) (mu : Law Rq)
    (cover : KeySupport011.Covered mu domain)
    (mass : ∀ h,domain h → SamplerMassCondition014.MassCondition h) :
    Divergence.AC (Divergence.joint mu (fun h => pairLaw (StandaloneRuntime019.publicCode h)))
      (Divergence.joint mu reference) ∧
    Divergence.second (Divergence.joint mu (fun h => pairLaw (StandaloneRuntime019.publicCode h)))
      (Divergence.joint mu reference)≤1+1/2^47 := by
  simp_rw [RuntimeAgreement019.publicCode_eq]
  exact LegacyPairWitness019.same_key_law domain mu cover mass

theorem actual_same_key_paid (domain : Rq → Prop) (mu : Law Rq)
    (cover : KeySupport011.Covered mu domain)
    (mass : ∀ h,domain h → SamplerMassCondition014.MassCondition h)
    (realLaw : Rq → Law (Rq×ReferenceJoint019.Reply)) (k : ℝ) (hk : 0<k)
    (lower : ∀ h,mu.mass h≠0 →
      OnSupportLower (pairLaw (StandaloneRuntime019.publicCode h)) (reference h) (realLaw h) k) :
    Divergence.AC (Divergence.joint mu (fun h => pairLaw (StandaloneRuntime019.publicCode h)))
      (Divergence.joint mu realLaw) ∧
    Divergence.second (Divergence.joint mu (fun h => pairLaw (StandaloneRuntime019.publicCode h)))
      (Divergence.joint mu realLaw)≤1+paidError (1/2^47) k :=
  KeyReferenceLower019.joint_paid _ _ _ _ _ _ hk (actual_same_key_law domain mu cover mass) lower

#print axioms actual_certificate
#print axioms actual_all_h_ac
#print axioms actual_full_observation
#print axioms actual_no_exact_noise
#print axioms actual_paid_noise
#print axioms actual_same_key_law
#print axioms actual_same_key_paid
end FT1536.S05.StandaloneCertificate019
