# Constructive public forward call167

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Owner task ACTIVE / NOT_COMPLETE. Source commit24c7bcf0.

PublicForwardMemory167 derives legal input extent and disjointness from
initialized writable input and two fresh automatic blocks, and constructs
the generator table domain after allocation. PublicForwardDomains167
derives every first-pass and complete-tail input from that memory and the
complete166 generator output. PublicForwardCleanup167 proves the original
two scope exits restore freshness. PublicForwardConstruct167.source then
constructs the entire forwardT execution and cleanup; .call adds the
original mq_NTT wrapper. No generator/tail/callee execution is an input.
The remaining inputs are legal caller memory and scalar/pointer bindings,
not probabilistic hypotheses. Concrete selected caller instantiation is
still the next step.

Four modules/22 declarations passed full expression-DAG roundtrip and
fresh safe kernel audit in job142, four sequential processes, standard
axioms only. Accepted jobs141/142 have empty stdout/stderr,0 errors and
0 warnings. Failed job140 is retained: decide could not reduce pointer
projections containing free block IDs; explicit arithmetic change fixed
the proof without strengthening its hypotheses or changing the model.
All57140 inherited166 pins verified at resume and are rechecked by seal.

ENTRY167 SHA256:
32bf19e7a5b7ba8e2d61cf2fa76173e0d4637a2a7d4df17dca440086898688a2.
Audit collection SHA256:
d4e2f30568e9a07717289af2236ef510675af1da3ca6ebef7039ba0981cb0286.
Exact evidence/postseal: KEYGEN_PUBLIC_FORWARD_167.json and
.build/forward167/POSTSEAL_167.json.

OPEN: both concrete forward calls, public nonzero/division/inverse/return,
root solver, certificate/codecs, G(seed*) and numeric positive acceptance,
coding and whole-law bounds. Corrected134 remains the target; old110 is
not relabelled. The paper remains measured and do_sign has exactly five
unchanged obligations. No C/model change, new axiom, limit increase,
independent review, push or worker was introduced.
