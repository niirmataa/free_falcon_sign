import Run2.ExactCounting

namespace FT1536.Run2.PublicErrorIdentity
open Finset PublicSimulation Geometry CorrectnessProbability
open FT1536.Relation

theorem center_reduce (v : Vec) : centerRq (reduceVec v)=centerVec v := by
  have hc (x : ℤ) : center (x : ZMod 18433).val = center x := by
    unfold center
    rw [ZMod.val_intCast]
    omega
  funext i
  exact Prod.ext (hc (v i).1) (hc (v i).2)

theorem extraction_of_sample (h : Rq) (z : Vec × Vec) :
    extract h (A h z) z.2 = (centerVec z.1,z.2) := by
  simp [extract,A,center_reduce]

noncomputable def publicBadSample (z : BoxPair) : Prop :=
  PublicSimulation.signed16 z.2 ∧ ¬ Q (centerVec (decode z).1,(decode z).2)<B
noncomputable instance : DecidablePred publicBadSample := Classical.decPred _

theorem public_bad_iff (h : Rq) (z : BoxPair) :
    BadVerify.Bad h (SigmaMath.syndrome h z,emit z) ↔ publicBadSample z := by
  classical
  unfold emit
  split
  next hs =>
    change (∃ s, some z.2=some s ∧ ¬Verify h (SigmaMath.syndrome h z) (decodeVec s)) ↔ _
    have hv : FT1536.Relation.signed16 (decodeVec z.2) := hs
    have hi : Verify h (SigmaMath.syndrome h z) (decodeVec z.2) ↔
        Q (centerVec (decode z).1,(decode z).2)<B := by
      change (FT1536.Relation.signed16 (decodeVec z.2) ∧
        Q (extract h (A h (decode z)) (decode z).2)<B) ↔ _
      rw [extraction_of_sample]
      exact and_iff_right hv
    constructor
    · rintro ⟨s,he,hn⟩
      have he' := Option.some.inj he
      subst s
      exact ⟨hs,fun hq => hn (hi.mpr hq)⟩
    · intro hp
      exact ⟨z.2,rfl,fun hv' => hp.2 (hi.mp hv')⟩
  next hs => simp [BadVerify.Bad,publicBadSample,hs]

noncomputable def publicError : ℝ := boundedGaussian.event publicBadSample

theorem public_error_independent_of_h (h : Rq) :
    (SigmaMath.freshPublic h).event (BadVerify.Bad h) = publicError := by
  classical
  rw [SigmaMath.freshPublic,publicJoint,CorrectnessProbability.map_event]
  unfold publicError Law.event
  apply sum_congr rfl
  intro z _
  change (if BadVerify.Bad h (SigmaMath.syndrome h z,emit z) then boundedGaussian.mass z else 0) = _
  simp only [public_bad_iff]

set_option maxRecDepth 8192 in
theorem numerator_partition (h : Rq) :
    (∑ c, ExactCounting.F h c) = ExactCounting.countPolynomial
      (fun z => Q (decode z)<B ∧ publicBadSample z) := by
  classical
  unfold ExactCounting.F ExactCounting.countPolynomial
  rw [sum_comm]
  apply sum_congr rfl
  intro z _
  have he (c : Rq) :
      (@ite (Polynomial ℤ) (SigmaMath.syndrome h z=c ∧ Q (decode z)<B ∧ badReply h c (emit z))
        (Classical.propDecidable _) (Polynomial.monomial (ExactCounting.degree z) 1) 0) =
      if SigmaMath.syndrome h z=c then
        (@ite (Polynomial ℤ) (Q (decode z)<B ∧ publicBadSample z) (Classical.propDecidable _)
          (Polynomial.monomial (ExactCounting.degree z) 1) 0)
      else 0 := by
    by_cases hc : SigmaMath.syndrome h z=c
    · subst c
      have hb : badReply h (SigmaMath.syndrome h z) (emit z) ↔ publicBadSample z := by
        have hh := public_bad_iff h z
        have heq : BadVerify.Bad h (SigmaMath.syndrome h z,emit z) ↔ badReply h (SigmaMath.syndrome h z) (emit z) := by
          cases emit z <;> simp [BadVerify.Bad,badReply]
        exact heq.symm.trans hh
      by_cases hn : Q (decode z)<B <;> by_cases hbad : publicBadSample z <;> simp [hb,hn,hbad]
    · simp [hc]
  simp_rw [he]
  simp

end FT1536.Run2.PublicErrorIdentity
