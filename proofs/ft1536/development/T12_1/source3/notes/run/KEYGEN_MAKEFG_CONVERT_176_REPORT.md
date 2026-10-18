# Actual make_fg conversion176

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Whole owner goal ACTIVE / NOT_COMPLETE.
Sources bbaed752, e6a3ab96, c1504bc0.

SelectedMakeFgConvert176.part_source constructs the original make_fg part1
from SelectedMakeFgEntry175.entry after its original declarations. It runs
MKN, selects PRIMES3[0].p = 2147355649, and performs both int16-to-modp_set
stores for every one of the 1536 source-derived f/g coefficients.
Word32Memory176 and MakeFgConversionLoop176 prove the memory operations
and full counted loop parametrically. SelectedMakeFgConvert176.f_image /
g_image identify both complete output arrays with the original sampler
words; the frame preserves inputs and bytes outside the output ranges.
SelectedMakeFgRange176.f_range / g_range prove canonical residue bounds.

SelectedMakeFgDispatch176.source executes the actual false early-return
branch at depth10/out_ntt0. SelectedMakeFgTopEntry176.binding constructs
the original ternary-top call at logn10/out_ntt1, and initialized proves
its 3072 input words exist in the actual resulting heap.
SelectedMakeFgContinuation176.source remains conditional on the original
ternary-top body and remaining step-loop executions. It is a composition
lemma, not a claim that make_fg or the root solver has completed.

Fifteen mathematical modules /148 named declarations passed full expression
DAG roundtrip and fresh safe kernel checks in audit225, with15 sequential
processes and only propext/Classical.choice/Quot.sound. Accepted stdout and
stderr are empty:0 errors/0 warnings. MakeFgSyntax176 only serializes
source-bound syntax and is excluded from the mathematical declaration count.
No new Sage numerical certificate was needed; source execution, finite
counter arithmetic and three coefficient cases are kernel proved directly.

Jobs211-225 are retained. Failed or mixed212/215/216/217/218/219/220/221/222
are explained in KEYGEN_MAKEFG_CONVERT_176_FAILURES.json. In particular,
the selected heap transport exceeded the unchanged heartbeat limit until
it was split into shallow record updates and an existing heap theorem.
No resource limit, source C, reference semantics or mathematical condition
was weakened. A lookup used the wrong relative roadmap path; the tracked
run2/notes/B1_STAGED_ROADMAP.md was located and read, with no missing pin.

ENTRY176 verified61059 inherited paths, SHA256
434b77ee585d17f69304e97c13dd7a9d684f5016656c5638e784404c857b471a.
Audit collection SHA256
2b57e973548603a92583116c123db732fcefe0dd28856baa47f9ef9580b335ae.
Receipt and postseal are KEYGEN_MAKEFG_CONVERT_176.json and
.build/makefg176/POSTSEAL_176.json.

OPEN: ternary-top execution, nine make_fg_step calls, CRT/Bezout and
multiplication gates, intermediate/depth0/root validation, certificate and
codecs, then the full emitted witness for KeygenProbability134.
Old110 remains frozen; no unconditional Z>0, numerical p_accept, coding
or p_K bound is claimed. No IID/D1/F04 or measured-rate premise was used.
The paper remains measured; exactly five do_sign items remain unchanged.
No independent review, duplicate worker or push.

The selected source conversion is now complete for both full input arrays.
The substantive solver and final emitted packet still require source proofs.
This checkpoint supplies no new positive probability bound.
