# Pre-do_sign closeout — the single remaining implementation slot is not yet achieved

Date: 2026-10-14. Primary self-audit verdict: **incomplete, with the smallest
missing implication**. The deterministic keygen contract and scoped replay
consolidation are complete; a new kernel-checked analytic consumer and a
source-pinned signing obligation map are prepared. The requested theorem
with real implementation advantage and ONLY a do_sign realization slot is
**BLOCKED**, not proved and not newly exported under the requested name.
No independent review is claimed for these additions.

## Stage results

| Owner stage | Result | Acceptance / evidence |
| --- | --- | --- |
| 1. B1.10 | `PROVED_KERNEL_SCOPED / NOT_REVIEWED` | New `KeygenSourceToFiber001` reference contract, 3 theorems, 11 audited declarations; 2/2 final compiles, logs 0/0 |
| 2. B1.11 | `CONSOLIDATED_SCOPED_EVIDENCE / NOT_REVIEWED` | Existing independent 45/45 fresh replay, 5 controls and 5 rejected mutations, 974 historical source/product pairs by pin |
| 3. Real end-to-end single-slot statement | `BLOCKED_SINGLE_SLOT_ASSEMBLY` | Deterministic keygen-to-fiber does not identify a key law; the existing computational hop is for public simulation, not real honest signing |
| 4. do_sign preparation | `SOURCE_PINNED / REALIZATION_OPEN` | 17 source files, 23 exact lexical function regions; named pointwise goal and proved model consumer; 2/2 final compiles, logs 0/0 |

B1.11's current owner-defined reference evidence acceptance is met.
`full_b1_11_replay=false`: neither the whole historical world nor the old
plan's wider mutation list was freshly executed here. Historical labels,
failed jobs and independent verdicts are unchanged.

## Why the requested final statement cannot be obtained by wiring these pins

The decisive source/type checks are preserved by `SignRealization086Audit`
as full terms, types and standard-axiom lists.

1. **KEY-LAW, outside the do_sign body.** B1.10 quantifies over a defined
   successful source execution and derives its output's certificate,
   equations and bytes. It contains no `Law`, random tape, probability,
   normalizer or distribution equality. In contrast,
   `AssemblyComp.KeyLawBinding.identify` requires an actual equality
   `muEmitted = muKey`. No producer of that equality from the new
   deterministic contract is present in the inspected source3/run2 formal
   sources. A law on emitted packets could be defined by pushing forward a
   source-defined successful-execution distribution, but the latter and its
   identification with the D1 experiment still need construction. Naming an
   arbitrary law `muEmitted` is not that construction. Call-level capacity
   rejection must also remain distinct from per-attempt acceptance.
2. **Existing `Assembly` has a weaker meaning.** In
   `Assembly.lean:359–389`, `hkey` is passed through a gate whose body is
   `intro _hkey`; it does not identify any distributions. The conclusion
   is `Games.AdvEUF`, already defined by `Games.runEUF` using the abstract
   `signHonest` law. The final PRG step is
   `hbase.trans (le_add_of_nonneg_right hseam)`: adding a nonnegative
   quantity to the ideal-game bound. This is a valid theorem as written,
   but not an honest-implementation generator change. Supplying B1.10 as
   `keyIdent` would leave that meaning unchanged.
3. **The corrected computational theorem has the right restricted scope.**
   `AssemblyComp.advMT_ge_of_public_sim_stream_win` consumes
   `AdvPublicSimStream`, a computational test class/cost certificate and
   a key-law binding. Its tape-driven computation is `signSimAt`, with a
   public key and no secret signing material. It cannot be relabelled as
   the real secret-key signing experiment. The real signer needs its own
   tape-parametrized experiment, admitted winning test and fair-tape law
   comparison before using the hybrid. Its computational advantage should
   remain an explicit term, not be replaced by the historical statistical
   `Assembly.AdvPRG = TV` quantity or assumed negligible.
4. **Byte interfaces have local contracts, not the whole game equality.**
   The key packets and source codecs are now available. The pinned
   `VerifyBind.verdict_valid_iff` still describes the declared decoded
   verifier (`keyDecoder`, `hashTo`, `decodeSig`); composition with actual
   signature observations, caller failure behavior and the game must be
   established. `provenance/FT1536_ACTIVE_BUILD.md` explicitly retains
   `protocol_wrapper_integrated=false`, including the historical CLI
   capacity/nonce mismatch. No wrapper was changed in this task.

Thus the central missing implication **before** claiming one do_sign slot is:

> Define the actual conditional key-generation and byte-level security
> experiment from the pinned implementation, identify its key law and
> connect its non-signing interfaces to the declared ROM game. Then the
> source signing-law/hybrid obligation can be isolated without moving
> unrelated KeyGen or experiment obligations into it.

This is a missing proof/construction, not a demonstrated cryptographic
attack or a refutation of the desired theorem. No generic proposition,
blanket correctness assumption or disguised conjunction was introduced to
hide it. No final `end_to_end_assembled_theorem_statement` was fabricated.

## The exact prepared analytic goal

`Source3.SignRealizationObligations086.PointwiseStageGoal S jatt weights`
is an OPEN goal. `WeightData` contains the four weight functions, indexed
by `(h, st, message, nonce, challenge)`. The structure requires:

```text
replyShape : HacGlue.ReplyShapeAt S jatt
road       : forall h st m r c,
               PointwiseStageRoad (SigmaMath.syndrome h) c
                 target mach wrapS w
attemptShape : forall h st m r c,
                 AttemptShape (jatt h st m r c) w
                   (stageRoad_nonneg (road h st m r c))
```

The realized functions must be DEFINED from the SAME source execution;
arbitrary inhabitants of `WeightData` do not claim realization. The checked
consumer derives `AttemptPointwiseAt`, then `LocalJointCertificate`, then
`model_bound_of_pointwise_goal` via `concrete_euf_cma_to_mt_isis`. This has
one named analytic premise and no free `keyIdent` or PRG budget. Its
conclusion is explicitly the abstract fair-randomness ROM game for an
arbitrary supplied key law. It is a useful consumer/interface for the last
window, not a weaker result renamed as real end-to-end security.

F04 variant A is consumed through `HacGlue.romChallengeAt` as a theorem.
All 166 accepted source/product pairs were rechecked. #166
`SelectBitPreserve` is excluded; #156 `ThetaBox` retains its previously
accepted documented linter exception. No new warning suppression occurs.

## Source decision for e2

Pinned `Extra/c/falcon-sign.c` SHA256:
`eee8d7dc503e007cb76bcc157094b2a2de481075ac3f67426848f7a8cae6efd8`.
Candidate manifest SHA256:
`56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
`DO_SIGN_SOURCE_MAP_086.json` pins all 17 files and 23 extracted regions;
extraction is lexical evidence, not a source-adequacy theorem.

The enforced profile has `CT_BEREXP=1`, adaptive CDF=1, ternary candidate,
`SIGN_MAX_ATTEMPTS=16`, FPEMU and the hardened default scalar CDF. The ROM
challenge is formed before the outer retry loop and held fixed. Each
iteration initializes the PRNG, calls `do_sign`, checks fatal sampler
fault, then tests `falcon_is_short`; norm rejection retries. After the
first short result, encoding occurs ONCE outside the loop; codec failure
returns 0, not another candidate. Scalar BerExp rejection inside
`sampler_large` is different from this outer signature norm rejection.

**Structural selection:** the unconditioned, sample-then-check attempt
route matches the outer norm control flow. The prepared target is
`e2(k)=k^32-1`, at `k=attemptFactor`; the mathematical consumer proves
`e2(k)<2^-32` only under the pointwise goal. The acceptance-conditioned
`k_cond=k/(1-2^-24)` is not selected by this outer attempt boundary.
Conditioning the final successful output would be a different law and
cannot silently discard the cap/failure mass. **No actual-code e2 bound
has been proved here.** Fatal faults, runtime widths and law realization
must be resolved before the unconditioned target can be asserted of C.

## What the do_sign realization must supply

| ID | Required source result, with no extra premise substituted for it |
| --- | --- |
| DS-MATERIAL | Consume B1.10's SAME decoded f,g,F,G,h and certificate through `falcon_sign_set_private_key`, validation, `load_skey`, FFT basis and LDL tree; establish all reachable leaf domains |
| DS-LAW | Define the actual one-attempt and reply laws from the pinned code, with state/history/ROM challenge, entropy source and scalar rejection accounted for |
| DS-ATTEMPT | Prove `AttemptShape` for those actual weights, after actual norm checking; prove exact fiber support and coordinate/int16 interpretation, rather than assuming `A(h,z)=c` |
| DS-REPLY | Prove `ReplyShapeAt`: chronological attempts, cap16, first success, exhaustion, encoding outside the loop, nonce/challenge state and buffer failures |
| DS-FAULT | Prove fatal sampler faults absent on the reachable domain, or derive a compatible new law/bound; an immediate fatal return cannot simply be mapped to a retryable `none` |
| DS-TAPE | Resolve unbounded scalar `for(;;)` consumption versus finite total `Sampler.code` with `S.bits`; prove a valid representation/termination and resource accounting, not an assumed finite bound |
| DS-TOWER | Give exact/real row factors on every fiber point, zero target off-fiber, nonnegative rows, pointwise row sandwiches and both budget-product fits; 3072 full rowBudgets are not admissible |
| DS-MACHINE | Give the 20 multiplicative/11 divisive factors and evaluation identity with all ranges; or a proved alternative feeding the same stage. An additive error requires support-restricted floor and separate hzero, never a global positive floor |
| DS-WRAP | Give all 1536 coordinate factors, evaluation identity and allowed ranges; prove relation to actual rounding/casts (ternary and binary do_sign formulas differ) |
| DS-BOX | Give whole-space retention rho in the proved interval and pointwise uniform rescaling, covering bulk AND tail; total-mass estimates alone do not discharge this |
| DS-BYTES | Tie final observed signature, actual codec length/capacity/header and verifier outcome to the game reply; key-codec agreement alone is insufficient |
| DS-HYBRID | Define the honest signer under the real stream and fair randomness, certify its admitted winning test/resources, and compose its computational hop with the certificate and extraction |

DS-MATERIAL through DS-HYBRID explain the intended broad signing
realization scope. KEY-LAW and the non-signing experiment construction
above remain separately open; they have not been renamed do_sign.

## Checks, failures and readiness

084 final job: 2/2; 086 final job: 2/2. New named declarations: 11 + 8;
new named theorems: 3 + 5. 086 audit: 8 new + 3 inherited full declarations,
standard axioms only. Failed/mixed jobs retained: 084_001 (sandbox),
084_002 (dependent alias), 086_001 (missing namespace), 086_002 (audit
printer truncation). The last was corrected with explicit/deep proof
printing; no limit or linter was weakened. There are six job directories
in total, four failed or mixed, with final accepted streams 0/0.

Self-review covered the new Lean declarations and report claims, the raw
existing Assembly/AssemblyComp/Games types and bodies, and the listed C
regions/profile. Mathematical proofreading covered only this task's
changed/new sources and notes; no independent verdict or universal audit
of historical mathematics is claimed. B1.10's actual type matches its
reference scope; the requested real-code single-slot target remains
incomplete. No new numerical experiment was needed; the mathematics above
was checked by Lean rather than a Python numeric surrogate.

**Readiness:** ready for a carefully scoped signing realization window,
but not ready to call that window the only remaining work. The cheapest
next prerequisite is the source-defined key-law/experiment contract with
an exact equality target; separately, DS-FAULT and DS-TAPE are the first
discriminating signing checks before spending effort on all four pointwise
roads. No counterexample to security, success/termination theorem or
small-error bound for actual C is claimed.
