# PROMPT — new window: AttemptWeights (the four-stage sandwich transport — the heavy analytic core)

Workspace: `proofs/ft1536/development/T12_1/run2/`. Small local commits via
`git commit --only -- <paths>`; NO push (owner signal); one Git writer at a
time (three parallel lanes run: B1 in `source3/`, B5 in `formal/Assembly.lean`).
English crypto register in code. OWN FILES ONLY: create
`formal/AttemptWeights.lean` + `notes/B4_ATTEMPT_WEIGHTS_WORK_STATE.md`.
Everything else READ-ONLY. Zero unfinished-proof markers; defs-first;
guarded compiles; logs 0/0; axiom audit your module.

**Read first:** `notes/B4_ATTEMPT_WORK_STATE.md` (YOUR contract — the
`AttemptWeights` interface, the four-stage margin table, the candidate
`attemptFactor` computation), `formal/AttemptPointwise.lean` (the consumer
of your result — the exact type you must deliver), `notes/B4_SYNTHESIS.md`
(the assembly map), `formal/SignLayerSupport.lean` (the none-cases and
support facts), `formal/CenteringClosure.lean` (wrap budgets tauB/boxB,
kernelized), `formal/SecondMoment.lean` (toolkit).

## Goal — prove `AttemptWeights`

The one-attempt mass comparison of `AttemptPointwise` factorizes as a
transport of the realized attempt weights through FOUR stages, each with a
recorded multiplicative margin. Prove the transport and compose the
margins kernel-side to `attemptFactor < 1 + 2^-38` (the numeric
composition in the exact-ℚ / `norm_num` style of `CenteringClosure`):

1. **T5 machine sandwich** — `machineMargin < 1 + 2^-42` (consuming the
   kernelized T5 margins in `CenteringClosure`/`T5ScalarMass`; cite, don't
   rebuild);
2. **A2 tower / fiber-tilt sandwich over the WHOLE tail region** —
   `towerMargin < 1 + 2^-43`. THIS is the named heavy item: the sandwich
   must hold over the entire tail region of the weight function, not just
   the bulk. The tower machinery (`a2Tower`, `triangular_mass_bounds`
   error ~2^-46, `Run2/T5ScalarMass`, `Run2/A2Theta`) is the toolkit;
   `notes/S3_E_PROVENANCE.md` records where these bounds live. If a global
   tail-region statement is missing from the toolkit, prove it (the
   `SecondMoment` style: small defs, pointwise identities, then compose);
3. **wrap budget** — `tauB = 2^-40` (CenteringClosure; consume);
4. **box budget** — `boxB = 1e-1000` (CenteringClosure; consume).

Composition (already the contract of B4/3a): the product of the stage
margins gives `k = attemptFactor < 1 + 2^-38`, and
`layer2_of_obligations`/`layer2_e2_actual` deliver `e2 = k^32 - 1 <
2^-32`. `rejB = 2^-24` stays OUTSIDE the multiplicative factor (the
absolute miss-mass budget) — unless the attempt shape turns out to be
acceptance-conditioned (the recorded trap: then a `1/(1-rejB)` factor
moves inside; do NOT assume either shape — state which one your transport
proves and note the delta).

## Honest boundaries

- The DEFINITION of the realized attempt weights comes from the
  `AttemptShape` interface (B1/source3's S.code binding — in progress).
  Take it as a named parameter with the exact type from
  `B4_ATTEMPT_WORK_STATE.md`; your theorem proves the TRANSPORT for any
  weights satisfying that interface.
- Additive errors (`Adv_PRG`, byte bridges) stay out of the multiplicative
  shape (mass-floor caveat recorded) — do not force them in.
- If some stage's margin cannot be closed from the current toolkit, record
  the EXACT missing lemma with its intended type (this becomes the input
  for the T5/REFINE material owners) — never assume it.

## Deliverables

`formal/AttemptWeights.lean` (0/0 + axiom audit),
`notes/B4_ATTEMPT_WEIGHTS_WORK_STATE.md` per batch, Polish handoff
summary: the composed `attemptFactor` with its exact stage table (proven
vs assumed margins — the split IS the remaining analytic scope).
