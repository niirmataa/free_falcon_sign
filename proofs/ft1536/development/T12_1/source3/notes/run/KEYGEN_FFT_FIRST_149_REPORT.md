# First FFT pass 149

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED after the final audit and seal.
Whole owner success-mass task: ACTIVE / NOT_COMPLETE.

The first pass of the original `falcon_FFT3` now has a reusable source proof
for arbitrary input words and a legal buffer. `FftFirstBody149.source` covers
the original declaration, two loads, nested FPR calls, ordered stores and
local-scope restoration. `FftFirstBuffer149.source` derives its two pointer
expressions from natural bounds and source cells, carries the exact complete
word image, and preserves all bytes outside the logical buffer.

`FftFirstInduction149.source` proves the ORIGINAL loop for any `n, hn, u`
satisfying the explicit structural invariant and `u <= hn`: exactly `hn-u`
iterations, the source increment, final `u=hn`, and final false guard. The
output is `FftFirstInduction149.values n hn length wr wi (hn-u) u input`.
These are conditional execution lemmas with the legal entry state stated
in their types; they do not assume a callee result, independence, a float
oracle, or a KeyGen success event. Their entry facts must still be derived
for the selected second call from `SelectedFftGBinding148.bound`.

Evidence: jobs001/004/005 build all eight mathematical modules with 0/0
logs. Jobs002/003 preserve two elaboration failures and their causes. Job006
runs standard Sage on exact ZZ schedule/coverage/span controls, including
two deliberately shortened/lengthened schedules; auxiliary only. Job007
audits all53 declarations in17 sequential processes using the unchanged
full DAG roundtrip and fresh safe kernel definition at the original type,
with only propext/Classical.choice/Quot.sound allowed. Receipt and postseal
are produced only after all checks succeed. Source commits:5e6c5bbb,0810d740.

The actual execution endpoint is unchanged from148: first rt1 FFT call
complete, second rt2 call binding/input ready. No additional actual selected
FFT iteration or second-call completion is claimed in149. The new generic
loop removes the need to repeat the old per-chunk numerical replay. The
next step is second-call setup followed by existing first/middle/tripling
lemmas and actual caller return. Later norm/Gram-Schmidt/solver/codecs and
the concrete positive Z, acceptance and coding bounds remain open. The
explicit corrected law134 remains the target; frozen110 and its131zero
diagnostic are preserved. No real-C zero-success claim follows.

No production C change, new axiom, probability premise, resource increase,
warning suppression, push, independent review or extra worker. Paper
wording remains measured; exactly five do_sign obligations are unchanged.
