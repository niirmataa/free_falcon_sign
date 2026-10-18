# Complete selected source generator call181

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Selected generator invocation: COMPLETE.
Whole owner goal ACTIVE / NOT_COMPLETE.
Source commits: bbd23d49, 51561490, cb1b698e.

GeneratorSquareBody181.source constructs the original scoped square body,
including its v declaration, doubled child index and both stores. The
inverse-table read is taken after the first actual store, preserving the
source evaluation order. Initialization monotonicity supplies that read;
no stale heap or assumed word value is substituted. GeneratorSquareLoop181
constructs all 255 descending iterations, u=255,...,1, ending at u=0.
Its invariant derives both tables' readable region down to index1.

GeneratorTopSource181.source constructs the original three topElements:
copy gm[1] to gm[0], load w from gm[1], and store igm[0] from the exact nested
modp_add/modp_sub/modp_div expression. Source-existence lemmas for all scalar
callees are reused, including the complete modp_div from178. R/R2 and the
w declaration are transported through the actual previous executions.
Both complete 1024-word buffers become source-established readable data.

SelectedGeneratorTop181.body_source is the COMPLETE original
KeygenMkgm3Program.code execution at SelectedGeneratorEntry178.entry.
SelectedGeneratorCall181.source is the actual KeygenLevelCalls.Call .generate,
with its proved argument binding and ReturnValue.voidEnd; instruction embeds
it in the original ternary-top body. This closes the selected logn10/full1,
first-prime modp_mkgm3 invocation. It is not a claim for every parameter set
and does not yet close make_fg_ternary_top or the root solver.

SelectedGeneratorCall181.forward_table consumes this new complete execution
in the existing KeygenMkgm3Assembly.source_table theorem. The result is the
full canonical gm table, all indices0..1023. both_initialized and
SelectedGeneratorFrame181.g_read/i_read give actual reads of both buffers.
The frame's f_image/g_image preserves the same full1536-word converted
sampler inputs at fs/gs through the entire call. Sizes are preserved;
bytes preserves other blocks and scratch offsets below19064. The inverse
table is proved readable here; no new algebraic inverse-table claim is made.

All 13 mathematical modules / 76 named declarations passed full expression
DAG roundtrip and fresh safe kernel checking in audit287, in 13 sequential
processes. Only propext/Classical.choice/Quot.sound were allowed. Accepted
stdout/stderr are empty: 0 errors / 0 warnings. All new claims are parametric
or source/word kernel proofs; no new external numerical experiment was
required. Existing source, STATIC and canonical-root facts were reused.
No C/reference semantics, resource limit or mathematical condition changed;
no warning was hidden. No independent review or push occurred.

History281-287 has seven jobs and two failed or mixed jobs. Job281 accepted
the domain frame, then exposed a missing shallow heap reduction and an
application line parsed as a new tactic. Job285 accepted the complete top
suffix and actual generator call, then exposed an unexpanded caller-state
alias in the f/g transport. Both repairs preserved the exact statements and
source operations. Exact causes and logs are retained in the failure ledger.
There were no controlled cancellations or relaxed limits in this checkpoint.

ENTRY181 verified 64490 inherited paths; SHA256:
d6bda72f5938d1f7811f8bb624aae57f41ea86a25136680b69a05d8f42491875.
Audit collection SHA256:
a50a9e86f0cc2fabbbc48180845a79371af7b490977255c731416c1da8c69c9f.
Receipt: KEYGEN_GENERATOR_FINISH_181.json.
Postseal: .build/genfinish181/POSTSEAL_181.json.

| Owner point | Current status | Exact boundary |
| --- | --- | --- |
| Full source seed witness and positive mass | PARTIAL | The selected generator body and actual call are complete. Both forward NTTs and the remaining top/make_fg/root/encoding path stay open; no full emitted witness or unconditional Z>0. |
| Numerical first-attempt acceptance bound | OPEN | No numerical p_accept bound, including1/4, is established by this checkpoint. |
| Conditional coding and quantitative p_K | OPEN | Source coding success and a concrete positive p_K remain unproved. |

Next are the two original 32-bit modp_NTT3 calls at
SelectedGeneratorCall181.after, then R3/top triple products, nine make_fg_step
calls, CRT/Bezout/carry tests, intermediate/depth0/root validation and
certificate/codecs. The emitted-witness target remains corrected
KeygenProbability134; old110 stays frozen. No IID/D1/F04 or empirical premise
was introduced. The paper retains measured8192/23628 and the separate256/739
control; exactly five do_sign obligations remain unchanged.

The entire selected source generator call is now constructed and kernel checked.
Its full gm table and both preserved input images are available for the original forward calls.
The complete emitted KeyGen witness and all requested positive probability bounds remain open.
