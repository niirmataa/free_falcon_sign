# 105 — complete stopped source attempt loop

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**; whole owner task
**ACTIVE / NOT COMPLETE**. Parent POSTSEAL104:
`5c580ecd28994ad021c040814f0de4971a559ac90aaaf252ae7a05946536d8b9`.

All actual attempt gates now compose: two samplers, resultants, norm/GS,
public computation, solver and certificate. The cap uniquely determines
whether a sampled attempt may start. Every retry transports the existing
Initial, counter/dimensions, scratch space and public-object liveness to
the SAME next state. No draw or independent seed is inserted at a retry.

The complete original Loop has unique finite output, including exhausted
cap and successful loop exits. To avoid dependent record-projection case
elimination, Run erases only the attempt-proof list. Erase and restore
prove both directions with every transition and state retained. runLoop/
spec is an exact partial denotation of the original Loop, not an oracle
or success-only trace selector. It does not assert inner-loop termination.
The existing actual 3000000 cap and chronological bound proofs remain.

Every loop input is derived from the actual whole-call prefix and existing
memory domain. The seeded adapter uses the SAME actual source-seeded
state and completed prefix; no future successful execution is assumed.
Classical choice extracts an already supplied intermediate prefix witness,
not a successful KeyGen outcome or an arbitrary execution probability law.

Final keygen_loop105_006:6/6, five mathematical modules and full audit of
25declarations, logs0/0, standard axioms only. Six jobs include three
failed elaborations: a folded input-state projection, dependent attempt
record elimination/unused proof-only binder, and argument order/missing
explicit sealed import in the entry adapter. All original sources/logs and
causes retained. Global limits unchanged. Author self-review only.

Next: encoder leaf determinism and complete tail argument/state binding,
including failure branches and pointer-word decoding, then seeded whole
producer and actual law/SAME-model binding. Fixed caller/entropy boundary,
nonreturn and normalization/positive success where required remain open.
Five do_sign items unchanged; no push, migration, production C edit,
reviewer, stages import or actual-C e2 result.
