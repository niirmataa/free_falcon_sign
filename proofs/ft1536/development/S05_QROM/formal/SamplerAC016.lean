import SamplerSupport016
import Run2.LawBinding
import Run2.ExactCounting

/- Unconditional support theorem for every public h. This does not assert
   an all-h small moment, nor source/API equivalence. -/
namespace FT1536.S05.SamplerAC016
open Finset FT1536.Geometry FT1536.Relation FT1536.PublicSimulation
open FT1536.Run2 FT1536.Run2.FiberBinding FT1536.Run2.ExactCounting
open SamplerCode016 SamplerSupport016

theorem honest_positive_at_accepted (h : Rq) (z : BoxPair) (hz : Q (decode z)<B) :
    0<(SigmaMath.freshHonest h).mass (SigmaMath.syndrome h z,emit z) := by
  classical
  have hp := BadVerify.trial_positive (SigmaMath.syndrome h) z hz
  have hc := BadVerify.cap_first_positive _ z hp 15
  have hm := BadVerify.map_mass_ge (MathSign.cap (trial (SigmaMath.syndrome h)
    (SigmaMath.syndrome h z)) 16) (MathSign.emit emit) (some z)
  have hbody : 0<(signBody (SigmaMath.syndrome h) (SigmaMath.syndrome h z)).mass (emit z) :=
    hc.trans_le hm
  rw [honest_joint_body]
  exact mul_pos (by positivity) hbody

theorem all_h_ac (t : Tables) (h : Rq) (st : State) (m : Bytes) (r : Nonce) :
    Divergence.AC (samplerLaw (sampler t) h st m r) (SigmaMath.freshHonest h) := by
  classical
  intro output hz
  unfold FT1536.Run2.samplerLaw
  rw [map_mass]
  apply sum_eq_zero
  intro tape _
  by_cases he : (sampler t).code h st m r tape=output
  · have hp := honest_positive_at_accepted h (selected t (seedEquiv tape)) (selected_norm t _)
    rw [←code_as_emission t h st m r tape,he,hz] at hp
    exact False.elim (lt_irrefl 0 hp)
  · simp [he]

theorem no_none (t : Tables) (h c : Rq) (st : State) (m : Bytes) (r : Nonce) :
    (samplerLaw (sampler t) h st m r).mass (c,none)=0 := by
  classical
  unfold FT1536.Run2.samplerLaw
  rw [map_mass]
  apply sum_eq_zero
  intro tape _
  simp [sampler]

#print axioms honest_positive_at_accepted
#print axioms all_h_ac
#print axioms no_none
end FT1536.S05.SamplerAC016
