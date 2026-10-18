# First actual make_fg_step entry and memory prefix187

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Selected first lower-step binding and preparation prefix: COMPLETE.
Actual first step call, nine complete steps and root/encoding: OPEN.
Whole owner goal ACTIVE / NOT_COMPLETE.
Source commits: 4958da28, 2f919cb0, e78d3839.

FirstStepEntry187 binds the original parent loop syntax and executes d=1.
The declared d cell is derived from the preserved make_fg caller frame.
The first guard, logn-d and (d+1)<depth || out_ntt expressions execute with
the actual restored logn10/depth10/out_ntt0 cells. binding constructs the
real data/logn9/depth1/ter1/in_ntt1/out_ntt1 argument frame. source_step remains
explicitly conditional on the ENTIRE step-body execution and void return;
this checkpoint does not claim the first step call has completed.

StepDeclarations187 executes the original n/hn/u, slen/tlen and pointer
and prime declarations. StepPrefixProgram187 binds the original preparation
region to explicit executable syntax. SelectedStepSizes187 constructs the
actual shifts n=1<<9=512 and hn=n>>1=256. StepStaticInputs187 derives actual
64-bit reads of the source small3 length table at indices1/2, preserves the
readonly prime and REV10 objects through prior execution, and carries them
into the new entry. Existing source-parsed STATIC facts are reused; the
lengths are not inferred from a desired buffer shape or empirical data.

SelectedStepLengths187 executes slen/tlen loads and the ter1 prime-selection
branch, yielding slen1/tlen2 and PRIMES3. The exact source arithmetic then
sets all seven pointers: fd670, gd1182, fs1694, gs2206, gm2718, igm3230,
t1 index3742, each within the established block31 uint32 scratch object.
SelectedStepLayout187.pointers is their original ordered execution. The
new full0/512-word layout is not the previous full1/1536-word layout.

SelectedStepMove187.source executes the original4096-byte memmove from
byte2680 to6776, with actual initialized source bytes derived from the two
completed top outputs. word_transfer preserves each established source
word; f_read/g_read establish both moved512-word inputs. The exact changed
interval is [6776,10872). Extent, size bound and writability are derived from
the original source-established scratch allocation, not newly assumed.

SelectedStepPrefix187.part_source closes the original part .step1;
continue_step composes it with the executed declarations and exposes exactly
parts2/3/4 as the remaining source obligation. SelectedStepReady187 preserves
the static reads and table objects and exposes all actual scalar/flag cells
needed for the first prime iteration. No full0 generator, inverse call,
first-prime loop, CRT or remaining-prime loop is claimed complete here.

All 12 mathematical modules / 159 named declarations passed full expression
DAG roundtrip and fresh safe kernel checking in audit332, in 12 sequential
processes. Only propext/Classical.choice/Quot.sound were allowed. Accepted
stdout/stderr are empty: 0 errors / 0 warnings. New claims are source
construction and direct kernel verification of finite words/layouts; no new
external numerical experiment was needed. C/reference semantics and
resource limits are unchanged; no warning was suppressed. No independent
review or push occurred.

History328-332 contains 5 jobs and 2 failed/mixed attempts329/330. Actual static
reads and size assignments accepted in329, but concrete empty-scope and
heap comparisons reached the existing 2,000,000-heartbeat limit. A generic
empty-scope identity and shallow heap projection resolved those issues.
Job330 accepted that repair, then reached the same limit when transporting
a concrete tlen cell through a pointer-only state update. Direct proofs of
the already-executed scalar cells resolved it;331 accepted all four remaining
modules in 2.6-3.9 seconds each. Exact logs and causes remain preserved.
There were no controlled cancellations or relaxed resource limits.

ENTRY187 verified 67797 inherited paths; SHA256:
30d8260ce5399396a18b9bb362c40e5b66ea8cbcea50dc94351c13d3747e5b44.
Audit collection SHA256: d22052508a411f5e7318acd355bdbbb48d168bcbf19d58f556605aefb2d14bae.
Receipt: KEYGEN_STEP_ENTRY_187.json.
Postseal: .build/stepentry187/POSTSEAL_187.json.

| Owner point | Current status | Exact boundary |
| --- | --- | --- |
| Full source seed witness and positive mass | PARTIAL | The first lower step has its actual binding, declarations, source lengths/layout and input memmove. Its remaining body, nine full steps and later root/encoding remain open; no complete emitted witness or unconditional Z>0. |
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

The first lower make_fg_step now has its actual source argument binding and complete preparation prefix.
Its moved inputs and preserved static objects establish the exact starting state for the remaining prime loops.
The complete emitted KeyGen witness and all requested positive probability bounds remain open.
