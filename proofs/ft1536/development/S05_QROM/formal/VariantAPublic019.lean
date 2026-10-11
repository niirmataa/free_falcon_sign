import StandaloneRuntime019
import VariantABridge019
import ReferencePaid019

/- Actual executable public pair code is available in the repaired world.
   A BASE certificate is still an explicit input here: this module does not
   load the legacy proof environment or claim a combined game proof. -/
namespace FT1536.S05.VariantAPublic019
open FT1536.Relation FT1536.Run2 JointInterface019 ReferenceJoint019 ReferenceLower019

theorem actual_not_reply_sampler (h : Rq) (s : Sampler) (st : State) (m : Bytes) (r : Nonce) :
    pairLaw (StandaloneRuntime019.publicCode h)≠samplerLaw s h st m r :=
  VariantABridge019.no_exact_sampler_adapter _ _ _ _ _ _

theorem paid_reply_comparison (h : Rq) (s : Sampler) (st : State) (m : Bytes) (r : Nonce)
    (e k : ℝ) (hk : 0<k)
    (base : Certificate (StandaloneRuntime019.publicCode h) (reference h) e)
    (lower : OnSupportLower (pairLaw (StandaloneRuntime019.publicCode h)) (reference h)
      (samplerLaw s h st m r) k) :
    Divergence.AC (pairLaw (StandaloneRuntime019.publicCode h)) (samplerLaw s h st m r) ∧
    Divergence.second (pairLaw (StandaloneRuntime019.publicCode h)) (samplerLaw s h st m r)≤1+paidError e k :=
  paid_budget _ _ _ _ _ hk base lower

theorem paid_reply_observation {O : Type} [Fintype O] [DecidableEq O]
    (h : Rq) (s : Sampler) (st : State) (m : Bytes) (r : Nonce)
    (e k : ℝ) (hk : 0<k)
    (base : Certificate (StandaloneRuntime019.publicCode h) (reference h) e)
    (lower : OnSupportLower (pairLaw (StandaloneRuntime019.publicCode h)) (reference h)
      (samplerLaw s h st m r) k) (f : Rq×ReferenceJoint019.Reply → O) :
    Divergence.AC ((pairLaw (StandaloneRuntime019.publicCode h)).map f) ((samplerLaw s h st m r).map f) ∧
    Divergence.second ((pairLaw (StandaloneRuntime019.publicCode h)).map f)
      ((samplerLaw s h st m r).map f)≤1+paidError e k :=
  ReferencePaid019.observed_paid_budget _ _ _ _ _ hk base lower f

#print axioms actual_not_reply_sampler
#print axioms paid_reply_comparison
#print axioms paid_reply_observation
end FT1536.S05.VariantAPublic019
