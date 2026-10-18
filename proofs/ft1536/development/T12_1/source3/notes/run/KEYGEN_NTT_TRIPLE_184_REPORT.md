# Complete first selected source modular forward call184

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Selected first32-bit forward invocation: COMPLETE.
Second forward invocation and the remaining solver/encoding path: OPEN.
Whole owner goal ACTIVE / NOT_COMPLETE.
Source commits: aa76efa9, 06753d6e, 2305bd39, 3dfc083d.

NttTripleAddress184 constructs the actual stride and table addresses.
NttTripleStates184 records the original words and successive local/memory
states. NttTripleLoads184 and NttTripleScales184 construct both declarations,
the gm[r] read, x2, the three input reads and all six scaled words in the
original source order. All three input words are read before any store.
The source-bound scalar callee bodies are reused; no independent word value,
canonical-range premise, abstract transform or native trace is substituted.

NttTripleStores184 constructs the exact three final sums and stores, including
the distinct fB1/fC2 and fB2/fC1 pairings. ModularStore184 and ModularSum184
prove the word conversion and nested sum once for arbitrary words.
NttTripleCells184 and NttTripleStoreCells184 explicitly transport existing
local values through the two earlier heap-only writes. NttTripleBody184.source
composes these checked atoms into the entire original scoped tripleBody.
NttTripleFrame184 proves precise1536-word writes, restored local/pointer
cells and preservation of actual byte initialization.

NttTripleControl184 constructs the original u+=3, r++ and r1+=3*stride.
NttTripleEntry184 constructs u=0, the actual uint32(logn-1) shift count,
(size_t)1<<9=512 and r1=a. NttTripleLoop184.full constructs every one of the
512 iterations, deriving input/table reads from the current heap and
preserved separation. The actual false guard occurs at u1536, with r1024.
The source body is proved once parametrically and reused by induction.

NttTripleSquare184 constructs the preceding wSquared assignment from two
actual gm[1] reads and source Montgomery multiplication. Its Fixed result
contains the NEW w value; the old first/middle-pass w is not retained.
NttTriplePass184.full includes this assignment, initialization, complete loop,
full1 branch, exact scope restoration and trailing skip. The new w is
returned with its established state invariant.

SelectedNttTriple184.source instantiates the complete triplePass at
SelectedNttMiddle183.after. body_source composes it with the already-closed
original prologue, first pass and eight middle rounds to yield the COMPLETE
KeygenNttForwardPrograms.forwardBody at SelectedForwardEntry182.entry.
SelectedForwardCall184.source constructs the actual first
KeygenLevelCalls.Call .forward and ReturnValue.voidEnd; instruction embeds
it in the caller's original top body. This is the selected fs/logn10/full1/
stride1/first-prime invocation, not a claim for every parameter set.

SelectedForwardFrame184.combined_frame relates the complete call's caller
heaps and modifies only scratch block31 bytes [6776,12920). g_image preserves
the entire second converted input and gm_table preserves the complete
canonical table. a_read establishes readability of the transformed first
input without asserting equality to its old image. Caller locals and array
bindings are unchanged. The next obligation is exactly the original second
forward call followed by TopForwardShape182.remaining.

All 20 mathematical modules / 121 named declarations passed full expression
DAG roundtrip and fresh safe kernel checking in audit317, in 20 sequential
processes. Only propext/Classical.choice/Quot.sound were allowed. Accepted
stdout/stderr are empty: 0 errors / 0 warnings. No external numerical
certificate was required: source execution, word operations and finite
indices are proved by the kernel. C/reference semantics and resource
limits are unchanged; no warning was suppressed. No independent review
or push occurred.

History308-317 has 10 jobs and 7 failed or mixed jobs309-315. Jobs309 and314
reached the existing 2,000,000-heartbeat limit during elaboration;309 also
exposed an unchanged-heap alias. Job310 exposed unnecessary copied helper
parameters, which were removed. Jobs311/312/313 were deliberately stopped
(exit143 after285.934/132.982/110.041 seconds) while investigating store
elaboration cost; their exact receipts/logs remain. Generic word-store and
explicit-sum factoring alone did not solve that cost. The completed314
failure located it at local-cell arguments crossing heap-updated states;
explicit Slot transport then accepted all stores in33.892 seconds in315.
That mixed job also accepted the complete triple body and memory frame,
then exposed counter-view aliases repaired in316. There were no increased
limits, hidden failures or silent replacement of an accepted source module.

ENTRY184 verified 66224 inherited paths; SHA256:
179e0b9cd7572763cab009e06049b3d7ca3b7430f578cbf3e668da9265167122.
Audit collection SHA256: 9d57afba24709223d4d11e019ea542e24e1b7a0a94d8ccf6ff0c2263f8538726.
Receipt: KEYGEN_NTT_TRIPLE_184.json.
Postseal: .build/ntttriple184/POSTSEAL_184.json.

| Owner point | Current status | Exact boundary |
| --- | --- | --- |
| Full source seed witness and positive mass | PARTIAL | The entire first modular forward call is constructed. The second call and later solver/encoding path stay open; no complete emitted KeyGen witness or unconditional Z>0. |
| Numerical first-attempt acceptance bound | OPEN | No numerical p_accept bound, including1/4, follows from this checkpoint. |
| Conditional coding and quantitative p_K | OPEN | Source coding success and a concrete positive p_K remain unproved. |

The emitted-witness target remains corrected KeygenProbability134; old110
stays frozen. Existing package_of_witness and success_lower_of_witness
remain conditional on the complete source witness. No IID/D1/F04 or
empirical premise was introduced. Paper wording stays measured8192/23628
with the separate256/739 control. Exactly five do_sign items remain:
key/certificate transport; AttemptShape/ReplyShapeAt; PointwiseStageRoad's
four conditions; rounding/int16/syndrome; sampler loop and honest-signing
PRG hybrid.

The first entire selected modular forward call is now constructed and kernel checked.
Its exact caller-state frame preserves the second input and canonical table for the next original call.
The complete emitted KeyGen witness and all requested positive probability bounds remain open.
