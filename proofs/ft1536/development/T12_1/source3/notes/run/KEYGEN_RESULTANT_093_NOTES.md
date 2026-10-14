# 093 — actual resultant gates and local-array relocation

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**; whole owner task
**ACTIVE / NOT COMPLETE**. Parent POSTSEAL092:
`fe22a4dffaca97ced56d0d231b68959613bab248a07c8a638a210ac99d7b49d1`.

The array/modular/word transport modules prove covariance of actual source
execution under renaming of abstract memory blocks. They retain offsets,
values, fixed program bodies, scalar call relations, source instructions
and all control flow. Transport does not require a callee determinism
assumption. Word-expression/execution determinism is separately proved
on a checked syntactic domain excluding modular-call expressions; the
complete actual resultant setup/packing/switch/tail satisfies that check.
The existing scalar call table remains closed and source proved.

`KeygenResultantBody093.Body` is precisely the body-premise group of
`KeygenResultantSource.Call`, with its source setup, memset legality,
packing, all switch fallthroughs, tail and return conversion. Its finite
outcome and scalar return are unique for a fixed local-array block.
`KeygenResultantRename093` transports the whole body and shows that swapping
two fresh blocks fixes the original bound state when its arrays/tables are
live. This proves equality of scalar returns even when executions choose
different blocks for b[96]. No arithmetic resultant specification replaces
the actual executed source body.

`KeygenResultantCall093` derives the bound-state live-pointer facts from
actual argument binding, the input polynomial's live object and live tables.
The caller state is restored exactly, using the previously proved byte and
metadata frames. Both scalar return and caller result are unique. This
composes into uniqueness of the two actual resultant gates, retaining first
rejection, second rejection and normal fallthrough.

`KeygenResultantFunction093.gate` is an exact partial source function;
its membership iff theorem covers every source gate result. `from_samples`
derives its input domain from actual sampler calls and the existing Initial
caller domain. No accepted-result selector or independent-attempt law is
introduced; no termination or success-existence claim is made.

Final coherent `keygen_resultant093_010`: **9/9**, stdout/stderr **0/0**,
eight mathematical modules and the full type/term-DAG/axiom audit of **49
declarations**, standard axioms only. Ten job directories are retained.
Three failed/mixed jobs and causes are in `KEYGEN_RESULTANT_093_FAILURES.json`.
Job004 exceeded the kernel memory budget while checking all nine switch
cases in one proof; the check was split into nine named lemmas, with the
same resource limits and same statement. The other failures were rejected
deprecation warnings and the wrong projection of a slots-preservation fact.
No warnings were suppressed and no limits increased.

Author self-review checked source coverage, fresh-block swapping, exact
caller restoration, all rejection edges, source-derived input legality,
and the separation of determinism from totality. This is not independent
acceptance. No new numerical computation was needed.

Next: norm/GS and public/solver/certificate/codec source closure, followed
by the entire capped loop and whole-call law. Fixed caller construction,
explicit seed versus automatic entropy, source nonreturn, normalization,
success positivity where required, and SAME decoded model law remain open.
Exactly five do_sign items remain unchanged. No push, production edit,
migration, stages import, reviewer or actual-C e2 result is claimed.
