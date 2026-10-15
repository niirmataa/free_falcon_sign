# Actual raw-norm computation151

Status: PROVED_KERNEL_SCOPED_COMPUTATION / NUMERICAL_GATE_OPEN / NOT_REVIEWED
after final audit/seal. Whole owner success-mass task ACTIVE / NOT_COMPLETE.

`KeygenNormInduction151.source` proves the original ordered loop with two
additions per iteration, source square/add calls, all guards/increments,
final false guard, and unchanged heap. The body is proved once; composing
abstract result words first avoids reduction of large FPR expressions in
intermediate state types. There is no reassociation or exact-real shortcut.

`SelectedRawNorm151.computation` proves the ENTIRE original raw-norm code
from reference SelectedBound135.after: both small conversions, both actual
FFT calls, zero initialization,1536 iterations and doubling. The raw-norm
spine remains KeygenSearchExec/KeygenNormFrame, as required by133; only bound
initialization uses the extended scalar closure. Both FFT images remain
unchanged. Actual new state SelectedRawNorm151.after, immediately before
the raw-norm rejection gate.

`SelectedRawNorm151.comparison` supplies the original fpr_lt object-copy
source execution at the exact symbolic finalWord and source-derived bound
word4737176763271429578. `NumericalObligation` is explicitly OPEN:
FprCompare.spec finalWord GeneratedBound135.finalWord = 1.
`accepted_of_comparison` is conditional on this unproved finite equality;
it is not an accepted gate witness and is not a new premise of any completed
KeyGen or probability theorem.

Failed/mixed jobs001/005 are retained:001 hit unchanged recursion limits
when state composition exposed nested FPR words; abstract word composition
resolved it.005 attempted direct decide +kernel on the complete numerical
comparison and exceeded the unchanged kernel memory limit. This proves
neither acceptance nor rejection. No raised limit or warning suppression.
Jobs001/002/003/004 supply all9 accepted mathematical modules with0/0 logs.
Job007 audits70 declarations in20 sequential processes, full unchanged DAG
roundtrip and fresh safe kernel definition, allowed standard3axioms.

Sage006/native pinned-C control proposes doubled norm word4704131856579166192
(0x41486efffffffff0), versus bound4737176763271429578; native comparator1.
Sage ZZ independently checks all3072 additions/squares on the native FFT
word vectors. Candidate SHA256
f586d16a9da07b6367374216852faf6462292834230ec58e2953e5e656bd772b.
This is finite diagnostic evidence only: equality of those native vectors
with the exact symbolic Lean FFT images is not yet kernel-certified.

Source commits94a48554/40fa743e. Next: staged numerical image certificates
and the original norm gate, then GS/division/solver/emission/codecs. No
concrete positive Z/p_accept/coding/p_K is claimed. Corrected134 target,
frozen110zero history, measured wording and five do_sign items unchanged.
No push, new worker, independent review, empirical premise, IID or F04.
