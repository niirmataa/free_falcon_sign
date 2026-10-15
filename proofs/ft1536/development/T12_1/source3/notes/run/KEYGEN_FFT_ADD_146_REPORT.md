#146 — source ADD variants, derived addresses and whole-buffer updates

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Whole success-mass task ACTIVE /
NOT COMPLETE. Actual execution endpoint remains SelectedFftMiddle144.after;
no complete tripling iteration is claimed here. No source/reference/law134
change; frozen110zero unchanged.

## Proven result

FpcAddCompute146.source proves the shared original ADD arithmetic for all
four operand words and legal caller names. FpcAddLocal146.source then proves
the local-output variant, preserving the original temporary scope and all
other caller cells. Output names may alias inputs; distinct output names
and absence of temporary collisions are explicit ordinary source conditions.

FpcAddStore146.source proves the two source-ordered64-bit writes, restoring
all local cells and retaining the full byte frame. It assumes no disjointness
of destination addresses: if they coincide, the second original write wins.
The proof stages writes for an abstract operation kind before instantiating
ADD, preventing the kernel from expanding a large word formula during state
conversion. Arithmetic, statements and limits are unchanged.

FftTripleAddShape146/FftTripleAddCalls146 binds all six actual source sites:
19/20/21 update B0+=C0,B1+=C2,B2+=C1;22/23/24 store A+B0,A+B1,A+B2 at
u+i and u+i+hn. Static caller-name and index-read-set guards are proved.
Together with145, all thirteen tripling macro sites have source rules;
this does not yet compose the full original body.

C99SmallLiteral146 proves original mixed uint64/int32 addition and updates
for literals0..3, retaining modulo2^64 output. FftTripleIndices146 derives
all six ORIGINAL pointer judgments from u+2<hn,2*hn<=n,n<2^64, typed u/hn,
array binding and buffer capacity. It does not assume the pointers.

C99TwoWordBuffer146 and FpcPairBuffer146 preserve a complete represented
word vector under the two ordered writes, with full locals/array/metadata/
outside-buffer frame. FftTripleStore146.source_and_image combines these
facts with each actual store ADD: allocation is derived from the represented
buffer reads, and address arithmetic from the counters. The resulting
symbolic vector is exactly two ordered updates. Remaining caller inputs are
ordinary operand cells, range/context facts and the represented buffer.

## Evidence

ENTRY146 9a1d8e4973f30362cfeaedd6a829aba6983e587c852f87707dba6b077ea2c09e
verified43248 inherited pins from145postseal
ed18fdf9b820a95b267bec04cbe5fd4df7476b226d13a2730ef58414e5992fe2.
Small local source commits0d7a3929,df407193; no push or independent review.

Final audit009 covers11 mathematical modules plus11 isolated audits,
79 named declarations. Accepted0/0 records, complete expression DAG
roundtrip and fresh safe kernel definitions at original types/options are
required; only propext/Classical.choice/Quot.sound. This is self-audit.

Standard-preparser Sage008 compares40 raw-word cases with pinned C ADD:
local outputs, input/output aliasing, distinct and coincident store addresses,
caller temporary-name preservation and buffer frame. Exact ZZ definitions
are reused from pinned145/140. A separate finite256-position slot control
checks coverage of1536 words. All are auxiliary controls, not premises of
kernel theorems, actual tripling-loop execution or probability claims.
Compiler/job logs are0/0; native word outputs are retained as control data.

All9jobs are retained; failed/mixed002/003/004 have explicit causes.
002: implicit cell_at through a heap update, deep state conversion and an
ambiguous byte-frame expression;003: concrete ADD word expansion still caused
deep kernel recursion;004: an Int cast was incorrectly supplied where the
source AST literal expects Nat. Explicit states, abstract-kind staging and
the correct literal type fixed them without increasing limits or suppressing
warnings.145's rejected optional generic expander remains inherited evidence
and is not imported or promoted here.

## Open work

Derive six input loads and two cubic loads, transport source constants,
compose the thirteen macro rules into one exact tripling body and prove its
256-step loop. Then finish the first FFT call, rt2 and later KeyGen. Full
emitted-packet witness and concrete positive Z/p_accept/coding/p_K bounds
remain open. No IID/D1/F04 or measurement premise, no hidden do_sign item;
the measured paper and exactly five do_sign items remain unchanged.
