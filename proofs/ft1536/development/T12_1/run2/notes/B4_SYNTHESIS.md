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

## 2026-10-02 update: B4/3a + B4/3b closed — the remaining scope is EXACTLY four named premises

**`layer2_e2_actual`: `e2 < 2^-32` is now ACTUAL** (from `ReplyShape` + the
two named analytic bounds), not conditional. `attemptFactor` computed
kernel-side exactly (`chainHi`/`chainLo`, `norm_num` in the CenteringClosure
style), `attemptFactor < 1 + 2^-38`, propagated `k^32 - 1`.

`HacGlue.localJointCertificate_of_named_premises` delivers
`LocalJointCertificate S ((1+d1)*(1+d2)-1)` with `d1 = 0`
(`UniformChallengeAt`), `d2 = e2`. Its EXACT argument list IS the remaining
project scope for rung B4:

1. `huc : UniformChallengeAt S` — **already delivered** (B3/X);
2. `hshape : ReplyShapeAt S jatt` — source binding of the attempt law
   (`SIGN_MAX_ATTEMPTS=16`, emission `:3412-3418`) — B1/source3;
3. `hattempt : AttemptPointwiseAt jatt k` — the analytic core, reduced to
   TWO named bounds (B4/3a): `AttemptShape` (S.code/do_sign binding) and
   `AttemptWeights` (the 4-stage sandwich transport, incl. the
   tower/fiber-tilt sandwich over the whole tail region); the normalizer
   ratio is absorbed by the two-sided sandwich (kernel);
4. `hone : ∀ h, ONone (syndrome h)` — fiber geometry of `Relation.A` for
   the real key (source side); pinned by
   `attempt_miss_satisfiable_iff_onone` (miss side fits the trial law iff
   O-NONE holds at achievable challenges).

Not theorem arguments (open, recorded): the byte bridge (chi2 = top risk if
real mass leaves the emit image) and the additive-error caveat (Adv_PRG
needs a mass floor `mu <= (trial A c).mass (some z)` to enter the
multiplicative shape; it stays an additive term of the outer bound).

Known shape trap (recorded, not assumed): if the real `to_sign` attempt is
conditioned on acceptance inside one attempt, the some-side picks up a
`1/(1-rejB)` factor — `rejB = 2^-24` then moves inside the multiplicative
accounting.

Owner decision 2026-10-02: **the work stays public** (traffic note: 30.09
scraper wave, 2008 clones / 65 unique cloners, 3 unique human visitors —
recorded as-is; no secrets in the bytes; Kerckhoffs posture kept).

Next: B5 assembly skeleton may consume
`localJointCertificate_of_named_premises` with exactly these four
arguments; B1/source3 and one geometry window supply premises 2-4.

## 2026-10-02 (late): O-NONE DISCHARGED UNCONDITIONALLY — two premises left

The O-NONE window proved `hone : ∀ h, HacGlue.ONone (syndrome h)` with NO
named assumption — stronger than the prompt asked for: `Relation.A`
depends only on coordinate residues mod 18433, so every fiber is a coset
of the `18433·Z` residue lattice; `liftPair` shifts a witness to a
coordinate >= 47103 where `block >= 2*47103^2 = 4437385218 > B =
2093922385` (2x margin, inside the finite box); a nonempty fiber suffices.
No NTRU equations needed — B1 supplies NOTHING for this premise.

The window also assembled `localJointCertificate_of_attemptFactor`: the B4
certificate with O-NONE discharged — **e < 2^-32, THREE named arguments
instead of four**. The remaining B4 scope is exactly:

1. `hshape : ReplyShapeAt S jatt` — source binding of the attempt law
   (B1/source3; B1.01 CLOSED with receipts — NTT word algebra over
   `ZMod 2147355649` with the Montgomery scale in the type and PRIMES3
   pinned to source bytes; B1.02 prepared analytically in
   `KEYGEN_RESIDUE_CHECKPOINT.md` section 2: region map `3046..91`, the
   exact missing grammar list, the five consumers to patch);
2. `hattempt : AttemptPointwiseAt jatt k` — the two named analytic bounds
   (`AttemptShape`, `AttemptWeights`).

Open non-arguments unchanged: the byte bridge and the additive-error mass
floor. B5 skeleton may now target `localJointCertificate_of_attemptFactor`
directly (see `run2/notes/PROMPT_B5_ASSEMBLY.md`).

## 2026-10-02 (night): B5 SKELETON DONE — the closing list (Assembly.lean, commit 132098c2)

`end_to_end_assembled_theorem_statement` is PROVEN from named premises
(0/0, 20/20 standard axioms, the argument list printed in
`.build/audit/AssemblyAudit.log`): the Section-1 bound in full — B4
certificate (`e = k^32-1`, O-NONE discharged unconditionally) ->
`concrete_euf_cma_to_mt_isis` over `Reduction.build` -> carried `deltaPRG`
term. The D2-route-(b) hybrid lives at the Dist/Law level
(`tape_game_hop` family: `AdvEUF(real stream) <= AdvEUF(uniform tape) +
deltaPRG`, including the `Law.uniform.map` seam of `Games.Sampler.code`).
Exports: the literal `+AdvPRG` variant, the `attemptFactor` variant
(`e < 2^-32`), `exists_assembled_reducer` (the reducer IS
`Reduction.build beta A S`), `assembled_hardness_substitution`. A1 pinned
in model scope (`a1_no_retry_interface`). Recorded deviation: `AdvPRG`
realized on the tape law `tau : Law (Fin S.bits -> Bool)` (distance needs
a law object); the outer bound carries `deltaPRG`, the literal variant is
separate.

**THE CLOSING LIST (= the project's checklist):**

| Arg | Content | Owner | State |
|---|---|---|---|
| `hk` | arithmetic | kernel | PROVEN (attemptFactor) |
| `huc` | UniformChallengeAt (the ROM) | B3/X | DELIVERED |
| `hshape` | ReplyShapeAt (attempt law bound to C) | B1/source3 | in progress (B1.02 window) |
| `hattempt` | AttemptPointwiseAt (= AttemptShape + AttemptWeights) | B1 + AttemptWeights window | AttemptWeights prompt READY, unlaunched |
| `hkey` | keyIdent (emitted-key law identification) | B1.10 (`emitted_to_actual_fiber`) | type slot, content owed by B1 |
| `hprg` | AdvPRG <= deltaPRG (ChaCha20 account) | B2 | **NEW WINDOW NEEDED** (`PROMPT_B2_ADVPRG.md`) |

Non-arguments (open, recorded): the byte bridge, the additive-error mass
floor. A2 rides in `huc`; A1/A5 bite into `hkey`; A3/A4 in the byte bridge.

## 2026-10-02 (night, late): AttemptWeights DONE — the heavy core's analytics closed

`AttemptWeights.lean` (781 lines, 0/0, 51/51 standard axioms; commits
2eec3920/0190943c). `attemptFactor = machineMargin * towerMargin *
wrapFactor * boxFactor` (exact, `rfl`) with ALL numeric margins proven
kernel-side (tower < 1+2^-43, machine < 1+2^-42, wrap < 1+1/(2^39-1), box
< 1+1e-30; composition `attemptFactor_comp_lt` from the stage table).

**Both attempt shapes are now kernelized** (no shape assumed):
- unconditioned (sample-then-check): `rejB = 2^-24` OUTSIDE the factor,
  `layer2_of_stageChain` -> `second < 1+2^-32`;
- acceptance-conditioned: delta EXACTLY `1/(1-rejB)` inside
  (`conditioned_ratio_le`), `conditionedFactor < 1+2^-23`, `e2 < 2^-17`
  (`layer2_e2_conditioned`). Truncated weights have zero tail mass — the
  tail sandwich cannot pass through them (the same counterexample).

**The whole-tail sandwich is proven NECESSARY** (kernel counter-theorems
`bulkOnly_tail_uncontrolled` / `bulkOnly_normalized_tail_uncontrolled`,
witnesses `zeroPair`/`liftPair`): any future "tail mass is negligible"
shortcut is inadmissible in this proof shape. The global tail theorem
(`regionMass`, `RegionSandwich`, `sandwich_regionMass`,
`sandwich_tailMass`, `tail_ratio_le`) transfers the sandwiches to EVERY
region's masses with identical margins.

**`hattempt`'s remaining content is now purely realization (no analytics
left):** the definitions of the realized weights `target/mach/wrapS/w` and
their four POINTWISE stage sandwiches — which need (i) the `do_sign` core
binding (B1/source3) and (ii) the T5/REFINE material RE-STATED POINTWISE
(their current bounds are TOTAL masses, not pointwise — the exact missing
lemma type is recorded on both sides). Once B1 delivers the transport
`do_sign -> AttemptShape` + `TowerWhole` realized on target (per point,
with tail), the whole of B4/3 closes with no new mathematics.

## 2026-10-02 (post-compact): B2/AdvPRG DONE — hprg delivered, route (a) closed BY THEOREM

`AdvPrg.lean` (0/0, 71/71 standard axioms; commit 3870dc50). The final
assumption is ONE named predicate, `ChaCha20PRFBound` — the standard
distinguishing game for the ChaCha20 stream of the pinned `Extra/c/frng.c`
(SHAKE-256 seeding <- /dev/urandom + user seed) vs the uniform tape, at
total consumption `n = beta.qs * S.bits` bits, budget `deltaPRG`. The SHAPE
is proven both ways: `ChaCha20PRFBound tau delta <-> AdvPRG tau <= delta`
(exactly the same delta) — `hprg` plugs into the B5 consumer
(`assembled_hardness_substitution_chacha`) with zero slack. Consumption is
kernel-counted: `S.bits` per sampler call (rfl), <= beta.qs calls per
budget game (structural Program tokens); generator state 56 B = 2^448
states, block 64 B, refill 4096 B = 64 blocks; nonce 320 bits/query comes
from SHAKE (A2 boundary, outside the ChaCha20 claim).

**Route (a) is now closed by theorem** (not just by the D2 decision): the
stream is a function of the 56-byte seed => `1 - 2^448/2^n <= AdvPRG` —
any delta satisfying the assumption on the real tape is >= `1-2^448/2^n`
(~1 at real lengths). The statistical reading of deltaPRG is ~1 and
vacuous; only the COMPUTATIONAL `Adv_PRG(ChaCha20)` at the stated
consumption is meaningful (route (b)). A future ideal-PRNG theorem would
delete `deltaPRG` from the assembly entirely.

**C-side audit finding (recorded, not smoothed):** `falcon_prng_get_bytes`
(`frng.c:355`) copies from the buffer START, unlike the indexed
`get_u8`/`get_u64`. In the pinned profile nothing calls it (the sampler
draws via get_u64/get_u8) — a dead pipe TODAY, but a live wire if any
future profile starts using it. Pinned bytes must not change; this is a
finding for the FT-family C candidate line.

## 2026-10-02 (evening): T5-pointwise DONE — hattempt's math FULLY closed (commit 95bac2c0)

The collision's happy ending: `T5Pointwise.lean` (1003 lines = window B's
base `b2b36cad` + window A's fixes/additions; 0/0, 56/56 standard
axioms). ALL FOUR stage transports proven pointwise
(TowerRowRoad->TowerWhole, MachineEvalRoad->MachineStage,
WrapCoordRoad->WrapStage, BoxRetentionRoad->BoxStage) + the composition
`layer2_of_stageRoad` (attemptFactor < 1+2^-38, second < 1+2^-32). The
rows->points road closed arithmetically: recorded margins = exactly the
2-row product (`tower_margin_row2`); 3072 rows force 2^-58-class per-row
budgets (`road_fit_3072_rows`); full rowBudget per row BUSTS the whole
budget (`rowwise_fullBudget_busts`).

**Insufficiency is now THEOREM-level, not warning-level:**
- `massSandwich_not_pointwise` (at the exact margins of ALL four stages):
  total-mass bounds NEVER give pointwise control;
- `additiveError_no_machineStage`: additive error without a floor cannot
  restate multiplicatively — BUT with a floor (`machineFloor` from
  `t5_leaf_floor_gt`, window A's addition) the bridge
  `machineStage_of_absErr_floor` closes the additive route CONDITIONALLY.

**`hattempt` now reduces to PURE REALIZATION** (no new mathematics):
per-row/per-op/per-coordinate data on the real `do_sign` weights
(B1/source3), delivered as `PointwiseStageRoad` ->
`attemptWeights_of_stageRoad` -> `layer2_of_stageRoad`. Note for B1: the
3072-row variant needs the 2^-58-class row bound. After that: merge with
`layer2_of_stageChain` in Assembly and `end_to_end` closes.

Toolchain lessons added: `prod x : a, body` binds `body` with LIMITED
binding (`prod i, 1 - b i` silently parses outside the product - ALWAYS
parenthesize); Rat.cast trap extension: nlinarith/simpa choke on heavy
local hypotheses - prove small facts in clean context first.

## 2026-10-06: B1.02 ACCEPTANCE — the complete source-bound execution model

The whole of B1.02 (2.1.1 + 2.1.2) is closed (commits aa86ba27/d81c257c/
ccf94077 pushed in 69092f01..ccf94077; 56a7ee7b/01eb7fae local): a
complete source-bound execution model of the `modp_NTT3_ext` body with
derived counters and pointer positions for ALL THREE loop families
(first/triple/intermediate) and the butterfly call observations extracted
as CONCLUSIONS from the parsed bodies (call-premise leakage removed;
Load32/Store32 witnesses at current positions). The intermediate bounds
(`i <= 7` from the executed `mGuard` `t > 3`, hence `m <= 2^8`,
`t <= 768`, `v1 <= 2^18`) are derived from ROUND COUNTS with the
`t*m=n` ban honored (that identity lives in B1.04 and only there) — one
premise `2^18*s < 2^64` discharges both product non-overflows. This is
the boundary where the source binding ends and the mathematics begins.
Next: B1.03 (modp_mkgm3 root table, order 9216/4608 as a proof
obligation), then B1.04 (values/ranges - t*m=n lives there), B1.07
(stride=1 via the wrapper frame), B1.10 (`emitted_to_actual_fiber` =
 `hkey`).

## 2026-10-06 (evening): B2/B5 package CHANGES_REQUIRED (E1-E5) - the seam's true state

Independent review (own replay 70/70, kernel counterexamples
`membership_without_cost`, `export_without_key_ident`; pins REVIEW
a638b45d, OUTPUTS 4a9d8197) verdict: CHANGES_REQUIRED. Traps F/G
CLEAN: no TV smuggling, the winning test covers the experiment's
remaining randomness, the simulator/MT-game identification is correct,
the Phi inversion is sharp and exact. Three real gaps + two descriptive:
E1 (significant): `P_tau` is the stream-driven PUBLIC SIMULATION - the
direct bound is the main form FOR THAT experiment; the honest/real-Sign
-> P_tau bridge with the correct second-moment comparison is MISSING and
must not be claimed closed (`b <= phi D b` is not that comparison; D is
only a redundant weakening for P_tau). E2 (significant): `CompWinCert`
is dangling - membership must feed the hop and the cost line must be in
the export's type (q tied to `AdvPrg.chachaBlocksTotal beta S`). E3
(significant): `hkey` is fake-consumed (`intro _hkey`; `True.intro`
reproduces the export) - bind the key-law identification dependently.
E4/E5 (descriptive): total piecewise inverse form / negative-radican
convention, domination for `max 0 (eps-deltaPRG)`; comments reference
nonexistent `CompTest.ofEvent` etc.; audit bookkeeping 52+4.

Consequence for the public claim: the computational seam is REAL but
scoped to P_tau; the honest-Sign bridge is now the explicitly recorded
open interface (overlaps the B1 do_sign/ReplyShape realization and the
B4 second-moment consumption). Fix window: E1-E5 on the corrected work
contract (f6561725); one window, statement surgery + wiring, no new
math campaign.

## 2026-10-06 (night): third independent review - convergence confirmed + premium tools

Third review (snapshot to 844c0d07, i.e. PRE-dating the 6ff3c838 fix)
CONFIRMS E1-E3 as recorded and validates the synthesis as the most
reliable status. Three tools added to the project's kit:
1. **The k=1 scope test** (the standard meaning-test for the export):
   `end_to_end_stream_theorem` accepts any `1 <= k`, so `k = 1` (D = 0)
   needs no divergence proof - proof the export does NOT consume the
   real-Sign statistical certificate. Correct for P_tau; the fixed
   export must either consume the comparison or say D is a redundant
   weakening for P_tau (E1 criterion). Use this test in every future
   assembly review.
2. **The four-arrow target assembly map** (official closure shape):
   real Sign on real randomness -(computational hybrid)-> same Sign on
   fair randomness -(law bindings + certificate)-> public simulation
   -(extraction)-> MT-ISIS. Arrows 3-4 EXIST (streamGame_uniform +
   concrete_lazy_game_binding + Reduction.build); arrows 1-2 = the
   honest-Sign bridge = the B1 realization lane (do_sign/ReplyShape/
   AttemptShape/keyIdent + LocalJointCertificate S e consumption via
   `stopped_euf_to_concrete_mt`). CompPRG's tape arrow must NEVER be
   identified with the generator change in real signing.
3. **The piecewise publication form of the inverse**: psi_D(a) = 0 for
   a <= D/(1+D), else a - sqrt(D*a*(1-a)) (E4 enhancement - the
   piecewise form does not suggest tiny positive advantages give
   positive guarantees).

Also confirmed: P_tau is the stream-driven PUBLIC SIMULATION (signSimAt:
nonce+ROM+stop-on-collision+S.code returning challenge AND response ->
programmedReply; streamCont draws only the public key from muH - no
secret key in the signing execution). Minor bookkeeping: the older
WORK_STATE.md header still lists already-fixed items (stale vs
checkpoint).

## Consumption map

    B3/X  UniformChallenge + HashToSpec        -> Layer 1 (d1 = 0)
    B4/1  decomposition + joint_bounds ctor    -> the assembly mechanism
    B4/2  support/AC + layer2_of_obligations   -> Layer 2 skeleton (e2 = k^32-1)
    S3    CenteringClosure delta + budgets     -> the wrap-error inputs
    T5    machine/tower sandwiches             -> the mass-margin inputs
    B1    (source3, in progress)               -> ReplyShape + S.code binding
    B5    assembly                             -> the final theorem
