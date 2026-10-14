import T5Pointwise
import HacGlue
import Run2.ConcreteReduction

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Preparation only: the weight functions below must later be DEFINED from
   the same pinned do_sign execution. This module does not supply them or
   assert that the concrete implementation satisfies the open goal.
   Its model theorem is deliberately not named the implementation's final
   end_to_end_assembled_theorem_statement: key-law and byte-game transport
   are not consequences of this analytic interface. -/
namespace FT1536.Source3.SignRealizationObligations086
open FT1536 FT1536.Run2 FT1536.Relation FT1536.Geometry FT1536.PublicSimulation

abbrev WeightFamily := Rq → Run2.State → Run2.Bytes → Run2.Nonce → Rq → BoxPair → ℝ

/-- Objects only. Arbitrary inhabitants do not assert source realization. -/
structure WeightData where
  target : WeightFamily
  mach : WeightFamily
  wrapS : WeightFamily
  w : WeightFamily

/-- The exact open, unconditioned analytic goal, with no global positive
    mass floor and no generic keyIdent proposition. All four roads are
    pointwise, including tail and off-fiber support. -/
structure PointwiseStageGoal (S : Sampler) (jatt : HacGlue.AttemptFamily)
    (weights : WeightData) : Prop where
  replyShape : HacGlue.ReplyShapeAt S jatt
  road : ∀ h st m r c, T5Pointwise.PointwiseStageRoad (SigmaMath.syndrome h) c
    (weights.target h st m r c) (weights.mach h st m r c)
    (weights.wrapS h st m r c) (weights.w h st m r c)
  attemptShape : ∀ h st m r c, AttemptPointwise.AttemptShape (jatt h st m r c)
    (weights.w h st m r c) (T5Pointwise.stageRoad_nonneg (road h st m r c))

theorem attempt_bound (goal : PointwiseStageGoal S jatt weights) :
    HacGlue.AttemptPointwiseAt jatt SignLayerSupport.attemptFactor := by
  intro h st m r c
  exact AttemptPointwise.attemptPointwise_of_attemptWeights
    (goal.attemptShape h st m r c)
    (T5Pointwise.attemptWeights_of_stageRoad (goal.road h st m r c))

theorem local_certificate (goal : PointwiseStageGoal S jatt weights) :
    LocalJointCertificate S (SignLayerSupport.e2 SignLayerSupport.attemptFactor) :=
  HacGlue.localJointCertificate_of_pointwise_premises S SignLayerSupport.attemptFactor
    SignLayerSupport.attemptFactor_one_le jatt goal.replyShape (attempt_bound goal)

/-- F04 variant A is supplied by the pinned construction, not an input. -/
theorem rom_from_construction (S : Sampler) : HacGlue.RomChallengeAt S :=
  HacGlue.romChallengeAt S

theorem unconditioned_error :
    SignLayerSupport.e2 SignLayerSupport.attemptFactor = SignLayerSupport.attemptFactor^32-1 ∧
    SignLayerSupport.e2 SignLayerSupport.attemptFactor < 1/4294967296 := by
  refine ⟨?_,SignLayerSupport.e2_attemptFactor_lt⟩
  change (SignLayerSupport.attemptFactor^16)^2-1=SignLayerSupport.attemptFactor^32-1
  rw [← pow_mul]

/-- A checked consumer of the SINGLE named analytic goal. This is the
    abstract fair-randomness ROM game, for an arbitrary supplied key law.
    There is no computational PRG hop or implementation-law claim here. -/
theorem model_bound_of_pointwise_goal {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK × Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (jatt : HacGlue.AttemptFamily) (weights : WeightData)
    (goal : PointwiseStageGoal S jatt weights) :
    Games.AdvEUF beta muKey A ≤
      min 1 (StoppingLoss.epsColl beta +
        EventTransfer.phi ((1+SignLayerSupport.e2 SignLayerSupport.attemptFactor)^beta.qs-1)
          (Games.AdvMT (beta.qh+1) (SigmaMath.muH muKey) (Reduction.build beta A S))) :=
  concrete_euf_cma_to_mt_isis beta muKey A S
    (SignLayerSupport.e2 SignLayerSupport.attemptFactor) (local_certificate goal)

end FT1536.Source3.SignRealizationObligations086
