# Whole actual KeyGen law — final author handoff

2026-10-14. **Owner KeyGen-law objective met in the declared A2/reference
scope; PROVED_KERNEL_SCOPED / NOT_REVIEWED.** This closes the whole-law
route, not T12.1, the honest-signing implementation proof, independent review,
or the earlier one-do_sign-only end-to-end objective.

The authoritative target is [the unchanged 088 plan](KEYGEN_WHOLE_LAW_088_PLAN.md),
started from `9d78eb3fe73d928a1324c7b5d11e273ee97f28b2` after the D1 boundary
counterexample. Cutoff and assessment are this same checkpoint: proof commits
`1694400e`, `94769403`, sealed by `e1a89f75`; no historical status is rewritten.
The [stage index](KEYGEN_WHOLE_LAW_FINAL_001_INDEX.json) records all 24 stages,
exact receipt/postseal pins and the local commit history. The
[owner TODO](KEYGEN_WHOLE_LAW_TODO.md) is the current decision view.

## What is proved

Fix an environment and the existing legal caller data *outside* the random
seed map. A single A2 seed is uniform on the 32-byte space, of cardinality
2^256. Its bytes enter the actual pinned `falcon_keygen_set_seed` source at
`len=32, replace=1`. The same resulting SHAKE state flows through every
scalar draw, rejection, outer attempt, accepted certificate and codec.
No independent-retry law, generic D1 equality, supplied execution family,
source-realization field or extra KeyGen PRG assumption is an input.

The complete source observation `G(seed)` has outcomes:

- no finite defined initialization plus invocation;
- observed readiness, attempt-limit or encoding failure;
- the final emitted secret/public byte packet.

The law is the actual seed pushforward through `G`. Finite source execution
and the observation agree in both directions; any choice of finite execution
has the same result. The outer cap is 3,000,000 attempts. Readiness mass is
zero on the explicit replacement-seeded path. Every failure class remains
in the raw experiment; partial codec writes are not promoted to success.

For every whole-call outcome `o`, its probability is exactly
`#{s : G(s)=o} / 2^256`. Let `Z` be the whole-call emitted-byte mass. All
no-defined-return, failure and successful masses sum to 1. The successful
packet law is absent when `Z=0`; otherwise it is normalized by **Z**, not
by a per-attempt acceptance estimate. No theorem here asserts `Z>0`.

Actual secret/public partial decoders define a second seed-to-model
experiment. Every successful packet decodes to the SAME `(f,g,F,G,h)` as
its source certificate/fiber contract. Its successful joint law equals the
successful packet law pushed through joint decoding; both constructions
have exactly the same success normalizer. Invalid decoder defaults have
zero successful mass. `SigmaMath.muH` is exactly the public marginal of
this joint law, without any uniform-key claim.

`KeygenModelBinding111.package` constructs both normalized laws and their
identification evidence from the two computations. It is absent iff `Z=0`.
`Package.laws_equal` and `Package.assembly` supply the actual equality and
`AssemblyComp.KeyLawBinding`; the caller does not supply a desired equality.
Every positive model key has an actual seed and the SAME source contract.
The existing generic model is instantiated by this whole law; the rejected
per-attempt D1 law is not resurrected.

## Exact input and progress boundaries

The source domain is the existing pinned C99/GCC LP64 M0 reference domain:
legal context, source tables, scratch, separate live output objects,
`comp=1`, and public capacity at least 2881 with its writable region.
Caller memory and capacities are fixed before sampling the seed. This does
not claim a result for arbitrary buffers, aliasing, profile or native ABI.
The finite canonical pointer representation is constructed before supplying
the caller heap. No theorem rebases an arbitrary existing machine heap.
These input facts contain no successful execution or probability-law field.

The public replacement-seed API is real source code. A fresh automatic call
instead reaches `rng_ready`, obtains `tmp[32]` from `falcon_get_seed`, and
uses `replace=0` on its initialized context. Its entropy system calls can
fail or fail to finish. The source size is checked; no unconditional OS
availability/distribution or full automatic-bootstrap transport is proved.
The declared A2 experiment starts at supplied replacement bytes, as recorded
in088. Mixed-seed and resumed calls require their own initial-state/input
law. They are not silently equated to the present experiment. For a claim
about the unconditional OS-backed API, that additional boundary remains open
outside do_sign; it is not an extra premise hidden in the present theorem.

The totalized outcome `none` means **absence of a finite defined source
execution**, exactly as characterized by `KeygenByteGame109.none_iff`. It
does not distinguish divergence from undefined execution or prove either
one occurs. The experiment retains its mass rather than assuming progress.
The outer cap is not used to prove inner sampler or solver termination.
This resolves the progress obligation needed for the declared outcome law;
a termination or positive-success theorem remains a distinct stronger task.

## Author self-audit

Primary verdict: **proved as written** for the above scoped claim. This is
self-review, not independent REVIEWED status. Raw definitions, theorem bodies,
input fields, source branches and the model interface were inspected.

| Obligation | Result and decisive evidence |
| --- | --- |
| Actual sampled bytes and source seeding | Passed: SeedEntry089/SeedDomain089, fixed caller and source API |
| Same stream through all attempts | Passed: draw090, sampler091, prefix092, actual capped loop105 |
| Complete solver and certificate behavior | Passed: source leaves093–103 and Certificate104; no solver-correct oracle |
| All codec exits and actual pointer reads | Passed in declared representation: codec106, dispatcher107, caller108 |
| Whole source construction, not arbitrary trace input | Passed: WholeTrace109.complete_outputs, SeededExecution109.unique, ByteGame109.some_iff/none_iff |
| Exact raw law and normalization | Passed: Probability110.mass_count/accounting, SuccessCount110.success_count |
| Correct whole-success conditioning and zero case | Passed: Probability110.zero_success/conditional_mass and ModelBinding111.package_none_iff |
| SAME decoded material and certificate | Passed: DecodedKey111.same_material and ModelBinding111.model_source |
| No invalid decoder mass | Passed: DecodeMass111.raw_zero/decoding_failure_mass |
| Joint law and public marginal | Passed: ModelLaw111.raw_binding/conditioned_binding, ModelBinding111.public_marginal |
| Actual interface binding, including body | Passed: identify uses conditioned_binding; Package derives identification from the computed outputs |
| Fresh OS path, arbitrary native layouts or resumed law | Outside the declared A2 scope; not proved or assumed |
| Positive success, numeric acceptance, termination | Not asserted; zero success/nonreturn retained explicitly |
| Honest implementation security and actual-C e2 | Not addressed by this KeyGen result; dependencies remain below |

The dependency chain is acyclic: pinned source semantics and prior SAME-fiber
contract → actual whole seeded outcome → uniform-seed pushforward → whole
success conditioning → actual partial decoding → joint equality/public
marginal/interface binding. The finite key carrier uses decoded packet images;
its fallback values cannot gain source mass. `Identified` is not an arbitrary
proposition and does not include the law equality being proved.

The existing generic D1 shortcut remains refuted (087). The incomplete-live-set
pointer counterexample (106) remains valid for its local raw interface;
108 supplies a constructive representation and actual read provenance.
Neither result is a counterexample to full actual FT1536 security.
The number 0.34671 remains the pinned empirical 8192/23628 attempt frequency;
it is not a kernel-proved lower bound for `Z`. F04 establishes signing ROM
challenge behavior conditional on fixed h, not the KeyGen public-key law.

## Verification and retained evidence

Final selected replay: `keygen_model111_008`, **18/18 accepted modules,
stdout/stderr 0/0**: seven109 producer modules, six110 law modules, four111
model modules and one combined full audit. The audit contains **110 named
declarations**, full term/type DAG roundtrips, and only `propext`,
`Classical.choice`, `Quot.sound`. There are 37 new111 declarations.
The new runner reuses the exact previously sealed166-module F04 scope and
checks overlapping source hashes. Historical documented warnings keep their
old scope; no new warning suppression is introduced. This is a coherent
selected replay with pinned dependencies, not full historical replay.

Stage111 has eight jobs, six failed/mixed, all retained in
[the failure register](KEYGEN_MODEL_111_FAILURES.json). Earlier stage failures,
including the098 aggregate-audit resource failures and their streaming fix,
remain pinned through the stage index. No failed job is labelled accepted. The closeout index generator also retained
an initial metadata failure: stage098 has separate source/audit job fields,
so the index now preserves both original fields without editing its receipt.
One Lean process at a time, original resource/isolation limits, no subagents.

Sage110 used the standard preparser and exact ZZ/QQ for eight synthetic
outcomes, zero success, many-to-one decoding and three rejected incorrect
normalizations. It is an algebra control, not a real seed enumeration or
acceptance computation; its version1 provenance limits remain explicit.
No new literature premise or numerical approximation is used by the proof.

| Final stage | Receipt SHA256 | Postseal SHA256 |
| --- | --- | --- |
| 109 producer | ac894459d095ab26d482ca59282ca5471587d3e7783d44429561e985f282dd87 | 199b2d130a54ddac3640f463e5b8bae600c57e521a3aa2dc5219ce455f93d89c |
| 110 whole law | 7a51c28fd66cd9471d4df12c0dd0e618d42993ace80772aa1c269bc88c166087 | 519cc807438728617d8adffb91b0ccf4dfffaecd4f3e260d0e7098bd4b5d051c |
| 111 model | d2e539d50329951d22dad35c8a34372edb2b78ffc1696923b4254a71b2832b14 | 0476066da04edb02c2009a6d0fdc7a9286b9e08f8100d3cd5c7c87cd161a6a65 |

POSTSEAL111 verifies **27,064 distinct pinned files**. Source/model commits
are local on main; no push, production-C changes, migration, stages import,
tag or independent-review claim. Foreign changes and historical reports are
preserved. Final committed-source/pin verification is generated at
`.build/key_law088/FINAL_POSTSEAL_001.json` with its small tracked companion
`KEYGEN_WHOLE_LAW_FINAL_001.json`. Proofreading/self-review covered the new111 sources and this
closeout; no mathematical-token changes were made during proofreading.

## Remaining project work, outside this completed law route

The non-signing actual byte security experiment still needs its caller/wrapper,
signature observation and verifier/ROM transport. The historical wrapper
integration/capacity/nonce cautions from086 remain. The present result closes
KEY-LAW in the declared scope; it does not claim that only do_sign remains
before a real implementation security theorem. An OS-backed KeyGen claim
needs the separate bootstrap/input boundary described above.

The do_sign slot remains **exactly five points**:

1. Key/certificate transport.
2. AttemptShape/ReplyShapeAt.
3. The four PointwiseStageRoad conditions.
4. Rounding/int16/syndrome.
5. Sampler loop and the honest-signing PRG hybrid.

The optional actual-C `e2 = k^32 - 1` bound remains open. The outer control
flow selects the unconditioned target, but actual signing-law realization,
fatal faults, scalar progress and casts/support are still prerequisites.
KeyGen law identification supplies none of these; promoting the analytic
bound would be unsound. Next useful work is the separate non-signing game
transport and the already isolated signing obligations, after owner-selected
independent review of this package. No reviewer was started automatically.
