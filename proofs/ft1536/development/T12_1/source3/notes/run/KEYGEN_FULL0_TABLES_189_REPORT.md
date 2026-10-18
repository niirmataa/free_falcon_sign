# Actual full0 generator tables and call189

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Actual first-step logn9/full0 generator body and call: COMPLETE.
Complete first make_fg_step, later solver and encoding: OPEN.
Whole owner goal PAUSED_AT_OWNER_REQUEST_AFTER_CHECKPOINT / NOT_COMPLETE.
Owner decision2026-10-18: close this checkpoint, then take a break before190.
Source commits: 62488273, 02dfb243, fa96267e. No push.

Gen0RowPrelude189 and Gen0RowPreludeFacts189 execute the original row
initialization for actual logn9: x/ix, g2/g4/ig2/ig4, k2 and b256.
Gen0RowIndex189 derives REV10[u<<2] from the pinned source table relation,
proves the unsigned shift/index arithmetic and256<=lastIndex(u)<512.
Gen0RowStore189 and Gen0RowBody189 execute the four stores and four scalar
updates in the original order. Gen0RowLoop189.full constructs128 iterations
u0,2,...254 and the final false guard at256. These source bodies are proved
parametrically once and instantiated through the loop proof.

SelectedGen0Prelude189, SelectedGen0RowFixed189, SelectedGen0RowLoop189 and
SelectedGen0Row189 bind these proofs to StepGeneratorInverseCall188.after,
with the actual full0 g/ig words, source REV10, new table pointers and
scratch heap. The original logn==1 false branch and row scope restoration
are executed. No full1 invocation or canonical table law is substituted.

Gen0RawInitialized189 derives raw initialized spans through1023 from the
already executed top transform and187 memmove frame. These are actual
scratch-byte facts needed by the existing generic square helpers; they do
not assert canonical twiddles beyond511 or add source reads/stores.
SelectedGen0Control189 executes k=logn-1 to8, the false full guard and derives
all actual GeneratorCubeFixed180.Fixed and initialization conditions.
SelectedGen0Square189 executes the original255 square-loop iterations and
final false guard, reusing GeneratorSquareLoop181.full without new premises.
SelectedGen0Top189.source executes the original top elements; body_source
composes the ENTIRE original KeygenMkgm3Program.code at the actual188 entry.

SelectedGen0Call189.source constructs the actual KeygenLevelCalls.Call
.generate and returns the executed heap to the original caller. instruction
and branch_source close the source instruction and ternary branch.
continue_inner leaves exactly StepPrimeShape188.tail at
SelectedGen0Call189.after as the explicit next obligation. It does not claim
that the first prime iteration or make_fg_step is complete.

SelectedGen0Frame189 derives heap-size/writability stability, caller
locals/arrays preservation, both512-word moved-input read contracts and
both actual512-word gm/igm read contracts. Its bytes theorem proves the
whole-call frame for other blocks and offsets<10872; a unified upper byte
frame ending14968 is NOT claimed. SelectedGen0Ready189 exposes the actual
caller p/p0i/R2,u0,v/x declarations,n512,hn256,slen1,tlen2,logn9,ter1,
in_ntt1,out_ntt1 and pointer bindings. A canonical algebraic full0 table
law is still separate from the proved execution/readability facts.

All19 mathematical modules /163 named declarations passed full expression
DAG roundtrip and fresh safe kernel checking in audit342, in19 sequential
processes. Only propext/Classical.choice/Quot.sound were allowed. Accepted
stdout/stderr are empty:0 errors /0 warnings. All calculations here are
structural source execution and finite kernel arithmetic; no new external
numerical experiment was needed. C/reference semantics and resource limits
are unchanged. No warning suppression, unfinished proof, new mathematical
premise or independent-review claim was introduced.

Jobs337-342 are retained. Four failed/mixed jobs have explicit causes:
337 needed a literal-width exposure for decide with a free-index type;
338 needed explicit heap-size transport through an alias;339 had an unused
binder;340 omitted an import of the already proved188 caller bridge.
The accepted prefixes of those jobs were preserved and reused.341 and342
accepted completely; no controlled cancellation occurred in189.

ENTRY189 verified69068 inherited paths; SHA256:
de260071c3e588d5a4ac02a2199b40b7892e8f9d5d5a9f467ade6843fa0e788d.
Audit collection SHA256:
2f68041a645bbc1addcf48827e58b3968aded00c8d5501372dc7b894870f000d.
Receipt: KEYGEN_FULL0_TABLES_189.json.
Postseal: .build/full0tables189/POSTSEAL_189.json.
Exact receipt/postseal pins and the final closure count are recorded in
KEYGEN_FULL0_TABLES_189_PINS.md; the next obligation and resume procedure
are in KEYGEN_FULL0_TABLES_189_NEXT_ROUTE.md. Historical artifacts remain
unchanged. Pause the app goal after the closing local metadata commit.

| Owner point | Current status | Exact result or missing bound |
| --- | --- | --- |
| Full source seed witness and positive mass | PARTIAL | Actual full0 generator body/call completed. No complete emitted witness yet; KeygenSuccessMass134.success_lower_of_witness still requires that witness before Z>=2^-256>0 can be instantiated. |
| Numerical first-attempt acceptance bound | OPEN | No proved numerical p_accept bound, including1/4. Own KeyGen law and acceptance analysis remain required. |
| Conditional coding and quantitative p_K | OPEN | No proved conditional coding lower bound or concrete positive p_K; full source completion and the first-attempt inclusion must still be combined. |

The emitted-witness target remains corrected KeygenProbability134, with
KeygenModelUnlock134.package_of_witness as the other witness consumer.
Old110 stays frozen with its recorded dispatch defect. No unconditional
Z>0 follows from this checkpoint. No IID/D1/F04/empirical premise is used.
Paper wording remains measured8192/23628 with separate256/739 control.
Exactly five do_sign items remain: key/certificate transport;
AttemptShape/ReplyShapeAt; PointwiseStageRoad's four conditions;
rounding/int16/syndrome; sampler loop and honest-signing PRG hybrid.

The actual full0 generator call now executes completely and preserves the two inputs required by the next source loop.
The remaining first-prime tail, later solver and encoding still prevent a complete emitted witness and unconditional positive probability bounds.
Checkpoint189 is a recoverable local pause requested by the owner, while the paper's measured claims and the five do_sign items remain unchanged.
