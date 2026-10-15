# Actual GS computation155

Status after final audit and seal:
PROVED_KERNEL_SCOPED_GS_COMPUTATION / NUMERICAL_GATE_OPEN / NOT_REVIEWED.
Whole owner task ACTIVE / NOT_COMPLETE.

All remaining selected GS helper calls and the complete original ordered
norm computation are now source-proved. The endpoint is
`SelectedGsNorm155.after`. The exact remaining obligation is
`SelectedGsNorm155.NumericalObligation`:
`FprCompare.spec SelectedGsNorm155.finalWord GeneratedBound135.finalWord = 1`.
This equality has NOT been proved. `accepted_of_comparison` and
`norm_prefix` are explicitly conditional on it; they are not GS acceptance
or full KeyGen-success witnesses.

## Source result

`C99VectorLoop155.source` provides shared source-loop induction with a
separately discharged body rule and invariant. `WordMap155.pointwise`
and `GsAutoValues155.pointwise` expose exact indexed vector outputs,
avoiding nested update replay. They preserve the original word arithmetic.

`GsMapShape155` binds the original adjoint and scale bodies.
`GsMapLoop155.source` handles their full loops; `GsMapCall155` includes
actual parameter evaluation/binding, normal return and outside-buffer
frames. `FprOfModulus155.source` proves the source conversion of18433 to
word4670796038414532608. It is not an assumed scale constant.

`SelectedGsAdjoint155.source` closes the entire original GS head from
`SelectedRawNorm151.after`, using154's inverse-norm call and both new
adjoint calls. `SelectedGsScale155.first_source/second_source` execute
both original scaling calls through `KeygenAttemptFft.Call`, preserving
the other buffer and rt3 after each call.

`GsAutoBody155.source` proves the two-store mul-autoadjoint iteration,
including the required read separation after its first write.
`GsAutoLoop155.source` proves the whole loop and preserves the multiplier
buffer. `SelectedGsAuto155` binds and executes both actual calls.
Its `remaining_norm` theorem checks that the remaining GS tail is exactly
the source norm fragment already treated by151; this identity is proved,
not inferred from similar-looking C text.

`SelectedGsNormEntry155` derives the real n/norm/u cells, unchanged bound,
both pointer bindings and both source-proved images. `SelectedGsNorm155`
then executes zero, all1536 ordered square/add pairs and doubling, reusing
the existing norm induction. `tail` proves the entire original GS tail;
`comparison` proves the original comparator execution at its exact word
arguments. Together with the source head and scale calls, this leaves
only the finite numerical comparison for selected GS acceptance.

## Validation

Entry154 verified52751 pins. Twenty mathematical modules expose225 named
declarations. Final audit job014 checks the full expression-DAG roundtrip,
fresh safe kernel definition at the original type and standard three
axioms, in20 sequential processes and225 separate commands. Limits are
unchanged; accepted stdout/stderr must be0/0. Final collection/receipt and
postseal are authoritative for completion. This remains author verification.

Source commitsd8b997c0/34579672/9dc66ae7/0e2b43a6/39dd7e6a are local main checkpoints, without push.
All14 jobs are retained. Mixed job001 accepted the generic source-loop
proof but rejected deprecated `if_neg` in the word-map proof under
warningAsError; replacing it with `ite_eq_right` passed. No warning
suppression, increased limit or ignored failure was used.

Standard Sage job008 compiles the pinned portable C fpr-emulated.c and
falcon-fft.c under the original profile. It runs the actual inverse-norm,
both adjoint, both scale and both mul-autoadjoint functions, then the
ordered source norm expressions. All9985 emitted words agree with the
pinned154 auxiliary candidates. Native output, input, compiler command,
binary, sources and control result are preserved.

The proposed GS norm word is4736654857535133486; the source-proved bound
word is4737176763271429578. They are FPEMU encodings, not probabilities.
The proposed GS word and intermediate candidate vectors still need
kernel finite certificates. Native/Sage agreement is auxiliary evidence
and does not discharge NumericalObligation.

## Remaining scope

Next kernel-certify inverse-norm and subsequent vector values, ordered
norm trace and comparison, using the existing bounded checker and balanced
literal trees. Do not repeat source FFT/GS execution or try one giant
nested numeric evaluation. Then continue the selected solver and final
emitted packet/certificate/codecs before instantiating the seed-atom mass
lemma. Concrete positive Z, population p_accept, conditional coding and
p_K bounds remain open under corrected134.

Frozen110's missing-sqrt model diagnostic remains preserved; it is not a
zero-success claim about real C. Paper wording stays measured. Exactly
five do_sign obligations are unchanged; no IID/D1/F04 identification, new
axiom, worker, schedule, source-C modification or push.
