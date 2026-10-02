# B4 synthesis — the delta -> e chain is now a two-premise problem (2026-10-02)

Assembly record of the three parallel deliveries (B4/1 `JointDecomp.lean`,
B4/2 `SignLayerSupport.lean`, B3/X `HashTo.lean`) as consumed by
`SecondMoment.localJointCertificate_of_joint_bounds`.

## The assembled shape

    LocalJointCertificate S ((1+d1)*(1+d2)-1)

- **Layer 1 (challenge)**: `UniformChallenge` (B3/X) gives `d1 = 0`
  exactly -> `e = d2`. The exact variant of
  `JointDecomp.localJointCertificate_of_joint_bounds` applies.
- **Layer 2 (reply)**: `honestReply h c = signBody (syndrome h) c` is
  PROVEN (B4/1) to be the conditional of `freshHonest h` -> the comparison
  target is exactly `signBody`. B4/2's `layer2_of_obligations` gives
  `AC + second <= 1 + e2` from one pointwise factor `k` on the trial law,
  propagated as `e2 = k^32 - 1` through `cap 16 .map emit`.
- **AC feasibility (the wrap-error question)**: RESOLVED by B4/2 — the
  `delta` mass lands INSIDE the support (`emitted_reply_supported`,
  `wrap_channel_in_support`; the honest law itself carries Verify-rejected
  replies, `BadVerify.emitted_bad_mass`), so the POINTWISE route applies
  and `second_cond_le` is not needed here. The converse risk is recorded
  (`chi2_top_of_out_of_support`): any real-sampler mass outside the `emit`
  image (byte-decode artifact) breaks AC and makes chi2 infinite.

## The exact remaining obligations (nothing else blocks e)

1. **`AttemptPointwise`** (the heavy analytic core): the one-attempt mass
   comparison of the real `to_sign` attempt law against `fiberWeight` +
   normalizer + the miss comparison. Candidate factor already computed
   kernel-side: T5 machine sandwich `machineMargin < 1 + 2^-42`, A2 tower
   sandwich `towerMargin < 1 + 2^-43`, wrap budgets `tauB/boxB` ->
   `attemptFactor < 1 + 2^-38`; with it, `e2 < 2^-32` (conditional
   corollary, kernel-checked). `rejB` stays outside the factor (miss-mass
   budget of the delta bridge).
2. **`ReplyShape`** (source binding): the law shape of one attempt bound to
   the pinned C (`SIGN_MAX_ATTEMPTS=16`, emission `:3412-3418`) — the
   source3/B1 and B3 SIGN-side material is the input.
3. **`O-NONE`** (box point): positive `signBody` mass at `none` for every
   achievable challenge (the exact condition is `signBody_none_pos_iff`).
4. **Byte bridge** of the model (open swallow, recorded by B4/2).

The additive-error caveat (e.g. `Adv_PRG`) does NOT fit the multiplicative
`AttemptPointwise` shape without a mass floor — recorded openly; it stays
an additive term of the outer bound (Section 1 of the scope), not of `e`.

## Consumption map

    B3/X  UniformChallenge + HashToSpec        -> Layer 1 (d1 = 0)
    B4/1  decomposition + joint_bounds ctor    -> the assembly mechanism
    B4/2  support/AC + layer2_of_obligations   -> Layer 2 skeleton (e2 = k^32-1)
    S3    CenteringClosure delta + budgets     -> the wrap-error inputs
    T5    machine/tower sandwiches             -> the mass-margin inputs
    B1    (source3, in progress)               -> ReplyShape + S.code binding
    B5    assembly                             -> the final theorem
