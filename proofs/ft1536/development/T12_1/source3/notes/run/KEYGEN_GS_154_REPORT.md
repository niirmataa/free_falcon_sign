# First actual GS helper154

Status after successful final audit and seal:
PROVED_KERNEL_SCOPED_ACTUAL_GS_INVNORM / NOT_REVIEWED.
Whole owner task ACTIVE / NOT_COMPLETE.

`SelectedGsInvNorm154.source` proves the ACTUAL first GS helper call,
`falcon_poly_invnorm2_fft3(rt3,rt1,rt2,10,1)`, from
`SelectedRawNorm151.after`, the state reached by the accepted raw-norm
gate153. It includes caller argument evaluation/binding, dimensions,
all 768 iterations, scope handling, normal function return and discard.
The new caller endpoint is `SelectedGsInvNorm154.after`.

`SelectedGsContinuation154.shape/source` binds this call to the original
`KeygenAttemptNorm.headCode`. Its remaining source program contains the
two adjoint calls. No GS acceptance, solver success or full emitted-packet
witness is claimed.

## Exact arithmetic and memory

`FprDivWords154.iterations` refines the existing division round theorem
to an exact pair of remainder/quotient words. `FprDivSuffix154.source`
preserves the original sticky bit, normalization, signed exponent work,
zero correction and FPR rounding. `FprDivFast154.execution/model/source`
prove the explicit word implementation equals the existing interpreter
and has the original C source-call derivation for every pair of 64-bit
words. `FprInvFast154.source` supplies the original header call, using the
pinned fpr_one constant. No real-number division or error approximation
replaces these word operations.

`GsInvNormShape154.source` binds the complete callee syntax to the pinned
C. The arithmetic expression groups the two a squares and two b squares,
then adds them before inversion, exactly as in the source.
`GsInvNormBody154.source` proves one parametric source iteration with
four loads, one result store and scope restoration.
`GsInvNormLoop154.source` derives the entire loop by induction; initial
output words are not required. The invariant preserves both input images,
allocation metadata and the complete written output prefix.

`SelectedGsBinding154.binding` evaluates the actual rt1/rt2/rt3 pointers
and logn/full arguments. `SelectedGsEntry154.fixed` discharges the generic
premises from existing source facts: n=1536, hn=768, scratch block31 of
286720 bytes, input spans [0,12288) and [12288,24576), and output span
[24576,30720). Pointer arithmetic, writable permissions, allocation and
separation are proved, not supplied as new assumptions.
`SelectedGsInvNorm154.image` gives the exact 768-word output formula;
`first_image/second_image` retain both kernel-certified FFT inputs.

## Validation and provenance

Entry153 verified51996 pins. Fifteen mathematical modules expose143 named
declarations. Final audit job016 checks every declaration with the unchanged
full expression-DAG roundtrip, fresh safe kernel definition at its original
type and three allowed axioms. It uses15 sequential Lean processes and143
separate commands, unchanged resource limits and accepted logs0/0. The final
collection, receipt and postseal determine successful completion; this is
author verification, not independent review.

Source commits32b868ac/eb0e6148/f4ca404f are local main checkpoints, without push.
All16 jobs are retained. Failed/mixed jobs001/002/004/005/008/011 have exact
causes in KEYGEN_GS_154_FAILURES.json: reserved identifier, pattern-match
elaboration, rejected incorrect declaration-list proposal, deprecated lemma
warnings, Sage metadata serialization, and guard-expression elaboration.
The rejected syntax proposal was corrected to the actual C declarations;
no failed check was ignored. One initial launch timed out in automatic
permission review before creating a process or job directory; that separate
launch record is retained. Its single retry started job001.

Standard Sage job009 uses exact ZZ operations and compares976 input pairs
against pinned portable C div/inv and fpr_of(18433):144 boundary pairs,
64 deterministic diagnostic pairs and768 selected inverse-norm denominators.
The resulting controls are auxiliary, not universal or probability premises.
GS154_CANDIDATES.json SHA256
dcc03ce308ed26ab1e17578ec0884e3d0487d716df97877ccabeb37ae22b987b
contains denominator/inverse/adjoint/scaling/product vectors and an ordered
norm trace; its proposed final GS norm word4736654857535133486 is NOT yet a
kernel-certified GS value or acceptance theorem.

## Remaining work

Continue the original adjoint calls, scaling by source fpr_of(18433), both
mul-autoadjoint calls, ordered norm/double and comparison. Numerical
candidate equalities also remain open. The full seed witness, emitted
packet/certificate/codecs and concrete positive Z, p_accept, conditional
coding and p_K bounds remain open. The active law is corrected134;
frozen110's missing-sqrt model defect remains recorded and is not a claim
that real C has zero success mass. Measured paper wording and exactly five
do_sign obligations remain unchanged. No IID, D1, F04 identification, new
axiom, new worker, schedule, source-C modification or push.
