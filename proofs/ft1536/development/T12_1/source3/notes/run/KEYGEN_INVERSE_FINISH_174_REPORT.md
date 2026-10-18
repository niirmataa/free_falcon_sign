# Complete selected public computation174

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Whole owner task NOT_COMPLETE. Sources1cca11a6 and ca0d7c14.

SelectedPublicSuccess174.source proves the actual KeygenPublicSource.Call
from SelectedPublicBinding157.before to SelectedPublicSuccess174.after
returning int32(1). SelectedPublicSuccess174.gate closes the original
falcon_compute_public acceptance gate in the same selected attempt.
No public-call execution premise remains. continue_search has exactly
the separate, still-open original NTRU RootGate as its execution premise.

This closes the complete public path accumulated in167–174: fresh local
arrays, full generated tables, both forward calls, their source-derived
polynomial values, every nonzero denominator test, all1536 divisions,
512 inverse triples, eight reverse radix rounds,768 first-root inverse
butterflies, the live ni=div18433(10237,n) branch,1536 normalization stores,
inverse wrapper, original return1 and local-array disposal. The proof
uses the already-constructed samplers and both norm gates156 unchanged.

Eleven new modules /54 named declarations passed full expression-DAG
roundtrip and fresh safe kernel checking in audit197,11 sequential
processes, only propext/Classical.choice/Quot.sound. Accepted jobs193–197
have empty stdout/stderr,0 errors and0 warnings. Mixed194 is retained:
the selected root pass succeeded, while a record indentation error in the
normalization body was rejected; the corrected source passed195.
No limit increase, warning suppression, new premise, C/model modification,
independent review or push.

ENTRY174 verified60003 inherited paths, SHA256:
455dfccff8bae80401f71770d85eaf1fe757fbd0280a8331d5c5b0e7d7ee90f0.
Audit collection SHA256:
a74de4f9993097f1e22212a54af776cfe852095ac295b871b254ebedbe95f1ae.
Evidence: KEYGEN_INVERSE_FINISH_174.json and
.build/finish174/POSTSEAL_174.json.

Owner task status:
| Obligation | Status | Exact limit of this checkpoint |
|---|---|---|
| Full emitted KeyGen witness and Z≥2^-256 | PARTIAL | Public call now returns1; root solver, certificate/codecs and final packet still open |
| Numeric p_accept bound from actual KeyGen law | PARTIAL / NO NUMERIC BOUND | No kernel counting/integration bound for the actual seed→SHAKE→sampler acceptance event; F04 and measured S1 values are not premises |
| Coding conditional on acceptance and numeric p_K | OPEN | Source coding-success bound and its quantitative first-attempt corollary still unproved |

KeygenSuccessMass134.success_lower_of_witness and
KeygenModelUnlock134.package_of_witness remain conditional consumers:
their full emitted-execution input is not yet discharged. No Z>0,
p_accept≥1/4 or positive numeric p_K is claimed. This is a missing proof,
not evidence that valid keys are rare or that the analytic route is
impossible. The target remains corrected KeygenProbability134; old110
is frozen with its recorded model-coverage issue. The paper remains
measured (8192/23628 and the distinct256/739 control), and the five
do_sign obligations are unchanged.

The full selected public-key computation is now a kernel source theorem.
The original NTRU solver and emitted packet remain the next concrete gap.
Probability bounds remain unproved and measured observations stay measured.
