# 091 — seeded readiness and the complete MODE1 sampler

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**; whole owner task
**ACTIVE / NOT COMPLETE**. Parent is POSTSEAL090
`fe2e07f03be54246088b3ab40660646cfcc9e423428dbd32524b642e5b83de81`.

## Result

The actual `rng_ready` body, on the physical seeded=1/flipped=0 flags
derived from the replacement-seed API, skips automatic entropy, performs
the source flip and returns one. Its finite result and event list are
unique. The call-level proof retains actual argument binding and return
conversion. `KeygenReadyCall091.ready` is an exact partial function, with
membership iff the source call; `from_seed` derives its input flags from
the actual seeding execution, without a correctness field.

`C99Metadata091` proves allocation/permission/table/global preservation
for the array and modular statement semantics. `C99SimpleModular091`
proves determinism for the syntactically checked scalar-only fragment
used by MODE1. It does not assume determinism of arbitrary modular calls.

The sampler proofs compose actual refill, two-bit extraction, rejection,
16-bit stores, inner rejection loops, outer coefficient loops and call
binding. Live context/table legality is transported at every scalar RNG
draw. The existing real-source RNG theorem removes fresh temporary block
choices; no uniform-word oracle, IID premise or attempt-law replacement
is used. Two finite executions have the SAME final source state.

`KeygenSamplerFunction091.sample` is an exact mathematical partial source
function. `sample_spec` is both-direction membership iff the actual
`KeygenSamplerCalls.Call`; returned legality is derived. `pair_spec`
composes two calls through the SAME intermediate state, preserving all
stream correlations. Choices in the Part construction are justified by
proved uniqueness, not by selecting successful KeyGen attempts.

## Checks and preserved failures

Coherent final job `keygen_sampler091_013`: **9/9**, empty stdout/stderr;
eight mathematical modules and the full type/expression-DAG/axiom audit
of **73 declarations**, only standard axioms. No source warnings are
disabled. Single-job lock, no-network sandbox and resource bounds remain.
All 13 job directories and their immutable source snapshots are retained.
Six failed/mixed jobs are recorded in `KEYGEN_SAMPLER_091_FAILURES.json`:
constructor/projection issues, one erased local name, scope metadata,
the checked-loop induction predicate, and two legality-instantiation
issues. Each later job changes the failed proof step.

Author self-review checked chronological state threading, rejection
versus acceptance control, legal-memory propagation and the distinction
between uniqueness of finite executions and termination. This is not
independent review. No new numerical computation was needed.

## Remaining target

Neither partial sampler nor seeded readiness proves that a defined
execution exists for every seed. The outer KeyGen cap does not bound
the inner sampler rejection loop. Whole-KeyGen gate/solver/codec
determinism, fixed caller construction, the explicit-seed versus fresh
OS-entropy boundary, source nonreturn, whole-call normalization, positive
success when required, and SAME decoded model-law binding remain open.
The next stage connects seeded readiness to the real enclosing prefix,
then continues the remaining source closure. All five do_sign items
remain unchanged. No push, production C edit, migration, stage import,
reviewer or actual-C e2 result is claimed.
