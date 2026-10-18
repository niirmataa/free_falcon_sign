# Selected source modular NTT middle passes183

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Selected first forward invocation: prologue, first and middle passes COMPLETE;
final triple pass OPEN. Whole owner goal ACTIVE / NOT_COMPLETE.
Source commits: 8d40fe2f, ad126b3a, 7b0eb029, 0f728e39.

NttBinaryBody183.source constructs the original scoped middle butterfly
parametrically: declare x/y, read both pointers, replace y by the source
Montgomery product with the actual s cell, then store add(x,y) and sub(x,y).
NttBinaryFrame183 proves exact local restoration, unchanged pointer cells,
monotone initialization and the precise1536-word write frame. No word value,
canonical-range condition or twiddle is assumed independently of source reads.

NttVControl183 and NttVLoop183.full construct the original v initialization,
every inner butterfly and both pointer advances, and the final false guard.
The loop is parametric in its block origin l and half-width h, with derived
bounds l+2*h<=1536. NttMiddleAddress183 proves the actual stride multiplication
and m+u1 table address. NttMiddleTable183 transports actual table reads through
the precise frame; table/array separation is later discharged for the selected
layout, not left as a premise of the selected execution.

NttU1Setup183 constructs the scoped v/s declarations, actual gm[m+u1] read
and both pointer bindings in source order. NttU1Body183 embeds the complete
v loop and restores the scoped cells. NttU1Control183 and NttU1Loop183.full
construct every twiddle block and the actual u1++/v1+=t updates. The invariant
m*t=1536 and t=2*h derives every array bound; m<=512 derives every table bound.
Neither pointer validity nor readable data is supplied by a native trace.

NttMBody183.source constructs the original ht/u1/v1 scope, ht=t>>1,
complete block loop, and t=ht assignment. NttMControl183 constructs the
mixed-width full-dependent guard and m<<=1 update, preserving the actual
uint32 right operand and C unsigned promotion. NttSchedule183.selected is
a closed kernel certificate of the exact eight counter transitions:
(m,t)=(2,768),(4,384),(8,192),(16,96),(32,48),(64,24),(128,12),
(256,6),(512,3). NttMLoop183.full builds the complete original intermediatePass,
including both initial assignments, all eight rounds and final false guard.
The schedule contains only proved finite arithmetic facts and is not an
assumed execution, data certificate or probabilistic premise.

SelectedNttMiddle183.exists_execution/source discharges the generic input
conditions at SelectedNttFirst182.after. The end cells are m512/t3.
SelectedMiddleFrame183.g_image/gm_table preserve the complete second input
and canonical gm; a_read proves the transformed first input remains readable.
combined_frame reaches the original call entry and changes only scratch
block31 bytes [6776,12920). SelectedMiddleMetadata183 preserves logn10/full1,
u768 and the declared r cell; prefix_source constructs the combined original
prologue, first pass and all intermediate passes.

SelectedNttMiddle183.continue_forward still requires the original triplePass
execution. Thus the complete first forward call, second forward call and
later solver/encoding path are not claimed. The next source obligation has
512 triple butterflies and is recorded exactly in NEXT_ROUTE. Existing
public16-bit transform results were not substituted for these32-bit steps.

All17 mathematical modules /108 named declarations passed full expression
DAG roundtrip and fresh safe kernel checking in audit307, in17 sequential
processes. Only propext/Classical.choice/Quot.sound were allowed. Accepted
stdout/stderr are empty:0 errors /0 warnings. Source construction and finite
counter facts were proved directly in Lean; no new external numerical
certificate was needed. No C/reference semantics, resource limit or
mathematical condition changed; no warnings were suppressed. No independent
review or push occurred.

History296-307 has12 jobs and9 failed or mixed attempts297-305. They exposed
explicit expression/word aliases, symbolic h<h guard normalization,
zero-offset and pointer-state associativity, one multiline term grouping,
a mixed-width comparison cast, reserved local name to, and a missing
noncomputable annotation for an existing chosen state. Exact causes and
logs are retained. Accepted modules from mixed jobs were reused unchanged.
There were no controlled cancellations or relaxed limits in this checkpoint.

ENTRY183 verified65570 inherited paths; SHA256:
3b46f2fe6b355095be2942fba7b380497434eaed3f0e701b5ba114a3e21806ee.
Audit collection SHA256: 8c0f207243d69782abf5045eaf98a4f4cdf2d3b18e6e1ea3a428339d9c757b0c.
Receipt: KEYGEN_NTT_MIDDLE_183.json.
Postseal: .build/nttmiddle183/POSTSEAL_183.json.

| Owner point | Current status | Exact boundary |
| --- | --- | --- |
| Full source seed witness and positive mass | PARTIAL | The actual first modular NTT now includes all middle rounds. Triple pass, second call and remaining solver/encoding path stay open; no full emitted witness or unconditional Z>0. |
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

All eight original selected modular NTT middle rounds are now constructed and kernel checked.
Their precise memory frame preserves the second input and canonical table for the final triple pass.
The complete emitted KeyGen witness and all requested positive probability bounds remain open.
