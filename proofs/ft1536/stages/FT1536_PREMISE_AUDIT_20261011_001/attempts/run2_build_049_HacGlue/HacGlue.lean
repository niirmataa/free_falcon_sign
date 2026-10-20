import JointDecomp
import SignLayerSupport
import VerifyBind.HashTo

/-! # HacGlue — the `hac` discharge, O-NONE, and the assembled B4 certificate

Window B4/3b of the B4 composition plan (`notes/B4_SYNTHESIS.md`): the glue of
the three B4 deliveries. Deliverables of THIS module (all kernel-checked, no
new model, no unfinished-proof markers):

1. **Discharge of `hac`** — the support/AC premise of
   `JointDecomp.localJointCertificate_of_joint_bounds`. The premise is stated
   about the sampler's per-challenge reply law (the conditional of
   `FT1536.Run2.samplerLaw` at `c`) against the honest body
   `JointDecomp.honestReply h c = signBody (syndrome h) c`, while B4/2's
   content (`SignLayerSupport`) lives over `signBodyOf`/`cap`/`emit`. The
   SHAPE bridge is `honestReply_eq_signBodyOf` (via
   `SignLayerSupport.signBody_eq_signBodyOf`); the discharge itself is proved
   in the two recorded routes: the pointwise route (`hac_of_layer2`, straight
   from `SignLayerSupport.layer2_of_obligations`) and the support route
   (`hac_of_support`, through `SignLayerSupport.ac_of_reply_support`, where
   the wrap/centering `delta` channel of B4/2 rides INSIDE the `emit` image —
   `SignLayerSupport.emitted_reply_supported`,
   `SignLayerSupport.wrap_channel_in_support` — and the honest flip side is
   the recorded converse `SignLayerSupport.chi2_top_of_out_of_support`). The
   constructor `localJointCertificate_of_joint_bounds_no_hac` is
   `JointDecomp.localJointCertificate_of_joint_bounds` WITHOUT the `hac`
   premise (its `hcond` is discharged by the same obligations).
2. **O-NONE** — positive `none` mass of `signBody (syndrome h) c`. The exact
   condition at an achievable challenge is
   `signBody_none_pos_iff_achievable` (the achievable-case refinement of
   `SignLayerSupport.signBody_none_pos_iff`, where the empty-fiber branch
   dies); non-achievable challenges are settled outright
   (`signBody_none_pos_of_fiberless`). The natural achievability hypothesis is
   the out-of-box fiber point `ONone`; it needs source/key-side facts about
   the fiber geometry of `FT1536.SigmaMath.syndrome` (the lattice coset of
   `FT1536.Relation.A h` spreading beyond the `Q < B` region inside the finite
   box), so it is RECORDED as a named premise and never assumed. Its exact
   role is pinned by `attempt_miss_satisfiable_iff_onone`: at an achievable
   challenge the `none`-side of `SignLayerSupport.AttemptPointwise` admits a
   MISS-CAPABLE attempt law if and only if the O-NONE out-of-box conclusion
   holds there (the weaker `signBody`-level consequence is
   `signBody_none_pos_of_attempt_miss`).
3. **The assembled certificate** `localJointCertificate_of_named_premises` —
   `FT1536.Run2.LocalJointCertificate S ((1 + d1) * (1 + d2) - 1)` with the
   exact challenge layer `d1 = 0` (the ROM identification
   `FT1536.VerifyBind.UniformChallenge`) and `d2 = SignLayerSupport.e2 k =
   k^32 - 1`, where the ONLY remaining arguments are the named premises
   `AttemptPointwise` (at its exact `SignLayerSupport` interface, via the
   family parameter `jatt`), `ReplyShape`, O-NONE (the Lean-premise part of
   `notes/B4_SYNTHESIS.md` §obligations) plus Layer 1 `UniformChallenge` and
   the arithmetic side condition `1 ≤ k` (proved at the candidate factor).
   The exact argument list of this theorem
   IS the remaining project scope of B4; see `notes/B4_GLUE_WORK_STATE.md`.
   The leaner pointwise route (O-NONE avoidable) is recorded as
   `localJointCertificate_of_pointwise_premises`. At the candidate factor
   `SignLayerSupport.attemptFactor` the error is `e < 2^-32`
   (`SignLayerSupport.e2_attemptFactor_lt`).

Scope boundaries (recorded, NOT claimed): the real `S.code`/`ReplyShape`
source binding and the byte-bridge swallow stay open (B1/source3 lanes per
the B4/2 boundary); the additive-error caveat (`Adv_PRG`-shaped terms) stays
outside the multiplicative `AttemptPointwise` shape (outer bound; see the
`Honest boundary of the multiplicative shape` paragraph of Part 3 in
`notes/B4_LAYER2_WORK_STATE.md`). All statements are on the
pinned types `FT1536.Law`, `FT1536.Divergence`,
`FT1536.PublicSimulation.signBody/trial/emit`, `FT1536.MathSign.cap/emit`,
`FT1536.Run2.samplerLaw/LocalJointCertificate`; nothing is assumed beyond the
named premises above. Standard axioms only.
-/

namespace FT1536.HacGlue
open Finset FT1536 FT1536.PublicSimulation FT1536.Geometry

/-! ## 0. Named interfaces (defs first) -/

/-- The sampler's per-challenge reply law: the conditional of
`FT1536.Run2.samplerLaw S h st m r` at the challenge `c` (the B4/1
`JointDecomp.condOf`). Both the `hac` premise of
`JointDecomp.localJointCertificate_of_joint_bounds` and the Layer-2
comparison of `SignLayerSupport.layer2_of_obligations` are about THIS law
against the honest body `JointDecomp.honestReply h c`. -/
noncomputable def replyAt (S : FT1536.Run2.Sampler) (h : FT1536.Relation.Rq)
    (st : FT1536.Run2.State) (m : FT1536.Run2.Bytes) (r : FT1536.Run2.Nonce)
    (c : FT1536.Relation.Rq) : Law (Option BoxVec) :=
  JointDecomp.condOf (FT1536.Run2.samplerLaw S h st m r) c

theorem replyAt_eq (S : FT1536.Run2.Sampler) (h : FT1536.Relation.Rq)
    (st : FT1536.Run2.State) (m : FT1536.Run2.Bytes) (r : FT1536.Run2.Nonce)
    (c : FT1536.Relation.Rq) :
    replyAt S h st m r c
      = JointDecomp.condOf (FT1536.Run2.samplerLaw S h st m r) c := rfl

/-- The per-signing-point family of one-attempt laws of the real `to_sign`
sampler — the WITNESS OBJECT of the two Layer-2 named premises (a law, not an
assumption). Its identification with the sampler's realized attempt law is
part of the `ReplyShape`/`AttemptPointwise` premises and of the open
`S.code` binding (B1/source3). -/
abbrev AttemptFamily : Type :=
  FT1536.Relation.Rq → FT1536.Run2.State → FT1536.Run2.Bytes → FT1536.Run2.Nonce →
    FT1536.Relation.Rq → Law (Option BoxPair)

/-- The `hac` premise shape of
`JointDecomp.localJointCertificate_of_joint_bounds`, named: the sampler's
per-challenge reply law is absolutely continuous w.r.t. the honest body
`JointDecomp.honestReply h c = signBody (syndrome h) c`. -/
def HacShape (S : FT1536.Run2.Sampler) : Prop :=
  ∀ (h : FT1536.Relation.Rq) (st : FT1536.Run2.State) (m : FT1536.Run2.Bytes)
    (r : FT1536.Run2.Nonce) (c : FT1536.Relation.Rq) (z : Option BoxVec),
    (JointDecomp.honestReply h c).mass z = 0 → (replyAt S h st m r c).mass z = 0

/-- NAMED PREMISE `UniformChallenge` (Layer 1) at every signing point: the
single ROM assumption of `FT1536.VerifyBind` — the challenge marginal of the
sampler law is `FT1536.Law.uniform` exactly (`d1 = 0`). ASSUMED at the
hash-to-point boundary; no security property is proved here. -/
def UniformChallengeAt (S : FT1536.Run2.Sampler) : Prop :=
  ∀ (h : FT1536.Relation.Rq) (st : FT1536.Run2.State) (m : FT1536.Run2.Bytes)
    (r : FT1536.Run2.Nonce),
    FT1536.VerifyBind.UniformChallenge
      (JointDecomp.marginal (FT1536.Run2.samplerLaw S h st m r))

/-- NAMED PREMISE `ReplyShape` (Layer 2, source binding) at every signing
point and challenge: the sampler's conditional reply law IS the pinned body
`SignLayerSupport.signBodyOf` over its own attempt law `jatt h st m r c`.
Source-bound content (`SIGN_MAX_ATTEMPTS = 16`, emission
`Extra/c/falcon-sign.c:3412-3418`); the `S.code` binding itself is other
lanes (B1/source3). -/
def ReplyShapeAt (S : FT1536.Run2.Sampler) (jatt : AttemptFamily) : Prop :=
  ∀ (h : FT1536.Relation.Rq) (st : FT1536.Run2.State) (m : FT1536.Run2.Bytes)
    (r : FT1536.Run2.Nonce) (c : FT1536.Relation.Rq),
    SignLayerSupport.ReplyShape (replyAt S h st m r c) (jatt h st m r c)

/-- NAMED PREMISE `AttemptPointwise` (Layer 2, the analytic core) at every
signing point and challenge, at its EXACT `SignLayerSupport` interface: the
one-attempt mass comparison of `jatt h st m r c` against the pinned fiber law
`trial (syndrome h) c`, both on `some z` and on the miss point. Consumed as a
premise; never assumed beyond this interface. -/
def AttemptPointwiseAt (jatt : AttemptFamily) (k : ℝ) : Prop :=
  ∀ (h : FT1536.Relation.Rq) (st : FT1536.Run2.State) (m : FT1536.Run2.Bytes)
    (r : FT1536.Run2.Nonce) (c : FT1536.Relation.Rq),
    SignLayerSupport.AttemptPointwise (jatt h st m r c)
      (FT1536.SigmaMath.syndrome h) c k

/-- NAMED PREMISE `O-NONE` (the box point): every ACHIEVABLE target `c` of
`A` has a fiber point outside the norm box (`¬ Q (decode z) < B`). This is the
natural achievability hypothesis behind positive `none` mass; its proof needs
source/key-side fiber geometry (the lattice coset of `FT1536.Relation.A h`
inside the finite `FT1536.PublicSimulation.BoxPair` spreads beyond the
`Q < B` region), so it is recorded as a named premise and never assumed. The
EXACT condition behind positive `none` mass is
`signBody_none_pos_iff_achievable` (this premise OR an in-box fiber point
with an unencodable tail `¬ signed16 z.2`). -/
def ONone (A : BoxPair → FT1536.Relation.Rq) : Prop :=
  ∀ c : FT1536.Relation.Rq, (∃ z : BoxPair, A z = c) →
    ∃ z : BoxPair, A z = c ∧ ¬ Q (decode z) < B

/-! ## 1. Discharging `hac`: the bridging lemma and the constructor without it -/

/-- THE shape bridge: the honest comparison target of the `hac` premise,
`JointDecomp.honestReply h c`, is exactly the B4/2 body
`SignLayerSupport.signBodyOf (trial (syndrome h) c)` over `signBodyOf`/`cap`/
`emit` — so the `hac` premise (about the sampler reply law vs `signBody
(syndrome h) c`) and the B4/2 support map (about `signBodyOf`/`emit`/`cap`)
talk about ONE law. -/
theorem honestReply_eq_signBodyOf (h c : FT1536.Relation.Rq) :
    JointDecomp.honestReply h c
      = SignLayerSupport.signBodyOf (trial (FT1536.SigmaMath.syndrome h) c) :=
  SignLayerSupport.signBody_eq_signBodyOf (FT1536.SigmaMath.syndrome h) c

/-- Support containment — the `hsome` shape of
`SignLayerSupport.ac_of_reply_support`, matching the `emit`-image content of
`SignLayerSupport.emitted_reply_supported` /
`SignLayerSupport.wrap_channel_in_support`: under `ReplyShape` +
`AttemptPointwise`, every reply `some v` the sampler law can put mass on lies
in the `emit` image of in-box fiber candidates over `c` (the support
characterization `SignLayerSupport.signBody_some_pos_iff`). The wrap/centering
`delta` channel of B4/2 is a Verify-side verdict on the emitted value and
therefore rides INSIDE this image; the complementary failure mode (mass
outside the image — e.g. a byte-decode artifact) is the recorded converse
`SignLayerSupport.chi2_top_of_out_of_support`. -/
theorem reply_some_support {j : Law (Option BoxVec)} {jT : Law (Option BoxPair)}
    {A : BoxPair → FT1536.Relation.Rq} {c : FT1536.Relation.Rq} {k : ℝ}
    (hk : 1 ≤ k) (hshape : SignLayerSupport.ReplyShape j jT)
    (hattempt : SignLayerSupport.AttemptPointwise jT A c k)
    (v : BoxVec) (hj : j.mass (some v) ≠ 0) :
    ∃ z : BoxPair, A z = c ∧ Q (decode z) < B ∧ emit z = some v := by
  have hjn : 0 < j.mass (some v) :=
    lt_of_le_of_ne (j.nonneg (some v)) (Ne.symm hj)
  have hle : j.mass (some v) ≤ k ^ 16 * (signBody A c).mass (some v) := by
    rw [hshape (some v), SignLayerSupport.signBody_eq_signBodyOf A c]
    exact SignLayerSupport.signBodyOf_le_of_attempt_le jT (trial A c) k hk
      (SignLayerSupport.attemptPointwise_le hattempt) (some v)
  have hkp : (0:ℝ) < k ^ 16 :=
    pow_pos (lt_of_lt_of_le (by norm_num) hk) 16
  have hppos : 0 < (signBody A c).mass (some v) :=
    (SignLayerSupport.pos_mul_iff hkp ((signBody A c).nonneg (some v))).1
      (lt_of_lt_of_le hjn hle)
  exact (SignLayerSupport.signBody_some_pos_iff A c v).1 hppos

/-- THE bridging lemma, pointwise route: the two Layer-2 named obligations
(with `1 ≤ k`) discharge the `hac` premise shape — the sampler's conditional
reply law is `Divergence.AC` w.r.t. `honestReply h c`. Route: the AC half of
`SignLayerSupport.layer2_of_obligations` through the shape bridge
`honestReply_eq_signBodyOf`. No O-NONE input on this route (a pointwise bound
dominates the sampler exactly where the honest mass lives). -/
theorem hac_of_layer2 (S : FT1536.Run2.Sampler) (k : ℝ) (hk : 1 ≤ k)
    (jatt : AttemptFamily) (hshape : ReplyShapeAt S jatt)
    (hattempt : AttemptPointwiseAt jatt k) : HacShape S := by
  intro h st m r c z hz
  exact (SignLayerSupport.layer2_of_obligations (replyAt S h st m r c)
    (jatt h st m r c) (FT1536.SigmaMath.syndrome h) c k hk
    (hshape h st m r c) (hattempt h st m r c)).1 z hz

/-- THE bridging lemma, support route (the wrap-error channel of B4/2): the
same two obligations, PLUS positive honest `none` mass (O-NONE at every
challenge, `honestReply_none_pos_of_ONone`), discharge the `hac` premise shape
through `SignLayerSupport.ac_of_reply_support` — the miss point is inside the
support by O-NONE, and every positive reply is inside the `emit` image by
`reply_some_support` (this is exactly the content B4/2 proved as
`emitted_reply_supported` / `wrap_channel_in_support` /
`signBody_some_pos_iff`). This route consumes O-NONE as a premise of the
assembled certificate; the pointwise route above shows the certificate alone
would survive without it. -/
theorem hac_of_support (S : FT1536.Run2.Sampler) (k : ℝ) (hk : 1 ≤ k)
    (jatt : AttemptFamily) (hshape : ReplyShapeAt S jatt)
    (hattempt : AttemptPointwiseAt jatt k)
    (hone : ∀ (h c : FT1536.Relation.Rq), 0 < (JointDecomp.honestReply h c).mass none) :
    HacShape S := by
  intro h st m r c z hz
  have hacAC : Divergence.AC (replyAt S h st m r c)
      (signBody (FT1536.SigmaMath.syndrome h) c) :=
    SignLayerSupport.ac_of_reply_support (replyAt S h st m r c)
      (FT1536.SigmaMath.syndrome h) c
      (fun _ => ne_of_gt (hone h c))
      (fun v => reply_some_support (j := replyAt S h st m r c) hk
        (hshape h st m r c) (hattempt h st m r c) v)
  exact hacAC z hz

/-- Base-monotonicity corollary of the side condition `1 ≤ k`: the Layer-2
factor `SignLayerSupport.e2 k = (k^16)^2 - 1` is nonnegative (needed by the
certificate field `nonnegative`). -/
theorem e2_nonneg {k : ℝ} (hk : 1 ≤ k) : 0 ≤ SignLayerSupport.e2 k := by
  show 0 ≤ (k ^ 16) ^ 2 - 1
  have h16 : (1:ℝ) ≤ k ^ 16 := by
    have h := SignLayerSupport.pow_mono_exp (k := k) hk (i := (0:ℕ)) (j := 16) (by norm_num)
    simpa using h
  have h2 : (1:ℝ) ≤ (k ^ 16) ^ 2 := by
    rw [pow_two]
    simpa using mul_le_mul h16 h16 (zero_le_one) (le_trans zero_le_one h16)
  linarith

/-- THE constructor WITHOUT the `hac` premise (goal 1): the challenge-layer
bound `1 + d1` and the two Layer-2 named obligations at factor `k` give the
full `FT1536.Run2.LocalJointCertificate S ((1 + d1) * (1 + e2 k) - 1)`. The
`hac` premise of `JointDecomp.localJointCertificate_of_joint_bounds` is
discharged by `hac_of_layer2`; its `hcond` premise is the second half of
`SignLayerSupport.layer2_of_obligations`. Nothing else is assumed. -/
theorem localJointCertificate_of_joint_bounds_no_hac (S : FT1536.Run2.Sampler)
    (d1 k : ℝ) (hd1 : 0 ≤ d1) (hk : 1 ≤ k) (jatt : AttemptFamily)
    (hmarg : ∀ (h : FT1536.Relation.Rq) (st : FT1536.Run2.State)
      (m : FT1536.Run2.Bytes) (r : FT1536.Run2.Nonce),
      Divergence.second (JointDecomp.marginal (FT1536.Run2.samplerLaw S h st m r))
        (Law.uniform : Law FT1536.Relation.Rq) ≤ 1 + d1)
    (hshape : ReplyShapeAt S jatt) (hattempt : AttemptPointwiseAt jatt k) :
    FT1536.Run2.LocalJointCertificate S ((1 + d1) * (1 + SignLayerSupport.e2 k) - 1) :=
  JointDecomp.localJointCertificate_of_joint_bounds S d1 (SignLayerSupport.e2 k) hd1
    (e2_nonneg hk) hmarg
    (fun h st m r c => (SignLayerSupport.layer2_of_obligations (replyAt S h st m r c)
      (jatt h st m r c) (FT1536.SigmaMath.syndrome h) c k hk (hshape h st m r c)
      (hattempt h st m r c)).2)
    (hac_of_layer2 S k hk jatt hshape hattempt)

/-! ## 2. O-NONE: positive `none` mass of the honest body -/

/-- The EXACT condition behind positive `none` mass at an ACHIEVABLE
challenge (goal 2): `SignLayerSupport.signBody_none_pos_iff` with the
empty-fiber branch killed by achievability — either an out-of-box fiber point
(`¬ Q (decode z) < B`, the O-NONE premise) or an in-box fiber point with an
unencodable tail (`¬ signed16 z.2`, the `emit` encode-failure tag). -/
theorem signBody_none_pos_iff_achievable (A : BoxPair → FT1536.Relation.Rq)
    (c : FT1536.Relation.Rq) (hach : ∃ z : BoxPair, A z = c) :
    0 < (signBody A c).mass none ↔
      ((∃ z : BoxPair, A z = c ∧ ¬ Q (decode z) < B) ∨
        ∃ z : BoxPair, A z = c ∧ Q (decode z) < B ∧ ¬ PublicSimulation.signed16 z.2) := by
  rw [SignLayerSupport.signBody_none_pos_iff, SignLayerSupport.trial_none_pos_iff]
  constructor
  · intro h
    rcases h with h | h
    · rcases h with h | h
      · exact Or.inl h
      · obtain ⟨z0, hz0⟩ := hach
        exact absurd hz0 (h z0)
    · exact Or.inr h
  · intro h
    rcases h with h | h
    · exact Or.inl (Or.inl h)
    · exact Or.inr h

/-- O-NONE sufficient branch: an out-of-box fiber point over `c` gives
positive `none` mass (through the attempt-level miss of
`SignLayerSupport.trial_none_pos_iff`). -/
theorem signBody_none_pos_of_out_of_box (A : BoxPair → FT1536.Relation.Rq)
    (c : FT1536.Relation.Rq) (h : ∃ z : BoxPair, A z = c ∧ ¬ Q (decode z) < B) :
    0 < (signBody A c).mass none :=
  (SignLayerSupport.signBody_none_pos_iff A c).2
    (Or.inl ((SignLayerSupport.trial_none_pos_iff A c).2 (Or.inl h)))

/-- A NON-achievable challenge is settled outright: an empty fiber aborts
(`SignLayerSupport.trial_none_pos_iff`, `∀ z, A z ≠ c` branch), so the
`none` mass is positive with no geometric hypothesis — only the
non-achievability itself. -/
theorem signBody_none_pos_of_fiberless (A : BoxPair → FT1536.Relation.Rq)
    (c : FT1536.Relation.Rq) (h : ∀ z : BoxPair, A z ≠ c) :
    0 < (signBody A c).mass none :=
  (SignLayerSupport.signBody_none_pos_iff A c).2
    (Or.inl ((SignLayerSupport.trial_none_pos_iff A c).2 (Or.inr h)))

/-- O-NONE payoff: under the named premise `ONone`, EVERY target `c` has
positive `none` mass — achievable challenges by the out-of-box fiber point,
the rest by the empty-fiber abort. -/
theorem signBody_none_pos_of_ONone (A : BoxPair → FT1536.Relation.Rq) (h : ONone A)
    (c : FT1536.Relation.Rq) : 0 < (signBody A c).mass none := by
  by_cases hex : ∃ z : BoxPair, A z = c
  · exact signBody_none_pos_of_out_of_box A c (h c hex)
  · exact signBody_none_pos_of_fiberless A c (fun z hz => hex ⟨z, hz⟩)

/-- O-NONE at the pinned comparison pair: positive `none` mass of the honest
body `honestReply h c` under `ONone (syndrome h)`. -/
theorem honestReply_none_pos_of_ONone (h : FT1536.Relation.Rq)
    (hone : ONone (FT1536.SigmaMath.syndrome h)) (c : FT1536.Relation.Rq) :
    0 < (JointDecomp.honestReply h c).mass none :=
  signBody_none_pos_of_ONone (FT1536.SigmaMath.syndrome h) hone c

/-- Exactness of the O-NONE role, necessity side: an attempt law with
positive miss mass cannot be pointwise-dominated at `none` unless the pinned
trial law also misses (`SignLayerSupport.AttemptPointwise.none_le`). -/
theorem attempt_miss_pos_of_pointwise {jT : Law (Option BoxPair)}
    {A : BoxPair → FT1536.Relation.Rq} {c : FT1536.Relation.Rq} {k : ℝ}
    (h : SignLayerSupport.AttemptPointwise jT A c k) (hm : 0 < jT.mass none) :
    0 < (trial A c).mass none := by
  by_contra hc
  have hz : (trial A c).mass none = 0 :=
    le_antisymm (le_of_not_gt hc) ((trial A c).nonneg none)
  have hle := h.none_le
  rw [hz, mul_zero] at hle
  linarith

/-- O-NONE role, conclusion side (WEAKER than exactness): a MISS-CAPABLE
sampler attempt law plus `SignLayerSupport.AttemptPointwise` forces positive
honest `none` mass (first branch of
`SignLayerSupport.signBody_none_pos_iff`). The `signBody`-level positivity is
NOT the exact condition: the `¬ signed16 z.2` tail branch of
`signBody_none_pos_iff_achievable` gives it without any dominated miss-capable
attempt law. The exact two-way statement is
`attempt_miss_satisfiable_iff_onone` below. -/
theorem signBody_none_pos_of_attempt_miss {jT : Law (Option BoxPair)}
    {A : BoxPair → FT1536.Relation.Rq} {c : FT1536.Relation.Rq} {k : ℝ}
    (h : SignLayerSupport.AttemptPointwise jT A c k) (hm : 0 < jT.mass none) :
    0 < (signBody A c).mass none :=
  (SignLayerSupport.signBody_none_pos_iff A c).2
    (Or.inl (attempt_miss_pos_of_pointwise h hm))

/-- THE exact O-NONE role (both directions): at an ACHIEVABLE challenge the
`none`-side of `SignLayerSupport.AttemptPointwise` admits a MISS-CAPABLE
attempt law if and only if the O-NONE out-of-box conclusion holds there.
(=>) `attempt_miss_pos_of_pointwise` gives `0 < (trial A c).mass none`, and
`SignLayerSupport.trial_none_pos_iff` with the empty-fiber branch dead gives
the out-of-box fiber point. (<=) the pinned trial law itself, at factor `1`,
is a dominated attempt law and misses exactly when `(trial A c).mass none >
0` — again `SignLayerSupport.trial_none_pos_iff`, out-of-box branch. The real
sampler (positive miss budget `rejB` of `FT1536.CenteringClosure`) must fit
the `none`-side, so this is the exact source-side condition of the Layer-2
premise at the miss point. -/
theorem attempt_miss_satisfiable_iff_onone (A : BoxPair → FT1536.Relation.Rq)
    (c : FT1536.Relation.Rq) (hach : ∃ z : BoxPair, A z = c) :
    ((∃ (jT : Law (Option BoxPair)) (k : ℝ),
        SignLayerSupport.AttemptPointwise jT A c k ∧ 0 < jT.mass none)) ↔
      (∃ z : BoxPair, A z = c ∧ ¬ Q (decode z) < B) := by
  constructor
  · intro h
    obtain ⟨jT, k, hp, hm⟩ := h
    have hpos : 0 < (trial A c).mass none :=
      attempt_miss_pos_of_pointwise hp hm
    rcases (SignLayerSupport.trial_none_pos_iff A c).1 hpos with h | h
    · exact h
    · obtain ⟨z0, hz0⟩ := hach
      exact absurd hz0 (h z0)
  · intro h
    have hpos : 0 < (trial A c).mass none :=
      (SignLayerSupport.trial_none_pos_iff A c).2 (Or.inl h)
    exact ⟨trial A c, (1:ℝ),
      { some_le := fun z => le_of_eq (one_mul _).symm
        none_le := le_of_eq (one_mul _).symm }, hpos⟩

/-! ## 3. The assembled certificate -/

/-- THE assembled B4 certificate (goal 3), in the synthesis shape
`FT1536.Run2.LocalJointCertificate S ((1 + d1) * (1 + d2) - 1)` with the
exact challenge layer `d1 = 0` (Layer 1: `UniformChallenge` gives the
challenge marginal `= Law.uniform`, so `second = 1` exactly) and
`d2 = SignLayerSupport.e2 k = k^32 - 1` (Layer 2: `ReplyShape` +
`AttemptPointwise` at factor `k`).

THE EXACT FINAL ARGUMENT LIST, in binder order — nothing else is assumed:

* `S : FT1536.Run2.Sampler` — the sampler under test (object, not an
  assumption);
* `k : ℝ` — the per-attempt comparison factor (object; the target value is
  `SignLayerSupport.attemptFactor`);
* `hk : 1 ≤ k` — arithmetic side condition (at the candidate factor
  `SignLayerSupport.attemptFactor` it is `SignLayerSupport.attemptFactor_one_le`,
  proved, not an assumption);
* `jatt : AttemptFamily` — the one-attempt law family (witness object of the
  Layer-2 premises);
* `huc : UniformChallengeAt S` — NAMED PREMISE `UniformChallenge` (Layer 1,
  the single ROM assumption, B3/X `FT1536.VerifyBind`);
* `hshape : ReplyShapeAt S jatt` — NAMED PREMISE `ReplyShape` (source
  binding, B1/source3);
* `hattempt : AttemptPointwiseAt jatt k` — NAMED PREMISE `AttemptPointwise`
  at its exact `SignLayerSupport` interface (the analytic core, window B4/3a);
* `hone : ∀ h, ONone (syndrome h)` — NAMED PREMISE `O-NONE` (the box point;
  source-side fiber geometry), consumed by the support-route discharge
  `hac_of_support`.

The byte-bridge swallow and the additive-error caveat are NOT arguments of
this theorem (recorded open items, outside its multiplicative shape). -/
theorem localJointCertificate_of_named_premises (S : FT1536.Run2.Sampler) (k : ℝ)
    (hk : 1 ≤ k) (jatt : AttemptFamily)
    (huc : UniformChallengeAt S) (hshape : ReplyShapeAt S jatt)
    (hattempt : AttemptPointwiseAt jatt k)
    (hone : ∀ h : FT1536.Relation.Rq, ONone (FT1536.SigmaMath.syndrome h)) :
    FT1536.Run2.LocalJointCertificate S ((1 + (0:ℝ)) * (1 + SignLayerSupport.e2 k) - 1) := by
  refine JointDecomp.localJointCertificate_of_joint_bounds S (0:ℝ) (SignLayerSupport.e2 k)
    (by norm_num) (e2_nonneg hk) ?_ ?_ ?_
  · intro h st m r
    have h1 : JointDecomp.marginal (FT1536.Run2.samplerLaw S h st m r)
        = (Law.uniform : Law FT1536.Relation.Rq) := huc h st m r
    rw [h1, JointDecomp.second_self]
    norm_num
  · intro h st m r c
    exact (SignLayerSupport.layer2_of_obligations (replyAt S h st m r c)
      (jatt h st m r c) (FT1536.SigmaMath.syndrome h) c k hk (hshape h st m r c)
      (hattempt h st m r c)).2
  · exact hac_of_support S k hk jatt hshape hattempt
      (fun h c => honestReply_none_pos_of_ONone h (hone h) c)

/-- The `d1 = 0` variant in its reduced form (`e = d2`, the synthesis note):
`(1 + 0) * (1 + e2 k) - 1 = e2 k = k^32 - 1`. Same argument list as
`localJointCertificate_of_named_premises`. -/
theorem localJointCertificate_of_named_premises_e (S : FT1536.Run2.Sampler) (k : ℝ)
    (hk : 1 ≤ k) (jatt : AttemptFamily)
    (huc : UniformChallengeAt S) (hshape : ReplyShapeAt S jatt)
    (hattempt : AttemptPointwiseAt jatt k)
    (hone : ∀ h : FT1536.Relation.Rq, ONone (FT1536.SigmaMath.syndrome h)) :
    FT1536.Run2.LocalJointCertificate S (SignLayerSupport.e2 k) := by
  have hr : ((1 + (0:ℝ)) * (1 + SignLayerSupport.e2 k) - 1) = SignLayerSupport.e2 k := by
    ring
  rw [← hr]
  exact localJointCertificate_of_named_premises S k hk jatt huc hshape hattempt hone

/-- Lean variant WITHOUT O-NONE (recorded for scope sharpness): with the
pointwise-route discharge `hac_of_layer2` the certificate's NAMED inputs are
only `UniformChallenge` + `ReplyShape` + `AttemptPointwise` (over the objects
`S`, `jatt` and the arithmetic `1 ≤ k`); `hac_of_support`'s `hone` input is
the only place O-NONE is consumed by the assembled certificate. O-NONE stays
in the project scope regardless:
`attempt_miss_satisfiable_iff_onone` pins it as the exact condition under
which a miss-capable sampler fits the `none`-side of `AttemptPointwise`. -/
theorem localJointCertificate_of_pointwise_premises (S : FT1536.Run2.Sampler) (k : ℝ)
    (hk : 1 ≤ k) (jatt : AttemptFamily)
    (huc : UniformChallengeAt S) (hshape : ReplyShapeAt S jatt)
    (hattempt : AttemptPointwiseAt jatt k) :
    FT1536.Run2.LocalJointCertificate S (SignLayerSupport.e2 k) :=
  JointDecomp.localJointCertificate_of_uniform_challenge S (SignLayerSupport.e2 k)
    (e2_nonneg hk) huc
    (fun h st m r c => (SignLayerSupport.layer2_of_obligations (replyAt S h st m r c)
      (jatt h st m r c) (FT1536.SigmaMath.syndrome h) c k hk (hshape h st m r c)
      (hattempt h st m r c)).2)
    (hac_of_layer2 S k hk jatt hshape hattempt)

/-- THE final numeric form at the candidate factor: at
`k = SignLayerSupport.attemptFactor` (the composite of the kernelized T5
machine sandwich, A2/tower sandwich and wrap budgets of
`SignLayerSupport`) the assembled certificate has
`e = SignLayerSupport.e2 SignLayerSupport.attemptFactor < 2^-32`
(`SignLayerSupport.e2_attemptFactor_lt`), and its argument list is, in
binder order, EXACTLY the objects `S`, `jatt` and the four named premises
`huc` (`UniformChallenge`), `hshape` (`ReplyShape`), `hattempt`
(`AttemptPointwise` at `attemptFactor`), `hone` (`O-NONE`). -/
theorem localJointCertificate_of_named_premises_attemptFactor (S : FT1536.Run2.Sampler)
    (jatt : AttemptFamily)
    (huc : UniformChallengeAt S) (hshape : ReplyShapeAt S jatt)
    (hattempt : AttemptPointwiseAt jatt SignLayerSupport.attemptFactor)
    (hone : ∀ h : FT1536.Relation.Rq, ONone (FT1536.SigmaMath.syndrome h)) :
    FT1536.Run2.LocalJointCertificate S
      (SignLayerSupport.e2 SignLayerSupport.attemptFactor) :=
  localJointCertificate_of_named_premises_e S SignLayerSupport.attemptFactor
    SignLayerSupport.attemptFactor_one_le jatt huc hshape hattempt hone

end FT1536.HacGlue
