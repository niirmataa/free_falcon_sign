import JointDecomp
import ReferenceJoint019
import ObservationMoment019
import DyadicBridge019

/- Compiled ONLY against the pinned repaired variant-A closure. This adapter
   witnesses the actual new API, not an instance of a source signing sampler.
   The public pair generator remains a different object. -/
namespace FT1536.S05.VariantABridge019
open FT1536.Relation FT1536.Run2 JointInterface019 ReferenceJoint019

def noiseCode (s : Sampler) (h : Rq) (st : State) (m : Bytes) (r : Nonce) :
    ReplyCode Rq ReferenceJoint019.Reply where
  bits := s.bits
  code := s.code h st m r

theorem reply_law_eq (s : Sampler) (h : Rq) (st : State) (m : Bytes) (r : Nonce) (c : Rq) :
    JointInterface019.replyLaw (noiseCode s h st m r) c=Run2.replyLaw s h st m r c := rfl

theorem fresh_law_eq (s : Sampler) (h : Rq) (st : State) (m : Bytes) (r : Nonce) :
    freshLaw (noiseCode s h st m r)=samplerLaw s h st m r := rfl

theorem honest_reply_eq (h c : Rq) :
    ReferenceJoint019.honestReply h c=JointDecomp.honestReply h c := rfl

theorem honest_target_eq (h : Rq) :
    reference h=Divergence.joint (Law.uniform : Law Rq) (JointDecomp.honestReply h) := rfl

theorem challenge_from_ROM (s : Sampler) (h : Rq) (st : State) (m : Bytes) (r : Nonce) :
    JointInterface019.marginal (freshLaw (noiseCode s h st m r))=(Law.uniform : Law Rq) :=
  fresh_marginal _

/-- A law certificate of the public PAIR code is sufficient against the
    common ideal reference. No uniform marginal of that pair code is assumed. -/
theorem public_pair_reference (j : PairCode Rq ReferenceJoint019.Reply) (h : Rq) (e : ℝ)
    (cert : Certificate j (reference h) e) :
    Divergence.AC (pairLaw j) (Divergence.joint (Law.uniform : Law Rq) (JointDecomp.honestReply h)) ∧
    Divergence.second (pairLaw j) (Divergence.joint (Law.uniform : Law Rq) (JointDecomp.honestReply h))≤1+e := cert

theorem no_exact_sampler_adapter (j : PairCode Rq ReferenceJoint019.Reply)
    (s : Sampler) (h : Rq) (st : State) (m : Bytes) (r : Nonce) :
    pairLaw j≠samplerLaw s h st m r := by
  rw [←fresh_law_eq]
  exact DyadicBridge019.no_exact_adapter _ _

#print axioms reply_law_eq
#print axioms fresh_law_eq
#print axioms honest_reply_eq
#print axioms honest_target_eq
#print axioms challenge_from_ROM
#print axioms public_pair_reference
#print axioms no_exact_sampler_adapter
end FT1536.S05.VariantABridge019
