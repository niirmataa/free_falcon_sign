# 092 — source seed through readiness, cap and first samples

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**; whole owner task
**ACTIVE / NOT COMPLETE**. Parent POSTSEAL091:
`df3d8520ea270941f8b893512120b6cd6b5bd87e9b639d35577b18e028147575`.

## Checked source connection

`KeygenPrefixFunction092` proves that automatic declarations preserve
the seeded flags, by the already proved frame for live allocated blocks.
It follows the actual declarations, counter initialization, profile reads
and readiness gate. In the legal replacement-seeded domain, a finite
prefix has normal flow and no entropy events; its final state is unique.
The exact partial `runPrefix` has a both-direction source specification.

`KeygenCappedSampler092` derives the live RNG/table domain from the actual
caller Initial facts, proves uniqueness of the context-resolved sampler
calls and transports legality across them. It proves cap/setup uniqueness
for reachable counters and preserves metadata through either cap branch.
Two successive sampler calls after a nonexhausted cap have the SAME result
in any two finite executions. Their common stream state is not replaced.

`KeygenSeedPrefix092` connects the real replacement-seed call, external
make argument binding and complete prefix. The existing legal caller
domain and physical flags are transported by the source seeding theorem;
no seed-indexed correctness field is introduced. `prepare_spec` identifies
its exact partial output. The returned counter=0, fixed dimensions, live
RNG object and live tables are derived for the real next call site.

`KeygenSeedTrace092` applies that result to every branch of the existing
whole source Trace: there are no entropy events and no readiness-failure
trace after this defined replacement-seed call. This does not remove cap
or encoding failure, and does not exclude absence of finite execution.

`KeygenFirstSamples092.sampleFirst` is the exact partial source chain
from supplied seed bytes through both f/g sampler calls of the first
attempt. The cap cannot exhaust at counter zero, as a source consequence.
The acceptance gates have not yet executed at this boundary. In
particular, this is not the accepted-key output law or success existence.

## Verification and limitations

Final coherent `keygen_prefix092_009`: **6/6**, stdout/stderr **0/0**,
five mathematical modules plus full type/term-DAG/axiom audit of **33
declarations**, standard axioms only. Nine job directories retain all
snapshots and logs. Six failed/mixed jobs with exact causes are recorded
in `KEYGEN_PREFIX_092_FAILURES.json`; these are elaboration, import and
tactic-composition errors, not counterexamples to the source statements.
The normal resource bounds and single-process discipline remain.

Author self-review checked that flags and sampler legality are derived
at the caller, that cap failure and nonreturn are not conflated, that the
same intermediate states are shared, and that actual source binding is
used in both directions. No independent acceptance is claimed.

Next: actual resultant/norm/public/solver/certificate/codec execution
uniqueness and composition through the entire capped attempt loop. The
fixed legal caller still needs construction; explicit seed versus fresh
automatic entropy, nonreturn, success normalization and the final SAME
model law remain open. Exactly five do_sign items are unchanged. No new
probability/PRG assumption, push, source C edit, migration, reviewer,
stages import or actual-C e2 claim is part of this checkpoint.
