# 094 — actual raw norm, GS and ternary source composition

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**; whole owner task
**ACTIVE / NOT COMPLETE**. Parent POSTSEAL093:
`2cb53254ff998fe688846782637386564f846205445a77d89fc35ab940f63c09`.

`C99ProcedureDeterminism094` proves uniqueness for the procedure language,
including call argument binding, actual recursive body execution, return
conversion and caller receipt. The program table stays fixed; no callee
determinism or correctness is an assumption. Scalar/array source
determinism is supplied by the previously checked closed proofs.

`KeygenNormLanguage094` proves the actual small-to-fpr call and fixed
scalar-call table deterministic. A checked search-language fragment
covers source procedure calls, small-to-fpr, assignments/stores, loops,
branches and scope. It excludes unused pointer/align/plain-load/move
constructors, not any active norm/GS source instruction. The concrete
bound, raw norm, GS head and GS tail bodies all pass that kernel check.

`KeygenNormSource094` composes bound initialization, raw FFT computation,
the actual object-copy fpr_lt comparator, GS computation, the two scaling
calls and the final comparison. `norm_spec` identifies an exact partial
source function retaining both rejection and normal completion. No real
FFT identity, rounding-error estimate or gate acceptance is assumed.

`KeygenTernaryFunction094` combines both source samplers, both resultant
gates and raw/GS processing. The initial live-memory facts are derived
from the existing caller Initial domain, and the resultant input domain
is derived from the SAME sampled states. `ternary_spec` is an iff with
the existing `KeygenCallerPrefix.Ternary` source relation. Normal flow
is the boundary before public computation, solver and certificate; it
is not whole-attempt acceptance or successful KeyGen.

Final coherent `keygen_norm094_006`: **5/5**, stdout/stderr **0/0**, four
mathematical modules plus full type/term-DAG/axiom audit of **30
declarations**, standard axioms only. Six job directories remain intact.
One failed job and its tactical pattern cause are recorded in
`KEYGEN_NORM_094_FAILURES.json`; the repair changes inference orientation,
not the mathematical statement or source relation. Limits unchanged.

Author self-review checked code coverage, actual FFT/FPEMU callees,
chronological source states and all ternary rejection edges. No independent
acceptance or totality claim is made. No numerical experiment was needed.
Next: public computation, solver, certificate, codecs and the full capped
loop, followed by the actual seed law and SAME model-key binding. The
fixed caller, automatic entropy boundary, source nonreturn, normalization
and positive success where needed remain open. Five do_sign items unchanged;
no push, migration, production C edit, reviewer or actual-C e2 result.
