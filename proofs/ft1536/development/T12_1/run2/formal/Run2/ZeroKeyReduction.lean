import Run2.PublicErrorIdentity

namespace FT1536.Run2.ZeroKeyReduction
open Geometry PublicSimulation CorrectnessProbability
open FT1536.Relation

theorem mul_zero_left (s : Rq) : mulRq 0 s=0 := by
  funext i
  simp [mulRq,UniformErrorBound.poly_zero]

theorem extraction_zero_key (c : Rq) (s : Vec) : extract 0 c s=(centerRq c,s) := by
  simp [extract,mul_zero_left]

theorem zero_key_verify (c : Rq) (s : Vec) :
    Verify 0 c s ↔ FT1536.Relation.signed16 s ∧ Q0 (centerRq c)+Q0 s<B := by
  simp only [Verify,extraction_zero_key,Q]

theorem every_positive_rejected (c : Rq) (hc : B≤Q0 (centerRq c)) (s : Vec) :
    ¬ Verify 0 c s := by
  rw [zero_key_verify]
  intro hv
  have hn := Q0_nonneg s
  linarith [hv.2]

theorem zero_target_safe (z : BoxPair) (hz : SigmaMath.syndrome 0 z=0)
    (hn : Q (decode z)<B) : ¬ BadVerify.Bad 0 (0,emit z) := by
  classical
  have hred : reduceVec (decode z).1=0 := by
    simpa [SigmaMath.syndrome,A,mul_zero_left] using hz
  have hcen : centerVec (decode z).1=0 := by
    rw [← PublicErrorIdentity.center_reduce,hred,UniformErrorBound.center_zero]
  have hnorm : Q (centerVec (decode z).1,(decode z).2)<B := by
    rw [hcen]
    have hp := Q0_nonneg (decode z).1
    have hzero : Q0 0=0 := by simp [Q0,block]
    simp only [Q,hzero,zero_add] at hn ⊢
    linarith
  have he := PublicErrorIdentity.public_bad_iff (0 : Rq) z
  rw [hz] at he
  exact fun hb => (he.mp hb).2 hnorm

theorem F_zero_zero : ExactCounting.F 0 0=0 := by
  classical
  unfold ExactCounting.F ExactCounting.countPolynomial
  apply Finset.sum_eq_zero
  intro z _
  have hp : ¬ (SigmaMath.syndrome 0 z=0 ∧ Q (decode z)<B ∧ badReply 0 0 (emit z)) := by
    rintro ⟨hc,hn,hb⟩
    have he : BadVerify.Bad 0 (0,emit z) := by
      cases ho : emit z with
      | none => simp [ho,badReply] at hb
      | some s => exact ⟨s,rfl,by simpa [ho,badReply] using hb⟩
    exact zero_target_safe z hc hn he
  simp [hp]

theorem zero_target_bad_probability : tBad 0 0=0 := by
  rw [ExactCounting.one_try_bad_exact,F_zero_zero]
  simp [ExactCounting.evalCount]

theorem zero_target_full_bad_probability :
    (signBody (SigmaMath.syndrome 0) 0).event (badReply 0 0)=0 := by
  rw [body_bad_exact,zero_target_bad_probability,mul_zero]

end FT1536.Run2.ZeroKeyReduction
