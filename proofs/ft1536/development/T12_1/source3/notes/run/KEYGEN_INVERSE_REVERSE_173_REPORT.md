# All eight selected reverse radix rounds173

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Whole owner task ACTIVE / NOT_COMPLETE.
Sources da0f5a66,9842053c,e86316ff.

SelectedReverse173.source constructs the original reverse section on
SelectedInversePrefix172.last, including t=6 and m=256 initialization,
all inner/group loops and all eight rounds, ending at t=1536/m=1.
The actual butterfly stores a0+a1 and mont(a0-a1,s); it uses the raw
second input rather than the forward multiply-before-add assignment.
Existing allocation, control, scalar and memory frame proofs are reused.
The selected output arrays, n/hn/u/profile and r/ni declarations are
derived. continue_inverse retains exactly the remaining first-root
inverse and normalization; full inverse execution is still open.

Fifteen modules / 75 declarations passed full expression-DAG roundtrip
and fresh safe kernel checks in audit192, 15 sequential processes, only
propext/Classical.choice/Quot.sound. Accepted logs are empty, 0 errors and
0 warnings. Mixed187 is retained: read/write/body modules passed, while
restricted simplification did not identify the two source guard aliases;
an explicit kernel-checked equality fixed it. Jobs188–192 passed.
No new numerical certificate, premise, resource setting or model change.

ENTRY173 verified 59549 inherited paths, SHA256:
ead48c4395738070e66f0fbd9a342717a15065fc3535ba9a9146de671762f7ef.
Audit collection SHA256:
becac710a9501163f8135ac42a2be125db1c7a20f126401be1d218210e658735.
Evidence: KEYGEN_INVERSE_REVERSE_173.json and
.build/reverse173/POSTSEAL_173.json.

OPEN: first-root inverse, normalization, full public return1, root solver,
certificate/codecs and corrected134 emitted witness. Z>0 and concrete
acceptance/coding/p_K bounds remain open. Old110, measured wording and
exactly five do_sign obligations are unchanged. No review status or push.

All selected reverse radix rounds now have constructive source execution.
The last inverse pass, normalization and later KeyGen work remain open.
The new source result does not establish a probability bound.
