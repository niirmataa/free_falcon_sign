#144 — all actual middle FFT passes closed

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Whole owner success-mass program
ACTIVE / NOT COMPLETE. C/reference/law134 unchanged; frozen110zero unchanged.

## Proven source result

C99OuterScalar144 proves the original uint64 right shift, mixed signed-zero
assignment and greater-than comparison. FftOuterSetup144 proves original
outer declarations, ht=t>>1,hm=m>>1 and for-clause initializers u1=v1=0 from
typed cells. Scalar-statement and array-language assignment wrappers remain
exactly as parsed. FftOuterFrame144 restores the original lexical scope and
preserves all other locals, object metadata and outside-buffer bytes.

FftOuterStep144.source composes the actual source prologue,143's entire group
loop, t=ht assignment, outer scope restoration and m<<=1. Its result carries
an exact pure word-vector recurrence, typed next controls, readonly table
pins and complete frame. The finite schedule records arithmetic side
conditions, not executions or outcomes. FftOuterInduction144.source proves
the ORIGINAL outer loop by induction on such a schedule, including every
true guard and its final false guard.

FftOuterSchedule144.remaining kernel-checks all side conditions for the
remaining seven actual passes from t384,m4 to t3,m512. The actual caller
Context is derived from sealed142: source-bound arrays/table alias, heap
permissions and exact represented input. SelectedFftMiddle144.exists_source
instantiates the induction, and complete_loop_source prepends the already
proved first outer iteration. ALL EIGHT middle outer passes are now closed
for the first rt1 FFT. The accepted actual instantiation module took7.183s.
No separate numerical butterfly/group execution series was introduced.

The endpoint SelectedFftMiddle144.after is a standard Classical.choose of a
proved execution, with exact symbolic finalValues. This does not supply a
literal evaluated numeric snapshot. FftMiddleContinuation144.after_first/body
composes the entire prior FFT prefix and exposes precisely the original
tripling branch plus skip as the remaining body obligation.

SelectedFftMiddleContext144 proves n1536,hn768,tmin3,full1,logn10, the actual
cubic-table array binding, metadata and outside-buffer frame. The true
profile is logn10/full1: source MKN=(1+2*full)<<(logn-full)=1536. Thus the
tripling initial v is1024, not512. No tripling execution is claimed here.

## Evidence

ENTRY144 222b8f3d34a9b6d9a634fe6c9798674d19696bb68a2ba4869c02e95dd0971871
verified42651 inherited pins from143postseal
9fb8f638e65dd7c5a7226df05b73bf6458b3ce110979df34ec2ab7434d1ba72b.
Local source commits cb5d6a39,4cd41e80,76adc1b6; no push.

Final audit011 covers13 mathematical modules plus13 isolated audit modules,
90 named declarations. Accepted0/0 records, complete expression DAG
roundtrip and fresh safe kernel definitions at original types/options are
required; only propext/Classical.choice/Quot.sound. This is self-audit.
Standard-preparser Sage010 verifies the source profile, seven-pass schedule
and nine uint64 boundary cases in ZZ, as auxiliary controls only. Neither
numeric FFT output nor probability follows from those finite checks.

All11jobs are retained; three failed/mixed001/006/008 have explicit causes.
001: Int/Nat quotient rewrite pattern;006: unexpanded finalValues alias;
008: a NEW context lemma incorrectly guessed logn9 and was refuted by the
kernel. The pinned actual snapshot already had logn10, and only the new
lemma was corrected. Existing source executions/images/seals were unchanged.
No new assumption, warning suppression or raised resource limit.

## Open work

Close the original degree-tripling branch, then the second rt2 FFT and
subsequent KeyGen steps. A verified numeric image may later be needed at
the acceptance gate; native output is not such a proof. The full emitted
packet witness and all concrete positive Z/p_accept/coding/p_K bounds remain
open. No IID/D1/F04 shortcut, empirical premise or hidden do_sign obligation;
the measured paper and exactly five do_sign items are unchanged.
