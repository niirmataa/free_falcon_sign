#148 — first actual FFT call complete; second-call entry prepared

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Whole success-mass program
ACTIVE / NOT COMPLETE. No C/reference/law134 changes; frozen110zero unchanged.

## Proven result

FftTriplingInduction148.prefix_source/source proves the ORIGINAL tripling
loop by induction, reusing147's complete body. It derives each body range
from k<256 with u=3*k,v=2*(512+k), executes the original +3/+2 updates,
preserves the exact vector/table/constants/frame, and proves the final
false guard. The unreachable advance fallback is not used in source steps.
The loop does not assume independent data or replay256 numerical bodies.

FftTriplingSetup148 proves the original branch declaration and for-clause
initialization, including the uint64 cast/left shift by actual uint32 logn10.
SelectedTriplingConstants148 derives all four source FPR constant cells from
the previously source-bound state; the literals are not premises.
SelectedTripling148 instantiates all256 iterations from u0/v1024, proves
u768/v1536 at loop exit, restores the branch v scope and uses actual full1.
FftMiddleContinuation144 then yields the entire first FFT function body.

SelectedFftFComplete148.source closes the ACTUAL rt1 falcon_FFT3 call from
reference NormalizedSmall136.after, including argument binding, body,
void return and caller receive. extended lifts it to corrected133 search
semantics. Caller locals/arrays/globals/tables are exactly retained; the
heap has the proved exact symbolic FFT image. continue_norm starts at the
original rt2 call and does not claim later norm/KeyGen completion.

SelectedFftFFrame148 gives sizes/permissions, readonly pins and the complete
outside-first-buffer byte frame relative to the accepted141 snapshot.
SelectedFftGInput148 derives an initialized1536-word rt2 image from that
ACTUAL source snapshot and transports it through this frame. It does not
assume or newly claim equality with ConvertedWords136.gWord; its definition
is the exact captured source memory that the second call will read.
The second pointer is block31,index1536,count35840,width8, byte span
[12288,24576), outside rt1's [0,12288) span.

SelectedFftGBinding148.binding binds the actual second-call arguments from
the returned caller state, with rt2 pointer,logn10,full1 and original global/
table environments. Its bound state carries the represented input and pins.
The second FFT body has NOT executed here. Both output/input images are
exact symbolic definitions, not assumed native snapshots.

## Evidence

ENTRY148 6fa783f5dcde17ada9f1719ec4e48694d0c515948ee764af3b8d2cef21a03b6d
verified44573 inherited pins from147postseal
8e42d926730a54abc641de1610ed8c2950890a91bbbfdddf7ff908cebf3ae1fd.
Own source commits e769500b,e35a9c7a,e9e09b0d; no push.

Final audit012 covers14 mathematical modules and29 isolated processes for
92 declarations. At most four declarations per process bound cumulative
command cost; exact ordered complete coverage and current source/artifact
hashes are checked. Original full DAG roundtrip, term comparison and fresh
safe kernel checking remain, with fixed options/limits,0/0 logs and only
propext/Classical.choice/Quot.sound. This is self-audit, not independent review.

Standard-preparser Sage011 checks the source counter/index schedule and
buffer byte spans in ZZ. It is auxiliary only and supplies no numeric FFT
output, whole-KeyGen success or probability premise. All12jobs are retained;
failed/mixed002/005/007/009 have explicit causes: large concrete symbolic
heap transport, a source alias rewrite, constructor-hole goal ordering and
a caller alias/reflexive condition rewrite. A fresh existential body endpoint
and explicit arguments resolve the proof-engineering issues without higher
limits, warning suppression or new assumptions.

## Remaining work

Execute the second FFT from SelectedFftGBinding148.bound, preferably using
a generic first-pass rule plus the existing middle/tripling inductions.
Then continue the original norm/Gram-Schmidt/solver/certificate/codec path.
A later numeric image must be equated to these symbolic images by proof.
Full emitted-packet witness and concrete positive Z/p_accept/coding/p_K
bounds remain open. No IID/D1/F04 shortcut or hidden do_sign obligation;
measured wording and exactly five do_sign items are unchanged.
