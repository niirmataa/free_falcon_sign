# Source-established table reads and actual generator cube rows180

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Whole owner goal ACTIVE / NOT_COMPLETE.
Source commits: 30468d6d, cd91f802, fec81489, f26e5e10.

SelectedGeneratorInitialized180 closes the previously missing read facts
for BOTH upper-half tables. Word32Initialized180 proves that concrete stores
initialize their destination bytes and preserve earlier initialization;
GeneratorRowInitLoop180 carries this through all original last-row stores.
C99ModularArity096.execution_unique identifies that strengthened result with
the exact chosen state from179. The resulting gm/igm reads at512..1023
come from actual writes, not from initial scratch zero fill or a snapshot.
The byte-to-Load32 helper uses the actual initialized bytes; its fallback
byte value is ruled out by the initialization proof.

GeneratorCubeBody180.source constructs the original scoped cube body:
y/z declarations, actual child reads at2*u, the two nested Montgomery cubes
and the two stores at u. GeneratorCubeLoop180.source/full constructs all
256 iterations for u=256,...,511, the original guards and increments, and
the final false guard at u=512. Initialization monotonicity preserves the
upper reads while each iteration initializes its two lower destinations.
This is one parametric body and an inductive loop, not 256 native runs.

SelectedGeneratorCubeSetup180 constructs kFromLogn (k=9) and dec k (k=8)
on the actual state. SelectedGeneratorCube180.source constructs the original
full1 branch, including the empty-scope restoration and full cubeLoop.
The final state is SelectedGeneratorCubeLoop180.after. Its remaining source
obligation is exactly squareLoop::topElements; the full generator is not yet
claimed complete.

SelectedGeneratorCubeTable180.forward_filled consumes this execution in
the existing KeygenMkgm3Assembly.full_rows theorem, proving canonical gm
cells256..1023. Its g_initialized/i_initialized and g_read/i_read export
source-established initialization and reads for BOTH tables on that range.
The actual final counters are u=512 and k=8. SelectedGeneratorCubeFrame180
preserves both complete converted sampler images f/g, every other memory
block and scratch bytes below19064, with sizes/writability unchanged.
The inverse table has proved readable data here; no additional algebraic
inverse-table specification is asserted by this checkpoint.

All 15 mathematical modules / 79 named declarations passed full expression
DAG roundtrip and fresh safe kernel checking in audit280, in 15 sequential
processes. Only propext/Classical.choice/Quot.sound were allowed. Accepted
stdout/stderr are empty: 0 errors / 0 warnings. New arithmetic and source
claims are parametric kernel proofs; no external numerical certificate or
new numerical experiment was required. Existing STATIC permutation, source
bindings and canonical-root lemmas were reused. No C/reference semantics,
resource limit or mathematical condition changed, and no warning was hidden.
No independent review, duplicate worker or push occurred.

Jobs270-280 are retained: 11 jobs, eight failed or mixed jobs.
270 exposed a counter removed by reflexive case substitution;271 used the
reserved name prefix;272 and275 exposed rejected compact inequality token
sequences;273 used decide on a definitional width with a free index;274 needed
local record projections exposed for exact write heaps;276 needed the proved
put_bind transport for the reused increment;278 needed a state-indexed
Pointers structure rebuilt from its unchanged fields. All were local proof
or syntax repairs, with exact causes in the failure ledger. No job in this
checkpoint was manually cancelled or rerun under relaxed limits.

ENTRY180 verified 63963 inherited paths; SHA256:
10628f71cc9368bd3d05d7a829a145ef8a1177f8fb797c02bacd48353f68941a.
Audit collection SHA256:
a612376e3ca6066220c6ddb9461b5f058b2fa6cbc97658625965cd9c82206413.
Receipt: KEYGEN_GENERATOR_CUBE_180.json.
Postseal: .build/gencube180/POSTSEAL_180.json.

| Owner point | Current status | Exact boundary |
| --- | --- | --- |
| Full source seed witness and positive mass | PARTIAL | Both table read inputs and the actual generator cube phase are closed; square/top-elements and the remaining root/encoding source path stay open. No full emitted witness or unconditional Z>0. |
| Numerical first-attempt acceptance bound | OPEN | No numerical p_accept bound, including1/4, is established here. |
| Conditional coding and quantitative p_K | OPEN | Full source coding success and a concrete positive p_K remain unproved. |

After squareLoop and topElements remain the complete generator call, both
original forward NTT calls, R3/top triple products, nine make_fg_step calls,
CRT/Bezout/carry gates, intermediate/depth0/root validation and certificate/
codecs. The emitted-witness target remains corrected KeygenProbability134;
old110 stays frozen. No IID/D1/F04 or empirical premise was used. The paper
retains measured8192/23628 and the distinct256/739 control, and exactly five
do_sign obligations remain unchanged. The full owner goal remains active.

Both table reads and the actual 256-iteration cube phase are now kernel proved.
Canonical gm data and source-established reads now extend down to index256, with the original inputs preserved.
The full emitted witness and all requested positive probability bounds remain open.
