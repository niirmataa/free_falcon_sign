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

## 2026-10-07: B2/B5 package CLOSED - PASS_SCOPED, independent, zero changes

The computational seam is formally accepted: INDEPENDENT_REVIEWER
(fresh context, independent of author - different model than the
6ff3c838/REVIEW_002 author), verdict **PASS_SCOPED with NO
CHANGES_REQUIRED** across A-G + E1-E5 + F/G non-regression. Evidence
base (own hands): 68/68 rebuilds exit 0, audit 79/79 1:1 with own
inventory (zero phantoms, standard-axiom subsets only), zero markers in
66 sources raw AND comment-stripped, 21 own kernel checks
(generalized_inverse_iff both ways, psiD = phiInv, k_one_D_zero,
key_binding_true_iff, membership_without_cost_fails,
class_restriction_is_load_bearing, sampler_is_not_honest_in_general...),
7/7 material pins reproduced. Key resolutions:
- B: D does NOT get lost - (1+e)^qs-1 enters in
  `concrete_euf_cma_to_mt_isis` (B4 certificate -> second moment); the
  public chain deliberately carries no D;
- C: the companion bound is the CORRECT main form for the public game
  (no second-moment loss lives there); the phi form is kernel-weaker and
  consistent (max 0 clipping necessary - own counterexample);
- F: hop direct from CompPRGBound + bind_draw_event (proven Fubini);
  zero TV traces in the closure;
- G: signSimAt != signHonest/freshHonest (kernel); the certificate
  factor lands exactly in D: Comparison (1+e) -> (1+e)^qs -> phi.
Controls worth reusing: empty class = no bound at AdvPRG = 1/2 (class is
load-bearing), averaged_test_half (1/2-test), the k=1/D=0 weakening
probe. 79-vs-64 = API change + log-set choice, not an error.

CLOSING LIST NOW: everything except the four-arrow map's arrows 1-2 -
the honest-Sign bridge = the B1 realization lane (do_sign/ReplyShape/
AttemptShape/keyIdent/B1.10) + final assembly. **Owner decision
2026-10-07: the formal stages-import + tag happens ONCE, at T12.1
acceptance** (single archive.py pass at the end - not per-package stages
mid-campaign); the B2/B5 acceptance is recorded here and in REVIEW_003.

## 2026-10-07: B1.03 ACCEPTANCE - the complete source table-law layer

All of B1.03's stages closed (commits through f27008de; BATCH_017 pin
50f35519... exact): syntax frontend + non-mutual strata (trap 33),
modp_R value law (2^31 mod p), generator order 9216/4608 kernel-VERIFIED,
REV10 exactness (rawTable = some (bitrev10 0..1023) - all 1024 entries),
div_source_bound + KeygenMkgm3Program.source_bound (three REAL parser
bugs found en route: dead revStoreTail, false call on ((size_t)1<<k)-1,
duplicated outer xor in divSelect), modp_R2 law (2^62 mod p, R^2 scale,
p0i from the initializer execution), and the row laws (all 1024 gm words
with ranges, exponents, orders, Montgomery scale; igm=ft; gm behavior +
source material; sizes + memory non-overlap). Mutation-tested: 6/6
injected mutations detected in BOTH normal and UBSan builds (the row-law
checker is not vacuous). Traps 32-48 recorded.

NEXT: B1.04 (values/ranges/polynomial invariants + butterfly cells -
`t*m=n` lives THERE and only there) = the last heavy rung before
realization and final assembly. Status remains NOT_REVIEWED (stage
acceptance is not an independent review - reviews run per the owner's
schedule).

## 2026-10-07 (later): B1.04 ACCEPTANCE - the full NTT transformation identified

The last heavy rung is CLOSED (commits through 2868c49e; BATCH_019 pin
983a481a10293c01 exact; 8 non-empty logs verified = preserved FAILED
ATTEMPTS' error logs, disclosed provenance; accepted jobs 0/0): u1/m
loops + all 8 rounds + 512 triple iterations; **the complete source NTT
execution is identified with evaluations of the input Vec polynomial -
all 1536 results canonical** (`KeygenNttExecution`, `KeygenNttTransform`
+ twiddle tree/cert, round-polynomial); composed with table generation
and input conversion. Audit 131 exports, 402 consistent inputs.
`t*m=n` discharged HERE, as designed. Source-NTT <-> polynomial-math
binding is COMPLETE.

NEXT: B1.05 (solver success -> the exact integral NTRU equation; the
full solver proof remains open), then B1.07 (stride=1 via the wrapper
frame), B1.10 (emitted_to_actual_fiber = hkey), B1.11, and the do_sign
realization (hshape + PointwiseStageRoad) + final assembly (arrows 1-2).

## 2026-10-08: state review confirms the trajectory + the do-not-reopen map

Independent state review at 8ca34465 (63 commits since its previous
snapshot) confirms: E2/E3 FIXED in code (cost is part of the export
contract - `CompWinCert` consumed with `costLine` conjunct and
`chachaBlocksTotal` binding; `KeyLawBinding.identify` makes `True`
insufficient - two concrete laws must be equated), B1.03 fully closed
(`KeygenMkgm3.source_contract` for ALL 1024 gm words + the
aliasing-aware `source_then_overwrite` composition), B1.04 = the full
transform identified (`source_transform` -> evaluations for all 1536
cells from the parsed forwardBody; `generated_converted_transform`
composes generation+conversion - the project may NO LONGER be described
as "local NTT ops without whole-transform polynomial binding"), and
B1.05's chain: `checked_pointwise` -> `residual_zero` ->
`exact_of_images` gives the EXACT equation **fG - gF = 18433** in the
coefficient quotient with |f|,|g| <= 1, |F|,|G| <= 2047 (Bound v 1 now
CONCLUDED from sampler execution via `KeygenSamplerBounds.source_material`,
and `generated_converted_checked` holds the equation AND the
`Represents` of the SAME vectors in final memory). Paper sec_04
confirmed to separate proven/target correctly.

**DO-NOT-REOPEN MAP** (reviewer's correction of stale gaps): E2/E3,
B1.03 table certificate (REV10/modp_R2/row laws), B1.04 full transform,
completed CRT/zint_bezout local bindings (operational/memory scope -
NOT arithmetic Bezout/GCD theorems; non-vacuous chunk audits
`map ... = some`). Remaining = exactly the closing list: full call
chain + material transport (B1.05c), key-law identification instance
(B1.10), honest-Sign realization + final assembly (arrows 1-2).

## 2026-10-09: B1.05 ACCEPTANCE - the complete source -> NTRU-equation chain

B1.05 is CLOSED (BATCH_020..032, 12 batches; final commit 9b927367;
5019 pins PASS; 4/4 mutations detected per round). The chain is
complete and kernel-checked: table generation + conversion + the full
NTT transform (B1.04) + solver execution (deepest -> intermediate ->
depth0 -> root -> caller) + gate transport (resultants -> raw/GS ->
public) + Entry from caller initialization + `RootCaller.Legal` on the
same prefix -> **the exact equation fG - gF = 18433 with bounds
1/1/2047/2047 on PRESERVED tables**. The `f/g <= 1` bound is CONCLUDED
from sampler execution (not assumed). Scope honesty: this is NOT a
full KeyGen theorem and NOT a security proof - it is the complete
composition gap removal for the solver region.

NEXT: B1.06 (not started), then B1.07 (stride=1 via the wrapper frame),
B1.10/B1.11 (emitted_to_actual_fiber = hkey material), the do_sign
realization (hshape + PointwiseStageRoad) and final assembly
(four-arrow map, arrows 1-2).

## 2026-10-09: B1.05 deep review - premises actually DERIVED, composition gap truly gone

Structural review at 98a4abf6 (33 commits) verifies the B1.05 closure
at the type level: `KeygenCallerSuccess.exact_integer_ntru` carries
ONLY `Initial ctx before` (input MEMORY: pointer bindings, M0 profile,
PRIMES3/REV10 objects, scratch legality, disjointness - NO vector
coefficients/bounds/equations) + `Exec ctx before out` + `normal` flow
-> exists f g F G with Bounds 1/1/2047/2047, `multiply f G - multiply g
F = constantCoeffs (18433)` and `Represents` of the same four in final
memory. The reviewer's rename-check passed: `RootCaller.Legal` is
carried through the SAME executed prefix (`root_legal` + `material` off
one `Exec`); the old `Validation` record is now CONSTRUCTED from
execution (`KeygenRootValidation.validation` with `start.heap =
before.heap`). Chain fully realized (`.deepest/.intermediate/.depth0 =>
named Call` with accept/reject gates and `depth--` semantics). Gap
noted and closed: C `if (!solve_NTRU(...)) continue;` vs the lemma's
`return 1` premise - `nonzero_one` derives `v = .int32 1` from the
actual nonzero gate result (values proven 0 or 1 first). Gate transport
covers reject paths; local scope closes BEFORE the public call; static
tables preserved via byte-block properties.

**DO-NOT-REPEAT MAP extended**: the old diagnosis "missing solver chain
/ sample-to-equation transport" is CLOSED within B1.05's declared
scope. Scope note preserved: the theorem covers completed execution of
the indicated fragments with active root under legal initial memory -
NOT all of `falcon_keygen_make`, not termination, not acceptance
probability, not emitted-key distribution. Remaining per BATCH_032:
B1.06 (source public equations + inversion for the same f/g/h),
B1.07 (full surrounding call + loop chronology: auto allocations, RNG
readiness, retry counter/limit, full-run composition), then codecs/emitted
bytes/certificate + `emitted_to_actual_fiber` + do_sign realization +
final computational assembly.

## 2026-10-10: state review at 0e38ca35 (90 commits) + EDITORIAL MAP for ePrint

Proof-side confirmations: B1.06 scope CLOSED (`KeygenPublicAccepted.
source_same_material`: h*f_bar = g_bar, f_inv*f_bar = 1 in R_q,
canonical rep of the REAL output h, preserved f/g input bytes; fInv is
a mathematical invertibility witness, NOT an assumed table; premises =
profile contract + legal memory + representation + input bounds +
disjointness + successful public helper; invertibility/inv-NTT
correctness/canonicity/equations all DERIVED. BATCH_046 normalization:
mq_div_18433(Rt,(uint32_t)n) scaled for n=1536, reconstruction factor
canceled by proof of meaning - no "forward and inverse are inverse"
assumption). B1.07 RNG readiness full (KeygenMakeReadySampling.
source_same_material: counter=1, bound-1 vectors from original input
contract + same execution; set_seed/rng_ready/SHAKE/tmps/Linux syscall
observations incl. failures = source control+memory closure, NOT
entropy claims). Latest: KeygenMakeProgram.lean binds full caller
syntax (source_bound, actual_attempt_tail, actual_four_segment_loop,
post_acceptance_capacity_tests, final_return_source; order
computePublic -> solve -> certificate -> break; attempt success NOT
identified with successful encoded key return).

**EDITORIAL MAP (owner-chosen reviewer) - the paper rule for ePrint:**
- ONE polished article (keep title/authorship/mission/ePrint venue);
  v0.3 (28pp, 117 pins, 21 theorem groups) is THE base - no new
  article, no competing version. "Professional like Falcon" = the
  ORGANIZATION of the argument (falcon-sign.info/falcon.pdf as the
  organizational reference only).
- **Narrative follows the ARGUMENT, not batch numbers**: source
  execution -> proper material/law -> security experiment -> reduction.
  BATCH ids/Lean names/hashes live in a theorem-to-export compliance
  table + appendices + reproduction package. In-body: "B1.06" becomes
  a normal mathematical proposition with premises; appendix points to
  `KeygenPublicAccepted.source_same_material`.
- **Proofs readable without running Lean**: expand second-moment
  direction, adaptive-adversary induction, collision loss, extraction
  to MT-ISIS.
- Four final-version items: (A) algorithms at ONE level - real
  byte-level algorithms vs proof-helper laws + theorems joining them;
  retry limit/emission failure/buffer-capacity error/re-sampling belong
  to the EXPERIMENT, not pseudocode footnotes. (B) abstract exponent
  follows from ACTUAL AttemptShape: e2(k)=k^32-1<2^-32 (unconditional)
  vs k_cond=k/(1-2^-24), e2<2^-17 (conditioned) - the CODE realization
  chooses the variant; editorial choice must NOT precede the proof
  choice; e<2^-32 is NOT a "32-bit security level" (needs q_s,
  (1+e)^q_s-1, remaining losses). (C) main theorem = FINAL EXPORT
  after closing: rewrite actual final type with assumptions/costs/
  terms; don't lock narrative to the current target formula; classical
  proof stays main result - NO QROM stretching. (D) security section +
  Related Work need scientific editing: S06 stays
  UNCERTIFIED/CHANGES_REQUIRED even after the reduction closes; the
  table must not visually promise more than its caption; Related Work
  compares actual GUARANTEE LEVELS (games vs code vs compiler vs
  assumption) incl. EasyCrypt, Jasmin, HACL* alongside GPV/Falcon.
- **Edit main text NOW** (motivation, profile spec, closed-reduction
  description, B1.05/B1.06 results, literature, appendix structure);
  leave abstract + main theorem + guarantees summary for LAST (after
  final composition).
- **Reproduction package is a deliverable**: receipts in ignored
  work/ or .build/ are NOT public access - hash != availability; the
  publication archive needs dependencies + replay commands, not just a
  manifest.
- Reviewer's editorial plan `PLAN_EPRINT_FT1536.md` exists in their
  sandbox (not in repo) - worth preserving into paper/notes/ when the
  owner hands it over.

## 2026-10-10: OWNER DECISION - paper strategy: our work forward, A1 as end-stage donor

Reviewer "Recent" produced an alternative editorial package
`Free_FT_A1` (Pobrane/Free_FT_A1_LaTeX/, pinned to Git 0e38ca35):
same signed title/authorship, tight honest abstract, theorem-centric
structure with an assembly chapter, Appendix B obstructions as
propositions with proofs, Appendix C reproduction + SOURCE_MAP +
SOURCE_LOCATIONS + verification receipts. **Owner decision: keep our
v0.3-redaction as the living paper and continue the proof lane; merge
A1's strengths at the FINAL composition** (abstract style, obstructions
appendix, reproduction appendix, SOURCE_MAP approach) in one end-stage
move. Rationale: proof is the bottleneck; final composition waits for
the final export anyway; one living paper + one frozen donor = no
two-paper drift. Mechanical check of A1 (C01-C22 mapping vs exports,
bibliography honesty, markers) still due BEFORE any merge.

## 2026-10-11: CROSS-LANE CATCH - VirtualLegal impossibility (vacuous Invocation.encoded)

The QROM lane (Codex/Astra) found a concrete defect in the B1.07
invocation result: `VirtualLegal` requires ALL Nat identifiers to have
distinct addresses < 2^64 - impossible (kernel-proven separately).
Consequence: the `Invocation.encoded` branch is VACUOUS (premise can
never hold) - dependent theorems about the encoding path are currently
vacuously true, i.e. ungrounded. The instruction skeleton remains
sound; the defect is in map legality. Fix required BEFORE any Q-BIND
use and before further mainline consumption: restrict map legality to
the actual finite live memory blocks, re-validate ALL dependent proofs
(incl. earlier batches consuming VirtualLegal/encoded), new trap entry,
re-pin. The QROM worker pinned the exact pin+obstacle in S05 and did
not touch mainline sources (correct cross-lane etiquette).

## 2026-10-11: PREMISE AUDIT (premise-audit-001) - 4 confirmed obstructions, DO-NOT-CONSUME list

REPORT_ONLY / CONFIRMED_VACUITY / OPEN_SUSPECTS. Frozen scope
ef354c48: 761 Source3 + 148 run2 Lean files. PREMISE_MATRIX: 1011
SUSPECT (open obligations, NOT bugs), 9 TRIVIAL, 2 IMPOSSIBLE, 9 OK,
1 VACUOUS. `all_impossible_premises_found=false` - completeness NOT
claimed. W in work/FT1536_PREMISE_AUDIT_20261011_001.

**F01** (independent re-derivation of the cross-lane find): global
VirtualLegal impossible (Nat->Fin(2^64) injection). PLUS new stronger
diagnosis: `invocation_only_failure` - EVERY Invocation object returns
0 in this snapshot; `no_successful_invocation` kills source+success of
invocation_gate/invocation_certificate. `capped` branch NOT excluded -
do not call Invocation empty.

**F02**: `dimensions : (s:State) -> Dimensions s` impossible
(empty-locals state -> none = some). LOCAL Dimensions fine (witness
exists). Error is the all-states quantifier.

**F03 (NEW, survives F01/F02 fixes!)**: global LegalWorkspace
(`(s:State) -> LegalWorkspace s ctx`) EXCLUDES every real CertBind:
`(forall s, LegalWorkspace s ctx) <-> (forall s args, not CertBind)`;
`attempt_spine_premises_impossible` derives False from the ACTUAL
attempt_spine export premises. Scope precision: argument-set conflict,
not whole-family IMPOSSIBLE; local uses (accepted_certificate,
spine_witness, attempt_witness, cert_package_of_call) not covered.

**F04 (HEAVIEST - interface redesign)**: UniformChallengeAt is
IMPOSSIBLE for the finite fair-bit Sampler (uniform-preserving map
2^bits -> 18433^1536 needs 18433 | 2^bits; kernel-rejected). NO current
Sampler realizes it. **DO-NOT-CONSUME (12 exports)**: 4x
HacGlue.localJointCertificate_of_* (huc), ONoneGeometry.
localJointCertificate_of_attemptFactor, 5 Assembly variants, 2 AdvPrg
final variants (huc). The old B4_SYNTHESIS claim "UniformChallengeAt
delivered" is NOT consumable for this Sampler type. Abstract ROM NOT
refuted; its exact realization via finite fair bits is. The corrected
AssemblyComp.advMT_ge_of_public_sim_stream_win is NOT covered (no huc).

F05: TowerWhole + positive global floor conditional conflict (don't
bridge positive FPR scalar to lower bound of all weights). F06:
ChaCha20PRFBound small-delta impossible on long tape (statistical vs
computational distinction stands). TRIVIAL findings documented
(CompPRGBound empty-class gate behaves correctly etc.).

Proposed repairs (NOT applied by audit): F01 finite live-block legality
+ witness (the in-tree fix needs own pin + 40.1 acceptance); F02/F03
invariants moved to concrete rawState along the same real derivation,
global forall replaced by reachable-states theorem with explicit
producer; **F04 = MODEL DECISION (owner): (A) ROM challenge sampled
outside the sampler tape [matches reality: c=H(r||m) from the hash,
not from signing randomness - RECOMMENDED], (B) unbounded tape +
termination accounting, (C) approximate uniformity with non-zero
first-layer error; rewrite types + all 12 consumers either way - do
NOT replace the proof with an A2 label.**

Also preserved: 3 historically inconsistent import hashes in cache
(excluded, documented, untouched), full failed-attempt history, fresh
replay of all probe modules. Audit found what clean builds hide.

## 2026-10-11: OWNER DECISION - F04 repair = variant A (ROM challenge outside the sampler tape)

The challenge c is sampled from the ROM hash outside the signing
sampler's fair-bit tape (matches the real code: c = H(r||m) from the
hash, not from signing randomness; the sampler draws only noise).
F04 repair window must rewrite the run2 types (Sampler/LawBinding/
Games, UniformChallengeAt -> challenge-from-ROM interface) and ALL 12
consumers (4x HacGlue.localJointCertificate_of_*, ONoneGeometry.
localJointCertificate_of_attemptFactor, 5 Assembly variants, 2 AdvPrg
final variants). Costs and hprg must match variant A. Do NOT replace
proofs with A2 labels. F05 (TowerWhole/floor support) rides the same
run2 window. Rejected variants: B (unbounded tape - unphysical),
C (approximate uniformity - spreads error terms through the loss
accounting).

## 2026-10-11: F04 REPAIR, VARIANT A (run2) — IMPLEMENTED; F05 rides the same window

Implementation of the owner decision above, in this run2 window (guarded
builds in `.build/f04_rom_a_001/`, every attempt retained). The challenge
`c = H(r‖m)` is the ROM hash answer at the signed name, drawn OUTSIDE the
sampler's fair-bit tape — the sampler draws only the noise, matching the
real `to_sign`.

### Types rewritten (run2 core)

- `Run2/Games.lean` — `Sampler.code : Rq → State → Bytes → Nonce → Rq →
  (Fin bits → Bool) → Option BoxVec` (was `... → (Fin bits → Bool) →
  Rq × Option BoxVec`): the ROM challenge `c` is an INPUT of the noise map,
  the tape realizes the reply only. `Games.sample` = the joint signing
  draw: the lazy ROM answer `c` (uniform, outside the tape) then the noise
  tape. `Games.signSim` keeps its exact shape (the challenge draw lives
  inside `sample`, kernel wording preserved).
- `Run2/LawBinding.lean` — `replyLaw` (per-challenge noise reply law),
  `samplerLaw = Divergence.joint Law.uniform (replyLaw ...)` — THE
  challenge-from-ROM joint — plus `samplerLaw_mass`, `map_expect`,
  `joint_expect`, `sample_law` (all kernel-checked; the
  `LocalJointCertificate` statement is unchanged, it compares the joint
  laws).
- `JointDecomp.samplerLaw_marginal_uniform` — the challenge marginal IS
  `Law.uniform` exactly (`marginal_joint`), delivered as a THEOREM: this is
  the F04 replacement, `d1 = 0` with no slack and no premise.
- `HacGlue` — `UniformChallengeAt` REMOVED (the impossible bridge of the
  pre-audit model, premise-audit F04); replaced by the challenge-from-ROM
  interface `RomChallengeAt` with its kernel realization `romChallengeAt`
  (NOT an assumption) and the bridge `replyAt_eq_replyLaw` (`condOf` of the
  joint IS the noise reply law).

### The 12 consumers rewritten (the F04 DO-NOT-CONSUME list, all repaired)

`huc : UniformChallengeAt S` is GONE from every consumer; Layer 1 is
delivered by `romChallengeAt` / `JointDecomp.samplerLaw_marginal_uniform` —
no A2-label substitution, the uniformity is a kernel proof of the ROM
construction. New argument lists (binder order):

1. `HacGlue.localJointCertificate_of_named_premises` — (S, k, hk, jatt,
   hshape, hattempt, hone);
2. `HacGlue.localJointCertificate_of_named_premises_e` — same;
3. `HacGlue.localJointCertificate_of_pointwise_premises` — (S, k, hk, jatt,
   hshape, hattempt); its `localJointCertificate_of_uniform_challenge`
   premise is discharged by `romChallengeAt S` (a proof, not an assumption);
4. `HacGlue.localJointCertificate_of_named_premises_attemptFactor` —
   (S, jatt, hshape, hattempt, hone);
5. `ONoneGeometry.localJointCertificate_of_attemptFactor` — (S, jatt,
   hshape, hattempt) (O-NONE discharged by `hone`);
6. `Assembly.end_to_end_assembled_theorem_statement`;
7. `Assembly.end_to_end_assembled_theorem_statement_prgTerm`;
8. `Assembly.end_to_end_assembled_theorem_attemptFactor`;
9. `Assembly.exists_assembled_reducer`;
10. `Assembly.assembled_hardness_substitution`;
11. `AdvPrg.assembled_hardness_substitution_chacha`;
12. `AdvPrg.end_to_end_assembled_theorem_statement_chacha`
    — all of 6-12 lose exactly the `huc` binder.

NOT touched (outside the charge, as the audit records):
`AssemblyComp.advMT_ge_of_public_sim_stream_win` (no `huc` in its type) —
its whole closure still compiles; `JointDecomp.localJointCertificate_of_joint_bounds`
/ `_of_pointwise_bounds` keep their abstract `hmarg` shape (satisfiable,
unchanged). Frozen stages keep the pre-audit bytes; the audit's
DO-NOT-CONSUME list stays the record of what WAS broken.

### Costs and hprg per variant A

- `PublicEncoding.samplerInput` carries the ROM challenge (`field c`, 24576
  bits); `samplerOutput` is the reply only (≤ 26113 bits, was ≤ 50689);
- `SamplerMachine.inputCap` = 49476 + stateCap + 9·bytes + S.bits (the
  challenge input is charged), `SamplerMachine.cost` at the 26113 output
  cap; `SamplerCertificate` is a `Code (Option BoxVec)` (noise-only reply);
- `MeteredExecution.signAfter` charges `challengeCost` (the ROM-hash
  challenge production — outside the tape) + `drawCost S.bits` (noise tape
  only) + `sCost` (input includes `field c`); `turnBound` matches;
- `MachineExecution.run` / `MeteredExecution.run` sign branches draw the ROM
  challenge like the nonce (outside the tape), then the noise tape; both
  `run_binding`/`erasure` re-proved;
- `CompPrg`: `signSimAt`'s window drives the noise map only (challenge is a
  ROM draw outside the tape), `signSimAt_uniform` re-proved; `tapeWidth =
  qs · S.bits` and `hprg : AdvPRG tau ≤ deltaPRG` remain the NOISE-tape
  seam only — the challenge is not on the tape (exactly the variant-A
  difference versus B/C); `ChaCha20PRFBound` stays the named standard
  assumption (`hprg_of_chacha20`);
- `Assembly.samplerLawAt` = the ROM joint with the noise reply under `tau`;
  `samplerLawAt_uniform` holds by `rfl`.

### F05 (same window) — floor on the proper support / relative pointwise form

`T5Pointwise`:

- `machineStage_of_absErr_floor_support` — the floor restricted to the
  PROPER SUPPORT (`0 < target z`); zeros outside the fiber are handled
  SEPARATELY (`hzero`), never conflated with the floor;
- `machineStage_of_relErr` — the RELATIVE pointwise estimate
  (`|mach z − target z| ≤ eps · target z`): no floor at all;
- `machineStage_of_absErr_fiberFloor` — the F05 consistency pin: on the
  actual `TowerWhole` target the support-restricted floor coexists with the
  forced fiber support (the audit's CONDITIONAL conflict is dissolved, not
  papered over). The global-floor form `machineStage_of_absErr_floor` is
  KEPT as recorded history with its own scope.

### DO-NOT-CONSUME list (premise-audit F04) — status after this repair

| export | status |
|---|---|
| 4x `HacGlue.localJointCertificate_of_*` | REPAIRED (variant A) — consumable at the new signatures |
| `ONoneGeometry.localJointCertificate_of_attemptFactor` | REPAIRED — consumable at the new signature |
| 5x `Assembly.*` (statement/prngTerm/attemptFactor/exists/hardness) | REPAIRED — consumable at the new signatures |
| 2x `AdvPrg.*_chacha` | REPAIRED — consumable at the new signatures |

The OLD signatures (with `huc : UniformChallengeAt S`) remain
NON-consumable. Nothing here asserts any A2 label; Layer 1 is a kernel
theorem of the ROM construction.

Pre-existing, untouched, outside every closure (recorded, not fixed here):
`Run2/rawBadEnclosure.lean`, `Run2/Scratch.lean`, `Probe.lean` — historical
scratch sources of commit `3396e8e0`, imported by nothing, already broken
before this window (Lean-3 `hypothesis` syntax / stale `#check` names); and
`FftBind/FftGeometry.lean`, `FftBind/FftSemantics.lean`,
`FftBind/NttSemantics.lean` — cross-lane BINBIND material importing
`Source3.*`, whose repair is the separate lane 062 (do-not-touch here).

Open (unchanged, recorded): `ReplyShape`/`S.code` source binding
(B1/source3), the byte bridge, the additive-error caveat, the F06
statistical/computational distinction (`chacha20PRFBound_delta_ge` stands).
F05's `hzero` (machine fiber support) is a named premise of the source
side, never assumed.

## 2026-10-11: F04-REVIEW-001 verdict = CHANGES_REQUIRED (scope/trust-boundary, not math)

Independent review (own rebuild 167/167 exit 0): F04/F05 repair
mathematics passes under explicit premises; 21 checked declarations =
standard axioms only. Two acceptance-criterion violations:
**R1**: SelectBitPreserve.lean (32-34, 58-61) - select_bits_equiv/
select_old_eq_new/select_code_variants_equiv depend on
`select_bits_equiv._native.bv_decide.ax_1_5` (outside the standard
trio). Historical diagnostic module; reverse import graph shows NO
consumers. Fix: re-prove without the axiom OR explicitly narrow the
accepted build to the F04/F05 closure and exclude this module from
the "standard only" claim + pin the new scope/evidence. **R2**:
ThetaBox.lean:166 has a historical local
`linter.constructorNameAsVariable false` (pre-832a9953, unchanged by
the repair); with the linter enabled the build dies with "maximum
recursion depth" IN THE LINTER (tool bug, not math). The blanket
"zero suppression" claim needs scope correction or the linter issue
fixed without disabling. Reviewer preserved test copy + error, did
not touch author sources.

Correction plan: honest scope re-statement now (exact trust boundary:
repair closure = standard-only; SelectBitPreserve = documented
historical diagnostic with bv_decide axiom, excluded; ThetaBox =
documented tool-bug exception with preserved evidence), optional
low-priority hardening batch later (re-prove SelectBitPreserve without
bv_decide; resolve ThetaBox linter recursion properly). Then quick
second review round on scope+evidence.

## 2026-10-11: owner rule - operational/hardware content NEVER in the repo

Explicit owner order: hardware, migration, mounts and operational
handoffs stay OUT of the repository (it is public and cloned). Such
material goes to ignored `proofs/ft1536/work/` or directly into the
target window via chat. One offending handoff commit was erased from
GitHub history by explicit owner order (forced update, the only
allowed exception; two tip commits dropped, all older hashes and pins
untouched). Future violations = stop-and-report, not silent commits.

## 2026-10-13: F04/F05 package ACCEPTED - PASS_SCOPED (REVIEW_002, Daybreak)

Targeted recheck of F04_ROM_VARIANT_A_SCOPE_002 by owner-designated
reviewer Daybreak = **PASS_SCOPED**. Trust boundary pinned exactly:
accepted scope = 166 modules (#001-#165, #167), import-closed;
#166 SelectBitPreserve explicitly excluded (zero importers, native
bv_decide axiom preserved in evidence); ThetaBox:166 accepted as a
DOCUMENTED linter exception (tool recursion bug). 3813/3813 files
hash-consistent, mathematical sources unchanged, no
sorry/admit/native_decide/sorryAx/new axioms in accepted scope.
Reviewer artifacts (hashes verified 1:1):
work/FT1536_F04_SCOPE_RECHECK_002/REVIEW_002.md (f8e0b2ad...),
REVIEW_002_RESULT.json (dbb00be7...). No full replay per scope of
the recheck. History intact (CHANGES_REQUIRED of REVIEW_001 stays
the historical verdict of round 1).

Audit findings closure: F01=061, F02/F03=062, F04/F05=run2 repair
+ SCOPE_002 + REVIEW_002. F06 stays OPEN. Source binding
(S.code <-> do_sign) stays OPEN and must NOT be claimed closed.
Hardening queue (low priority): re-prove SelectBitPreserve without
bv_decide; resolve ThetaBox linter recursion without disabling.

## 2026-10-13: B1 mid-review PASS_SCOPED (MIDREVIEW_001, Daybreak) - sealed chain 065-072 attested

Independent mid-review of sealed pairs BATCH_065-072 = **PASS_SCOPED**:
all 15,815 POSTSEAL pins match bytes 1:1; 90 accepted modules with
clean receipts; 955 audit entries point only at the standard axiom
trio; no NOTES-vs-theorem-type discrepancies. PARTIAL_PROOF status
correctly held; BATCH_073 + its seal supplement explicitly out of
scope (postseal 073 pending). No full replay by design; no sources
or pins changed. Reviewer artifacts pinned:
work/FT1536_B1_MIDREVIEW_001/MIDREVIEW_001.md (a32cd78a...),
MIDREVIEW_001_RESULT.json (34c95eca...).

Meaning: the rapid-growth chain (invocation bridge, full STATIC on
physical int16, NONE 3072, STATIC length formula) is now
independently attested for the paper's artifact story. The
three-sentence ritual was adopted and returned by the reviewer.

## 2026-10-13: A1 donor review CHANGES_REQUIRED (A1_REVIEW_001, Daybreak) - merge is selective embedding

Mechanical review of the A1 donor LaTeX package before merge =
**CHANGES_REQUIRED**: A1 describes the OLD F04 interface, needs F05
clarification, and does not cover the newest B1 state (NOT_REVIEWED).
Directly replacing live v0.3 would DELETE its status macros and
fuller pins - so the merge plan is refined: v0.3 stays the living
base, A1 DONATES selected parts (text developments, C01-C22 map,
annexes, SOURCE_MAP) into a single current v0.3 snapshot with
manifest, statuses and a fresh LaTeX build. Gates before merge:
(1) align F04/F05 + B1 claims with current statuses, (2) version
metadata for the comparison snapshot, (3) fresh compilation
(latexmk missing on reviewer host - environment gate). Donor
integrity 28/28 hashes; bibliography clean (7 cited keys = 7
entries, no orphans/uncited). Reviewer artifacts pinned:
work/FT1536_A1_REVIEW_001/A1_REVIEW_001.md (8646d733...),
A1_REVIEW_001_RESULT.json (61f6bf23...).

## 2026-10-13: WHOLE TODO closed - full codec/transport stack proven (186 modules, 1002 theorems)

The big TODO delivered ALL FOUR components: (1) NONE in-place
identity + existence (1536 coefficients, 3072 bytes, full decoder
with stores/return, original array recovered on [-9216,9216]);
(2) STATIC call roundtrip + in-place identity for ALL int16 values
including -32768, lengths from source; (3) vectors <-> int16 both
directions (real 768+768 layout, same f/g/F/G through four calls);
(4) public codec: actual observed key decode (header 0x8a, payload
2880, length 2881 -> same h) with extra-byte decoder behavior
preserved. Totals: 186 modules, 1986 declarations, 1002 named
theorems; final audit covers ALL declarations; accepted logs 0/0;
105/214 failed jobs retained with reasons; 18 helper bodies filled
by separate audit without touching earlier proofs/seals. Supplement
073 conditions met (manifest 010 + refusal frozen, pin 010->011
only, 15815/15815 input pins, ENTRY074 after re-postseal).
Final postseal WHOLE_TODO_POSTSEAL_001: 20619 pins, sha256
ca4997f1... (verified). Report: notes/run/
KEYGEN_SOURCE_TO_FIBER_001_CODEC_WHOLE_TODO_REPORT_001.md
(18767157...), INDEX_001.json. HEAD 738756e1.

Status edges (honest): B1.07 Acceptance NOT MET (connect accepted
attempt to serialization input; LegalWorkspace, relocation,
call-ID, lifetime obligations); B1.08 NOT MET (compose+observe
whole final secret key with 0xaa header); B1.09 public serialization
proven, full acceptance waits on B1.07 link. Math<->bytes bridge
now has full codec proofs; biggest gap = whole-KeyGen composition.
NOT_REVIEWED held.

## 2026-10-14: B1.07-09 ACCEPTED independently - PASS_SCOPED (REVIEW_B1_CLOSEOUT_001, Daybreak)

Independent review of the B1.07-09 closeout (batches 079-083) =
**PASS_SCOPED** in the C99/GCC LP64 reference model: input pins
21759 and final 21798 consistent; fresh replay 45/45 clean; five
deliberate mutations (bound 7681-10369, header 0xaa, memory-legality
premise, frame weakening) all rejected as expected. Verdict confirms
the CONDITIONAL agreement of both key packages (secret 0xaa + public
2881 joined on the same accepted material/certificate). Explicitly
NOT proven: real keygen success, Sign security, S.code<->do_sign.
Next: separate B1.10 contract, then B1.11 consolidation; then
do_sign realization. Reviewer artifacts pinned:
work/FT1536_B1_CLOSEOUT_REVIEW_001/REVIEW_B1_CLOSEOUT_001.md
(b4df4d69...), REVIEW_B1_CLOSEOUT_001_RESULT.json (ee080453...).

The B1.07, B1.08, B1.09 reference-scope Acceptance is now both
author-established AND independently reviewed.

## 2026-10-15: independent integration audit (snapshot f246feae) - INCOMPLETE, smallest missing implication

Independent integration audit (owner-designated, own W, no Git
writes) verdict: **INCOMPLETE** for the final real-C theorem. The
smallest missing implication: a typed, resource-bounded comparison
of the WHOLE C game vs model Games.runEUF at the SAME emitted key
and generator state. Findings: **F01 (NEW B2 spec error)**:
ChaCha20PRFBound is forall-E = statistical distance; route_a_closed
forces delta >= 1-2^(448-n), at n=512 that is 1-2^-64 - not a small
computational advantage (Sage-verified; does not question ChaCha20
security, only the formal interface). **F02**: Assembly statement
takes keyIdent : Prop unbound to muKey; hprg yields only 0<=delta;
no real-C-win <= model-win+loss. **F03**: T5 successfulKeyGen has
independent words quantifier - gate_full_floor not yet a floor for
the Gram of the same emitted key. **F04**: runEUF samples (sk,h)
once but honest calls depend only on h; equal single marginals do
not give joint multi-Sign law (exact countermodel); needs per-secret
or stateful source implication. **F05**: known open obligations
stand (successfulLaw may be none, D1 countermodel, B3/B4/S05 scope).
Local chains type-consistent; reviewer's own Lean replay died at
2GiB (exit 134) so NO independent kernel PASS granted; statuses
NOT_REVIEWED justified. Reviewer's one next step: B2 resource-bounded
distinguishertype + real whole-game hop consumed in Assembly for one
emitted (sk,h), same SHAKE/ChaCha state, exact horizon.

Impact on plan: audit SHARPENS the endgame, does not break it -
F02/F03/F04 become named assembly/do_sign obligations; F01 = B2
interface fix (small precise task); the ePrint condition "rozliczenie
otwartych interfejsow" now has its authoritative inventory.

## 2026-10-15: second integration audit (base 60835e6a) reconciles the first - work is FURTHER along

Owner-side integration audit (base 60835e6a) verdict: still
incomplete, but with an important correction of the picture:
**the previous audit's coverage map OMITTED existing CompPrg,
AssemblyComp and KeygenModelBinding134** (all present in its base).
Current work is further along than the first audit suggested.
CORRECTION TO MY OWN ENTRY ABOVE: the ChaCha20PRFBound TV/PRG issue
is NOT new - it is our F06 from Oct 11 (B4 register); both the first
audit and my yesterday's entry misclassified it as NEW. Apologies
in the record.

Confirmed sound locally (by type/proof reading + own 5 axiom-free
Lean lemmas + Sage checks): CompPRGBound/consume its premises
(cost certificate is INPUT, not a machine-cost proof); KeyLawBinding
requires real law equality (keyIdent := True insufficient);
KeygenModelBinding134 adapter is a real transport - its open
instantiation is EXACTLY positive success mass (package_none_iff,
KeygenSuccessMass134.positive_iff_witness). Source #147 = whole body
of one tripling iteration (no 256-iteration consumer yet).

New precise problems: **A02 (code-level!)**: falcon_prng_init is
INSIDE the attempt loop (falcon-sign.c:3330/3356/3361), each init
pulls 56 bytes from shared SHAKE (frng.c:290/302), nonces 40 bytes
from same state (:3286) - one-expansion AdvPrg description does not
identify whole C Sign. **A03**: joint/stateful honest-signing bridge
(countered: fixed bit -> equality 1, independent -> 1/2). **A04**:
game horizon != C randomness-consumption bound (sampler_large own
rejection loop :2898, get_u64 tail discards internal.h:824-829);
T01 a.s.-termination vs ghost budgets must not become hard caps.
**A05**: T5 gate words identity with key vectors (= prior F03).
**A06**: whole-call law vs per-attempt D1 (KeygenLawBoundary087.
condition_equal_iff + countermodel 1/2 vs 2/3).

Most valuable next contract per audit: source chronology
nonce -> seed per attempt -> sampler draws/refill -> retry/abort/
emit -> next query at one key/one state; then honest-stream game
type, horizon/loss at truncation, cost certificate. Parallel
source3 witness lane feeds the prepared consumers - FFT results
NOT invalidated. Do NOT recreate CompPrg/law adapter. Full
independent replay remains a separate gate.

## 2026-10-17: Z-lower 134 STOP_AND_REPORT - positivity IS witness existence (analytic route refuted)

The bounds window delivered step 1 fully (**KeygenMode1Law134** -
exact conditional per-coefficient law from source MODE1; uniform
margin m(c)/(1-m(3)) = 1/3, deviation transfer 16delta/(9-12delta),
oneDraw_transfer identity; deviations computed explicitly - the ONLY
undetermined component is the SHAKE chunk law over uniform seeds,
which sources do not determine) and step 4's full consumption chain
(KeygenModelUnlock134.{z_positive_of_first_attempt_bounds,
package_of_first_attempt_bounds, package_of_witness,
package_of_certified_set, acceptMass_positive_iff}). **The key
theorem: acceptMass_positive_iff - first-attempt mass is positive
IFF an accepting seed exists.** Therefore the analytic route cannot
be cheaper than the witness route: positivity = witness existence.
Step 2 (a > 0 for the real seed law) is a REAL wall (SHAKE chunk
law), not an omission; measurement 8192/23628 stays a control.
epsilon = a*c shape closed formally; a and c1 numerically OPEN
(codec/certificate line). My earlier recommendation (analytic
shortcut) is hereby formally refuted - recorded like D1.

Decision requested: **R1 (kernel certificate of one public synthetic
seed = seed9 fixture) is the cheapest sufficient form and unlocks
KeygenModelBinding134.package via package_of_witness immediately** -
RECOMMENDED; R2 (explicit RNG premise) would add a new external
assumption and weaken the claim - only with explicit owner consent.
R3 (MODE1 law + consumption chain) stays as immutable math.
Receipt: KEYGEN_Z_LOWER_134.json (643a160d...), postseal Z134,
commits 8b18ef5b/430ef59b/1ed29612/4926a6df.

## Consumption map

    B3/X  UniformChallenge + HashToSpec        -> Layer 1 (d1 = 0)
    B4/1  decomposition + joint_bounds ctor    -> the assembly mechanism
    B4/2  support/AC + layer2_of_obligations   -> Layer 2 skeleton (e2 = k^32-1)
    S3    CenteringClosure delta + budgets     -> the wrap-error inputs
    T5    machine/tower sandwiches             -> the mass-margin inputs
    B1    (source3, in progress)               -> ReplyShape + S.code binding
    B5    assembly                             -> the final theorem
