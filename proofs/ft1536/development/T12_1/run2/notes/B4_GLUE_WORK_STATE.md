# B4/3b — the `hac` glue, O-NONE, and the assembled certificate

Task: `notes/PROMPT_B4_HAC_GLUE.md` (window B4/3b; the glue of the three B4
deliverables per `notes/B4_SYNTHESIS.md`). Workspace
`proofs/ft1536/development/T12_1/run2/`. Own files only:
`formal/HacGlue.lean` + this entry. Recorded 2026-10-02.

## Status

**DONE — `formal/HacGlue.lean` builds 0/0** (empty log, guarded serial
compile `tools/original/run_lean_guarded.sh`, exit 0; rebuilt after the batch
review fixes). Axiom audit: **26/26 audited declarations (7 defs/abbrevs +
19 theorems) depend only on `[propext, Classical.choice, Quot.sound]`**. No
unfinished-proof markers (incl. placeholders). All statements on the pinned
types; nothing assumed beyond the named premises of
`notes/B4_SYNTHESIS.md` §obligations that are Lean premises here
(`AttemptPointwise`, `ReplyShape`, O-NONE), Layer 1 `UniformChallenge`, and
the arithmetic side condition `1 ≤ k` (exact binder list in Part 3 below —
that list IS the remaining project scope of B4).

Subagent batch review (2026-09-30 rhythm): verdict **NEEDS_FIXES** — 1 major
(the "exact final argument list" drifted from the real binder order and
missed `k`) + 8 minor wording/provenance findings; ALL fixed in both files
(details in Part 5).

## 1. Discharge of `hac` (prompt goal 1)

The premise `hac` of `JointDecomp.localJointCertificate_of_joint_bounds` is
about the SAMPLER's reply law vs `signBody (syndrome h) c`; B4/2's content is
about `signBodyOf`/`cap`/`emit`. The shape pieces:

- `replyAt S h st m r c := JointDecomp.condOf (samplerLaw S h st m r) c` —
  the sampler's per-challenge reply law (B4/1's conditional), the subject of
  both the `hac` premise and the Layer-2 comparison;
- `HacShape S` — the `hac` premise shape, named;
- **`honestReply_eq_signBodyOf`** — THE shape bridge:
  `honestReply h c = signBodyOf (trial (syndrome h) c)` (through B4/2's
  `signBody_eq_signBodyOf`), so the premise target and the B4/2 support map
  are ONE law.

Two proved discharge routes over the same two Layer-2 named obligations
(`ReplyShape` + `AttemptPointwise` at `1 ≤ k`):

- **`hac_of_layer2`** (pointwise route) — the AC half of
  `SignLayerSupport.layer2_of_obligations`, through the shape bridge. No
  O-NONE input (a pointwise bound dominates the sampler exactly where the
  honest mass lives);
- **`hac_of_support`** (support route, the wrap-error channel of B4/2) — via
  `SignLayerSupport.ac_of_reply_support`: the miss point is inside the
  support by O-NONE (positive honest `none` mass), and every positive reply
  is inside the `emit` image by **`reply_some_support`** (the `hsome` shape,
  from `AttemptPointwise` + `signBodyOf_le_of_attempt_le` +
  `signBody_some_pos_iff`). This is exactly the content B4/2 proved as
  `emitted_reply_supported` / `wrap_channel_in_support` (the wrap/centering
  `delta` is a Verify-side verdict on the emitted value, hence INSIDE the
  image); the honest flip side stays recorded as
  `SignLayerSupport.chi2_top_of_out_of_support` (mass outside the `emit`
  image — e.g. a byte-decode artifact — breaks AC and forces `chi2 = ⊤`).

**`localJointCertificate_of_joint_bounds_no_hac`** — THE constructor WITHOUT
the `hac` premise: challenge-layer bound `1 + d1` + the two Layer-2
obligations at factor `k` give
`FT1536.Run2.LocalJointCertificate S ((1 + d1) * (1 + e2 k) - 1)`; `hac` is
discharged by `hac_of_layer2` and `hcond` is the second half of
`layer2_of_obligations`. Side lemma `e2_nonneg : 1 ≤ k → 0 ≤ e2 k`.

## 2. O-NONE (prompt goal 2)

- **`signBody_none_pos_iff_achievable`** — the EXACT condition at an
  achievable challenge (`∃ z, A z = c` kills the empty-fiber branch of
  `SignLayerSupport.signBody_none_pos_iff` +
  `trial_none_pos_iff`): positive `none` mass <=> an out-of-box fiber point
  (`∃ z, A z = c ∧ ¬ Q (decode z) < B`) OR an in-box fiber point with an
  unencodable tail (`∃ z, A z = c ∧ Q (decode z) < B ∧ ¬ signed16 z.2`).
- `signBody_none_pos_of_fiberless` — non-achievable challenges are settled
  OUTRIGHT (empty-fiber abort; no geometric hypothesis beyond the
  non-achievability itself).
- **`ONone`** — the natural achievability hypothesis, RECORDED as a named
  premise (never assumed): every achievable `c` has an out-of-box fiber
  point. It needs source/key-side fiber geometry (the lattice coset of
  `Relation.A h` inside the finite `BoxPair` spreads beyond the `Q < B`
  region); it is NOT derivable from the current kernel interfaces, and it is
  genuinely a hypothesis (degenerate keys could have a whole fiber inside
  the box and encodable).
- Payoff: `signBody_none_pos_of_ONone` + `honestReply_none_pos_of_ONone` —
  under `ONone (syndrome h)` EVERY challenge has positive honest `none`
  mass.
- Exactness of the role: **`attempt_miss_satisfiable_iff_onone`** (the exact
  two-way statement) — at an achievable challenge the `none`-side of
  `AttemptPointwise` admits a MISS-CAPABLE attempt law (`0 < jT.mass none`;
  the real sampler's `rejB = 2^-24` miss budget is positive) IFF the O-NONE
  out-of-box conclusion holds there; the (<=) witness is the pinned trial law
  at factor `1`. Supporting pieces: `attempt_miss_pos_of_pointwise`
  (domination forces a trial-level miss) and
  `signBody_none_pos_of_attempt_miss` — the latter is only the WEAKER
  `signBody`-level positivity (the `¬ signed16` tail branch gives it without
  any dominated miss-capable law, so it is NOT the exact condition; review
  finding fixed). This is why O-NONE stays in the assembled certificate's
  interface even though the pointwise route alone would discharge `hac`
  without it.

## 3. The assembled certificate (prompt goal 3) — THE exact final argument list

**`localJointCertificate_of_named_premises`** :
`FT1536.Run2.LocalJointCertificate S ((1 + d1) * (1 + d2) - 1)` with
`d1 = 0` and `d2 = SignLayerSupport.e2 k = k^32 - 1`. Its argument list is
EXACTLY, in binder order (nothing else is assumed):

| Argument (binder order) | Kind | Content / owner lane |
|---|---|---|
| `S : FT1536.Run2.Sampler` | object | the sampler under test (`S.code` binding = B1/source3, OPEN) |
| `k : ℝ` | object | the per-attempt comparison factor; the target value is `SignLayerSupport.attemptFactor` |
| `hk : 1 ≤ k` | arithmetic | at `k = attemptFactor` this is `SignLayerSupport.attemptFactor_one_le` (proved), not an assumption |
| `jatt : AttemptFamily` | witness object | the per-signing-point one-attempt law family (NOT an assumption) |
| `huc : UniformChallengeAt S` | NAMED PREMISE | `UniformChallenge` = the single ROM assumption `L = Law.uniform` on the challenge marginal (B3/X `VerifyBind.HashTo`), gives `d1 = 0` |
| `hshape : ReplyShapeAt S jatt` | NAMED PREMISE | `ReplyShape` — the sampler conditional IS `signBodyOf (jatt …)` (source binding: `SIGN_MAX_ATTEMPTS = 16`, emission `Extra/c/falcon-sign.c:3412-3418`); B1/source3 |
| `hattempt : AttemptPointwiseAt jatt k` | NAMED PREMISE | `AttemptPointwise` at its EXACT `SignLayerSupport` interface (`some z` + `none` comparison vs `trial (syndrome h) c`); window B4/3a (parallel) |
| `hone : ∀ h, ONone (syndrome h)` | NAMED PREMISE | O-NONE (box point; source-side fiber geometry), consumed by the support-route discharge `hac_of_support` |

**This table IS the remaining project scope of B4.** Variants (all proved):

- `localJointCertificate_of_named_premises_e` — the reduced `d1 = 0` form
  `e = d2 = e2 k` (same list);
- `localJointCertificate_of_named_premises_attemptFactor` — at
  `k = attemptFactor`: `e = e2 attemptFactor < 2^-32`
  (`SignLayerSupport.e2_attemptFactor_lt`); binder order `(S, jatt, huc,
  hshape, hattempt, hone)` = the objects `S`, `jatt` + the four named
  premises (`k` fixed, `hk` discharged by `attemptFactor_one_le`);
- `localJointCertificate_of_pointwise_premises` — the leaner NAMED list
  WITHOUT O-NONE (`UniformChallenge` + `ReplyShape` + `AttemptPointwise`;
  over the objects `S`, `jatt` and the arithmetic `1 ≤ k`; the pointwise
  route `hac_of_layer2`). `hac_of_support`'s `hone` input is the only place
  O-NONE is consumed by the assembled certificate; it stays in scope
  regardless (Part 2 exactness lemma).

NOT arguments of the theorem (recorded open items, outside its
multiplicative shape): the byte-bridge swallow (open model bridge of
`PublicSimulation`; its failure mode is
`SignLayerSupport.chi2_top_of_out_of_support`) and the additive-error caveat
(`Adv_PRG`-shaped terms need a mass floor or the conservative
`SecondMoment.second_cond_le` route — outer bound; see the
`Honest boundary of the multiplicative shape` paragraph of Part 3 in
`notes/B4_LAYER2_WORK_STATE.md`).

## 4. Compile receipt

- Source: `formal/HacGlue.lean`; module `HacGlue`; command
  `bash tools/original/run_lean_guarded.sh formal/HacGlue.lean
  .build/check_lib/HacGlue.olean 900 3600` — exit 0 (first build 182s;
  rebuild after the review fixes exit 0, log re-verified empty).
- Log `.build/check_lib/HacGlue.log`: **empty** = 0 errors / 0 warnings.
- Axiom audit `.build/audit/HacGlueAudit.lean` + `.log` (scratch under
  ignored `.build/`, nothing else touched; the `#print axioms` pattern of
  `formal/VerifyBind/Audit.lean`): **26/26 declarations (7 defs/abbrevs +
  19 theorems), axioms `[propext, Classical.choice, Quot.sound]` only**.
- Marker check: no `sorry`/`admit`/`native_decide`/placeholders.
- Dependencies (REUSE, unmodified): `JointDecomp` (`condOf`, `honestReply`,
  `marginal`, `second_self`, `localJointCertificate_of_joint_bounds`,
  `localJointCertificate_of_uniform_challenge`), `SignLayerSupport`
  (`signBodyOf`/`geo`/`imageMass` mass formulas, support characterization,
  `AttemptPointwise`/`ReplyShape`, `layer2_of_obligations`,
  `ac_of_reply_support`, `signBodyOf_le_of_attempt_le`,
  `attemptPointwise_le`, `pos_mul_iff`, `pow_mono_exp`, `attemptFactor`
  family, `e2_attemptFactor_lt`), `VerifyBind.HashTo` (`UniformChallenge`),
  `Run2.LawBinding` (`samplerLaw`, `LocalJointCertificate`) and the pinned
  `FT1536.PublicSimulation` / `FT1536.MathSign` / `FT1536.Geometry` /
  `FT1536.Divergence` layers.

## 5. Attempts log

- **Attempt 1** (exit 0): full build on the first run (defs-first order;
  the two defeq bridges `honestReply`/`signBody` and `replyAt`/`condOf`
  resolved through plain `exact`/term elaboration — `noncomputable def`
  delta unfolding is enough, no `show` shims needed). The guarded runner
  writes one fixed log path, so the empty log is the final run's log.
- **Audit run** (exit 0): all 26 `#print axioms` lines standard (first pass
  25 declarations, re-run after the review-added lemma).
- **Batch review** (subagent, read-only): NEEDS_FIXES — 1 major + 8 minor.
  Major: the "exact final argument list" (docstring + table) missed `k` and
  drifted from the real binder order. Minors: binder-count drift on the
  `_attemptFactor` variant; "exactly the condition" claim stronger than the
  cited lemmas (fixed by adding the true two-way
  `attempt_miss_satisfiable_iff_onone`); "O-NONE is the only input of
  `hac_of_support`" reworded (it is `hac_of_support`'s only EXTRA input over
  `hac_of_layer2`); `§obligations` mis-citation (the byte bridge is not a
  Lean premise and `UniformChallenge` is Layer 1) plus the swallowed `hk`;
  wrong B4_LAYER2 section ref for the additive-error caveat; audit split
  miscounted (`replyAt_eq` is a theorem, not a def); "no hypothesis at all"
  on the fiberless lemma; "needs only ..." on the leaner variant. ALL
  applied to both files; module rebuilt 0/0 and re-audited 26/26.

## 6. Lessons (for the batch next to B4/1's and B4/2's lists)

- Defeq bridges between `noncomputable def` wrappers (`honestReply` →
  `signBody`, `replyAt` → `condOf`, `HacShape` → the raw `hac` Pi type) need
  no lemmas for CONSUMPTION — `intro`/`exact` unfold them at default
  transparency. Keep `rfl`-equation lemmas (`replyAt_eq`,
  `honestReply_eq_signBodyOf`) for REWRITING in reader-facing positions.
- `mul_le_mul h₁ h₂ (0 ≤ c) (0 ≤ b) : a * c ≤ b * d` (4-arg shape);
  `1 * 1` normalizes to `1` under `simpa`. `pow_mono_exp hk (i := 0) (j := 16)`
  + `simpa` gives `1 ≤ k ^ 16` cleanly.
- A named-premise `def ... : Prop` (like `UniformChallengeAt`) is worth the
  extra layer: the assembled theorem's binder list becomes self-documenting
  scope, and the underlying `∀`-form still unifies by delta when passing the
  premise to the older constructors.
- Recording a hypothesis as a named premise (O-NONE) and separately proving
  its EXACTNESS (`signBody_none_pos_of_attempt_miss`) is stronger than either
  choice alone: the scope table names the owner lane and the kernel pins
  down what breaks without it.

## 7. Polish handoff note (skrót dla właściciela)

Dokładna lista argumentów `localJointCertificate_of_named_premises` (patrz
tabela w Part 3, kolejność binderów) = pozostały zakres B4: obiekty `S`,
`k = attemptFactor` (z `1 ≤ k` dowiedzionym), `jatt`, oraz cztery nazwane
przesłanki: `UniformChallenge` (założenie ROM), `ReplyShape` (wiązanie
źródłowe B1/source3), `AttemptPointwise` przy `attemptFactor` (okno B4/3a)
i O-NONE (geometria fibera, strona źródłowa). Przy nich certyfikat ma
`e = e2 attemptFactor < 2^-32`. Otwarte poza listą:
most bajtowy i zastrzeżenie o błędach addytywnych (`Adv_PRG`) — to warunki
zewnętrzne, nie argumenty tego twierdzenia.
