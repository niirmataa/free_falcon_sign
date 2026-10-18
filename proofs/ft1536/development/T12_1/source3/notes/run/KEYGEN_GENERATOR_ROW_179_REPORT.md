# Actual generator last-row execution179

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Whole owner goal ACTIVE / NOT_COMPLETE.
Source commits: d2076b75, 0e869601, 933d21bb, 60e7dac7.

GeneratorRowPrelude179.source constructs the original elseRow declarations
and scalar initialization: x/ix, g2/g4/ig2/ig4, k=1 and b=512. Its hypotheses
are instantiated from the actual generator state after checkpoint178.
GeneratorRowIndex179 and GeneratorRowStore179 construct the original REV10
reads and uint32 stores from source table bytes, allocation and writability.
GeneratorRowBody179.source proves the complete eight-statement iteration,
with four stores and four actual Montgomery scalar updates.

GeneratorRowLoop179.source/full constructs all 256 original iterations,
with u=0,2,...,510 and final u=512. It is one parametric body proof and an
inductive counted-loop proof, not 256 independent native executions.
SelectedGeneratorRow179.source supplies the actual rowSelect execution,
including the false logn==1 branch and exact elseRow scope restoration.
The final state is SelectedGeneratorRow179.after. The remaining generator
instructions are explicitly [kFromLogn,ifFull,squareLoop]++topElements.

SelectedGeneratorRowTable179.ready consumes the previously proved initial
prefix in KeygenMkgm3Prelude.initial_result. Its forward_filled theorem then
uses the newly constructed rowSelect execution in the existing
KeygenMkgm3RowInit.selected_row theorem. This closes the canonical contents
of gm[512..1023], as well as u=512 and k=1, without assuming the table result.
The source writes to igm are constructed too; a separate exported theorem
covering upper-half igm initialization remains to be supplied before the
next cube-loop proof. No algebraic inverse-table claim is asserted here.

SelectedGeneratorRowFrame179.f_image/g_image proves that both complete
converted sampler arrays at fs/gs survive these writes unchanged.
Its bytes theorem preserves every block other than31 and block31 offsets
below19064. Sizes and writability are preserved by the actual memory steps.
This is a scoped byte-frame export; it is not a whole-heap identity.
The next phase must derive its inverse-table read facts from actual stores,
without replacing them by an assumption about initial scratch contents.

All 14 mathematical modules / 112 named declarations passed full expression
DAG roundtrip and fresh safe kernel checking in audit269, in 14 sequential
processes. The only allowed axioms were propext/Classical.choice/Quot.sound.
Accepted stdout/stderr are empty: 0 errors / 0 warnings. The prelude-facts
module writes compilation-progress markers only; these IO commands are
not proof premises and are not mathematical declarations. No new numerical
experiment was needed: source/word/index claims are kernel proofs, and the
existing checked STATIC permutation and root facts are reused.

Jobs258-269 are retained, with six failed or mixed jobs:
-259: an already reduced index alias and dependent elimination of a Load16
  indexed by a concrete expression; fixed by a generic allocation lemma.
-263,264,265: controlled cancellations after124.971s,66.516s,45.211s while
  isolating costly auxiliary state conversions. Markers identified ig2_cell,
  then k_cell; explicit shallow/outside-cell transports replaced those
  conversions with the same exact statements. The final facts module passed.
-266: DisjointBytes needed unfolding before decide; no separation changed.
-267: the frame proof needed the empty-list membership disjunct reduced;
  the unused simp rule was removed with warning-as-error still enabled.
No source C, reference semantics, resource limit or mathematical condition
was weakened. No independent review, duplicate worker or push occurred.

ENTRY179 verified 63347 inherited paths; SHA256:
6c2039f81e94c5eb9813b568e6b8041a0f0707c29cdfdfdae9b3c1708c1c0fb0.
Audit collection SHA256:
f1abe4ad691747ff3f88db69a7e68c607cade23ed41a2d992402de8163b5f90c.
Receipt: KEYGEN_GENERATOR_ROW_179.json.
Postseal: .build/genrow179/POSTSEAL_179.json.

| Owner point | Current status | Exact boundary |
| --- | --- | --- |
| Full source seed witness and positive mass | PARTIAL | The actual generator last row is complete, with canonical upper-half gm and unchanged f/g; remaining generator/root/encoding source execution is still open. No full emitted witness or unconditional Z>0. |
| Numerical first-attempt acceptance bound | OPEN | No numerical p_accept bound, including1/4, follows from this stage. |
| Conditional coding and quantitative p_K | OPEN | Full encoding success and a concrete positive p_K remain unproved. |

After the generator's cube/square/top-elements remain both forward NTTs,
the top triple products, nine make_fg_step calls, CRT/Bezout/carry tests,
intermediate/depth0/root validation and certificate/codecs. The emitted
witness target remains corrected KeygenProbability134; old110 stays frozen.
No IID, D1, F04 or empirical premise is introduced. Measured8192/23628 and
the distinct256/739 control remain measurement material, and exactly five
do_sign obligations remain unchanged. The full owner goal stays active.

The actual last-row branch and all its iterations are now kernel proved.
The canonical gm result now follows from that execution, while the full emitted witness remains open.
The next proof constructs the upper rows using source-established reads of both tables.
