# Actual public quotient loop171

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Whole owner task ACTIVE / NOT_COMPLETE. Source commit873f3923.

SelectedQuotient171.source constructs the original public suffix pass,
including u=0 and all 1536 iterations, from SelectedForwardT168.output
to SelectedQuotient171.after with normal flow. Each original t[u]==0
branch falls through using the source-bound nonzero theorem170; each
ternary div18433 expression and h[u] store is constructed from the actual
scalar helper body. The loop preserves all t words and h readability.
The selected inverse-entry profile, pointers, writable initialized h and
fresh blocks33/34 are derived, not caller assumptions. continue_public
retains the exact remaining inverse/return obligation.

PublicQuotientAtoms171 proves comparison/load/division source steps;
PublicQuotientBody171 constructs one original scoped body and its frame;
PublicQuotientLoop171 proves the complete loop with its initialization,
increment and endpoint. These parametric lemmas are instantiated once
on the selected state. No numerical experiment or probability premise
is needed for this source composition.

Four modules / 25 declarations passed full expression-DAG roundtrip and
fresh safe kernel checks in audit177, four sequential processes, only
propext/Classical.choice/Quot.sound. Accepted jobs176/177 have empty
stdout/stderr, 0 errors and 0 warnings. Failed jobs172–175 are retained:
restricted Bool simplification, zero-result representation and equality
transport initially rewrote the comparison operand as well as its result.
The final proof transports only the result argument. No source condition,
C/model semantics, setting, resource limit or warning policy changed.

ENTRY171 verified 58828 inherited paths, SHA256:
ce729289f461dc25381224eec10619d8b51425915bc2830100c6bb1f44a7654a.
Audit collection SHA256:
13dda776c187d2dcd9c98c26b4bf52d70eac24e8f308ea8f920d75497ded8c23.
Evidence: KEYGEN_PUBLIC_QUOTIENT_171.json and
.build/quotient171/POSTSEAL_171.json.

OPEN: complete inverse and public return1, original root solver,
certificate/codecs and the full corrected134 emitted-packet witness.
Z>0 and concrete positive p_accept/coding/p_K bounds remain open.
Old110, measured wording and the five do_sign obligations are unchanged.
No independent review, second worker, parallel Lean or push occurred.

The same selected source execution now reaches the inverse call after
all 1536 successful tests and divisions. The inverse, solver and final
emitted packet remain open. Probability bounds are not yet established.
