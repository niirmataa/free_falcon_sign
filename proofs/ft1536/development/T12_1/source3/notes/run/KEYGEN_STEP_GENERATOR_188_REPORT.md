# First prime setup and actual full0 generator scalar prefix188

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
First prime setup and full0 generator binding/scalar prefix: COMPLETE.
Generator table suffix, complete step calls and root/encoding: OPEN.
Whole owner goal ACTIVE / NOT_COMPLETE.
Source commits: 41b6d008, 78096f17, 66bcb1d7.

MakeFgSpine188 and StepPrimeShape188 expose the ORIGINAL first prime-loop
syntax, scoped body, declaration/prime prefix, generator arguments/branch
and continuation. SelectedStepPrime188.initial_source executes u=0 and
guard proves u<slen at the actual slen1 state. StepPrimeDeclarations188
constructs the original p/p0i/R2, v and x declarations. p_bytes/p_read derives
p from the source prime object at primes[u], then p_source/i_source/r_source
executes the actual prime assignment, modp_ninv31 and modp_R2 bodies.
prefix_source is an executed contiguous prefix of the original scoped
iteration; continue_inner retains the remaining body explicitly.

StepGeneratorEntry188.generator_read obtains primes[u].g from the same
current heap. binding constructs the actual modp_mkgm3 arguments at the NEW
gm/igm buffers, with logn9/full0. REV10, scratch allocation and writability
are transported from the existing source state. The old completed
logn10/full1 invocation is not substituted for this call.

StepGeneratorScalar188 executes the original declarations/R/R2/g conversion
and initializes k from the actual logn9. StepGeneratorCube188 executes the
ACTIVE !full branch: g=mont(g,mont(g,g)), then k9→10. StepGeneratorSquare188
executes the original state-exact while(k++<11): the true guard advances
k10→11 BEFORE the square, and the final false guard advances k11→12.
Both the changed full0 g word and the final counter are constructed from
source operations, not asserted as endpoint conditions.

StepGeneratorInverseCall188 executes igAssign using the existing complete
31-round modp_div source proof on the new g word. StepGeneratorPrefix188.source
composes the entire actual scalar prefix through ig at the new generator
entry. Its heap theorem follows from the executed pure source fragment.
StepGeneratorReady188 exposes k12, new g/ig, R/R2, p/p0i, logn9/full0,
u/w declarations, both table pointers, REV10, allocation/writability and
both moved512-word input-read contracts. No table store has yet been claimed.

StepGeneratorBridge188 makes the remaining dependency explicit: source
execution of rowSelect/kFromLogn/ifFull/squareLoop/topElements and the void
return are still required to construct the actual generator branch. The
caller tail and its local/pointer scope restoration remain represented in
the original grammar. These conditional bridges are not reported as a
closed generator, prime iteration or make_fg_step call.

All 12 mathematical modules / 140 named declarations passed full expression
DAG roundtrip and fresh safe kernel checking in audit336, in 12 sequential
processes. Only propext/Classical.choice/Quot.sound were allowed. Accepted
stdout/stderr are empty: 0 errors / 0 warnings. All new computations are
source/word construction and finite kernel syntax checks; no new external
numerical experiment was needed. Existing scalar proofs were reused without
changing their assumptions or the reference semantics. Resource limits and
C sources are unchanged; no warning was suppressed. No independent review
or push occurred.

History333-336 has 4 accepted jobs and no failed/mixed job or controlled
cancellation in this checkpoint. The empty188 failure ledger records this;
all inherited failures remain pinned, including187's state-comparison limits
and184's explicitly recorded cancellations and their final repair.

ENTRY188 verified 68469 inherited paths; SHA256:
d0b7284c0c8f09ae96b890f8346ccfc89b133392a0059a64ff02e78cb53e3a3b.
Audit collection SHA256: abfb6b67568d5c451af027011789cb7b313251380a52db6efcdfdcb938aa2f04.
Receipt: KEYGEN_STEP_GENERATOR_188.json.
Postseal: .build/stepgen188/POSTSEAL_188.json.

| Owner point | Current status | Exact boundary |
| --- | --- | --- |
| Full source seed witness and positive mass | PARTIAL | The first prime setup and actual full0 generator scalar prefix are executed. Table generation, complete steps and later root/encoding remain open; no complete emitted witness or unconditional Z>0. |
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

The first prime setup and full0 generator scalar prefix now execute in their actual source context.
The changed g word, k12 and preserved heap establish the exact next state for table generation.
The complete emitted KeyGen witness and all requested positive probability bounds remain open.
