# PROMPT — new window: B4/3a, AttemptPointwise (the one-attempt mass comparison — the analytic core)

Workspace: `proofs/ft1536/development/T12_1/run2/`. Small local commits via
`git commit --only -- <paths>`; NO push (owner signal); one Git writer at a
time. English crypto register in code. OWN FILES ONLY: create
`formal/AttemptPointwise.lean` + `notes/B4_ATTEMPT_WORK_STATE.md`.
Everything else READ-ONLY. Zero unfinished-proof markers incl. placeholders;
defs-first; guarded compiles (`tools/original/run_lean_guarded.sh`); logs 0/0.

**Read first:** `notes/B4_SYNTHESIS.md` (your obligation is named there:
`AttemptPointwise`), `formal/SignLayerSupport.lean` +
`notes/B4_LAYER2_WORK_STATE.md` (the exact obligation shapes and the
candidate factor computation), `formal/SecondMoment.lean` (toolkit),
`formal/CenteringClosure.lean` (wrap budgets tauB/boxB/rejB + the two named
delta premises), `notes/S1_P_ACCEPT_FACTS.md` (methodology model: facts
with line citations, no smoothing).

## Goal — `AttemptPointwise`

Prove (or reduce with surgical precision) the one-attempt mass comparison
that B4/2's `layer2_of_obligations` consumes:

    for one to_sign attempt law `jatt` and the pinned trial law
    `trial A c` (PublicSimulation): pointwise factor `k`,
    jatt.mass z <= k * (trial A c).mass z  (and the none-side comparison)

with the candidate `k = attemptFactor < 1 + 2^-38` assembled from inputs
ALREADY kernelized: T5 machine sandwich `machineMargin < 1 + 2^-42`, A2
tower sandwich `towerMargin < 1 + 2^-43`, wrap budgets `tauB = 2^-40`,
`boxB = 1e-1000`. Consume those; do not re-prove them. With it the
conditional corollary `e2 < 2^-32` upgrades from conditional to actual.

Work in this order (small steps, each verified):
1. state the EXACT `jatt` (the one-attempt law of the real `to_sign`
   sampler) — if its definition requires source binding (`S.code`,
   `ReplyShape` territory), state the interface precisely and prove
   everything DOWN FROM the interface; record the boundary honestly;
2. the `some`-side comparison over the `emit` image (in-box z, `signed16`);
3. the `none`-side comparison (the four none-cases of
   `SignLayerSupport`: empty fiber, norm reject, cap exhaustion, encoding
   flag) — this is where `rejB` lives (miss-mass budget; keep it OUTSIDE
   the multiplicative factor, as recorded);
4. the numeric kernel checks of the composed `attemptFactor` (exact ℚ or
   `norm_num` literals in the style of `CenteringClosure`).

## Honest boundaries (the two known swallows)

- The additive-error caveat: `Adv_PRG`-style additive terms do NOT fit the
  multiplicative `AttemptPointwise` shape without a mass floor — keep them
  out of `e` (they belong to the outer bound, scope Section 1); record any
  place where you would need a floor.
- If the real `to_sign` attempt law cannot be pinned without `ReplyShape`
  (source3/B1's binding of `SIGN_MAX_ATTEMPTS=16` and emission
  `:3412-3418`), your theorem takes it as a NAMED parameter — never assume
  its content silently.

## Deliverables

`formal/AttemptPointwise.lean` (0/0), `notes/B4_ATTEMPT_WORK_STATE.md` per
batch, Polish handoff summary (what proven, what reduced to which named
premise, the numeric status of `attemptFactor`).
