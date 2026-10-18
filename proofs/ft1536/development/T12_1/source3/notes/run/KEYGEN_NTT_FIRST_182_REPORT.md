# Selected source modular NTT first pass182

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Selected first forward invocation: PREFIX COMPLETE; middle/triple passes OPEN.
Whole owner goal ACTIVE / NOT_COMPLETE.
Source commits: 261a5ef8, e850c2cd, 311e73b6, 2df0ca57.

NttFirstBody182.source constructs the original scoped first butterfly once,
parametrically in its actual state, pointers and words. It loads both inputs
before either store and preserves the original second expression
modp_sub(modp_add(a0,a1,p),montgomery(a1,w,p,p0i),p). It does not replace this
expression by the different binary butterfly. Source-bound scalar bodies
are reused without imposing a new canonical-range or probabilistic premise.

NttWriteFrame182 and NttFirstBodyFrame182 prove the exact two stores,
restoration of scoped locals and preservation outside the selected word
interval. NttFirstFixed182 transports allocation, writability and actual
byte initialization. NttFirstControl182 constructs the original u increment
and both pointer advances; NttFirstEntry182 constructs their initialization.
NttFirstLoop182.full constructs all 768 iterations by one inductive proof,
ending with u=768 and pointers a+768 and a+1536. Actual reads follow from
initialized bytes; no arbitrary or stale memory values are supplied.

SelectedForwardEntry182.binding constructs the actual first forward-call
argument binding after SelectedGeneratorCall181.after: fs, stride1, gm,
logn10, full1, p and p0i. NttPrologue182.source constructs the original
declarations, false early-return guard and n=1536/hn=768 setup, returning
the existing KeygenNttForwardExec.ready state. NttFirstSetup182 then loads
the actual gm[1] word. SelectedFirstInput182.input discharges every input
condition using the preceding complete generator and preserved sampler image.

SelectedNttFirst182.first_pass and SelectedFirstMetadata182.prefix_source
construct the first pass and the combined original prologue/first-pass prefix
at this selected entry. The precise frame modifies only scratch block31's
byte interval [6776,12920). SelectedFirstFrame182.g_image preserves the full
second converted input, and gm_table preserves the complete canonical gm
table. a_read proves readability of the transformed first input; it does
not claim that this input retains its pre-transform values. logn/full and
the declared m/t cells are available for the next original loops.

The remaining obligation is still an execution of the original intermediate
and triple passes at SelectedNttFirst182.after. continue_forward consumes
that obligation; it does not discharge it. Consequently neither this first
complete forward call nor the second call is claimed by checkpoint182.
The old 16-bit public-transform execution is not substituted for this
32-bit solver-transform execution.

All 19 mathematical modules / 110 named declarations passed full expression
DAG roundtrip and fresh safe kernel checking in audit295, in 19 sequential
processes. Only propext/Classical.choice/Quot.sound were allowed. Accepted
stdout/stderr are empty: 0 errors / 0 warnings. Structural execution and
finite index arithmetic were proved directly in the kernel; no new external
numerical certificate was needed. No C/reference semantics, resource limit
or mathematical condition changed; no warning was suppressed. No independent
review or push occurred.

History288-295 contains eight jobs and three failed or mixed jobs, retained
with their logs and causes. Job289 exposed a Fin-versus-Nat pointer alias
and an unused simp argument. Job290 accepted the write frame, then exposed
string-to-character-list normalization in local-scope restoration. Job291
accepted scope/fixed-state transport, then required the source uint64(1)
integer-to-Nat projection to be exposed before pointer associativity.
All repairs preserved the original statements and source operations.
There were no controlled cancellations or relaxed resource limits.

ENTRY182 verified 64932 inherited paths; SHA256:
1b48b13300ac0d713d954e5a0a193919e7d6d427308a2cffd54d6f8276e3b504.
Audit collection SHA256:
b7a9b05b03ac62648ff18b2ce90f95e496aae92b1cafdfb1e736fe806e0218ab.
Receipt: KEYGEN_NTT_FIRST_182.json.
Postseal: .build/nttfirst182/POSTSEAL_182.json.

| Owner point | Current status | Exact boundary |
| --- | --- | --- |
| Full source seed witness and positive mass | PARTIAL | The actual first modular NTT entry, prologue and all 768 first-pass butterflies are constructed. Middle/triple passes and the remaining solver/encoding path stay open; no full emitted witness or unconditional Z>0. |
| Numerical first-attempt acceptance bound | OPEN | No numerical p_accept bound, including 1/4, is established by this checkpoint. |
| Conditional coding and quantitative p_K | OPEN | Source coding success and a concrete positive p_K remain unproved. |

The emitted-witness target remains corrected KeygenProbability134; old110
stays frozen. Existing package_of_witness and success_lower_of_witness
remain conditional on the complete source witness. No IID/D1/F04 or
empirical premise was introduced. The paper retains measured8192/23628
and the separate256/739 control; exactly five do_sign obligations remain
unchanged: key/certificate transport; AttemptShape/ReplyShapeAt;
PointwiseStageRoad's four conditions; rounding/int16/syndrome; sampler loop
and honest-signing PRG hybrid.

The selected original prologue and all 768 first-pass butterflies are now constructed and kernel checked.
Their precise memory frame preserves the second input and canonical table needed by the following source execution.
The complete emitted KeyGen witness and all requested positive probability bounds remain open.
