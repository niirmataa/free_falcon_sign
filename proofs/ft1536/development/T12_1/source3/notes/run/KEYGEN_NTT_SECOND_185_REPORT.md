# Both original selected modular forward calls185

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Both selected32-bit forward invocations: COMPLETE.
Top products and the remaining make_fg/root/encoding path: OPEN.
Whole owner goal ACTIVE / NOT_COMPLETE.
Source commits: 83f8f62f, 1a7a61b0, a117477f.

NttWholeSource185.source composes the existing original prologue, first pass,
eight middle rounds and final triple pass into one parametric complete
forwardBody construction for logn10/full1/stride1. It transports actual
table reads, initialization and control cells between the executed phases.
The final phase retains its actual wSquared assignment and returns the
new w with the output invariant. The generic theorem explicitly lists its
input/memory/separation conditions; all are discharged at the selected
second-call entry below. No transform oracle or new mathematical premise
is introduced, and no individual butterfly proof is repeated.

SelectedSecondEntry185.binding constructs the original gs argument binding
at SelectedForwardCall184.after, the actual caller state after the first
call. SelectedSecondInput185.g_read derives the second input from the
preserved converted sampler image. table_reads/twiddle_read derive actual
gm reads, separate proves the concrete layout separation, and input derives
every allocation, initialization, writability and scalar/pointer condition.
The second construction does not restart from the pre-first-call heap.

SelectedSecondBody185.source instantiates the complete original forwardBody
at this second entry. SelectedSecondCall185.source is the actual second
KeygenLevelCalls.Call .forward with ReturnValue.voidEnd; instruction embeds
it in the caller. both_source composes both original forward instructions
in order. continue_top leaves exactly TopForwardShape182.remaining, not an
unmentioned extra execution assumption hidden in do_sign.

SelectedSecondFrame185.caller_frame confines second-call writes to block31
bytes [12920,19064). f_read preserves every established word of the first
transformed input; f_readable/g_readable provide actual reads over all1536
words of both transformed buffers. The canonical gm is unchanged. Paired
byte/size/writability facts relate both calls to the original caller heap,
with possible writes only in [6776,19064). Caller locals and array bindings
are unchanged. Neither transformed input is claimed equal to its old image.

SelectedSecondMetadata185 exposes the actual caller p/p0i/R2, logn10,
n1536/dn1024/tn512, out_ntt=int32(1), declared R3/u/v cells, all six pointers
and scratch writability. TopProductShape185.shape binds the next original
source remainder to R3 assignment, product loop and tail. Those operations
are still required before claiming the complete make_fg_ternary_top call.

All 8 mathematical modules / 70 named declarations passed full expression
DAG roundtrip and fresh safe kernel checking in audit321, in 8 sequential
processes. Only propext/Classical.choice/Quot.sound were allowed. Accepted
stdout/stderr are empty: 0 errors / 0 warnings. No external numerical
certificate was needed: this is source-proof composition and direct kernel
verification of finite layout facts. C/reference semantics and resource
limits are unchanged; no warning was suppressed. No independent review
or push occurred.

History318-321 contains 4 accepted jobs and no failed/mixed job or controlled
cancellation in this checkpoint. The empty185 failure ledger records that
fact; all historical failures, including184's elaboration attempts and
three controlled cancellations, remain pinned and preserved.

ENTRY185 verified 66977 inherited paths; SHA256:
e117f2efd3ef2a60d035c5b3fc43af683ea078c5221f7c66f8e8a3964238af4f.
Audit collection SHA256: 8c4e371d0544d06bf4dd3ec46db5a285a876aa621e6a0cb9e01b1cab71b0cd05.
Receipt: KEYGEN_NTT_SECOND_185.json.
Postseal: .build/nttsecond185/POSTSEAL_185.json.

| Owner point | Current status | Exact boundary |
| --- | --- | --- |
| Full source seed witness and positive mass | PARTIAL | Both original modular forward calls are constructed. Top products and the remaining solver/encoding path stay open; no full emitted KeyGen witness or unconditional Z>0. |
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

Both entire selected modular forward calls are now constructed and kernel checked in their original order.
The second call preserves the first transformed input and canonical table, and the next source remainder is explicit.
The complete emitted KeyGen witness and all requested positive probability bounds remain open.
